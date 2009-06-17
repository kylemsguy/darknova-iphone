#import "pricesView.h"
#import "S1AppDelegate.h"
#import "player.h"

@implementation pricesView



-(void)UpdateWindow
{
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	player * pPlayer = app.gamePlayer;
	NSString * tmp;
	tmp = [pPlayer getSolarSystemName:pPlayer.warpSystem];
	name.text = tmp; 
	//[tmp release];
	tmp = [pPlayer getSolarSystemSpecalResources:pPlayer.warpSystem];
	resources.text  = tmp;
	//[tmp release];	
	tmp =  [NSString stringWithFormat:@"Bays: %i/%i", [app.gamePlayer filledCargoBays], [app.gamePlayer totalCargoBays] ];	
	bays.text = tmp; 
	//[tmp release];	
	cash.text = [NSString stringWithFormat:@"Cash: %i cr.", app.gamePlayer.credits ];		
	
	if (absolutePrices) {
		[absolutePricesButton setTitle:@"Price Differences" forState:UIControlStateNormal];
		[absolutePricesButton setTitle:@"Price Differences" forState:UIControlStateHighlighted];		
	}
	else {
		[absolutePricesButton setTitle:@"Absolute Prices" forState:UIControlStateNormal];
		[absolutePricesButton setTitle:@"Absolute Prices" forState:UIControlStateHighlighted];		
		
	}

	int bold;
	tmp = [pPlayer getPriceDifference:0 difference:!absolutePrices realPrice:&itemsPrice[0] maxCount:&itemsMax[0] isSmart:&bold];
	water.text = tmp; 
	//[tmp release];
	tmp = [pPlayer getPriceDifference:1 difference:!absolutePrices realPrice:&itemsPrice[1] maxCount:&itemsMax[1] isSmart:&bold];
	furs.text = tmp;
	//[tmp release];	
	tmp = [pPlayer getPriceDifference:2 difference:!absolutePrices realPrice:&itemsPrice[2] maxCount:&itemsMax[2] isSmart:&bold];
	food.text = tmp;
	//[tmp release];	
	tmp = [pPlayer getPriceDifference:3 difference:!absolutePrices realPrice:&itemsPrice[3] maxCount:&itemsMax[3] isSmart:&bold];
	ore.text = tmp;
	//[tmp release];
	tmp = [pPlayer getPriceDifference:4 difference:!absolutePrices realPrice:&itemsPrice[4] maxCount:&itemsMax[4] isSmart:&bold];
	games.text = tmp;
	//[tmp release];
	tmp = [pPlayer getPriceDifference:5 difference:!absolutePrices realPrice:&itemsPrice[5] maxCount:&itemsMax[5] isSmart:&bold];
	firearms.text = tmp;
	//[tmp release];
	tmp = [pPlayer getPriceDifference:6 difference:!absolutePrices realPrice:&itemsPrice[6] maxCount:&itemsMax[6] isSmart:&bold];
	medicine.text = tmp;
	//[tmp release];
	tmp = [pPlayer getPriceDifference:7 difference:!absolutePrices realPrice:&itemsPrice[7] maxCount:&itemsMax[7] isSmart:&bold];
	machines.text = tmp;
	//[tmp release];
	tmp = [pPlayer getPriceDifference:8 difference:!absolutePrices realPrice:&itemsPrice[8] maxCount:&itemsMax[8] isSmart:&bold];
	narcotics.text = tmp;
	//[tmp release];
	tmp = [pPlayer getPriceDifference:9 difference:!absolutePrices realPrice:&itemsPrice[9] maxCount:&itemsMax[9] isSmart:&bold];
	robots.text = tmp;
	//[tmp release];
	
}

- (void)didMoveToWindow {
	absolutePrices = false;
	[super didMoveToWindow];
	[self UpdateWindow];
}

-(void) pressedCargoMax:(unsigned int) num {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	[app.gamePlayer buyCargo:num Amount:itemsMax[num]];
	[self UpdateWindow];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex  // after animation
{
	int button = buttonIndex;
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	
	if (button == 1) {
		// Ok
		
		NSString * value = [[(AlertModalWindow*)alertView myTextField] text];
		unsigned int val = value.intValue;
		[app.gamePlayer buyCargo:activeTradeItem Amount:val];
		[self UpdateWindow];	
	} else if (button == 2) {
		
		[self pressedCargoMax:activeTradeItem];
	}
	
}

-(void) BuyItem:(int)num
{
	activeTradeItem = num;	
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString * message = [NSString stringWithFormat:@"At %i cr. each, you can afford %i. \nHow many do you want to buy?\n\n",[app.gamePlayer getBuyPrice:activeTradeItem],  itemsMax[activeTradeItem]];
	AlertModalWindow * myAlertView = [[[AlertModalWindow alloc] initWithTitle:@"Buy Items" yoffset:90 message:message  
																	delegate:self cancelButtonTitle:@"None" okButtonTitle:@"Ok"  thirdButtonTitle:@"All"] autorelease];
	
	[myAlertView show];
}


-(IBAction) buyWater
{
	[self BuyItem:0];
}

-(IBAction) buyFurs
{
	[self BuyItem:1];	
}

-(IBAction) buyFood
{
	[self BuyItem:2];	
}

-(IBAction) buyOre
{
	[self BuyItem:3];	
}

-(IBAction) buyGames
{
	[self BuyItem:4];	
}

-(IBAction) buyFirearms
{
	[self BuyItem:5];	
}

-(IBAction) buyMedicine
{
	[self BuyItem:6];	
}

-(IBAction) buyMachines
{
	[self BuyItem:7];	
}

-(IBAction) buyNarcotics
{
	[self BuyItem:8];	
}

-(IBAction) buyRobots
{
	[self BuyItem:9];	
}

-(IBAction) showAbsolutePrices
{
	absolutePrices = !absolutePrices;
	[self UpdateWindow];
}






@end
