#import "TRPhotoDetailVC.h"

@interface TRPhotoDetailVC ()

@end

@implementation TRPhotoDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Photo detail", nil);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
        initWithTitle:NSLocalizedString(@"Close", nil)
        style:UIBarButtonItemStylePlain target:self
        action:@selector(closeDetailVC)];
}

/// The user got tired, bring them back to the thumbnail view.
- (void)closeDetailVC
{
    [self.navigationController dismissViewControllerAnimated:YES
        completion:nil];
}

@end
