//
//  EWEComposeCommentViewTest.m
//  Blocstagram
//
//  Created by Kervins Valcourt on 9/1/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EWEComposeCommentView.h"

@interface EWEComposeCommentViewTest : XCTestCase

@end

@implementation EWEComposeCommentViewTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testThatInitializationWorks
{
    
    EWEComposeCommentView *composeComment = [[EWEComposeCommentView alloc]init];
    XCTAssertTrue(composeComment.isWritingComment == YES, @"The bool should be equal");
    XCTAssertTrue(composeComment.isWritingComment == NO, @"The bool should be equal");
}

@end
