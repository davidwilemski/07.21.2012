//
//  LoginSegue.m
//  Games4u
//
//  Created by Alexander Haefner on 7/22/12.
//  Copyright (c) 2012 umich. All rights reserved.
//

#import "LoginSegue.h"
#import "LoginPageViewController.h"
#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation LoginSegue

@synthesize appDelegate = _appDelegate;

-(void) perform 
{
    self.appDelegate = [[UIApplication sharedApplication] delegate]; 
    
    
    UIViewController *destViewController = (ViewController *) self.destinationViewController;
    UIViewController *srcViewController = (LoginPageViewController *)self.sourceViewController;
    [srcViewController.view removeFromSuperview];
    [self.appDelegate.window addSubview:destViewController.view];
    
    self.appDelegate.window.rootViewController=destViewController;
    
    
    //[((LoginPageViewController*)self.sourceViewController).view removeFromSuperview];
}
@end
