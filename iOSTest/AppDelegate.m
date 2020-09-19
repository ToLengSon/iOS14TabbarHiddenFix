//
//  AppDelegate.m
//  iOSTest
//
//  Created by wsong on 2020/9/19.
//

#import "AppDelegate.h"
#import "TianMuMain1ViewController.h"
#import "TianMuMain2ViewController.h"
#import "TianMuMain3ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    UITabBarController *tabbarVC = [[UITabBarController alloc] init];
    tabbarVC.viewControllers = @[
        [[UINavigationController alloc] initWithRootViewController:[TianMuMain1ViewController new]],
        [[UINavigationController alloc] initWithRootViewController:[TianMuMain2ViewController new]],
        [[UINavigationController alloc] initWithRootViewController:[TianMuMain3ViewController new]],
    ];
    self.window.rootViewController = tabbarVC;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
