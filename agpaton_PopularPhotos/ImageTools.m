//
//  ImageTools.m
//  agpaton_PopularPhotos
//
//  Created by Alejandro González Patón on 31/10/14.
//  Copyright (c) 2014 Alejandro González Patón. All rights reserved.
//

#import "ImageTools.h"

@implementation ImageTools

+ (void)GetPhotoFromURL:(NSString *)url andId:(NSNumber *)ID completion:(void (^)(UIImage * image))callback {
    
    UIImage *image = [self readMediaImage:[NSString stringWithFormat:@"PHOTO_%@", ID]];
    
    if (!image) {
        // Get the expected image
        dispatch_queue_t callerQueue = dispatch_get_main_queue();
        dispatch_queue_t downloadQueue = dispatch_queue_create("com.imageurlgetqueue", NULL);
        dispatch_async(downloadQueue, ^{
            NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            
            UIImage *img = [UIImage imageWithData:imageData];
            
            dispatch_async(callerQueue, ^{
                if (callback) {
                    callback(img);
                }
               
                [self writeLocalMediaImage:img name:[NSString stringWithFormat:@"PHOTO_%@", ID]];
            });
        });

    } else {
        if (callback) {
            callback(image);
        }
    }
}

+ (UIImage *)readMediaImage:(NSString *)imgID {
    if (![imgID isEqualToString:@""]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *pathToFile = [documentsDirectory stringByAppendingPathComponent:imgID];
        
        NSData *imageData = [NSData dataWithContentsOfFile:pathToFile];
        return [UIImage imageWithData:imageData];
    }
    return nil;
}


+ (void)writeLocalMediaImage :(UIImage *)image name:(NSString*)imgID {
    if ([imgID isEqualToString:@""]) {
        return;
    }
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:imgID];
    
    //   NSLog(@"MEDIA CHACHE %@", savedImagePath);
    
    [data writeToFile:savedImagePath atomically:YES];
}

@end

