//
//  DetailViewController.m
//  PopularPictures
//
//  Created by Nelson on 25/11/14.
//  Copyright (c) 2014 Nelson Domínguez. All rights reserved.
//

#import "DetailViewController.h"

#import <MapKit/MapKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "MapViewAnnotation.h"
#import "UIImage+Color.h"

#define kTableViewCellIdentifier            @"TableViewCellIdentifier"

typedef NS_ENUM(NSInteger, TableViewCellType) {
    TableViewCellTypeName,
    TableViewCellTypeDesc,
    TableViewCellTypeUserInfo,
    TableViewCellTypeCameraInfo,
    TableViewCellTypeMap,
};

@interface DetailViewController ()

@property (nonatomic, strong) NSArray *options;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Photo Detail", nil);
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.tableView.separatorInset = UIEdgeInsetsMake(15, 15, 15, 15);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
    
    NSMutableArray *options = [NSMutableArray new];
    if (self.photo.name.length > 0) {
        [options addObject:@(TableViewCellTypeName)];
    }
    if (self.photo.desc.length > 0) {
        [options addObject:@(TableViewCellTypeDesc)];
    }
    if (self.photo.userName.length > 0) {
        [options addObject:@(TableViewCellTypeUserInfo)];
    }
    if (self.photo.camera.length > 0) {
        [options addObject:@(TableViewCellTypeCameraInfo)];
    }
    if (self.photo.latitude.doubleValue != 0 && self.photo.longitude.doubleValue != 0) {
        [options addObject:@(TableViewCellTypeMap)];
    }
    self.options = [NSArray arrayWithArray:options];
}

#pragma mark TableView Delegate and Datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.options.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *option = [self.options objectAtIndex:indexPath.row];
    TableViewCellType type = option.integerValue;
    
    if (type == TableViewCellTypeName) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTableViewCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = self.photo.name;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        return cell;
    }
    else if (type == TableViewCellTypeDesc) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTableViewCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.numberOfLines = 0;
        
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[self.photo.desc dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        
        cell.textLabel.attributedText = attrStr;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        
        return cell;
    }
    else if (type == TableViewCellTypeUserInfo) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTableViewCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = self.photo.userName;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        
        cell.imageView.layer.cornerRadius = 8.0;
        cell.imageView.clipsToBounds = YES;
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.photo.userImageUrl] placeholderImage:[UIImage imageWithColor:[UIColor darkTextColor] size:(CGSize){45.0, 45.0}]];
        
        return cell;
    }
    else if (type == TableViewCellTypeCameraInfo) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kTableViewCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = self.photo.camera;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.text = self.photo.aperture.description;
        return cell;
    }
    else if (type == TableViewCellTypeMap) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTableViewCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(self.view.frame) - 30, 170)];
        mapView.userInteractionEnabled = FALSE;
        
        MKCoordinateRegion myRegion;
        myRegion.center.latitude = self.photo.latitude.doubleValue;
        myRegion.center.longitude = self.photo.longitude.doubleValue;
        myRegion.span.latitudeDelta = 0.2;
        myRegion.span.longitudeDelta = 0.2;
        
        [mapView setRegion:myRegion animated:NO];
        
        MapViewAnnotation *annotation = [[MapViewAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(self.photo.latitude.doubleValue, self.photo.longitude.doubleValue)];
        [mapView addAnnotation:annotation];
        
        [cell.contentView addSubview:mapView];
        return cell;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *option = [self.options objectAtIndex:indexPath.row];
    TableViewCellType type = option.integerValue;
    
    switch (type) {
        case TableViewCellTypeDesc:
        {
            UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
            
            CGSize constrainedSize = CGSizeMake(CGRectGetWidth(cell.contentView.frame), 9999);
            NSDictionary *attributesDictionary = @{NSFontAttributeName: cell.textLabel.font};
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:cell.textLabel.text attributes:attributesDictionary];
            
            CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            return MAX(requiredHeight.size.height, 44.0f);
        }
        case TableViewCellTypeUserInfo: {
            return 60.0;
        }
        case TableViewCellTypeMap: {
            return 170.0;
        }
        default:
            return 44.0f;
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

@end
