//
//  PJWConstants.h
//  TENJigSawCutter
//
//  Created by 444ten on 8/24/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import <UIKit/UIKit.h>

//static NSString * const kImageName = @"04.jpg";
//static NSString * const kImageName = @"200x200";
static NSString * const kImageName = @"900x700.jpg";

static const CGFloat kPJWDoubleGhostInsetSmall  =  20.0;
static const CGFloat kPJWDoubleGhostInsetBig    = 200.0;

@interface PJWConstants : NSObject

+ (NSDictionary *)presetCutterType;

@end
