//
//  RNKPicturesCollectionVC.h
//  RankTest
//
//  Created by Rafael Bartolome on 26/11/14.
//  Copyright (c) 2014 www.rafaelbartolome.es. All rights reserved.
//

@import UIKit;
#import "CoreDataCollectionVC.h"

/**
 *  VC with a collection of pictures
 *  Inherits from CoreDataCollectionVC that acts as a CD datasource 
 */

@interface RNKPicturesCollectionVC : CoreDataCollectionVC

/**
 *  Index path of the selected document
 */
@property (nonatomic, readonly) NSIndexPath *selectedIndexPath;

@end
