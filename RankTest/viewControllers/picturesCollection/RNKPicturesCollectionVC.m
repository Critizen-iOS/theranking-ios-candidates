//
//  RNKPicturesCollectionVC.m
//  RankTest
//
//  Created by Rafael Bartolome on 26/11/14.
//  Copyright (c) 2014 www.rafaelbartolome.es. All rights reserved.
//

#import "RNKPicturesCollectionVC.h"
#import "RNKConstants.h"
#import "RNKDataBaseEngine.h"
#import "RNKPictureCollectionViewCell.h"
#import "RNKPhotosEngine.h"
#import "RNKPictureDetailVC.h"


//TODO
#import "Photo.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface RNKPicturesCollectionVC ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) RNKPhotosEngine *photosEngine;

@end

@implementation RNKPicturesCollectionVC

static NSString * const reuseIdentifier = @"PictureCell";

- (void)viewDidLoad {
    DLog();

    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"RNKPictureCollectionViewCell" bundle:nil] forCellWithReuseIdentifier: reuseIdentifier];
    
    // Do any additional setup after loading the view.

    [self setManagedObjectContext: [[RNKDataBaseEngine sharedInstance] getManagedObjectContext]];

    //TODO: show loading

    //Load values
    [self.photosEngine getPopularPicturesOnCompletion:^(BOOL result, NSError *error) {
        //TODO: manage error and hide loading

    }];
    

}

- (RNKPhotosEngine*) photosEngine {
    DLog();
    if (!_photosEngine) {
        _photosEngine = [[RNKPhotosEngine alloc] init];
    }
    return _photosEngine;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    DLog();

    _managedObjectContext = managedObjectContext;

    //DLog(@"  %@", _managedObjectContext);

    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];

    NSString *predicateString = nil; //All pictures

    fetchRequest.predicate = [NSPredicate predicateWithFormat: predicateString];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"rating"
                                                                   ascending: NO ]];

    [fetchRequest setFetchBatchSize:20];

    self.debug = YES;
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest: fetchRequest
                                                                        managedObjectContext: managedObjectContext
                                                                          sectionNameKeyPath: nil
                                                                                   cacheName: nil];


    if (self.fetchedResultsController.fetchedObjects.count == 0 ) {
        DLog(@"No pictures fetched");
    } else {
        DLog(@"%lu pictures found", (unsigned long)self.fetchedResultsController.fetchedObjects.count);
    }

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    RNKPictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    // Configure the cell //TODO:

    /*
     //TODO load  more results
    if (indexPath.row == ([[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects] -1)) {
        [self.photosEngine getPopularPicturesOnCompletion:^(BOOL result, NSError *error) {
            //TODO: manage error
        }];
    }
    */


    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];

    //Config cell
    cell.title.text = photo.name;

    cell.ranking.text = [photo.rating stringValue];

    [cell.picture sd_setImageWithURL:[NSURL URLWithString: photo.image_url]];

    return cell;

}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    RNKPictureDetailVC *pictureDetailVC = [[RNKPictureDetailVC alloc] initWithNibName:@"RNKPictureDetailVC" bundle:nil];

    pictureDetailVC.photo = photo;

    [self.navigationController pushViewController: pictureDetailVC animated: YES];

}

@end
