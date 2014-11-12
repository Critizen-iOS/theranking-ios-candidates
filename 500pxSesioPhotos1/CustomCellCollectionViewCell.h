//
//  CustomCellCollectionViewCell.h
//  500pxSesioPhotos1
//
//  Created by Sergio Becerril on 12/11/14.
//  Copyright (c) 2014 Sergio Becerril. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCellCollectionViewCell : UICollectionViewCell


@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *puntuacion;
@property (strong, nonatomic) IBOutlet UIImageView *image;


@end
