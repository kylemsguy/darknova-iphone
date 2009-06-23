#import "SaveGameViewController.h"
#import "S1AppDelegate.h"
#import "Player.h"
#import "FileSaveCell.h"


@implementation SaveGameViewController



- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = NSLocalizedString(@"Load Saved Game", @"");
	
	menuList = [[NSMutableArray alloc] init];
	menuListAdditional = [[NSMutableArray alloc] init];
	menuName = [[NSMutableArray alloc] init];	
	
	loadMode = true;
	
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) dealloc
{
	[menuList dealloc];
	[menuListAdditional dealloc];
	[menuName dealloc];
	[super dealloc];
}


-(void)UpdateTable
{
	[menuName removeAllObjects];	
	[menuList removeAllObjects];
	[menuListAdditional removeAllObjects];	
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	[app.gamePlayer ShowSaveGames:menuList name:menuName additional:menuListAdditional];
	[self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	self.tableView.rowHeight = 60;

	[self UpdateTable];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

// decide what kind of accesory view (to the far right) we will use
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellAccessoryDisclosureIndicator;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0)
	return [menuList count];
	
	return 0;
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    FileSaveCell *cell = (FileSaveCell*)[tableView dequeueReusableCellWithIdentifier:kDisplayCell_ID];
    if (cell == nil) {
        cell = [[[FileSaveCell alloc] initWithFrame:CGRectZero reuseIdentifier:kDisplayCell_ID] autorelease];
    }
    
	cell.nameLabel.text = [menuName objectAtIndex:indexPath.row];// objectForKey:@"title"];
	cell.infoLabel.text = [menuListAdditional objectAtIndex:indexPath.row];// objectForKey:@"title"];
	
    // Set up the cell...
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 0)
	return @"Saved Games";
	
	return @" ";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//	UIViewController *targetViewController = [[menuList objectAtIndex: indexPath.row] objectForKey:@"viewController"];
//	[[self navigationController] pushViewController:targetViewController animated:YES];
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	activeSaveNumber = indexPath.row;
	if (loadMode) {
		[self.view removeFromSuperview];
		//[app.navigationController popViewControllerAnimated:YES];			
		[app.gamePlayer LoadGame:[menuList objectAtIndex:indexPath.row]];

	}
	else {
		[app.gamePlayer SaveGame:[menuList objectAtIndex:indexPath.row]];
		[app.navigationController popViewControllerAnimated:YES];
	}

	
}

-(void)setSaveGameMode
{
	self.title =@"Save Game";
	loadMode = false;	
	UIBarButtonItem *systemItem = [[[UIBarButtonItem alloc]
								   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
								   target:self action:@selector(action:)] autorelease];
	self.navigationItem.rightBarButtonItem = systemItem;
	[self UpdateTable];
}

- (void)action:(id)sender
{
	activeSaveNumber = [self.tableView  numberOfRowsInSection:0];
	//self.view.backgroundColor = [UIColor colorWithRed: 1.0f green:0.45f blue:0.45f alpha:1.0f];
	NSString * newName = [NSString stringWithFormat:@"%i", activeSaveNumber];
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	[app.gamePlayer SaveGame:newName];
	[app.navigationController popViewControllerAnimated:YES];	
	[self UpdateTable];
}

-(void)setLoadGameMode
{
	loadMode = true;
	self.title =@"Load Game";
	self.navigationItem.rightBarButtonItem = nil;
}



@end
