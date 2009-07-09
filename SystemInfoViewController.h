#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SystemInfoViewController : UIViewController<UINavigationBarDelegate> {
	IBOutlet	UILabel*	systemMessage;	
	IBOutlet    UIWebView*  systemInfoContent;
	
	IBOutlet	UIButton*	systemNews;
	IBOutlet	UIButton*	systemHire;
	IBOutlet	UIButton*	systemSpecial;	
}


-(IBAction)doQuests;
-(IBAction)showNews;
-(IBAction)showHire;
-(IBAction)showSpecial;

-(void) UpdateView;
@end
