#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SpecialCargoView.h"
#import "ShipView.h"
#import "QuestView.h"
#import "StatusView.h"

@interface CommanderStatusViewController : UIViewController {
	IBOutlet ShipView * shipViewInst;
	IBOutlet StatusView * statusViewInst;
	IBOutlet QuestView * questViewInst;
	IBOutlet SpecialCargoView *  specialCargoViewInst;
}

@property (nonatomic, retain) ShipView * shipViewInst;
@property (nonatomic, retain) StatusView * statusViewInst;
@property (nonatomic, retain) QuestView * questViewInst;
@property (nonatomic, retain) SpecialCargoView *  specialCargoViewInst;

-(IBAction) quests;
-(IBAction) ship;
-(IBAction) specialCargo;
-(IBAction) status;

@end
