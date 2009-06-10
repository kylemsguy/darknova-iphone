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
