//
//  TENTileModel.m
//  TENJigSawCutter
//
//  Created by 444ten on 8/9/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import "TENTileModel.h"
#import "PJWOffsetCornerModel.h"

@interface TENTileModel ()
@property (nonatomic, strong)   NSMutableArray  *upPoints;
@property (nonatomic, strong)   NSMutableArray  *leftPoints;
@property (nonatomic, strong)   NSMutableArray  *downPoints;
@property (nonatomic, strong)   NSMutableArray  *rightPoints;

@end

@implementation TENTileModel

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)initWithOriginImage:(UIImage *)originImage row:(NSUInteger)row column:(NSInteger)col {
    self = [super init];
    if (self) {
        self.originImage = originImage;
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
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self tileImage]];
    imageView.layer.borderWidth = 1.0;
    
    self.imageView = imageView;
    
    self.center = [self randomCenter];
}

- (void)cropImageWithOffsetCornerModel:(PJWOffsetCornerModel *)offsetCornerModel {
    NSInteger row = self.row;
    NSInteger col = self.col;
    
    NSArray *offsets = offsetCornerModel.offsets;
    
    CGPoint leftUpOffset    = CGPointFromValue(offsets[row    ][col    ]);
    CGPoint rightUpOffset   = CGPointFromValue(offsets[row    ][col + 1]);
    CGPoint rightDownOffset = CGPointFromValue(offsets[row + 1][col + 1]);
    CGPoint leftDownOffset  = CGPointFromValue(offsets[row + 1][col    ]);    
}

#pragma mark -
#pragma mark Private Methods

- (UIImage *)tileImage {
    CGPoint upLeftPoint = CGPointFromValue(self.upLeft);
    CGPoint downRightPoint = CGPointFromValue(self.downRight);
    
    CGRect tileRect = CGRectMake(upLeftPoint.x, upLeftPoint.y,
                                 downRightPoint.x - upLeftPoint.x, downRightPoint.y - upLeftPoint.y);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.originImage.CGImage, tileRect);
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
