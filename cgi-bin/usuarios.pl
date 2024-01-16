#!F:/Perl/perl/bin/perl.exe

use strict;
use warnings;
use CGI;
use CGI::Session;
use CGI::Cookie;
use DBI;

my $cgi = CGI->new;
$cgi->charset("UTF-8");
my $u = "user_query";
my $p = "W0()3ROEpIL9A)Cs";
my $dsn = "dbi:mysql:database=banca;host=127.0.0.1";
my $dbh = DBI->connect($dsn, $u, $p);

my $user = $cgi->param("user");
my $password = $cgi->param("password");
my $session_time = 600;

my $sth = $dbh->prepare("SELECT * FROM usuarios WHERE usuario=? AND clave=?");
$sth->execute($user, $password);


if ($sth->fetchrow_array) {
    my $session = CGI::Session->new();
    $session->param("user", $user);
    $session->expire(time + $session_time);
    $session->flush();

    my $cookie = $cgi->cookie(-name => "user_session_id",
                            -value => $session->id(),
                            -expires => time + $session_time,
                            "-max-age" => time + $session_time);
    $cookie->bake();

    print "correct";
} else {
    print($cgi->header("text/html"));
    print "wrong";
}