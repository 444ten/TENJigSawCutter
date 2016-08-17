//
//  PJWTilesModel.h
//  TENJigSawCutter
//
//  Created by 444ten on 8/15/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PJWTileImageView.h"

@interface PJWTilesModel : NSObject
@property (nonatomic, readonly) NSSet   *tileSet;

@property (nonatomic, strong)   NSMutableArray  *calculatedTiles;

- (void)updateCalculatedTilesWithView:(PJWTileImageView *)view;
- (NSSet *)freeNeighborsForTileView:(PJWTileImageView *)tileView;

@end
