//
//  GridCellView.m
//  Ranking 500px
//
//  Created by Moisés Moreno on 26/11/14.
//  Copyright (c) 2014 sés. All rights reserved.
//

#import "GridCellView.h"

#import "UIImageView+AsyncLoad.h"


#pragma mark - = GridCellView () = -

@interface GridCellView ()

#pragma - Outlets -

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *ratingLabel;

@end


#pragma mark - = GridCellView = -

@implementation GridCellView

#pragma mark - Data -

- (void)setPhoto:(PXPhoto *)pxPhoto
{
    PXImage *pxImage = pxPhoto.images[0];
    [_imageView setAsyncImageFromURL:pxImage.url forTag:pxPhoto.photoId];
    _nameLabel.text = pxPhoto.name;
    _ratingLabel.text = [NSString stringWithFormat:@"%.1f", pxPhoto.rating];
}

- (UIImage *)image
{
    return _imageView.image;
}

@end
