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
    // Dispose of any resources that can be recreated.
}

- (IBAction)connectPressed:(UIButton *)sender
{
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
                 // create an output so i can send OSC data to myself
                 OSCOutPort *outPort = [oscManager createNewOutputToAddress:ipField.text atPort:portField.text.intValue];
                 
                 NSString *x = [[NSString alloc] initWithFormat:@"%.02f",gyroData.rotationRate.x];
                 NSString *y = [[NSString alloc] initWithFormat:@"%.02f",gyroData.rotationRate.y];
                 NSString *z = [[NSString alloc] initWithFormat:@"%.02f",gyroData.rotationRate.z];
                 NSLog(@"%@,%@,%@", x, y, z);
                 
                 // make an OSC message
                 OSCMessage *newMsg = [OSCMessage createWithAddress:@"/Address/Path/1"];

                 // add a bunch arguments to the message
                 [newMsg addFloat:gyroData.rotationRate.x];
                 [newMsg addFloat:gyroData.rotationRate.y];
                 [newMsg addFloat:gyroData.rotationRate.z];
                 
                 // send the OSC message
                 [outPort sendThisMessage:newMsg];
             }];
        }
    }
    else
    {
        NSLog(@"Gyroscope not Available!");
    }
}

- (IBAction)disconnectPressed:(UIButton *)sender
{
    
}

@end
