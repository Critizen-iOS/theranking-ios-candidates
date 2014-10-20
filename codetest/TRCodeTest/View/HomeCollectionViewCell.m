//
//  HomeCollectionViewCell.m
//  TRCodeTest
//
//  Created by Oscar on 18/10/14.
//  Copyright (c) 2014 Skyweb Production. All rights reserved.
//

#import "HomeCollectionViewCell.h"
#import "TR500PxPhoto.h"

@interface HomeCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *rating;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end

@implementation HomeCollectionViewCell

- (void)drawCellWithPhoto:(TR500PxPhoto *)photo {
    _name.text = photo.name;
    _rating.text = [NSString stringWithFormat:@"%.1f", photo.rating.floatValue];
    
    [_image sd_setImageWithURL:photo.url placeholderImage:[UIImage new]];
}

@end
