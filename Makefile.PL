use inc::Module::Install;

name            'JiftyX-ModelHelpers';
license         'mit';
author          'Kang-min Liu <gugod@gugod.org>';
all_from        'lib/JiftyX/ModelHelpers.pm';

build_requires  'Test::More';
build_requires  'Test::Warn';

WriteAll;
