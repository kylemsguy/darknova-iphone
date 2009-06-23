#import "optionsViewController.h"
#import "S1AppDelegate.h"
#import "Player.h"
#import "OptionsCell.h"
#import "S1AppDelegate.h"
#import "Player.h"

@implementation optionsViewController

- (void)viewDidLoad {
	
    [super viewDidLoad];
}

#pragma mark Table view methods

// decide what kind of accesory view (to the far right) we will use
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellAccessoryNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0)
		return 2;
	else
		if (section == 1)
		return 14;
	else
		return 0;
	
}

- (void)optionsChanged:(NSInteger)id valueInt:(int)value {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	app.gamePlayer.leaveEmpty = value;
}

- (void)optionsChanged:(NSInteger)id value:(bool)value {
	
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];

	switch(id){
		case 0:
			if (value)
				[app.gamePlayer enableMusic];
			else
				[app.gamePlayer disableMusic];
			break;
		case 1:
			if (value)
				[app.gamePlayer enableSound];
			else
				[app.gamePlayer disableSound];
			break;
			
		case 2:
			app.gamePlayer.alwaysIgnorePolice = value;
			break;
		case 3:
			app.gamePlayer.alwaysIgnorePirates = value;
			break;
		case 4:
			app.gamePlayer.alwaysIgnoreTraders = value;
			break;
		case 5:
			app.gamePlayer.alwaysIgnoreTradeInOrbit = value;
			break;
		case 6:
			app.gamePlayer.autoFuel = value;
			break;
		case 7:
			app.gamePlayer.autoRepair = value;
			break;
		case 8:
			app.gamePlayer.reserveMoney = value;
			break;
		case 9:
			app.gamePlayer.autoAttack = value;
			break;
		case 10:
			app.gamePlayer.autoFlee= value;
			break;
		case 12:
			app.gamePlayer.newsAutoPay= value;
			break;
		case 13:
			app.gamePlayer.showTrackedRange= value;
			break;		
		case 14:
			app.gamePlayer.trackAutoOff= value;
			break;		
		case 15:
			app.gamePlayer.remindLoans = value;
			break;		
			
			
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];

    OptionsCell *cell = (OptionsCell*)[tableView dequeueReusableCellWithIdentifier:oDisplayCell_ID];
    if (cell == nil) {
        cell = [[[OptionsCell alloc] initWithFrame:CGRectZero reuseIdentifier:oDisplayCell_ID] autorelease];
    }
	[cell setDelegate:self num:indexPath.row + indexPath.section*2];	
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			cell.comment.text = @"Enable music";
			[cell setBool:[app.gamePlayer isMusicEnabled]];			
		} else {
			cell.comment.text = @"Enable sound";
			[cell setBool:[app.gamePlayer isSoundEnabled]];
			
		}

	} else {
		switch(indexPath.row) {
			case 0:
				cell.comment.text = @"Always ignore when it safe Police";
				[cell setBool:app.gamePlayer.alwaysIgnorePolice];
				break;
			case 1:
				cell.comment.text = @"Always ignore when it safe Pirates";
				[cell setBool:app.gamePlayer.alwaysIgnorePirates];
				break;
			case 2:
				cell.comment.text = @"Always ignore when it safe Traders";
				[cell setBool:app.gamePlayer.alwaysIgnoreTraders];				
				break;
			case 3:
				cell.comment.text = @"Ignore dealing traders";
				[cell setBool:app.gamePlayer.alwaysIgnoreTradeInOrbit];				
				break;
			case 4:
				cell.comment.text = @"Get full tank on arrival";
				[cell setBool:app.gamePlayer.autoFuel];				
				break;
			case 5:
				cell.comment.text = @"Get full hull repair on arrival";
				[cell setBool:app.gamePlayer.autoRepair];				
				break;
			case 6:
				cell.comment.text = @"Reserve money for warp costs";
				[cell setBool:app.gamePlayer.reserveMoney];				
				break;
			case 7:
				cell.comment.text = @"Continuous attack and flight";
				[cell setBool:app.gamePlayer.autoAttack];				
				break;
			case 8:
				cell.comment.text = @"Continue attacking fleeing ship";
				[cell setBool:app.gamePlayer.autoFlee];				
				break;
			case 9:
				cell.comment.text = @"Cargo bays to leave empty";
				[cell setInt:app.gamePlayer.leaveEmpty];				
				break;
			case 10:
				cell.comment.text = @"Always pay for newspaper";
				[cell setBool:app.gamePlayer.newsAutoPay];
				break;
			case 11:
				cell.comment.text = @"Show range to tracked system";
				[cell setBool:app.gamePlayer.showTrackedRange];
				break;
			case 12:
				cell.comment.text = @"Stop tracking on arrival";
				[cell setBool:app.gamePlayer.trackAutoOff];
				break;
			case 13:
				cell.comment.text = @"Remind about loans";
				[cell setBool:app.gamePlayer.remindLoans];
				break;
				
				
		}
		
		
	}

    /*
	cell.nameLabel.text = [menuName objectAtIndex:indexPath.row];// objectForKey:@"title"];
	cell.infoLabel.text = [menuListAdditional objectAtIndex:indexPath.row];// objectForKey:@"title"];
	 */
	
    // Set up the cell...
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 0)
		return @"Sound options";
	else
		if (section == 1)
		return @"Game options";
	else
		return @" ";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	
}

@end
