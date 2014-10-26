//
//  TRPhotoCollectionViewCell.h
//  TheRanking
//
//  Created by Jesús Emilio Fernández de Frutos on 25/10/14.
//  Copyright (c) 2014 Jesús Emilio Fernández de Frutos. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 UICollectionViewCell class
 */
@interface TRPhotoCollectionViewCell : UICollectionViewCell

/**
 Label to display the rating score
 */
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

/**
 UIimageView to display the phot from 500px
 */
@property (weak, nonatomic) IBOutlet UIImageView *imagePhoto;

/**
 indicator to display meanwhile the photo is downloading
 */
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

/**
 UILabel to display the name of the photo
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/**
 The URL to download the photo
 */
@property (weak, nonatomic) NSString *url;

@end
