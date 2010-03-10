/*
    Dark Nova © Copyright 2009 Dead Jim Studios
    This file is part of Dark Nova.

    Dark Nova is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Dark Nova is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Dark Nova.  If not, see <http://www.gnu.org/licenses/>
*/

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
