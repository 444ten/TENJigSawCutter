//
//  ViewController.m
//  TENJigSawCutter
//
//  Created by 444ten on 8/5/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import "ViewController.h"

#import "TENCornerModel.h"
#import "TENTiles.h"

//static NSString * const kImageName = @"04.jpg";
static NSString * const kImageName = @"200x200";

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *centerImageView;
@property (strong, nonatomic) IBOutlet UIImageView *originalImageView;

@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;

@property (nonatomic, strong) TENCornerModel *cornerModel;

@property (nonatomic, strong)   TENTiles    *tiles;

@end

@implementation ViewController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCornerModel];
    [self setupTiles];
    
    UIImage *image = [UIImage imageNamed:kImageName];
    
//    self.centerImageView.image = image;
    self.originalImageView.image = image;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self cropOnlyImage];
}

#pragma mark -
#pragma mark TENCornerModel

- (void)setupCornerModel {
    TENCornerModel *cornerModel = [TENCornerModel new];

    cornerModel.fullWidth = 200.f;
    cornerModel.fullHeight = 200.f;
    cornerModel.countWidth = 3;
    cornerModel.countHeight = 4;
    
    [cornerModel setup];
    
    self.cornerModel = cornerModel;
}

- (void)setupTiles {
    TENTiles *tiles = [TENTiles new];
    tiles.cornerModel = self.cornerModel;
    
    [tiles setup];
    
    self.tiles = tiles;
}

#pragma mark -
#pragma mark Interface Handling

- (IBAction)panCenterImage:(UIPanGestureRecognizer *)recognizer {
    NSLog(@"Coordinate...");
    [self.view bringSubviewToFront:recognizer.view];
    
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
}
- (IBAction)tapOriginalImage:(UITapGestureRecognizer *)sender {
    [self.view bringSubviewToFront:sender.view];
}

#pragma mark -
#pragma mark Private Methods

- (void)cropOnlyImage {
    UIView *rootView = self.view;
    
    [rootView addSubview:[self tileViewWithRect:CGRectMake(  0,   0, 600, 600)]];
//    [rootView addSubview:[self tileViewWithRect:CGRectMake(100,   0, 200, 100)]];
//    [rootView addSubview:[self tileViewWithRect:CGRectMake(  0, 100, 100, 200)]];
//    [rootView addSubview:[self tileViewWithRect:CGRectMake(100, 100, 200, 200)]];
}

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


- (UIImageView *)tileViewWithRect:(CGRect)tileRect {
    UIImageView *result = [[UIImageView alloc] initWithImage:[self tileWithRect:tileRect]];
    
//    result.layer.borderWidth = 1.0;
    result.userInteractionEnabled = YES;
    
    [result addGestureRecognizer:[self panRecognizer]];
    [result addGestureRecognizer:[self tapRecognizer]];
    
    [self cropTileView:result];
    
    return result;
}

- (UIImage *)tileWithRect:(CGRect)tileRect {
    UIImage *originImage = [UIImage imageNamed:kImageName];
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(originImage.CGImage, tileRect);
    
    UIImage *result = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return result;
}

- (UIPanGestureRecognizer *)panRecognizer {
    UIPanGestureRecognizer *result = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(panCenterImage:)];
    [result setMinimumNumberOfTouches:1];
    [result setMaximumNumberOfTouches:1];
    
    return result;
}

- (UITapGestureRecognizer *)tapRecognizer {
    UITapGestureRecognizer *result = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(tapAction:)];
    return result;
}

- (void)tapAction:(UITapGestureRecognizer *)recognizer {
    [self.view bringSubviewToFront:recognizer.view];
}

@end
