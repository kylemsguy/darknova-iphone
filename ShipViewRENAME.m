#import "ShipViewRENAME.h"
#import "S1AppDelegate.h"
#import "Player.h"

@implementation ShipViewRENAME

-(void)update  {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	label.text = [app.gamePlayer drawCurrentShipForm];	
	shipImage.image = [UIImage imageNamed:[app.gamePlayer getShipImageName:[app.gamePlayer getCurrentShipType]]];
	shipName.text = [app.gamePlayer getShipName:[app.gamePlayer getCurrentShipType]];
	
}

- (void)viewDidAppear:(BOOL)animated  {
	[self update];
}

- (void)didMoveToWindow {
	
	
	[super didMoveToWindow];
	[self update];
}

@end
