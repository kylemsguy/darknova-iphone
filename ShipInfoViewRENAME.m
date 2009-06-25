#import "ShipInfoViewRENAME.h"
#import "S1AppDelegate.h"
#import "Player.h"


@implementation ShipInfoViewRENAME

@synthesize ship;

-(void)updateViewForShip:(int)shipIndex 
{

	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];

	nameLabel.text = [app.gamePlayer getShipName:shipIndex]; 
	sizeLabel.text = [app.gamePlayer getShipSize:shipIndex];
	cargoBaysLabel.text =  [NSString stringWithFormat:@"%i", [app.gamePlayer getShipCargoBays:shipIndex]];
	rangeLabel.text = [NSString stringWithFormat:@"%i parsecs", [app.gamePlayer getShipRange:shipIndex]];	
	hullStrengthLabel.text = [NSString stringWithFormat:@"%i", [app.gamePlayer getShipHullStrength:shipIndex]];	
	weaponSlotsLabel.text = [NSString stringWithFormat:@"%i", [app.gamePlayer getShipWeaponSlots:shipIndex]];
	shieldSlotsLabel.text = [NSString stringWithFormat:@"%i", [app.gamePlayer getShipShieldSlots:shipIndex]];
	gadgetSlotsLabel.text = [NSString stringWithFormat:@"%i", [app.gamePlayer getShipGadgetSlots:shipIndex]];
	crewQuartersLabel.text = [NSString stringWithFormat:@"%i", [app.gamePlayer getShipCrewQuarters:shipIndex]];			
	shipImage.image = [UIImage imageNamed:[app.gamePlayer getShipImageNameBg:shipIndex]];

}

- (void)didMoveToWindow {
	
	
	[super didMoveToWindow];
	[self updateViewForShip:ship];
}

- (void)viewDidAppear:(BOOL)animated  {
	[self updateViewForShip:ship];
}

-(IBAction) done {
	[self removeFromSuperview];
}
@end
