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

static const CGFloat kArcHeightMaxRatio     = 0.5;
static const CGFloat kCurlRatio             = 0.5;

static const CGFloat kArcWidthMinRatio      = 0.3;
static const CGFloat kArcWidthDeltaRatio    = 0.5;

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

    CGFloat sideHeight = parameterModel.overlapWidth;

    CGFloat sideBaseWidth = parameterModel.baseHeight;
    CGFloat sideOverlapWidth = parameterModel.overlapHeight;
    
    CGFloat sideCenterWidth = sideBaseWidth / 2 + sideOverlapWidth;
    
//    CGFloat arcHeightMax    = sideHeight * kArcHeightMaxRatio;
//    CGFloat curlHeight      = sideHeight * kCurlRatio;
//    
    CGFloat arcWidthMin     = sideOverlapWidth * kArcWidthMinRatio;
//    CGFloat arcWidthDelta   = sideOverlapWidth * kArcWidthDeltaRatio;

    NSMutableArray *result = [NSMutableArray new];
    
    CGFloat x = 0.0;
    CGFloat y = 0.0;

//simple side
    x = arc4random_uniform(sideHeight);
    y = sideCenterWidth - arcWidthMin +  (2 * arc4random_uniform(arcWidthMin));
    [result addObject:NSValueWithPoint(x, y)];

/*

//inArc end
    x = arc4random_uniform(arcHeightMax);
    y = sideCenterWidth - (arcWidthMin + arc4random_uniform(arcWidthDelta));
    [result addObject:NSValueWithPoint(x, y)];

//hole start
    x += curlHeight;
    [result addObject:NSValueWithPoint(x, y)];

//hole end
    x = arc4random_uniform(arcHeightMax) + curlHeight;
    y = sideCenterWidth + (arcWidthMin + arc4random_uniform(arcWidthDelta));
    [result addObject:NSValueWithPoint(x, y)];
    
//outArc start
    x -= curlHeight;
    [result addObject:NSValueWithPoint(x, y)];
*/
    
//revert random
    if (arc4random_uniform(2) == 1) {
        for (NSInteger index = 0; index < result.count; index++) {
            CGPoint point = CGPointFromValue(result[index]);
            
            result[index] = NSValueWithPoint(sideHeight - point.x, point.y);
        }
    }
    
    return result;
}


- (void)setupWidthSides {
    PJWPuzzleParameterModel *parameterModel = [PJWPuzzleParameterModel sharedInstance];
    NSMutableArray *widthSides = [NSMutableArray new];
    
    for (NSInteger row = 0; row <= parameterModel.countHeight; row++) {
        NSMutableArray *rowArray = [NSMutableArray new];
        
        for (NSInteger col = 0; col < parameterModel.countWidth; col++) {
            if (0 == row || parameterModel.countWidth == row) {
                [rowArray addObject:@[]];
            } else {
                [rowArray addObject:[self pointsOfWidthSide]];
            }
        }
        
        [widthSides addObject:rowArray];
    }
    
    self.widthSides = widthSides;
    
}

- (NSArray *)pointsOfWidthSide {
    PJWPuzzleParameterModel *parameterModel = [PJWPuzzleParameterModel sharedInstance];
    
    CGFloat sideHeight = parameterModel.overlapHeight;
    
    CGFloat sideBaseWidth = parameterModel.baseWidth;
    CGFloat sideOverlapWidth = parameterModel.overlapWidth;
    
    CGFloat sideCenterWidth = sideBaseWidth / 2 + sideOverlapWidth;
    
//    CGFloat arcHeightMax    = sideHeight * kArcHeightMaxRatio;
//    CGFloat curlHeight      = sideHeight * kCurlRatio;
    
    CGFloat arcWidthMin     = sideOverlapWidth * kArcWidthMinRatio;
//    CGFloat arcWidthDelta   = sideOverlapWidth * kArcWidthDeltaRatio;
    
    NSMutableArray *result = [NSMutableArray new];
    
    CGFloat x = 0.0;
    CGFloat y = 0.0;

    
//simple side
    x = sideCenterWidth - arcWidthMin +  (2 * arc4random_uniform(arcWidthMin));
    y = arc4random_uniform(sideHeight);
    [result addObject:NSValueWithPoint(x, y)];

    
/*
//inArc end
    x = sideCenterWidth - (arcWidthMin + arc4random_uniform(arcWidthDelta));
    y = arc4random_uniform(arcHeightMax);
    [result addObject:NSValueWithPoint(x, y)];
    
//hole start
    y += curlHeight;
    [result addObject:NSValueWithPoint(x, y)];
    
//hole end
    x = sideCenterWidth + (arcWidthMin + arc4random_uniform(arcWidthDelta));
    y = arc4random_uniform(arcHeightMax) + curlHeight;
    [result addObject:NSValueWithPoint(x, y)];
    
    //outArc start
    y -= curlHeight;
    [result addObject:NSValueWithPoint(x, y)];
*/
    
//  revert random
    if (arc4random_uniform(2) == 1) {
        for (NSInteger index = 0; index < result.count; index++) {
            CGPoint point = CGPointFromValue(result[index]);
            
            result[index] = NSValueWithPoint(point.x, sideHeight - point.y);
        }
    }
    
    return result;
}

@end
