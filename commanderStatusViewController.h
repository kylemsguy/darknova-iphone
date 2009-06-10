#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "specialCargoView.h"
#import "shipView.h"
#import "questView.h"
#import "statusView.h"

@interface commanderStatusViewController : UIViewController/* Specify a superclass (eg: NSObject or NSView) */ {
	IBOutlet shipView * shipViewInst;
	IBOutlet statusView * statusViewInst;
	IBOutlet questView * questViewInst;
	IBOutlet specialCargoView *  specialCargoViewInst;
}

@property (nonatomic, retain) shipView * shipViewInst;
@property (nonatomic, retain) statusView * statusViewInst;
@property (nonatomic, retain) questView * questViewInst;
@property (nonatomic, retain) specialCargoView *  specialCargoViewInst;

-(IBAction) quests;
-(IBAction) ship;
-(IBAction) specialCargo;
-(IBAction) status;

@end
