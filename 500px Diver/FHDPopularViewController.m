//
//  FHDPopularViewControllerCollectionViewController.m
//  500px Diver
//
//  Created by Jaime on 25/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>

#import "FHDPopularViewController.h"
#import "FHDPopularViewCell.h"
#import "FHDPopularItem.h"

@interface FHDPopularViewController ()

// List of popular items in Collection View
@property (nonatomic, strong) NSMutableArray *popularItems;

@end

@implementation FHDPopularViewController

static NSString * const reuseIdentifier = @"PopularCell";

- (void)viewDidLoad {
    [super viewDidLoad];

    _popularItems = [[NSMutableArray alloc] init];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"FHDPopularViewCell" bundle:[NSBundle mainBundle]]
          forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSInteger sections = (_popularItems.count == 0) ? 0 : 1;
    return sections;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _popularItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FHDPopularViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    FHDPopularItem *popularItem = [_popularItems objectAtIndex:indexPath.row];
    
    cell.ratingLbl.text = [NSString stringWithFormat:@"%.2f", [popularItem.rating doubleValue]];
    cell.nameLbl.text = popularItem.name;
    cell.activityView.hidden = NO;
    [cell.activityView startAnimating];
    __weak FHDPopularViewCell *myCell = cell;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:popularItem.imageUrl]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 [myCell.activityView stopAnimating];
                                 myCell.activityView.hidden = YES;
                             }];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout protocol methods

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(8, 8, 8, 8);  // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0;
}

#pragma mark - FHDPopularViewInterface protocol methods

- (void)showPopularItems:(NSArray *)items
{
    // First time, load data
    if (_popularItems.count == 0) {
        [_popularItems addObjectsFromArray:items];
        [self.collectionView reloadData];
        
    // More data is ready, add it to the end of collection view
    } else {
        __block NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
             NSIndexPath *indexPath = [NSIndexPath indexPathForRow:((_popularItems.count-1) + idx) inSection:0];
            [indexPaths addObject:indexPath];
        }];
        [_popularItems addObjectsFromArray:items];
        [self.collectionView insertItemsAtIndexPaths:indexPaths];
    }
}

#pragma mark <UICollectionViewDelegate>

// When user selects an item, sends event to the Presenter
// Detail view controller will be shown
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_viewDelegate popularDidSelectItem:[_popularItems objectAtIndex:indexPath.item]];
}

// User reaches the end of the collection view
// Send event to the Presenter to request more data
- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == (_popularItems.count - 1)) {
        [_viewDelegate popularDidEndScroll];
    }
}

@end
