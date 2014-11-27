//
//  Ranking500px.m
//  TheRanking
//
//  Created by Luis Sanchez Garcia on 27/11/14.
//  Copyright (c) 2014 Luis Sánchez García. All rights reserved.
//

#import "Ranking500pxAPI.h"
#import "Picture+Dict500px.h"
#define ASSERT_CONFIGURATION(x)     NSAssert([x.consumerKey length] > 0 && [x.apiEndpoint length] > 0, @"ConsumerKey and ApiEndpoint values needed")

static NSInteger const kNumberOfPhotosPerRequest = 50;

@interface Ranking500pxAPI()

@property (nonatomic, copy) NSString *consumerKey;
@property (nonatomic, copy) NSString *apiEndpoint;

@end

@implementation Ranking500pxAPI


- (instancetype) init {
    self = [super init];
    if (self) {
        NSDictionary *config = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"500pxConfig" ofType:@"plist"]];
        self.consumerKey = config[@"consumerKey"];
        self.apiEndpoint = config[@"apiEndpoint"];
        
        ASSERT_CONFIGURATION(self);
        NSLog(@"[Consumer key - Endpoint] = [%@ - %@]", self.consumerKey, self.apiEndpoint);
    }
    return self;
}

- (NSURL *) popularPicturesURL {
    return  [NSURL URLWithString:[NSString stringWithFormat:@"%@photos?feature=popular&rpp=%ld&consumer_key=%@", self.apiEndpoint, (long)kNumberOfPhotosPerRequest, self.consumerKey]];
}

- (void) processPopularPicturesResponse: (NSData *)response onError:(void(^)(RankingAPIErrorCode errorCode, NSError *error))errorBlock {
    NSError *jsonError = nil;
    NSDictionary *responseDictionary =
    [NSJSONSerialization JSONObjectWithData:response
                                    options:NSJSONReadingAllowFragments
                                      error:&jsonError];
    
    if (!jsonError) {
        NSArray *pictures = responseDictionary[@"photos"];
        [self importDictArray:pictures usingConversionBlock:^(Picture *picture, NSDictionary *pictureDict) {
            
            [picture importFrom500pxDictionary:pictureDict];
            
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            errorBlock(RankingAPIErrorCodeBadResponse, nil);
        });
    }

}

@end
