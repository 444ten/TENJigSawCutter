//
//  PJWOffsetCornerModel.h
//  TENJigSawCutter
//
//  Created by 444ten on 8/10/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PJWOffsetCornerModel : NSObject
@property (nonatomic, strong)   NSMutableArray  *offsets;

- (instancetype)initWithCountWidth:(NSInteger)countWidth
                       countHeight:(NSInteger)countHeight
                      overlapWidth:(CGFloat)overlapWidth
                     overlapHeight:(CGFloat)overlapHeight;
@end
