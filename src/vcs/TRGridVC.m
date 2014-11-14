#import "TRGridVC.h"

#import "ELHASO.h"
#import "TRGridPhotoCell.h"
#import "TRLogic.h"
#import "TRPhotoData.h"
#import "TRPhotoDetailVC.h"


#import <QuartzCore/CALayer.h>

#define kTRGridPhotoCell @"TRGridPhotoCell"
#define kTRGridAutoloadCell @"TRGridAutoloadCell"


@interface TRGridVC ()

@property (strong, nonatomic) IBOutlet UICollectionView* collectionView;
/// Just a copy of the latest global fetch.
@property (strong, nonatomic) NSArray* items;
/// Parent which fades in/out with some timeouts.
@property (strong, nonatomic) IBOutlet UIView* errorView;
@property (strong, nonatomic) IBOutlet UILabel* errorLabel;
/// Keeps track of the refresh control so we can reset it on network finish.
@property (strong, nonatomic) UIRefreshControl* refreshControl;

@end


@implementation TRGridVC

#pragma mark -
#pragma mark Life

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Register the cells we want to display.
    [self.collectionView
        registerNib:[UINib nibWithNibName:kTRGridPhotoCell bundle:nil]
        forCellWithReuseIdentifier:kTRGridPhotoCell];
    [self.collectionView
        registerNib:[UINib nibWithNibName:kTRGridAutoloadCell bundle:nil]
        forCellWithReuseIdentifier:kTRGridAutoloadCell];

    // Add UIRefreshControl to our collection.
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(didRequestRefresh:)
        forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];

    self.items = [TRLogic getPhotos];
    self.errorView.layer.cornerRadius = 10;
    self.errorView.hidden = YES;
    self.errorView.alpha = 0;
}

/** Starts an automatic loading of photos the fist time.
 *
 * This is a good place to put the automatic fetch for the app startup, since
 * this is the first view that will be seen and we expect to have always some
 * items.
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.items.count < 1) {
        DLOG(@"No photos? Go get some…");
        [self didRequestRefresh:nil];
    }
}

#pragma mark -
#pragma mark Methods

/** Fades out the error view.
 *
 * The fadeing is done from whatever current state there is and without
 * interrupting animations, so it should be safe to call this always.
 *
 * Reimplementing existing HUD libraries because it's fun… not.
 */
- (void)fadeOutErrorView
{
    BLOCK_UI();
    [UIView animateWithDuration:kFadeInterval delay:0 options:kFadeOptions
        animations:^{ self.errorView.alpha = 0; } completion:nil];
}

/** Callback for the refresh control.
 *
 * Small wrapper over startFetchFromScratch: to pass the parameter and indicate
 * the control to animate the refresh.
 */
- (void)didRequestRefresh:(id)sender
{
    BLOCK_UI();
    [self.refreshControl beginRefreshing];
    [self startFetchFromScratch:YES];
}

/** Starts a network fetch operation for either paging or refreshes.
 *
 * Pass YES as `restart` to force reloading everything, NO if you only want
 * more pages.
 */
- (void)startFetchFromScratch:(BOOL)restart
{
    [TRLogic fetchPhotosWithCallback:^(NSError* error){
            BLOCK_UI();
            [self.refreshControl endRefreshing];

            if (error) {
                DLOG(@"Error fetching photos: %@", error);
                self.errorLabel.text =
                    NON_NIL_STRING(error.localizedDescription);
                self.errorView.hidden = NO;
                // Fade in the error, from whatever state it was.
                [UIView animateWithDuration:kFadeInterval delay:0
                    options:kFadeOptions animations:^{
                        self.errorView.alpha = 1;
                    } completion:^(BOOL finished) {
                        // Discard the error if there are items.
                        if (self.items.count)
                            RUN_AFTER(2, ^{ [self fadeOutErrorView]; });
                    }];
            } else {
                // Discard any previous error message should if reloading.
                [self fadeOutErrorView];
                self.items = [TRLogic getPhotos];
                [self.collectionView reloadData];
            }
        } startPage:restart];
}

#pragma mark -
#pragma mark UICollectionViewDataSource protocol

/** Returns always two sections.
 * The first section will contain the actual data. The second section is used
 * to sperately hold the autoload cell which triggers further network requests.
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

/** Returns the items for the collection.
 * In the case of the second fake section it will returns 1 only if there have
 * previously been loaded other items, to avoid having the more cell in the
 * empty view during the first load.
 */
- (NSInteger)collectionView:(UICollectionView*)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    if (section)
        return (self.items.count ? 1 : 0);
    else
        return self.items.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView
    cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section) {
        // Return the fake autoload cell and perform a network request.
        UICollectionViewCell *cell = [self.collectionView
            dequeueReusableCellWithReuseIdentifier:kTRGridAutoloadCell
            forIndexPath:indexPath];
        [self startFetchFromScratch:NO];
        return cell;
    } else {
        // Return the real cells.
        TRPhotoData* photoData = self.items[indexPath.row];
        TRGridPhotoCell* cell = [self.collectionView
            dequeueReusableCellWithReuseIdentifier:kTRGridPhotoCell
            forIndexPath:indexPath];

        [cell configure:photoData];
        return cell;
    }
}

#pragma mark -
#pragma mark UICollectionViewDelegate protocol

- (void)collectionView:(UICollectionView*)collectionView
    didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (0 != indexPath.section)
        return;

    TRPhotoDetailVC* vc = [TRPhotoDetailVC new];
    vc.photoData = self.items[indexPath.row];
    UINavigationController *navVc = [[UINavigationController alloc]
        initWithRootViewController:vc];
    [self presentViewController:navVc animated:YES completion:nil];
}

@end
