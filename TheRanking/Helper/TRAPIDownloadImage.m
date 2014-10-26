//
//  TRAPIDownloadImage.m
//  TheRanking
//
//  Created by Jesús Emilio Fernández de Frutos on 25/10/14.
//  Copyright (c) 2014 Jesús Emilio Fernández de Frutos. All rights reserved.
//

#import "TRAPIDownloadImage.h"


@interface TRAPIDownloadImage()
@property (nonatomic, strong) NSMutableDictionary *pictures;
@end
@implementation TRAPIDownloadImage

- (id)init
{
    self = [super init];
    if (self) {
        _pictures = [[NSMutableDictionary alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadImage:) name:@"TRDownloadImage" object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (TRAPIDownloadImage*)sharedInstance
{

    static TRAPIDownloadImage *_sharedInstance = nil;
    

    static dispatch_once_t oncePredicate;
    
    // 3
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[TRAPIDownloadImage alloc] init];
    });
    return _sharedInstance;
}

- (void)downloadImage:(NSNotification*)notification
{

    UIImageView *imageView = notification.userInfo[@"imageView"];
    NSString *url = notification.userInfo[@"url"];
    

    imageView.image =[self.pictures valueForKey:url];
    
    if (imageView.image == nil)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.pictures setValue:[UIImage imageWithData:imageData] forKey:url];
                imageView.image = [UIImage imageWithData:imageData];
            });
        });
    }
}
@end
