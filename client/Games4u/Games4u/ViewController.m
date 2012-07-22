//
//  ViewController.m
//  Games4u
//
//  Created by Alexander Haefner on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize appstore = _appstore;
@synthesize appDomainToIndex = _appDomainToIndex;
@synthesize scrollView = _scrollView;
@synthesize webview = _webview;
@synthesize closeBtn = _closeBtn;
@synthesize currentIcon = _currentIcon;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self makeHTTPConnection:@"/apps" withParams:[self createStandardRequestDict]];
    loaded_imgs_count = 0;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)HTTPRequestFinished:(NSMutableDictionary *)body
{
    NSMutableArray *apps = (NSMutableArray*)[body objectForKey:@"apps"];
    self.appDomainToIndex = [[NSMutableDictionary alloc] init];
    self.appstore = apps;
    img_count = [apps count];
    NSString *iPadOriPhone;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        iPadOriPhone = @"ipad";
    } else {
        iPadOriPhone = @"iphone";
    }
    NSString *imgUrlKey = [NSString stringWithFormat:@"%@_icon", iPadOriPhone];
    int index = 0;
    for (NSMutableDictionary *app in apps) {
        NSString *url = (NSString*)[app objectForKey:imgUrlKey];
        DisplayImage *dsp_image = [[DisplayImage alloc] initWithURL:url andDomain:(NSString*)[app objectForKey:@"domain"] andIndex:index andDelegate:self];
        [app setObject:dsp_image forKey:@"image_object"];
        [self.appDomainToIndex setObject:app forKey:[app objectForKey:@"domain"]];
    }
}
-(void)initTouchForAppDomain:(NSString*)domain {
    //User touches an image, load that domain
    AppWebView *webview = [[AppWebView alloc] init];
    NSURL *req_url = [NSURL URLWithString:domain];
   // NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:req_url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [webview loadRequest:[NSURLRequest requestWithURL:req_url]];
    [webview setFrame:CGRectMake(0, 0, 768.0, 1024.0)];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 48.0, 24.0)];
    [btn setTintColor:[UIColor grayColor]];
    [btn setTitle:@"Close" forState:UIControlStateNormal];
    [btn setShowsTouchWhenHighlighted:YES];
    [btn addTarget:self action:@selector(closeWebView) forControlEvents:UIControlEventTouchUpInside];
    DisplayImage *dsp_image = (DisplayImage*)[[self.appDomainToIndex objectForKey:domain] objectForKey:@"image_object"];
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    CGPoint newOrigin = CGPointMake(dsp_image.frame.origin.x, dsp_image.frame.origin.y + 88.0);
    [dsp_image removeFromSuperview];
    oldFrame = dsp_image.frame;
    
    //insert dsp image into top level view
    [dsp_image setFrame:CGRectMake(newOrigin.x, newOrigin.y, dsp_image.frame.size.width, dsp_image.frame.size.height)];
    [self.view insertSubview:dsp_image atIndex:12];
    self.currentIcon = dsp_image;
    self.webview = webview;
    [UIView animateWithDuration:0.50f   
                          delay:0.0 options:UIViewAnimationCurveEaseOut
                     animations:^{
                         [dsp_image setFrame:CGRectMake(0.0, 0.0, 768.0, 1024.0)];
                         
                     }
                     completion:^(BOOL finished) {
                         [self.webview showWebView];
                     }
     ];
    self.closeBtn = btn;
}
- (void) displayCurrentWebView {
    [self.currentIcon removeFromSuperview];
    [self.currentIcon setFrame:oldFrame];
    [self.scrollView addSubview:self.currentIcon];
    [self.view insertSubview:self.webview atIndex:10];
    [self.view insertSubview:self.closeBtn atIndex:11];
    [self.currentIcon setFrame:oldFrame];
    self.currentIcon = nil;
}

- (void) incrementImgLoadCount {
    loaded_imgs_count += 1;
    if(loaded_imgs_count == img_count) {
        [self displayImageSubViews];
    }
}

- (void) closeWebView {
    [self.webview removeFromSuperview];
    [self.closeBtn removeFromSuperview];
}

- (void)displayImageSubViews
{
    for (NSMutableDictionary *app in self.appstore) {
        DisplayImage *dsp_image = (DisplayImage*)[app objectForKey:@"image_object"];
        [self.scrollView addSubview:dsp_image];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
