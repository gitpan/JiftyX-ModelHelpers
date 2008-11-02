use strict;
use warnings;

package Simapp::Model::Book;
our $VERSION = '0.20';

use Jifty::DBI::Schema;

use Simapp::Record schema {
    column name => type is 'varchar(255)';
};

# Your model-specific methods go here.

1;

