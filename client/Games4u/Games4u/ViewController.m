//
//  ViewController.m
//  Games4u
//
//  Created by Alexander Haefner on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize appstore = _appstore;
@synthesize appDomainToIndex = _appDomainToIndex;

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
    for (NSMutableDictionary *app in apps) {
        DisplayImage *dsp_image = [[DisplayImage alloc] initWithURL:[app objectForKey:@"img_url"] andDomain:(NSString*)[app objectForKey:@"domain"] andDelegate:self];
        [app setObject:dsp_image forKey:@"image_object"];
        [self.appDomainToIndex setObject:app forKey:[app objectForKey:@"domain"]];
    }
}
-(void)initTouchForAppDomain:(NSString*)domain {
    //User touches an image, load that domain
    UIWebView *webview = [[UIWebView alloc] init];
    NSURL *req_url = [NSURL URLWithString:[[self.appDomainToIndex objectForKey:@"domain"] objectForKey:@"url"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:req_url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [webview loadRequest:[NSURLRequest requestWithURL:req_url]];
    [self.view addSubview:webview];
}
- (void) incrementImgLoadCount {
    loaded_imgs_count += 1;
    if(loaded_imgs_count == img_count) {
        [self displayImageSubViews];
    }
}

- (void)displayImageSubViews
{
    for (NSMutableDictionary *app in self.appstore) {
        DisplayImage *dsp_image = (DisplayImage*)[app objectForKey:@"image_object"];
        [self.view addSubview:dsp_image];
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
