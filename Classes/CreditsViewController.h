// 
//  CreditsViewController.h
//
//  Copyright (C) Dead Jim Studios 2009-2010, All rights reserved.
//
// This file is part of HyperWARP.
//
// HyperWARP is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// HyperWARP is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with HyperWARP.  If not, see <http://www.gnu.org/licenses/>.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface CreditsViewController : UIViewController <UIAlertViewDelegate, MFMailComposeViewControllerDelegate> {
	IBOutlet UIWebView			*webView;
	IBOutlet UINavigationBar	*navBar;
	int emailType;
	NSURL *location;
	
}

@property(retain) NSURL *location;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;

-(IBAction)chooseEmailAction;

-(IBAction)closeViewAction;

@end
