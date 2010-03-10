/*
    Dark Nova © Copyright 2009 Dead Jim Studios
    This file is part of Dark Nova.

    Dark Nova is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Dark Nova is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Dark Nova.  If not, see <http://www.gnu.org/licenses/>
*/

#import "WarpViewController.h"
#import "S1AppDelegate.h"
#import "Player.h"

@implementation WarpViewController

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
