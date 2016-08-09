//
//  TENTiles.h
//  TENJigSawCutter
//
//  Created by 444ten on 8/9/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import "TENTileModel.h"
#import "TENCornerModel.h"

@interface TENTiles : NSObject
@property (nonatomic, strong)   NSMutableArray<TENTileModel *>  *tiles;
@property (nonatomic, strong)   TENCornerModel  *cornerModel;

- (void)setup;

@end
