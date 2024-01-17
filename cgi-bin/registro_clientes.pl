#!perl/bin/perl.exe

# Recibe: dni, name, plastname, mlastname, bdate
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
# o nada si todo esta bien :>

use strict;
use warnings;
use CGI;
use CGI::Session;
use CGI::Cookie;
use DBI;

my $cgi = CGI->new;
$cgi->charset("UTF-8");
my $dni = $cgi->param("dni");
my $name = $cgi->param("name");
my $plastname = $cgi->param("plastname");
my $mlastname = $cgi->param("mlastname");
my $bdate = $cgi->param("bdate");

my $dni_status = check_DNI($dni);
my $name_status = check_name($name);
my $plastname_status = check_plastname($plastname);
my $mlastname_status = check_mlastname($mlastname);
my $bdate_status = check_bdate($bdate);

register();

sub register {
    if (!$dni_status && !$name_status && !$plastname_status && !$mlastname_status && !bdate_status) {
        my $u = "query";
        my $p = "YR4AFJUC3nyRmasY";
        my $dsn = "dbi:mysql:database=bancafinal;host=127.0.0.1";
        my $dbh = DBI->connect($dsn, $u, $p);

        my $sth = $dbh->prepare("INSERT INTO clientes (dni, nombres, paterno, materno, nacimiento) VALUES ($dni, $name, $plastname, $mlastname, $bdate)");
        $sth->execute();
        print $cgi->header("text/xml");

        return;
    }

    print_errors();
}

sub check_DNI {
    my $dni = $_[0];
    if (!$dni) {
        return "Ingrese un DNI.";
    }
    if ($dni !~ /^\d{8}$/) {
        return "DNI no valido.";
    }
}

sub check_name {
    my $name = $_[0];
    if (!$name) {
        return "Ingrese un nombre.";
    }
    if (length($name) > 40) {
        return "Nombre muy largo.";
    }
    if ($name !~ /^\w{1,40}$/) {
        return "Nombre no valido.";
    }
}

sub check_plastname {
    my $plastname = $_[0];
    my $length = length($plastname);
    if (!$plastname) {
        return "Ingrese un apellido paterno.";
    }
    if ($length > 30) {
        return "Apellido paterno muy largo.";
    }
    if ($plastname !~ /^\w{1,30}$/) {
        return "Apellido paterno no valido.";
    }
}

sub check_mlastname {
    my $mlastname = $_[0];
    my $length = length($mlastname);
    if (!$mlastname) {
        return "Ingrese un apellido materno.";
    }
    if ($length > 30) {
        return "Apellido materno muy largo.";
    }
    if ($mlastname !~ /^\w{1,30}$/) {
        return "Apellido materno no valido.";
    }
}

sub check_bdate {
    my $bdate = $_[0];
    if (!$bdate) {
        return "Ingrese una fecha de nacimiento.";
    }
    if ($bdate !~ /^\d{4}\-\d{2}\-\d{2}$/) {
        return "Fecha de nacimiento no valida.";
    }
}

sub print_errors {
    print "<errors>\n";
    for my $key (keys %errors) {
        if ($errors{$key}) {
        print<<XML;
    <error>
        <element>$key</element>
        <message>$errors{$key}</message>
    </error>
XML
        }
    }
    print "</errors>\n";
}