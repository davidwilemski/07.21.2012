//
//  AppDelegate.m
//  Games4u
//
//  Created by Alexander Haefner on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize hostURL = _hostURL;
@synthesize pushNotificationToken = _pushNotificationToken;
@synthesize currentUser = _currentUser;
@synthesize currentUrl = _currentUrl;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.hostURL = @"http://23.21.143.75:8888";
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    if(launchOptions != nil) { 
        NSDictionary* dict = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if(dict != nil) {
            [self addMessageFromRemoteNotification:dict updateUI:NO];
        }
    }
    return YES;
}
		
- (void) addMessageFromRemoteNotification:(NSMutableDictionary*)dict updateUI:(BOOL)update {
    [(ViewController*)self.window.rootViewController openUrl:[dict objectForKey:@"domain"]];
}

- (void)application:(UIApplication*) application  didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"MY device token is: %@", deviceToken);
    self.pushNotificationToken = deviceToken;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    if([title isEqualToString:@"Accept"]) {
        [(ViewController*)self.window.rootViewController openUrl:self.currentUrl];
    }
        
}

//Convert push notification token to hex
- (NSString *)hexadecimalStringWithData:(NSData*)data {
    /* Returns hexadecimal string of NSData. Empty string if data is empty.   */
    
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    
    if (!dataBuffer)
        return [NSString string];
    
    NSUInteger          dataLength  = [data length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02x", (unsigned long)dataBuffer[i]]];
    
    return [NSString stringWithString:hexString];
}

-(void) application:(UIApplication*) application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    NSLog(@"Push Notification: %@", userInfo);
    self.currentUrl = [userInfo objectForKey:@"domain"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[userInfo objectForKey:@"title"] message:[userInfo objectForKey:@"msg"] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Accept", nil];
    [alert show];
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

-(NSString*)getConcantenatedHostUrl:(NSString*)path
{
    return [self.hostURL stringByAppendingString:path];
}

@end
