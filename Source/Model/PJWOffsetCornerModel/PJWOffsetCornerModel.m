//
//  PJWOffsetCornerModel.m
//  TENJigSawCutter
//
//  Created by 444ten on 8/10/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import "PJWOffsetCornerModel.h"
#import "TENMacros.h"

@interface PJWOffsetCornerModel ()
@property (nonatomic, assign)   NSInteger   countWidth;
@property (nonatomic, assign)   NSInteger   countHeight;
@property (nonatomic, assign)   CGFloat     overlapWidth;
@property (nonatomic, assign)   CGFloat     overlapHeight;

@end

@implementation PJWOffsetCornerModel

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)initWithCountWidth:(NSInteger)countWidth
                       countHeight:(NSInteger)countHeight
                      overlapWidth:(CGFloat)overlapWidth
                     overlapHeight:(CGFloat)overlapHeight
{
    self = [super init];
    if (self) {
        self.offsets = [NSMutableArray new];
        
        self.countWidth = countWidth;
        self.countHeight = countHeight;
        self.overlapWidth = overlapWidth;
        self.overlapHeight = overlapHeight;
        
        [self setup];
    }
    
    return self;
}

#pragma mark -
#pragma mark Private Methods

- (void)setup {
    for (NSInteger row = 0; row <= self.countHeight; row++) {
        NSMutableArray *rowArray = [NSMutableArray new];
        
        for (NSInteger col = 0; col <= self.countWidth; col++) {
            [rowArray addObject:NSValueWithPoint([self xOffsetForColumn:col], [self yOffsetForRow:row])];
        }
        
        [self.offsets addObject:rowArray];
    }
}

- (CGFloat)xOffsetForColumn:(NSUInteger)column {
    CGFloat result;
    
    if (0 == column) {
        result = 0.0;
    } else if (self.countWidth == column) {
        result = self.overlapWidth;
    } else {
        result = arc4random_uniform(self.overlapWidth);
    }
    
    return result;
}

- (CGFloat)yOffsetForRow:(NSUInteger)row {
    CGFloat result;
    
    if (0 == row) {
        result = 0.0;
    } else if (self.countHeight == row) {
        result = self.overlapHeight;
    } else {
        result = arc4random_uniform(self.overlapHeight);
    }
    
    return result;
}

@end
