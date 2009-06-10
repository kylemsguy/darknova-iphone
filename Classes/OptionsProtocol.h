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

