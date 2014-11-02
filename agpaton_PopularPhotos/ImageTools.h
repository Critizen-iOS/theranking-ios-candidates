//
//  ImageTools.h
//  agpaton_PopularPhotos
//
//  Created by Alejandro González Patón on 31/10/14.
//  Copyright (c) 2014 Alejandro González Patón. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageTools : NSObject

+ (void)GetPhotoFromURL:(NSString *)url andId:(NSNumber *)ID completion:(void (^)(UIImage * image))callback;

@end
