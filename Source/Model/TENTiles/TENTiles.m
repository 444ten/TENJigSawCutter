//
//  TENTiles.m
//  TENJigSawCutter
//
//  Created by 444ten on 8/9/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import "TENTiles.h"

#import "PJWOffsetCornerModel.h"

@interface TENTiles ()
@property (nonatomic, assign) CGFloat baseWidth;
@property (nonatomic, assign) CGFloat overlapWidth;
@property (nonatomic, assign) CGFloat sliceWidth;

@property (nonatomic, assign) CGFloat baseHeight;
@property (nonatomic, assign) CGFloat overlapHeight;
@property (nonatomic, assign) CGFloat sliceHeight;

@end

@implementation TENTiles

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tiles = [NSMutableArray new];
    }
    
    return self;
}

#pragma mark -
#pragma mark Public Methods

- (void)setup {
    [self calculateParameters];
    
    PJWOffsetCornerModel *offsetCornerModel = [[PJWOffsetCornerModel alloc] initWithCountWidth:self.countWidth
                                                                                   countHeight:self.countHeight
                                                                                  overlapWidth:self.overlapWidth
                                                                                 overlapHeight:self.overlapHeight];
    
    UIImage *originImage = [UIImage imageNamed:kImageName];
        
    NSMutableArray *tiles = self.tiles;
    
    for (NSInteger row = 0; row < self.countHeight; row++) {
        
        for (NSInteger col = 0; col < self.countWidth; col++) {
            TENTileModel *tileModel = [[TENTileModel alloc]initWithOriginImage:originImage row:row column:col];
            
            [self setCornerPointFor:tileModel];
            
            [tileModel setupImageViewWithOriginImage:originImage];
            
            if (0 == col) {
                tileModel.tileType |= PJWTileTypeLeft;
            } else if (self.countWidth - 1 == col) {
                tileModel.tileType |= PJWTileTypeRight;
            }
            
            if (0 == row) {
                tileModel.tileType |= PJWTileTypeUp;
            } else if (self.countHeight - 1 == row) {
                tileModel.tileType |= PJWTileTypeDown;
            }
            
            
            [tiles addObject:tileModel];
        }
    }
}

#pragma mark -
#pragma mark Private Methods

- (void)calculateParameters {
    self.baseWidth = self.fullWidth / (self.countWidth + self.overlapRatioWidth * (self.countWidth + 1));
    self.overlapWidth = self.overlapRatioWidth * self.baseWidth;
    self.sliceWidth = 2 * self.overlapWidth + self.baseWidth;
    
    self.baseHeight = self.fullHeight / (self.countHeight + self.overlapRatioHeight * (self.countHeight + 1));
    self.overlapHeight = self.overlapRatioHeight * self.baseHeight;
    self.sliceHeight = 2 * self.overlapHeight + self.baseHeight;
}

- (void)setCornerPointFor:(TENTileModel *)tileModel {
    CGFloat x = tileModel.col * (self.baseWidth + self.overlapWidth);
    CGFloat y = tileModel.row * (self.baseHeight + self.overlapHeight);
    
    tileModel.upLeft    = NSValueWithPoint(x                    , y                     );
    tileModel.upRight   = NSValueWithPoint(x + self.sliceWidth  , y                     );
    tileModel.downRight = NSValueWithPoint(x + self.sliceWidth  , y + self.sliceHeight  );
    tileModel.downLeft  = NSValueWithPoint(x                    , y + self.sliceHeight  );
}

#pragma mark -
#pragma mark

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
    
    //    [tileView.layer setMask:shapeLayer];
    
    [self drawPath:aPath inView:tileView];
}


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

- (void)drawPath:(UIBezierPath *)path inView:(UIView *)view {
    CAShapeLayer *shapeLayer = [CAShapeLayer new];
    shapeLayer.lineWidth = 1;
    shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    shapeLayer.fillColor = [UIColor colorWithWhite:0.0 alpha:0.5].CGColor;
    shapeLayer.path = path.CGPath;
    
    [view.layer addSublayer:shapeLayer];
}


@end
