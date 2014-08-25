//
//  EWEMediaTableViewCell.h
//  Blocstagram
//
//  Created by Kervins Valcourt on 8/17/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EWEMedia, EWEMediaTableViewCell;
@protocol EWEMediaTableViewCellDelegate <NSObject>

- (void) cell:(EWEMediaTableViewCell *)cell didTapImageView:(UIImageView *)imageView;
- (void) cell:(EWEMediaTableViewCell *)cell didLongPressImageView:(UIImageView *)imageView;
- (void) cell:(EWEMediaTableViewCell *)cell didDoubleTapImageView:(UIImageView *)imageView;
- (void) cellDidPressLikeButton:(EWEMediaTableViewCell *)cell;

@end
@interface EWEMediaTableViewCell : UITableViewCell
@property(nonatomic,strong) EWEMedia *mediaItem;
@property (nonatomic, weak) id <EWEMediaTableViewCellDelegate> delegate;

+ (CGFloat) heightForMediaItem:(EWEMedia *)mediaItem width:(CGFloat)width;

@end
