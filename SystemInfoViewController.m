#import "SystemInfoViewController.h"
#import "S1AppDelegate.h"
#import "Player.h"
#import "CommandViewController.h"
#import "NewsViewController.h"
@implementation SystemInfoViewController

/*@synthesize	systemName;
@synthesize	systemSize;
@synthesize	systemTechLevel;
@synthesize	systemGoverment;
@synthesize	systemResources;
@synthesize	systemPolice;	
@synthesize	systemPirates;
@synthesize	systemMessage;	*/


-(IBAction)testClick {
//	UIViewController * targetViewController = [[UIViewController alloc] initWithNibName:@"startView" bundle:nil];
//	[[self navigationController] presentModalViewController:targetViewController animated:YES];		
}

-(void) UpdateView {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	systemName.text = [app.gamePlayer getCurrentSystemName];
	systemSize.text = [app.gamePlayer getCurrentSystemSize];
	systemTechLevel.text = [app.gamePlayer getCurrentSystemTechLevel];	
	systemGoverment.text = [app.gamePlayer getCurrentSystemPolitics];	
	systemPirates.text = [app.gamePlayer getCurrentSystemPirates];
	systemPolice.text = [app.gamePlayer getCurrentSystemPolice];
	systemResources.text = [app.gamePlayer getCurrentSystemSpecalResources];
	systemMessage.text = [app.gamePlayer drawNewspaperForm];
	
	/*if ([app.gamePlayer IsNewsExist])
	{
		[self.view addSubview:systemNews];
	}
	else*/
		[ systemNews removeFromSuperview];
		
	if ([app.gamePlayer IsHireExist])
	{
		[self.view addSubview:systemHire];
	}
	else
		[ systemHire removeFromSuperview];

	if ([app.gamePlayer IsSpecialExist])
	{
		[self.view addSubview:systemSpecial];
	}
	else
		[ systemSpecial removeFromSuperview];
	
	
}

- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
	[self UpdateView];
}

- (void)loadView
{
	[super loadView];
	[self UpdateView];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		self.title = @"System Info";				
	}

	
	return self;
}

-(IBAction)doQuests
{
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	[app.gamePlayer drawQuestsForm:self];
}

-(void)showNewsView
{	
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	[app.gamePlayer payForNewsPaper:1];
	NewsViewController * targetViewController = [[NewsViewController alloc] initWithNibName:@"news"  bundle:nil];
	[self.navigationController pushViewController:targetViewController animated:YES];
	targetViewController.text.text = [app.gamePlayer drawNewspaperForm];
	[targetViewController release];
}


-(IBAction)showNews
{
	
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	if (!app.gamePlayer.alreadyPaidForNewspaper && [app.gamePlayer toSpend] < (app.gamePlayer.gameDifficulty + 1))
		[app.gamePlayer FrmAlert:@"CantAffordPaperAlert"];
		else {
			if (!app.gamePlayer.newsAutoPay && !app.gamePlayer.alreadyPaidForNewspaper) {
				UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"Buy newspaper?" message:[NSString stringWithFormat:@"The local newspaper costs %i credits. Do you wish to buy a copy?", 
																									 app.gamePlayer.gameDifficulty + 1] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Buy", nil] autorelease];
				[alert show];
			} else 
				[self showNewsView];
	}
}


/*-(void)dealloc
{
	self.systemName = nil;
	self.systemSize = nil;
	self.systemTechLevel = nil;
	self.systemGoverment = nil;
	self.systemResources = nil;
	self.systemPolice = nil;	
	self.systemPirates = nil;
	self.systemMessage = nil;	
	[super dealloc];
}*/

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex  // after animation
{
	int button = buttonIndex;
	if (button == 1)
	{
		[self showNewsView];
	}
}


-(IBAction)showHire
{
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
//	[app commandCommand];
	[app.commandView personellRoster];
}

-(IBAction)showSpecial
{
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	[app.gamePlayer showSpecialEvent]; //	[app commandCommand];
	[app.gamePlayer setInfoViewController:self];
	[self UpdateView];
}


@end
