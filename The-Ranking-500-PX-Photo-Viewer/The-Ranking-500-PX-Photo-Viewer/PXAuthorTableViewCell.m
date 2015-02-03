//
//  PXAuthorTableViewCell.m
//  The-Ranking-500-PX-Photo-Viewer
//
//  Created by Ernesto Pino on 2/3/15.
//  Copyright (c) 2015 Ernesto Pino. All rights reserved.
//

#import "PXAuthorTableViewCell.h"

@implementation PXAuthorTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.pictureImageView.layer.cornerRadius = self.pictureImageView.frame.size.width / 2;
    self.pictureImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
