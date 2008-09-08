#!/usr/bin/env perl
use warnings;
use strict;

use Jifty::Test::Dist tests => 3;
use JiftyX::ModelHelpers;

{
    use Simapp::Model::Book;
    my $b = Book;
    is( ref($b), "Simapp::Model::Book" );
}

my $good_book_id;
{
    my $b1 = Jifty->app_class(Model => "Book")->new;
    $good_book_id = $b1->create( name => "Good Book A");

    my $b2 = Book(name => "Good Book A");
    is( $b2->id, $b1->id );
}

{
    my $b = Book($good_book_id);
    is( $b->name, "Good Book A" );
}

