#import "TRLogic.h"

#import "ELHASO.h"
#import "TRPhotoData.h"
#import "TRSecrets.h"


#define kPageSize 20

#if 1
#define kBaseHost @"https://api.500px.com"
#else
#define kBaseHost @"http://localhost:8080"
#endif

// See http://stackoverflow.com/a/5459929/172690
#define STR_HELPER(x) #x
#define STR(x) STR_HELPER(x)


#define kURLThumbnailsMask (kBaseHost \
    @"/v1/photos?feature=popular&sort=rating&image_size=2&consumer_key=" \
    kConsumerKey @"&rpp=" STR(kPageSize) @"&page=%ld")


@interface TRLogic ()

/// List of photos retrieved so far. Might be empty.
@property (nonatomic, strong) NSArray* photos;
/// Pending network task to fetch more pages, should we need to cancel it.
@property (nonatomic, weak) NSURLSessionDataTask* pageRequest;

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
 * query on success. If any error happens an NSError is relayed. The
 * `startPage` boolean indicates if the query is meant to *replace* the current
 * set of photos or simply add more pages. Pass YES if you want to flush
 * everything, NO if you want to append more pages of photos to the current
 * collection.
 *
 * When you are requesting the start page you are meant to do it in a UI
 * blocking fashion, meaning that you should not request again a starting page
 * until the previous one has finished. With the limited scope of the UI this
 * is reasonable.
 *
 * For page requests the class will keep track of any pending paging requests.
 * So the autoload cell can request as many pages as it wants, it will only get
 * one request each time.  Requesting the start page will abort any paging
 * requests too.
 */
+ (void)fetchPhotosWithCallback:(logicCallback)callback
    startPage:(BOOL)startPage
{
    LASSERT(callback, @"No callback?");
    BLOCK_UI();

    // Calculate which page should we get in case it is not the beginning.
    TRLogic *logic = [TRLogic get];
    NSInteger page = 1;
    if (!startPage)
        page = 1 + (logic.photos.count / kPageSize);

    if (startPage) {
        // Cancel any previous paging fetches if we are starting fresh.
        [logic.pageRequest cancel];
    } else {
        // OTOH if there is a going paging request, avoid repeating it.
        NSURLSessionDataTask *task = logic.pageRequest;
        if (task && NSURLSessionTaskStateRunning == task.state) {
            DLOG(@"There is a previous pending page request, aborting");
            return;
        }
    }

    NSURLSession* session = [NSURLSession sharedSession];
    NSURL* url = [NSURL URLWithString:[NSString
        stringWithFormat:kURLThumbnailsMask, (long)page]];
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
                    if (1 == page) {
                        // Replace existing stuff.
                        logic.photos = photos;
                    } else {
                        // Only append pictures, presume correct sorting et all.
                        NSMutableArray *temp = [NSMutableArray
                            arrayWithArray:logic.photos];
                        [temp addObjectsFromArray:photos];
                        logic.photos = temp;
                    }
                    callback(nil);
                });
        }];

    // Should we keep track of pending paging requests?
    if (startPage > 1)
        logic.pageRequest = task;

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
