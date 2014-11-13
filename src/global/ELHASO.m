#import "ELHASO.h"

#import <Foundation/Foundation.h>

#import <assert.h>
#import <objc/runtime.h>
#import <objc/message.h>


/** Conditional wrapper around dispatch_async_ui()
 * Sometimes you are writting code which can run in both the UI and a
 * background thread. To avoid tiresome ifs, you can run this function and pass
 * a block. If you are running on the main thread, the block will run
 * immediately, otherwise it will be queued on the main thread to run in the
 * near future.
 */
void run_on_ui(dispatch_block_t block)
{
	if ([NSThread isMainThread])
		block();
	else
		dispatch_async_ui(block);
}

/** Modified blocking version of run_on_ui().
 * This is nearly identical to run_on_ui(), the difference being that if you
 * are not running on the main thread, your code will wait for the ui thread
 * with dispatch_sync() to do what you are specifying in the block.
 *
 * Consider this a version where you want to make sure something is done on the
 * UI rather than asking the UI to do something but not caring exactly when.
 */
void wait_for_ui(dispatch_block_t block)
{
	if ([NSThread isMainThread])
		block();
	else
		dispatch_sync(dispatch_get_main_queue(), block);
}

// vim:tabstop=4 shiftwidth=4 syntax=objc
