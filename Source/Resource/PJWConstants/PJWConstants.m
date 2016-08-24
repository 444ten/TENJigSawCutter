//
//  PJWConstants.m
//  TENJigSawCutter
//
//  Created by 444ten on 8/24/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import "PJWConstants.h"

@implementation PJWConstants

+ (NSDictionary *)presetCutterType {
    return @{@(0) : @[@(2), @(2)],
             @(1) : @[@(3), @(2)],
             @(2) : @[@(4), @(3)],
             @(3) : @[@(5), @(4)],
             @(4) : @[@(6), @(5)],
             @(5) : @[@(8), @(6)],
             @(6) : @[@(9), @(7)],
             @(7) : @[@(10), @(8)],
             @(8) : @[@(12), @(9)],
             @(9) : @[@(15), @(11)],
             @(10) : @[@(16), @(12)],
             @(11) : @[@(18), @(14)],
             @(12) : @[@(20), @(15)]
             };
}



@end
