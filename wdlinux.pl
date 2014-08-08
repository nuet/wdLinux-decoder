#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use feature 'say';

use File::Slurp qw/read_file write_file/;
use Compress::Zlib;
use Encode;

binmode(STDOUT, ':encoding(utf8)');

sub wd_decode 
{
    my @data = unpack 'C*', substr (read_file ($_[0]), 9);
    my @key  = (0xB8, 0x35, 0x6, 0x2, 0x88, 0x1, 0x5B, 0x7, 0x44, 0x0);

    my ($i, $j) = (0, scalar @data);
    for (@data)
    {
        $_ = $key [ 2 * ($j % 5) ] ^ ~$_; 
        $_ &= 0xFF; -- $j;
    }

    return encode ('utf8', decode ('gbk', uncompress (pack 'C*', @data)));
}

for (@ARGV)
{
    say "$_ => $_.clear";
    write_file ("$_", wd_decode ($_));
}
