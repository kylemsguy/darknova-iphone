#import "ShipYardViewController.h"

@implementation ShipYardViewController



- (void)awakeFromNib
{
	self.title = @"Ship Yard";	
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		self.title = @"Ship Yard";				
	}
	return self;
}

@end