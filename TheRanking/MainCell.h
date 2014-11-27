//
//  MainCell.h
//  TheRanking
//
//  Created by Luis Sanchez Garcia on 27/11/14.
//  Copyright (c) 2014 Luis Sánchez García. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *ratingLabel;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@end
