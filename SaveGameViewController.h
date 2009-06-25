#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SaveGameViewController : UITableViewController {
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
