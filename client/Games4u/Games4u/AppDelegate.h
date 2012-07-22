//
//  AppDelegate.h
//  Games4u
//
//  Created by Alexander Haefner on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *hostURL;
@property (strong, nonatomic) NSData *pushNotificationToken;
@property (strong, nonatomic) NSString *currentUser;
@property (strong, nonatomic) NSString *currentUrl;

-(NSString*)getConcantenatedHostUrl:(NSString*)path;
- (NSString *)hexadecimalStringWithData:(NSData*)data;

@end
