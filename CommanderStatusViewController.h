#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SpecialCargoViewRENAME.h"
#import "shipView.h"
#import "questView.h"
#import "statusView.h"

@interface CommanderStatusViewController : UIViewController/* Specify a superclass (eg: NSObject or NSView) */ {
	IBOutlet shipView * shipViewInst;
	IBOutlet statusView * statusViewInst;
	IBOutlet questView * questViewInst;
	IBOutlet SpecialCargoViewRENAME *  specialCargoViewInst;
}

@property (nonatomic, retain) shipView * shipViewInst;
@property (nonatomic, retain) statusView * statusViewInst;
@property (nonatomic, retain) questView * questViewInst;
@property (nonatomic, retain) SpecialCargoViewRENAME *  specialCargoViewInst;

-(IBAction) quests;
-(IBAction) ship;
-(IBAction) specialCargo;
-(IBAction) status;

@end
