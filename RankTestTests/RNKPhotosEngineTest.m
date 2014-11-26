//
//  RNKPhotosEngineTest.m
//  RankTest
//
//  Created by Rafael Bartolome on 26/11/14.
//  Copyright (c) 2014 www.rafaelbartolome.es. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "RNKPhotosEngine.h"
#import "TGRAsyncTestHelper.h"

@interface RNKPhotosEngineTest : XCTestCase {
    RNKPhotosEngine *photosEngine;
}

@end

@implementation RNKPhotosEngineTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    photosEngine = [[RNKPhotosEngine alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCanGetPicturesIntoDB {

    NSNumber * __block result;

    [photosEngine getPopularPicturesOnCompletion:^(BOOL resultBlock, NSError *error) {
        if (!error && resultBlock) {
            result = @1;
        }
    }];

     TGRAssertEventually( result != nil, @"should complete with a response");

    if ([result  isEqual: @1]) {
        XCTAssertTrue(true, "Must create objects in DB");
    }
    
}

@end
