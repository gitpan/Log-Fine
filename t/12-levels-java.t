#!perl -T

#
# $Id: 5e55cff662a03b94e4ac11712b886c7e7d3914cf $
#

use Test::More tests => 50;

use Log::Fine::Levels::Java qw( :macros :masks );

{

        my $levels = Log::Fine::Levels::Java->new();

        # levels should be a *::Java object
        isa_ok($levels, "Log::Fine::Levels::Java");

        # validate methods
        can_ok($levels, $_)
            foreach (
                    qw/ new bitmaskAll levelToValue maskToValue valueToLevel /);

        my @levels = $levels->logLevels();
        my @masks  = $levels->logMasks();

        ok(scalar @levels > 0);
        ok(scalar @masks > 0);

        # make sure levels are in ascending order by val;
        my $val = 0;
        my $map = Log::Fine::Levels::Java::LVLTOVAL_MAP;
        foreach my $level (@levels) {
                next if $map->{$level} == 0;
                ok($map->{$level} > $val);
                $val = $map->{$level};
        }

        # make sure masks are ascending order by val
        $val = 0;
        $map = Log::Fine::Levels::Java::MASK_MAP;
        foreach my $mask (@masks) {
                next if $map->{$mask} == 0;
                ok($map->{$mask} > $val);
                $val = $map->{$mask};
        }

        # variable for holding bitmask
        my $bitmask = 0;

        for (my $i = 0; $i < scalar @levels; $i++) {
                ok($i == $levels->levelToValue($levels[$i]));
                ok(&{ $levels[$i] } eq $i);
                ok(&{ $masks[$i] }  eq $levels->maskToValue($masks[$i]));

                $bitmask |= $levels->maskToValue($masks[$i]);
        }

        ok($bitmask == $levels->bitmaskAll());
        ok($levels->MASK_MAP($_) =~ /\d/) foreach (@masks);

}