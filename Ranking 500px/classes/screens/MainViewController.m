//
//  MainViewController.m
//  Ranking 500px
//
//  Created by Moisés Moreno on 25/11/14.
//  Copyright (c) 2014 sés. All rights reserved.
//

#import "MainViewController.h"

#import "GridCellView.h"
#import "PhotoCache.h"
#import "PXAPI.h"
#import "PXPhoto.h"
#import "DetailView.h"

static NSString *const GridCellId = @"GridCellId";


#pragma mark - = MainViewController () = -

@interface MainViewController () {
    DetailView *detailView;
    PhotoCache *photoCache;
}

#pragma mark - Outlets -

@property (nonatomic, strong) IBOutlet UICollectionView *gridView;

#pragma mark -

- (void)updateGrid;

@end


#pragma mark - = MainViewController = -

@implementation MainViewController

#pragma mark - View lifecycle -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    detailView = [DetailView detailView];
    detailView.frame = self.view.bounds;
    [detailView layoutIfNeeded];
    
    // register cell
    UINib *cellNib = [UINib nibWithNibName:@"GridCellView" bundle:nil];
    [_gridView registerNib:cellNib forCellWithReuseIdentifier:GridCellId];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGrid) name:PhotoCacheItemsLoadedMessage object:photoCache];
    photoCache = [[PhotoCache alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate -

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];

    [UIView animateWithDuration:0.2f
        delay:0
        options:UIViewAnimationOptionAllowUserInteraction
        animations:^{
            cell.alpha = 0.8f;
        }
        completion:nil
    ];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];

    [UIView animateWithDuration:0.2f
        delay:0
        options:UIViewAnimationOptionAllowUserInteraction
        animations:^{
            cell.alpha = 1.0f;
        }
        completion:nil
    ];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GridCellView *cell = (GridCellView *)[collectionView cellForItemAtIndexPath:indexPath];

    PXPhoto *pxPhoto = [photoCache photoForIndex:indexPath.row];

    [detailView setPhoto:pxPhoto preview:[cell image]];
    [detailView openInView:self.view fromView:cell];
}


#pragma mark - UICollectionViewDataSource -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return photoCache.totalItems;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GridCellView *cell = (GridCellView *)[collectionView dequeueReusableCellWithReuseIdentifier:GridCellId forIndexPath:indexPath];
    
    PXPhoto *pxPhoto = [photoCache photoForIndex:indexPath.row];

    [cell setPhoto:pxPhoto];

    return cell;
}

// optional

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

#pragma mark - MainViewController () -

- (void)updateGrid
{
    [_gridView reloadData];
}


@end
