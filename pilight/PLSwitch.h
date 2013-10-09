//
//  PLSwitch.h
//  pilight
//
//  Created by Martin Kollaard on 04-10-13.
//  Copyright (c) 2013 Martin Kollaard. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PLSwitch : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *key;
@property (nonatomic,strong) PLRoom *room;
@property (nonatomic,assign) int order;

@property (nonatomic, assign) BOOL state;
@property (nonatomic, assign) int type;

@property (nonatomic, assign) int dimlevel;
@property (nonatomic, assign) int maxDimlevel;
@property (nonatomic, assign) int minDimlevel;

-(void)changeToState:(BOOL)state;
-(void)changeToState:(BOOL)state withDimlevel:(int)dimLevel;

@end
