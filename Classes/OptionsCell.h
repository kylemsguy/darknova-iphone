#import <UIKit/UIKit.h>
#import "OptionsViewController.h"

extern NSString *oDisplayCell_ID;

@interface OptionsCell : UITableViewCell< UITextFieldDelegate> {
	UISwitch*	isEnabled;
	UITextField* textField;
	UILabel*	comment;
	id <OptionsChangeDelegate> _delegate;
	NSInteger numItem;
}

@property (nonatomic, retain) UISwitch *isEnabled;
@property (nonatomic, retain) UILabel *comment;
-(void)setDelegate:(id)d num:(NSInteger)num;
-(void)setBool:(bool)b;
-(void)setInt:(int)i;

@end
