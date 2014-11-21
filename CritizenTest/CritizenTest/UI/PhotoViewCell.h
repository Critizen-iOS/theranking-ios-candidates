//
//  PhotoViewCell.h
//  CritizenTest
//
//  Created by Juan Pedro Catalán on 20/11/14.
//  Copyright (c) 2014 Juanpe Catalán. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewCell : UICollectionViewCell


@property (nonatomic, strong) IBOutlet UIImageView * thumbImageView;
@property (nonatomic, strong) IBOutlet UILabel * photoNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *ratingLabel;

@end
