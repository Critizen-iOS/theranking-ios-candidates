//
//  HTTP.m
//
//  Created by Moisés Moreno.
//

#import "HTTP.h"

@implementation HTTP

/*
 * Get content from a URL.
 *
 * \param urlString URL string.
 * \param completion Completion block. If ok 'data' contains the response, else 'data' is nil.
 */
+ (void)getURL:(NSString *)urlString completion:(void (^)( NSData *data ))completion
{
    NSURL *url = [NSURL URLWithString:urlString];

    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];

    // check cache
    NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    if( cachedResponse ) {
        if( completion ) completion( cachedResponse.data );

    } else {
        // not cached, send request
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

            if( [response isMemberOfClass:[NSHTTPURLResponse class]] ) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                if( httpResponse.statusCode != 200 ) {
                    if( completion ) completion( nil );
                    return;
                }
            }

            completion( data );
        }];
    }
}

@end
