//
//  TRPhotoCollectionViewCell.m
//  TheRanking
//
//  Created by Jesús Emilio Fernández de Frutos on 25/10/14.
//  Copyright (c) 2014 Jesús Emilio Fernández de Frutos. All rights reserved.
//

#import "TRPhotoCollectionViewCell.h"

@implementation TRPhotoCollectionViewCell


- (void)awakeFromNib
{

    [super awakeFromNib];

    [self.indicator startAnimating];

}


-(void) setUrl:(NSString *)url
{
    _url = url;
   [self.imagePhoto addObserver:self forKeyPath:@"image" options:0 context:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TRDownloadImage"
                                                        object:self
                                                      userInfo:@{@"imageView":self.imagePhoto, @"url":url}];
}


- (void)dealloc
{
    [self.imagePhoto removeObserver:self forKeyPath:@"image"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"image"])
    {
        [self.indicator stopAnimating];
       
    }
}


@end
