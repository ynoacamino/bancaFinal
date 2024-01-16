#!F:/Perl/perl/bin/perl.exe

use strict;
use warnings;
use CGI;
use CGI::Session;
use CGI::Cookie;

my $cgi = CGI->new;
$cgi->charset("UTF-8");
my %cookies = CGI::Cookie->fetch();
my $session_cookie = $cookies{"client_session_id"};

my $action = $cgi->param("action");
if ($action eq "check") {
    print $cgi->header("text/xml");
    if ($session_cookie) {
        my $session_id = $session_cookie->value();
        my $session = CGI::Session->load($session_id);
        my $name = $session->param("name");
        my $expire_time = $session->expires() - time;
        my $logged_in = ($expire_time > 0) || 0;
        print<<BLOCK;
        <response>
            <logged_in>$logged_in</logged_in>
            <name>$name</name>
            <expire_time>$expire_time</expire_time>
        </response>
BLOCK
    } else {
        print<<BLOCK;
        <response>
            <logged_in>0</logged_in>
        </response>
BLOCK
    }
} elsif ($action eq "close") {
    print $cgi->header("text/html");
    if ($session_cookie) {
        my $session_id = $session_cookie->value();
        my $session = CGI::Session->load($session_id);
        $session_cookie->expires("-1h");
        $session->delete();
        $session->flush();
    } else {
        print "error";
    }
}


