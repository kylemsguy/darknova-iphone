#import "BuyCargoViewController.h"

@implementation BuyCargoViewController

-(void)viewDidAppear {
	menuList = [[NSMutableArray alloc] init];	
	[menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 NSLocalizedString(@"Options1", @""), @"title",
						 nil, @"viewController",
						 nil]];	
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		// this will appear as the title in the navigation bar
		self.title = @"Buy Cargo";//NSLocalizedString(@"PageFiveTitle", @"");
		
		// this will appear above the segmented control
		//self.navigationItem.prompt = @"Buy Cargo";
	}
	[self viewDidAppear];
	return self;
}

static NSString *kCellIdentifier = @"MyIdentifier";



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
	//cell.
	
	return cell;
}
- (void)didMoveToWindow {
	[self viewDidAppear];
}
@end
