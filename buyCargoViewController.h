#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface buyCargoViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> /* Specify a superclass (eg: NSObject or NSView) */ {
	NSMutableArray			*menuList;
}

@end
