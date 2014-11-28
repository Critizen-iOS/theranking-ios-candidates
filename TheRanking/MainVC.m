//
//  MainVC.m
//  TheRanking
//
//  Created by Luis Sanchez Garcia on 26/11/14.
//  Copyright (c) 2014 Luis Sánchez García. All rights reserved.
//

#import "MainVC.h"
#import "Ranking500pxAPI.h"
#import "MainCell.h"
#import "DetailVC.h"

@interface MainVC () <UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate> {
    NSMutableArray *_fetchedResultsObjectChanges;
    BOOL firstLoad;
}

@property (nonatomic, strong) Ranking500pxAPI *api;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) DetailVC *detailVC;

@end

@implementation MainVC

static NSString * const kCellIdentifier = @"MyCollViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = NSLocalizedString(@"The Ranking", @"Main View title");
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                               target:self
                               action:@selector(refreshData:)];
    self.navigationItem.rightBarButtonItem = button;
    
    // Configure collection view
    [self.collectionView registerClass:[MainCell class] forCellWithReuseIdentifier:kCellIdentifier];
    UINib *cellNib = [UINib nibWithNibName:@"MainCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:kCellIdentifier];
    
    // Configure api client
    self.api = [Ranking500pxAPI sharedInstance];
    
    // Configure query to the database
    _fetchedResultsObjectChanges = [NSMutableArray new];
    
    self.fetchedResultsController = [self.api popularPictureFetchedResultsController];
    self.fetchedResultsController.delegate = self;
    
    firstLoad = YES;
    
}

- (void) refreshData: (id) sender {
    __weak typeof(self) wSelf = self;
    
    [self.api refreshPopularImagesOnError:^(RankingAPIErrorCode errorCode, NSError *error) {
        
        NSString *title;
        NSString *message;
        
        switch(errorCode) {
            case RankingAPIErrorCodeCouldntContactServer:
            case RankingAPIErrorCodeNotFound:
            case RankingAPIErrorCodeBadResponse: {
                title = NSLocalizedString(@"Ups...", @"Response from server not what was expected, alert title");
                message = NSLocalizedString(@"500px is not answering as expected. Try again later...", @"Response from server not what was expected, alert message");
            }
                break;
            default:
            case RankingAPIErrorCodeUnknown: {
                NSLog(@"Error %@", error.description);
                title = NSLocalizedString(@"Error", @"Generic error alert title");
                message = NSLocalizedString(@"Couldn't contact server. Check connection and try again later.", @"Generic connectivity error alert message");
            }
                break;
        }
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle: title
                                              message: message
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionCancel = [UIAlertAction
                        actionWithTitle:NSLocalizedString(@"Ok", @"Acknowledge button")
                        style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:actionCancel];
        [wSelf presentViewController:alertController animated:YES completion:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.detailVC = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(firstLoad == YES) {
        [self refreshData:nil];
        firstLoad = NO;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (DetailVC *)detailVC {
    if(_detailVC == nil) {
        self.detailVC = [[DetailVC alloc] initWithNibName: nil bundle: nil];
    }
    return _detailVC;
}

#pragma mark - NSFetchResultsController Delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {

}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    NSMutableDictionary *change = [NSMutableDictionary new];
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            change[@(type)] = newIndexPath;
            break;
            
        case NSFetchedResultsChangeDelete:
            change[@(type)] = indexPath;
            break;
            
        case NSFetchedResultsChangeUpdate:
            change[@(type)] = indexPath;
            break;
            
        case NSFetchedResultsChangeMove:
            change[@(type)] = @[indexPath, newIndexPath];
            break;
    }
    
    [_fetchedResultsObjectChanges addObject: change];
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {

    if([_fetchedResultsObjectChanges count] > 0) {
        [self.collectionView performBatchUpdates:^{
            
            for (NSDictionary *change in _fetchedResultsObjectChanges)
            {
                [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    
                    NSFetchedResultsChangeType type = [key integerValue];
                    switch (type)
                    {
                        case NSFetchedResultsChangeInsert:
                            [self.collectionView insertItemsAtIndexPaths:@[obj]];
                            break;
                        case NSFetchedResultsChangeDelete:
                            [self.collectionView deleteItemsAtIndexPaths:@[obj]];
                            break;
                        case NSFetchedResultsChangeUpdate:
                            [self.collectionView reloadItemsAtIndexPaths:@[obj]];
                            break;
                        case NSFetchedResultsChangeMove:
                            [self.collectionView moveItemAtIndexPath:obj[0] toIndexPath:obj[1]];
                            break;
                        default:
                            break;
                    }
                }];
            }
        } completion:nil];
        
        [_fetchedResultsObjectChanges removeAllObjects];
    }
}

#pragma mark - CollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)sectionIndex {
    NSArray *sections = [self.fetchedResultsController sections];
    
    if (sectionIndex < [sections count])
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:sectionIndex];
        return sectionInfo.numberOfObjects;
    }
    
    return 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MainCell *cell = (MainCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    static NSNumberFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setMaximumFractionDigits:1];
        [formatter setRoundingMode:NSNumberFormatterRoundDown];
    });
    
    Picture *object = (Picture *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.titleLabel.text = object.pictureTitle;
    cell.ratingLabel.text = [formatter stringFromNumber:object.pictureRating];
    cell.imageURL = object.pictureURL;
    
    return cell;
}


#pragma mark - CollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Picture *object = (Picture *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    DetailVC *detailController = [self detailVC];
    detailController.selectedPicture = object;
    [self.navigationController pushViewController:detailController animated:YES];

    
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [(MainCell *)cell bounceRating];
}

@end
