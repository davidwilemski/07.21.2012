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

@interface ViewController : BaseViewController 
{
    int img_count;
    int loaded_imgs_count;
}

@property (nonatomic, strong) NSArray* appstore;
@property (nonatomic, strong) NSMutableDictionary *appDomainToIndex;

-(void)initTouchForAppDomain:(NSString*)domain;
-(void)incrementImgLoadCount;
-(void)displayImageSubViews;
@end
