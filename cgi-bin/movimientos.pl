#!F:/Perl/perl/bin/perl.exe

use strict;
use warnings;
use CGI;
use CGI::Session;
use CGI::Cookie;
use DBI;

my $cgi = CGI->new;
$cgi->charset("UTF-8");
my $u = "movements_query";
my $p = "4Tfgy*5eEjnv[rjN";
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

my $type = $cgi->param("type");
my $amount = $cgi->param("amount");

sub checkType {
    my $type = $_[0];
    if ($type ne "deposit" && $type ne "withdrawal") {
        return "Tipo no valido"
    }
    return "Correcto";
}

sub checkAmount {
    my $amount = $_[0];
    if (!$amount) {
        return "Ingrese una cantidad";
    }
    if ($amount !~ /^\d+$/ || $amount < 0) {
        return "Cantidad no valida";
    }
    if ($type eq "withdrawal") {
        my $sth = $dbh->prepare("SELECT SUM(monto*tipo) FROM movimientos WHERE tarjeta_id=? AND cuenta_id=?");
        $sth->execute($card_id, $account_id);
        my @sum = $sth->fetchrow_array;
        my $balance = $sum[0] || 0;
        if ($balance - $amount < 0) {
            return "Balance negativo"
        }
    }
    return "Correcto";
}

my $amount_status = checkAmount($amount);
my $type_status = checkType($type);

if ($amount_status eq "Correcto" && $type_status eq "Correcto") {
    my $type_num;
    if ($type eq "deposit") {
        $type_num = 1;
    } else {
        $type_num = -1;
    }

    my $sth = $dbh->prepare("INSERT INTO movimientos (tarjeta_id, cuenta_id, monto, tipo) VALUES (?, ?, ?, ?)");
    $sth->execute($card_id, $account_id, $amount, $type_num);
    print $cgi->header("text/html");
    print "correct";
} else {
    print $cgi->header("text/xml");
    print<<BLOCK;
    <response>
        <elem_status>
            <element>amount</element>
            <status>$amount_status</status>
        </elem_status>
        <elem_status>
            <element>type</element>
            <status>$type_status</status>
        </elem_status>
    </response>
BLOCK
}