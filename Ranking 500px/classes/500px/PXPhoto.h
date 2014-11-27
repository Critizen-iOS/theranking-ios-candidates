//
//  PXPhoto.h
//  Ranking 500px
//
//  Created by Moisés Moreno on 25/11/14.
//  Copyright (c) 2014 sés. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PXUser.h"


#pragma mark - = PXImage = -

@interface PXImage: NSObject

#pragma mark - Creation -

/*!
 * Create a new image object from JSON.
 *
 * \param json JSON object.
 */
- (instancetype)initWithJSON:(NSDictionary *)json;

#pragma mark - Properties -

@property (nonatomic, readonly) short size;
@property (nonatomic, readonly) NSString *url;
@property (nonatomic, readonly) NSString *httpsUrl;
@property (nonatomic, readonly) NSString *format;

@end


#pragma mark - = PXPhoto = -

@interface PXPhoto: NSObject


#pragma mark - Creation -

/*!
 * Create a new photo object from JSON.
 *
 * \param json JSON object.
 */
- (instancetype)initWithJSON:(NSDictionary *)json;


#pragma mark - Properties -

//! ID of the photo.
@property (nonatomic, readonly) NSInteger photoId;
//! Title of the photo.
@property (nonatomic, readonly) NSString *name;
//! Description of the photo.
@property (nonatomic, readonly) NSString *photoDescription;
//! Make and model of the camera this photo was made with.
@property (nonatomic, readonly) NSString *camera;
//! This photo’s camera lens information.
@property (nonatomic, readonly) NSString *lens;
//! Focal length of the shot.
@property (nonatomic, readonly) NSString *focalLength;
//! ISO value of the shot.
@property (nonatomic, readonly) NSString *iso;
//! Shutter speed value of the shot.
@property (nonatomic, readonly) NSString *shutterSpeed;
//! Aperture value of the shot.
@property (nonatomic, readonly) NSString *aperture;
//! The number of views this photo has.
@property (nonatomic, readonly) NSInteger timesViewed;
//! Rating of the photo.
@property (nonatomic, readonly) float rating;
//! Status of the photo in the system. An active photo always has the status of 1.
@property (nonatomic, readonly) NSInteger status;
//! Timestamp indicating time of photo creation.
@property (nonatomic, readonly) NSDate *createdAt;
//! Category of the photo.
@property (nonatomic, readonly) short category;
//! A human-readable name of the location where the photo was taken.
@property (nonatomic, readonly) NSString *location;
//! Boolean value whether or not the community page (http://500px.com/photo/:id) of this photo is available. A value of true means the page is not available.
@property (nonatomic, readonly) BOOL privacy;
//! Latitude of the location where the photo was taken.
@property (nonatomic, readonly) double latitude;
//! Longitude of the location where the photo was taken.
@property (nonatomic, readonly) double longitude;
//! Timestamp of when the photo was taken.
@property (nonatomic, readonly) NSDate *takenAt;
//! Boolean value whether or not the photo is for sale.
@property (nonatomic, readonly) BOOL forSale;
//! The width of the original, unresized photo.
@property (nonatomic, readonly) NSInteger width;
//! The height of the origin, unresized photo.
@property (nonatomic, readonly) NSInteger height;
//! Number of votes cast on this photo.
@property (nonatomic, readonly) NSInteger votesCount;
//! Number of times this photo was added as a favorite on the website.
@property (nonatomic, readonly) NSInteger favoritesCount;
//! Number of comments this photo has.
@property (nonatomic, readonly) NSInteger commentsCount;
//! Number of positive votes (likes) this photo has received.
@property (nonatomic, readonly) NSInteger positiveVotesCount;
//! Boolean value whether the current photo is NSFW.
@property (nonatomic, readonly) BOOL nsfw;
//! The number of sales this photo has.
@property (nonatomic, readonly) NSInteger salesCount;
//! The highest rating this photo has had.
@property (nonatomic, readonly) double highestRating;
//! The date the highest rating was reached on.
@property (nonatomic, readonly) NSDate *highestRatingDate;
//! License type of the photo.
@property (nonatomic, readonly) short licenseType;
//! Boolean value indicating whether or not this photo has been converted.
@property (nonatomic, readonly) BOOL converted;
//! URL of the image. Deprecated.
@property (nonatomic, readonly) NSString *imageUrl;
//! Array with images URL and sizes.
@property (nonatomic, readonly) NSArray *images;
//! Author’s profile.
@property (nonatomic, readonly) PXUser *user;
//! Number of collections this photo is present in;
@property (nonatomic, readonly) NSInteger collectionsCount;

@end
