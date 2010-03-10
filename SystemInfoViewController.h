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

@interface SystemInfoViewController : UIViewController<UINavigationBarDelegate>/* Specify a superclass (eg: NSObject or NSView) */ {
	IBOutlet	UILabel*	systemName;
	IBOutlet	UILabel*	systemSize;
	IBOutlet	UILabel*	systemTechLevel;
	IBOutlet	UILabel*	systemGoverment;
	IBOutlet	UILabel*	systemResources;
	IBOutlet	UILabel*	systemPolice;	
	IBOutlet	UILabel*	systemPirates;
//	IBOutlet	UILabel*	systemMessage;	
	IBOutlet	UITextView*	systemMessage;	
	
	IBOutlet	UIButton*	systemNews;
	IBOutlet	UIButton*	systemHire;
	IBOutlet	UIButton*	systemSpecial;	
}

/*@property (nonatomic, retain)	UILabel*	systemName;
@property (nonatomic, retain)	UILabel*	systemSize;
@property (nonatomic, retain)	UILabel*	systemTechLevel;
@property (nonatomic, retain)	UILabel*	systemGoverment;
@property (nonatomic, retain)	UILabel*	systemResources;
@property (nonatomic, retain)	UILabel*	systemPolice;	
@property (nonatomic, retain)	UILabel*	systemPirates;
@property (nonatomic, retain)	UILabel*	systemMessage;	*/



-(IBAction)testClick;
-(IBAction)doQuests;
-(IBAction)showNews;
-(IBAction)showHire;
-(IBAction)showSpecial;

-(void) UpdateView;
@end
