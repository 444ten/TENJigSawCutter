//
//  TENTileModel.m
//  TENJigSawCutter
//
//  Created by 444ten on 8/9/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import "TENTileModel.h"
#import "PJWOffsetCornerModel.h"
#import "PJWPuzzleParameterModel.h"

@interface TENTileModel ()
@property (nonatomic, strong)   NSMutableArray  *upPoints;
@property (nonatomic, strong)   NSMutableArray  *leftPoints;
@property (nonatomic, strong)   NSMutableArray  *downPoints;
@property (nonatomic, strong)   NSMutableArray  *rightPoints;

@end

@implementation TENTileModel

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)initWithRow:(NSUInteger)row column:(NSInteger)col {
    self = [super init];
    if (self) {
        self.row = row;
        self.col = col;
        
        self.upPoints    = [NSMutableArray new];
        self.leftPoints  = [NSMutableArray new];
        self.downPoints  = [NSMutableArray new];
        self.rightPoints = [NSMutableArray new];
    }
    
    return self;
}

#pragma mark -
#pragma mark Public Methods

- (void)setup {
    PJWTileImageView *imageView = [[PJWTileImageView alloc] initWithImage:[self tileImage]];
    imageView.layer.borderWidth = 1.0;
//    imageView.alpha = 0.4;
    
    self.imageView = imageView;
    
    self.center = [self randomCenter];
    
    [self cropImageView];
}

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
    
//    NSMutableArray *upPoints = self.upPoints;
//    [upPoints addObject:leftUpCorner];
//    [upPoints addObject:leftUpCorner];
    
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
    self.imageView.bezierPath = aPath;
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = aPath.CGPath;
    
    [self.imageView.layer setMask:shapeLayer];

    
    [self drawPath:aPath inView:self.imageView];
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

#pragma mark -
#pragma mark Private Methods

- (UIImage *)tileImage {
    CGPoint upLeftPoint = CGPointFromValue(self.upLeft);
    CGPoint downRightPoint = CGPointFromValue(self.downRight);
    
    CGRect tileRect = CGRectMake(upLeftPoint.x, upLeftPoint.y,
                                 downRightPoint.x - upLeftPoint.x, downRightPoint.y - upLeftPoint.y);
    
    UIImage *originImage = [PJWPuzzleParameterModel sharedInstance].originImage;
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(originImage.CGImage, tileRect);
    UIImage *result = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);

    return result;
}

- (NSValue *)randomCenter {
    CGFloat x = arc4random_uniform(900);
    CGFloat y = arc4random_uniform(700);
    
    return NSValueWithPoint(x, y);
}

@end
