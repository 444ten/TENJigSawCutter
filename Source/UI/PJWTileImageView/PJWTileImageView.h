//
//  PJWTileImageView.h
//  TENJigSawCutter
//
//  Created by 444ten on 8/11/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PJWTileModel.h"

@interface PJWTileImageView : UIImageView
@property (nonatomic, strong)   PJWTileModel    *tileModel;

- (void)moveToTargetView:(PJWTileImageView *)targetView;

- (void)moveSegmentWithOffset:(CGPoint)offset animated:(BOOL)animated;
- (void)moveSegmentToPoint:(CGPoint)point animated:(BOOL)animated;

- (void)stickToView:(PJWTileImageView *)view;

@end
