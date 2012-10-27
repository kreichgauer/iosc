//
//  ViewController.m
//  iosc
//
//  Created by mf on 27.10.12.
//  Copyright (c) 2012 Michael Frister. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize oscManager;
@synthesize motionManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.motionManager = [[CMMotionManager alloc] init];

    // create an OSCManager- set myself up as its delegate
    oscManager = [[OSCManager alloc] init];
    [oscManager setDelegate: self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)connectPressed:(UIButton *)sender
{
    if([self.motionManager isDeviceMotionAvailable])
    {
        if([self.motionManager isGyroActive] == NO)
        {
            motionManager.deviceMotionUpdateInterval = 1.0f / 5;
            OSCOutPort *outPort = [oscManager createNewOutputToAddress:ipField.text atPort:portField.text.intValue];

            [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                            withHandler:^(CMDeviceMotion *motionData, NSError *error)
             {
                 CMAttitude *attitude = motionData.attitude;
                 CMAcceleration acceleration = motionData.userAcceleration;
//                 NSLog(@"yaw: %f pitch: %f roll %f", attitude.yaw, attitude.pitch, attitude.roll);

                 OSCMessage *gyroMsg = [OSCMessage createWithAddress:@"/rotation"];
                 [gyroMsg addFloat:attitude.yaw];
                 [outPort sendThisMessage:gyroMsg];

                 OSCMessage *accelerationMsg = [OSCMessage createWithAddress:@"/acceleration"];
                 [accelerationMsg addFloat:acceleration.x];
                 [accelerationMsg addFloat:acceleration.y];
                 [accelerationMsg addFloat:acceleration.z];
                 [outPort sendThisMessage:accelerationMsg];
             }];

            [connectButton setHighlighted:YES];
            [disconnectButton setHighlighted:NO];
        }
    }
    else
    {
        NSLog(@"Gyroscope not Available!");
    }
}

- (IBAction)disconnectPressed:(UIButton *)sender
{
    [self.motionManager stopDeviceMotionUpdates];
    [connectButton setHighlighted:NO];
    [disconnectButton setHighlighted:YES];
}

@end
