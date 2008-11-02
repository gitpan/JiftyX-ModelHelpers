#!/usr/bin/env perl
use warnings;
use strict;

use Jifty::Test::Dist tests => 3;
use JiftyX::ModelHelpers qw(M);

{
    use Simapp::Model::Book;
    my $b = M("Book");
    is( ref($b), "Simapp::Model::Book" );
}

my $good_book_id;
{
    my $b1 = Jifty->app_class(Model => "Book")->new;
    $good_book_id = $b1->create( name => "Good Book A");

    my $b2 = M("Book", name => "Good Book A");
    is( $b2->id, $b1->id );
}

{
    my $b = M("Book", id => $good_book_id);
    is( $b->name, "Good Book A" );
}

