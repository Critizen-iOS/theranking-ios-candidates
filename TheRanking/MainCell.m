//
//  MainCell.m
//  TheRanking
//
//  Created by Luis Sanchez Garcia on 27/11/14.
//  Copyright (c) 2014 Luis Sánchez García. All rights reserved.
//

#import "MainCell.h"

@interface MainCell() {
    CGFloat originalTopSpaceRatingConstant;
    CGFloat originalBottomSpaceTitleConstant;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceRatingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceTitleConstraint;

@end

@implementation MainCell

- (void)awakeFromNib {
    // Initialization code
    originalTopSpaceRatingConstant = self.topSpaceRatingConstraint.constant;
    originalBottomSpaceTitleConstant = self.bottomSpaceTitleConstraint.constant;
    
}

-(void)setHighlighted:(BOOL)highlighted
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

@end
