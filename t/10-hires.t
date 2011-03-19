#!perl -T

#
# $Id: b1e6c86e6208d7657bf09ea51910b268372e6b40 $
#

use Test::More;

use Log::Fine;
use Log::Fine::Formatter;
use Log::Fine::Formatter::Basic;
use Log::Fine::Formatter::Detailed;
use Log::Fine::Levels::Syslog;

{

        # See if we have Time::HiRes installed
        eval "use Time::HiRes";

        if ($@) {
                plan skip_all =>
"Time::HiRes is not installed.  High precision logging not possible";
        } else {
                plan tests => 13;
        }

        # create a basic formatter
        my $basic = Log::Fine::Formatter::Basic->new(hires => 1);

        ok(ref $basic eq "Log::Fine::Formatter::Basic");
        ok($basic->name() =~ /\w\d+$/);
        ok($basic->timeStamp() eq
            Log::Fine::Formatter->LOG_TIMESTAMP_FORMAT_PRECISE);

        # format a message
        my $msg = "Stop by this disaster town";
        my $log0 = $basic->format(INFO, $msg, 1);

        # see if the format is correct
        ok($log0 =~ /^\[.*?\] \w+ $msg/);

        # make sure we can change the timestamp format
        $basic->timeStamp("%Y%m%d%H%M%S.%%millis%%");

        my $log1 = $basic->format(INFO, $msg, 1);

        # see if the format is correct
        ok($log1 =~ /^\[\d{14}\.\d+\] \w+ $msg/);

        # now create a detailed formatter
        my $detailed = Log::Fine::Formatter::Detailed->new(hires => 1);

        ok(ref $detailed eq "Log::Fine::Formatter::Detailed");
        ok($detailed->name() =~ /\w\d+$/);
        ok($detailed->timeStamp() eq
            Log::Fine::Formatter->LOG_TIMESTAMP_FORMAT_PRECISE);

        # format a message
        my $log2 = $detailed->format(INFO, $msg, 1);

        ok($log2 =~ /^\[\d\d\:\d\d\:\d\d\.\d{5,5}\] \w+ \(.*?\) $msg/);

        my $log3 = myfunc($detailed, $msg);

        ok($log3 =~ /^\[.*?\] \w+ \(.*?\:\d+\) $msg/);

        my $precise =
            Log::Fine::Formatter::Basic->new(
                                 hires            => 1,
                                 precision        => 10,
                                 timestamp_format => "%d %b %H:%M:%S.%%Millis%%"
            );

        ok($precise->isa("Log::Fine::Formatter::Basic"));
        ok($precise->name() =~ /\w\d+$/);

        my $log4 = $precise->format(WARN, $msg, 1);

        # Note: This regex is designed to catch non-English month
        # representations found in other locales.  This has been
        # tested against:
        #
        #  * ar_AE.utf8
        #  * cs_CZ.utf8
        #  * de_DE.utf8
        #  * es_ES.utf8
        #  * hi_IN.utf8
        #  * ja_JP.utf8
        #  * ko_KR.utf8
        #  * zh_TW.UTF-8
        #
        # This list is by no means comprehensive.  Also, since there
        # is a wide variety of different interpretations of various
        # locales on different operating systems, handle our own error
        # reporting.

        # Debuggery
        #print STDERR $log4;

        if ($log4 =~ /^\[\w+\s+\S+ \d\d\:\d\d\:\d\d\.\d{10,10}\] \w+ $msg/) {
                ok(1);
        } else {
                print STDERR "\n----------------------------------------\n";
                print STDERR "Test failed on the following line:\n\n";
                print STDERR "${log4}";
                print STDERR "----------------------------------------\n";
                ok(0);
        }

}

# this subroutine is for testing the detailed formatter

sub myfunc
{

        my $formatter = shift;
        my $msg       = shift;

        return $formatter->format(INFO, $msg, 1);

}
