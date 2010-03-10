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


#define GETLOANACTION		1
#define PAYBACKLOANACTION	2
#define BUYINSURANCE		3
#define STOPINSURANCE		4

@interface BankViewController : UIViewController <UIAlertViewDelegate> {
	IBOutlet	UIButton*		getLoan;
	IBOutlet	UIButton*		paybackLoan;
	IBOutlet	UIButton*		getInsurance;
	IBOutlet	UIButton*		stopInsurance;
	IBOutlet	UILabel*		currentDebt;
	IBOutlet	UILabel*		maximumLoan;
	IBOutlet	UILabel*		currentShipCost;
	IBOutlet	UILabel*		noClaim;
	IBOutlet	UILabel*		insuranceCosts;
	IBOutlet	UILabel*		currentCash;
	int							actionMode;
}

@property (nonatomic, retain) UIButton *getLoan;
@property (nonatomic, retain) UIButton *paybackLoan;
@property (nonatomic, retain) UIButton *getInsurance;
@property (nonatomic, retain) UIButton *stopInsurance;
@property (nonatomic, retain) UILabel *	currentDebt;
@property (nonatomic, retain) UILabel *	maximumLoan;
@property (nonatomic, retain) UILabel *	currentShipCost;
@property (nonatomic, retain) UILabel *	noClaim;
@property (nonatomic, retain) UILabel *	insuranceCosts;
@property (nonatomic, retain) UILabel *	currentCash;
@property int							actionMode;

-(IBAction)getLoanAction;
-(IBAction)paybackLoanAction;
-(IBAction)getInsuranceAction;
-(IBAction)stopInsuranceAction;
-(void)UpdateView;
@end
