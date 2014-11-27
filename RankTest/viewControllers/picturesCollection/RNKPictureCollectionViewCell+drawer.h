//
//  RNKPictureCollectionViewCell+drawer.h
//  RankTest
//
//  Created by Rafael Bartolome on 27/11/14.
//  Copyright (c) 2014 www.rafaelbartolome.es. All rights reserved.
//

#import "RNKPictureCollectionViewCell.h"

@class Photo;

/**
 *  Extension for RNKPictureCollectionViewCell in order to fill all fields
 *  Not the best solution, bus is fast and the view doen't receive the model directly.
 */

@interface RNKPictureCollectionViewCell (drawer)

/**
 *  Complete all fields with a Photo object
 *  @param photo 
 */
- (void) drawCellWithPicture: (Photo*) photo;

@end
