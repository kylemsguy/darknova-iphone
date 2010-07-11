//
//  JumpStartViewController.h
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


@interface JumpStartViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
	
	
	NSMutableArray			*menuList;  
	NSMutableArray			*menuName;  	
	NSMutableArray			*menuListAdditional;  
	IBOutlet UIBarButtonItem	*addNewButton;
	IBOutlet UIBarButtonItem	*doneButton;
	IBOutlet UITableView		*myTableView;
	
	BOOL didLoadOrSave;
	BOOL isAutoSaveFile;
	BOOL loadMode;
	BOOL isEditing;
	int activeSaveNumber;
	
}

@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem	*addNewButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem	*doneButton;

-(void)setSaveGameMode;
-(void)setLoadGameMode;
-(void)setRetireMode;


@end
