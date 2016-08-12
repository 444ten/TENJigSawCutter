//
//  PJWPuzzleParameterModel.m
//  TENJigSawCutter
//
//  Created by 444ten on 8/10/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import "PJWPuzzleParameterModel.h"

//static NSString * const kImageName = @"04.jpg";
//static NSString * const kImageName = @"200x200";
static NSString * const kImageName = @"900x700.jpg";

@implementation PJWPuzzleParameterModel

#pragma mark -
#pragma mark Class Methods

+ (instancetype)sharedInstance {
    static PJWPuzzleParameterModel *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    
    return sharedInstance;
}

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupOriginImage];
    }
    
    return self;
}

#pragma mark -
#pragma mark Public Methods

- (void)setup {
    [self calculateSlice];
    self.offsetCornerModel = [PJWOffsetCornerModel new];
    self.offsetSideModel = [PJWOffsetSideModel new];
}

#pragma mark -
#pragma mark Private Methods


- (void)setupOriginImage {
    self.originImage = [UIImage imageNamed:kImageName];
}

- (void)calculateSlice {
    self.baseWidth = self.fullWidth / (self.countWidth + self.overlapRatioWidth * (self.countWidth + 1));
    self.overlapWidth = self.overlapRatioWidth * self.baseWidth;
    self.sliceWidth = 2 * self.overlapWidth + self.baseWidth;
    self.anchorWidth = self.baseWidth + self.overlapWidth;
    
    self.baseHeight = self.fullHeight / (self.countHeight + self.overlapRatioHeight * (self.countHeight + 1));
    self.overlapHeight = self.overlapRatioHeight * self.baseHeight;
    self.sliceHeight = 2 * self.overlapHeight + self.baseHeight;
    self.anchorHeight = self.baseHeight + self.overlapHeight;
}


@end
