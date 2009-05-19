#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SaveGameViewController : UITableViewController/* Specify a superclass (eg: NSObject or NSView) */ {
	NSMutableArray			*menuList;  
	NSMutableArray			*menuName;  	
	NSMutableArray			*menuListAdditional;  
	IBOutlet UIBarButtonItem * addButton;
	bool loadMode;
	int activeSaveNumber;
}

-(void)setSaveGameMode;
-(void)setLoadGameMode;
@end
