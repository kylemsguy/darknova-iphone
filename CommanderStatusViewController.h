#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SpecialCargoView.h"
#import "ShipViewRENAME.h"
#import "questView.h"
#import "statusView.h"

@interface CommanderStatusViewController : UIViewController/* Specify a superclass (eg: NSObject or NSView) */ {
	IBOutlet ShipViewRENAME * shipViewInst;
	IBOutlet statusView * statusViewInst;
	IBOutlet questView * questViewInst;
	IBOutlet SpecialCargoView *  specialCargoViewInst;
}

@property (nonatomic, retain) ShipViewRENAME * shipViewInst;
@property (nonatomic, retain) statusView * statusViewInst;
@property (nonatomic, retain) questView * questViewInst;
@property (nonatomic, retain) SpecialCargoView *  specialCargoViewInst;

-(IBAction) quests;
-(IBAction) ship;
-(IBAction) specialCargo;
-(IBAction) status;

@end
