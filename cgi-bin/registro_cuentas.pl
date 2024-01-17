#!perl/bin/perl.exe

# Recibe: user, password, dni
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
my $user = $cgi->param("user");
my $password = $cgi->param("password");
my $dni = $cgi->param("dni");

our $client_id;
my $user_status = check_user($user);
my $password_status = check_password($password);
my $dni_status = check_DNI($dni);

register();

sub register {
    if (!$user_status && !$password_status && !$dni_status) {
        my $u = "query";
        my $p = "YR4AFJUC3nyRmasY";
        my $dsn = "dbi:mysql:database=bancafinal;host=127.0.0.1";
        my $dbh = DBI->connect($dsn, $u, $p);

        my $sth = $dbh->prepare("INSERT INTO cuentas (usuario, clave, cliente_id) VALUES ($user, $password, $client_id)");
        $sth->execute;
        print $cgi->header("text/xml");

        return;
    }

    print_errors();
}

sub check_user {
    my $card_number = $_[0];
    my $length = length($card_number);
    if (!$card_number || $length == 0) {
        return "Ingrese un usuario.";
    }
    if ($length > 30) {
        return "Usuario muy largo.";
    }
}

sub check_password {
    my $password = $_[0];
    my $length = length($password);
    if (!$password || $length == 0) {
        return "Ingrese una clave.";
    }
    if ($length > 30) {
        return "Clave muy larga.";
    }
}

sub check_DNI {
    my $dni = $_[0];
    if (!$dni) {
        return "Ingrese un DNI";
    }
    if ($dni !~ /^\d{8}$/) {
        return "DNI no valido";
    }
    my $sth = $dbh->prepare("SELECT `id` FROM clientes WHERE dni = $dni");
    $sth->execute;
    my @row = $sth->fetchrow_array;
    if (!@row) {
        return "Cliente no existente";
    }
    $client_id = $row[0];
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