//
//  TR500Px.m
//  TRCodeTest
//
//  Created by Oscar on 18/10/14.
//  Copyright (c) 2014 Skyweb Production. All rights reserved.
//

#import "TR500Px.h"
#import "TR500PxPhoto.h"
#import "TR500Px+Constants.h"
#import "TRNetworkManager.h"

@interface TR500Px ()

@property (strong, nonatomic) NSString *baseURL;

@end

@implementation TR500Px

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static TR500Px *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TR500Px alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        _baseURL = REMOTE_500PX_ENDPOINT;
    }
    return self;
}

- (void)getPhotosWithInformation:(TR500PxInfo *)information completionBlock:(getPhotosResponse)completion {
    NSString *endpoint = [NSString stringWithFormat:@"%@%@%@&%@=%@", _baseURL, REMOTE_METHOD_PHOTOS, information.params, REMOTE_PARAM_CONSUMER_KEY, DEVELOPER_CONSUMER_KEY];
    NSURL *url = [NSURL URLWithString:endpoint];
 
    [[TRNetworkManager sharedInstance] GET:url completionBlock:^(NSData *responseData, NSString *response, NSError *error) {
       
        if (!error) {
            NSError *parseError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&parseError];
            
            if (!parseError) {
                NSArray *photos = [TR500PxPhoto initWithResponse:json];
                completion(photos, error);
            }
        } else {
            completion(nil, error);
        }
    }];
}

@end
