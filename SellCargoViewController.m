#import "SellCargoViewController.h"
#import "SellCargoViewRENAME.h"

@implementation SellCargoViewController
- (void)awakeFromNib
{
	self.title = @"Sell Cargo";	
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		self.title = @"Sell Cargo";				
	}
	return self;
}

-(void) setJettisonType {
	self.title = @"Jettison Cargo";	
	SellCargoViewRENAME * pCargo = (SellCargoViewRENAME*) self.view;
	[pCargo setJettisonType];
}

-(void) setOpponentType
{
	self.title = @"Plunder Cargo";	
	SellCargoViewRENAME * pCargo = (SellCargoViewRENAME*) self.view;
	[pCargo setOpponentType];
}
@end
