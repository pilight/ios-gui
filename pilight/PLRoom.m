//
//  PLRoom.m
//  pilight
//
//  Created by Martin Kollaard on 04-10-13.
//  Copyright (c) 2013 Martin Kollaard. All rights reserved.
//

#import "PLRoom.h"

@implementation PLRoom

-(id)init {
    if((self = [super init])) {
        _devices = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)addDevice:(id)device {
    [self.devices addObject:device];
    
    [self.devices sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 order] < [obj2 order]) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    
}

@end
