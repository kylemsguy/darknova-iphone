#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface HighScoresViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	NSMutableArray			*menuList;	
    IBOutlet id tableView;
}

@end
