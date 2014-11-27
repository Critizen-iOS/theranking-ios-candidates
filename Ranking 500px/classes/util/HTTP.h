//
//  HTTP.h
//
//  Created by Moisés Moreno.
//

#import <UIKit/UIKit.h>

//! Simple HTTP helper.
@interface HTTP: NSObject

/*!
 * Get content from a URL.
 *
 * \param urlString URL string.
 * \param completion Completion block. If ok 'data' contains the response, else 'data' is nil.
 */
+ (void)getURL:(NSString *)urlString completion:(void (^)( NSData *data ))completion;

@end
