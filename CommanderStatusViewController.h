#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SpecialCargoView.h"
#import "ShipView.h"
#import "QuestView.h"
#import "StatusViewRENAME.h"

@interface CommanderStatusViewController : UIViewController/* Specify a superclass (eg: NSObject or NSView) */ {
	IBOutlet ShipView * shipViewInst;
	IBOutlet StatusViewRENAME * statusViewInst;
	IBOutlet QuestView * questViewInst;
	IBOutlet SpecialCargoView *  specialCargoViewInst;
}

@property (nonatomic, retain) ShipView * shipViewInst;
@property (nonatomic, retain) StatusViewRENAME * statusViewInst;
@property (nonatomic, retain) QuestView * questViewInst;
@property (nonatomic, retain) SpecialCargoView *  specialCargoViewInst;

-(IBAction) quests;
-(IBAction) ship;
-(IBAction) specialCargo;
-(IBAction) status;

@end
