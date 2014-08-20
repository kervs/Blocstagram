//
//  EWEMedia.h
//  Blocstagram
//
//  Created by Kervins Valcourt on 8/17/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EWEUser;
@interface EWEMedia : NSObject

@property (nonatomic, strong) NSString *idNumber;
@property (nonatomic, strong) EWEUser *user;
@property (nonatomic, strong) NSURL *mediaURL;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSArray *comments;
- (instancetype) initWithDictionary:(NSDictionary *)mediaDictionary;

@end
