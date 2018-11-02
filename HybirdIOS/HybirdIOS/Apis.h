//
//  Apis.h
//  HybirdIOS
//
//  Created by pillar on 2018/10/30.
//  Copyright © 2018 pillar. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Apis : NSObject

@property NSString * testA;

+(void)statusBarStyle:(NSString *)msg;
+(void)statusBarHidden:(BOOL)isHidden;

@end

NS_ASSUME_NONNULL_END
