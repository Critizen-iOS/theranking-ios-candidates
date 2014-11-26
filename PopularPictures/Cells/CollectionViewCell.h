//
//  CollectionViewCell.h
//  PopularPictures
//
//  Created by Nelson on 25/11/14.
//  Copyright (c) 2014 Nelson Domínguez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoMO.h"

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) PhotoMO *photoItem;

@end
