//
//  FileSaveCell.m
//  S1
//
//  Created by Alexey Medvedev on 13.12.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "FileSaveCell.h"

#define kCellHeight	25.0

// cell identifier for this custom cell
NSString *kDisplayCell_ID = @"DisplayCell_ID";


@implementation FileSaveCell

@synthesize nameLabel, infoLabel;


- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		CGRect aRect = CGRectMake(3, 3, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
		nameLabel = [[UILabel alloc] initWithFrame:aRect];
		nameLabel.backgroundColor = [UIColor clearColor];
		nameLabel.opaque = NO;
		nameLabel.textColor = [UIColor blackColor];
		nameLabel.highlightedTextColor = [UIColor blackColor];
		nameLabel.font = [UIFont boldSystemFontOfSize:18];
		[self.contentView addSubview:nameLabel];

		CGRect newRect = CGRectMake(3, 25, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
		infoLabel = [[UILabel alloc] initWithFrame:newRect];
		infoLabel.backgroundColor = [UIColor clearColor];
		infoLabel.opaque = NO;
		infoLabel.textColor = [UIColor grayColor];
		infoLabel.highlightedTextColor = [UIColor blackColor];
		infoLabel.font = [UIFont systemFontOfSize:10];
		[self.contentView addSubview:infoLabel];
		
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];
	
	// when the selected state changes, set the highlighted state of the lables accordingly
//	nameLabel.highlighted = selected;
//	infoLabel.highlighted = selected;
    // Configure the view for the selected state
}


- (void)dealloc {
	[infoLabel release];
	[nameLabel release];
    [super dealloc];

}


@end
