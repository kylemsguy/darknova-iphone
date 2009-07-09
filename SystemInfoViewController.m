#import "SystemInfoViewController.h"
#import "S1AppDelegate.h"
#import "Player.h"
#import "CommandViewController.h"
#import "NewsViewController.h"
@implementation SystemInfoViewController



-(void) UpdateView {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	

	NSString *systemInfoTemplatePath = [[NSBundle mainBundle] pathForResource:@"SystemInfoTemplate" ofType:@"txt"];  
	NSString *systemInfoTemplateText = [NSString stringWithContentsOfFile:systemInfoTemplatePath];  
	NSString* htmlContent = [NSString stringWithFormat:systemInfoTemplateText,	[app.gamePlayer getCurrentSystemName],
																				[app.gamePlayer getCurrentSystemSize],
																				[app.gamePlayer getCurrentSystemTechLevel],
																				[app.gamePlayer getCurrentSystemPolitics],
																				[app.gamePlayer getCurrentSystemSpecalResources],
																				[app.gamePlayer getCurrentSystemPolice],
																				[app.gamePlayer getCurrentSystemPirates]];
//	[app.gamePlayer getCurrentSystem

    [systemInfoContent setBackgroundColor: [UIColor clearColor]];
    [systemInfoContent loadHTMLString:htmlContent baseURL:nil];
	
	if ([app.gamePlayer IsNewsExist]) {
		[self.view addSubview:systemNews];
	} else {
		[ systemNews removeFromSuperview];
	}
		
	if ([app.gamePlayer IsHireExist]) {
		[self.view addSubview:systemHire];
	} else {
		[ systemHire removeFromSuperview];
	}
		
	if ([app.gamePlayer IsSpecialExist]) {
		[self.view addSubview:systemSpecial];
	} else {
		[ systemSpecial removeFromSuperview];
	}
		
	
	
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
	NSLog(@"doQuests");
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
	NSLog(@"showSpecial");
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	[app.gamePlayer showSpecialEvent]; //	[app commandCommand];
	[app.gamePlayer setInfoViewController:self];
	[self UpdateView];
}


@end
