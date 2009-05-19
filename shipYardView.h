#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface shipYardView : UIView/* Specify a superclass (eg: NSObject or NSView) */ {
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
