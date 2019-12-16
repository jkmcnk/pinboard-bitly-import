#!/usr/bin/perl

use strict;
use warnings;

use utf8;
use JSON;
use LWP::UserAgent;
use Date::Parse;
use Date::Format;

scalar @ARGV == 1 || die "Usage: bitlinks-to-pinboard.pl <pinboard-api-token>";

my $json = <STDIN>;
my $decoded = decode_json($json);
my $links = $decoded->{'links'};

my $ua = LWP::UserAgent->new;

my $at = $ARGV[0];

my $pinbase = "https://api.pinboard.in/v1/posts/add?auth_token=$at";

foreach my $bitlink (@$links) {
    my $url = $bitlink->{'long_url'};
    my $tags = $bitlink->{'tags'};
    my $title = $bitlink->{'title'};
    my $created_bitly = $bitlink->{'created_at'};
    my $created = Date::Parse::str2time($created_bitly);
    my $created_pinboard = Date::Format::time2str("%Y-%m-%dT%H:%M:%SZ", $created, 'UTC');
    
    if(!defined($title)) {
        $title = $url;
    }
    
    my $requrl = $pinbase . "&url=$url&description=$title&dt=$created_pinboard";
    if(scalar @$tags > 0) {
        my $taglist = join(',', @$tags);
        $requrl = $requrl . "&tags=$taglist";
    }

    my $req = HTTP::Request->new(GET => $requrl);
    my $res = $ua->request($req);
    if(!$res->is_success) {
        print "URL $url import failed.\n";
    }
}
