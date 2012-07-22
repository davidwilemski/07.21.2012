//
//  ViewController.h
//  Games4u
//
//  Created by Alexander Haefner on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "DisplayImage.h"
#import "AppWebView.h"

@interface ViewController : BaseViewController 
{
    int img_count;
    int loaded_imgs_count;
    CGRect oldFrame;
}

@property (nonatomic, strong) NSArray* appstore;
@property (nonatomic, strong) NSMutableDictionary *appDomainToIndex;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) AppWebView *webview;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) DisplayImage *currentIcon;

-(void)initTouchForAppDomain:(NSString*)domain;
-(void)incrementImgLoadCount;
-(void)displayImageSubViews;
-(void)displayCurrentWebView;
@end
