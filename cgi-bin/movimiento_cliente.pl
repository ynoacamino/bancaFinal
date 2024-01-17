#!perl/bin/perl.exe

# Recibe: card_id, type, amount
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
my $card_id = $cgi->param("card_id");
my $type = $cgi->param("type");
my $amount = $cgi->param("amount");

my %cookies = CGI::Cookie->fetch();
my $session_cookie = $cookies{"session_id_cliente"};

my $card_id_status = check_card_id($card_id);
my $amount_status = check_amount($amount);
my $type_status = check_type($type);

if ($session_cookie) {
    my $session_id = $session_cookie->value();
    my $session = CGI::Session->load($session_id);
    $account_id = $session->param("account_id");

    transaction();
}

sub transaction {
    if (!card_id_status && !$amount_status && !$type_status) {
        my $u = "query";
        my $p = "YR4AFJUC3nyRmasY";
        my $dsn = "dbi:mysql:database=bancafinal;host=127.0.0.1";
        my $dbh = DBI->connect($dsn, $u, $p);

        my $type_num = $type eq "deposit" ? 1 : -1;

        my $sth = $dbh->prepare("INSERT INTO movimientos (tarjeta_id, monto, tipo) VALUES ($card_id, $amount, $type_num)");
        $sth->execute;
        print $cgi->header("text/xml");

        return;
    }

    print_errors();
}

sub check_card_id {
    my $card_id = $_[0];
    my $length = length($card_id);
    if (!$card_id || $length == 0) {
        return "Tarjeta no valida.";
    }
}

sub check_amount {
    my $amount = $_[0];
    if (!$amount) {
        return "Ingrese una cantidad.";
    }
    if ($amount !~ /^\d+$/ || $amount < 0) {
        return "Cantidad no valida.";
    }
    if ($type eq "withdrawal") {
        my $sth = $dbh->prepare("SELECT SUM(monto*tipo) FROM movimientos WHERE tarjeta_id = $card_id");
        $sth->execute;
        my @sum = $sth->fetchrow_array;
        my $balance = $sum[0] || 0;
        if ($balance - $amount < 0) {
            return "Balance negativo."
        }
    }
}

sub check_type {
    my $type = $_[0];
    if (!&type || ($type ne "deposit" && $type ne "withdrawal")) {
        return "Tipo no valido".
    }
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