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
-(IBAction)testClick;
-(IBAction)doQuests;
-(IBAction)showNews;
-(IBAction)showHire;
-(IBAction)showSpecial;

-(void) UpdateView;
@end
