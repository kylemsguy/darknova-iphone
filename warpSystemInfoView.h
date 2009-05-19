#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface warpSystemInfoView : UIView /* Specify a superclass (eg: NSObject or NSView) */ {
	IBOutlet	UILabel*	systemName;
	IBOutlet	UILabel*	systemSize;
	IBOutlet	UILabel*	systemTechLevel;
	IBOutlet	UILabel*	systemGoverment;
	IBOutlet	UILabel*	systemDistance;
	IBOutlet	UILabel*	systemPolice;	
	IBOutlet	UILabel*	systemPirates;
	IBOutlet	UILabel*	systemMessage;
	IBOutlet	UILabel*	systemCost;	
	IBOutlet	UIButton*	specific;
}

-(IBAction) pressSpecific;
-(void) UpdateView;

@end
