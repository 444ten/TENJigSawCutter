//
//  TENTileModel.m
//  TENJigSawCutter
//
//  Created by 444ten on 8/9/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import "TENTileModel.h"
#import "PJWOffsetCornerModel.h"

#import "PJWCropImageView.h"
#import "PJWPuzzleParameterModel.h"

@interface TENTileModel ()

@end

@implementation TENTileModel

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)initWithRow:(NSUInteger)row column:(NSInteger)col {
    self = [super init];
    if (self) {
        self.row = row;
        self.col = col;
        
        self.linkedTileHashTable = [self setupLinkedTile];
    }
    
    return self;
}

#pragma mark -
#pragma mark Public Methods

- (void)setup {
    PJWCropImageView *cropImageView = [[PJWCropImageView alloc] initWithImage:[self tileImage]];
//    [cropImageView cropImageForRow:self.row col:self.col];

    UIGraphicsBeginImageContextWithOptions(cropImageView.frame.size, NO, 0.0);
    [cropImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *cropImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    
    PJWTileImageView *tileImageView = [[PJWTileImageView alloc] initWithImage:cropImage];
//    tileImageView.layer.borderWidth = 1.0;
//    imageView.alpha = 0.4;

    
    self.imageView = tileImageView;
    
    self.anchor = [self anchorPoint];
}


#pragma mark -
#pragma mark Private Methods

- (NSHashTable *)setupLinkedTile {
    NSHashTable *result = [NSHashTable weakObjectsHashTable];
    [result addObject:self];
    
    return result;
}

- (UIImage *)tileImage {
    PJWPuzzleParameterModel *parameterModel = [PJWPuzzleParameterModel sharedInstance];
    
    CGFloat x = self.col * (parameterModel.baseWidth  + parameterModel.overlapWidth);
    CGFloat y = self.row * (parameterModel.baseHeight + parameterModel.overlapHeight);
    CGFloat dX = parameterModel.sliceWidth;
    CGFloat dY = parameterModel.sliceHeight;

    CGRect tileRect = CGRectMake(x, y, dX, dY);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(parameterModel.originImage.CGImage, tileRect);
    UIImage *result = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
   
    return result;
}

- (NSValue *)anchorPoint {
    PJWPuzzleParameterModel *parameterModel = [PJWPuzzleParameterModel sharedInstance];
    CGFloat x = parameterModel.overlapWidth  + 0.5 * parameterModel.baseWidth  + self.col * parameterModel.anchorWidth ;
    CGFloat y = parameterModel.overlapHeight + 0.5 * parameterModel.baseHeight + self.row * parameterModel.anchorHeight;
    
    return NSValueWithPoint(x, y);
}

@end
