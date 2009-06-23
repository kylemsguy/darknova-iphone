#import "warpViewController.h"
#import "S1AppDelegate.h"
#import "Player.h"

@implementation warpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		self.title = NSLocalizedString(@"Average Price List", @"");
	}
	return self;
}


-(IBAction) showSystemInformation
{
	self.title = @"Target System";
	self.view = sysInfoViewInst;
	[sysInfoViewInst UpdateView];
}

-(IBAction) showPricesInformation
{
	self.title = @"Average Price List";
	self.view = pricesViewInst;	
	//[pricesViewInst UpdateView];
}


-(IBAction) showShortRangeChart
{
	//	[self removeFromSuperview];
	
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	[app.navigationController popViewControllerAnimated:YES];
	//	UIViewController * targetViewController = [[UIViewController alloc] initWithNibName:@"shortrangeChart" bundle:nil];
	//	[app.navigationController pushViewController:targetViewController animated:YES];	
}

-(IBAction) doWarp
{
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	[app.gamePlayer doWarp:false];
}


-(IBAction) nextPlanet
{
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	app.gamePlayer.warpSystem = [app.gamePlayer nextSystemWithinRange:app.gamePlayer.warpSystem Back:FALSE];
	if (self.view == sysInfoViewInst)
		[sysInfoViewInst UpdateView];
	[pricesViewInst UpdateWindow];
}

-(IBAction) prevPlanet
{
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	app.gamePlayer.warpSystem = [app.gamePlayer nextSystemWithinRange:app.gamePlayer.warpSystem Back:TRUE];
	if (self.view == sysInfoViewInst)
		[sysInfoViewInst UpdateView];
	[pricesViewInst UpdateWindow];	
}

@end
