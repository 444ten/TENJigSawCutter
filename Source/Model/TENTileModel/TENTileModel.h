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

@interface TENTileModel : NSObject
@property (nonatomic, assign)   NSInteger   row;
@property (nonatomic, assign)   NSInteger   col;

@property (nonatomic, strong)   NSValue *anchor;
@property (nonatomic, strong)   NSHashTable  *linkedTileHashTable;

@property (nonatomic, strong)   PJWTileImageView *imageView;

- (instancetype)initWithRow:(NSUInteger)row column:(NSInteger)col;

- (void)setup;

@end
