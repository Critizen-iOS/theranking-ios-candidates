//
//  RNKPhotosAPI.m
//  RankTest
//
//  Created by Rafael Bartolome on 26/11/14.
//  Copyright (c) 2014 www.rafaelbartolome.es. All rights reserved.
//

#import "RNKConstants.h"
#import "RNKPhotosAPI.h"
@import UIKit;

static NSString *PopularPicturesURL = @"photos?feature=popular&sort=rating&image_size=4&include_store=store_download";


@implementation RNKPhotosAPI {

    NSURLSession *session;
}



- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];

        //The right way to specify the request format in HTTP is not using a file extension,
        //but using an “Accept” header. Instead of using the extension try to use the “Accept” header with the right MIME type.
        [sessionConfig setHTTPAdditionalHeaders: @{@"Accept": @"application/json"}];

        session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                delegate: nil
                                           delegateQueue:nil];
    }
    return self;
}


- (void) getPopularPicturesJSON: (void(^)(NSArray *picturesJSON, NSError *error)) completionBlock {

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    NSString *urlString = [PopularPicturesURL stringByAppendingString: [self getConsumerKeyParameter]];
    urlString = [APIENGINE_BASEURL stringByAppendingString: urlString];

    //DLog(@"URL String: %@", urlString);

    [[session dataTaskWithURL:[NSURL URLWithString: urlString]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {

                if (!error) {

                    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                    if (httpResp.statusCode == 200) {

                        NSError *jsonError;
                        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data
                                                                             options:NSJSONReadingAllowFragments
                                                                               error:&jsonError];
                        if ( (NSNull*)responseJSON == [NSNull null]) {
                            responseJSON = nil;
                        }

                        if (!jsonError) {

                            NSArray *picturesJSON = [responseJSON valueForKeyPath:@"photos"];
                            if ( (NSNull*)picturesJSON == [NSNull null]) {
                                picturesJSON = nil;
                            }

                            dispatch_async(dispatch_get_main_queue(), ^{
                                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                            });

                            completionBlock (picturesJSON,nil);

                        } else {
                            error = jsonError;
                        }

                    } else {
                        //TODO: use localized strings
                        NSDictionary *userInfo = @{
                                                   NSLocalizedDescriptionKey: @"HTTP error",
                                                   NSLocalizedFailureReasonErrorKey: @"Imposible to connect",
                                                   NSLocalizedRecoverySuggestionErrorKey: @"Review network connection",
                                                   };

                        error = [[NSError alloc] initWithDomain: @"network" code: httpResp.statusCode userInfo: userInfo];
                    }

                }


                if (error) {

                    dispatch_async(dispatch_get_main_queue(), ^{

                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                       
                    });

                    //TODO: find a better way to handle error
                    ELog(@"Connection failed:%@",[error localizedDescription]);
                    
                    completionBlock(nil, error);
                }
                
            }] resume];
    

}



- (NSString*) getConsumerKeyParameter {

    return [@"&consumer_key=" stringByAppendingString: API_CONSUMER_KEY];
}

@end
