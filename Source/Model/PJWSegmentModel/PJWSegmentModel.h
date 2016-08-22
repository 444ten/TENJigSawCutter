//
//  PJWSegmentModel.h
//  TENJigSawCutter
//
//  Created by 444ten on 8/19/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PJWTileImageView.h"

@interface PJWSegmentModel : NSObject
@property (nonatomic, strong)   PJWTileImageView *leftTile;
@property (nonatomic, strong)   PJWTileImageView *rightTile;
@property (nonatomic, strong)   PJWTileImageView *upTile;
@property (nonatomic, strong)   PJWTileImageView *downTile;

- (instancetype)initWithTileView:(PJWTileImageView *)tileView;

@end
