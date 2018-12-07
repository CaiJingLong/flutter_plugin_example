#import "BattlePowerPlugin.h"
#import <Foundation/NSTimer.h>

@implementation BattlePowerPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"battle_power"
                                     binaryMessenger:[registrar messenger]];
    BattlePowerPlugin* instance = [[BattlePowerPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    
    [self registerPostTimerWithRegistrar:registrar];
}

+(void) registerPostTimerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar{
    FlutterBasicMessageChannel *channel = [FlutterBasicMessageChannel messageChannelWithName:@"run_time" binaryMessenger:[registrar messenger]];
    
    long start = [self getNow];
    
    [NSTimer scheduledTimerWithTimeInterval:5 repeats:true block:^(NSTimer * _Nonnull timer) {
        long run = [self getNow] - start;
        [channel sendMessage:[NSNumber numberWithLong:run]];
        
        if (run > 100){
            [timer invalidate];
        }
    }];
}

+(long)getNow{
    NSDate *date = [NSDate date];
    long timeStamp = [date timeIntervalSince1970];
    return timeStamp;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } if([@"add" isEqualToString:call.method]){
        NSDictionary *args = call.arguments;
        int x = [[args valueForKey:@"x"] intValue];
        int y = [[args valueForKey:@"y"] intValue];
        NSNumber *sum = [NSNumber numberWithLong:(x+y)];
        result(sum);
    }else {
        result(FlutterMethodNotImplemented);
    }
}

@end
