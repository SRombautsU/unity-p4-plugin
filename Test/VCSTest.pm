use lib 'Test/Perforce';
use PerforceTest;

sub IntegrationTest
{
	$failed = PerforceIntegrationTests(@_);
	return $failed;
}

1;
