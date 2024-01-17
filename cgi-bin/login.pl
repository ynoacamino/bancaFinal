#!perl/bin/perl.exe

# Recibe: user, password, type (cliente u operario)
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
# o solo la creacion de una cookie si todo esta bien :>

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
my $type = $cgi->param("type");
my $session_time = 600;

my $user_status = check_user($user);
my $password_status = check_password($password);
my $type_status = check_type($type);
my %errors = (user => $user_status, password => $password_status, type => $type_status);

login();

sub login {
    if (!$user_status && !$password_status && !$type_status) {
        my $u = "query";
        my $p = "YR4AFJUC3nyRmasY";
        my $dsn = "dbi:mysql:database=bancafinal;host=127.0.0.1";
        my $dbh = DBI->connect($dsn, $u, $p);

        my $query;
        if ($type eq "cliente") {
            $query = "SELECT `cuentas`.`id`, `clientes`.`id`, CONCAT(`clientes`.`nombres`, ' ', `clientes`.`paterno`, ' ', `clientes`.`materno`)
                    FROM cuentas, clientes
                    WHERE cuentas.usuario = '$user' AND cuentas.clave = '$password' AND cuentas.cliente_id = clientes.id";
        } else {
            $query = "SELECT `nombre` FROM operarios WHERE usuario='$user' AND clave='$password'";
        }
        my $sth = $dbh->prepare($query);
        $sth->execute;

        my @person = $sth->fetchrow_array;
        if (@person) {
            my $session = CGI::Session->new();
            if ($type eq "cliente") {
                $session->param("account_id", $person[0]);
                $session->param("client_id", $person[1]);
                $session->param("name", $person[2]);
            } else {
                $session->param("name", $person[0]);    
            }
            $session->expire(time + $session_time);
            $session->flush();

            my $cookie = $cgi->cookie(-name => "session_id_$type",
                                    -value => $session->id(),
                                    -expires => time + $session_time,
                                    "-max-age" => time + $session_time);
            print $cgi->header("text/xml", -cookie => $cookie);

            return;
        } else {
            $errors{login} = "El usuario y la clave no coinciden.";
        }
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

sub check_type {
    my $type = $_[0];
    if ($type ne "cliente" && $type ne "operario") {
        return "Tipo no valido.";
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