#import "TRGridVC.h"

#import "TRLogic.h"
#import "ELHASO.h"


@implementation TRGridVC

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [TRLogic fetchThumbnailsWithCallback:^(NSError* error){
            DLOG(@"DummyVC reporting! error: %@", error);
        }];
}

@end
