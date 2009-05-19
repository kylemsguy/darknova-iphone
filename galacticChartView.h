#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface galacticChartView :UIView /* Specify a superclass (eg: NSObject or NSView) */ {
	
	CGImageRef redDot;
	CGImageRef greenDot;
	CGImageRef blueDot;
	
	CGSize		redDotSize;
	CGSize		blueDotSize;
	CGSize		greenDotSize;
	
	CGImageRef background;
	CGSize		backgroundSize;
	
	IBOutlet UIButton* nextSystem;
	IBOutlet UIButton* prevSystem;
	IBOutlet UIButton* jumpButton;	
	IBOutlet UILabel* systemName;
	IBOutlet UILabel* systemType;	
	int Index;
	
}
-(IBAction)selectNextSystem; 
-(IBAction)selectPrevSystem; 
-(IBAction)findSystem; 
-(IBAction)jump; 

@end
