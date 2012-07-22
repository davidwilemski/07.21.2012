//
//  AppWebView.h
//  Games4u
//
//  Created by Alexander Haefner on 7/22/12.
//  Copyright (c) 2012 umich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppWebView : UIWebView <UIWebViewDelegate>
{
    BOOL delegateReadyToDisplay;
    BOOL finishedLoading;
    id controllerDelegate;
}

@property (nonatomic, strong) id controllerDelegate;
- (id)initWithDelegate:(id)d;
- (void) showWebView;
- (BOOL) shouldOpenLinksExternally;
- (void) webView:(UIWebView *)webView;
- (void) webviewMessageKey:(NSString*)key value:(NSString*)val;
@end
