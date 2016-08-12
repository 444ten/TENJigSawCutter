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

@end

@implementation TENTileModel

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)initWithRow:(NSUInteger)row column:(NSInteger)col {
    self = [super init];
    if (self) {
        self.row = row;
        self.col = col;
    }
    
    return self;
}

#pragma mark -
#pragma mark Public Methods

- (void)setup {
    PJWTileImageView *imageView = [[PJWTileImageView alloc] initWithImage:[self tileImage]];
    imageView.layer.borderWidth = 1.0;
//    imageView.alpha = 0.4;

    imageView.row = self.row;
    imageView.col = self.col;
    
    [imageView cropImageView];
    
    self.imageView = imageView;
    
    self.anchor = [self anchorPoint];
}


#pragma mark -
#pragma mark Private Methods

- (UIImage *)tileImage {
    PJWPuzzleParameterModel *parameterModel = [PJWPuzzleParameterModel sharedInstance];
    
    CGFloat x = self.col * (parameterModel.baseWidth + parameterModel.overlapWidth);
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

    CGFloat x = (self.col + 1) * parameterModel.overlapWidth  + (self.col + 0.5) * parameterModel.baseWidth ;
    CGFloat y = (self.row + 1) * parameterModel.overlapHeight + (self.row + 0.5) * parameterModel.baseHeight;
    
    return NSValueWithPoint(x, y);
}

@end
