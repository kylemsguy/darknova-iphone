#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface highScoresViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>/* Specify a superclass (eg: NSObject or NSView) */ {
	NSMutableArray			*menuList;	
    IBOutlet id tableView;
}

@end
