#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "PricesView.h"
#import "WarpSystemInfoView.h"

@interface WarpViewController : UIViewController  {
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
