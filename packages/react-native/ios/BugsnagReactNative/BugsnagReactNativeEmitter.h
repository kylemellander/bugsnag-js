#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface BugsnagReactNativeEmitter : RCTEventEmitter <RCTBridgeModule>
- (void)registerForNativeStateChanges;
@end
