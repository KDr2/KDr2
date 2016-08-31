#!/usr/bin/env perl
use v5.12;
use strict;
use warnings;

#use Smart::Comments;

use Cwd 'abs_path';
use File::Basename;
use File::Spec::Functions;
use File::Slurp;
use File::Find ();
use YAML;

use Mojo::IOLoop;
use Cloudinary;

my $META_EXT = ".cloudinary";
my $APP_ROOT = dirname(dirname(abs_path(__FILE__)));
my $IMG_ROOT = catfile($APP_ROOT, "depot", "images");
my $IMG_EXT = qr/\.(jpg|jpeg|gif|png|tiff)$/i;

sub init_cloudinay {
    state ($cloudinary, $delay);
    if (!$cloudinary) {
        my $text = read_file(catfile($APP_ROOT, "config/cloudinary.private.yml"));
        my ($hashref, $arrayref, $string) = Load($text);
        ### $hashref
        ### $arrayref
        ### $string
        $cloudinary = Cloudinary->new(
            cloud_name => $hashref->{production}->{cloud_name},
            api_key => $hashref->{production}->{api_key},
            api_secret => $hashref->{production}->{api_secret}
        );
        $delay = Mojo::IOLoop::Delay->new;
    }
    return ($cloudinary, $delay);
}

sub local_path {
    return catfile($IMG_ROOT, $_[0]);
}

sub depot_path {
    return "http://depot.kdr2.com/img-kdr2-com/$_[0]";
}

sub public_id {
    $_[0] =~ s/\.[^.]+$//;
    return "img-kdr2-com/$_[0]";
}


sub upload2cloudinary {
    my $path = $File::Find::name =~ s/^\Q$IMG_ROOT\E\///r;
    my $img_local_path = local_path($path);
    # check file
    return if $img_local_path !~ $IMG_EXT;
    return if ! -f $img_local_path;

    # check mtime
    my $img_meta_path = $img_local_path . $META_EXT;
    my $img_mtime = (stat($img_local_path))[9];
    my $met_mtime = 0;
    $met_mtime = (stat($img_meta_path))[9] if -f $img_meta_path;
    return if $met_mtime > $img_mtime;

    # upload
    my ($cloudinary, $delay) = init_cloudinay;
    my $end = $delay->begin;
    say "===> Uploading image $img_local_path ...";
    $cloudinary->upload({
        file          => depot_path($path),
        # format        => $str,                # optional
        public_id     => public_id($path),      # optional
        resource_type => "image",               # image or raw. defaults to "image"
    }, sub {
        my ($cloudinary, $res) = @_;
        ### $res
        if (defined $res->{version}) {
            write_file($img_meta_path, $res->{version});
        } else {
            say "--- :( upload error: @{[$res->{error}->{message}]} ...";
        }
        $end->();
    });
}

sub main {
    my (undef, $delay) = init_cloudinay;
    File::Find::find({wanted => \&upload2cloudinary}, $IMG_ROOT);
    $delay->wait;
}

main();
