//
//  AlertModalWindow.h
//  S1
//
//  Created by Alexey Medvedev on 08.10.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AlertModalWindow : UIAlertView< UITextFieldDelegate> {
	UITextField *	myTextField;
	int				pressedButton;
}

@property (nonatomic, retain)	UITextField *	myTextField;
@property int									pressedButton;

- (id)initWithTitle:(NSString *)title yoffset:(int)yoffset  message:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle thirdButtonTitle:(NSString*)thirdButtonTitle;

@end
