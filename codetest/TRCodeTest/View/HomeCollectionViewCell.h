//
//  HomeCollectionViewCell.h
//  TRCodeTest
//
//  Created by Oscar on 18/10/14.
//  Copyright (c) 2014 Skyweb Production. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

@class TR500PxPhoto;

@interface HomeCollectionViewCell : UICollectionViewCell

- (void)drawCellWithPhoto:(TR500PxPhoto *)photo;

@end
