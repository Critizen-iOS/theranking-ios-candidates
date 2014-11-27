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
 */
@interface RNKPictureCollectionViewCell (drawer)

/**
 *  Complete all fields with a Photo object
 *  @param photo 
 */
- (void) drawCellWithPicture: (Photo*) photo;

@end
