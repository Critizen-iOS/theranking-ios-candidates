//
//  TRPhotoCVCell.m
//  theranking-ios-candidates.
//
//  Created by Joaquin Perez Barroso on 23/11/14.
//  Copyright (c) 2014 Joaquin Perez Barroso. All rights reserved.
//

#import "TRPhotoCVCell.h"
#import "TRDataNetManager.h"
#import "Photo.h"

@interface TRPhotoCVCell ()

@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *ratingLabel;

@end


@implementation TRPhotoCVCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGSize size = frame.size;
        self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        [self.contentView addSubview:self.photoView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, size.height -20 , size.width, 20)];
        self.nameLabel.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.font = [UIFont systemFontOfSize:15];
        
        [self.contentView addSubview:self.nameLabel];
        
        self.ratingLabel = [[UILabel alloc] initWithFrame:CGRectMake(size.width - 60, 0, 60, 18)];
        self.ratingLabel.textAlignment = NSTextAlignmentCenter;
        self.ratingLabel.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
        
        [self.contentView addSubview:self.ratingLabel];
        
        
    }
    return self;
}

-(void)setPhoto:(Photo *)photo
{
    self.nameLabel.text = photo.name;
    self.ratingLabel.text = [NSString stringWithFormat:@"%0.2f",[photo.rating floatValue]];
    
    if (photo.imageData)
    {
        self.photoView.image = [UIImage imageWithData:photo.imageData];
    }
    else
    {
        self.photoView.image = nil;
        dispatch_async(dispatch_queue_create("CatchPhoto", nil), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:photo.image_url]];
            
            if (data)
            {
                dispatch_async(dispatch_get_main_queue(),
                               ^{
                                   self.photoView.image = [UIImage imageWithData:data];
                                   photo.imageData = data;
                                   [[TRDataNetManager sharedManager].managedObjectContext save:nil];
                                   
                               });
            }
            
            
        });
    }
    
    _photo = photo;
}

@end
