#import "TRGridVC.h"

#import "ELHASO.h"
#import "TRGridCell.h"
#import "TRLogic.h"
#import "TRPhotoData.h"


#define kTRGridCell @"TRGridCell"


@interface TRGridVC ()

@property (nonatomic, strong) IBOutlet UICollectionView* collectionView;
/// Just a copy of the latest global fetch.
@property (nonatomic, strong) NSArray* items;

@end


@implementation TRGridVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView
        registerNib:[UINib nibWithNibName:kTRGridCell bundle:nil]
        forCellWithReuseIdentifier:kTRGridCell];

    self.items = [TRLogic getPhotos];
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

        [TRLogic fetchPhotosWithCallback:^(NSError* error){
                BLOCK_UI();
                if (error) {
                    DLOG(@"Error fetching photos: %@", error);
                } else {
                    self.items = [TRLogic getPhotos];
                    DLOG(@"Got %u items", self.items.count);
                    [self.collectionView reloadData];
                }
            }];
    }
}

#pragma mark -
#pragma mark UICollectionViewDataSource protocol

- (NSInteger)collectionView:(UICollectionView*)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView
    cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    TRPhotoData* photoData = self.items[indexPath.row];
    TRGridCell* cell = [self.collectionView
        dequeueReusableCellWithReuseIdentifier:kTRGridCell
        forIndexPath:indexPath];

    [cell configure:photoData];
    return cell;
}

#pragma mark -
#pragma mark UICollectionViewDelegate protocol

- (void)collectionView:(UICollectionView*)collectionView
    didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    TRPhotoData* photoData = self.items[indexPath.row];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    DLOG(@"Should do something with %@, like maybe show it", photoData);
}

@end
