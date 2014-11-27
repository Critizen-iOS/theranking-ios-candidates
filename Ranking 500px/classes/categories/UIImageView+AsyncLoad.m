//
//  UIImageView+AsyncLoad.m
//
//  Created by Moisés Moreno.
//

#import "UIImageView+AsyncLoad.h"

#import "HTTP.h"


@implementation UIImageView (AsyncLoad)

- (void)setAsyncImageFromURL:(NSString *)urlString forTag:(NSInteger)tag
{
    [self setAsyncImageFromURL:urlString forTag:tag loadingImage:nil completion:nil];
}

- (void)setAsyncImageFromURL:(NSString *)urlString forTag:(NSInteger)tag loadingImage:(UIImage *)loadingImage
{
    [self setAsyncImageFromURL:urlString forTag:tag loadingImage:nil completion:nil];
}

- (void)setAsyncImageFromURL:(NSString *)urlString forTag:(NSInteger)tag loadingImage:(UIImage *)loadingImage completion:(void (^)( BOOL success ))completion
{
    // set the tag
    self.tag = tag;
    self.image = loadingImage;
    
    [HTTP getURL:urlString completion:^( NSData *data ) {
        // check the tag
        if( tag == self.tag ) {
            self.image = data ? [[UIImage alloc] initWithData:data] : loadingImage;
        }
        
        if( completion ) completion( data && tag==self.tag );
    }];
}

@end
