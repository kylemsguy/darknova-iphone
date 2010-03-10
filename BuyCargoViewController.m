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
