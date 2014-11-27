//
//  RNKPictureCollectionViewCell+drawer.m
//  RankTest
//
//  Created by Rafael Bartolome on 27/11/14.
//  Copyright (c) 2014 www.rafaelbartolome.es. All rights reserved.
//

#import "RNKPictureCollectionViewCell+drawer.h"
#import "Photo.h"
#import <SDWebImage/UIImageView+WebCache.h>


@implementation RNKPictureCollectionViewCell (drawer)

- (void) drawCellWithPicture: (Photo*) photo {

    self.title.text = photo.name;

    self.ranking.text = [photo.rating stringValue];

    [self.picture sd_setImageWithURL:[NSURL URLWithString: photo.image_url]];

}

@end
