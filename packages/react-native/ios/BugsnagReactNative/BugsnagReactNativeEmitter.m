#import "BugsnagReactNativeEmitter.h"
#import "Bugsnag.h"
#import "BugsnagClient.h"

@interface BugsnagStateEvent: NSObject
@property NSString *type;
@property id data;
@end

@interface Bugsnag ()
+ (BugsnagClient *)client;
@end

@interface BugsnagClient ()
- (void)addObserverUsingBlock:(void (^_Nonnull)(BugsnagStateEvent *_Nonnull))event;
@end

@interface BugsnagMetadata ()
- (NSDictionary *)toDictionary;
@end

@implementation BugsnagReactNativeEmitter

RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents {
  return @[@"bugsnag::sync"];
}

- (void)registerForNativeStateChanges {
    [[Bugsnag client] addObserverUsingBlock:^(BugsnagStateEvent *event) {
        NSDictionary *data = [self serializeStateChangeData:event];
        [self sendEventWithName:@"bugsnag::sync" body:data];
    }];
}

- (NSDictionary *)serializeStateChangeData:(BugsnagStateEvent *)event {
    id obj;

    if ([@"ContextUpdate" isEqualToString:event.type]) {
        obj = event.data;
    } else if ([@"UserUpdate" isEqualToString:event.type]) {
        obj = event.data;
    } else if ([@"MetadataUpdate" isEqualToString:event.type]) {
        BugsnagMetadata *metadata = event.data;
        obj = [metadata toDictionary];
    }

    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[@"type"] = event.type;

    if (obj != nil) {
        dict[@"data"] = obj;
    } else {
        dict[@"data"] = [NSNull null];
    }
    return dict;
}

@end
