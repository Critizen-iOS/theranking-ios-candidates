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

@interface PXPhotoDetailTableViewController ()

@property (nonatomic, strong) NSMutableArray *sectionTitles;

@end

@implementation PXPhotoDetailTableViewController

static NSString * const reuseIdentifier = @"PXDetailCellIdentifier";
static NSString * const nameSectionTitle = @"Name";
static NSString * const descriptionSectionTitle = @"Description";
static NSString * const authorSectionTitle = @"Author";
static NSString * const cameraSectionTitle = @"Camera";
static NSString * const mapSectionTitle = @"Map";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Register cell
    UINib *cellNib = [UINib nibWithNibName:@"PXPhotoDetailTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:reuseIdentifier];
    
    // Configure table view
    self.title = @"Detail";
    self.tableView.separatorColor = [UIColor clearColor];
    
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
        [self.sectionTitles addObject:nameSectionTitle];
    }
    
    // Check if the photo has a description
    if (self.photo.photoDescription != nil && ![self.photo.photoDescription isEqualToString:@""])
    {
        sections++;
        [self.sectionTitles addObject:descriptionSectionTitle];
    }
    
    // Check if the photo has a author
    if (self.photo.author != nil)
    {
        sections++;
        [self.sectionTitles addObject:authorSectionTitle];
    }
    
    // Check if the photo has a camera info
    if (self.photo.camera != nil && ![self.photo.camera isEqualToString:@""])
    {
        sections++;
        [self.sectionTitles addObject:cameraSectionTitle];
    }
    
    // Check if the photo has coordinates
    if (self.photo.coordinate.latitude != 0.0 && self.photo.coordinate.longitude != 0.0)
    {
        sections++;
        [self.sectionTitles addObject:mapSectionTitle];
    }
    
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sectionTitles objectAtIndex:section];
}

@end
