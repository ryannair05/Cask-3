#import <UIKit/UIKit.h>

@interface UIScrollView (Private)
- (void)_scrollViewWillBeginDragging;
@end

@interface UITableView (Private)
- (UITableViewCell *)_createPreparedCellForGlobalRow:(NSInteger)row withIndexPath:(id)indexPath willDisplay:(bool)willDisplay;
@end

