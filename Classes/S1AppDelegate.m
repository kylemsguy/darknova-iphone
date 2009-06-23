//
//  S1AppDelegate.m
//  S1
//
//  Created by Alexey M on 9/26/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "S1AppDelegate.h"
#import <UIKit/UIKit.h>
#import "startGameViewController.h"
#import "Player.h"
#import <CoreGraphics/CoreGraphics.h>
#import <CoreFoundation/CoreFoundation.h>
#import "MainToolBar.h"

@implementation S1AppDelegate

@synthesize window;
@synthesize commandView;
@synthesize navigationController;
@synthesize mainToolbar;
@synthesize gameView;
@synthesize mainBankViewController;
@synthesize gamePlayer, isGameLoaded, gameOptionsButton;
@synthesize shipInfoController, buyShipController;

bool bStartNewGame;
- (void)applicationDidFinishLaunching:(UIApplication *)application {	
	gamePlayer = [[Player alloc] initEmpty];
	newGame = 0;
	saveGame = 0;
	commandView = 0;
	helpWindow = 0;
	gameView = 0;
	[gamePlayer initGlobals];
	bStartNewGame = true;
	shipInfoController = 0;
	buyShipController = 0;
	[window makeKeyAndVisible];	
	
	[self showStartGame];
	
	[gamePlayer playMusic];
	[gamePlayer initSounds];
//	audioPlayer = [AudioPlayer alloc];
	
	// URL here.
	/*
	NSArray *filePaths =	NSSearchPathForDirectoriesInDomains (
																 
																 NSDocumentDirectory, 
																 NSUserDomainMask,
																 YES
																 ); 
	
	NSString* recordingDirectory = [filePaths objectAtIndex: 0];
	
	CFStringRef fileString = (CFStringRef) [NSString stringWithFormat: @"%@/Resonance.caf", recordingDirectory];
	
	// create the file URL that identifies the file that the recording audio queue object records into
	CFURLRef fileURL1 =	CFURLCreateWithFileSystemPath (
													   NULL,
													   @"Resonance.caf",//fileString,
													   kCFURLPOSIXPathStyle,
													   false
													   );
	
	NSURL * fileURL = (NSURL *) fileURL1;
	
	//	set the audio session category
	UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
	AudioSessionSetProperty (
							 kAudioSessionProperty_AudioCategory,
							 sizeof (sessionCategory),
							 &sessionCategory
							 );
	
	audioPlayer = [AudioPlayer alloc];
	audioPlayer.audioFileURL = fileURL1;
	[audioPlayer openPlaybackFile: audioPlayer.audioFileURL];
	[audioPlayer setupPlaybackAudioQueueObject];
	[audioPlayer setDonePlayingFile: NO];
	[audioPlayer setAudioPlayerShouldStopImmediately: NO];
	
	AudioSessionSetActive (true);	
//	[audioPlayer openPlaybackFile:fileURL];
//	[audioPlayer setupPlaybackAudioQueueObject];	
	[audioPlayer play];
	 */
	
	
		/*
		//stop playing
		if(player1) {
			NSLog (@"User tapped Stop to stop playing.");
			[player1 setAudioPlayerShouldStopImmediately: YES];
			NSLog (@"Calling AudioQueueStop from controller object.");
			[player1 stop];
			
			// now that playback has stopped, deactivate the audio session
			AudioSessionSetActive (false);
		}  
		//THIS PART DOESN'T WORK
		//start playing again
		AudioSessionSetActive (true);
		NSLog (@"sending play message to play object.");
		[player1 play];	
		*/
	//}
}

-(void)showStartGame{
	
	[window addSubview:navigationController.view];		
	isGameLoaded = false;
	bStartNewGame = true;
	
	// size up the toolbar and set its frame
	[mainToolbar sizeToFit];
	CGFloat toolbarHeight = [mainToolbar frame].size.height;
	CGRect mainViewBounds = navigationController.view.bounds;
	[mainToolbar setFrame:CGRectMake(CGRectGetMinX(mainViewBounds),
									 CGRectGetMinY(mainViewBounds) + CGRectGetHeight(mainViewBounds) - (toolbarHeight ) + 2.0,
									 CGRectGetWidth(mainViewBounds),
									 toolbarHeight)];
	[mainToolbar removeFromSuperview];
	
	[startToolbar sizeToFit];
	toolbarHeight = [startToolbar frame].size.height;
	mainViewBounds = navigationController.view.bounds;
	[startToolbar setFrame:CGRectMake(CGRectGetMinX(mainViewBounds),
									  CGRectGetMinY(mainViewBounds) + CGRectGetHeight(mainViewBounds) - (toolbarHeight ) + 2.0,
									  CGRectGetWidth(mainViewBounds),
									  toolbarHeight)];
	[[navigationController view] addSubview:startToolbar];	
	
	
	helloWindowViewController * helloWindow = [[[helloWindowViewController alloc] initWithNibName:@"helloWindow" bundle:nil] autorelease];
	NSArray* arr = [NSArray arrayWithObjects:helloWindow, nil];
	[self.navigationController setViewControllers:arr];
}

-(void)switchBarToGame
{
	if (bStartNewGame) {
		bStartNewGame = false;
		[startToolbar removeFromSuperview];
		[[navigationController view] addSubview:mainToolbar];	
		
		//for (int i =0; i < self.navigationController.viewControllers.count; ++i) 
		//	[[self.navigationController.viewControllers objectAtIndex:i] release];		
	}
}

-(IBAction)commandCommand{
	
	if (commandView != navigationController.topViewController) {
		
		if (commandView == 0)
			commandView = [[commandViewController alloc] initWithNibName:@"commands" bundle:nil];
		
		NSArray* arr = [NSArray arrayWithObjects:commandView, nil];
		
		//if (
		//for (int i =0; i < self.navigationController.viewControllers.count; ++i) 
		//	[[self.navigationController.viewControllers objectAtIndex:i] release];	
		
		self.navigationController.viewControllers = arr;
	//	[[self navigationController] setviewControllers:arr];
		//[commandView release];
	}
}

-(IBAction)shipYardCommand
{
	[self commandCommand];
	[commandView shipYard];
}

-(IBAction)sellCargoAction
{
	[self commandCommand];
	[commandView sellCargo];
}

-(IBAction)systemInfoCommand
{
	[self commandCommand];
	[commandView systemInformation];
}

-(IBAction)navigateAction
{
	[self commandCommand];
	[commandView shortRangeChart];
}

-(IBAction)fileCommand{
}

-(IBAction)gameCommand{
	if (gameView == 0)
		gameView = [[gameViewController alloc] initWithNibName:@"game" bundle:nil];
	
	NSArray* arr = [NSArray arrayWithObjects:gameView, nil];	
	self.navigationController.viewControllers = arr;
	
	//[gameView release];
}

-(IBAction)helpCommand{
	if (helpWindow == 0)
		helpWindow	= [[UIViewController alloc] initWithNibName:@"help" bundle:nil];
	
	NSArray* arr = [NSArray arrayWithObjects:helpWindow, nil];	
	self.navigationController.viewControllers = arr;
	
//	[helpWindow release];
}

-(void)dealloc {
	[window release];
	[super dealloc];
}

-(IBAction) startNewGame 
{
	if (newGame == 0)
		newGame = [[startGameViewController alloc] initWithNibName:@"startView" bundle:nil];
	//[self.navigationController pushViewController:newGame animated:TRUE];
	NSArray* arr = [NSArray arrayWithObjects:newGame, nil];	
	self.navigationController.viewControllers = arr;
	
//	[newGame release];

}

-(IBAction) loadGame
{	
	if (saveGame == 0)
		saveGame = [[SaveGameViewController alloc] initWithNibName:@"saveGames" bundle:nil];
	isGameLoaded = true;
	//[self.navigationController pushViewController:saveGame animated:TRUE];	
	NSArray* arr = [NSArray arrayWithObjects:saveGame, nil];	
	self.navigationController.viewControllers = arr;
	
//	[saveGame release];
}

-(IBAction) help
{
	if (helpWindow == 0)
		helpWindow	= [[HelpViewControllerRENAME alloc] initWithNibName:@"help" bundle:nil];
	[self.navigationController pushViewController:helpWindow animated:TRUE];
//	[helpView release];
	
}


/*
- (IBAction)click:(id)sender {

	UIViewController * targetViewController = [[startGameViewController alloc] initWithNibName:@"startView" bundle:nil];
	[[self tabbarController] presentModalViewController:targetViewController animated:YES];

}

- (IBAction)newGame:(id)sender {

	UIViewController * targetViewController = [[startGameViewController alloc] initWithNibName:@"startView" bundle:nil];
	[[self tabbarController] presentModalViewController:targetViewController animated:YES];
	
}
-(IBAction)newGame2 {
	UIViewController * targetViewController = [[startGameViewController alloc] initWithNibName:@"startView" bundle:nil];
	[[self tabbarController] presentModalViewController:targetViewController animated:YES];
}
*/
@end
