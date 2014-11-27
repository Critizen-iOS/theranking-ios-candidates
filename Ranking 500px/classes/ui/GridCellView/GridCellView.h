//
//  GridCellView.h
//  Ranking 500px
//
//  Created by Moisés Moreno on 26/11/14.
//  Copyright (c) 2014 sés. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PXPhoto.h"

#pragma mark - = GridCellView = -

@interface GridCellView: UICollectionViewCell

#pragma mark - Data -

- (void)setPhoto:(PXPhoto *)pxPhoto;

- (UIImage *)image;

@end
