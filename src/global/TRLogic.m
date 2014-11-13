#import "TRLogic.h"

#import "ELHASO.h"
#import "TRSecrets.h"


#if 0
#define kBaseHost @"https://api.500px.com"
#else
#define kBaseHost @"http://localhost:8080"
#endif


#define kURLThumbnails (kBaseHost @"/v1/photos?feature=popular&sort=rating&image_size=2&consumer_key=" kConsumerKey)


@interface TRLogic ()

/// List of thumbnails retrieved so far. Might be empty.
@property (nonatomic, strong) NSArray* thumbs;

@end


@implementation TRLogic

/** Shared global getter.
 *
 * Takes care of initializing the class once if needed.
 */
+ (TRLogic*)get
{
    static dispatch_once_t onceToken;
    static TRLogic* logic;

    dispatch_once(&onceToken, ^{
            logic = [TRLogic new];
            logic.thumbs = [NSArray array];
        });

    return logic;
}

/** Starts to request the data for the thumbnails of the app.
 *
 * The returned data will be cached in the global variables which you need to
 * query on success. If any error happens an NSError is relayed.
 *
 * This method doesn't take into account concurrency nor reentrancy, the UI is
 * meant to block while waiting for an answer. This method deals with the
 * parsing of thumbnail objects and doesn't do paging at all.
 */
+ (void)fetchThumbnailsWithCallback:(logicCallback)callback
{
    LASSERT(callback, @"No callback?");
    BLOCK_UI();

    NSURLSession* session = [NSURLSession sharedSession];
    NSURL* url = [NSURL URLWithString:kURLThumbnails];
    DLOG(@"Fetching %@", url);

    NSURLSessionDataTask* task = [session dataTaskWithURL:url
        completionHandler:^(NSData* data, NSURLResponse* response,
            NSError* error){

            DONT_BLOCK_UI();
            // Did something fail with the network?
            if (error) {
                dispatch_async_ui(^{ callback(error); });
                return;
            }

            id json = [NSJSONSerialization JSONObjectWithData:data
                options:0 error:&error];
            // Did json parsing fail for some reason?
            if (error) {
                DLOG(@"Failed to serialize JSON of '%@'", [[NSString alloc]
                    initWithData:data encoding:NSUTF8StringEncoding]);
                dispatch_async_ui(^{ callback(error); });
                return;
            }

            NSDictionary* dict = CAST(json, NSDictionary);
            // Did we get no dictionary or the JSON object was not an array?
            if (!dict) {
                dispatch_async_ui(^{
                    callback([NSError errorWithDomain:kErrorLogic
                        code:0 userInfo:nil]);
                });
                return;
            }

            DLOG(@"Got %@ raw objects", dict);
            DLOG(@"Maybe I should use the callback here…");
        }];
    [task resume];
}

@end
