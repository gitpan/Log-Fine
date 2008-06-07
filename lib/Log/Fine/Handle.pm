
=head1 NAME

Log::Fine::Handle - Controls where to send logging output

=head1 SYNOPSIS

Sets up an output handle for log messages

    use Log::Fine;
    use Log::Fine::Handle;

    # instantiate the handle (default values shown)
    my $handle = Log::Fine::Handle::Foo
        ->new( name      => "foo0",
               mask      => Log::Fine::Handle->DEFAULT_LOGMASK,
               level     => DEBG,
               formatter => Log::Fine::Formatter:Basic->new() );

    # see if a handle is loggable at a given level
    my $rc = $handle->isLoggable(INFO);

    # write a message
    $handle->msgWrite(INFO, "Informational message", 1);

=head1 DESCRIPTION

A Log::Fine::Handle object controls I<where> to send formatted log
messages.  The destination can be a file, syslog, a database table, or
simply to output.  Message formatting is then handled by a
L<formatter|Log::Fine::Formatter> object.

=cut

use strict;
use warnings;

package Log::Fine::Handle;

use base qw( Log::Fine );

use Carp;
use Log::Fine qw( :macros :masks );
use Log::Fine::Formatter::Basic;

# Constant: DEFAULT_LOG_MASK
#
# Default log mask.  Basically everything
use constant DEFAULT_LOGMASK => Log::Fine->LOGMASK_ALL;

=head1 METHODS

=head2 isLoggable($lvl)

Specifies whether the handle is loggable at the given level.  Returns
1 if we can log, undef otherwise.

=cut

sub isLoggable
{

        my $self = shift;
        my $lvl  = shift;

        croak "No Level :$lvl\n"
            unless (defined $lvl and $lvl =~ /\d+/);

        # bitand the level and the mask to see if we're loggable
        return (($self->{mask} & $lvl) == $lvl) ? 1 : undef;

}          # isLoggable()

=head2 msgWrite($lvl, $msg, $skip)

Tells the handle to output the given log message.  The third
parameter, C<$skip>, is passed to caller() for accurate method
logging.

B<Note:> msgWrite() is an I<internal> method to the Log::Fine
framework, meant to be sub-classed.  Use
L<Log::Fine::Logger/"log($lvl, $msg)"> for actual logging.

=cut

sub msgWrite
{

        my $self  = shift;
        my $class = ref $self;

        croak "someone used an (abstract) Handle object"
            if $class eq 'Log::Fine::Handle';

        croak "call to abstract method ${class}::msgWrite()";

}          # msgWrite()

=head2 setFormatter($formatter)

Sets the formatter for this object

=cut

sub setFormatter
{

        my $self      = shift;
        my $formatter = shift;

        # validate formatter
        croak "First argument must be a valid formatter object!\n"
            unless (defined $formatter
                    and $formatter->isa("Log::Fine::Formatter"));

        $self->{formatter} = $formatter;

}          # setFormatter()

# --------------------------------------------------------------------

##
# Initializes our object

sub _init
{

        my $self = shift;

        # perform super initializations
        $self->SUPER::_init();

        # set default bitmask
        $self->{mask} = DEFAULT_LOGMASK
            unless defined $self->{mask};

        # by default, set the level to DEBG
        $self->{level} = DEBG
            unless defined $self->{level};

        # set the default formatter
        $self->{formatter} = Log::Fine::Formatter::Basic->new()
            unless (defined $self->{formatter}
                    and $self->{formatter}->isa("Log::Fine::Formatter"));

        # Victory!
        return $self;

}          # _init()

=head1 SEE ALSO

L<perl>, L<Log::Fine>, L<Log::Fine::Formatter>

=head1 AUTHOR

Christopher M. Fuhrman, C<< <cfuhrman at panix.com> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-log-fine-handle at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Log-Fine>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Log::Fine

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Log-Fine>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Log-Fine>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Log-Fine>

=item * Search CPAN

L<http://search.cpan.org/dist/Log-Fine>

=back

=head1 REVISION INFORMATION

  $Id: Handle.pm 76 2008-06-06 16:36:28Z cfuhrman $

=head1 COPYRIGHT & LICENSE

Copyright (c) 2008 Christopher M. Fuhrman, 
All rights reserved.

This program is free software licensed under the...

	The BSD License

The full text of the license can be found in the
LICENSE file included with this module.

=cut

1;          # End of Log::Fine::Handle