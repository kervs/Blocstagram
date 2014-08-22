//
//  EWEMediaFullScreenAnimator.h
//  Blocstagram
//
//  Created by Kervins Valcourt on 8/21/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EWEMediaFullScreenAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL presenting;
@property (nonatomic, weak) UIImageView *cellImageView;

@end
