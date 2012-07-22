//
//  LoginPageViewController.m
//  Games4u
//
//  Created by Alexander Haefner on 7/22/12.
//  Copyright (c) 2012 umich. All rights reserved.
//

#import "LoginPageViewController.h"
#import "AppDelegate.h"

@interface LoginPageViewController ()

@end

@implementation LoginPageViewController

@synthesize field = _field;
@synthesize submit = _submit;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)send:(id)sender 
{

    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    [self makeHTTPConnection:[NSString stringWithFormat:@"/login?username=%@&device_token=%@",[self.field text], [app hexadecimalStringWithData:app.pushNotificationToken ]]  withParams:[self createStandardRequestDict]];
    app.currentUser = self.field.text; //When you're tired, you do things like this.
    [self.field removeFromSuperview];
    [self.submit removeFromSuperview];
    [self.field resignFirstResponder];
}

- (void)HTTPRequestFinished:(NSMutableDictionary *)body
{
    [self performSegueWithIdentifier:@"LoginSegue" sender:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
