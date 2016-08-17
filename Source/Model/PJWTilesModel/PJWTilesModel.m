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
#pragma mark Public Methods

- (void)updateCalculatedTilesWithView:(PJWTileImageView *)view {
    NSSet *linkedTileSet = view.tileModel.linkedTileHashTable.setRepresentation;
    PJWPuzzleParameterModel *parameterModel = [PJWPuzzleParameterModel sharedInstance];
    NSArray *calculatedTiles = self.calculatedTiles;
    
    NSEnumerator *enumerator = [linkedTileSet objectEnumerator];
    PJWTileImageView *imageView;
    while (imageView = [enumerator nextObject]) {
        PJWTileModel *tileModel = imageView.tileModel;
        calculatedTiles[tileModel.row][tileModel.col] = @(NO);
    }

    
    for (NSInteger row = 0; row < parameterModel.countHeight; row++) {
        for (NSInteger col = 0; col < parameterModel.countWidth; col++) {
            calculatedTiles[row][col] = [self calculatedTileWithRow:row col:col];
        }
    }
    
}


- (NSValue *)calculatedTileWithRow:(NSInteger)row col:(NSInteger)col {
    NSArray *calculatedTiles = self.calculatedTiles;
    PJWPuzzleParameterModel *parameterModel = [PJWPuzzleParameterModel sharedInstance];
    
    BOOL left = YES;
    if (col == 0) {
        left = NO;
    } else {
        left = [calculatedTiles[row][col - 1] boolValue];
    }
    
    BOOL right = YES;
    if (col == parameterModel.countWidth - 1) {
        right = NO;
    } else {
        right = [calculatedTiles[row][col + 1] boolValue];
    }
    
    BOOL up = YES;
    if (row == 0) {
        up = NO;
    } else {
        up = [calculatedTiles[row - 1][col] boolValue];
    }

    BOOL down = YES;
    if (row == parameterModel.countHeight - 1) {
        down = YES;
    } else {
        down = [calculatedTiles[row + 1][col] boolValue];
    }
    
    return @(left || right || up || down);
}

#pragma mark -
#pragma mark Private Methods

- (void)setup {
    PJWPuzzleParameterModel *parameterModel = [PJWPuzzleParameterModel sharedInstance];
    
    NSMutableArray *tiles = [NSMutableArray new];
    NSMutableArray *calculatedTiles = [NSMutableArray new];
    
    for (NSInteger row = 0; row < parameterModel.countHeight; row++) {
        
        NSMutableArray *rowArray = [NSMutableArray new];
        NSMutableArray *rowNoncalculatedArray = [NSMutableArray new];
        
        for (NSInteger col = 0; col < parameterModel.countWidth; col++) {
            PJWTileModel *tileModel = [[PJWTileModel alloc] initWithRow:row column:col];
            
            PJWTileImageView *tileImageView = [[PJWTileImageView alloc]
                                               initWithImage:[self cropImageForTileModel:tileModel]];
            
            [tileModel.linkedTileHashTable addObject:tileImageView];
            tileImageView.tileModel = tileModel;
            
            [rowArray addObject:tileImageView];
            [rowNoncalculatedArray addObject:@(YES)];
        }
        
        [tiles addObject:rowArray];
        [calculatedTiles addObject:rowNoncalculatedArray];
    }
    
    self.tiles = tiles;
    self.calculatedTiles = calculatedTiles;
    
    
    
}

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
