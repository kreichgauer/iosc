//
//  ViewController.h
//  iosc
//
//  Created by mf on 27.10.12.
//  Copyright (c) 2012 Michael Frister. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <VVOSC/VVOSC.h>

@interface ViewController : UIViewController {
    IBOutlet UITextField *ipField;
    IBOutlet UITextField *portField;
}

@property (retain, nonatomic) CMMotionManager *motionManager;
@property (retain, nonatomic) OSCManager *oscManager;

- (IBAction)connectPressed:(UIButton *)sender;
- (IBAction)disconnectPressed:(UIButton *)sender;

@end
