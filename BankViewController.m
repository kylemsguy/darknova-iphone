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

#import "BankViewController.h"
#import "S1AppDelegate.h"
#import "Player.h"
#import "AlertModalWindow.h"
#include "spacetrader.h"

@implementation BankViewController

@synthesize		getLoan;
@synthesize		paybackLoan;
@synthesize		getInsurance;
@synthesize		stopInsurance;
@synthesize		currentDebt;
@synthesize		maximumLoan;
@synthesize		currentShipCost;
@synthesize		noClaim;
@synthesize		insuranceCosts;
@synthesize		currentCash, actionMode;

- (void)awakeFromNib
{
	self.title = @"Bank";	
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		self.title = @"Bank";		
	}
	
	[self UpdateView];
	
	return self;
}

-(void)UpdateView {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (app.gamePlayer.debt <= 0) {
		[paybackLoan removeFromSuperview];
		[self.view addSubview: getLoan];
	}
	else {
		[self.view addSubview: paybackLoan];
		if (app.gamePlayer.debt >= [app.gamePlayer maxLoan])
			[getLoan removeFromSuperview];
	}
	
	if (app.gamePlayer.insurance) {
		[self.view addSubview: stopInsurance];
		[getInsurance removeFromSuperview];		
	}
	else {
		[stopInsurance removeFromSuperview];		
		[self.view addSubview: getInsurance];		
	}

	
	currentDebt.text = [NSString stringWithFormat:@"%i cr.", app.gamePlayer.debt];
	maximumLoan.text = [NSString stringWithFormat:@"%i cr.", [app.gamePlayer maxLoan]];
	NSUInteger cost = [app.gamePlayer currentShipPriceWithoutCargo:true];
	currentShipCost.text = [NSString stringWithFormat:@"%i cr.", cost ];	
	
	NSUInteger noclaim = min( app.gamePlayer.noClaim, 90);
	if (noclaim == 90)
		noClaim.text = [NSString stringWithFormat:@"% (maximum)"];				
	else
		noClaim.text = [NSString stringWithFormat:@"%i %% ",noclaim];	
	
	insuranceCosts.text = [NSString stringWithFormat:@"%i cr.", [app.gamePlayer insuranceMoney]];	
	currentCash.text = [NSString stringWithFormat:@"Cash: %i cr.", app.gamePlayer.credits];	
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex  // after animation
{
	int button = buttonIndex;
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	
	if (actionMode == GETLOANACTION) {
		
	
	if (button == 1) {
		// Ok
		
		NSString * value = [[(AlertModalWindow*)alertView myTextField] text];
		unsigned int val = value.intValue;
		
		if (val > [app.gamePlayer maxLoan])
			val = [app.gamePlayer maxLoan];
		
		[app.gamePlayer getLoan:val];
		
	} else 
		if (button == 2) {
			// MAximum
		[app.gamePlayer getLoan:[app.gamePlayer maxLoan]];			
		}
	}
	else 
		if (actionMode == PAYBACKLOANACTION) {
			if (button == 1) {
				// Ok
				
				NSString * value = [[(AlertModalWindow*)alertView myTextField] text];
				unsigned int val = value.intValue;
							
				[app.gamePlayer payBack:val];
				
			} else 
				if (button == 2) {
					// MAximum
					[app.gamePlayer payBack:99999];			
				}			
		}
		else
			if(actionMode == STOPINSURANCE && button == 1)
				app.gamePlayer.insurance = false;
			
	
	[self UpdateView];
}

-(IBAction)getLoanAction{
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	NSString * message = [NSString stringWithFormat:@"You can borrow up to %i cr.\nHow much do you want?\n\n", [app.gamePlayer maxLoan]];
	AlertModalWindow * myAlertView = [[AlertModalWindow alloc] initWithTitle:@"Get loan" yoffset:90 message:message  
																	delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"Ok" thirdButtonTitle:@"Max"];

	[myAlertView show];
	actionMode = GETLOANACTION;
	
	[myAlertView release];
}

-(IBAction)paybackLoanAction {
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	NSString * message = [NSString stringWithFormat:@"You have a debt %i cr.\nHow much do you pay back?\n\n", app.gamePlayer.debt];
	AlertModalWindow * myAlertView = [[AlertModalWindow alloc] initWithTitle:@"Pay Back" yoffset:90 message:message  
																	delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"Ok" thirdButtonTitle:@"Max"];
	
	actionMode = PAYBACKLOANACTION;
	[myAlertView show];
	
	[myAlertView release];	
}

-(IBAction)getInsuranceAction {
	actionMode = BUYINSURANCE;
	S1AppDelegate * app = (S1AppDelegate *)[[UIApplication sharedApplication] delegate];	
	if (!app.gamePlayer.escapePod) {
		UIAlertView * myAlertView = [[UIAlertView alloc] initWithTitle:@"No Escape Pod" message:@"Insurance isn't useful for you, since you don't have an escape pod."  
															  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		
		[myAlertView show];
		
		[myAlertView release];			
	}
	else {
		[app.gamePlayer playSound:eBuyInsurance];
		app.gamePlayer.insurance = true;
	}
	[self UpdateView];	
}

-(IBAction)stopInsuranceAction {
	actionMode = STOPINSURANCE;
	UIAlertView * myAlertView = [[UIAlertView alloc] initWithTitle:@"Stop Insurance" message:@"Do you really wish to stop your insurance and lose your no-claim?"  
																	delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];

	[myAlertView show];
	
	[myAlertView release];		
	[self UpdateView];	
}

@end
