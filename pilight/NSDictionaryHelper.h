//
//  NSDictionaryHelper.h
//  Socialist
//
//  Created by Rens Verhoeven on 19-03-13.
//  Copyright (c) 2013 The BKRY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NSDictionaryHelper)
/*
 Check if the object associated with the key exists and/or is not null
*/
-(BOOL)isValidObjectForKey:(NSString *)key;

@end
