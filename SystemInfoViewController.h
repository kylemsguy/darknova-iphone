#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SystemInfoViewController : UIViewController<UINavigationBarDelegate>/* Specify a superclass (eg: NSObject or NSView) */ {
	IBOutlet	UILabel*	systemName;
	IBOutlet	UILabel*	systemSize;
	IBOutlet	UILabel*	systemTechLevel;
	IBOutlet	UILabel*	systemGoverment;
	IBOutlet	UILabel*	systemResources;
	IBOutlet	UILabel*	systemPolice;	
	IBOutlet	UILabel*	systemPirates;
	IBOutlet	UILabel*	systemMessage;	
	
	IBOutlet	UIButton*	systemNews;
	IBOutlet	UIButton*	systemHire;
	IBOutlet	UIButton*	systemSpecial;	
}

/*@property (nonatomic, retain)	UILabel*	systemName;
@property (nonatomic, retain)	UILabel*	systemSize;
@property (nonatomic, retain)	UILabel*	systemTechLevel;
@property (nonatomic, retain)	UILabel*	systemGoverment;
@property (nonatomic, retain)	UILabel*	systemResources;
@property (nonatomic, retain)	UILabel*	systemPolice;	
@property (nonatomic, retain)	UILabel*	systemPirates;
@property (nonatomic, retain)	UILabel*	systemMessage;	*/



-(IBAction)testClick;
-(IBAction)doQuests;
-(IBAction)showNews;
-(IBAction)showHire;
-(IBAction)showSpecial;

-(void) UpdateView;
@end
