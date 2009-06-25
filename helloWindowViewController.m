#import "helloWindowViewController.h"
#import "StartGameViewControllerRENAME.h"
#import "S1AppDelegate.h"
#import "Player.h"
#import "SaveGameViewController.h"

@implementation helloWindowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		// this will appear as the title in the navigation bar
		self.title = NSLocalizedString(@"Welcome to Dark Nova", @"");
		
		// this will appear above the segmented control
		//self.navigationItem.prompt = @"Please fill fields:";
	}
	
	return self;
}

-(void)dealloc {
	
	[super dealloc];
}
@end
