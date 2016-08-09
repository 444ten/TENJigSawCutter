//
//  TENTiles.m
//  TENJigSawCutter
//
//  Created by 444ten on 8/9/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import "TENTiles.h"

@implementation TENTiles

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tiles = [NSMutableArray new];
    }
    
    return self;
}

#pragma mark -
#pragma mark Public Methods

- (void)setup {
    TENCornerModel *cornerModel = self.cornerModel;
    NSArray *cornerPoints = cornerModel.cornerPoints;
    
    NSMutableArray *tiles = self.tiles;
    
    for (NSInteger row = 0; row < cornerModel.countHeight; row++) {
        
        for (NSInteger col = 0; col < cornerModel.countWidth; col++) {
            TENTileModel *tileModel = [TENTileModel new];
            
            tileModel.upLeft    = cornerPoints[row    ][col    ];
            tileModel.upRight   = cornerPoints[row    ][col + 1];
            tileModel.downRight = cornerPoints[row + 1][col + 1];
            tileModel.downLeft  = cornerPoints[row + 1][col    ];
            
            [tiles addObject:tileModel];
        }
    }
}


@end
