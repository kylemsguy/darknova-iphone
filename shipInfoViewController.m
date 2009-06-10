#import "shipInfoViewController.h"
#import "shipInfoView.h"

@implementation shipInfoViewController

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
