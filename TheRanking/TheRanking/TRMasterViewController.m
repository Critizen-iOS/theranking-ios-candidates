//
//  TRMasterViewController.m
//  TheRanking
//
//  Created by Jesús Emilio Fernández de Frutos on 07/02/15.
//  Copyright (c) 2015 Jesús Emilio Fernández de Frutos. All rights reserved.
//

#import "TRMasterViewController.h"
#import "TR500PX.h"
#import "TRPhotoCollectionViewCell.h"
#import "Photo.h"
#import "TRAPIDownloadImage.h"
#import "AppDelegate.h"

NSString *const myCell					= @"Cell";

@interface TRMasterViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation TRMasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //Get the managedObjectContext
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _managedObjectContext = [appDelegate managedObjectContext];
    
    [self configureLayout];
    
    [self loadData];
}

-(void) configureLayout
{
    UINib *cellNib = [UINib nibWithNibName:@"TRPhotoCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:myCell];
    
    // Configure layout
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    [flowLayout setItemSize:CGSizeMake(110, 124)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                               target:self
                               action:@selector(refreshButtonSend)];
    self.navigationItem.rightBarButtonItem = button;
    [self.navigationItem setTitle:@"TheRanking"];
}

-(void)loadData
{
    TRAPIDownloadImage *download= [[TRAPIDownloadImage sharedInstance] init];
    NSLog(@"INIT%@", [download description]);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"firstRun"])
    {
        
        [defaults setObject:[NSDate date] forKey:@"firstRun"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self refresh];
    }
    
}

-(void) clearStorage
{
    NSFetchRequest * allPhotos = [[NSFetchRequest alloc] init];
    [allPhotos setEntity:[NSEntityDescription entityForName:@"Photo" inManagedObjectContext:self.managedObjectContext]];
    [allPhotos setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * photos = [self.managedObjectContext executeFetchRequest:allPhotos error:&error];
    

    for (NSManagedObject * photo in photos) {
        [self.managedObjectContext deleteObject:photo];
    }
    
    NSFetchRequest * allUsers = [[NSFetchRequest alloc] init];
    [allUsers setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext]];
    [allUsers setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSArray * users = [self.managedObjectContext executeFetchRequest:allPhotos error:&error];
    
    for (NSManagedObject * user in users) {
        [self.managedObjectContext deleteObject:user];
    }

    
    
    NSError *saveError = nil;
    [self.managedObjectContext save:&saveError];
}

-(void) refreshButtonSend
{
    [self clearStorage];
    [self refresh];
}

-(void) refresh
{
    [[TR500PX sharedInstance] loadDataCompletionBlock:^{
        [self.collectionView reloadData];
    }];
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        NSError *error = nil;
        if (![_fetchedResultsController performFetch:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Photo" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // We retrieve all rows.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rating" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}




#pragma mark - UICollectionView

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    NSLog(@"%lu", (unsigned long)[sectionInfo numberOfObjects]);
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
    Photo *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.nameLabel.text = [[object valueForKey:@"Name"] description];
    cell.ratingLabel.text = [[object valueForKey:@"rating"] description];
    cell.url = [object valueForKey:@"image_url"];
}



@end
