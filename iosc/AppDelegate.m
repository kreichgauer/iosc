//
//  AppDelegate.m
//  iosc
//
//  Created by mf on 27.10.12.
//  Copyright (c) 2012 Michael Frister. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

@synthesize oscManager;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

    self.motionManager = [[CMMotionManager alloc] init];


    //Gyroscope
    if([self.motionManager isGyroAvailable])
    {
        /* Start the gyroscope if it is not active already */
        if([self.motionManager isGyroActive] == NO)
        {
            /* Update us 2 times a second */
            [self.motionManager setGyroUpdateInterval:1.0f / 60];
            
            /* And on a handler block object */

            /* Receive the gyroscope data on this block */
            [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue]
                                            withHandler:^(CMGyroData *gyroData, NSError *error)
             {
                 NSString *x = [[NSString alloc] initWithFormat:@"%.02f",gyroData.rotationRate.x];
                 NSString *y = [[NSString alloc] initWithFormat:@"%.02f",gyroData.rotationRate.y];
                 NSString *z = [[NSString alloc] initWithFormat:@"%.02f",gyroData.rotationRate.z];
                 NSLog(@"%@,%@,%@", x, y, z);
             }];
        }
    }
    else
    {
        NSLog(@"Gyroscope not Available!");
    }

    // create an OSCManager- set myself up as its delegate
    oscManager = [[OSCManager alloc] init];
    OSCManager *manager = oscManager;
    [manager setDelegate:self];
    
    // create an input port for receiving OSC data
    [manager createNewInputForPort:1234];
    
    // create an output so i can send OSC data to myself
    OSCOutPort *outPort = [manager createNewOutputToAddress:@"192.168.251.12" atPort:1234];
    
    // make an OSC message
    OSCMessage *newMsg = [OSCMessage createWithAddress:@"/Address/Path/1"];
    
    // add a bunch arguments to the message
    [newMsg addInt:12];
    [newMsg addFloat:12.34];
    [newMsg addBOOL:YES];
    [newMsg addString:@"Hello World!"];

    // send the OSC message
    [outPort sendThisMessage:newMsg];
    
    return YES;
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
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
