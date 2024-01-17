#!perl/bin/perl.exe

# Recibe: card_number, password
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
my $card_number = $cgi->param("card_number");
my $password = $cgi->param("password");
my $session_time = 600;

my $card_number_status = check_card_number($card_number);
my $password_status = check_password($password);
my %errors = (card_number => $card_number_status, password => $password_status);


login();


sub login {
    if (!$card_number_status && !$password_status) {
        my $u = "query";
        my $p = "YR4AFJUC3nyRmasY";
        my $dsn = "dbi:mysql:database=bancafinal;host=127.0.0.1";
        my $dbh = DBI->connect($dsn, $u, $p);

        my $sth = $dbh->prepare("SELECT `tarjetas`.`id`, `cuentas`.`id`, CONCAT(clientes.nombres, ' ', clientes.paterno, ' ', clientes.materno)
                                FROM tarjetas, cuentas, clientes
                                WHERE tarjetas.numero = '$card_number' AND tarjetas.clave = '$password' AND cuentas.tarjeta_id = tarjetas.id AND cuentas.cliente_id = clientes.id;");
        $sth->execute();

        my @client = $sth->fetchrow_array;
        if (@client) {
            my $session = CGI::Session->new();
            $session->param("card_id", $client[0]);
            $session->param("account_id", $client[1]);
            $session->param("name", $client[2]);
            $session->expire(time + $session_time);
            $session->flush();

            my $cookie = $cgi->cookie(-name => "session_id_cliente",
                                    -value => $session->id(),
                                    -expires => time + $session_time,
                                    "-max-age" => time + $session_time);
            print $cgi->header("text/xml", -cookie => $cookie);

            return;
        } else {
            $errors{login} = "El número de tarjeta y la clave no coinciden.";
        }
    }

    print_errors();
}

sub check_card_number {
    my $card_number = $_[0];
    my $length = length($card_number);
    if (!$card_number || $length == 0) {
        return "Ingrese un número de tarjeta.";
    }
    if ($card_number !~ /^\d{16}$/) {
        return "Número de tarjeta no valido.";
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