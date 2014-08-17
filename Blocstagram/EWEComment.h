//
//  EWEComment.h
//  Blocstagram
//
//  Created by Kervins Valcourt on 8/17/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EWEUser;
@interface EWEComment : NSObject

@property (nonatomic, strong) NSString *idNumber;

@property (nonatomic, strong) EWEUser *from;
@property (nonatomic, strong) NSString *text;


@end
