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
//  OptionsProtocol.h
//  S1
//
//  Created by Alexey Medvedev on 16.12.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol OptionsChangeDelegate<NSObject>
@optional

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)optionsChanged:(NSInteger)id value:(bool)value;
- (void)optionsChanged:(NSInteger)id valueInt:(int)value;

@end

