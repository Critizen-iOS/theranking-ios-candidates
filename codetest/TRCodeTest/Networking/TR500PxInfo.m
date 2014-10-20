//
//  TR500PxInfo.m
//  TRCodeTest
//
//  Created by Oscar on 18/10/14.
//  Copyright (c) 2014 Skyweb Production. All rights reserved.
//

#import "TR500PxInfo.h"
#import "TR500PxInfo+Extras.h"

@implementation TR500PxInfo

static NSInteger DEFAULT_PAGE = 1;
static NSInteger DEFAULR_PHOTOS_PER_PAGE = 20;

- (instancetype)initWithFeature:(TR500PxFeature)feature sort:(TR500PxSort)sort page:(NSNumber *)page photosPerPage:(NSNumber *)photosPerPage {
    NSAssert(page.integerValue >= 1, @"Page should be >=1");
    NSAssert((photosPerPage.integerValue >=1 && photosPerPage.integerValue <= 100), @"Can not be over 100");

    if (self = [super init]) {
        _page = page;
        _photosPerPage = photosPerPage;
        _params = [NSString stringWithFormat:@"?feature=%@&sort=%@&page=%@&rpp=%@", [self stringFromFeature:feature], [self stringFromSort:sort], _page, _photosPerPage];
    }
    return self;
}

- (instancetype)initWithFeature:(TR500PxFeature)feature sort:(TR500PxSort)sort page:(NSNumber *)page {
    return [self initWithFeature:feature sort:sort page:page photosPerPage:[NSNumber numberWithInteger:DEFAULR_PHOTOS_PER_PAGE]];
}

- (instancetype)initWithFeature:(TR500PxFeature)feature sort:(TR500PxSort)sort {
    return [self initWithFeature:feature sort:sort page:[NSNumber numberWithInteger:DEFAULT_PAGE] photosPerPage:[NSNumber numberWithInteger:DEFAULR_PHOTOS_PER_PAGE]];
}

@end
 