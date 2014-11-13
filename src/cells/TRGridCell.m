#import "TRGridCell.h"

#import "ELHASO.h"


@interface TRGridCell ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end


@implementation TRGridCell

- (void)configure:(TRPhotoData*)data
{
    DLOG(@"Set cell with %p", data);
}

@end
