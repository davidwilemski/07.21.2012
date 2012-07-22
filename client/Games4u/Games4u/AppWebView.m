//
//  AppWebView.m
//  Games4u
//
//  Created by Alexander Haefner on 7/22/12.
//  Copyright (c) 2012 umich. All rights reserved.
//

#import "AppWebView.h"
#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppWebView
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame withDelegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        delegateReadyToDisplay = NO;
        self.delegate = delegate;
        // Initialization code
    }
    return self;
}
- (void) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *requestString = [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSArray *requestArray = [requestString componentsSeparatedByString:@":##sendToApp##"];
    
    if ([requestArray count] > 1){
        NSString *requestPrefix = [[requestArray objectAtIndex:0] lowercaseString];
        NSString *requestMssg = ([requestArray count] > 0) ? [requestArray objectAtIndex:1] : @"";
        [self webviewMessageKey:requestPrefix value:requestMssg];
        return NO;
    }
    else if (navigationType == UIWebViewNavigationTypeLinkClicked && [self shouldOpenLinksExternally]) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return YES;
}

- (void) webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"START LOAD");
}

- (void) webviewMessageKey:(NSString*)key value:(NSString*)val {
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    if([key isEqualToString:@"push"]) {
        if([val isEqualToString:@"get"]) {
            [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"getToken(%@);", app.pushNotificationToken]];
        }
    }
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Web view failed");
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"hey");
    if (delegateReadyToDisplay) {
        [(ViewController*)self.delegate displayCurrentWebView];
    } else {
        finishedLoading = YES;
    }
}

- (void) showWebView {
    if (finishedLoading == YES) {
        [(ViewController*)self.delegate displayCurrentWebView];
    } else {
        delegateReadyToDisplay = YES;
    }
}

- (BOOL) shouldOpenLinksExternally {
    return NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
