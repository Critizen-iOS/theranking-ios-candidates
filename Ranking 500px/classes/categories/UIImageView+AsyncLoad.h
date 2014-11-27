//
//  UIImageView+AsyncLoad.h
//
//  Created by Moisés Moreno.
//

#import <UIKit/UIKit.h>

@interface UIImageView (AsyncLoad)

- (void)setAsyncImageFromURL:(NSString *)urlString forTag:(NSInteger)tag;
- (void)setAsyncImageFromURL:(NSString *)urlString forTag:(NSInteger)tag loadingImage:(UIImage *)loadingImage;
- (void)setAsyncImageFromURL:(NSString *)urlString forTag:(NSInteger)tag loadingImage:(UIImage *)loadingImage completion:(void (^)( BOOL success ))completion;

@end
