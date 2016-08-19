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
    NSArray *calculatedTiles = self.calculatedTiles;

    [linkedTileSet enumerateObjectsUsingBlock:^(PJWTileImageView *obj, BOOL *stop) {
        PJWTileModel *tileModel = obj.tileModel;
        calculatedTiles[tileModel.row][tileModel.col] = @(NO);
    }];

    [linkedTileSet enumerateObjectsUsingBlock:^(PJWTileImageView *obj, BOOL *stop) {
        PJWTileModel *tileModel = obj.tileModel;
        NSInteger row = tileModel.row;
        NSInteger col = tileModel.col;
    
        calculatedTiles[row][col] = [self calculatedTileWithRow:row col:col];
    }];
}

- (NSValue *)calculatedTileWithRow:(NSInteger)row col:(NSInteger)col {
    NSArray *calculatedTiles = self.calculatedTiles;
    PJWPuzzleParameterModel *parameterModel = [PJWPuzzleParameterModel sharedInstance];
    
    BOOL left  = (col == 0                             ) ? NO : [calculatedTiles[row][col - 1] boolValue];
    BOOL right = (col == parameterModel.countWidth - 1 ) ? NO : [calculatedTiles[row][col + 1] boolValue];
    BOOL up    = (row == 0                             ) ? NO : [calculatedTiles[row - 1][col] boolValue];
    BOOL down  = (row == parameterModel.countHeight - 1) ? NO : [calculatedTiles[row + 1][col] boolValue];
    
    return @(left || right || up || down);
}


- (NSSet *)freeNeighborsForTileView:(PJWTileImageView *)tileView {
    PJWTileModel *tileModel = tileView.tileModel;
    
    NSInteger row = tileModel.row;
    NSInteger col = tileModel.col;
    
    NSMutableSet *result = [NSMutableSet new];
    
    if ([self isFreeNeighborForTileView:tileView withRow:row-1 col:col]) {
        [result addObject:self.tiles[row-1][col]];
        [tileView.tileModel.linkedTileHashTable unionHashTable:[self.tiles[row-1][col] tileModel].linkedTileHashTable];
    }
    if ([self isFreeNeighborForTileView:tileView withRow:row+1 col:col]) {
        [result addObject:self.tiles[row+1][col]];
        [tileView.tileModel.linkedTileHashTable unionHashTable:[self.tiles[row+1][col] tileModel].linkedTileHashTable];

    }
    if ([self isFreeNeighborForTileView:tileView withRow:row col:col-1]) {
        [result addObject:self.tiles[row][col-1]];
        [tileView.tileModel.linkedTileHashTable unionHashTable:[self.tiles[row][col-1] tileModel].linkedTileHashTable];

    }
    if ([self isFreeNeighborForTileView:tileView withRow:row col:col+1]) {
        [result addObject:self.tiles[row][col+1]];
        [tileView.tileModel.linkedTileHashTable unionHashTable:[self.tiles[row][col+1] tileModel].linkedTileHashTable];
    }
    
    return result;
}

- (BOOL)isFreeNeighborForTileView:(PJWTileImageView *)tileView withRow:(NSInteger)row col:(NSInteger)col {
    CGFloat magneticDelta = 40;
    
    PJWPuzzleParameterModel *parameterModel = [PJWPuzzleParameterModel sharedInstance];
    PJWTileModel *tileModel = tileView.tileModel;
    
//side/corner tile
    if (row < 0 || row >= parameterModel.countHeight || col < 0 || col >= parameterModel.countWidth) {
        return NO;
    }

    PJWTileImageView *neighborTileView = self.tiles[row][col];
    
//already in segment
    if ([tileModel.linkedTileHashTable containsObject:neighborTileView]) {
        return NO;
    }
    
    CGPoint tileCenter = tileView.center;
    CGPoint neighborCenter = neighborTileView.center;

    CGFloat deltaWidthAxis = fabs(tileCenter.x - neighborCenter.x);
    CGFloat deltaWidthNeighbor = fabs(deltaWidthAxis - parameterModel.anchorWidth);
    
    CGFloat deltaHeightAxis = fabs(tileCenter.y - neighborCenter.y);
    CGFloat deltaHeightNeighbor = fabs(deltaHeightAxis - parameterModel.anchorHeight);
    
//width neighbor
    if (row == tileModel.row) {
        if (deltaHeightAxis < magneticDelta && deltaWidthNeighbor < magneticDelta) {
            NSInteger nextCol = col - tileModel.col;
            NSInteger sign = (neighborCenter.x > tileCenter.x) ? 1: -1;
            
            if ((sign * nextCol) == 1) {
                return YES;
            }
        }
    }
    
//height neighbor
    if (col == tileModel.col) {
        if (deltaWidthAxis < magneticDelta && deltaHeightNeighbor < magneticDelta) {
            NSInteger nextRow = row - tileModel.row;
            NSInteger sign = (neighborCenter.y > tileCenter.y) ? 1: -1;
            
            if ((sign * nextRow) == 1) {
                return YES;
            }
        }
        
    }
    
    return NO;
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
