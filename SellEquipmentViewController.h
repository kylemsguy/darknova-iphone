#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SellEquipmentViewController : UIViewController /* Specify a superclass (eg: NSObject or NSView) */ {

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
