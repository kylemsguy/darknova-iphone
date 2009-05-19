#import "sellCargoViewController.h"
#import "sellCargoView.h"

@implementation sellCargoViewController
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
	sellCargoView * pCargo = (sellCargoView*) self.view;
	[pCargo setJettisonType];
}

-(void) setOpponentType
{
	self.title = @"Plunder Cargo";	
	sellCargoView * pCargo = (sellCargoView*) self.view;
	[pCargo setOpponentType];
}
@end
