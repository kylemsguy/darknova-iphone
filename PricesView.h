#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface PricesView : UIView<UIAlertViewDelegate>/* Specify a superclass (eg: NSObject or NSView) */ {
	IBOutlet UILabel * water;
	IBOutlet UILabel * furs;
	IBOutlet UILabel * food;
	IBOutlet UILabel * ore;	
	IBOutlet UILabel * games;
	IBOutlet UILabel * firearms;
	IBOutlet UILabel * medicine;
	IBOutlet UILabel * machines;
	IBOutlet UILabel * narcotics;	
	IBOutlet UILabel * robots;
	IBOutlet UILabel * bays;
	IBOutlet UILabel * name;	
	IBOutlet UILabel * resources;	
	IBOutlet UIButton * absolutePricesButton;		
	bool absolutePrices;
	IBOutlet UILabel * cash;
	int itemsPrice[10];
	int itemsMax[10];
	
	int activeTradeItem;
}

-(IBAction) buyWater;
-(IBAction) buyFurs;
-(IBAction) buyFood;
-(IBAction) buyOre;
-(IBAction) buyGames;
-(IBAction) buyFirearms;
-(IBAction) buyMedicine;
-(IBAction) buyMachines;
-(IBAction) buyNarcotics;
-(IBAction) buyRobots;
-(IBAction) showAbsolutePrices;

-(void)UpdateWindow;


@end
