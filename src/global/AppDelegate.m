#import "AppDelegate.h"

#import "DummyVC.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc]
        initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor redColor];
    self.window.rootViewController = [DummyVC new];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
