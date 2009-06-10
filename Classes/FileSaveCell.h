//
//  FileSaveCell.h
//  S1
//
//  Created by Alexey Medvedev on 13.12.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *kDisplayCell_ID;

@interface FileSaveCell : UITableViewCell {

	UILabel	*nameLabel;
	UILabel	*infoLabel;

}

@property (nonatomic, retain) UILabel *infoLabel;
@property (nonatomic, retain) UILabel *nameLabel;

@end
