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
        self.noncalculatedTileSet = [NSMutableSet new];
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

- (void)updateNoncalculatedTiles {
    NSMutableSet *calculatedTileSet = [NSMutableSet setWithSet:self.tileSet];
    [calculatedTileSet minusSet:self.noncalculatedTileSet];
    
    NSMutableSet *newNoncalculatedTileSet = [NSMutableSet new];
    
    for (PJWTileImageView *view in calculatedTileSet) {
        if ([self noncalculatedTile:view]) {
            [newNoncalculatedTileSet addObject:view];
        }
    }
    
    [self.noncalculatedTileSet unionSet:newNoncalculatedTileSet];
}


- (BOOL)noncalculatedTile:(PJWTileImageView *)view {
    PJWPuzzleParameterModel *parameterModel = [PJWPuzzleParameterModel sharedInstance];
    
    NSSet *set = view.tileModel.linkedTileHashTable.setRepresentation;
    
    NSInteger row = view.tileModel.row;
    NSInteger col = view.tileModel.col;
    
    BOOL left = NO;
    if (col == 0) {
        left = YES;
    } else {
        left = [set containsObject:self.tiles[row][col - 1]];
    }
    
    BOOL right = NO;
    if (col == parameterModel.countWidth - 1) {
        right = YES;
    } else {
        right = [set containsObject:self.tiles[row][col + 1]];
    }
    
    BOOL up = NO;
    if (row == 0) {
        up = YES;
    } else {
        up = [set containsObject:self.tiles[row - 1][col]];
    }

    BOOL down = NO;
    if (row == parameterModel.countHeight - 1) {
        down = YES;
    } else {
        down = [set containsObject:self.tiles[row + 1][col]];
    }
    
    return left && right && up && down;
}

#pragma mark -
#pragma mark Private Methods

- (void)setup {
    PJWPuzzleParameterModel *parameterModel = [PJWPuzzleParameterModel sharedInstance];
    
    NSMutableArray *tiles = [NSMutableArray new];
    NSMutableArray *noncalculatedTiles = [NSMutableArray new];
    
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
            [rowNoncalculatedArray addObject:@(NO)];
        }
        
        [tiles addObject:rowArray];
        [noncalculatedTiles addObject:rowNoncalculatedArray];
    }
    
    self.tiles = tiles;
    self.noncalculatedTiles = noncalculatedTiles;
    
    
    
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
