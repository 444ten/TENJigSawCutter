//
//  PJWSegmentModel.m
//  TENJigSawCutter
//
//  Created by 444ten on 8/19/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import "PJWSegmentModel.h"

@interface PJWSegmentModel ()
@property (nonatomic, strong)   PJWTileImageView    *tileView;

@end

@implementation PJWSegmentModel

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)initWithTileView:(PJWTileImageView *)tileView {
    self = [super init];
    if (self) {
        self.tileView = tileView;
//        [self setupWithTileView:(PJWTileImageView )];
    }
    
    return self;
}

#pragma mark -
#pragma mark Private Methods

- (void)setupWithTileView {
    
}


@end
