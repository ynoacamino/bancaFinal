#!perl/bin/perl.exe

# Recibe: action (check [revisa si la sesion esta activa], close [cierra la sesion]), type (cliente u operario)
# Retorna:
# <session>
#     <logged_in>0 o 1</logged_in>
#     <name>nombre</name>
#     <expire_time>tiempo restante</expire_time>
# </session>

use strict;
use warnings;
use CGI;
use CGI::Session;
use CGI::Cookie;

my $cgi = CGI->new;
$cgi->charset("UTF-8");
my $action = $cgi->param("action");
my $type = $cgi->param("type");

my %cookies = CGI::Cookie->fetch();
my $session_cookie = $cookies{"session_id_$type"};

print ($cgi->header("text/xml"));
print "<session>\n";
if ($action eq "check") {
    if ($session_cookie) {
        my $session_id = $session_cookie->value();
        my $session = CGI::Session->load($session_id);
        my $name = $session->param("name");
        my $expire_time = $session->expires() - time;
        print<<XML;
        <logged_in>1</logged_in>
        <name>$name</name>
        <expire_time>$expire_time</expire_time>
XML
    } else {
        print "<logged_in>0</logged_in>\n";
    }
} elsif ($action eq "close") {
    print "<logged_in>0</logged_in>\n";
    if ($session_cookie) {
        my $session_id = $session_cookie->value();
        my $session = CGI::Session->load($session_id);
        $session_cookie->expires("-1h");
        $session->delete();
        $session->flush();
    }
}
print "</session>";

