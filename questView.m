#import "questView.h"
#import "S1AppDelegate.h"
#import "Player.h"

@implementation questView

-(void)update  {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	label.text = [app.gamePlayer drawQuestsForm];	
}

- (void)viewDidAppear:(BOOL)animated  {
	[self update];
}

- (void)didMoveToWindow {
	
	
	[super didMoveToWindow];
	[self update];
}

@end
