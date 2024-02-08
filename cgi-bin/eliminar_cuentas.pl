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

my $u = "query";
my $p = "YR4AFJUC3nyRmasY";
my $dsn = "dbi:mysql:database=bancafinal;host=127.0.0.1";
my $dbh = DBI->connect($dsn, $u, $p);

our $client_id;
my $dni_status = check_DNI($dni);

if (!$dni_status) {
    remove_account($client_id);
} else {
    print_errors();
}

sub remove_account {
    my $client_id = shift;
    my $sth = $dbh->prepare("DELETE FROM cuentas WHERE cliente_id = '$client_id'");
    $sth->execute;

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
    my $sth = $dbh->prepare("SELECT `id` FROM clientes WHERE dni = ?");
    $sth->execute($dni);
    my @row = $sth->fetchrow_array;
    if (!@row) {
        return "Cliente no existente.";
    }
    $client_id = $row[0];
    return undef;
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
