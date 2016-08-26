//
//  UIImage+Resize.h
//  TENJigSawCutter
//
//  Created by 444ten on 8/26/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

- (UIImage *)croppedImage:(CGRect)bounds;
//- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
//          transparentBorder:(NSUInteger)borderSize
//               cornerRadius:(NSUInteger)cornerRadius
//       interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;

/*
+ (UIImage *)imageWithImage:(UIImage *)image scaledToFitToSize:(CGSize)newSize;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToFillToSize:(CGSize)newSize;
*/

@end
