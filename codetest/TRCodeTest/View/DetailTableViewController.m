//
//  DetailTableViewController.m
//  TRCodeTest
//
//  Created by Oscar on 18/10/14.
//  Copyright (c) 2014 Skyweb Production. All rights reserved.
//

#import "DetailTableViewController.h"
#import "DetailTableViewCell.h"
#import "DetailTableViewCellBase.h"
#import "TR500PxPhoto.h"
#import "DetailSection.h"
#import "DetailSectionItem.h"

@interface DetailTableViewController ()

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSMutableArray *sections;

@end

@implementation DetailTableViewController

static NSString *cellIdentifier = @"cellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Initial setup

- (void)setUp {
    
    self.title = _photo.name;
    
    // Register cell classes
    UINib *tableViewCellNib = [UINib nibWithNibName:NSStringFromClass([DetailTableViewCell class]) bundle:nil];
    UINib *tableViewCellNibBase = [UINib nibWithNibName:NSStringFromClass([DetailTableViewCellBase class]) bundle:nil];
    
    [self.tableView registerNib:tableViewCellNib forCellReuseIdentifier:NSStringFromClass([DetailTableViewCell class])];
    [self.tableView registerNib:tableViewCellNibBase forCellReuseIdentifier:NSStringFromClass([DetailTableViewCellBase class])];
    
    if (_photo.hasLocation) {
        // Add pin
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = _photo.location;
        annotation.title = _photo.name;
        
        [_mapView addAnnotation:annotation];
        [_mapView setCenterCoordinate:_photo.location animated:YES];
    } else {
        _mapView.frame = CGRectZero;
    }
    
    if (!_sections) {
        _sections = [NSMutableArray array];
    }
    
    // Picture Info
    DetailSectionItem *pictureName = [[DetailSectionItem alloc] initWithTitle:NSLocalizedString(@"_PICTURE_NAME", nil)
                                                                     subtitle:_photo.name];
    DetailSectionItem *pictureDescription = [[DetailSectionItem alloc] initWithTitle:NSLocalizedString(@"_PICTURE_DESCRIPTION", nil)
                                                                            subtitle:_photo.summary];
    
    DetailSection *pictureInfo = [[DetailSection alloc] initWithName:NSLocalizedString(@"_SECTION_PICTURE", nil)
                                                               items:@[pictureName, pictureDescription]];
    [_sections addObject:pictureInfo];
    
    // User info
    DetailSectionItem *user = [[DetailSectionItem alloc] initWithTitle:_photo.user.name
                                                              subtitle:nil
                                                                 image:_photo.user.userPicture];
    DetailSection *userInfo = [[DetailSection alloc] initWithName:NSLocalizedString(@"_SECTION_USER", nil)
                                                            items:@[user]];
    [_sections addObject:userInfo];
    
    // Camera info
    
    if (_photo.camera) {
        DetailSectionItem *camera = [[DetailSectionItem alloc] initWithTitle:NSLocalizedString(@"_CAMERA_NAME", nil)
                                                                    subtitle:_photo.camera];
        
        DetailSection *cameraSection = [[DetailSection alloc] initWithName:NSLocalizedString(@"_SECTION_CAMERA", nil)
                                                                     items:@[camera]];
        [_sections addObject:cameraSection];
    }
    
    // Reload table
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DetailSection *detailSection = _sections[section];
    return detailSection.items.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    DetailSection *detailSection = _sections[section];
    return detailSection.name;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailSection *detailSection = _sections[indexPath.section];
    DetailSectionItem *item = detailSection.items[indexPath.row];
    
    return (item.isUser ? 75 : 50);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailSection *detailSection = _sections[indexPath.section];
    DetailSectionItem *item = detailSection.items[indexPath.row];
    
    UITableViewCell *cell;
    
    if (item.isUser) {
        cell = (DetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DetailTableViewCell class]) forIndexPath:indexPath];
        [(DetailTableViewCell *)cell drawCellWithItem:item];
    } else {
        cell = (DetailTableViewCellBase *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DetailTableViewCellBase class]) forIndexPath:indexPath];
        
        cell.textLabel.text = item.title;
        cell.detailTextLabel.text = item.subtitle;
    }
 
    return cell;
}

@end
