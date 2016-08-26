//
//  UIImage+Resize.h
//  TENJigSawCutter
//
//  Created by 444ten on 8/26/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

+ (UIImage *)imageWithImage:(UIImage *)image scaledToFitToSize:(CGSize)newSize;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToFillToSize:(CGSize)newSize;

@end
