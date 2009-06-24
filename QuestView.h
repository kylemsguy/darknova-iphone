#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface QuestView :UIView/* Specify a superclass (eg: NSObject or NSView) */ {
	IBOutlet UITextView * label;
}

-(void)update;

@end
