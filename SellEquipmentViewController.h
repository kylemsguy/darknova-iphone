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

@interface SellEquipmentViewController : UIViewController  {

	IBOutlet UILabel *  weaponName0;
	IBOutlet UILabel *  weaponName1;
	IBOutlet UILabel *  weaponName2;	
	IBOutlet UILabel *  weaponPrice0;
	IBOutlet UILabel *  weaponPrice1;
	IBOutlet UILabel *  weaponPrice2;
	IBOutlet UIButton *  weaponSell0;
	IBOutlet UIButton *  weaponSell1;
	IBOutlet UIButton *  weaponSell2;


	IBOutlet UILabel *  shieldName0;
	IBOutlet UILabel *  shieldName1;
	IBOutlet UILabel *  shieldName2;	
	IBOutlet UILabel *  shieldPrice0;
	IBOutlet UILabel *  shieldPrice1;
	IBOutlet UILabel *  shieldPrice2;
	IBOutlet UIButton *  shieldSell0;
	IBOutlet UIButton *  shieldSell1;
	IBOutlet UIButton *  shieldSell2;

	IBOutlet UILabel *  gadgetName0;
	IBOutlet UILabel *  gadgetName1;
	IBOutlet UILabel *  gadgetName2;	
	IBOutlet UILabel *  gadgetPrice0;
	IBOutlet UILabel *  gadgetPrice1;
	IBOutlet UILabel *  gadgetPrice2;
	IBOutlet UIButton *  gadgetSell0;
	IBOutlet UIButton *  gadgetSell1;
	IBOutlet UIButton *  gadgetSell2;
	
	IBOutlet UILabel * noWeapons;
	IBOutlet UILabel * noShield;
	IBOutlet UILabel * noGadgets;
	IBOutlet UILabel * cash;
	
	int numSellItem;
}

-(IBAction) sellWeapon0;
-(IBAction) sellWeapon1;
-(IBAction) sellWeapon2;

-(IBAction) sellShield0;
-(IBAction) sellShield1;
-(IBAction) sellShield2;

-(IBAction) sellGadget0;
-(IBAction) sellGadget1;
-(IBAction) sellGadget2;

@end
