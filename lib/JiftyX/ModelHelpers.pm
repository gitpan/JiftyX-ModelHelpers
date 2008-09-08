package JiftyX::ModelHelpers;
use strict;
use Exporter;

our @ISA = qw(Exporter);
our @EXPORT;
our $VERSION = "0.01";

if (@EXPORT == 0) {
    require Jifty::Schema;
    my @models = map { s/.*::(.+)$/$1/;  $_; } Jifty::Schema->new->models;

    no strict 'refs';
    for my $model (@models) {
        if ( index($model, "Collection") >= 0) {
            *{"$model"} = sub {
                my @args = @_;
                my $obj = Jifty->app_class(Model => "$model")->new;
                if (@args == 0) {
                    $obj->unlimit;
                }
                elsif (@args % 2 == 0) {
                    my %limits = @args;
                    while( my ($col, $val) = each %limits) {
                        $obj->limit(column => $col, value => $val);
                    }
                }
                return $obj;
            }
        }
        else {
            *{"$model"} = sub {
                my @args = @_;
                my $obj = Jifty->app_class(Model => "$model")->new;
                if (@args == 1) {
                    $obj->load($args[0]);
                }
                elsif (@args && @args % 2 == 0) {
                    $obj->load_by_cols(@args);
                }
                return $obj;
            };
        }
        push @EXPORT, "&${model}";
    }
}

"true, true.";

=head1 NAME

JiftyX::ModelHelpers - Use Jifty model easily.

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

Suppose you have a "Book" model in your app:

    use JiftyX::ModelHelper;

    # Load the record of book with id = $id
    $book = Book($id);

    # Load by other criteria
    $book = Book(isbn => " 978-0099410676");

    # Load a colllection of books
    $books = BookCollection(author => "Jesse");

=head1 Description

Jifty programmers may find them self very tired of typing in their
View or Dispatcher when it comes to retrieve records or collection of
records. That is why this module was borned.

This module, when required, generates two functions for each models
your Jifty application. One for accessing records, the other for
accessing collections. For example, if you have a model named "Book",
the generated functions are:

    JiftyX::ModelHelpers::Book
    JiftyX::ModelHelpers::BookCollection

They are automatically imported to your currenct package scope as:

    Book
    BookCollection

The record function takes either exact one argument or a hash. When it
 is given only one argument, that argument is treated as the value of
 "id" field and the record with that id is retured. Such as:

    my $book = Book(42);

This is exactly the same as:

    my $book = Jifty->app_class(Model => 'Book')->new;
    $book->load(42);

In other cases, it'd expect a hash:

    my $book = Book(isbn => "978-0099410676");

This is exactly the same as:

    my $book = Jifty->app_class(Model => 'Book');
    $book->load_by_cols(isbn => "978-0099410676");

Please also read the description of C<load_by_cols> in
L<Jifty::DBI::Record> to know how to use it. Basically the generate
helper functions just delegate all its argument to that method and
returns whatever returned from there.

The returned C<$book> is a L<Jifty::Record> object, so please read
its POD for how to use it.

As for the function of collections, here's the example to get a
collection of all records of books:

    my $books = BookCollection;

And that's identical to:

    my $books = Jifty->app_class(Model => "BookCollection")->new;
    $books->unlimit;

The function for collection can take a hash too, and calls C<limit>
method on the collection several times:

    my $books = BookCollection(
        author => "Neal Stephenson",
        binding => "paperback"
    );

This is the same as:

    my $books = Jifty->app_class(Model => "BookCollection")->new;
    $books->limit(column => "author", value => "Neal Stephenson");
    $books->limit(column => "binding", value => "paperback");

The returned C<$books> is still a L<Jifty::Collection> object, so
please read its POD for how to use it.

For people who works daily in Jifty world, this should make your code
more readible for most of the time.

=head1 Namespace clobbering

One major issue for using this module is that it automaically defines
many functions in its caller, and that might cause naming collision.

To work around this, keep in mind that this method is an L<Exporter>,
so you can pass those functions your want explicitly:

    # Don't want BookCollection function
    use JiftyX::ModelHelpers qw(Book);

=head1 Development

The code repository for this project is hosted on

    http://svn.jifty.org/svn/jifty.org/JiftyX-ModelHelpers

If you want to report a bug or an issue, please use this form:

    https://rt.cpan.org/Ticket/Create.html?Queue=JiftyX-ModelHelpers

If you want to disscuss about this module, please join jifty-devel
mailing list.

To join the list, send mail to C<jifty-devel-subscribe@lists.jifty.org>

=head1 AUTHORS

Kang-min Liu C< <gugod@gugod.org> >

=head1 COPYRIGHT & LICENSE

The MIT License

Copyright (c) 2008 Kang-min Liu

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

=cut

