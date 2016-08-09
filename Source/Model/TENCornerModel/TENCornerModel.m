//
//  TENCornerModel.m
//  TENJigSawCutter
//
//  Created by 444ten on 8/8/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import "TENCornerModel.h"

#import "TENMacros.h"

@interface TENCornerModel ()

@end

@implementation TENCornerModel

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cornerPoints = [NSMutableArray new];
    }
    return self;
}

#pragma mark -
#pragma mark Public Methods

- (void)setup {
    CGFloat sliceWidth = self.fullWidth / self.countWidth;
    CGFloat sliceHeight = self.fullHeight / self.countHeight;
    
    for (NSInteger row = 0; row <= self.countHeight; row++) {
        NSMutableArray *rowArray = [NSMutableArray new];

        for (NSInteger col = 0; col <= self.countWidth; col++) {
            CGFloat x = col * sliceWidth;
            CGFloat y = row * sliceHeight;
            [rowArray addObject:NSValueWithPoint(x, y)];
        }
        
        [self.cornerPoints addObject:rowArray];
    }
}

@end
