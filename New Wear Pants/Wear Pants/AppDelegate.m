//
//  AppDelegate.m
//  Wear Pants
//
//  Created by Sony Theakanath on 1/26/15.
//  Copyright (c) 2015 Sony Theakanath. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIViewController *centerViewController = [[ViewController alloc] init];
    MMExampleLeftSideDrawerViewController *leftside = [[MMExampleLeftSideDrawerViewController alloc] init];
    leftside.delegate = centerViewController;
    UIViewController *leftSideDrawerViewController = leftside;
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:centerViewController];
    MMDrawerController * drawerController = [[MMDrawerController alloc] initWithCenterViewController:navigationController leftDrawerViewController:leftSideDrawerViewController rightDrawerViewController:nil];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [drawerController setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
            MMDrawerControllerDrawerVisualStateBlock block;
            block = [[MMExampleDrawerVisualStateManager sharedManager] drawerVisualStateBlockForDrawerSide:drawerSide];
            if(block)
                block(drawerController, drawerSide, percentVisible);
     }];
    [drawerController setDrawerVisualStateBlock:[MMDrawerVisualState swingingDoorVisualStateBlock]];
    [navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],  NSForegroundColorAttributeName,[UIColor whiteColor], NSForegroundColorAttributeName,[NSValue valueWithUIOffset:UIOffsetMake(0, -1)], NSForegroundColorAttributeName,[UIFont fontWithName:@"Roboto-Medium" size:20.0], NSFontAttributeName,nil]];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:drawerController];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
