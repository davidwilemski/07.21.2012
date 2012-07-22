//
//  DisplayImage.m
//  Games4u
//
//  Created by Alexander Haefner on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DisplayImage.h"
#import "AppDelegate.h"
#import "ViewController.h"

@implementation DisplayImage

@synthesize delegate = _delegate;
@synthesize domain = _domain;

- (id) initWithURL:(NSString*)url andDomain:(NSString*)domain andDelegate:(id)delegate {
    self = [super init];
    if(self) {
        [self makeHTTPConnection:url withParams:[[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"GET", @"", nil] forKeys:[NSArray arrayWithObjects:@"request_method", @"body", nil]]];
        [self setUserInteractionEnabled:YES];
        self.domain = domain;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [(ViewController*)self.delegate initTouchForAppDomain:self.domain];
}


- (void) makeHTTPConnection:(NSString*)url withParams:(NSMutableDictionary*)dict {
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSURL *req_url = [NSURL URLWithString:[app getConcantenatedHostUrl:url]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:req_url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSString* requestMethod = [dict objectForKey:@"request_method"];
    [request setHTTPMethod:requestMethod];
    
    [request addValue:@"Content-Type" forHTTPHeaderField:@"application/x-www-form-urlencoded"];
    
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString *body = [dict objectForKey:@"body"];
    
    //TODO: Add Client Login
    //[request addValue:app.usercookie forHTTPHeaderField:@"Cookie"];
    
    [request setHTTPBody: [body dataUsingEncoding:NSASCIIStringEncoding]];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if(connection_data == nil)
        connection_data = [[NSMutableData alloc] initWithData: data];
    else 
        [connection_data appendData: data];
}
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
    NSDictionary *fields = [HTTPResponse allHeaderFields];
    if([HTTPResponse statusCode] != 200) {
        [self HTTPRequestFailed:response];
    } else {
        [self HTTPRequestReceivedResponse:response];
    }
}
- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    UIImage *img = [UIImage imageWithData:connection_data];
    [self setImage:img];
    CGRect frame;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        frame = CGRectMake(0.0, 0.0, 160.0, 240.0);
    } else {
        frame = CGRectMake(0.0, 0.0, 160.0, 240.0);
    }
    [self setFrame:frame];
    [((ViewController*)self.delegate) incrementImgLoadCount];
    connection_data = nil;
}
- (void) HTTPRequestFailed:(NSURLResponse *)response {
    NSLog(@"This method should be implemented by subclasses that use http requests");
}

- (void) HTTPRequestFinished:(NSMutableDictionary*)body {
    NSLog(@"This method should be implemented by subclasses that use http requests");
}
- (void) HTTPRequestReceivedResponse:(NSURLResponse *)response {
    NSLog(@"This method should be implemented by subclasses that use http requests");
}
- (BOOL)canBecomeFirstResponder {
    return YES;
}
@end
