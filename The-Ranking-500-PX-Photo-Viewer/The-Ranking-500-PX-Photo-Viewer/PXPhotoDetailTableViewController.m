//
//  PXPhotoDetailTableViewController.m
//  The-Ranking-500-PX-Photo-Viewer
//
//  Created by Ernesto Pino on 2/3/15.
//  Copyright (c) 2015 Ernesto Pino. All rights reserved.
//

#import "PXPhotoDetailTableViewController.h"
#import "PXPhoto.h"
#import "UIImageView+AFNetworking.h"
#import "PXNameTableViewCell.h"
#import "PXDescriptionTableViewCell.h"
#import "PXAuthorTableViewCell.h"
#import "PXCameraTableViewCell.h"
#import "PXMapTableViewCell.h"
#import "PXAuthor.h"
#import <MapKit/MapKit.h>

@interface PXPhotoDetailTableViewController ()

@property (nonatomic, strong) NSMutableArray *sectionTitles;

@end

@implementation PXPhotoDetailTableViewController

static NSString * const nameCellReuseIdentifier = @"PXNameCellIdentifier";
static NSString * const descriptionCellReuseIdentifier = @"PXDescriptionCellIdentifier";
static NSString * const authorCellReuseIdentifier = @"PXAuthorCellIdentifier";
static NSString * const cameraCellReuseIdentifier = @"PXCameraCellIdentifier";
static NSString * const mapCellReuseIdentifier = @"PXMapCellIdentifier";

#define kNameSectionTitle           @"Name"
#define kDescriptionSectionTitle    @"Description"
#define kAuthorSectionTitle         @"Author"
#define kCameraSectionTitle         @"Camera"
#define kMapSectionTitle            @"Map"

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Obtain the cell's nibs
    UINib *nameCellNib = [UINib nibWithNibName:@"PXNameTableViewCell" bundle:nil];
    UINib *descriptionCellNib = [UINib nibWithNibName:@"PXDescriptionTableViewCell" bundle:nil];
    UINib *authorCellNib = [UINib nibWithNibName:@"PXAuthorTableViewCell" bundle:nil];
    UINib *cameraCellNib = [UINib nibWithNibName:@"PXCameraTableViewCell" bundle:nil];
    UINib *mapCellNib = [UINib nibWithNibName:@"PXMapTableViewCell" bundle:nil];
    
    // Register cells
    [self.tableView registerNib:nameCellNib forCellReuseIdentifier:nameCellReuseIdentifier];
    [self.tableView registerNib:descriptionCellNib forCellReuseIdentifier:descriptionCellReuseIdentifier];
    [self.tableView registerNib:authorCellNib forCellReuseIdentifier:authorCellReuseIdentifier];
    [self.tableView registerNib:cameraCellNib forCellReuseIdentifier:cameraCellReuseIdentifier];
    [self.tableView registerNib:mapCellNib forCellReuseIdentifier:mapCellReuseIdentifier];
    
    // Configure table view
    self.title = @"Detail";
    //self.tableView.separatorColor = [UIColor clearColor];
    
    // Configure data
    self.sectionTitles = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPhoto:(PXPhoto *)photo
{
    _photo = photo;
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 200)];
    headerImageView.contentMode = UIViewContentModeScaleToFill;
    __weak UIImageView *weakHeaderImageView = headerImageView;
    
    [headerImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.photo.imageURL]]
                               placeholderImage:nil
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                            
                                            weakHeaderImageView.image = image;
                                            
                                            // Animation effect
                                            
                                            [weakHeaderImageView setAlpha:0.0];
                                            [UIView beginAnimations:nil context:NULL];
                                            [UIView setAnimationDuration:0.3];
                                            [weakHeaderImageView setAlpha:1.0];
                                            [UIView commitAnimations];
                                            
                                        }
                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                            
                                            NSLog(@"Error trying to load image asynchronously...");
                                            
                                        }];
    
    self.tableView.tableHeaderView = headerImageView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    
    int sections = 0;
    
    // Check if the photo has a name
    if (self.photo.name != nil && ![self.photo.name isEqualToString:@""])
    {
        sections++;
        [self.sectionTitles addObject:kNameSectionTitle];
    }
    
    // Check if the photo has a description
    if (self.photo.photoDescription != nil && ![self.photo.photoDescription isEqualToString:@""])
    {
        sections++;
        [self.sectionTitles addObject:kDescriptionSectionTitle];
    }
    
    // Check if the photo has a author
    if (self.photo.author != nil)
    {
        sections++;
        [self.sectionTitles addObject:kAuthorSectionTitle];
    }
    
    // Check if the photo has a camera info
    if (self.photo.camera != nil && ![self.photo.camera isEqualToString:@""])
    {
        sections++;
        [self.sectionTitles addObject:kCameraSectionTitle];
    }
    
    // Check if the photo has coordinates
    if (self.photo.coordinate.latitude != 0.0 && self.photo.coordinate.longitude != 0.0)
    {
        sections++;
        [self.sectionTitles addObject:kMapSectionTitle];
    }
    
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    NSString *sectionTitle = [self.sectionTitles objectAtIndex:section];
    
    if ([sectionTitle isEqualToString:kCameraSectionTitle]) return 6;
    else return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionTitle = [self.sectionTitles objectAtIndex:indexPath.section];
    
    if ([sectionTitle isEqualToString:kNameSectionTitle]) return 44.0;
    else if ([sectionTitle isEqualToString:kDescriptionSectionTitle]) return 120.0;
    else if ([sectionTitle isEqualToString:kAuthorSectionTitle]) return 80.0;
    else if ([sectionTitle isEqualToString:kMapSectionTitle]) return 150.0;
    else return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Initialize the cell
    UITableViewCell *cell = nil;
    
    // Obtain section title
    NSString *sectionTitle = [self.sectionTitles objectAtIndex:indexPath.section];
    
    // Verify current section
    if ([sectionTitle isEqualToString:kNameSectionTitle])
    {
        PXNameTableViewCell *nameCell = (PXNameTableViewCell *) [tableView dequeueReusableCellWithIdentifier:nameCellReuseIdentifier];
        nameCell.textLabel.text = self.photo.name;
        cell = nameCell;
    }
    else if ([sectionTitle isEqualToString:kDescriptionSectionTitle])
    {
        PXDescriptionTableViewCell *descriptionCell = (PXDescriptionTableViewCell *) [tableView dequeueReusableCellWithIdentifier:descriptionCellReuseIdentifier];
        descriptionCell.descriptionTextView.text = self.photo.photoDescription;
        cell = descriptionCell;
    }
    else if ([sectionTitle isEqualToString:kAuthorSectionTitle])
    {
        PXAuthorTableViewCell *authorCell = (PXAuthorTableViewCell *) [tableView dequeueReusableCellWithIdentifier:authorCellReuseIdentifier];
        
        authorCell.pictureImageView.contentMode = UIViewContentModeScaleToFill;
        __weak UIImageView *weakAuthorImageView = authorCell.pictureImageView;
        
        [authorCell.pictureImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.photo.author.pictureURL]]
                               placeholderImage:nil
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                            weakAuthorImageView.image = image;
                                        }
                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                            
                                            NSLog(@"Error trying to load image asynchronously...");
                                            
                                        }];
        
        authorCell.fullnameLabel.text = self.photo.author.fullname;
        cell = authorCell;
    }
    else if ([sectionTitle isEqualToString:kMapSectionTitle])
    {
        PXMapTableViewCell *mapCell = (PXMapTableViewCell *) [tableView dequeueReusableCellWithIdentifier:mapCellReuseIdentifier];
        
        /*
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.photo.coordinate, 100, 100);
        [mapCell.mapView setRegion:[mapCell.mapView regionThatFits:region] animated:YES];
        */
        
        MKCoordinateRegion region;
        region.center.latitude = self.photo.coordinate.latitude;
        region.center.longitude = self.photo.coordinate.longitude;
        region.span.latitudeDelta = 1;
        region.span.longitudeDelta = 1;
        region = [mapCell.mapView regionThatFits:region];
        [mapCell.mapView setRegion:region animated:TRUE];
        
        // Add an annotation
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = self.photo.coordinate;
        
        [mapCell.mapView addAnnotation:point];
        
        cell = mapCell;
    }
    else    // Camera section
    {
        PXCameraTableViewCell *cameraCell = (PXCameraTableViewCell *) [tableView dequeueReusableCellWithIdentifier:cameraCellReuseIdentifier];
        
        if (indexPath.row == 0) // Camera
        {
            cameraCell.textLabel.text = @"Camera";
        
            if (self.photo.camera != nil && ![self.photo.camera isEqualToString:@""])
                cameraCell.detailTextLabel.text = self.photo.camera;
            else
                cameraCell.detailTextLabel.text = @"-";
        }
        else if (indexPath.row == 1)    // Lens
        {
            cameraCell.textLabel.text = @"Lens";
            
            if (self.photo.lens != nil && ![self.photo.lens isEqualToString:@""])
                cameraCell.detailTextLabel.text = self.photo.lens;
            else
                cameraCell.detailTextLabel.text = @"-";
        }
        else if (indexPath.row == 2)    // Focal Length
        {
            cameraCell.textLabel.text = @"Focal length";
            
            if (self.photo.focalLength != nil && ![self.photo.focalLength isEqualToString:@""])
                cameraCell.detailTextLabel.text = self.photo.focalLength;
            else
                cameraCell.detailTextLabel.text = @"-";
        }
        else if (indexPath.row == 3)    // Iso
        {
            cameraCell.textLabel.text = @"Iso";
            
            if (self.photo.iso != nil && ![self.photo.iso isEqualToString:@""])
                cameraCell.detailTextLabel.text = self.photo.iso;
            else
                cameraCell.detailTextLabel.text = @"-";
        }
        else if (indexPath.row == 4)    // Shutter speed
        {
            cameraCell.textLabel.text = @"Shutter speed";
            
            if (self.photo.shutterSpeed != nil && ![self.photo.shutterSpeed isEqualToString:@""])
                cameraCell.detailTextLabel.text = self.photo.shutterSpeed;
            else
                cameraCell.detailTextLabel.text = @"-";
        }
        else if (indexPath.row == 5)    // Aperture
        {
            cameraCell.textLabel.text = @"Aperture";
            
            if (self.photo.aperture != nil && ![self.photo.aperture isEqualToString:@""])
                cameraCell.detailTextLabel.text = self.photo.aperture;
            else
                cameraCell.detailTextLabel.text = @"-";
        }
        
        cell = cameraCell;
    }
    
    // Return the cell
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sectionTitles objectAtIndex:section];
}

@end
