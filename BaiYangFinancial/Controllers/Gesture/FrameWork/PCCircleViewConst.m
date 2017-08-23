
#import "PCCircleViewConst.h"

@implementation PCCircleViewConst

+ (void)saveGesture:(NSString *)gesture Key:(NSString *)key {
    [UserDefaults setObject:gesture forKey:key];
    [UserDefaults synchronize];
}

+ (NSString *)getGestureWithKey:(NSString *)key {

    return [UserDefaults objectForKey:key];
}

+ (void)removeLocaGestureWithKey:(NSString *)key {
    if ([UserDefaults objectForKey:key]) {
        [UserDefaults removeObjectForKey:key];
    }
    [UserDefaults synchronize];
}

@end
