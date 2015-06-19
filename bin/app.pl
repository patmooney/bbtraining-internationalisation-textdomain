#!/usr/bin/env perl
use strict; use warnings;

use FindBin;
BEGIN { unshift @INC, "$FindBin::Bin/../lib" }

use MyApp;
my $app = MyApp->new(5005);
$app->run();
