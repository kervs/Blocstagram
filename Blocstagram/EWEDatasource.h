//
//  EWEDatasource.h
//  Blocstagram
//
//  Created by Kervins Valcourt on 8/17/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EWEMedia;

@interface EWEDatasource : NSObject

+(instancetype) sharedInstance;
@property (nonatomic, strong, readonly) NSArray *mediaItems;

- (void) deleteMediaItem:(EWEMedia *)item;

@end
