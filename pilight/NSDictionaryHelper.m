//
//  NSDictionaryHelper.m
//  Socialist
//
//  Created by Rens Verhoeven on 19-03-13.
//  Copyright (c) 2013 The BKRY. All rights reserved.
//

#import "NSDictionaryHelper.h"

@implementation NSDictionary (NSDictionaryHelper)

-(BOOL)isValidObjectForKey:(NSString *)key {
    if (![self objectForKey:key]) {
        return NO;
    } else if ([[self objectForKey:key] isKindOfClass:[NSNull class]]) {
        return NO;
    } else if ([self objectForKey:key] == nil) {
        return NO;
    } else {
        return YES;
    }
}

@end
