#!F:/Perl/perl/bin/perl.exe

use strict;
use warnings;
use CGI;
use CGI::Session;
use CGI::Cookie;
use DBI;

my $cgi = CGI->new;
$cgi->charset("UTF-8");
my $u = "status_query";
my $p = "XNsjsdcSfc9.YJ_j";
my $dsn = "dbi:mysql:database=banca;host=127.0.0.1";
my $dbh = DBI->connect($dsn, $u, $p);

my %cookies = CGI::Cookie->fetch();
my $session_cookie = $cookies{"client_session_id"};
our $card_id;
our $account_id;
if ($session_cookie) {
    my $session_id = $session_cookie->value();
    my $session = CGI::Session->load($session_id);
    $card_id = $session->param("card_id");
    $account_id = $session->param("account_id");
}

my $sth = $dbh->prepare("SELECT * FROM cuentas WHERE id=?");
$sth->execute($account_id);
my @account = $sth->fetchrow_array;
my $currency = $account[4] eq "s" ? "S/." : "\$";

$sth = $dbh->prepare("SELECT * FROM movimientos WHERE tarjeta_id=? AND cuenta_id=?");
$sth->execute($card_id, $account_id);

my $total = 0;
print $cgi->header("text/xml");
print "<response>\n";
while (my @row = $sth->fetchrow_array) {
    $total = $total + ($row[3] * $row[4]);
    my $type = $row[4] == 1 ? "DEPOSITO" : "RETIRO";
    my $amount = $currency.$row[3];
    print<<BLOCK;
    <movement>
        <amount>$amount</amount>
        <type>$type</type>
        <date>$row[5]</date>
    </movement>
BLOCK
}
my $balance = $currency.$total;
print<<BLOCK;
    <balance>$balance</balance>
</response>
BLOCK
