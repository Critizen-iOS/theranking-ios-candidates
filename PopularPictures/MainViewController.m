//
//  ViewController.m
//  PopularPictures
//
//  Created by Nelson on 25/11/14.
//  Copyright (c) 2014 Nelson Domínguez. All rights reserved.
//

#import "MainViewController.h"

#import "CoreDataManager.h"
#import "CollectionViewCell.h"
#import "PicturesManager.h"

#import "DetailViewController.h"

#define kCollectionViewCellIdentifier           @"UICollectionViewCellIdentifier"

@interface MainViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation MainViewController

-(NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext == nil) {
        _managedObjectContext = [CoreDataManager sharedManager].managedObjectContext;
    }
    return _managedObjectContext;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"Pictures", nil);
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadMostPopularPictures) forControlEvents:UIControlEventValueChanged];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
    [self.collectionView addSubview:self.refreshControl];
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellIdentifier];
    
    [self loadMostPopularPictures];
}

-(void)loadMostPopularPictures
{
    [[PicturesManager sharedManager] findPopularPicturesWithSuccessBlock:^(NSArray *array) {
        [self.refreshControl endRefreshing];
    } failureBlock:^(NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionView

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    double with = (CGRectGetWidth(collectionView.frame) - 30) / 2;
    return CGSizeMake(with, with);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.fetchedResultsController.fetchedObjects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = (CollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellIdentifier forIndexPath:indexPath];
    
    PhotoMO *photoItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.photoItem = photoItem;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoMO *photoItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    DetailViewController *viewController = [[DetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    viewController.photo = photoItem;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([PhotoMO class]) inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rating" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

@end
