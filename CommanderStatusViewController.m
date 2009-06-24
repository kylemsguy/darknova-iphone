#import "CommanderStatusViewController.h"


@implementation CommanderStatusViewController


@synthesize shipViewInst, statusViewInst, questViewInst, specialCargoViewInst;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		[self status];
	}
	return self;
}


- (void)awakeFromNib
{
	//self.title = @"Commander Status";	
	[self status];
}

-(IBAction) quests {
	self.title = @"Quests";
	self.view =questViewInst;
	[questViewInst update];

}

-(IBAction) ship {
	self.title = @"Ship";
	self.view = shipViewInst;
	
}

-(IBAction) specialCargo {
	self.title = @"Special Cargo";
	self.view = specialCargoViewInst;
}

-(IBAction) status {
	self.title = @"Commander";
	self.view = statusViewInst;
	[statusViewInst UpdateView];
}

@end
