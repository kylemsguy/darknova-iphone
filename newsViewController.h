#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface newsViewController : UIViewController/* Specify a superclass (eg: NSObject or NSView) */ {
    IBOutlet UITextView *text;
}

@property (nonatomic, retain)UITextView *text;
@end
