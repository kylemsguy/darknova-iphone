#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NewCommanderViewRENAME : UIView {
    IBOutlet UILabel *difficultyLevel;
    IBOutlet UILabel *skillPoints;
    IBOutlet UILabel *pilotPointsLabel;	
    IBOutlet UILabel *fighterPointsLabel;	
    IBOutlet UILabel *traderPointsLabel;	
    IBOutlet UILabel *engineerPointsLabel;
	IBOutlet UITextField * pilotName;
	//NSMutableArray			*menuList;	
	//NSInteger totalSkillPoints;
}

- (IBAction)decDifficulty;
- (IBAction)addDifficulty;

- (IBAction)decPilotSkill;
- (IBAction)addPilotSkill;

- (IBAction)decFighterSkill;
- (IBAction)addFighterSkill;

- (IBAction)decTraderSkill;
- (IBAction)addTraderSkill;

- (IBAction)decEngineerSkill;
- (IBAction)addEngineerSkill;

-(IBAction)finishInputName;

@property (nonatomic, retain) UITextField * pilotName;
@end
