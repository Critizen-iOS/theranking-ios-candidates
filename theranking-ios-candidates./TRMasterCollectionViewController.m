//
//  TRMasterCollectionViewController.m
//  theranking-ios-candidates.
//
//  Created by Joaquin Perez Barroso on 23/11/14.
//  Copyright (c) 2014 Joaquin Perez Barroso. All rights reserved.
//

#import "TRMasterCollectionViewController.h"
#import "TRDetailViewController.h"
#import "TRPhotoCVCell.h"
#import "TRDataNetManager.h"

@interface TRMasterCollectionViewController ()

@property (nonatomic, strong) NSMutableArray *listOfPhotos;
@property (nonatomic) CGSize mainSize;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultController;

@end

@implementation TRMasterCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Fotos populares", nil);
    
    self.mainSize = [UIScreen mainScreen].bounds.size;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[TRPhotoCVCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    [[TRDataNetManager sharedManager] updatePhotosWithCompletionHandler:nil];
    [self fetchData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}



#pragma mark <UICollectionViewDataSource>




- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return [[[self.fetchedResultController sections] objectAtIndex:0] numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TRPhotoCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    if (indexPath.row == ([[[self.fetchedResultController sections] objectAtIndex:0] numberOfObjects] -1))
    {
        [[TRDataNetManager sharedManager] updatePhotosWithCompletionHandler:nil];
        NSLog(@"llamado");
    }
    
    cell.photo = [self.fetchedResultController objectAtIndexPath:indexPath];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TRDetailViewController *detail = [[TRDetailViewController alloc] init];
    detail.photo = [self.fetchedResultController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:detail animated:YES];
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.mainSize.width -45)/2, (self.mainSize.width -45)/2);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 15, 15, 15);
}

#pragma mark - fetch
-(void)fetchData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Photo" inManagedObjectContext:[TRDataNetManager sharedManager].managedObjectContext]];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"rating" ascending:NO];
    NSArray *sorts = @[sort];
    [request setSortDescriptors:sorts];
    
    self.listOfPhotos = [NSMutableArray arrayWithArray:[[TRDataNetManager sharedManager].managedObjectContext executeFetchRequest:request error:nil]];
    
    self.fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[TRDataNetManager sharedManager].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    [self.fetchedResultController performFetch:nil];
    self.fetchedResultController.delegate = self;
    
}




@end



