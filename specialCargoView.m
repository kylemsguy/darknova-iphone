#import "specialCargoView.h"
#import "S1AppDelegate.h"
#import "PlayerRENAME.h"

@implementation specialCargoView


-(void)update  {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	label.text = [app.gamePlayer drawSpecialCargoForm];	
}

- (void)viewDidAppear:(BOOL)animated  {
	[self update];
}

- (void)didMoveToWindow {
	
	
	[super didMoveToWindow];
	[self update];
}

@end
