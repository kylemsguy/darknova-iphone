#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface statusView : UIView/* Specify a superclass (eg: NSObject or NSView) */ {
	IBOutlet	UILabel*		pilotName;
	IBOutlet	UILabel*		pilotSkill;	
	IBOutlet	UILabel*		traderSkill;
	IBOutlet	UILabel*		fighterSkill;
	IBOutlet	UILabel*		engineerSkill;
	IBOutlet	UILabel*		kills;
	IBOutlet	UILabel*		time;
	IBOutlet	UILabel*		cash;
	IBOutlet	UILabel*		debt;
	IBOutlet	UILabel*		newWorth;
	IBOutlet	UILabel*		reputation;
	IBOutlet	UILabel*		policeRecord;
	IBOutlet	UILabel*		difficulty;


}


@property (nonatomic, retain) 	UILabel*		pilotName;
@property (nonatomic, retain) 	UILabel*		pilotSkill;	
@property (nonatomic, retain) 	UILabel*		traderSkill;
@property (nonatomic, retain)	UILabel*		fighterSkill;
@property (nonatomic, retain) 	UILabel*		engineerSkill;
@property (nonatomic, retain) 	UILabel*		kills;
@property (nonatomic, retain) 	UILabel*		time;
@property (nonatomic, retain) 	UILabel*		cash;
@property (nonatomic, retain) 	UILabel*		debt;
@property (nonatomic, retain)	UILabel*		newWorth;
@property (nonatomic, retain) 	UILabel*		reputation;
@property (nonatomic, retain) 	UILabel*		policeRecord;
@property (nonatomic, retain) 	UILabel*		difficulty;

-(void)UpdateView;

@end
