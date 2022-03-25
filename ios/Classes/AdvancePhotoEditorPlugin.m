#import "AdvancePhotoEditorPlugin.h"
#if __has_include(<advance_photo_editor/advance_photo_editor-Swift.h>)
#import <advance_photo_editor/advance_photo_editor-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "advance_photo_editor-Swift.h"
#endif

@implementation AdvancePhotoEditorPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAdvancePhotoEditorPlugin registerWithRegistrar:registrar];
}
@end
