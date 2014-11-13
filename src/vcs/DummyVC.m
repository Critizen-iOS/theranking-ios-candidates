#import "DummyVC.h"

#import "TRLogic.h"
#import "ELHASO.h"


@implementation DummyVC

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [TRLogic fetchThumbnailsWithCallback:^(NSError* error){
            DLOG(@"DummyVC reporting! error: %@", error);
        }];
}

@end
