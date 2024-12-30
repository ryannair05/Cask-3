#import <UIKit/UIImage.h>

#if __cplusplus
extern "C" {
#endif

    _Nonnull CFSetRef SBSCopyDisplayIdentifiers();
    NSString* _Nullable SBSCopyLocalizedApplicationNameForDisplayIdentifier(NSString* _Nullable identifier);

#if __cplusplus
}
#endif

@interface UIImage (Private)
+ (void)_loadImageFromURL:(NSURL *)arg1 completionHandler:(void (^)(UIImage *))arg2 API_AVAILABLE(ios(15));
@end