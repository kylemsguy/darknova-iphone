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

@interface ShipYardView : UIView {
	IBOutlet UILabel*	fuelAmount;
	IBOutlet UILabel*	fuelCost;
	IBOutlet UILabel*	hullStrength;
	IBOutlet UILabel*	needRepairs;
	IBOutlet UILabel*	newShipsInfo;
	IBOutlet UILabel*	escapePod;
	
	IBOutlet UIButton*	buyFuel;
	IBOutlet UIButton*	buyFullTank;
	IBOutlet UIButton*	buyRepair;
	IBOutlet UIButton*	buyFullRepair;
	IBOutlet UILabel*	totalCash;
	
	IBOutlet UIButton*	buyEscapePod;
	IBOutlet UIButton*  shipInfo;
	IBOutlet UIButton*  buyNewShip;	
	int mode;
}


/*
@property  UILabel*	fuelAmount;
@property  UILabel*	fuelCost;
@property  UILabel*	hullStrength;
@property  UILabel*	needRepairs;
@property  UILabel*	newShipsInfo;
@property  UILabel*	escapePod;
@property  UIButton*	buyFuel;
@property  UIButton*	buyFullTank;
@property  UIButton*	buyRepair;
@property  UIButton*	buyFullRepair;
@property  UIButton*	buyEscapePod;
@property  UILabel*	totalCash;
*/
-(IBAction) buyFuel;
-(IBAction) buyFullFuel;
-(IBAction) buyRepair;
-(IBAction) buyFullRepair;
-(IBAction) buyNewShip;
-(IBAction) buyEscapePod;
-(IBAction) shipInfo;

@end
