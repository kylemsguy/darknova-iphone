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

@interface BuyEquipmentViewController : UIViewController {
	IBOutlet UILabel * equipmentName0;
	IBOutlet UILabel * equipmentName1;
	IBOutlet UILabel * equipmentName2;
	IBOutlet UILabel * equipmentName3;
	IBOutlet UILabel * equipmentName4;	
	IBOutlet UILabel * equipmentName5;
	IBOutlet UILabel * equipmentName6;
	IBOutlet UILabel * equipmentName7;
	IBOutlet UILabel * equipmentName8;
	IBOutlet UILabel * equipmentName9;
	IBOutlet UIButton * buy0;
	IBOutlet UIButton * buy1;
	IBOutlet UIButton * buy2;
	IBOutlet UIButton * buy3;
	IBOutlet UIButton * buy4;
	IBOutlet UIButton * buy5;
	IBOutlet UIButton * buy6;
	IBOutlet UIButton * buy7;
	IBOutlet UIButton * buy8;
	IBOutlet UIButton * buy9;
	IBOutlet UILabel * equipmentPrice0;
	IBOutlet UILabel * equipmentPrice1;
	IBOutlet UILabel * equipmentPrice2;
	IBOutlet UILabel * equipmentPrice3;
	IBOutlet UILabel * equipmentPrice4;
	IBOutlet UILabel * equipmentPrice5;
	IBOutlet UILabel * equipmentPrice6;
	IBOutlet UILabel * equipmentPrice7;
	IBOutlet UILabel * equipmentPrice8;
	IBOutlet UILabel * equipmentPrice9;
	IBOutlet UILabel * cash;
}

-(IBAction) pressBuy0;
-(IBAction) pressBuy1;
-(IBAction) pressBuy2;
-(IBAction) pressBuy3;
-(IBAction) pressBuy4;
-(IBAction) pressBuy5;
-(IBAction) pressBuy6;
-(IBAction) pressBuy7;
-(IBAction) pressBuy8;
-(IBAction) pressBuy9;
-(void) UpdateView;

@end
