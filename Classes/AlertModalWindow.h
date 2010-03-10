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
