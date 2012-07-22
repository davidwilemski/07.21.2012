//
//  BaseViewController.m
//  Games4u
//
//  Created by Alexander Haefner on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

@synthesize parser = _parser;
@synthesize writer = _writer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.parser = [[SBJsonParser alloc] init];
    self.writer = [[SBJsonWriter alloc] init];
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

- (NSMutableDictionary*)createStandardRequestDict {
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"GET", @"", nil] forKeys:[NSArray arrayWithObjects:@"request_method", @"body", nil]];
    return dict;
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
    [self HTTPRequestFinished:[self.parser objectWithData:connection_data]];
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

@end
