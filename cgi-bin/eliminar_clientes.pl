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

    my $sth = $dbh->prepare("SELECT `id` FROM clientes WHERE dni = '$dni'");
    $sth->execute;
    my @row = $sth->fetchrow_array;
    my $id = $row[0];

    $sth = $dbh->prepare("DELETE FROM movimientos, tarjetas WHERE tarjetas.cliente_id = '$id' AND movimientos.tarjeta_id = tarjetas.id");
    $sth->execute;
    $sth = $dbh->prepare("DELETE FROM tarjetas, cuentas WHERE cuentas.cliente_id = '$id' AND tarjetas.cuenta_id = cuentas.id");
    $sth->execute;
    $sth = $dbh->prepare("DELETE FROM cuentas WHERE cliente_id = '$id'");
    $sth->execute;
    $sth = $dbh->prepare("DELETE FROM clientes WHERE id = '$id'");
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
