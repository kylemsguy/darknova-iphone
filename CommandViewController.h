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

#import "BuyCargoViewController.h"
#import "CommanderStatusViewController.h"
#import "BankViewController.h"
#import "SellCargoViewController.h"
#import "ShipYardViewController.h"
#import "SellEquipmentViewController.h"
#import "BuyEquipmentViewController.h"
#import "SystemInfoViewController.h"
#import "PersonellRosterViewController.h"
#import "ShortRangeChartViewController.h"
#import "GalacticChartViewController.h"

@interface CommandViewController : UIViewController  {

	BuyCargoViewController * buyCargoViewControllerImpl;
	SellCargoViewController * sellCargoViewControllerImpl;
	ShipYardViewController * shipYardViewControllerImpl;
	BuyEquipmentViewController * buyEquipmentViewControllerImpl;
	SellEquipmentViewController * sellEquipmentViewControllerImpl;
	PersonellRosterViewController * personellRosterViewControllerImpl;
	BankViewController * bankViewControllerImpl;
	SystemInfoViewController * SystemInfoViewControllerImpl;
	CommanderStatusViewController * commanderStatusViewControllerImpl;
	GalacticChartViewController * galacticChartViewControllerImpl;
	ShortRangeChartViewController * shortRangeChartViewControllerImpl;
}

-(IBAction) buyCargo;
-(IBAction) sellCargo;
-(IBAction) shipYard;
-(IBAction) buyEquipment;
-(IBAction) sellEquipment;
-(IBAction) personellRoster;
-(IBAction) bank;
-(IBAction) systemInformation;
-(IBAction) commanderStatus;
-(IBAction) galacticChart;
-(IBAction) shortRangeChart;
//-(id)init;
@end
