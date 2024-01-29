#!perl/bin/perl.exe

# Recibe: card_id
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

my %type_names = (1 => "DEPOSITO", 2 => "RETIRO", 3 => "TRANSFERENCIA ENVIADA", 4 => "TRANSFERENCIA RECIBIDA");

my $cgi = CGI->new;
$cgi->charset("UTF-8");

my %cookies = CGI::Cookie->fetch();
my $session_cookie = $cookies{"session_id_cliente"};

if ($session_cookie) {
    my $session_id = $session_cookie->value();
    my $session = CGI::Session->load($session_id);
    my $card_id = $cgi->param("card_id");

    my $u = "query";
    my $p = "YR4AFJUC3nyRmasY";
    my $dsn = "dbi:mysql:database=bancafinal;host=127.0.0.1";
    my $dbh = DBI->connect($dsn, $u, $p);

    my $sth = $dbh->prepare("SELECT `tarjetas`.`moneda`, `movimientos`.`monto`, `movimientos`.`tipo`, `movimientos`.`fecha`
                            FROM tarjetas, movimientos
                            WHERE tarjetas.id = '$card_id' AND movimientos.tarjeta_id = tarjetas.id");
    $sth->execute;

    my @row = $sth->fetchrow_array;
    my $currency = $row[0] eq "s" ? "S/." : "\$";
    my $amount = $currency.$row[1];
    my $type = $type_names{$row[2]};
    my $date = $row[3];
    my $total = $row[1] * get_mult($row[2]);

    print $cgi->header("text/xml");
    print "<status>\n";
    print_row($amount, $type, $date);
    while (@row = $sth->fetchrow_array) {
        $total = $total + ($row[1] * get_mult($row[2]));
        my $amount = $currency.$row[1];
        my $type = $type_names{$row[2]};
        my $date = $row[3];
        print_row($amount, $type, $date);        
    }
    my $balance = $currency.$total;
    print<<XML;
        <balance>$balance</balance>
    </status>
XML
}

sub get_mult {
    my $mult = 1;
    my $type_code = $_[0];
    if ($type_code == 2 || $type_code == 3) {
        $mult = -1;
    }
    return $mult;
}

sub print_row {
    my $amount = $_[0];
    my $type = $_[1];
    my $date = $_[2];
    print<<XML;
        <movement>
            <amount>$amount</amount>
            <type>$type</type>
            <date>$date</date>
        </movement>
XML
}

