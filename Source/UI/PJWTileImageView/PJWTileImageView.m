//
//  PJWTileImageView.m
//  TENJigSawCutter
//
//  Created by 444ten on 8/11/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import "PJWTileImageView.h"

@implementation PJWTileImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark -
#pragma mark Overriden Methods

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return [self.bezierPath containsPoint:point];
}

@end
