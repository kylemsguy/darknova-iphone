#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface GameViewControllerRENAME : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	NSMutableArray			*menuList;
	IBOutlet UITableView	*myTableView;
}

@property (nonatomic, retain) UITableView *myTableView;

@end
