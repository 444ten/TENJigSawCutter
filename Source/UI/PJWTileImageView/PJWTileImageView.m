//
//  PJWTileImageView.m
//  TENJigSawCutter
//
//  Created by 444ten on 8/11/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import "PJWTileImageView.h"
#import "PJWPuzzleParameterModel.h"
#import "TENMacros.h"

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

//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    return [self.bezierPath containsPoint:point];
//}

#pragma mark -
#pragma mark Public Methods

- (void)cropImageView {
    PJWPuzzleParameterModel *parameterModel = [PJWPuzzleParameterModel sharedInstance];
    NSInteger row = self.row;
    NSInteger col = self.col;
    
    NSArray *offsets = parameterModel.offsetCornerModel.offsets;
    
    CGPoint leftUpOffset    = CGPointFromValue(offsets[row    ][col    ]);
    CGPoint rightUpOffset   = CGPointFromValue(offsets[row    ][col + 1]);
    CGPoint rightDownOffset = CGPointFromValue(offsets[row + 1][col + 1]);
    CGPoint leftDownOffset  = CGPointFromValue(offsets[row + 1][col    ]);
    
    CGFloat offsetWidth = parameterModel.baseWidth + parameterModel.overlapWidth;
    CGFloat offsetHeight = parameterModel.baseHeight + parameterModel.overlapHeight;
    
    NSValue *leftUpCorner    = NSValueWithPoint(   leftUpOffset.x              ,    leftUpOffset.y               );
    NSValue *rightUpCorner   = NSValueWithPoint(  rightUpOffset.x + offsetWidth,   rightUpOffset.y               );
    NSValue *rightDownCorner = NSValueWithPoint(rightDownOffset.x + offsetWidth, rightDownOffset.y + offsetHeight);
    NSValue *leftDownCorner  = NSValueWithPoint( leftDownOffset.x              ,  leftDownOffset.y + offsetHeight);
    
    NSArray *points = nil;
    
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    [aPath moveToPoint:CGPointFromValue(leftUpCorner)];
    //up side
    points = parameterModel.offsetSideModel.widthSides[row][col];
    
    for (NSInteger index = 0; index < points.count; index++) {
        [aPath addLineToPoint:CGPointFromValue(points[index])];
    }
    
    
    [aPath addLineToPoint:CGPointFromValue(rightUpCorner)];
    
    //right side
    points = parameterModel.offsetSideModel.heightSides[row][col + 1];
    
    for (NSInteger index = 0; index < points.count; index++) {
        CGPoint point = CGPointFromValue(points[index]);
        point.x += offsetWidth;
        
        [aPath addLineToPoint:point];
    }
    
    [aPath addLineToPoint:CGPointFromValue(rightDownCorner)];
    
    //down side
    points = parameterModel.offsetSideModel.widthSides[row + 1][col];
    
    for (NSInteger index = points.count; index > 0; index--) {
        CGPoint point = CGPointFromValue(points[index-1]);
        point.y += offsetHeight;
        
        [aPath addLineToPoint:point];
    }
    
    [aPath addLineToPoint:CGPointFromValue(leftDownCorner)];
    
    //left side
    points = parameterModel.offsetSideModel.heightSides[row][col];
    
    for (NSInteger index = points.count; index > 0; index--) {
        [aPath addLineToPoint:CGPointFromValue(points[index-1])];
    }
    
    [aPath closePath];
    
    //mask
    self.bezierPath = aPath;

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = aPath.CGPath;
    
    
    [self.layer setMask:shapeLayer];    
    
    [self drawPath:aPath inView:self];
}

- (void)drawPath:(UIBezierPath *)path inView:(UIView *)view {
    CAShapeLayer *shapeLayer = [CAShapeLayer new];
    shapeLayer.lineWidth = 1;
    shapeLayer.strokeColor = [UIColor greenColor].CGColor;
    shapeLayer.fillColor = [UIColor colorWithWhite:0.0 alpha:0.0].CGColor;
    shapeLayer.path = path.CGPath;
    
    [view.layer addSublayer:shapeLayer];
}


#pragma mark -
#pragma mark
/*
 - (void)cropTileView:(UIImageView *)tileView {
 CGRect tileViewRect = tileView.bounds;
 
 CGFloat width = tileViewRect.size.width;
 CGFloat height = tileViewRect.size.height;
 
 //    CGPoint leftUp      = CGPointMake(    0,      0);
 //    CGPoint leftDown    = CGPointMake(    0, height);
 //    CGPoint rightUp     = CGPointMake(width,      0);
 //    CGPoint rightDown   = CGPointMake(width, height);
 
 CGPoint leftUp      = CGPointMake(   10,      10);
 CGPoint rightUp     = CGPointMake(width,      0);
 CGPoint rightDown   = CGPointMake(width, height);
 CGPoint leftDown    = CGPointMake(   20, height);
 
 
 NSArray *points = @[NSValueWithPoint(10, 10),
 NSValueWithPoint(width, 0),
 [NSValue valueWithCGPoint:rightDown],
 [NSValue valueWithCGPoint:leftDown]
 ];
 
 UIBezierPath *aPath = [UIBezierPath bezierPath];
 
 //start
 [aPath moveToPoint:CGPointFromValue(points[0])];
 
 //up side
 [aPath addLineToPoint:[points[1] CGPointValue]];
 
 //right side
 
 NSArray *curvePoints = @[NSValueWithPoint( 95,  200),    // inArc end
 NSValueWithPoint( 200,  190),   // hole start
 NSValueWithPoint( 130,  400),   // hole finish
 NSValueWithPoint( 100,  35),   // outArc start
 ];
 
 NSArray *controlPoints = @[NSValueWithPoint( 70,  70),    // inArc control 1
 NSValueWithPoint( 70,  130),    // inArc control 2
 NSValueWithPoint( 300,  -100),    // hole control 1
 NSValueWithPoint( 400,  400),    // hole control 2
 NSValueWithPoint( 97,  35),    // outArc control 1
 NSValueWithPoint( 97,  35),    // outArc control 2
 ];
 
 [aPath addCurveToPoint:CGPointFromValue(curvePoints[0])
 controlPoint1:CGPointFromValue(controlPoints[0])
 controlPoint2:CGPointFromValue(controlPoints[1])];
 
 //    [aPath addLineToPoint:CGPointFromValue(curvePoints[1])];
 
 NSValue *intersection = [self intersectionU1:controlPoints[1]
 u2:curvePoints[0]
 v1:controlPoints[2]
 v2:curvePoints[1]];
 
 [aPath addQuadCurveToPoint:CGPointFromValue(curvePoints[1])
 controlPoint:CGPointFromValue(intersection)];
 
 
 [aPath addCurveToPoint:CGPointFromValue(curvePoints[2])
 controlPoint1:CGPointFromValue(controlPoints[2])
 controlPoint2:CGPointFromValue(controlPoints[3])];
 
 
 
 //    [aPath addCurveToPoint:CGPointFromValue(rightPoints[5])
 //             controlPoint1:CGPointFromValue(rightPoints[3])
 //             controlPoint2:CGPointFromValue(rightPoints[4])];
 //
 //    [aPath addCurveToPoint:CGPointFromValue(rightPoints[8])
 //             controlPoint1:CGPointFromValue(rightPoints[6])
 //             controlPoint2:CGPointFromValue(rightPoints[7])];
 //
 ////down side
 //    [aPath addLineToPoint:[points[3] CGPointValue]];
 //
 ////left side
 //    [aPath addLineToPoint:[points[0] CGPointValue]];
 //
 ////finish
 //    [aPath closePath];
 
 
 CAShapeLayer *shapeLayer = [CAShapeLayer layer];
 shapeLayer.path = aPath.CGPath;
 
 [tileView.layer setMask:shapeLayer];
 
 [self drawPath:aPath inView:tileView];
 }
 
 */
- (NSValue *)intersectionU1:(NSValue *)u1Value
                         u2:(NSValue *)u2Value
                         v1:(NSValue *)v1Value
                         v2:(NSValue *)v2Value {
    CGPoint u1 = CGPointFromValue(u1Value);
    CGPoint u2 = CGPointFromValue(u2Value);
    CGPoint v1 = CGPointFromValue(v1Value);
    CGPoint v2 = CGPointFromValue(v2Value);
    
    CGPoint ret=u1;
    double t=((u1.x-v1.x)*(v1.y-v2.y)-(u1.y-v1.y)*(v1.x-v2.x))/((u1.x-u2.x)*(v1.y-v2.y)-(u1.y-u2.y)*(v1.x-v2.x));
    
    ret.x+=(u2.x-u1.x)*t;
    ret.y+=(u2.y-u1.y)*t;
    
    return NSValueWithPoint(ret.x, ret.y);
}


@end
