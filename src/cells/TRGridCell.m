#import "TRGridCell.h"

#import "ELHASO.h"
#import "TRPhotoData.h"


@interface TRGridCell ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *ratingLabel;

@end


@implementation TRGridCell

- (void)configure:(TRPhotoData*)data
{
    self.nameLabel.text = NON_NIL_STRING(data.photoName);
    self.ratingLabel.text = data.ratingText;
}

@end
