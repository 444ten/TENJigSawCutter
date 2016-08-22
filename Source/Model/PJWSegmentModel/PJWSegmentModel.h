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
@property (nonatomic, assign)   UIEdgeInsets    segmentInsets;

- (instancetype)initWithTileView:(PJWTileImageView *)tileView;

@end
