//
//  MainCell.m
//  TheRanking
//
//  Created by Luis Sanchez Garcia on 27/11/14.
//  Copyright (c) 2014 Luis Sánchez García. All rights reserved.
//

#import "MainCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MainCell() {
    CGFloat originalTopSpaceRatingConstant;
    CGFloat originalBottomSpaceTitleConstant;
}

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceRatingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceTitleConstraint;

@end

@implementation MainCell

- (void)awakeFromNib {
    // Initialization code
    originalTopSpaceRatingConstant = self.topSpaceRatingConstraint.constant;
    originalBottomSpaceTitleConstant = self.bottomSpaceTitleConstraint.constant;
    
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.imageView sd_cancelCurrentImageLoad];
    self.imageView.image = nil;
}

- (void) bounceRating {
    self.ratingLabel.transform = CGAffineTransformMakeScale(2.f, 2.f);
    
    [UIView animateWithDuration:0.4 animations:^{
        self.ratingLabel.transform = CGAffineTransformIdentity;
    }];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    [self.ratingLabel.superview layoutIfNeeded];
    [self.titleLabel.superview layoutIfNeeded];
    
    [UIView animateWithDuration:0.2 animations:^{

        if(highlighted) {
            self.topSpaceRatingConstraint.constant = -CGRectGetHeight(self.ratingLabel.bounds);
            self.bottomSpaceTitleConstraint.constant = -CGRectGetHeight(self.titleLabel.bounds);
        } else {
            self.topSpaceRatingConstraint.constant = originalTopSpaceRatingConstant;
            self.bottomSpaceTitleConstraint.constant = originalBottomSpaceTitleConstant;
        }
        
        [self.ratingLabel.superview layoutIfNeeded];
        [self.titleLabel.superview layoutIfNeeded];
    }];
}

- (void)setImageURL:(NSString *)imageURL {
    _imageURL = [imageURL copy];
    NSLog(@"%@", imageURL);
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"placeholder"]];
}

@end
