//
//  DetailSectionItem.m
//  TRCodeTest
//
//  Created by Oscar Antonio Duran Grillo on 20/10/14.
//  Copyright (c) 2014 Skyweb Production. All rights reserved.
//

#import "DetailSectionItem.h"

@implementation DetailSectionItem

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
    return [self initWithTitle:title subtitle:subtitle image:nil];
}

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle image:(NSURL *)imageURL {
    if (self = [super init]) {
        _title = title;
        _subtitle = subtitle;
        _imageURL = imageURL;
        
        if (imageURL) {
            _user = YES;
        }
    }
    return self;
}


@end
