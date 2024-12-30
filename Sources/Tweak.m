#import <Cask3-Swift.h>

__attribute__((constructor)) static void init() {
    cask_init();
}
