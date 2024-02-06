#!perl/bin/perl.exe

use strict;
use warnings;
use CGI;
use CGI::Session;
use CGI::Cookie;
use DBI;

my $cgi = CGI->new;
$cgi->charset("UTF-8");
my $number = $cgi->param("number");

my $u = "query";
my $p = "YR4AFJUC3nyRmasY";
my $dsn = "dbi:mysql:database=bancafinal;host=127.0.0.1";
my $dbh = DBI->connect($dsn, $u, $p);

my $number_status = check_number($number);

if (!$number_status) {
    remove_card($number);
} else {
    print_errors();
}

sub remove_card {
    my $number = shift;
    my $sth = $dbh->prepare("DELETE FROM tarjetas WHERE numero = ?");
    $sth->execute($number);

    print $cgi->header("text/xml");
}

sub check_number {
    my $number = $_[0];
    if (!$number) {
        return "Ingrese un número de tarjeta.";
    }
    if ($number !~ /^\d{16}$/) {
        return "Número de tarjeta no válido.";
    }
}

sub print_errors {
    print $cgi->header("text/xml");
    print "<errors>\n";
    print<<XML;
    <error>
        <element>number</element>
        <message>$number_status</message>
    </error>
XML
    print "</errors>\n";
}
