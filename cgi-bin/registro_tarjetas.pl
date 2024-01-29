#!perl/bin/perl.exe

# Recibe: number, password, currency (s o d), dni
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
use DateTime;

my $cgi = CGI->new;
$cgi->charset("UTF-8");
my $number = $cgi->param("number");
my $password = $cgi->param("password");
my $currency = $cgi->param("currency");
my $dni = $cgi->param("dni");
my $current_date = DateTime->now;
my $expire_date = $current_date->add(years => 7)->ymd;

my $u = "query";
my $p = "YR4AFJUC3nyRmasY";
my $dsn = "dbi:mysql:database=bancafinal;host=127.0.0.1";
my $dbh = DBI->connect($dsn, $u, $p);

our $account_id;
my $number_status = check_number($number);
my $password_status = check_password($password);
my $currency_status = check_currency($currency);
my $dni_status = check_DNI($dni);

my %errors = (number => $number_status, password => $password_status, currency => $currency_status, dni => $dni_status);

register();

sub register {
    if (!$number_status && !$password_status && !$currency_status && !$dni_status) {
        my $sth = $dbh->prepare("INSERT INTO tarjetas (numero, clave, vencimiento, cuenta_id) VALUES ('$number', '$password', '$expire_date', '$account_id')");
        $sth->execute();
        print $cgi->header("text/xml");

        return;
    }

    print_errors();
}

sub check_number {
    my $number = $_[0];
    if (!$number) {
        return "Ingrese un número de tarjeta.";
    }
    if ($number !~ /^\d{16}$/) {
        return "Número de tarjeta no valido.";
    }
}

sub check_password {
    my $password = $_[0];
    if (!$password) {
        return "Ingrese una clave.";
    }
    if (length($password) > 30) {
        return "Clave muy larga.";
    }
    if (length($password) < 8) {
        return "Clave muy corta.";
    }
}

sub check_currency {
    my $currency = $_[0];
    if (!$currency) {
        return "Marque una moneda.";
    }
    if ($currency !~ /^[sd]$/) {
        return "Moneda no valida.";
    }
}

sub check_DNI {
    my $dni = $_[0];
    if (!$dni) {
        return "Ingrese un DNI.";
    }
    if ($dni !~ /^\d{8}$/) {
        return "DNI no valido.";
    }
    my $sth = $dbh->prepare("SELECT `cuentas`.`id`
                            FROM cuentas, clientes
                            WHERE clientes.dni = '$dni' AND cuentas.cliente_id = clientes.id");
    $sth->execute;
    my @row = $sth->fetchrow_array;
    if (!@row) {
        return "Cliente no existente."
    }
    $account_id = $row[0];
    return undef;
}

sub print_errors {
    print $cgi->header("text/xml");
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