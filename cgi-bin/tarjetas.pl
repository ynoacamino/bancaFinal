#!F:/Perl/perl/bin/perl.exe

use strict;
use warnings;
use CGI;
use CGI::Session;
use CGI::Cookie;
use DBI;
use DateTime;

my $cgi = CGI->new;
$cgi->charset("UTF-8");
my $u = "accounts_query";
my $p = "yK\@tKA]c-.nHnn7Y";
my $dsn = "dbi:mysql:database=banca;host=127.0.0.1";
my $dbh = DBI->connect($dsn, $u, $p);

my $number = $cgi->param("number");
my $password = $cgi->param("password");
my $current_date = DateTime->now;
my $expire_date = $current_date->add(years => 7)->ymd;

sub checkNumber {
    my $number = $_[0];
    if (!$number) {
        return "Ingrese un número de tarjeta";
    }
    if ($number !~ /^\d{16}$/) {
        return "Número de tarjeta no valido";
    }
    my $sth = $dbh->prepare("SELECT * FROM tarjetas WHERE numero=?");
    $sth->execute($number);
    my @card_id = $sth->fetchrow_array;
    if (@card_id) {
        return "Tarjeta ya existente";
    }
    return "Correcto";
}

sub checkPassword {
    my $password = $_[0];
    if (!$password) {
        return "Ingrese una clave";
    }
    if (length($password) > 30) {
        return "Clave muy larga";
    }
    if (length($password) < 8) {
        return "Clave muy corta";
    }
    if ($password !~ /^\w{8,30}$/) {
        return "Clave no valida";
    }
    return "Correcto";
}

my $number_status = checkNumber($number);
my $password_status = checkPassword($password);

if ($number_status eq "Correcto" && $password_status eq "Correcto") {
    my $sth = $dbh->prepare("INSERT INTO tarjetas (numero, clave, vencimiento) VALUES (?, ?, ?)");
    $sth->execute($number, $password, $expire_date);
    print $cgi->header("text/html");
    print "correct";
} else {
    print $cgi->header("text/xml");
    print<<BLOCK;
    <response>
        <elem_status>
            <element>number</element>
            <status>$number_status</status>
        </elem_status>
        <elem_status>
            <element>password</element>
            <status>$password_status</status>
        </elem_status>
    </response>
BLOCK
}