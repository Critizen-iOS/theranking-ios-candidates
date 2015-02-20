//
//  DetailViewController.m
//  CritizenTestApp
//
//  Created by Patricio on 17/02/15.
//  Copyright (c) 2015 Patricio. All rights reserved.
//

#import "DetailViewController.h"
#import "InfoCell.h"
#import "DescriptionCell.h"
#import "AvatarCell.h"
#import "MapCell.h"
#import "NSObject+isNull.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString *const InfoCellIdentifier = @"InfoCell";
static NSString *const DescriptionCellIdentifier = @"DescriptionCell";
static NSString *const AvatarCellIdentifier = @"AvatarCell";
static NSString *const MapCellIdentifier = @"MapCell";

@implementation DetailViewController

@synthesize photo;
@synthesize photoId;
@synthesize imageScroll;
@synthesize imageView;
@synthesize infoTable;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    imageScroll.backgroundColor = [UIColor colorWithRed:239.0f green:239.0f blue:244.0f alpha:1.0f];
    
    UINib *infoCellNib = [UINib nibWithNibName:InfoCellIdentifier bundle:nil];
    [infoTable registerNib:infoCellNib forCellReuseIdentifier:InfoCellIdentifier];
    UINib *descriptionCellNib = [UINib nibWithNibName:DescriptionCellIdentifier bundle:nil];
    [infoTable registerNib:descriptionCellNib forCellReuseIdentifier:DescriptionCellIdentifier];
    UINib *avatarCellNib = [UINib nibWithNibName:AvatarCellIdentifier bundle:nil];
    [infoTable registerNib:avatarCellNib forCellReuseIdentifier:AvatarCellIdentifier];
    UINib *mapCellNib = [UINib nibWithNibName:MapCellIdentifier bundle:nil];
    [infoTable registerNib:mapCellNib forCellReuseIdentifier:MapCellIdentifier];
    
    
    [self fetchPhotoInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Instance Methods

- (void)fetchPhotoInfo
{
    photo = [[PXFetchManager sharedManager] fetchPhotoById:photoId];
    if (!photo) {
        [[PXFetchManager sharedManager] requestPhotoId:photoId
                                             imageSize:[NSNumber numberWithInt:4]
                                         callbackBlock:^(NSDictionary *dataDictionary, NSError *error) {
                                             photo = [[PXFetchManager sharedManager] fetchPhotoById:photoId];
                                             
                                             self.navigationItem.title = photo.name;
                                             [self setupPhotoImage];
                                             [infoTable reloadData];
                                         }];
    } else {
        
        self.navigationItem.title = photo.name;
        [self setupPhotoImage];
    }
}

- (void)setupPhotoImage
{
    NSURL *url = [NSURL URLWithString:photo.image_url];
    [imageView sd_setImageWithURL:url];
}

- (NSDictionary *)safeSetValueIfNilValue:(id)object forKey:(NSString *)key
{
    id value = object;
    if ([NSObject isNull:value])
        value = @"-";
    return @{key : value};
}

- (CGFloat)estimateDescriptionCellHeight
{
    DescriptionCell *tmpCell = [[DescriptionCell alloc] initWithFrame:CGRectMake(0, 0, infoTable.frame.size.width, 44)];
    CGSize constrainedSize = CGSizeMake(tmpCell.textLabel.frame.size.width, MAXFLOAT);
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:17]};
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:photo.photo_description attributes:attributes];
    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    tmpCell = nil;
    
    return MAX(44, ceilf(requiredHeight.size.height));
}

#pragma mark - Loading Cell Methods

- (UITableViewCell *)loadInfoCellWithInfo:(NSDictionary *)info forIndexPath:(NSIndexPath *)indexPath
{
    InfoCell *cell = [infoTable dequeueReusableCellWithIdentifier:InfoCellIdentifier forIndexPath:indexPath];
    NSArray *keys = [info allKeys];
    NSArray *values = [info allValues];
    cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", [keys firstObject], [values firstObject]];
    
    return cell;
}

- (UITableViewCell *)loadDescriptionCellWithDescription:(NSDictionary *)description forIndexPath:(NSIndexPath *)indexPath
{
    DescriptionCell *cell = [infoTable dequeueReusableCellWithIdentifier:DescriptionCellIdentifier forIndexPath:indexPath];
    NSArray *keys = [description allKeys];
    NSArray *values = [description allValues];
    cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", [keys firstObject], [values firstObject]];
    
    return cell;
}

- (UITableViewCell *)loadAvatarCellWithAvatar:(NSString *)avatar forIndexPath:(NSIndexPath *)indexPath
{
    AvatarCell *cell = [infoTable dequeueReusableCellWithIdentifier:AvatarCellIdentifier forIndexPath:indexPath];
    
    NSURL *url = [NSURL URLWithString:avatar];
    
    [cell.avatarImage sd_setImageWithURL:url];
    cell.avatarImage.layer.cornerRadius = 20;
    cell.avatarImage.clipsToBounds = YES;
    
    return cell;
}

- (UITableViewCell *)loadMapCellWithLocation:(NSDictionary *)location forIndexPath:(NSIndexPath *)indexPath
{
    MapCell *cell = [infoTable dequeueReusableCellWithIdentifier:MapCellIdentifier forIndexPath:indexPath];
    
    cell.latitude = [location valueForKey:@"latitude"];
    cell.longitude = [location valueForKey:@"longitude"];
    
    CLLocationCoordinate2D centerPoint;
    centerPoint.latitude = [cell.latitude doubleValue];
    centerPoint.longitude = [cell.longitude doubleValue];
    
    MKCoordinateRegion region = [cell.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(centerPoint, 30000, 30000)];
    [cell.mapView setRegion:[cell.mapView regionThatFits:region] animated:YES];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = centerPoint;
    [cell.mapView addAnnotation:point];
    
    return cell;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!photo) {
        return 0;
    }
    
    if ([NSObject isNotNull:photo.latitude] &&
        [NSObject isNotNull:photo.longitude] &&
        ![photo.latitude isEqual:@0] &&
        ![photo.longitude isEqual:@0]) {
        return 4;
    } else {
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = 0;
    
    switch (section) {
        case 0: { // Photo Info Section
            if ([NSObject isNotNull:photo.name])                 rows++;
            if ([NSObject isNotNull:photo.photo_description])    rows++;
            
            break;
        }
        case 1: { // User Info Section
            User *user = photo.user;
            if ([NSObject isNotNull:user.userpic_url])   rows++;
            if ([NSObject isNotNull:user.username])      rows++;
            if ([NSObject isNotNull:user.fullname])      rows++;
            if ([NSObject isNotNull:user.country])       rows++;
            if ([NSObject isNotNull:user.city])          rows++;
            break;
        }
            
        case 2: { // Camera Info Section
            Camera *cam = photo.camera;
            if ([NSObject isNotNull:cam.camera])         rows++;
            if ([NSObject isNotNull:cam.aperture])       rows++;
            if ([NSObject isNotNull:cam.focal_length])   rows++;
            if ([NSObject isNotNull:cam.iso])            rows++;
            if ([NSObject isNotNull:cam.shutter_speed])  rows++;
            if ([NSObject isNotNull:cam.lens])           rows++;
            break;
        }
            
        case 3: // Map Info Section
            if ([NSObject isNotNull:photo.latitude] &&
                [NSObject isNotNull:photo.longitude] &&
                ![photo.latitude isEqual:@0] &&
                ![photo.longitude isEqual:@0])
                rows++;
            break;
            
        default:
            break;
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) { // Photo Info Section
        
        switch (indexPath.row) {
            case 0: {
                NSDictionary *dict = [self safeSetValueIfNilValue:photo.name forKey:@"Name"];
                cell = [self loadInfoCellWithInfo:dict forIndexPath:indexPath];
                break;
            }
            case 1: {
                NSDictionary *dict = [self safeSetValueIfNilValue:photo.photo_description forKey:@"Description"];
                cell = [self loadDescriptionCellWithDescription:dict forIndexPath:indexPath];
                break;
            }
            default:
                break;
        }
        
    } else if (indexPath.section == 1) { // User Info Section
        
        User *user = photo.user;
        
        switch (indexPath.row) {
            case 0:
                cell = [self loadAvatarCellWithAvatar:user.userpic_url forIndexPath:indexPath];
                break;
            
            case 1: {
                NSDictionary *dict = [self safeSetValueIfNilValue:user.username forKey:@"Username"];
                cell = [self loadInfoCellWithInfo:dict forIndexPath:indexPath];
                break;
            }
            case 2: {
                NSDictionary *dict = [self safeSetValueIfNilValue:user.fullname forKey:@"Fullname"];
                cell = [self loadInfoCellWithInfo:dict forIndexPath:indexPath];
                break;
            }
            case 3: {
                NSDictionary *dict = [self safeSetValueIfNilValue:user.country forKey:@"Country"];
                cell = [self loadInfoCellWithInfo:dict forIndexPath:indexPath];
                break;
            }
            case 4: {
                NSDictionary *dict = [self safeSetValueIfNilValue:user.city forKey:@"City"];
                cell = [self loadInfoCellWithInfo:dict forIndexPath:indexPath];
                break;
            }
            default:
                break;
        }
        
    } else if (indexPath.section == 2) { // Camera Info Section
        
        Camera *cam = photo.camera;
        
        switch (indexPath.row) {
            case 0: {
                NSDictionary *dict = [self safeSetValueIfNilValue:cam.camera forKey:@"Model"];
                cell = [self loadInfoCellWithInfo:dict forIndexPath:indexPath];
                break;
            }
            case 1: {
                NSDictionary *dict = [self safeSetValueIfNilValue:cam.aperture forKey:@"Aperture"];
                cell = [self loadInfoCellWithInfo:dict forIndexPath:indexPath];
                break;
            }
            case 2: {
                NSDictionary *dict = [self safeSetValueIfNilValue:cam.focal_length forKey:@"Focal Length"];
                cell = [self loadInfoCellWithInfo:dict forIndexPath:indexPath];
                break;
            }
            case 3: {
                NSDictionary *dict = [self safeSetValueIfNilValue:cam.iso forKey:@"ISO"];
                cell = [self loadInfoCellWithInfo:dict forIndexPath:indexPath];
                break;
            }
            case 4: {
                NSDictionary *dict = [self safeSetValueIfNilValue:cam.shutter_speed forKey:@"Shutter Speed"];
                cell = [self loadInfoCellWithInfo:dict forIndexPath:indexPath];
                break;
            }
            case 5: {
                NSDictionary *dict = [self safeSetValueIfNilValue:cam.lens forKey:@"Lens"];
                cell = [self loadInfoCellWithInfo:dict forIndexPath:indexPath];
                break;
            }
            default:
                break;
        }
        
    } else if (indexPath.section == 3) { // Map Info Section
        
        if ([NSObject isNotNull:photo.longitude] && [NSObject isNotNull:photo.latitude]) {
            NSDictionary *dict1 = [self safeSetValueIfNilValue:photo.longitude forKey:@"longitude"];
            NSDictionary *dict2 = [self safeSetValueIfNilValue:photo.latitude forKey:@"latitude"];
            NSMutableDictionary *mergeDict = [NSMutableDictionary dictionary];
            [mergeDict addEntriesFromDictionary:dict1];
            [mergeDict addEntriesFromDictionary:dict2];
            cell = [self loadMapCellWithLocation:mergeDict forIndexPath:indexPath];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        // Map cell height
        return infoTable.frame.size.width;
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        // Description cell height
        return [self estimateDescriptionCellHeight];
    } else {
        // Other cells height
        return 44;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"";
    
    switch (section) {
        case 0:
            title = @"Photo Info";
            break;
            
        case 1:
            title = @"User Info";
            break;
            
        case 2:
            title = @"Camera Info";
            break;
            
        case 3:
            title = @"Map Info";
            break;
            
        default:
            break;
    }
    
    return title;
}

@end
