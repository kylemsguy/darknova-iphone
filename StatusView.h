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

@interface StatusView : UIView {
	IBOutlet	UILabel*		pilotName;
	IBOutlet	UILabel*		pilotSkill;	
	IBOutlet	UILabel*		traderSkill;
	IBOutlet	UILabel*		fighterSkill;
	IBOutlet	UILabel*		engineerSkill;
	IBOutlet	UILabel*		kills;
	IBOutlet	UILabel*		time;
	IBOutlet	UILabel*		cash;
	IBOutlet	UILabel*		debt;
	IBOutlet	UILabel*		newWorth;
	IBOutlet	UILabel*		reputation;
	IBOutlet	UILabel*		policeRecord;
	IBOutlet	UILabel*		difficulty;


}


@property (nonatomic, retain) 	UILabel*		pilotName;
@property (nonatomic, retain) 	UILabel*		pilotSkill;	
@property (nonatomic, retain) 	UILabel*		traderSkill;
@property (nonatomic, retain)	UILabel*		fighterSkill;
@property (nonatomic, retain) 	UILabel*		engineerSkill;
@property (nonatomic, retain) 	UILabel*		kills;
@property (nonatomic, retain) 	UILabel*		time;
@property (nonatomic, retain) 	UILabel*		cash;
@property (nonatomic, retain) 	UILabel*		debt;
@property (nonatomic, retain)	UILabel*		newWorth;
@property (nonatomic, retain) 	UILabel*		reputation;
@property (nonatomic, retain) 	UILabel*		policeRecord;
@property (nonatomic, retain) 	UILabel*		difficulty;

-(void)UpdateView;

@end
