#import <Foundation/Foundation.h>

#if __cplusplus
extern "C" {
#endif

    _Nonnull CFSetRef SBSCopyDisplayIdentifiers();
    NSString* _Nullable SBSCopyLocalizedApplicationNameForDisplayIdentifier(NSString* _Nullable identifier);

#if __cplusplus
}
#endif