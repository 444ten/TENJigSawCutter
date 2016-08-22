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
#pragma mark Accessors

- (void)setTileModel:(PJWTileModel *)tileModel {
    if (_tileModel != tileModel) {
        _tileModel = tileModel;
        
        CGRect bezierRect = tileModel.bezierPath.bounds;
        CGSize size = self.frame.size;
        
        tileModel.bezierInsets = UIEdgeInsetsMake(bezierRect.origin.y,
                                                  bezierRect.origin.x,
                                                  size.height - bezierRect.origin.y - bezierRect.size.height,
                                                  size.width  - bezierRect.origin.x - bezierRect.size.width);
    }
}

#pragma mark -
#pragma mark Overriden Methods

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return [self.tileModel.bezierPath containsPoint:point];
}

#pragma mark -
#pragma mark Public Methods

- (void)moveSegmentWithOffset:(CGPoint)offset animated:(BOOL)animated {
    NSEnumerator *enumerator = [self.tileModel.linkedTileHashTable objectEnumerator];
    PJWTileImageView *view;
    while (view = [enumerator nextObject]) {
        [self.superview bringSubviewToFront:view];
        
        [UIView animateWithDuration:animated ? 0.20 : 0.0
                         animations:^{
                             view.center = CGPointMake(view.center.x + offset.x,
                                                       view.center.y + offset.y);
                             
                         }];
    }
}

- (void)moveSegmentToPoint:(CGPoint)point animated:(BOOL)animated {
    CGPoint offset = CGPointMake(point.x - self.center.x, point.y - self.center.y);
    
    [self moveSegmentWithOffset:offset animated:animated];
}

- (void)stickToView:(PJWTileImageView *)view {
    PJWPuzzleParameterModel *parameterModel = [PJWPuzzleParameterModel sharedInstance];
    PJWTileModel *tileModel = self.tileModel;
    PJWTileModel *viewTileModel = view.tileModel;
    
    CGPoint targetCenter = view.center;
    targetCenter.x += (tileModel.col - viewTileModel.col) * parameterModel.anchorWidth;
    targetCenter.y += (tileModel.row - viewTileModel.row) * parameterModel.anchorHeight;
    
    [self moveSegmentToPoint:targetCenter animated:YES];
    [self updateLinkedTileWithView:view];
}

- (void)moveToTargetView:(PJWTileImageView *)targetView {
    PJWPuzzleParameterModel *parameterModel = [PJWPuzzleParameterModel sharedInstance];

    PJWTileModel *tileModel = self.tileModel;
    PJWTileModel *targetTileModel = targetView.tileModel;
    
    CGPoint center = targetView.center;
    center.x += (tileModel.col - targetTileModel.col) * parameterModel.anchorWidth;
    center.y += (tileModel.row - targetTileModel.row) * parameterModel.anchorHeight;
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.center = center;
                     }];
    
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

    NSEnumerator *enumerator = [linkedTileSet objectEnumerator];
    PJWTileImageView *imageView;
    while (imageView = [enumerator nextObject]) {
        imageView.tileModel.linkedTileHashTable = aggregateTable;
    }
}

@end
