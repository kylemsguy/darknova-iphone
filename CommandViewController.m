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

#import "CommandViewController.h"

#import "S1AppDelegate.h"

@implementation CommandViewController

-(id)initGlobals
{
	{
		buyCargoViewControllerImpl = 0;
		sellCargoViewControllerImpl = 0;
		shipYardViewControllerImpl = 0;
		buyEquipmentViewControllerImpl = 0;
		sellEquipmentViewControllerImpl = 0;
		personellRosterViewControllerImpl = 0;
		bankViewControllerImpl = 0;
		SystemInfoViewControllerImpl = 0;
		commanderStatusViewControllerImpl = 0;
		galacticChartViewControllerImpl = 0;
		shortRangeChartViewControllerImpl = 0;	
		
    }
    return self;
	
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		self.title = @"Commands";//NSLocalizedString(@"PageFiveTitle", @"");
		[self awakeFromNib];
	}
	
	return [self initGlobals];

}
	
- (void)awakeFromNib
{
	self.title = @"Commands";	
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	self.navigationItem.rightBarButtonItem = app.gameOptionsButton;
}


-(IBAction) buyCargo {
	
	if (buyCargoViewControllerImpl == 0) {
		buyCargoViewControllerImpl = [[BuyCargoViewController alloc] initWithNibName:@"buyCargo" bundle:nil];		
	}
	
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	[self.navigationController pushViewController:buyCargoViewControllerImpl animated:YES];
	buyCargoViewControllerImpl.navigationItem.rightBarButtonItem = app.gameOptionsButton;
}

-(IBAction) sellCargo {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	if(sellCargoViewControllerImpl == 0) {
		sellCargoViewControllerImpl = [[SellCargoViewController alloc] initWithNibName:@"sellCargo" bundle:nil];
	}
	
	[self.navigationController pushViewController:sellCargoViewControllerImpl animated:YES];
	sellCargoViewControllerImpl.navigationItem.rightBarButtonItem = app.gameOptionsButton;	
}

-(IBAction) shipYard {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	if(shipYardViewControllerImpl == 0) {
		shipYardViewControllerImpl = [[ShipYardViewController alloc] initWithNibName:@"shipYard" bundle:nil];
	}

	[self.navigationController pushViewController:shipYardViewControllerImpl animated:YES];
	shipYardViewControllerImpl.navigationItem.rightBarButtonItem = app.gameOptionsButton;	
}

-(IBAction) buyEquipment {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	if (buyEquipmentViewControllerImpl == 0)
		buyEquipmentViewControllerImpl = [[BuyEquipmentViewController alloc] initWithNibName:@"buyEquipment" bundle:nil];
	
	[self.navigationController pushViewController:buyEquipmentViewControllerImpl animated:YES];
	buyEquipmentViewControllerImpl.navigationItem.rightBarButtonItem = app.gameOptionsButton;	
}

-(IBAction) sellEquipment {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	if (sellEquipmentViewControllerImpl == 0)
		sellEquipmentViewControllerImpl = [[SellEquipmentViewController alloc] initWithNibName:@"sellEquipment" bundle:nil];
	[self.navigationController pushViewController:sellEquipmentViewControllerImpl animated:YES];
	sellEquipmentViewControllerImpl.navigationItem.rightBarButtonItem = app.gameOptionsButton;	
}

-(IBAction) personellRoster {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	if(personellRosterViewControllerImpl == 0)
		personellRosterViewControllerImpl = [[PersonellRosterViewController alloc] initWithNibName:@"personellRoster" bundle:nil];
	[self.navigationController pushViewController:personellRosterViewControllerImpl animated:YES];
	personellRosterViewControllerImpl.navigationItem.rightBarButtonItem = app.gameOptionsButton;	
}

-(IBAction) bank {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	if (bankViewControllerImpl == 0)
		bankViewControllerImpl = [[BankViewController alloc] initWithNibName:@"bank" bundle:nil];
	
	app.mainBankViewController  = bankViewControllerImpl;	
	[self.navigationController pushViewController:bankViewControllerImpl animated:YES];
	bankViewControllerImpl.navigationItem.rightBarButtonItem = app.gameOptionsButton;
	[ bankViewControllerImpl UpdateView];
}

-(IBAction) systemInformation {
	NSLog(@"systemInformation");
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	if (SystemInfoViewControllerImpl == 0)
		SystemInfoViewControllerImpl = [[SystemInfoViewController alloc] initWithNibName:@"systemInfo" bundle:nil];
	[self.navigationController pushViewController:SystemInfoViewControllerImpl animated:YES];
	SystemInfoViewControllerImpl.navigationItem.rightBarButtonItem = app.gameOptionsButton;	
}

-(IBAction) commanderStatus {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	if(commanderStatusViewControllerImpl == 0)
		commanderStatusViewControllerImpl = [[CommanderStatusViewController alloc] initWithNibName:@"commanderStatus" bundle:nil];
	[self.navigationController pushViewController:commanderStatusViewControllerImpl animated:YES];
	commanderStatusViewControllerImpl.navigationItem.rightBarButtonItem = app.gameOptionsButton;	
}

-(IBAction) galacticChart {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	if(galacticChartViewControllerImpl == 0)
		galacticChartViewControllerImpl = [[GalacticChartViewController alloc] initWithNibName:@"galacticChart" bundle:nil];
			
	[self.navigationController pushViewController:galacticChartViewControllerImpl animated:YES];
	galacticChartViewControllerImpl.navigationItem.rightBarButtonItem = app.gameOptionsButton;	
}

-(IBAction) shortRangeChart {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	if(shortRangeChartViewControllerImpl == 0)
		shortRangeChartViewControllerImpl = [[ShortRangeChartViewController alloc] initWithNibName:@"shortrangeChart" bundle:nil];
	[self.navigationController pushViewController:shortRangeChartViewControllerImpl animated:YES];
	shortRangeChartViewControllerImpl.navigationItem.rightBarButtonItem = app.gameOptionsButton;	
}


@end
