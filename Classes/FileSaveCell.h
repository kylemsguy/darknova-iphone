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
