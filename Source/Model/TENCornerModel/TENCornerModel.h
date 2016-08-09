//
//  TENCornerModel.h
//  TENJigSawCutter
//
//  Created by 444ten on 8/8/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#define NSValueWithPoint(x, y)  [NSValue valueWithCGPoint:CGPointMake(x, y)]
#define CGPointFromValue(value) [value CGPointValue]

#import <UIKit/UIKit.h>

@interface TENCornerModel : NSObject
@property (nonatomic, assign)   CGFloat fullWidth;
@property (nonatomic, assign)   CGFloat fullHeight;
@property (nonatomic, assign)   NSInteger countWidth;
@property (nonatomic, assign)   NSInteger countHeight;

@property (nonatomic, strong)   NSMutableArray *cornerPoints;

- (void)setup;

@end
