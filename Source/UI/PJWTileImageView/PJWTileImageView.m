//
//  PJWTileImageView.m
//  TENJigSawCutter
//
//  Created by 444ten on 8/11/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import "PJWTileImageView.h"

#import "PJWPuzzleParameterModel.h"

@implementation PJWTileImageView

#pragma mark -
#pragma mark Overriden Methods

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return [self.tileModel.bezierPath containsPoint:point];
}

#pragma mark -
#pragma mark Public Methods

- (void)moveSegmentWithOffset:(CGPoint)offset {
    for (PJWTileImageView *view in self.tileModel.linkedTileHashTable) {
        view.center = CGPointMake(view.center.x + offset.x,
                                  view.center.y + offset.y);
        
        [self.superview bringSubviewToFront:view];
    }
}

- (void)moveSegmentToPoint:(CGPoint)point {
    CGPoint offset = CGPointMake(point.x - self.center.x, point.y - self.center.y);
    
    [self moveSegmentWithOffset:offset];
}

- (void)stickToView:(PJWTileImageView *)view {
    PJWPuzzleParameterModel *parameterModel = [PJWPuzzleParameterModel sharedInstance];
    PJWTileModel *tileModel = self.tileModel;
    PJWTileModel *viewTileModel = view.tileModel;
    
    CGPoint targetCenter = view.center;
    
    //width drag
    if (tileModel.row == viewTileModel.row) {
        targetCenter.x += (tileModel.col - viewTileModel.col) * parameterModel.anchorWidth;
    }
    
    //height drag
    if (tileModel.col == viewTileModel.col) {
        targetCenter.y += (tileModel.row - viewTileModel.row) * parameterModel.anchorHeight;
    }
    
    [self moveSegmentToPoint:targetCenter];
    [self updateLinkedTileWithView:view];
}

- (BOOL)isNeighborToView:(PJWTileImageView *)view {
    CGFloat magneticDelta = 40;
    
    PJWPuzzleParameterModel *parameterModel = [PJWPuzzleParameterModel sharedInstance];
    PJWTileModel *tileModel = self.tileModel;
    PJWTileModel *viewTileModel = view.tileModel;

    CGPoint center = self.center;
    CGPoint viewCenter = view.center;
    
    CGFloat deltaWidthAxis = fabs(center.x - viewCenter.x);
    CGFloat deltaWidthNeighbor = fabs(deltaWidthAxis - parameterModel.anchorWidth);
    
    CGFloat deltaHeightAxis = fabs(center.y - viewCenter.y);
    CGFloat deltaHeightNeighbor = fabs(deltaHeightAxis - parameterModel.anchorHeight);
    
    //height neighbor
    if (deltaWidthAxis < magneticDelta && deltaHeightNeighbor < magneticDelta) {
        if (viewTileModel.col == tileModel.col) {
            NSInteger nextRow = viewTileModel.row - tileModel.row;
            NSInteger sign = (viewCenter.y > center.y) ? 1: -1;
            
            if ((sign * nextRow) == 1) {
                return YES;
            }
        }
    }
    
    //width neighbor
    if (deltaHeightAxis < magneticDelta && deltaWidthNeighbor < magneticDelta) {
        if (viewTileModel.row == tileModel.row) {
            NSInteger nextCol = viewTileModel.col - tileModel.col;
            NSInteger sign = (viewCenter.x > center.x) ? 1: -1;
            
            if ((sign * nextCol) == 1) {
                return YES;
            }
        }
    }
    
    return NO;
}

#pragma mark -
#pragma mark Private Methods

- (void)updateLinkedTileWithView:(PJWTileImageView *)view {
    PJWTileModel *tileModel = self.tileModel;
    PJWTileModel *viewTileModel = view.tileModel;
    
    NSHashTable *aggregateTable = [NSHashTable weakObjectsHashTable];
    [aggregateTable unionHashTable:tileModel.linkedTileHashTable];
    [aggregateTable unionHashTable:viewTileModel.linkedTileHashTable];
    
    NSMutableSet *linkedTileSet = tileModel.linkedTileHashTable.setRepresentation.mutableCopy;
    [linkedTileSet unionSet:viewTileModel.linkedTileHashTable.setRepresentation];
    
    for (PJWTileImageView *imageView in linkedTileSet) {
        imageView.tileModel.linkedTileHashTable = aggregateTable;
    }

}

@end
