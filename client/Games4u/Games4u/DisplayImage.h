//
//  DisplayImage.h
//  Games4u
//
//  Created by Alexander Haefner on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DisplayImage : UIImageView
{
    NSMutableData *connection_data;
    id delegate;
}
@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) NSString *domain;

- (id) initWithURL:(NSString*)url andDomain:(NSString*)domain andDelegate:(id)delegate;
- (void) makeHTTPConnection:(NSString*)url withParams:(NSMutableDictionary*)dict;
- (void) HTTPRequestFailed:(NSURLResponse *)response;
- (void) HTTPRequestFinished:(NSMutableDictionary*)body;
- (void) HTTPRequestReceivedResponse:(NSURLResponse*)response;
@end
