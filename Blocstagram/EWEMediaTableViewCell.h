//
//  EWEMediaTableViewCell.h
//  Blocstagram
//
//  Created by Kervins Valcourt on 8/17/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EWEMedia;
@interface EWEMediaTableViewCell : UITableViewCell
@property(nonatomic,strong) EWEMedia *mediaItem;
+ (CGFloat) heightForMediaItem:(EWEMedia *)mediaItem width:(CGFloat)width;

@end
