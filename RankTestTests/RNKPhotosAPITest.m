//
//  RNKPhotosAPITest.m
//  RankTest
//
//  Created by Rafael Bartolome on 26/11/14.
//  Copyright (c) 2014 www.rafaelbartolome.es. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "RNKPhotosAPI.h"
#import "TGRAsyncTestHelper.h"

@interface RNKPhotosAPITest : XCTestCase {

    RNKPhotosAPI *photosAPI;
}

@end

@implementation RNKPhotosAPITest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    photosAPI = [[RNKPhotosAPI alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCanGetJSONArrayOfPictures {

    NSNumber * __block result;

    [photosAPI getPopularPicturesJSON:^(NSArray *picturesJSON, NSError *error) {
        if (!error && picturesJSON) {
            result = @1;
        }
    }];

    TGRAssertEventually( result != nil, @"should complete with a response");

    if ([result  isEqual: @1]) {
        XCTAssertTrue(true, "API must return an array");
    }

}



@end
