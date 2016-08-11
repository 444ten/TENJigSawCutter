//
//  PJWOffsetSideModel.m
//  TENJigSawCutter
//
//  Created by 444ten on 8/11/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import "PJWOffsetSideModel.h"
#import "PJWPuzzleParameterModel.h"
#import "TENMacros.h"

static const CGFloat kArcHeightMaxRatio     = 0.3;
static const CGFloat kArcWidthMinRatio      = 0.3;
static const CGFloat kArcWidthDeltaRatio    = 0.5;

static const CGFloat kCurlRatio  = 0.3;


@implementation PJWOffsetSideModel

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupHeightSides];
        [self setupWidthSides];
    }
    
    return self;
}

#pragma mark -
#pragma mark Private Methods

- (void)setupHeightSides {
    PJWPuzzleParameterModel *parameterModel = [PJWPuzzleParameterModel sharedInstance];
    NSMutableArray *heightSides = [NSMutableArray new];
    
    for (NSInteger row = 0; row < parameterModel.countHeight; row++) {
        NSMutableArray *rowArray = [NSMutableArray new];
        
        [rowArray addObject:@[]]; //leftmost
        
        for (NSInteger col = 1; col < parameterModel.countWidth; col++) {
            [rowArray addObject:[self pointsOfHeightSide]];
        }
        
        [rowArray addObject:@[]]; //rightmost
        
        [heightSides addObject:rowArray];
    }
    
    self.heightSides = heightSides;
}

- (NSArray *)pointsOfHeightSide {
    PJWPuzzleParameterModel *parameterModel = [PJWPuzzleParameterModel sharedInstance];

    CGFloat baseHeight = parameterModel.baseHeight;
    CGFloat overlapHeight = parameterModel.overlapHeight;
    
    CGFloat centerHeight = baseHeight / 2 + overlapHeight;
    
    CGFloat arcHeightMax    = overlapHeight * kArcHeightMaxRatio;
    CGFloat arcWidthMin     = overlapHeight * kArcWidthMinRatio;
    CGFloat arcWidthDelta   = overlapHeight * kArcWidthDeltaRatio;
    CGFloat curl            = overlapHeight * kCurlRatio;

    NSMutableArray *result = [NSMutableArray new];
    CGFloat x = 0.0;
    CGFloat y = 0.0;
    
//inArc end
    x = arc4random_uniform(arcHeightMax);
    y = centerHeight - (arcWidthMin + arc4random_uniform(arcWidthDelta));
    [result addObject:NSValueWithPoint(x, y)];

//hole start
    x += curl;
    [result addObject:NSValueWithPoint(x, y)];

//hole end
    x = arc4random_uniform(arcHeightMax) + curl;
    y = centerHeight + (arcWidthMin + arc4random_uniform(arcWidthDelta));
    [result addObject:NSValueWithPoint(x, y)];
    
//outArc start
    x -= curl;
    [result addObject:NSValueWithPoint(x, y)];

    return result;
}


- (void)setupWidthSides {
    
}

@end























