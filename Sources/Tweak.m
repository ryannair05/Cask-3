#import <Orion/Orion.h>

__attribute__((constructor)) static void init() {
    if ([[[[NSProcessInfo processInfo] arguments] objectAtIndex:0] containsString:@"/Application"]) {
        orion_init();
    }
}
