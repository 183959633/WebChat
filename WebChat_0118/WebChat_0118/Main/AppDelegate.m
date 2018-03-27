//
//  AppDelegate.m
//  WebChat_0118
//
//  Created by Jack on 2018/1/11.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
@interface AppDelegate ()
@end
@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    RootViewController *root    = [[RootViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:root];
    _window.rootViewController  = nav;
    [_window makeKeyAndVisible];
    return YES;
}
@end
