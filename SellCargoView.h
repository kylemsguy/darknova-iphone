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
#include "spacetrader.h"

@interface SellCargoView : UIView {
    IBOutlet UIButton *cargo1;
    IBOutlet UIButton *cargo10;
    IBOutlet UIButton *cargo2;
    IBOutlet UIButton *cargo3;
    IBOutlet UIButton *cargo4;
    IBOutlet UIButton *cargo5;
    IBOutlet UIButton *cargo6;
    IBOutlet UIButton *cargo7;
    IBOutlet UIButton *cargo8;
    IBOutlet UIButton *cargo9;
    IBOutlet UIButton *maxCargo1;
    IBOutlet UIButton *maxCargo10;
    IBOutlet UIButton *maxCargo2;
    IBOutlet UIButton *maxCargo3;
    IBOutlet UIButton *maxCargo4;
    IBOutlet UIButton *maxCargo5;
    IBOutlet UIButton *maxCargo6;
    IBOutlet UIButton *maxCargo7;
    IBOutlet UIButton *maxCargo8;
    IBOutlet UIButton *maxCargo9;
	IBOutlet UILabel*	cargoPrice1;
	IBOutlet UILabel*	cargoPrice2;	
	IBOutlet UILabel*	cargoPrice3;
	IBOutlet UILabel*	cargoPrice4;
	IBOutlet UILabel*	cargoPrice5;
	IBOutlet UILabel*	cargoPrice6;
	IBOutlet UILabel*	cargoPrice7;
	IBOutlet UILabel*	cargoPrice8;	
	IBOutlet UILabel*	cargoPrice9;
	IBOutlet UILabel*	cargoPrice10;
	
	IBOutlet UILabel*	cargoName1;
	IBOutlet UILabel*	cargoName2;	
	IBOutlet UILabel*	cargoName3;
	IBOutlet UILabel*	cargoName4;
	IBOutlet UILabel*	cargoName5;
	IBOutlet UILabel*	cargoName6;
	IBOutlet UILabel*	cargoName7;
	IBOutlet UILabel*	cargoName8;	
	IBOutlet UILabel*	cargoName9;
	IBOutlet UILabel*	cargoName10;
	
	IBOutlet UILabel*	cargoBay;
	IBOutlet UILabel*	cash;	
	IBOutlet UINavigationBar * navigationBar;
	int					sellCargoViewValue[MAXTRADEITEM];
	int					activeTradeItem;
	bool bJettison;
	bool bOpponent;
}

-(void)setJettisonType;
-(void) setOpponentType;
-(IBAction) pressCargo1;
-(IBAction) pressCargo2;
-(IBAction) pressCargo3;
-(IBAction) pressCargo4;
-(IBAction) pressCargo5;
-(IBAction) pressCargo6;
-(IBAction) pressCargo7;
-(IBAction) pressCargo8;
-(IBAction) pressCargo9;
-(IBAction) pressCargo10;
-(IBAction) pressMaxCargo1;
-(IBAction) pressMaxCargo2;
-(IBAction) pressMaxCargo3;
-(IBAction) pressMaxCargo4;
-(IBAction) pressMaxCargo5;
-(IBAction) pressMaxCargo6;
-(IBAction) pressMaxCargo7;
-(IBAction) pressMaxCargo8;
-(IBAction) pressMaxCargo9;
-(IBAction) pressMaxCargo10;
@end
