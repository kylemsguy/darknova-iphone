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

@interface BuyShipView : UIView {
    IBOutlet UIButton *ship1;
    IBOutlet UIButton *ship10;
    IBOutlet UIButton *ship2;
    IBOutlet UIButton *ship3;
    IBOutlet UIButton *ship4;
    IBOutlet UIButton *ship5;
    IBOutlet UIButton *ship6;
    IBOutlet UIButton *ship7;
    IBOutlet UIButton *ship8;
    IBOutlet UIButton *ship9;
    IBOutlet UIButton *shipInfo1;
    IBOutlet UIButton *shipInfo10;
    IBOutlet UIButton *shipInfo2;
    IBOutlet UIButton *shipInfo3;
    IBOutlet UIButton *shipInfo4;
    IBOutlet UIButton *shipInfo5;
    IBOutlet UIButton *shipInfo6;
    IBOutlet UIButton *shipInfo7;
    IBOutlet UIButton *shipInfo8;
    IBOutlet UIButton *shipInfo9;
	IBOutlet UILabel*	shipPrice1;
	IBOutlet UILabel*	shipPrice2;	
	IBOutlet UILabel*	shipPrice3;
	IBOutlet UILabel*	shipPrice4;
	IBOutlet UILabel*	shipPrice5;
	IBOutlet UILabel*	shipPrice6;
	IBOutlet UILabel*	shipPrice7;
	IBOutlet UILabel*	shipPrice8;	
	IBOutlet UILabel*	shipPrice9;
	IBOutlet UILabel*	shipPrice10;

	IBOutlet UILabel*	cash;	
	int					buyShipViewValue[MAXTRADEITEM];
	int					activeShipItem;
	
}

-(IBAction) buyShip1;
-(IBAction) buyShip2;
-(IBAction) buyShip3;
-(IBAction) buyShip4;
-(IBAction) buyShip5;
-(IBAction) buyShip6;
-(IBAction) buyShip7;
-(IBAction) buyShip8;
-(IBAction) buyShip9;
-(IBAction) buyShip10;

-(IBAction) infoShip1;
-(IBAction) infoShip2;
-(IBAction) infoShip3;
-(IBAction) infoShip4;
-(IBAction) infoShip5;
-(IBAction) infoShip6;
-(IBAction) infoShip7;
-(IBAction) infoShip8;
-(IBAction) infoShip9;
-(IBAction) infoShip10;
@end
