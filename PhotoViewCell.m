//
//  PhotoViewCell.m
//  agpaton_PopularPhotos
//
//  Created by Alejandro González Patón on 02/11/14.
//  Copyright (c) 2014 Alejandro González Patón. All rights reserved.
//

#import "PhotoViewCell.h"

#import "ImageTools.h"

@interface PhotoViewCell ()
@property (nonatomic, weak) IBOutlet UIImageView *imgView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *ratingLabel;
@end

@implementation PhotoViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    self.imgView.backgroundColor = [UIColor lightGrayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imgView.backgroundColor = [UIColor redColor];
    
    __weak PhotoViewCell *safeCell = self;
    
    __block int row = (int)self.tag;
    
    [ImageTools GetPhotoFromURL:self.imageUrl andId:self.imageId completion:^(UIImage *image) {
        
        NSIndexPath *indexPath = [(UITableView *)self.superview.superview indexPathForCell: self];
        
        if (row == indexPath.row) {
             safeCell.imgView.image = image;
        }
       
    }];
}

- (void)setName:(NSString *)name
{
    self.nameLabel.text = name;
}

- (void)setRating:(NSNumber *)rating
{
    self.ratingLabel.text = [NSString stringWithFormat:@"%.2f", [rating doubleValue]];
}

@end
