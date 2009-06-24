#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "PricesView.h"
#import "WarpSystemInfoView.h"

@interface WarpViewControllerRENAME : UIViewController /* Specify a superclass (eg: NSObject or NSView) */ {
	IBOutlet PricesView * pricesViewInst;
	IBOutlet WarpSystemInfoView * sysInfoViewInst;
}

-(IBAction) showSystemInformation;
-(IBAction) showPricesInformation;
-(IBAction) showShortRangeChart;
-(IBAction) doWarp;
-(IBAction) nextPlanet;
-(IBAction) prevPlanet;
@end
