//
//  PLRoom.h
//  pilight
//
//  Created by Martin Kollaard on 04-10-13.
//  Copyright (c) 2013 Martin Kollaard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLRoom : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *key;
@property (nonatomic,assign) int order;
@property (nonatomic,strong) NSMutableArray *devices;

-(void)addDevice:(id)device;

@end
