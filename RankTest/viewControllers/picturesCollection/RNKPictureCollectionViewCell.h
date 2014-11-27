//
//  RNKPictureCollectionViewCell.h
//  RankTest
//
//  Created by Rafael Bartolome on 26/11/14.
//  Copyright (c) 2014 www.rafaelbartolome.es. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RNKPictureCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *ranking;
@property (weak, nonatomic) IBOutlet UIImageView *picture;


@end
