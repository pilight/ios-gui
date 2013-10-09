//
//  PilightController.h
//  pilight
//
//  Created by Martin Kollaard on 30-09-13.
//  Copyright (c) 2013 Martin Kollaard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GCDAsyncSocket.h>
@interface PilightController : NSObject

@property (nonatomic,strong) NSMutableArray *rooms;

@property (nonatomic,strong) NSString *hostname;
@property (nonatomic,assign) int port;
@property (nonatomic,strong) GCDAsyncSocket *socket;
@property (nonatomic,assign) int tag;
@property (nonatomic,assign) bool connected;


-(void)setDevice:(PLSwitch *)device state:(BOOL)state withDimLevel:(int)dimLevel;
-(void)setDevice:(PLSwitch *)device state:(BOOL)state;
-(void)connectWithHostname:(NSString *)hostname port:(int)port;
-(void)connect;
-(void)disconnect;

+ (PilightController *)shared;

@end
