#!perl/bin/perl.exe

# Recibe: nada
# Retorna: 
# <cards> 
#     <card>
#         <id>id</id>
#         <card_number>numero de tarjeta</card_number>
#         <code>codigo</code>
#         <expire_date>fecha de expiracion</expire_date>
#         <currency>moneda</currency>
#     </card>
#     <card>
#         ...
#     </card>
# </cards>

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
    my $account_id = $session->param("account_id");

    my $u = "query";
    my $p = "YR4AFJUC3nyRmasY";
    my $dsn = "dbi:mysql:database=bancafinal;host=127.0.0.1";
    my $dbh = DBI->connect($dsn, $u, $p);

    my $sth = $dbh->prepare("SELECT `id`, `numero`, `clave`, `vencimiento`, `moneda`
                            FROM tarjetas
                            WHERE cuenta_id = '$account_id'");
    $sth->execute;

    while (my @row = $sth->fetchrow_array) {
        my $id = $row[0];
        my $card_number = $row[1];
        my $code = $row[2];
        my $expire_date = $row[3];
        my $currency = $row[4] eq "s" ? "SOLES" : "DÓLARES";
        
        print $cgi->header("text/xml");
        print "<errors>\n";
        print_card($id, $card_number, $code, $expire_date, $currency);
        print "</errors>\n";
    }
}

sub print_card {
    print<<XML;
        <card>
            <id>$_[0]</id>
            <card_number>$_[1]</card_number>
            <code>$_[2]</code>
            <expire_date>$_[3]</expire_date>
            <currency>$_[4]</currency>
        </card>
XML
}

