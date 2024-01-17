#!perl/bin/perl.exe

# Recibe: nada
# Retorna: 
# <status> 
#     <movement>
#         <amount>cantidad</amount>
#         <type>tipo</type>
#         <date>fecha</date>
#     </movement>
#     <movement>
#         ...
#     </movement>
#     <balance>saldo</balance> 
# </status>

use strict;
use warnings;
use CGI;
use CGI::Session;
use CGI::Cookie;
use DBI;

my $cgi = CGI->new;
$cgi->charset("UTF-8");

my %cookies = CGI::Cookie->fetch();
my $session_cookie = $cookies{"session_id_cliente"};

if ($session_cookie) {
    my $session_id = $session_cookie->value();
    my $session = CGI::Session->load($session_id);
    my $card_id = $session->param("card_id");

    my $u = "query";
    my $p = "YR4AFJUC3nyRmasY";
    my $dsn = "dbi:mysql:database=bancafinal;host=127.0.0.1";
    my $dbh = DBI->connect($dsn, $u, $p);

    my $sth = $dbh->prepare("SELECT `tarjetas`.`moneda`, `movimientos`.`monto`, `movimientos`.`tipo`, `movimientos`.`fecha`
                            FROM tarjetas, movimientos
                            WHERE tarjetas.id = '$card_id'");
    $sth->execute($account_id);

    my @row = $sth->fetchrow_array;
    my $currency = $row[0] eq "s" ? "S/." : "\$";
    my $total = $row[1] * $row[2];
    print $cgi->header("text/xml");
    print "<status>\n";
    while (@row = $sth->fetchrow_array) {
        $total = $total + ($row[1] * $row[2]);
        my $amount = $currency.$row[1];
        my $type = $row[2] == 1 ? "DEPOSITO" : "RETIRO";
        my $date = $row[3];
        print<<BLOCK;
        <movement>
            <amount>$amount</amount>
            <type>$type</type>
            <date>$date</date>
        </movement>
BLOCK
    }
    my $balance = $currency.$total;
    print<<BLOCK;
        <balance>$balance</balance>
    </status>
BLOCK
}

