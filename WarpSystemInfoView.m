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

#import "WarpSystemInfoView.h"
#import "S1AppDelegate.h"
#import "Player.h"

@implementation WarpSystemInfoView

-(void) UpdateView {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	NSString * tmp = [app.gamePlayer getWarpSystemName];
	systemName.text = tmp;
	//[tmp release];
    tmp = [app.gamePlayer getWarpSystemSize];
	systemSize.text = tmp;
	//[tmp release];	
	tmp= [app.gamePlayer getWarpSystemTechLevel];	
	systemTechLevel.text = tmp;
	//[tmp release];	
	tmp = [app.gamePlayer getWarpSystemPolitics];	
	systemGoverment.text = tmp;
	//[tmp release];	
	tmp = [app.gamePlayer getWarpSystemPirates];
	systemPirates.text = tmp;
	//[tmp release];		
	tmp = [app.gamePlayer getWarpSystemPolice];
	systemPolice.text = tmp;
	//[tmp release];	
	systemDistance.text = [NSString stringWithFormat:@"%i parsecs", [app.gamePlayer realDistance: [app.gamePlayer getCurrentSystemIndex] b:app.gamePlayer.warpSystem]];

	int cost = [app.gamePlayer mercenaryMoney] + [app.gamePlayer insuranceMoney] + [app.gamePlayer WormholeTax:app.gamePlayer.currentSystem  b:app.gamePlayer.warpSystem];
	
	if (app.gamePlayer.debt > 0)
	{
		int IncDebt = max(1, app.gamePlayer.debt / 10);
		cost += IncDebt;
	}
	systemCost.text = [NSString stringWithFormat:@"%i cr.", cost];
//	[specific removeFromSuperview];	
//	if (cost > 0)
//		[specific addSubview:self];


		
}

- (void)didMoveToWindow {
	[super didMoveToWindow];
	[self UpdateView];
}

-(IBAction) pressSpecific
{
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	int cost = [app.gamePlayer mercenaryMoney] + [app.gamePlayer insuranceMoney] + [app.gamePlayer WormholeTax:app.gamePlayer.currentSystem  b:app.gamePlayer.warpSystem];
	
	int IncDebt = 0;
	if (app.gamePlayer.debt > 0)
	{
		IncDebt =  max(1, app.gamePlayer.debt / 10);
		cost += IncDebt;
	}
	
	

	NSString * message = [NSString stringWithFormat:@"Mercenaries: %i cr.\nInsurance: %i cr.\nInterest: %i cr.\nWormhole Tax: %i cr.\n\nTotal: %i cr.",
						  [app.gamePlayer mercenaryMoney], [app.gamePlayer insuranceMoney], IncDebt,  [app.gamePlayer WormholeTax:app.gamePlayer.currentSystem  b:app.gamePlayer.warpSystem], cost];
	UIAlertView * myAlertView = [[[UIAlertView alloc] initWithTitle:@"Specification" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
	
	[myAlertView show];
}

@end
