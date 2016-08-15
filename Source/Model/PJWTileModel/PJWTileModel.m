//
//  PJWTileModel.m
//  TENJigSawCutter
//
//  Created by 444ten on 8/15/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import "PJWTileModel.h"
#import "PJWPuzzleParameterModel.h"

@implementation PJWTileModel
#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)initWithRow:(NSUInteger)row column:(NSInteger)col {
    self = [super init];
    if (self) {
        self.row = row;
        self.col = col;
        
        self.anchor = [self anchorPoint];
        
        self.linkedTileHashTable = [NSHashTable weakObjectsHashTable];
    }
    
    return self;
}

#pragma mark -
#pragma mark Private Methods

- (NSValue *)anchorPoint {
    PJWPuzzleParameterModel *parameterModel = [PJWPuzzleParameterModel sharedInstance];
    CGFloat x = parameterModel.overlapWidth  + 0.5 * parameterModel.baseWidth  + self.col * parameterModel.anchorWidth ;
    CGFloat y = parameterModel.overlapHeight + 0.5 * parameterModel.baseHeight + self.row * parameterModel.anchorHeight;
    
    return NSValueWithPoint(x, y);
}

@end
