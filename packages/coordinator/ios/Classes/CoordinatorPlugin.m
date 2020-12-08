#import "CoordinatorPlugin.h"
#if __has_include(<coordinator/coordinator-Swift.h>)
#import <coordinator/coordinator-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "coordinator-Swift.h"
#endif

@implementation CoordinatorPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCoordinatorPlugin registerWithRegistrar:registrar];
}
@end
