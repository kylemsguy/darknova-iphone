#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "buyCargoViewController.h"
#import "CommanderStatusViewController.h"
#import "BankViewController.h"
#import "sellCargoViewController.h"
#import "shipYardViewController.h"
#import "SellEquipmentViewControllerRENAME.h"
#import "BuyEquipmentViewController.h"
#import "SystemInfoViewController.h"
#import "PersonellRosterViewController.h"
#import "ShortRangeChartViewController.h"
#import "GalacticChartViewController.h"

@interface commandViewController : UIViewController /* Specify a superclass (eg: NSObject or NSView) */ {

	buyCargoViewController * buyCargoViewControllerImpl;
	sellCargoViewController * sellCargoViewControllerImpl;
	shipYardViewController * shipYardViewControllerImpl;
	BuyEquipmentViewController * buyEquipmentViewControllerImpl;
	SellEquipmentViewControllerRENAME * sellEquipmentViewControllerImpl;
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
