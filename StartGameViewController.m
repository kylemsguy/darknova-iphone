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

#import "StartGameViewController.h"
#import "S1AppDelegate.h"
#import "Player.h"
@implementation StartGameViewController


- (IBAction)closeWindow {
   // [self.tabBarController dismissModalViewControllerAnimated:YES];
	//[self.navigationController setNavigationBarHidden:FALSE];//:<#(UINavigationBar *)#>
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (app.gamePlayer.totalSkillPoints == 0) {
//		[[self view] removeFromSuperview];
		S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
		[app switchBarToGame];
//		[[app window] addSubview:app.navigationController.view];
		[app.gamePlayer StartNewGame];
		app.commandView = 0;
		[app systemInfoCommand];

	}
	else {
		// open an alert with just an Ok button
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"More Skill Points" message:@"You haven't awarded all 20 skill points yet."
													   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
		[alert show];	
	}
	
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
if (self)
{
	[self.navigationController setNavigationBarHidden:TRUE];
	
	// this will appear as the title in the navigation bar
	self.title = @"New Commander";//NSLocalizedString(@"PageFiveTitle", @"");
	
	// this will appear above the segmented control
	//self.navigationItem.prompt = @"Please fill fields:";
}

return self;
}

- (void)viewDidAppear:(BOOL)animated {
	//[self.navigationController setNavigationBarHidden:TRUE];
	// this will appear as the title in the navigation bar
	self.title = @"New Commander";//NSLocalizedString(@"PageFiveTitle", @"");	
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	app.gamePlayer.traderSkill = 1;
	app.gamePlayer.engineerSkill = 1;
	app.gamePlayer.fighterSkill = 1;
	app.gamePlayer.pilotSkill = 1;
	app.gamePlayer.totalSkillPoints = 16;
	app.gamePlayer.gameDifficulty = 2;
	//S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	//[[app window] bringSubviewToFront:self.view];
	//[[app mainToolbar] 
	//[self.navigationController presentModalViewController:self animated:YES];
}


- (void)viewDidLoad
{
	// add our custom add button as the nav bar's custom right view
	//	UIBarButtonItem *addButton = [[[UIBarButtonItem alloc]
	//								   initWithTitle:@"AddTitle"
	//								   style:UIBarButtonItemStyleBordered
	//								   target:self
	//								   action:@selector(addAction:)] autorelease];
	//	self.navigationItem.rightBarButtonItem = addButton;
}
	
@end
