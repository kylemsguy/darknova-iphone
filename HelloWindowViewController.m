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

#import "HelloWindowViewController.h"
#import "StartGameViewController.h"
#import "S1AppDelegate.h"
#import "Player.h"
#import "SaveGameViewController.h"

@implementation HelloWindowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		// this will appear as the title in the navigation bar
		self.title = NSLocalizedString(@"Welcome to Dark Nova", @"");
		
		// this will appear above the segmented control
		//self.navigationItem.prompt = @"Please fill fields:";
	}
	
	return self;
}

-(void)dealloc {
	
	[super dealloc];
}
@end
