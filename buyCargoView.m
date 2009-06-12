#import "buyCargoView.h"
#import "S1AppDelegate.h"
#import "player.h"
#import "AlertModalWindow.h"

@implementation buyCargoView

-(void)setTitleToButton:(UIButton*) cargo num:(int)num maxButton:(UIButton*)maxButton{
	if (num > 0) {
		[cargo setTitle: [NSString stringWithFormat:@"%i",num] forState:UIControlStateNormal];
		[self addSubview:cargo];
		[self addSubview:maxButton];	
	}
	else {
		[cargo removeFromSuperview];
		[maxButton removeFromSuperview];
	}

}

-(void)setTitleToLabel:(UILabel*) cargo num:(int)num {
	if (num ==  0)
		cargo.text=@"not sold";
	else
		cargo.text = [NSString stringWithFormat:@"%i", num];
}

-(void) UpdateView {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	cash.text = [NSString stringWithFormat:@"Cash: %i cr.", app.gamePlayer.credits];	
	
	[self setTitleToLabel:cargoPrice1 num:[app.gamePlayer getBuyPrice:0]];
	[self setTitleToLabel:cargoPrice2 num:[app.gamePlayer getBuyPrice:1]];
	[self setTitleToLabel:cargoPrice3 num:[app.gamePlayer getBuyPrice:2]];	
	[self setTitleToLabel:cargoPrice4 num:[app.gamePlayer getBuyPrice:3]];
	[self setTitleToLabel:cargoPrice5 num:[app.gamePlayer getBuyPrice:4]];
	[self setTitleToLabel:cargoPrice6 num:[app.gamePlayer getBuyPrice:5]];
	[self setTitleToLabel:cargoPrice7 num:[app.gamePlayer getBuyPrice:6]];
	[self setTitleToLabel:cargoPrice8 num:[app.gamePlayer getBuyPrice:7]];	
	[self setTitleToLabel:cargoPrice9 num:[app.gamePlayer getBuyPrice:8]];
	[self setTitleToLabel:cargoPrice10 num:[app.gamePlayer getBuyPrice:9]];
	
	cargoBay.text = [NSString stringWithFormat:@"Bay: %i/%i", [app.gamePlayer filledCargoBays], [app.gamePlayer totalCargoBays] ];	
	
	for (int i = 0; i < MAXTRADEITEM; ++i)
		buyCargoViewValue[i] = [app.gamePlayer getAmountToBuy:i];
	
	[self setTitleToButton:cargo1 num:buyCargoViewValue[0] maxButton:maxCargo1];
	[self setTitleToButton:cargo2 num:buyCargoViewValue[1] maxButton:maxCargo2];
	[self setTitleToButton:cargo3 num:buyCargoViewValue[2] maxButton:maxCargo3];
	[self setTitleToButton:cargo4 num:buyCargoViewValue[3] maxButton:maxCargo4];
	[self setTitleToButton:cargo5 num:buyCargoViewValue[4] maxButton:maxCargo5];
	[self setTitleToButton:cargo6 num:buyCargoViewValue[5] maxButton:maxCargo6];
	[self setTitleToButton:cargo7 num:buyCargoViewValue[6] maxButton:maxCargo7];
	[self setTitleToButton:cargo8 num:buyCargoViewValue[7] maxButton:maxCargo8];
	[self setTitleToButton:cargo9 num:buyCargoViewValue[8] maxButton:maxCargo9];
	[self setTitleToButton:cargo10 num:buyCargoViewValue[9] maxButton:maxCargo10];
	
}

- (void)viewDidAppear:(BOOL)animated  {
	[self UpdateView];
}

- (void)didMoveToWindow {
	
	
	[super didMoveToWindow];
	[self UpdateView];
}

-(void) pressedCargo:(unsigned int) num {
	activeTradeItem = num;	
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString * message = [NSString stringWithFormat:@"At %i cr. each, you can afford %i. \nHow many do you want to buy?\n\n\n\n",[app.gamePlayer getBuyPrice:activeTradeItem],  buyCargoViewValue[activeTradeItem]];
	AlertModalWindow * myAlertView = [[[AlertModalWindow alloc] initWithTitle:@"Buy Items" yoffset:90 message:message  
																	delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"Ok"  thirdButtonTitle:@"Max"] autorelease];
	
	[myAlertView show];
}

-(void) pressedCargoMax:(unsigned int) num {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	[app.gamePlayer buyCargo:num Amount:buyCargoViewValue[num]];
	[self UpdateView];
	
	
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex  // after animation
{
	int button = buttonIndex;
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	
	if (button == 1) {
		// Ok
		
		NSString * value = [[(AlertModalWindow*)alertView myTextField] text];
		unsigned int val = value.intValue;
		[app.gamePlayer buyCargo:activeTradeItem Amount:buyCargoViewValue[val]];
		[self UpdateView];	
	} else if (button == 2) {
		
		[self pressedCargoMax:activeTradeItem];
	}
		
}


-(IBAction) pressCargo1 
{
	[self pressedCargo:0];
}

-(IBAction) pressCargo2
{
	[self pressedCargo:1];
}

-(IBAction) pressCargo3
{
	[self pressedCargo:2];
}

-(IBAction) pressCargo4
{
	[self pressedCargo:3];
}

-(IBAction) pressCargo5
{
	[self pressedCargo:4];
}

-(IBAction) pressCargo6
{
	[self pressedCargo:5];
}

-(IBAction) pressCargo7;
{
	[self pressedCargo:6];
}


-(IBAction) pressCargo8
{
	[self pressedCargo:7];
}

-(IBAction) pressCargo9
{
	[self pressedCargo:8];
}

-(IBAction) pressCargo10
{
	[self pressedCargo:9];
}

-(IBAction) pressMaxCargo1
{
	[self pressedCargoMax:0];
}

-(IBAction) pressMaxCargo2
{
	[self pressedCargoMax:1];
}

-(IBAction) pressMaxCargo3
{
	[self pressedCargoMax:2];
}

-(IBAction) pressMaxCargo4
{
	[self pressedCargoMax:3];
}

-(IBAction) pressMaxCargo5
{
	[self pressedCargoMax:4];
}

-(IBAction) pressMaxCargo6
{
	[self pressedCargoMax:5];
}

-(IBAction) pressMaxCargo7
{
	[self pressedCargoMax:6];
}


-(IBAction) pressMaxCargo8
{
	[self pressedCargoMax:7];
}

-(IBAction) pressMaxCargo9
{
	[self pressedCargoMax:8];
}

-(IBAction) pressMaxCargo10
{
	[self pressedCargoMax:9];
}

@end
