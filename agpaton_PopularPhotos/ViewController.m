//
//  ViewController.m
//  agpaton_PopularPhotos
//
//  Created by Alejandro González Patón on 31/10/14.
//  Copyright (c) 2014 Alejandro González Patón. All rights reserved.
//

#import "ViewController.h"
#import "Services.h"
#import "ImageTools.h"

#import "PhotoViewCell.h"

#import "DetailViewController.h"

#import "AppDelegate.h"

@interface ViewController ()  <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) UITableView *tblView;
@property (nonatomic, retain, readonly) NSManagedObjectContext *mainMOC;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) BOOL fetchingData;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@end

@implementation ViewController

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.tblView setBackgroundColor:[UIColor whiteColor]];
    
    _mainMOC = [self appDelegate].managedObjectContext;
    
    self.currentPage = 1;
    self.fetchingData = NO;
    
    [self getPhotosWithPage:[NSNumber numberWithInteger:self.currentPage]];
    
    [self configureFooter];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

- (UITableView *)tblView
{
    if (!_tblView) {
        _tblView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tblView.delegate = self;
        _tblView.dataSource = self;
        _tblView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_tblView registerNib:[UINib nibWithNibName:@"PhotoViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
        
        [self.view addSubview:_tblView];
    }
    
    return _tblView;
}

- (void)configureFooter
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.frame = CGRectMake(CGRectGetWidth(self.view.bounds)/2 - 10, 4, 20, 20);
    spinner.transform = CGAffineTransformMakeScale(1, 1);
    [spinner setColor:[UIColor darkGrayColor]];
    
    self.spinner = spinner;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.bounds), 40)];
    [footerView addSubview:self.spinner];
    
    self.tblView.tableFooterView = footerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self fetchedResultsController] fetchedObjects] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return self.tblView.frame.size.width*0.9;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Try to reuse a cell
    static NSString *CellIdentifier = @"Cell";
    PhotoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.tag = indexPath.row;
    
    cell.name = photo.photo_name;
    cell.rating = photo.photo_rating;
    cell.imageId = photo.photo_id;
    cell.imageUrl = photo.photo_imageUrl;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if (photo) {
        DetailViewController *vc = [[DetailViewController alloc] init];
        
        vc.photo = photo;
    
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    // Get New Publications
    BOOL IsScrollAtBottom = ((y >= h) && h > 0);
    
    if(IsScrollAtBottom && [[self.fetchedResultsController fetchedObjects] count]!=0)
    {
        [self getPhotosWithPage:[NSNumber numberWithInteger:self.currentPage]];
    }
}

- (void)getPhotosWithPage:(NSNumber *)page
{
    if (self.fetchingData) {
        return;
    }
    
    self.fetchingData = YES;
    [self.spinner startAnimating];
    
    [Services GetMostPopularPhotosWithPage:page completion:^(BOOL success) {
        
        self.currentPage++;
        self.fetchingData = NO;
        
        [self.spinner stopAnimating];
    }];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }
    
    [NSFetchedResultsController deleteCacheWithName:@"PhotoCache"];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Photo" inManagedObjectContext: self.mainMOC];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"photo_rating" ascending:NO];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sort, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext: _mainMOC sectionNameKeyPath:nil cacheName:@"PhotoCache"];
    _fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![_fetchedResultsController performFetch:&error])
    {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        //NSLog(@"<fetchedResultsController> Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [_tblView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [_tblView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        case NSFetchedResultsChangeDelete:
            [_tblView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
        {
            [_tblView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation: UITableViewRowAnimationTop];
        }
            break;
            
        case NSFetchedResultsChangeDelete:
            [_tblView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation: UITableViewRowAnimationLeft];
            break;
            
        case NSFetchedResultsChangeUpdate:
            
        {
            [self tableView:_tblView cellForRowAtIndexPath:indexPath];
            [_tblView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
            break;
            
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [_tblView endUpdates];
}

@end
