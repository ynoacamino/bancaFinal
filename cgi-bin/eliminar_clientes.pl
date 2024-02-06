#!perl/bin/perl.exe

use strict;
use warnings;
use CGI;
use CGI::Session;
use CGI::Cookie;
use DBI;

my $cgi = CGI->new;
$cgi->charset("UTF-8");
my $dni = $cgi->param("dni");

my $dni_status = check_DNI($dni);

if (!$dni_status) {
    remove_client($dni);
} else {
    print_errors();
}

sub remove_client {
    my $dni = shift;
    my $u = "query";
    my $p = "YR4AFJUC3nyRmasY";
    my $dsn = "dbi:mysql:database=bancafinal;host=127.0.0.1";
    my $dbh = DBI->connect($dsn, $u, $p);

    my $sth = $dbh->prepare("DELETE FROM clientes WHERE dni = ?");
    $sth->execute($dni);

    print $cgi->header("text/xml");
}

sub check_DNI {
    my $dni = $_[0];
    if (!$dni) {
        return "Ingrese un DNI.";
    }
    if ($dni !~ /^\d{8}$/) {
        return "DNI no válido.";
    }
}

sub print_errors {
    print $cgi->header("text/xml");
    print "<errors>\n";
    print<<XML;
    <error>
        <element>dni</element>
        <message>$dni_status</message>
    </error>
XML
    print "</errors>\n";
}
