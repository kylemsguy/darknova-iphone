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

//
//  OptionsCell.m
//  S1
//
//  Created by Alexey Medvedev on 15.12.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "OptionsCell.h"
#import "OptionsProtocol.h"
#define kCellHeight	25.0

// cell identifier for this custom cell
NSString *oDisplayCell_ID = @"oDisplayCell_ID";


@implementation OptionsCell

@synthesize comment, isEnabled;

#define kSwitchButtonWidth		94.0
#define kSwitchButtonHeight		27.0

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;

		CGRect aRect = CGRectMake(14, 7, kSwitchButtonWidth, kSwitchButtonHeight);
		isEnabled = [[UISwitch alloc] initWithFrame:aRect];
		[isEnabled addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
		[self.contentView addSubview:isEnabled];
		
		textField = [[UITextField alloc] initWithFrame:aRect];
		
		textField.borderStyle = UITextBorderStyleRoundedRect;
		textField.textColor = [UIColor blackColor];
		textField.font = [UIFont systemFontOfSize:17.0];

		textField.backgroundColor = [UIColor whiteColor];
		textField.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
		
		textField.keyboardType = UIKeyboardTypeDefault;
		textField.returnKeyType = UIReturnKeyDone;
		
		textField.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
		
		[textField setBackgroundColor:[UIColor whiteColor]];
		//textField.keyboardType=UIKeyboardTypeNumberPad;
		textField.returnKeyType=UIReturnKeyDone;
		textField.delegate = self;
		//[self addSubview:myTextField];
		
		
		CGRect newRect = CGRectMake(14 + kSwitchButtonWidth,5, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
		comment = [[UILabel alloc] initWithFrame:newRect];
		comment.backgroundColor = [UIColor clearColor];
		comment.opaque = NO;
		comment.textColor = [UIColor blackColor];
		comment.highlightedTextColor = [UIColor blackColor];
		comment.font = [UIFont systemFontOfSize:12];
		[self.contentView addSubview:comment];
		
		//changedValue = nil;
		
    }
    return self;
}

-(void)setBool:(bool)b {
	[self addSubview:isEnabled ];
	[textField removeFromSuperview];	
	[isEnabled setOn:b animated:FALSE];
}

-(void)setInt:(int)i
{
	[self addSubview:textField];
	[isEnabled removeFromSuperview];
	textField.text = [NSString stringWithFormat:@"%i", i];
}


-(void)setDelegate:(id)d num:(NSInteger)num
{
	_delegate = d;
	numItem = num;
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField1
{
	int value =textField1.text.intValue; 
	[_delegate optionsChanged:numItem valueInt:value];
	[textField1 resignFirstResponder];
	return YES;
}

- (void)switchAction:(id)sender
{
	[_delegate optionsChanged:numItem value:[sender isOn]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];
}


- (void)dealloc {
	[comment dealloc];
	[isEnabled dealloc];
	[textField dealloc];
    [super dealloc];
}


@end
