//
//  TRMasterViewController.m
//  TheRanking
//
//  Created by Jesús Emilio Fernández de Frutos on 25/10/14.
//  Copyright (c) 2014 Jesús Emilio Fernández de Frutos. All rights reserved.
//


#import "TRMasterViewController.h"

#import "TRDetailViewController.h"
#import "TR500PX.h"
#import "TRCoreData.h"

#import "TRPhotoCollectionViewCell.h"
#import "TRAPIDownloadImage.h"

NSString *const myCell					= @"Cell";

@interface TRMasterViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (void)configureCell:(TRPhotoCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation TRMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"TheRanking"];
    
    TRAPIDownloadImage *download= [[TRAPIDownloadImage sharedInstance] init];
    NSLog(@"INIT%@", [download description]);
    UINib *cellNib = [UINib nibWithNibName:@"TRPhotoCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:myCell];
    
    
    // Configure layout
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(110, 124)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    
    [[TR500PX sharedInstance] loadDataCompletionBlock:^{
        [self.collectionView reloadData];
    }];
}



#pragma mark - UICollectionView

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSFetchedResultsController *fetchedResultsController=[[TRCoreData sharedInstance] fetchedResultsControllerPhoto];
    return [[fetchedResultsController sections] count];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSFetchedResultsController *fetchedResultsController=[[TRCoreData sharedInstance] fetchedResultsControllerPhoto];
    id <NSFetchedResultsSectionInfo> sectionInfo = [fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TRPhotoCollectionViewCell *cell = (TRPhotoCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:myCell forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


- (void)configureCell:(TRPhotoCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSFetchedResultsController *fetchedResultsController=[[TRCoreData sharedInstance] fetchedResultsControllerPhoto];
    Photo *object = [fetchedResultsController objectAtIndexPath:indexPath];
    cell.nameLabel.text = [[object valueForKey:@"Name"] description];
    cell.ratingLabel.text = [[object valueForKey:@"rating"] description];
    cell.url = [object valueForKey:@"image_url"];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSFetchedResultsController *fetchedResultsController=[[TRCoreData sharedInstance] fetchedResultsControllerPhoto];
    TRDetailViewController *vc =[[TRDetailViewController alloc] initWithNibName:nil bundle:nil];
    vc.photo = [fetchedResultsController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

