//
//  PJWTilesModel.m
//  TENJigSawCutter
//
//  Created by 444ten on 8/15/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import "PJWTilesModel.h"

#import "PJWTileModel.h"

#import "PJWPuzzleParameterModel.h"
#import "PJWCropImageView.h"
#import "PJWTileImageView.h"

@interface PJWTilesModel ()
@property (nonatomic, strong)   NSMutableArray *tiles;

@end

@implementation PJWTilesModel

@dynamic tileSet;

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

#pragma mark -
#pragma mark Accessors

- (NSSet *)tileSet {
    NSMutableSet *result = [NSMutableSet new];
    for (NSArray *rowArray in self.tiles) {
        for (id obj in rowArray) {
            [result addObject:obj];
        }
    }

    return result.copy;
}

#pragma mark -
#pragma mark Private Methods

- (void)setup {
    PJWPuzzleParameterModel *parameterModel = [PJWPuzzleParameterModel sharedInstance];
    
    NSMutableArray *tiles = [NSMutableArray new];
    
    for (NSInteger row = 0; row < parameterModel.countHeight; row++) {
        
        NSMutableArray *rowArray = [NSMutableArray new];
        
        for (NSInteger col = 0; col < parameterModel.countWidth; col++) {
            PJWTileModel *tileModel = [[PJWTileModel alloc] initWithRow:row column:col];
            
            PJWTileImageView *tileImageView = [[PJWTileImageView alloc]
                                               initWithImage:[self cropImageForTileModel:tileModel]];
            
            [tileModel.linkedTileHashTable addObject:tileImageView];
            tileImageView.tileModel = tileModel;
            
            [rowArray addObject:tileImageView];
        }
        
        [tiles addObject:rowArray];
    }
    
    self.tiles = tiles;
}

#pragma mark -
#pragma mark Private Methods

- (UIImage *)cropImageForTileModel:(PJWTileModel *)tileModel {
    PJWCropImageView *cropImageView = [[PJWCropImageView alloc] initWithImage:[self imageForTileModel:tileModel]];
    [cropImageView cropImageForTileModel:tileModel];
    
    UIGraphicsBeginImageContextWithOptions(cropImageView.frame.size, NO, 0.0);
    [cropImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

- (UIImage *)imageForTileModel:(PJWTileModel *)tileModel {
    PJWPuzzleParameterModel *parameterModel = [PJWPuzzleParameterModel sharedInstance];
    
    CGFloat x = tileModel.col * (parameterModel.baseWidth  + parameterModel.overlapWidth);
    CGFloat y = tileModel.row * (parameterModel.baseHeight + parameterModel.overlapHeight);
    CGFloat dX = parameterModel.sliceWidth;
    CGFloat dY = parameterModel.sliceHeight;
    
    CGRect tileRect = CGRectMake(x, y, dX, dY);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(parameterModel.originImage.CGImage, tileRect);
    UIImage *result = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return result;
}

@end
