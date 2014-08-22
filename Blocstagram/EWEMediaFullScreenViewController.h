//
//  EWEMediaFullScreenViewController.h
//  Blocstagram
//
//  Created by Kervins Valcourt on 8/21/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EWEMedia;

@interface EWEMediaFullScreenViewController : UIViewController
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *shareButton;

- (instancetype) initWithMedia:(EWEMedia *)media;

-(void)shareButtonPressed:(id) target withAction:(SEL)Action;

- (void) centerScrollView;
@end
