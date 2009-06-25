#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#include "spacetrader.h"

@interface BuyCargoViewRENAME : UIView<UIAlertViewDelegate> {
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
	IBOutlet UILabel*	cargoBay;
	IBOutlet UILabel*	cash;	
	int					buyCargoViewValue[MAXTRADEITEM];
	int					activeTradeItem;
}

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
