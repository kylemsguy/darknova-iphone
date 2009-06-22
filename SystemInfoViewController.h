#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SystemInfoViewController : UIViewController<UINavigationBarDelegate>/* Specify a superclass (eg: NSObject or NSView) */ {
	IBOutlet	UILabel*	systemMessage;	
	IBOutlet    UIWebView*  systemInfoContent;
	
	IBOutlet	UIButton*	systemNews;
	IBOutlet	UIButton*	systemHire;
	IBOutlet	UIButton*	systemSpecial;	
}

@property (nonatomic, retain)	UILabel*	systemMessage;	


-(IBAction)doQuests;
-(IBAction)showNews;
-(IBAction)showHire;
-(IBAction)showSpecial;

-(void) UpdateView;
@end
