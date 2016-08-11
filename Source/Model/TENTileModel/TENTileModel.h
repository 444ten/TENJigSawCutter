//
//  TENTileModel.h
//  TENJigSawCutter
//
//  Created by 444ten on 8/9/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TENMacros.h"
#import "PJWTileImageView.h"

typedef NS_ENUM(NSUInteger, PJWTileTypeMask) {
    PJWTileTypeUp       = 1 << 0,
    PJWTileTypeRight    = 1 << 1,
    PJWTileTypeDown     = 1 << 2,
    PJWTileTypeLeft     = 1 << 3
};

@interface TENTileModel : NSObject
@property (nonatomic, assign)   NSInteger   row;
@property (nonatomic, assign)   NSInteger   col;

@property (nonatomic, strong)   NSValue *upLeft;
@property (nonatomic, strong)   NSValue *upRight;
@property (nonatomic, strong)   NSValue *downRight;
@property (nonatomic, strong)   NSValue *downLeft;

@property (nonatomic, strong)   NSValue *center;

@property (nonatomic, assign)   PJWTileTypeMask tileType;

@property (nonatomic, strong)   PJWTileImageView *imageView;

- (instancetype)initWithRow:(NSUInteger)row column:(NSInteger)col;

- (void)setup;

@end
