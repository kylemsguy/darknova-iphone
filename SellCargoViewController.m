#import "SellCargoViewController.h"
#import "SellCargoView.h"

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
	SellCargoView * pCargo = (SellCargoView*) self.view;
	[pCargo setJettisonType];
}

-(void) setOpponentType
{
	self.title = @"Plunder Cargo";	
	SellCargoView * pCargo = (SellCargoView*) self.view;
	[pCargo setOpponentType];
}
@end
