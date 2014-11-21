//
//  CZHomeViewController.m
//  CritizenTest
//
//  Created by Juan Pedro Catalán on 20/11/14.
//  Copyright (c) 2014 Juanpe Catalán. All rights reserved.
//

#import "CZ500Connector.h"
#import "CZHomeViewController.h"
#import "CZPhotoDetailsViewController.h"
#import "LoadingCollectionViewCell.h"
#import "PhotoViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CZHomeViewController ()
{
    BOOL _loading;
    BOOL _hasMorePhotos;
    NSInteger _currentPage;
    
}
@property (nonatomic, strong) UIActivityIndicatorView * spinLoading;

- (void) _fetchMorePhotos;
- (void) _requestPhotos;

@end

@implementation CZHomeViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];

    _loading        = NO;
    _hasMorePhotos  = NO;
    _currentPage    = 1;
    
     self.photos    = [NSMutableArray array];
    
    self.spinLoading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.spinLoading.hidesWhenStopped = YES;
    self.spinLoading.center = self.view.center;
    
    [self.view insertSubview:self.spinLoading
                aboveSubview:self.collectionView];
    
    UINib *cellNib          = [UINib nibWithNibName:@"PhotoViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"Thumb_Cell"];
    
    UINib *loadingCellNib   = [UINib nibWithNibName:@"LoadingCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:loadingCellNib forCellWithReuseIdentifier:@"LoadingCell"];

    [self.spinLoading startAnimating];
    
    [self _requestPhotos];
}

- (void) viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self setTitle:@"Popular"];
}

- (void) viewWillDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [self setTitle:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

- (void) _fetchMorePhotos{
    
    //NSLog(@"Fetch more photos...");
    
    _currentPage++;
    
    [self _requestPhotos];
}

- (void) _requestPhotos{

    [CZ500Connector requestForPhotoFeature:CZ500PhotoFeaturePopular
                                      page:_currentPage
                                photoSizes:CZ500PhotoModelSizeLarge
                                completion:^(NSArray * thumbs, BOOL morePhotos, NSError * error){
                                    
                                    _loading = NO;
                                    
                                    [self.spinLoading stopAnimating];
                                    
                                    _hasMorePhotos = morePhotos;
                                    
                                    [self.photos addObjectsFromArray:thumbs];
                                    
                                    [self.collectionView reloadData];
                                    
                                    //NSLog(@"Photos (%lu) %@ => %@", (unsigned long)[thumbs count], (morePhotos)?@"...":@"", thumbs);
                                    
                                }];
}

#pragma mark - UICollectionViewDelegate Methods 

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if(_hasMorePhotos){
        return self.photos.count + 1;
    }else{
        return self.photos.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.item < self.photos.count) {
        
        return [self itemCellForIndexPath:indexPath];
        
    } else {
        
        if (!_loading) {
            
            _loading = YES;
            
            [self _fetchMorePhotos];
        }
        
        return [self loadingCellForIndexPath:indexPath];
    }
}

- (UICollectionViewCell *) itemCellForIndexPath:(NSIndexPath *)indexPath {

    PhotoViewCell *cell = (PhotoViewCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"Thumb_Cell"
                                                                                          forIndexPath:indexPath];
    
    CZPhotoThumb * thumbObj = [self.photos objectAtIndex:indexPath.row];
    
    [cell.thumbImageView sd_setImageWithURL:[NSURL URLWithString:thumbObj.url]];
    [cell.photoNameLabel setText:thumbObj.name];
    [cell.ratingLabel setText:[NSString stringWithFormat:@"%.1f",thumbObj.rating.floatValue]];
    
    return cell;
}

- (UICollectionViewCell *) loadingCellForIndexPath:(NSIndexPath *)indexPath {
    
    LoadingCollectionViewCell *cell = (LoadingCollectionViewCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"LoadingCell" forIndexPath:indexPath];
    
    [cell.spinLoading startAnimating];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CZPhotoThumb * thumbObj = [self.photos objectAtIndex:indexPath.row];
    
    CZPhotoDetailsViewController * detailsVC = [[CZPhotoDetailsViewController alloc] initWithPhotoID:thumbObj.id.integerValue];
    
    [self.navigationController pushViewController:detailsVC
                                         animated:YES];
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item < self.photos.count) {
        
        return CGSizeMake(160.0f, 160.0f);
        
    } else {
        
        return CGSizeMake(self.view.frame.size.width, 36.0f);
    }
}

@end
