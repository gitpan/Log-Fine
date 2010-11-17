#!perl -T

#
# $Id: 59b13f6a6b7edb2b1cb57182c5deaa80b9281c2a $
#

use Test::Simple tests => 5;

use File::Spec::Functions;
use FileHandle;
use Log::Fine;
use Log::Fine::Handle::File;
use Log::Fine::Levels::Java;
use Log::Fine::Utils;

{

        my $file = "utils.log";
        my $msg  = "Stop by this disaster town";

        # Create a handle
        my $handle =
            Log::Fine::Handle::File->new(file      => $file,
                                         autoflush => 1);

        # do some validation
        ok($handle->isa("Log::Fine::Handle"));

        # remove the file if it exists so as not to confuse ourselves
        unlink $file if -e $file;

        # open the logging sub-system
        OpenLog(handles  => [$handle],
                levelmap => "Java");

        # log a message
        Log(FINE, $msg);

        # grab a ref to our filehandle
        my $fh = $handle->fileHandle();

        # see if a file handle was properly constructed
        ok($fh->isa("IO::File"));

        # now check the file
        ok(-e $file);

        # close the file handle and reopen
        $fh->close();

        $fh = FileHandle->new(catdir($handle->{dir}, $file));

        # see if a file handle was properly constructed
        ok($fh->isa("IO::File"));

        # read in the file
        while (<$fh>) {
                ok(/^\[.*?\] \w+ $msg/);
        }

        # clean up
        $fh->close();
        unlink $file;

}
