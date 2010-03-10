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

#import "CommanderStatusViewController.h"


@implementation CommanderStatusViewController


@synthesize shipViewInst, statusViewInst, questViewInst, specialCargoViewInst;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		[self status];
	}
	return self;
}


- (void)awakeFromNib
{
	//self.title = @"Commander Status";	
	[self status];
}

-(IBAction) quests {
	self.title = @"Quests";
	self.view =questViewInst;
	[questViewInst update];

}

-(IBAction) ship {
	self.title = @"Ship";
	self.view = shipViewInst;
	
}

-(IBAction) specialCargo {
	self.title = @"Special Cargo";
	self.view = specialCargoViewInst;
}

-(IBAction) status {
	self.title = @"Commander";
	self.view = statusViewInst;
	[statusViewInst UpdateView];
}

@end
