//
//  Apis.m
//  HybirdIOS
//
//  Created by pillar on 2018/10/30.
//  Copyright © 2018 pillar. All rights reserved.
//

#import "Apis.h"

@implementation Apis

+(void)statusBarStyle:(NSString *)msg {
    if ([msg isEqualToString:@"light"]) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    } else if ([msg isEqualToString:@"dark"]){
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}

+(void)statusBarHidden:(BOOL)isHidden {
    [UIApplication sharedApplication].statusBarHidden = isHidden;
}

@end
