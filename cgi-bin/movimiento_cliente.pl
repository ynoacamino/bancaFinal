#!perl/bin/perl.exe

# Recibe: card_id, type (d, w, t), amount, other_card (only for t)
# deposit, withdrawal, transferin
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

my %type_nums = (d => 1, w => 2, t => 3);

my $cgi = CGI->new;
$cgi->charset("UTF-8");
my $card_id = $cgi->param("card_id");
my $type = $cgi->param("type");
my $amount = $cgi->param("amount");

my %cookies = CGI::Cookie->fetch();
my $session_cookie = $cookies{"session_id_cliente"};

my $u = "query";
my $p = "YR4AFJUC3nyRmasY";
my $dsn = "dbi:mysql:database=bancafinal;host=127.0.0.1";
my $dbh = DBI->connect($dsn, $u, $p);

my $card_id_status = check_card_id($card_id);
my $type_status = check_type($type);
my $amount_status = check_amount($amount);
our $other_id;


my %errors = (card_id => $card_id_status, type => $type_status, amount => $amount_status);

if ($session_cookie) {
    transaction();
}

sub transaction {
    print $cgi->header("text/xml");
    if (!$card_id_status && !$amount_status && !$type_status) {
        my $type_num = $type_nums{$type};
        if ($type_num == 3) {
            transference();
        }
        my $sth = $dbh->prepare("INSERT INTO movimientos (tarjeta_id, monto, tipo) VALUES ('$card_id', '$amount', '$type_num')");
        $sth->execute;

        return;
    }

    print_errors();
}

sub transference {
    my $other_card = $cgi->param("other_card");
    my $other_card_status = check_other_card($other_card);
    if (!$other_card_status) {
        my $sth = $dbh->prepare("INSERT INTO movimientos (tarjeta_id, monto, tipo) VALUES ('$other_id', '$amount', '4')");
        $sth->execute;
        return;
    }

    print<<XML;
    <error>
        <element>other_card</element>
        <message>$other_card_status</message>
    </error>
XML
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
    if ($type eq "w") {
        my $sth = $dbh->prepare("SELECT SUM(monto*tipo) FROM movimientos WHERE tarjeta_id = '$card_id'");
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
    if (!$type) {
        return "Marque un tipo";
    }
    if ($type !~ /^[dwt]$/) {
        return "Tipo no valido";
    }
}

sub check_other_card {
    my $number = $_[0];
    if (!$number) {
        return "Ingrese un número de tarjeta.";
    }
    if ($number !~ /^\d{16}$/) {
        return "Número de tarjeta no valido.";
    }
    my $sth = $dbh->prepare("SELECT `id` FROM tarjetas WHERE numero = '$number'");
    $sth->execute;
    my @row = $sth->fetchrow_array;
    if (!@row) {
        return "La tarjeta no existe.";
    }
    $other_id = $row[0];
    return undef;
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