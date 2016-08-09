//
//  TENTileModel.m
//  TENJigSawCutter
//
//  Created by 444ten on 8/9/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import "TENTileModel.h"

@implementation TENTileModel

#pragma mark -
#pragma mark Public Methods

- (void)setupImageViewWithOriginImage:(UIImage *)originImage {
    CGPoint upLeftPoint = CGPointFromValue(self.upLeft);
    CGPoint downRightPoint = CGPointFromValue(self.downRight);
    
    CGRect tileRect = CGRectMake(upLeftPoint.x, upLeftPoint.y,
                                 downRightPoint.x - upLeftPoint.x, downRightPoint.y - upLeftPoint.y);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(originImage.CGImage, tileRect);
    UIImage *tileImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:tileImage];
    imageView.layer.borderWidth = 1.0;
    
    self.imageView = imageView;
    
    
    CGFloat x = arc4random_uniform(300);
    CGFloat y = arc4random_uniform(300);

    self.center = NSValueWithPoint(x, y);
}
@end
