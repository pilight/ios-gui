//
//  AppDelegate.m
//  pilight
//
//  Created by Martin Kollaard on 30-09-13.
//  Copyright (c) 2013 Martin Kollaard. All rights reserved.
//

#import "AppDelegate.h"
#import "SwitchesViewController.h"
#import "LoadViewController.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buildInterface) name:@"pilightConfigLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnected:) name:@"pilightDisconnected" object:nil];
    LoadViewController *loadview = [[LoadViewController alloc] init];
    self.window.rootViewController = loadview;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)disconnected:(NSNotification *)notification  {
    NSError *error = [notification object];
    if (![self.window.rootViewController isKindOfClass:[LoadViewController class]]) {
        LoadViewController *loadview = [[LoadViewController alloc] init];
        [loadview setErrorMessage:[error localizedDescription]];
        self.window.rootViewController = loadview;
    } else {
        [(LoadViewController *)self.window.rootViewController setErrorMessage:[error localizedDescription]];
    }
}

- (void)buildInterface {
    NSMutableArray *viewcontrollers = [[NSMutableArray alloc] init];
    
    for (PLRoom *room in [[PilightController shared] rooms]) {
        SwitchesViewController *switchView = [[SwitchesViewController alloc] initWithNibName:@"SwitchesViewController" bundle:Nil];
        [switchView setRoom:room];
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:[room name] image:nil tag:0];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:switchView];
        [navigationController setTabBarItem:item];
        [viewcontrollers addObject:navigationController];
    }
    
    UITabBarController *tabbar = [[UITabBarController alloc] init];
    tabbar.viewControllers = viewcontrollers;
    
    self.window.rootViewController = tabbar;

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if ([[PilightController shared] connected]) {
        [[PilightController shared] disconnect];
        NSLog(@"Disconnect!");
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if ([[PilightController shared] hostname]) {
        [[PilightController shared] connect];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
