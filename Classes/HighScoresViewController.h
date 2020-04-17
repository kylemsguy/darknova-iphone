// 
//  HighScoresViewController.h
//
//  Copyright (C) Dead Jim Studios 2009-2010, All rights reserved.
//
// This file is part of HyperWARP.
//
// HyperWARP is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// HyperWARP is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with HyperWARP.  If not, see <http://www.gnu.org/licenses/>.
//
//

#import <UIKit/UIKit.h>


@interface HighScoresViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {

	NSMutableArray	*menuList;
	IBOutlet UITableView *tableView;
	IBOutlet UINavigationBar	*navBar;
	BOOL loadMode;

}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;

-(void)setToolbar;
-(IBAction)clearScores;
-(IBAction)closeViewAction;

@end
