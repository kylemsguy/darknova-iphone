#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


#define GETLOANACTION		1
#define PAYBACKLOANACTION	2
#define BUYINSURANCE		3
#define STOPINSURANCE		4

@interface bankViewController : UIViewController <UIAlertViewDelegate>/* Specify a superclass (eg: NSObject or NSView) */ {
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
