#import "ShipInfoViewControllerRENAME.h"
#import "shipInfoView.h"

@implementation ShipInfoViewControllerRENAME

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		self.title = @"Ship Information";				
	}


	return self;
}

-(void) setShip:(int)index {
	shipInfoView* view1 = (shipInfoView*)[self view];//(shipInfoView*)[UIViewController view] delegate];
	view1.ship = index;
}
@end
