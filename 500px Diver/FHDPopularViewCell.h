//
//  FHDPopularCellViewCollectionViewCell.h
//  500px Diver
//
//  Created by Jaime on 25/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

// This class represents a single cell for the collection view
@interface FHDPopularViewCell : UICollectionViewCell

// Name of the item
@property (nonatomic, weak) IBOutlet UILabel *nameLbl;
// Rating for the item
@property (nonatomic, weak) IBOutlet UILabel *ratingLbl;
// Image for the item
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
// Waiting when image is loading
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityView;

@end
