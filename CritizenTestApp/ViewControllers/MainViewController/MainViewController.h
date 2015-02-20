//
//  MainViewController.h
//  CritizenTestApp
//
//  Created by Patricio on 17/02/15.
//  Copyright (c) 2015 Patricio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXFetchManager.h"

@interface MainViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *photosArray;

@end
