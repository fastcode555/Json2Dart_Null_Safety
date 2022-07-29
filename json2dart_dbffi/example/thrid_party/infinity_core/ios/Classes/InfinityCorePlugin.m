#import "InfinityCorePlugin.h"
#if __has_include(<infinity_core/infinity_core-Swift.h>)
#import <infinity_core/infinity_core-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "infinity_core-Swift.h"
#endif

@implementation InfinityCorePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftInfinityCorePlugin registerWithRegistrar:registrar];
}
@end
