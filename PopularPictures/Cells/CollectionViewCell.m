//
//  CollectionViewCell.m
//  PopularPictures
//
//  Created by Nelson on 25/11/14.
//  Copyright (c) 2014 Nelson Domínguez. All rights reserved.
//

#import "CollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CollectionViewCell()

@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *ratingLabel;

@end

@implementation CollectionViewCell

-(void)setPhotoItem:(PhotoMO *)photoItem
{
    _photoItem = photoItem;
    
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:photoItem.imageUrl]];
    self.nameLabel.text = photoItem.name;
    self.ratingLabel.text = [NSString stringWithFormat:@"%.1f", photoItem.rating.floatValue];
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    
    self.photoImageView.image = nil;
    self.nameLabel.text = nil;
    self.ratingLabel.text = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        float shadowRadius = 3.0;
        
        self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        self.photoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.photoImageView.layer.borderWidth = 3.0;
        self.photoImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.photoImageView.layer.shadowRadius = shadowRadius;
        self.photoImageView.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
        self.photoImageView.layer.shadowOpacity = 0.5f;
        [self.contentView addSubview:self.photoImageView];
        
        self.ratingLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame) - 60 - shadowRadius, shadowRadius, 60, 18)];
        self.ratingLabel.font = [UIFont systemFontOfSize:13];
        self.ratingLabel.textColor = [UIColor whiteColor];
        self.ratingLabel.textAlignment = NSTextAlignmentCenter;
        self.ratingLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        [self.contentView addSubview:self.ratingLabel];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(shadowRadius, CGRectGetMaxY(self.photoImageView.frame) - 20 - shadowRadius, CGRectGetWidth(frame) - (shadowRadius * 2), 20)];
        self.nameLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}

@end
