//
//  PJWOffsetCornerModel.m
//  TENJigSawCutter
//
//  Created by 444ten on 8/10/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import "PJWOffsetCornerModel.h"
#import "TENMacros.h"
#import "PJWPuzzleParameterModel.h"

@interface PJWOffsetCornerModel ()
@property (nonatomic, strong) PJWPuzzleParameterModel *parameterModel;

@end

@implementation PJWOffsetCornerModel

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)init {
    self = [super init];
    if (self) {
        self.parameterModel = [PJWPuzzleParameterModel sharedInstance];
        [self setup];
    }
    
    return self;
}
#pragma mark -
#pragma mark Private Methods

- (void)setup {
    PJWPuzzleParameterModel *parameterModel = [PJWPuzzleParameterModel sharedInstance];
    
    for (NSInteger row = 0; row <= parameterModel.countHeight; row++) {
        NSMutableArray *rowArray = [NSMutableArray new];
        
        for (NSInteger col = 0; col <= parameterModel.countWidth; col++) {
            [rowArray addObject:NSValueWithPoint([self xOffsetForColumn:col], [self yOffsetForRow:row])];
        }
        
        [self.offsets addObject:rowArray];
    }
}

- (CGFloat)xOffsetForColumn:(NSUInteger)column {
    PJWPuzzleParameterModel *parameterModel = [PJWPuzzleParameterModel sharedInstance];

    CGFloat result;
    
    if (0 == column) {
        result = 0.0;
    } else if (parameterModel.countWidth == column) {
        result = parameterModel.overlapWidth;
    } else {
        result = arc4random_uniform(parameterModel.overlapWidth);
    }
    
    return result;
}

- (CGFloat)yOffsetForRow:(NSUInteger)row {
    PJWPuzzleParameterModel *parameterModel = [PJWPuzzleParameterModel sharedInstance];
    
    CGFloat result;
    
    if (0 == row) {
        result = 0.0;
    } else if (parameterModel.countHeight == row) {
        result = parameterModel.overlapHeight;
    } else {
        result = arc4random_uniform(parameterModel.overlapHeight);
    }
    
    return result;
}

@end
