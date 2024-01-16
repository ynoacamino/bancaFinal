#!F:/Perl/perl/bin/perl.exe

use strict;
use warnings;
use CGI;
use CGI::Session;
use CGI::Cookie;
use DBI;

my $cgi = CGI->new;
$cgi->charset("UTF-8");
my $u = "clients_query";
my $p = "EEDcFTy180We(KX7";
my $dsn = "dbi:mysql:database=banca;host=127.0.0.1";
my $dbh = DBI->connect($dsn, $u, $p);

my $dni = $cgi->param("dni");
my $names = $cgi->param("names");
my $plastname = $cgi->param("plastname");
my $mlastname = $cgi->param("mlastname");
my $bdate = $cgi->param("bdate");

sub checkDNI {
    my $dni = $_[0];
    if (!$dni) {
        return "Ingrese un DNI";
    }
    if ($dni !~ /^\d{8}$/) {
        return "DNI no valido";
    }
    return "Correcto";
}

sub checkNames {
    my $names = $_[0];
    if (!$names) {
        return "Ingrese un nombre";
    }
    if (length($names) > 40) {
        return "Nombre muy largo";
    }
    if ($names !~ /^\w{1,40}$/) {
        return "Nombre no valido";
    }
    return "Correcto";
}

sub checkPlastname {
    my $plastname = $_[0];
    if (!$plastname) {
        return "Ingrese un apellido paterno";
    }
    if (length($plastname) > 30) {
        return "Apellido paterno muy largo";
    }
    if ($plastname !~ /^\w{1,30}$/) {
        return "Apellido paterno no valido";
    }
    return "Correcto";
}

sub checkMlastname {
    my $mlastname = $_[0];
    if (!$mlastname) {
        return "Ingrese un apellido materno";
    }
    if (length($mlastname) > 30) {
        return "Apellido materno muy largo";
    }
    if ($mlastname !~ /^\w{1,30}$/) {
        return "Apellido materno no valido";
    }
    return "Correcto";
}

sub checkBdate {
    my $bdate = $_[0];
    if (!$bdate) {
        return "Ingrese una fecha de nacimiento";
    }
    if ($bdate !~ /^\d{4}\-\d{2}\-\d{2}$/) {
        return "Fecha de nacimiento no valida";
    }
    return "Correcto";
}

my $dni_status = checkDNI($dni);
my $names_status = checkNames($names);
my $plastname_status = checkPlastname($plastname);
my $mlastname_status = checkMlastname($mlastname);
my $bdate_status = checkBdate($bdate);

if ($dni_status eq "Correcto" && $names_status eq "Correcto" && $plastname_status eq "Correcto" && $mlastname_status eq "Correcto" && $bdate_status eq "Correcto") {
    my $sth = $dbh->prepare("INSERT INTO clientes (dni, nombres, paterno, materno, nacimiento) VALUES (?, ?, ?, ?, ?)");
    $sth->execute($dni, $names, $plastname, $mlastname, $bdate);
    print $cgi->header("text/html");
    print "correct";
} else {
    print $cgi->header("text/xml");
    print<<BLOCK;
    <response>
        <elem_status>
            <element>dni</element>
            <status>$dni_status</status>
        </elem_status>
        <elem_status>
            <element>names</element>
            <status>$names_status</status>
        </elem_status>
        <elem_status>
            <element>plastname</element>
            <status>$plastname_status</status>
        </elem_status>
        <elem_status>
            <element>mlastname</element>
            <status>$mlastname_status</status>
        </elem_status>
        <elem_status>
            <element>bdate</element>
            <status>$bdate_status</status>
        </elem_status>
    </response>
BLOCK
}