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
//  AlertModalWindow.m
//  S1
//
//  Created by Alexey Medvedev on 08.10.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AlertModalWindow.h"


@implementation AlertModalWindow

@synthesize myTextField, pressedButton;

+(void)initialize
{
	[super initialize];
}

- (id)initWithTitle:(NSString *)title yoffset:(int)yoffset  message:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle thirdButtonTitle:(NSString*)thirdButtonTitle
{
	[self initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:okButtonTitle, thirdButtonTitle, nil];
	myTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, yoffset, 260.0, 25.0)];
	[myTextField setBackgroundColor:[UIColor whiteColor]];
	
	myTextField.returnKeyType=UIReturnKeyDone;
	myTextField.delegate = self;
	
	[self addSubview:myTextField];
	CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0.0, 60.0);
	[self setTransform:myTransform];	
	
	//[myAlertView show];
	//[myAlertView release];
	return self;
}

-(void)dealloc {
	//[myTextField dealloc];
	[super dealloc];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex  // after animation
{
	pressedButton = buttonIndex;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField1
{

	[textField1 resignFirstResponder];
	return YES;
}

@end
