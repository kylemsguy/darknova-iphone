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

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface EncounterViewController : UIViewController {
	IBOutlet UIButton    *close;
	IBOutlet UIButton    *attackButton;
	IBOutlet UIButton    *surrenderButton;
	IBOutlet UIButton    *ignoreButton;	
	IBOutlet UIButton    *fleeButton;
	IBOutlet UIButton    *submitButton;
	IBOutlet UIButton    *bribeButton;
	IBOutlet UIButton    *plunderButton;
	IBOutlet UIButton    *interruptButton;
	IBOutlet UIButton    *drinkButton;	
	IBOutlet UIButton    *boardButton;
	IBOutlet UIButton    *meetButton;
	IBOutlet UIButton    *yieldButton;
	IBOutlet UIButton    *tradeButton;
	IBOutlet UIImageView *attackImage;	
	IBOutlet UIImageView *attackImage2;
	IBOutlet UIImageView *encounterTypeImage;	
	IBOutlet UILabel     *message1Label;
	IBOutlet UILabel     *message1Labe2;
}

-(IBAction) close;

-(IBAction) attack;
-(IBAction) flee;
-(IBAction) ignore;
-(IBAction) trade;
-(IBAction) yield;
-(IBAction) surrender;
-(IBAction) bribe; 
-(IBAction) submit; 
-(IBAction) plunder; 
-(IBAction) interrupt; 
-(IBAction) meet; 
-(IBAction) board; 
-(IBAction) drink;

-(void) SetLabelText:(NSString*)text;
-(void) SetLabel2Text:(NSString*)text;
-(void) showEncounterWindow;

@end 