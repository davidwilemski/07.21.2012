//
//  BaseViewController.h
//  Games4u
//
//  Created by Alexander Haefner on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJson.h"

@interface BaseViewController : UIViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    NSMutableData *connection_data;
}

@property (strong, nonatomic) SBJsonParser *parser;
@property (strong, nonatomic) SBJsonWriter *writer;

- (NSMutableDictionary*) createStandardRequestDict;
- (void) makeHTTPConnection:(NSString*)url withParams:(NSMutableDictionary*)dict;
- (void) HTTPRequestFailed:(NSURLResponse *)response;
- (void) HTTPRequestFinished:(NSMutableDictionary*)body;
- (void) HTTPRequestReceivedResponse:(NSURLResponse*)response;
@end
