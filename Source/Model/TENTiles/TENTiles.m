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
        
        NSMutableArray *rowArray = [NSMutableArray new];
        
        for (NSInteger col = 0; col < parameterModel.countWidth; col++) {
            TENTileModel *tileModel = [[TENTileModel alloc] initWithRow:row column:col];
            
            
            [tileModel setup];
            
            [rowArray addObject:tileModel];
        }
        
        [tiles addObject:rowArray];
    }
}

@end
