//
//  PLSwitch.m
//  pilight
//
//  Created by Martin Kollaard on 04-10-13.
//  Copyright (c) 2013 Martin Kollaard. All rights reserved.
//

#import "PLSwitch.h"

@implementation PLSwitch

-(id)init {
    if((self = [super init])) {
        
    }
    return self;
}

-(void)changeToState:(BOOL)state withDimlevel:(int)dimLevel {
    if (_room != nil && (_state != state || _dimlevel != dimLevel)) {
        [[PilightController shared] setDevice:self state:state withDimLevel:dimLevel];
    }
    _state = state;
    _dimlevel = dimLevel;
}

-(void)changeToState:(BOOL)state {
    if (_room != nil && _state != state) {
        [[PilightController shared] setDevice:self state:state];
    }
    _state = state;
}
@end
