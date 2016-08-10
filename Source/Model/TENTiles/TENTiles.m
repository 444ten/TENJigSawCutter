//
//  TENTiles.m
//  TENJigSawCutter
//
//  Created by 444ten on 8/9/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import "TENTiles.h"

#import "PJWPuzzleParameterModel.h"
#import "PJWOffsetCornerModel.h"

@interface TENTiles ()

@end

@implementation TENTiles

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tiles = [NSMutableArray new];
        [self setup];
    }
    
    return self;
}

#pragma mark -
#pragma mark Private Methods

- (void)setup {
    PJWPuzzleParameterModel *parameterModel = [PJWPuzzleParameterModel sharedInstance];

    NSMutableArray *tiles = self.tiles;
    
    for (NSInteger row = 0; row < parameterModel.countHeight; row++) {
        
        for (NSInteger col = 0; col < parameterModel.countWidth; col++) {
            TENTileModel *tileModel = [[TENTileModel alloc] initWithRow:row column:col];
            
            [self setCornerPointFor:tileModel];
            
            [tileModel setup];
            
            if (0 == col) {
                tileModel.tileType |= PJWTileTypeLeft;
            } else if (parameterModel.countWidth - 1 == col) {
                tileModel.tileType |= PJWTileTypeRight;
            }
            
            if (0 == row) {
                tileModel.tileType |= PJWTileTypeUp;
            } else if (parameterModel.countHeight - 1 == row) {
                tileModel.tileType |= PJWTileTypeDown;
            }
            
            
            [tiles addObject:tileModel];
        }
    }
}

- (void)setCornerPointFor:(TENTileModel *)tileModel {
    PJWPuzzleParameterModel *parameterModel = [PJWPuzzleParameterModel sharedInstance];

    CGFloat x = tileModel.col * (parameterModel.baseWidth + parameterModel.overlapWidth);
    CGFloat y = tileModel.row * (parameterModel.baseHeight + parameterModel.overlapHeight);
    
    tileModel.upLeft    = NSValueWithPoint(x                            , y                             );
    tileModel.upRight   = NSValueWithPoint(x + parameterModel.sliceWidth, y                             );
    tileModel.downRight = NSValueWithPoint(x + parameterModel.sliceWidth, y + parameterModel.sliceHeight);
    tileModel.downLeft  = NSValueWithPoint(x                            , y + parameterModel.sliceHeight);
}


@end
