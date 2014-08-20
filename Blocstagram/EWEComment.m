//
//  EWEComment.m
//  Blocstagram
//
//  Created by Kervins Valcourt on 8/17/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import "EWEComment.h"
#import "EWEUser.h"

@implementation EWEComment

- (instancetype) initWithDictionary:(NSDictionary *)commentDictionary {
    self = [super init];
    
    if (self) {
        self.idNumber = commentDictionary[@"id"];
        self.text = commentDictionary[@"text"];
        self.from = [[EWEUser alloc] initWithDictionary:commentDictionary[@"from"]];
    }
    
    return self;
}


@end
