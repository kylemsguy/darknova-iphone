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

@interface NewCommanderView : UIView {
    IBOutlet UILabel *difficultyLevel;
    IBOutlet UILabel *skillPoints;
    IBOutlet UILabel *pilotPointsLabel;	
    IBOutlet UILabel *fighterPointsLabel;	
    IBOutlet UILabel *traderPointsLabel;	
    IBOutlet UILabel *engineerPointsLabel;
	IBOutlet UITextField * pilotName;
	//NSMutableArray			*menuList;	
	//NSInteger totalSkillPoints;
}

- (IBAction)decDifficulty;
- (IBAction)addDifficulty;

- (IBAction)decPilotSkill;
- (IBAction)addPilotSkill;

- (IBAction)decFighterSkill;
- (IBAction)addFighterSkill;

- (IBAction)decTraderSkill;
- (IBAction)addTraderSkill;

- (IBAction)decEngineerSkill;
- (IBAction)addEngineerSkill;

-(IBAction)finishInputName;

@property (nonatomic, retain) UITextField * pilotName;
@end
