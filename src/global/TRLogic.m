#import "TRLogic.h"

#import "ELHASO.h"
#import "TRPhotoData.h"
#import "TRSecrets.h"


#if 0
#define kBaseHost @"https://api.500px.com"
#else
#define kBaseHost @"http://localhost:8080"
#endif


#define kURLThumbnails (kBaseHost @"/v1/photos?feature=popular&sort=rating&image_size=2&consumer_key=" kConsumerKey)


@interface TRLogic ()

/// List of photos retrieved so far. Might be empty.
@property (nonatomic, strong) NSArray* photos;

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
            logic.photos = [NSArray array];
        });

    return logic;
}

/** Starts to request the data for the photos of the app.
 *
 * The returned data will be cached in the global variables which you need to
 * query on success. If any error happens an NSError is relayed.
 *
 * This method doesn't take into account concurrency nor reentrancy, the UI is
 * meant to block while waiting for an answer. This method deals with the
 * parsing of photos objects and doesn't do paging at all.
 */
+ (void)fetchPhotosWithCallback:(logicCallback)callback
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
            if (!dict) {
                DLOG(@"We didn't get a proper dictionary from %@", json);
                dispatch_async_ui(^{
                    callback([NSError errorWithDomain:kErrorLogic
                        code:0 userInfo:nil]);
                });
                return;
            }

            NSArray* rawPhotos = CAST(dict[@"photos"], NSArray);
            if (rawPhotos.count < 1) {
                DLOG(@"We didn't get a proper photo array from %@", dict);
                dispatch_async_ui(^{
                    callback([NSError errorWithDomain:kErrorLogic
                        code:0 userInfo:nil]);
                });
                return;
            }

            NSMutableArray* photos = [NSMutableArray
                arrayWithCapacity:rawPhotos.count];
            // Transform as many JSON objects as we can ignoring errors.
            for (id rawPhoto in rawPhotos) {
                TRPhotoData* photoData = [TRPhotoData fromDict:rawPhoto];
                if (photoData) {
                    [photos addObject:photoData];
                } else {
                    DLOG(@"Error parsing photo, ignoring %@", rawPhoto);
                }
            }

            if (photos.count != rawPhotos.count)
                DLOG(@"Hugh, there were some conversion errors. Oh well…");

            // Were we not able to transform any objects?
            if (photos.count < 1) {
                DLOG(@"Could not transform any objects at all!");
                dispatch_async_ui(^{
                    callback([NSError errorWithDomain:kErrorLogic
                        code:0 userInfo:nil]);
                });
                return;
            }

            dispatch_async_ui(^{
                    [TRLogic get].photos = photos;
                    callback(nil);
                });
        }];
    [task resume];
}

/** Returns the current list of downloaded TRPhotoData objects.
 *
 * If this is empty maybe you should call fetchPhotosWithCallback.
 */
+ (NSArray*)getPhotos
{
    return [TRLogic get].photos;
}

@end
