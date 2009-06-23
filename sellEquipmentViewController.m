#import "sellEquipmentViewController.h"
#import "S1AppDelegate.h"
#import "Player.h"

@implementation sellEquipmentViewController


- (void)awakeFromNib
{
	self.title = @"Sell Equipment";	
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		self.title = @"Sell Equipment";			
	}
	return self;
}


-(void)updateButtonAndLabels:(int)index button:(UIButton*)button labelName:(UILabel*)labelName labelPrice:(UILabel*)labelPrice counter:(int*)counter
{
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];

	if ([app.gamePlayer getSellEquipmentPrice:index] > 0) 
	{
		labelName.text = [app.gamePlayer getShipEquipmentName:index];		
		[self.view addSubview:button];
		[self.view addSubview:labelName];
		[self.view addSubview:labelPrice];		
		labelPrice.text = [NSString stringWithFormat:@"%i cr.", [app.gamePlayer getSellEquipmentPrice:index]];
		(*counter)++;
	}
	else {
		[button removeFromSuperview];
		[labelName removeFromSuperview];
		[labelPrice removeFromSuperview];
	}
}


-(void)UpdateView
{
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	int weapons = 0, shields = 0, gadgets = 0;
	[self updateButtonAndLabels:0 button:weaponSell0 labelName:weaponName0 labelPrice:weaponPrice0 counter:&weapons];
	[self updateButtonAndLabels:1 button:weaponSell1 labelName:weaponName1 labelPrice:weaponPrice1 counter:&weapons];
	[self updateButtonAndLabels:2 button:weaponSell2 labelName:weaponName2 labelPrice:weaponPrice2 counter:&weapons];

	if (weapons == 0)
		[self.view addSubview:noWeapons];
	else 
		[noWeapons removeFromSuperview];

	[self updateButtonAndLabels:3 button:shieldSell0 labelName:shieldName0 labelPrice:shieldPrice0 counter:&shields];
	[self updateButtonAndLabels:4 button:shieldSell1 labelName:shieldName1 labelPrice:shieldPrice1 counter:&shields];
	[self updateButtonAndLabels:5 button:shieldSell2 labelName:shieldName2 labelPrice:shieldPrice2 counter:&shields];
	
	if (shields == 0)
		[self.view addSubview:noShield];
	else 
		[noShield removeFromSuperview];

	[self updateButtonAndLabels:6 button:gadgetSell0 labelName:gadgetName0 labelPrice:gadgetPrice0 counter:&gadgets];
	[self updateButtonAndLabels:7 button:gadgetSell1 labelName:gadgetName1 labelPrice:gadgetPrice1 counter:&gadgets];
	[self updateButtonAndLabels:8 button:gadgetSell2 labelName:gadgetName2 labelPrice:gadgetPrice2 counter:&gadgets];
	
	if (gadgets == 0)
		[self.view addSubview:noGadgets];
	else 
		[noGadgets removeFromSuperview];
	
	cash.text = [NSString stringWithFormat:@"Cash: %i cr.", app.gamePlayer.credits];		
}


- (void)loadView
{
	[super loadView];
	[self UpdateView];
}


- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
	[self UpdateView];
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex  // after animation
{
	int button = buttonIndex;
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	
	if (button == 1) {
		// Ok
		[app.gamePlayer sellEquipment:numSellItem];
		[self UpdateView];	
	} 	
}


-(void) sellItem:(int)index
{
	numSellItem = index;

	UIAlertView * view = [[[UIAlertView alloc] initWithTitle:@"Sell Equipment" message:@"Are you sure you want to sell this item?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil] autorelease];
	[view show];	
}

-(IBAction) sellWeapon0
{
	[self sellItem:0];
}

-(IBAction) sellWeapon1
{
	[self sellItem:1];	
}

-(IBAction) sellWeapon2
{
	[self sellItem:2];	
}

-(IBAction) sellShield0
{
	[self sellItem:3];	
}

-(IBAction) sellShield1
{
	[self sellItem:4];	
}

-(IBAction) sellShield2
{
	[self sellItem:5];	
}

-(IBAction) sellGadget0
{
	[self sellItem:6];	
}

-(IBAction) sellGadget1
{
	[self sellItem:7];	
}

-(IBAction) sellGadget2
{
	[self sellItem:8];	
}


@end
