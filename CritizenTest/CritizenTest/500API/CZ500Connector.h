//
//  CZ500Connector.h
//  CritizenTest
//
//  Created by Juan Pedro Catalán on 20/11/14.
//  Copyright (c) 2014 Juanpe Catalán. All rights reserved.
//

#import "CZ500Request.h"
#import "CZCamera.h"
#import "CZPhoto.h"
#import "CZPhotoThumb.h"
#import "CZUser.h"

typedef void (^CZPhotoRequestCompletionBlock)(CZPhoto * photo, NSError *error);
typedef void (^CZFeaturedPhotosRequestCompletionBlock)(NSArray * thumbs, BOOL morePhotos, NSError *error);

@interface CZ500Connector : NSObject

+ (CZ500Request *) requestForPhotoFeature:(CZ500PhotoFeature)photoFeature
                                     page:(NSInteger)page
                               photoSizes:(CZ500PhotoModelSize)photoSizesMask
                               completion:(CZFeaturedPhotosRequestCompletionBlock)completionBlock;

+ (CZ500Request *) requestForPhotoID:(NSInteger)photoID
                          photoSizes:(CZ500PhotoModelSize)photoSizesMask
                          completion:(CZPhotoRequestCompletionBlock)completionBlock;

@end
