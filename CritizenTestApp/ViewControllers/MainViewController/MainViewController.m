//
//  MainViewController.m
//  CritizenTestApp
//
//  Created by Patricio on 17/02/15.
//  Copyright (c) 2015 Patricio. All rights reserved.
//

#import "MainViewController.h"
#import "DetailViewController.h"
#import "PhotoCell.h"
#import "LoadingCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


static NSString *const PhotoCellIdentifier = @"PhotoCell";
static NSString *const LoadingCellIdentifier = @"LoadingCell";

@implementation MainViewController {
    int currentPage;
    BOOL isLastPage;
    NSInteger maxRows;
    NSInteger maxColumns;
}

@synthesize collectionView;
@synthesize photosArray;

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Popular Photos";
    collectionView.backgroundColor = [UIColor colorWithWhite:0.25f alpha:1.0f];
    
    UINib *photoCellNib = [UINib nibWithNibName:PhotoCellIdentifier bundle:nil];
    [collectionView registerNib:photoCellNib forCellWithReuseIdentifier:PhotoCellIdentifier];
    
    UINib *loadingCellNib = [UINib nibWithNibName:LoadingCellIdentifier bundle:nil];
    [collectionView registerNib:loadingCellNib forCellWithReuseIdentifier:LoadingCellIdentifier];
    
    photosArray = [NSMutableArray array];
    isLastPage = NO;
    currentPage = 1;
    [self requestPhotosForCurrentPage];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    maxColumns = [self columnsDisplaidInCollectionView];
    maxRows = [self rowsDisplaidInCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Instance Methods

-(void)requestPhotosForCurrentPage
{
    [[PXFetchManager sharedManager] requestPhotos:@"popular"
                                             page:[NSNumber numberWithInt:currentPage]
                                             sort:@"rating"
                                    sortDirection:@"desc"
                                        imageSize:[NSNumber numberWithInt:3]
                                         callback:^(NSDictionary *dictionary, NSError *error) {
                                             if (!error) {
                                                 [photosArray addObjectsFromArray:[dictionary objectForKey:@"photos"]];
                                                 
                                                 NSNumber *totalPages = [dictionary objectForKey:@"total_pages"];
                                                 if (currentPage == totalPages.intValue) {
                                                     isLastPage = YES;
                                                 }
                                                 
                                                 [collectionView reloadData];
                                             } else {
                                                 NSLog(@"Error requesting photos");
                                             }
                                         }];
}

- (NSInteger)columnsDisplaidInCollectionView
{
    CGFloat w = collectionView.frame.size.width;
    UIEdgeInsets sectionInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    CGFloat minInterItem = 10.0f;
    CGSize itemSize = CGSizeMake(140.0f, 140.0f);
    
    // Maximiza numero de columnas par el espacio inter item minimo
    CGFloat num1 = w + sectionInset.right + sectionInset.left + minInterItem;
    CGFloat div1 = itemSize.width + minInterItem;
    CGFloat maxCol = floorf(num1 / div1);
    
    // Espacion inter items minimo para las columnas maximas
    CGFloat num2 = w + sectionInset.right + sectionInset.left - (maxCol * itemSize.width);
    CGFloat div2 = maxCol - 1;
    CGFloat interItem = num2 / div2;
    
    if (interItem < minInterItem) {
        return floorf(maxCol) - 1;
    } else {
        return floorf(maxCol);
    }
}

- (NSInteger)rowsDisplaidInCollectionView
{
    CGFloat h = collectionView.frame.size.height;
    UIEdgeInsets sectionInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    CGFloat minInterItem = 10.0f;
    CGSize itemSize = CGSizeMake(140.0f, 140.0f);
    
    CGFloat numerador = h - 2 * (sectionInset.top + sectionInset.bottom) + minInterItem;
    CGFloat divisor = itemSize.height + minInterItem;
    
    NSInteger columns = ceilf(numerador / divisor);
    return columns;
}

#pragma mark - PhotoCell and LoadingCell Methods

- (PhotoCell *)photoCellForIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoCellIdentifier forIndexPath:indexPath];
    NSDictionary *photoDictionary = [photosArray objectAtIndex:indexPath.row];
    
    NSURL *photoUrl = [NSURL URLWithString:[photoDictionary valueForKey:@"image_url"]];
    [cell.thumbImage sd_setImageWithURL:photoUrl];
    
    NSNumber *score = [photoDictionary valueForKey:@"rating"];
    NSString *scoreString = [NSString stringWithFormat:@"%.1f", score.floatValue];
    cell.scoreLabel.text = scoreString;
    
    NSString *name = [photoDictionary valueForKey:@"name"];
    cell.nameLabel.text = name;
    
    return cell;
}

- (LoadingCell *)loadingCellForIndexPath:(NSIndexPath *)indexPath
{
    LoadingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LoadingCellIdentifier forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UICollectionViewDataSource Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (!isLastPage && photosArray.count > 0) {
        return MAX(photosArray.count, (maxColumns * maxRows)) + maxColumns;
    } else {
        return photosArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < photosArray.count) {
        return [self photoCellForIndexPath:indexPath];
    } else {
        currentPage++;
        [self requestPhotosForCurrentPage];
        
        return [self loadingCellForIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *photoId = [[photosArray objectAtIndex:indexPath.row] valueForKey:@"id"];
    
    DetailViewController *dvc = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    dvc.photoId = photoId;
    [self.navigationController pushViewController:dvc animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[LoadingCell class]]) {
        LoadingCell *loadingCell = (LoadingCell *)cell;
        [loadingCell.activityIndicator startAnimating];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[LoadingCell class]]) {
        LoadingCell *loadingCell = (LoadingCell *)cell;
        [loadingCell.activityIndicator stopAnimating];
    }
}


@end
