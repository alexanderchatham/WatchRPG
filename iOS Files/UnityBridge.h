#import <Foundation/Foundation.h>
@interface UnityBridge : NSObject
+ (void)sendEventToWatch:(NSString *)eventName;
@end
