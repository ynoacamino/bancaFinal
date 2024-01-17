#!perl/bin/perl.exe

# Recibe: user, password
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
my $session_time = 1200;

my $user_status = check_user($user);
my $password_status = check_password($password);
my %errors = (user => $user_status, password => $password_status);

login();

sub login {
    if (!$user_status && !$password_status) {
        my $u = "query";
        my $p = "YR4AFJUC3nyRmasY";
        my $dsn = "dbi:mysql:database=bancafinal;host=127.0.0.1";
        my $dbh = DBI->connect($dsn, $u, $p);

        my $sth = $dbh->prepare("SELECT `nombre` FROM usuarios WHERE usuario='$user' AND clave='$password'");
        $sth->execute();

        my @operator = $sth->fetchrow_array;
        if (@operator) {
            my $session = CGI::Session->new();
            $session->param("name", $operator[0]);
            $session->expire(time + $session_time);
            $session->flush();

            my $cookie = $cgi->cookie(-name => "session_id_operario",
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