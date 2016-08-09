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
    UIImageView *result = [[UIImageView alloc] initWithImage:[self tileWithRect:tileRect]];
    
    //    result.layer.borderWidth = 1.0;
    result.userInteractionEnabled = YES;
    
    [result addGestureRecognizer:[self panRecognizer]];
    [result addGestureRecognizer:[self tapRecognizer]];
    
    [self cropTileView:result];
    
    return result;
    UIImage *originImage = [UIImage imageNamed:kImageName];
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(originImage.CGImage, tileRect);
    
    UIImage *result = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return result;

}

@end
