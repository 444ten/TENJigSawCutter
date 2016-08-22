//
//  TENMacros.h
//  TENJigSawCutter
//
//  Created by 444ten on 8/9/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#define NSValueWithPoint(x, y)  [NSValue valueWithCGPoint:CGPointMake(x, y)]
#define CGPointFromValue(value) [value CGPointValue]
#define TENHeadOrTile           arc4random_uniform(2)


#import <Foundation/Foundation.h>

@interface TENMacros : NSObject

@end
