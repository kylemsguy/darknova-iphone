#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "PricesViewRENAME.h"
#import "WarpSystemInfoView.h"

@interface warpViewController : UIViewController /* Specify a superclass (eg: NSObject or NSView) */ {
	IBOutlet PricesViewRENAME * pricesViewInst;
	IBOutlet WarpSystemInfoView * sysInfoViewInst;
}

-(IBAction) showSystemInformation;
-(IBAction) showPricesInformation;
-(IBAction) showShortRangeChart;
-(IBAction) doWarp;
-(IBAction) nextPlanet;
-(IBAction) prevPlanet;
@end
