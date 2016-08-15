//
//  PJWTileImageView.m
//  TENJigSawCutter
//
//  Created by 444ten on 8/11/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import "PJWTileImageView.h"

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

@end
