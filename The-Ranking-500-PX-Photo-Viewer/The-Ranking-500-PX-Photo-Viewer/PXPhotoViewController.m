//
//  PXPhotoViewController.m
//  The-Ranking-500-PX-Photo-Viewer
//
//  Created by Ernesto Pino on 2/2/15.
//  Copyright (c) 2015 Ernesto Pino. All rights reserved.
//

#import "PXPhotoViewController.h"
#import "PXApiManager.h"
#import "PXDataModel.h"
#import "PXCollectionViewCell.h"
#import "PXPhotoDetailTableViewController.h"

#define kSearchPopularPhotos    @"https://api.500px.com/v1/photos?feature=popular&sort=rating&image_size=3&page=%d&consumer_key=%@"

@interface PXPhotoViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) PXApiManager *apiManager;

@end

@implementation PXPhotoViewController

static NSString * const reuseIdentifier = @"PXCellIdentifier";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Create 500px API Manager
    self.apiManager = [[PXApiManager alloc] init];
    
    // Load the first page of data
    [self loadMoreData:[[PXDataModel sharedInstance] currentPhotoPage]];
    
    // Register cell
    UINib *cellNib = [UINib nibWithNibName:@"PXCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifier];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[[PXDataModel sharedInstance] photos] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath: %li", (long) indexPath.row);
    
    PXCollectionViewCell *cell = (PXCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    PXPhoto *photo = (PXPhoto *) [[[PXDataModel sharedInstance] photos] objectAtIndex:indexPath.row];
    if (cell)
    {
        NSLog(@"Cell: {id=%@ name=%@ rating=%.1f}", [photo.photoId stringValue], photo.name, [photo.rating doubleValue]);
        cell.photo = photo;
    }
    NSLog(@"-----------------");
    
    // Load more photos when the list ends
    /*
    if (indexPath.row == [[[PXDataModel sharedInstance] photos] count] - 1)
    {
        NSNumber *currentPage = [[PXDataModel sharedInstance] currentPhotoPage];
        NSInteger nextPage = [currentPage integerValue] + 1;
        
        [self loadMoreData:[NSNumber numberWithInteger:nextPage]];
    }
     */
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath: %li", (long) indexPath.row);
    PXPhoto *photo = (PXPhoto *) [[[PXDataModel sharedInstance] photos] objectAtIndex:indexPath.row];
    NSLog(@"Selected cell: {id=%@ name=%@ rating=%.1f}", [photo.photoId stringValue], photo.name, [photo.rating doubleValue]);
    NSLog(@"-----------------");
    
    // Create detail controller
    PXPhotoDetailTableViewController *photoDetailTableViewController = [[PXPhotoDetailTableViewController alloc] initWithNibName:@"PXPhotoDetailTableViewController" bundle:nil];
    photoDetailTableViewController.photo = photo;
    
    // Push detail view
    [self.navigationController pushViewController:photoDetailTableViewController animated:YES];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Deselect item
}

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark – <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(120, 120);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 20, 10, 20);
}

#pragma mark - Helper methods

- (void)loadMoreData:(NSNumber *)page
{
    // Execute call to get the photos
    [self.apiManager searchPhotos:kSearchPopularPhotos inPage:page withCompletionBlock:^(NSString *searchString, NSArray *results, NSError *error) {
        
        // Check if we have results
        if (results && results.count > 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSLog(@"Reloading data...");
                NSLog(@"Found %lu photos.", (unsigned long)[results count]);
                NSLog(@"-----------------");
                
                // Save loaded photos (only data)
                [[[PXDataModel sharedInstance] photos] addObjectsFromArray:results];
                
                // Reload collectionview data
                [self.collectionView reloadData];
            });
        }
        else if (error == nil)
        {
            NSLog(@"The page was loaded previously.");
        }
        else
        {
            NSLog(@"Error searching: %@", error.localizedDescription);
        }
    }];
}

@end
