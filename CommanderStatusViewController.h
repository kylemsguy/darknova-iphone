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

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SpecialCargoView.h"
#import "ShipView.h"
#import "QuestView.h"
#import "StatusView.h"

@interface CommanderStatusViewController : UIViewController {
	IBOutlet ShipView * shipViewInst;
	IBOutlet StatusView * statusViewInst;
	IBOutlet QuestView * questViewInst;
	IBOutlet SpecialCargoView *  specialCargoViewInst;
}

@property (nonatomic, retain) ShipView * shipViewInst;
@property (nonatomic, retain) StatusView * statusViewInst;
@property (nonatomic, retain) QuestView * questViewInst;
@property (nonatomic, retain) SpecialCargoView *  specialCargoViewInst;

-(IBAction) quests;
-(IBAction) ship;
-(IBAction) specialCargo;
-(IBAction) status;

@end
