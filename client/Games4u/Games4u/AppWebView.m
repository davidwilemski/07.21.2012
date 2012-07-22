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
@synthesize controllerDelegate = _controllerDelegate;

- (id)initWithDelegate:(id)d {
    self = [super init];
    if (self) {
        delegateReadyToDisplay = NO;
        self.controllerDelegate = d;
        [self setDelegate:self];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame withDelegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        delegateReadyToDisplay = NO;
        self.controllerDelegate = delegate;
        // Initialization code
    }
    return self;
}
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *requestString = [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSArray *requestArray = [requestString componentsSeparatedByString:@":##sendToApp##"];
    NSLog(@"grey: %@", requestString);
    
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
    NSLog(@"Key, value: %@ %@", key, val);
    if([key isEqualToString:@"push"]) {
        if([val isEqualToString:@"get"]) {
            [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"getToken('%@', '%@');", [app hexadecimalStringWithData:app.pushNotificationToken], app.currentUser]];
        }
    }
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Web view failed: %@", error);
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    if (delegateReadyToDisplay) {
        [(ViewController*)self.controllerDelegate displayCurrentWebView];
    } else {
        finishedLoading = YES;
    }
}

- (void) showWebView {
    if (finishedLoading == YES) {
        ViewController *controlDelegate = (ViewController*)self.controllerDelegate;
        [controlDelegate displayCurrentWebView];
        
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
