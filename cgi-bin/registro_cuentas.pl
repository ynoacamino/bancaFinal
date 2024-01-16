#!perl/bin/perl.exe

# Recibe: card_number, dni
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
my $dni = $cgi->param("dni");

my $u = "query";
my $p = "YR4AFJUC3nyRmasY";
my $dsn = "dbi:mysql:database=bancafinal;host=127.0.0.1";
my $dbh = DBI->connect($dsn, $u, $p);

our @card_id;
our @client_id;

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
    @card_id = $sth->fetchrow_array;
    if (!@card_id) {
        return "Tarjeta no existente";
    }
    return "Correcto";
}

sub checkDNI {
    my $dni = $_[0];
    if (!$dni) {
        return "Ingrese un DNI";
    }
    if ($dni !~ /^\d{8}$/) {
        return "DNI no valido";
    }
    my $sth = $dbh->prepare("SELECT * FROM clientes WHERE dni=?");
    $sth->execute($dni);
    @client_id = $sth->fetchrow_array;
    if (!@client_id) {
        return "Cliente no existente";
    }
    return "Correcto";
}

my $card_number_status = checkNumber($card_number);
my $currency_status = checkCurrency($currency);
my $dni_status = checkDNI($dni);

if ($card_number_status eq "Correcto" && $currency_status eq "Correcto" && $dni_status eq "Correcto") {
    my $sth = $dbh->prepare("INSERT INTO cuentas (numero, moneda, tarjeta_id, cliente_id) VALUES (?, ?, ?, ?)");
    $sth->execute($number, $currency, $card_id[0], $client_id[0]);
    print $cgi->header("text/html");
    print "correct";
} else {
    print $cgi->header("text/xml");
    print<<BLOCK;
    <response>
        <elem_status>
            <element>number</element>
            <status>$card_number_status</status>
        </elem_status>
        <elem_status>
            <element>currency</element>
            <status>$currency_status</status>
        </elem_status>
        <elem_status>
            <element>dni</element>
            <status>$dni_status</status>
        </elem_status>
    </response>
BLOCK
}