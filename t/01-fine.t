#!perl -T

#
# $Id: 51012a09b7d24c5645aa407a68d2ffc173b4cfd8 $
#

use Test::Simple tests => 8;

use Log::Fine qw( :macros :masks );

{

        # test construction
        my $fine = Log::Fine->new();

        ok(ref $fine eq "Log::Fine");

        # all objects should have names
        ok($fine->{name} =~ /\w\d+$/);

        # test retrieving a logging object
        my $log = $fine->logger("com0");

        # make sure we got a valid object
        ok($log and $log->isa("Log::Fine::Logger"));

        # see if the object supports getLevels
        ok($log->can("levelMap"));
        ok(ref $log->levelMap eq "Log::Fine::Levels::Syslog");

        # see if object supports listLoggers
        ok($log->can("listLoggers"));

        my @loggers = $log->listLoggers();

        ok(scalar @loggers > 0);
        ok(grep("com0", @loggers));

}
