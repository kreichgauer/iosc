//
//  AppDelegate.h
//  iosc
//
//  Created by mf on 27.10.12.
//  Copyright (c) 2012 Michael Frister. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) CMMotionManager *motionManager;

@property (strong, nonatomic) ViewController *viewController;

@end
