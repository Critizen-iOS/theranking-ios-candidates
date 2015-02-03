//
//  PXPhoto.h
//  The-Ranking-500-PX-Photo-Viewer
//
//  Created by Ernesto Pino on 2/2/15.
//  Copyright (c) 2015 Ernesto Pino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class PXAuthor;

@interface PXPhoto : NSObject

@property (nonatomic, strong) NSNumber *photoId;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *photoDescription;
@property (nonatomic, strong) NSString *camera;
@property (nonatomic, strong) NSString *lens;
@property (nonatomic, strong) NSString *focalLength;
@property (nonatomic, strong) NSString *iso;
@property (nonatomic, strong) NSString *shutterSpeed;
@property (nonatomic, strong) NSString *aperture;
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) PXAuthor *author;

@end
