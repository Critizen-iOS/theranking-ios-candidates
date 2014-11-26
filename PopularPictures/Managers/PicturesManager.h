//
//  PicturesManager.h
//  PopularPictures
//
//  Created by Nelson on 25/11/14.
//  Copyright (c) 2014 Nelson Domínguez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PicturesManager : NSObject

+(instancetype)sharedManager;

-(void)findPopularPicturesWithSuccessBlock:(void (^)(NSArray* array))successBlock
                              failureBlock:(void (^)(NSError *error))failureBlock;

@end
