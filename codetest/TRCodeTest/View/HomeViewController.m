//
//  HomeViewController.m
//  TRCodeTest
//
//  Created by Oscar on 18/10/14.
//  Copyright (c) 2014 Skyweb Production. All rights reserved.
//

#import "HomeViewController.h"
#import "DetailTableViewController.h"
#import "HomeCollectionViewCell.h"
#import "TR500Px.h"

@interface HomeViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *photos;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Clear memory image cache
    [[SDImageCache sharedImageCache] clearMemory];
}

#pragma mark - Initial setup

- (void)setUp {
    // Title
    self.title = NSLocalizedString(@"_APP_NAME", nil);
    
    // Register cell classes
    UINib *collectionViewNib = [UINib nibWithNibName:NSStringFromClass([HomeCollectionViewCell class]) bundle:nil];
    [self.collectionView registerNib:collectionViewNib forCellWithReuseIdentifier:NSStringFromClass([HomeCollectionViewCell class])];
    
    // Get remote images
    [self fetchRemotePhotos];
}

- (void)fetchRemotePhotos {
    TR500PxInfo *information = [[TR500PxInfo alloc] initWithFeature:POPULAR sort:RATING page:@1 photosPerPage:@50];
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"_HOME_LOADING_HUD", nil)
                         maskType:SVProgressHUDMaskTypeGradient];
    
    [[TR500Px sharedInstance] getPhotosWithInformation:information completionBlock:^(NSArray *photos, NSError *error) {
        
        if (!error) {
            _photos = photos;
            
            if (_photos.count) {
                [self.collectionView performBatchUpdates:^{
                    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
                } completion:NULL];
            }
        } else {
            NSLog(@"Error => %@", error);
        }
        
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HomeCollectionViewCell class])
                                                                             forIndexPath:indexPath];
    TR500PxPhoto *photo = _photos[indexPath.row];
    
    [cell drawCellWithPhoto:photo];
 
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait) {
            return CGSizeMake(150, 150);
        } else {
            return CGSizeMake(170, 170);
        }
    }
    return CGSizeMake(160, 160);
}

#pragma mark - <UICollectionViewDelegate> 

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DetailTableViewController *detail = [[DetailTableViewController alloc] initWithNibName:@"DetailTableViewController" bundle:nil];
    TR500PxPhoto *photo = _photos[indexPath.row];
    detail.photo = photo;
    
    [self.navigationController pushViewController:detail animated:YES];
}

@end
