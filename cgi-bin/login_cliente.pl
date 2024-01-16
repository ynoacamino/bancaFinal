#!perl/bin/perl.exe

# Recibe: card_number, password
# Retorna:
# <errors>
#     <error>
#         <element>elemento</element>
#         <message>mensaje</message>
#     </error>
#     <error>
#         ...
#     </error>
# </errors>

use strict;
use warnings;
use CGI;
use CGI::Session;
use CGI::Cookie;
use DBI;

my $cgi = CGI->new;
$cgi->charset("UTF-8");
my $card_number = $cgi->param("card_number");
my $password = $cgi->param("password");
my $session_time = 600;

my $u = "query";
my $p = "YR4AFJUC3nyRmasY";
my $dsn = "dbi:mysql:database=bancafinal;host=127.0.0.1";
my $dbh = DBI->connect($dsn, $u, $p);

my $sth = $dbh->prepare("SELECT * FROM tarjetas WHERE numero=? AND clave=?");
$sth->execute($number, $password);

my @card = $sth->fetchrow_array;
if (@card) {
    $sth = $dbh->prepare("SELECT * FROM cuentas WHERE numero=?");
    $sth->execute($number);
    my @account = $sth->fetchrow_array;
    $sth = $dbh->prepare("SELECT * FROM clientes WHERE id=?");
    $sth->execute($account[6]);
    my @client = $sth->fetchrow_array;
    my $name = $client[2]." ".$client[3]." ".$client[4];

    my $session = CGI::Session->new();
    $session->param("name", $name);
    $session->param("card_id", $card[0]);
    $session->param("account_id", $account[0]);
    $session->expire(time + $session_time);
    $session->flush();

    my $cookie = $cgi->cookie(-name => "session_id_cliente",
                            -value => $session->id(),
                            -expires => time + $session_time,
                            "-max-age" => time + $session_time);
    $cookie->bake();

    print "correct";
} else {
    print($cgi->header("text/html"));
    print "wrong";
}


