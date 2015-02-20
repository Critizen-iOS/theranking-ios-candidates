//
//  PhotoCell.h
//  CritizenTestApp
//
//  Created by Patricio on 18/02/15.
//  Copyright (c) 2015 Patricio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIView *scoreOverlay;

@end
