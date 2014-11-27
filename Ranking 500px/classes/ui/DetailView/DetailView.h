//
//  DetailView.h
//  Ranking 500px
//
//  Created by Moisés Moreno on 26/11/14.
//  Copyright (c) 2014 sés. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PXPhoto.h"

#pragma mark - = DetailView = -

@interface DetailView: UIView <UIScrollViewDelegate>

#pragma mark - Creation

+ (DetailView *)detailView;


#pragma mark - Data -

- (void)setPhoto:(PXPhoto *)pxPhoto preview:(UIImage *)preview;

#pragma mark - Show/hide -

- (void)openInView:(UIView *)parentView fromView:(UIView *)sourceView;
- (void)close;

@end
