#import "GameViewControllerRENAME.h"
#import "S1AppDelegate.h"
#import "Player.h"
#import "SaveGameViewController.h"
#import "OptionsViewController.h"
#import "HelpViewController.h"
#import "S1AppDelegate.h"
#import "Player.h"
#import "HighScoresViewController.h"

@implementation GameViewControllerRENAME

@synthesize myTableView;

static NSString *kCellIdentifier = @"MyIdentifier";


- (void)awakeFromNib
{	
	// construct the array of page descriptions we will use (each desc is a dictionary)
	//
	menuList = [[NSMutableArray alloc] init];

	OptionsViewController *optionsViewControllerInst = [[[OptionsViewController alloc] initWithNibName:@"options1" bundle:nil] autorelease];
	UIViewController *saveGameViewController = [[[SaveGameViewController alloc] initWithNibName:@"saveGames" bundle:nil] autorelease];
	UIViewController *helpViewControllerInst = [[[HelpViewController alloc] initWithNibName:@"help" bundle:nil] autorelease];
	UIViewController *highScores = [[[HighScoresViewController alloc] initWithNibName:@"highScores" bundle:nil] autorelease];
	
	[menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 NSLocalizedString(@"Options", @""), @"title",
						 optionsViewControllerInst, @"viewController",
						 nil]];
	
	[menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 NSLocalizedString(@"Save Game", @""), @"title",
						 saveGameViewController, @"viewController",
						 nil]];

	[menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 NSLocalizedString(@"Load Game", @""), @"title",
						 saveGameViewController, @"viewController",
						 nil]];
	
	[menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 NSLocalizedString(@"Help", @""), @"title",
						 helpViewControllerInst, @"viewController",
						 nil]];	
	
	[menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 NSLocalizedString(@"Retire", @""), @"title",
						 nil, @"viewController",
						 nil]];	

	[menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 NSLocalizedString(@"High Scores", @""), @"title",
						 highScores, @"viewController",
						 nil]];	
	
/*	[menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 NSLocalizedString(@"Clear High Scores", @""), @"title",
						 nil, @"viewController",
						 nil]];	
*/
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		self.title = @"Game";//NSLocalizedString(@"PageFiveTitle", @"");
		self.awakeFromNib;
	}
	return self;
}
	
- (void)dealloc
{
	[menuList release];
	[myTableView release];
	
	[super dealloc];
}


#pragma mark UIViewController delegate methods

- (void)viewWillAppear:(BOOL)animated
{
	// this UIViewController is about to re-appear, make sure we remove the current selection in our table view
	NSIndexPath *tableSelection = [myTableView indexPathForSelectedRow];
	[myTableView deselectRowAtIndexPath:tableSelection animated:NO];
}


#pragma mark UITableView delegate methods

// decide what kind of accesory view (to the far right) we will use
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellAccessoryDisclosureIndicator;
}

// tell our table how many sections or groups it will have (always 1 in our case)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex  // after animation
{
	if (buttonIndex == 1) {
		S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
		[app.gamePlayer showRetiredForm];
	}
}
// the table's selection has changed, switch to that item's UIViewController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

	switch(indexPath.row) {
		case 0:  {
			OptionsViewController *targetViewController = (OptionsViewController*)[[menuList objectAtIndex: indexPath.row] objectForKey:@"viewController"];
			[[self navigationController] pushViewController:targetViewController animated:YES];
			
		}	
		break;
		case 1:{
					SaveGameViewController *targetViewController = (SaveGameViewController *)[[menuList objectAtIndex: indexPath.row] objectForKey:@"viewController"];
					[[self navigationController] pushViewController:targetViewController animated:YES];		
					[targetViewController setSaveGameMode];
				}
			break;
		case 2:
				{
					SaveGameViewController *targetViewController = (SaveGameViewController *)[[menuList objectAtIndex: indexPath.row] objectForKey:@"viewController"];
					[[self navigationController] pushViewController:targetViewController animated:YES];		
					[targetViewController setLoadGameMode];		
				}
			break;
		case 3: 
		{
			UIViewController *targetViewController = (UIViewController *)[[menuList objectAtIndex: indexPath.row] objectForKey:@"viewController"];
			[[self navigationController] pushViewController:targetViewController animated:YES];		
			
		}
			break;
		case 4:
		{	

			UIAlertView *alert=[[[UIAlertView alloc] initWithTitle:@"Retire" message:@"Are you really want to retire?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil] autorelease];
			[alert show];	
		}
			break;
		case 5: 
		{
			HighScoresViewController *targetViewController = (HighScoresViewController *)[[menuList objectAtIndex: indexPath.row] objectForKey:@"viewController"];
			[[self navigationController] pushViewController:targetViewController animated:YES];		
			
		}
			break;
/*  commented this out until issue 18 can properly be addressed
 case 6:
		{
			
		}
			break;
 */
	}
}
 
  

#pragma mark UITableView datasource methods

// tell our table how many rows it will have, in our case the size of our menuList
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [menuList count];
}

// tell our table what kind of cell to use and its title for the given row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kCellIdentifier] autorelease];
	}
	
	cell.text = [[menuList objectAtIndex:indexPath.row] objectForKey:@"title"];
	
	return cell;
}



@end
