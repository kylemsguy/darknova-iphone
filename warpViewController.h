#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "pricesView.h"
#import "WarpSystemInfoViewRENAME.h"

@interface warpViewController : UIViewController /* Specify a superclass (eg: NSObject or NSView) */ {
	IBOutlet pricesView * pricesViewInst;
	IBOutlet WarpSystemInfoViewRENAME * sysInfoViewInst;
}

-(IBAction) showSystemInformation;
-(IBAction) showPricesInformation;
-(IBAction) showShortRangeChart;
-(IBAction) doWarp;
-(IBAction) nextPlanet;
-(IBAction) prevPlanet;
@end
