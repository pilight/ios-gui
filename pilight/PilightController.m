//
//  PilightController.m
//  pilight
//
//  Created by Martin Kollaard on 30-09-13.
//  Copyright (c) 2013 Martin Kollaard. All rights reserved.
//

#import "PilightController.h"

@implementation PilightController

-(id)init {
    if((self = [super init])) {
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        _rooms = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)connectWithHostname:(NSString *)hostname port:(int)port {
    [self setPort:port];
    [self setHostname:hostname];
    [self connect];
}

-(void)connect {
    NSLog(@"connecting to %@ on port %i", _hostname, _port);
    NSError *err = nil;
    [self disconnect];
    self.connected = YES;
    if (![_socket connectToHost:_hostname onPort:_port error:&err])
    {
        NSLog(@"I goofed: %@", err);
        self.connected = NO;
    }
}

-(void)disconnect {
    if (self.connected) {
        self.connected = NO;
        [_socket disconnect];
        
    }
        
}

- (void)socket:(GCDAsyncSocket *)sender didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"Connected!");
    self.connected = YES;
    [self sendData:@{@"message":@"client gui"}];
    [_socket readDataWithTimeout:-1 tag:1];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)error {
    if (self.connected) {
        NSLog(@"Disconnected: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pilightDisconnected" object:error];
    }
    self.connected = NO;
}


- (void)sendData:(NSDictionary *)message {
    
    NSLog(@"Sending: %@", message);
    
    [_socket writeData:[NSJSONSerialization dataWithJSONObject:message options:kNilOptions error:nil] withTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sender didReadData:(NSData *)data withTag:(long)tag
{
    NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@", json);
    if (tag == 1) {
        if ([[json objectForKey:@"message"] isEqualToString:@"accept client"]) {
            [self sendData:@{@"message":@"request config"}];
        }
    } else {
        if ([json isValidObjectForKey:@"config"]) {
            [self parseConfig:[json objectForKey:@"config"]];
        } else if ([json isValidObjectForKey:@"origin"] && [[json objectForKey:@"origin"] isEqualToString:@"config"]) {
            [self configUpdate:json];
        }
    }
    [_socket readDataWithTimeout:-1 tag:tag+1];
}

- (void)configUpdate:(NSMutableDictionary *)config {
    NSString *roomName = [[[config objectForKey:@"devices"] allKeys] objectAtIndex:0];
    NSString *deviceName = [[[config objectForKey:@"devices"] objectForKey:roomName] objectAtIndex:0];
    
    id device = [self findDeviceByName:deviceName ofRoom:roomName];
    if (device) {
        if ([[config objectForKey:@"values"] isValidObjectForKey:@"dimlevel"])
            [device setDimlevel:[[[config objectForKey:@"values"] objectForKey:@"dimlevel"] intValue]];
        if ([[config objectForKey:@"values"] isValidObjectForKey:@"state"])
            [device setState:[[[config objectForKey:@"values"] objectForKey:@"state"] isEqualToString:@"on"]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pilightDeviceChanged" object:[NSString stringWithFormat:@"%@%@", roomName, deviceName]];
    }
}

- (void)parseConfig:(NSMutableDictionary *)config {
    [self.rooms removeAllObjects];
    for (NSString *roomKey in [config allKeys]) {
        NSMutableDictionary *roomConfig = [config objectForKey:roomKey];
        PLRoom *room = [[PLRoom alloc] init];
        
        [room setName:[roomConfig objectForKey:@"name"]];
        [room setKey:roomKey];
        [room setOrder:[[roomConfig objectForKey:@"order"] intValue]];
        [[room devices] removeAllObjects];
        for (NSString *deviceKey in [roomConfig allKeys]) {
            if ([[roomConfig objectForKey:deviceKey] isKindOfClass:[NSMutableDictionary class]]) {
                if ([[[roomConfig objectForKey:deviceKey] objectForKey:@"type"] intValue] == 1 || [[[roomConfig objectForKey:deviceKey] objectForKey:@"type"] intValue] == 2 || [[[roomConfig objectForKey:deviceKey] objectForKey:@"type"] intValue] == 4) {
                    PLSwitch * device = [[PLSwitch alloc] init];
                    [device setKey:deviceKey];
                    [device setName:[[roomConfig objectForKey:deviceKey] objectForKey:@"name"]];
                    [device setOrder:[[[roomConfig objectForKey:deviceKey] objectForKey:@"order"] intValue]];
                    [device setType:[[[roomConfig objectForKey:deviceKey] objectForKey:@"type"] intValue]];
                    [device setState:([[[roomConfig objectForKey:deviceKey] objectForKey:@"state"] isEqualToString:@"on"])];
                    
                    if ([[[roomConfig objectForKey:deviceKey] objectForKey:@"type"] intValue] == 2) {
                        [device setDimlevel:[[[roomConfig objectForKey:deviceKey] objectForKey:@"dimlevel"] intValue]];
                        [device setMaxDimlevel:[[[[roomConfig objectForKey:deviceKey] objectForKey:@"settings"] objectForKey:@"max"] intValue]];
                        [device setMinDimlevel:[[[[roomConfig objectForKey:deviceKey] objectForKey:@"settings"] objectForKey:@"min"] intValue]];
                    }
                    [device setRoom:room];
                    [room addDevice:device];
                }
            }
        }
        
        [self.rooms addObject:room];
    }
    
    [self.rooms sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 order] < [obj2 order]) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pilightConfigLoaded" object:nil];
}

- (void)setDevice:(PLSwitch *)device state:(BOOL)state withDimLevel:(int)dimLevel {
    [self sendData:@{@"message":@"send", @"code":@{@"location" : [[device room] key], @"device":[device key],@"state":(state ? @"on" : @"off"), @"values" : @{@"dimlevel" : [NSString stringWithFormat:@"%i", dimLevel]}}}];
}

- (void)setDevice:(PLSwitch *)device state:(BOOL)state {
    [self sendData:@{@"message":@"send", @"code":@{@"location" : [[device room] key], @"device":[device key],@"state":(state ? @"on" : @"off")}}];
}

-(id)findDeviceByName:(NSString *)deviceName ofRoom:(NSString *) roomName {
    for (PLRoom *room in self.rooms) {
        if ([[room key] isEqualToString:roomName]) {
            for (id device in [room devices]) {
                if ([[device key] isEqualToString:deviceName])
                    return device;
            }
            return false;
        }
    }
    return false;
}

+ (PilightController *)shared {
    static PilightController *_sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedController = [[PilightController alloc] init];
    });
    return _sharedController;
}

@end
