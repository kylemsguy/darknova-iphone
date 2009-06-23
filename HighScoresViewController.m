#import "HighScoresViewController.h"
#import "S1AppDelegate.h"
#import "player.h"
static NSString *kCellIdentifier = @"MyIdentifier1";

@implementation HighScoresViewController

- (void)awakeFromNib
{	
	// construct the array of page descriptions we will use (each desc is a dictionary)
	//
	menuList = [[NSMutableArray alloc] init];
	self.title =@"High Scores";
	
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	[app.gamePlayer fillHighScores:menuList];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		self.awakeFromNib;
	}
	return self;
}


#pragma mark UIViewController delegate methods

- (void)viewWillAppear:(BOOL)animated
{
	// this UIViewController is about to re-appear, make sure we remove the current selection in our table view
	NSIndexPath *tableSelection = [tableView indexPathForSelectedRow];
	[tableView deselectRowAtIndexPath:tableSelection animated:NO];
}


#pragma mark UITableView delegate methods

// decide what kind of accesory view (to the far right) we will use
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellAccessoryNone;
}

// tell our table how many sections or groups it will have (always 1 in our case)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [menuList count] ? [menuList count] : 1;
}

// the table's selection has changed, switch to that item's UIViewController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}



#pragma mark UITableView datasource methods

// tell our table how many rows it will have, in our case the size of our menuList
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

// tell our table what kind of cell to use and its title for the given row
- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView1 dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kCellIdentifier] autorelease];
		cell.font = [UIFont systemFontOfSize:10.0];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	if ([menuList count])
		cell.text = [[menuList objectAtIndex:indexPath.section] objectForKey:@"line"];
	else
		cell.text = @"Empty";
	
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if ([menuList count])
		return [NSString stringWithFormat:@"%i. %@", section+1, [[menuList objectAtIndex:section] objectForKey:@"title"]];
	else
		return @"Empty";
}


@end
