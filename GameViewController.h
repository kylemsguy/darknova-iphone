#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface GameViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	NSMutableArray			*menuList;
	IBOutlet UITableView	*myTableView;
}

@property (nonatomic, retain) UITableView *myTableView;

@end
