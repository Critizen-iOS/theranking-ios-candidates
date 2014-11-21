//
//  CZRoundedImageView.m
//  CritizenTest
//
//  Created by Juan Pedro Catalán on 20/11/14.
//  Copyright (c) 2014 Juanpe Catalán. All rights reserved.
//

#import "CZRoundedImageView.h"

@implementation CZRoundedImageView

- (id) initWithCoder:(NSCoder *)aDecoder{

    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.layer.cornerRadius = self.frame.size.width / 2;
        self.clipsToBounds      = YES;
        
        self.layer.borderWidth  = 1.5f;
        self.layer.borderColor  = [UIColor lightGrayColor].CGColor;
        
    }
    return self;
}

@end
