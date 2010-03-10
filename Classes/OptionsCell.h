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
