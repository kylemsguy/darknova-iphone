#import "SellCargoViewRENAME.h"
#import "S1AppDelegate.h"
#import "Player.h"
#import "AlertModalWindow.h"

@implementation SellCargoViewRENAME

- (void)awakeFromNib
{
	[navigationBar removeFromSuperview];
	//self.title = @"Sell Cargo";	
	bJettison = FALSE;
	bOpponent = FALSE;
}


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
		cargo.text=@"no trade";
	else
		cargo.text = [NSString stringWithFormat:@"%i", num];
}

-(void) UpdateView {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	cash.text = [NSString stringWithFormat:@"Cash: %i cr.", app.gamePlayer.credits];	
	
	[self setTitleToLabel:cargoPrice1 num:[app.gamePlayer getSellPrice:0]];
	[self setTitleToLabel:cargoPrice2 num:[app.gamePlayer getSellPrice:1]];
	[self setTitleToLabel:cargoPrice3 num:[app.gamePlayer getSellPrice:2]];	
	[self setTitleToLabel:cargoPrice4 num:[app.gamePlayer getSellPrice:3]];
	[self setTitleToLabel:cargoPrice5 num:[app.gamePlayer getSellPrice:4]];
	[self setTitleToLabel:cargoPrice6 num:[app.gamePlayer getSellPrice:5]];
	[self setTitleToLabel:cargoPrice7 num:[app.gamePlayer getSellPrice:6]];
	[self setTitleToLabel:cargoPrice8 num:[app.gamePlayer getSellPrice:7]];	
	[self setTitleToLabel:cargoPrice9 num:[app.gamePlayer getSellPrice:8]];
	[self setTitleToLabel:cargoPrice10 num:[app.gamePlayer getSellPrice:9]];
	
	cargoBay.text = [NSString stringWithFormat:@"Bay: %i/%i", [app.gamePlayer filledCargoBays], [app.gamePlayer totalCargoBays] ];	
	
	if (bOpponent)
	{
		for (int i = 0; i < MAXTRADEITEM; ++i)
			sellCargoViewValue[i] = [app.gamePlayer getOpponentAmountToSell:i];
	}
	else {
	for (int i = 0; i < MAXTRADEITEM; ++i)
		sellCargoViewValue[i] = [app.gamePlayer getAmountToSell:i];
	}
	
	[self setTitleToButton:cargo1 num:sellCargoViewValue[0] maxButton:maxCargo1];
	[self setTitleToButton:cargo2 num:sellCargoViewValue[1] maxButton:maxCargo2];
	[self setTitleToButton:cargo3 num:sellCargoViewValue[2] maxButton:maxCargo3];
	[self setTitleToButton:cargo4 num:sellCargoViewValue[3] maxButton:maxCargo4];
	[self setTitleToButton:cargo5 num:sellCargoViewValue[4] maxButton:maxCargo5];
	[self setTitleToButton:cargo6 num:sellCargoViewValue[5] maxButton:maxCargo6];
	[self setTitleToButton:cargo7 num:sellCargoViewValue[6] maxButton:maxCargo7];
	[self setTitleToButton:cargo8 num:sellCargoViewValue[7] maxButton:maxCargo8];
	[self setTitleToButton:cargo9 num:sellCargoViewValue[8] maxButton:maxCargo9];
	[self setTitleToButton:cargo10 num:sellCargoViewValue[9] maxButton:maxCargo10];
	
}
-(void) offsetControl:(UIView*) p
{
	CGRect frame = CGRectMake(p.frame.origin.x, p.frame.origin.y + 40, p.frame.size.width,p.frame.size.height);
	[p setFrame:frame];
	//[p beginAnimations:@"gfghfh" context:nil];
	CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 40);
	p.transform = transform;
	//[p commitAnimations];
}

-(void) setOpponentType
{
	bOpponent = true;
	[self addSubview:navigationBar];
	//navigationBar.title = @"Plunder";
	[UIView beginAnimations:@"ss" context:nil];
	[UIView setAnimationDelay:0];
	[self offsetControl:cargo1];
	[self offsetControl:cargo2];
	[self offsetControl:cargo3];
	[self offsetControl:cargo4];
	[self offsetControl:cargo5];
	[self offsetControl:cargo6];
	[self offsetControl:cargo7];	
	[self offsetControl:cargo8];	
	[self offsetControl:cargo9];
	[self offsetControl:cargo10];
	
	[self offsetControl:maxCargo1];
	[self offsetControl:maxCargo2];
	[self offsetControl:maxCargo3];
	[self offsetControl:maxCargo4];
	[self offsetControl:maxCargo5];
	[self offsetControl:maxCargo6];
	[self offsetControl:maxCargo7];	
	[self offsetControl:maxCargo8];	
	[self offsetControl:maxCargo9];
	[self offsetControl:maxCargo10];
	
	[self offsetControl:cargoPrice1];
	[self offsetControl:cargoPrice2];
	[self offsetControl:cargoPrice3];
	[self offsetControl:cargoPrice4];
	[self offsetControl:cargoPrice5];
	[self offsetControl:cargoPrice6];
	[self offsetControl:cargoPrice7];	
	[self offsetControl:cargoPrice8];	
	[self offsetControl:cargoPrice9];
	[self offsetControl:cargoPrice10];
	
	[self offsetControl:cargoName1];
	[self offsetControl:cargoName2];
	[self offsetControl:cargoName3];
	[self offsetControl:cargoName4];
	[self offsetControl:cargoName5];
	[self offsetControl:cargoName6];
	[self offsetControl:cargoName7];	
	[self offsetControl:cargoName8];	
	[self offsetControl:cargoName9];
	[self offsetControl:cargoName10];
	
	[cash removeFromSuperview];
	[cargoBay removeFromSuperview];
	[UIView commitAnimations];
	[self UpdateView];
	[self setNeedsDisplay];
	
}

-(void)setJettisonType
{
	bJettison = true;
	[self addSubview:navigationBar];
	[UIView beginAnimations:@"ss" context:nil];
	[UIView setAnimationDelay:0];
	[self offsetControl:cargo1];
	[self offsetControl:cargo2];
	[self offsetControl:cargo3];
	[self offsetControl:cargo4];
	[self offsetControl:cargo5];
	[self offsetControl:cargo6];
	[self offsetControl:cargo7];	
	[self offsetControl:cargo8];	
	[self offsetControl:cargo9];
	[self offsetControl:cargo10];
	
	[self offsetControl:maxCargo1];
	[self offsetControl:maxCargo2];
	[self offsetControl:maxCargo3];
	[self offsetControl:maxCargo4];
	[self offsetControl:maxCargo5];
	[self offsetControl:maxCargo6];
	[self offsetControl:maxCargo7];	
	[self offsetControl:maxCargo8];	
	[self offsetControl:maxCargo9];
	[self offsetControl:maxCargo10];
	
	[self offsetControl:cargoPrice1];
	[self offsetControl:cargoPrice2];
	[self offsetControl:cargoPrice3];
	[self offsetControl:cargoPrice4];
	[self offsetControl:cargoPrice5];
	[self offsetControl:cargoPrice6];
	[self offsetControl:cargoPrice7];	
	[self offsetControl:cargoPrice8];	
	[self offsetControl:cargoPrice9];
	[self offsetControl:cargoPrice10];

	[self offsetControl:cargoName1];
	[self offsetControl:cargoName2];
	[self offsetControl:cargoName3];
	[self offsetControl:cargoName4];
	[self offsetControl:cargoName5];
	[self offsetControl:cargoName6];
	[self offsetControl:cargoName7];	
	[self offsetControl:cargoName8];	
	[self offsetControl:cargoName9];
	[self offsetControl:cargoName10];
	
	[cash removeFromSuperview];
	[cargoBay removeFromSuperview];
	[UIView commitAnimations];
	[self setNeedsDisplay];
	
}

- (void)didMoveToWindow {
	
	
	[super didMoveToWindow];
	[self UpdateView];
}

-(void) pressedCargo:(unsigned int) num {
	activeTradeItem = num;	
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString * message;
	AlertModalWindow * myAlertView;
	
	if (bJettison) {
		
		
		message = [NSString stringWithFormat:@"You can jettison up to %i at cr. each. \nYou paid about %i cr. per unit.\nHow many will you dump\n\n\n",
				   sellCargoViewValue[activeTradeItem], [app.gamePlayer getBuyPrice:activeTradeItem]];
		myAlertView = [[[AlertModalWindow alloc] initWithTitle:@"Discard Items" 
													  yoffset:130 
													  message:message  
													  delegate:self 
											          cancelButtonTitle:@"Cancel"
												      okButtonTitle:@"Ok"
											          thirdButtonTitle:@"All"] autorelease];
	}
	if (bOpponent)
	{
		message = [NSString stringWithFormat:@"You can sell up to %i at cr. each. \nHow many do you want to plunder?\n\n\n",
				   sellCargoViewValue[activeTradeItem]];
		myAlertView = [[[AlertModalWindow alloc] initWithTitle:@"Plunder Items" yoffset:130 message:message  
													 delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"Ok"  thirdButtonTitle:@"All"] autorelease];
	}
	else {
				
		message = [NSString stringWithFormat:@"You can sell up to %i at cr. each. \nYou paid about %i cr. per unit.\n Your %@ per unit is %i cr. \nHow many do you want to sell?\n\n\n",
				   sellCargoViewValue[activeTradeItem], [app.gamePlayer getBuyPrice:activeTradeItem], 
				   [app.gamePlayer getBuyingPrice:activeTradeItem] / sellCargoViewValue[activeTradeItem] > [app.gamePlayer getSellPrice:activeTradeItem] ? 
				   @"loss" : @"profit", ABS([app.gamePlayer getBuyingPrice:activeTradeItem] / sellCargoViewValue[activeTradeItem] - [app.gamePlayer getSellPrice:activeTradeItem])];
		myAlertView = [[[AlertModalWindow alloc] initWithTitle:@"Sell Items" yoffset:130 message:message  
													 delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"Ok"  thirdButtonTitle:@"All"] autorelease];
	}
	
	[myAlertView show];
}

-(void) pressedCargoMax:(unsigned int) num {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	if (bJettison) {
		[self removeFromSuperview];
		[app.gamePlayer sellCargo:num Amount:sellCargoViewValue[num] Operation:SELLCARGO];
		[app.gamePlayer continuePlunder];
 		//[self UpdateView];
		
	} else 
		if (bOpponent)
		{
			[self removeFromSuperview];
			[app.gamePlayer plunderItems:num count:sellCargoViewValue[num]];
			[app.gamePlayer continuePlunder];		
		}
	else
	{
		[app.gamePlayer sellCargo:num Amount:sellCargoViewValue[num] Operation:SELLCARGO];
		[self UpdateView];		
	}

}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex  // after animation
{
	int button = buttonIndex;
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	
	if (button == 1) {
		// Ok
		NSString * value = [[(AlertModalWindow*)alertView myTextField] text];
		unsigned int val = value.intValue;

		if (bJettison) {
			[self removeFromSuperview];
			[app.gamePlayer sellCargo:activeTradeItem Amount:val Operation:SELLCARGO];
			[app.gamePlayer continuePlunder];
			//[self UpdateView];
			
		} else
		{
			[app.gamePlayer sellCargo:activeTradeItem Amount:val Operation:SELLCARGO];
			[self UpdateView];	
		}
	} else if(button == 2) {
		
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
