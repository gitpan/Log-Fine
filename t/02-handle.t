#!perl -T

#
# $Id: 02-handle.t 35 2008-05-21 14:26:37Z cfuhrman $
#

use Test::More tests => 5;

use Log::Fine;
use Log::Fine::Handle;
use Log::Fine::Handle::String;

{

        # first we create a handle
        my $handle = Log::Fine::Handle::String->new();

        # validate handle
        ok($handle->isa("Log::Fine::Handle"));

        # validate default attributes
        ok($handle->{mask} == Log::Fine::Handle->DEFAULT_LOGMASK);
        ok($handle->{level} == DEBG);
        ok($handle->{formatter}->isa("Log::Fine::Formatter"));
        ok(ref $handle->{formatter} eq "Log::Fine::Formatter::Basic");

}
