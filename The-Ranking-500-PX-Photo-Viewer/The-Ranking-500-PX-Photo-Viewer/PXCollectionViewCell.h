//
//  PXCollectionViewCell.h
//  The-Ranking-500-PX-Photo-Viewer
//
//  Created by Ernesto Pino on 2/2/15.
//  Copyright (c) 2015 Ernesto Pino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXPhoto.h"

@interface PXCollectionViewCell : UICollectionViewCell

#pragma mark - Outlets
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

#pragma mark - Properties
@property (nonatomic, strong) PXPhoto *photo;

@end
