//
//  PJWTileModel.h
//  TENJigSawCutter
//
//  Created by 444ten on 8/15/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TENMacros.h"

@interface PJWTileModel : NSObject
@property (nonatomic, assign)   NSInteger   row;
@property (nonatomic, assign)   NSInteger   col;

@property (nonatomic, assign)   BOOL        isSide;
@property (nonatomic, assign)   BOOL        isBorderFix;
@property (nonatomic, assign)   BOOL        isGhostFix;

@property (nonatomic, strong)   UIBezierPath    *bezierPath;
@property (nonatomic, assign)   UIEdgeInsets    bezierInsets;

@property (nonatomic, strong)   NSValue         *anchor;
@property (nonatomic, strong)   NSHashTable     *linkedTileHashTable;

- (instancetype)initWithRow:(NSUInteger)row column:(NSInteger)col;

@end
