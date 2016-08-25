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

@dynamic countWidth;
@dynamic countHeight;

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
#pragma mark Accessors

- (NSInteger)countWidth {
    return [[PJWConstants presetCutterType][self.cutterType][0] integerValue];
}

- (NSInteger)countHeight {
    return [[PJWConstants presetCutterType][self.cutterType][1] integerValue];
}

#pragma mark -
#pragma mark Public Methods

- (void)setup {
    [self calculateSlice];
    [self setupGameField];
    self.offsetCornerModel = [PJWOffsetCornerModel new];
    self.offsetSideModel = [PJWOffsetSideModel new];
    
    self.ghostPresent = NO;
    self.borderPresent = NO;
    self.edgesPresent = NO;
    
    self.deltaGhost = 40.;
}

#pragma mark -
#pragma mark Private Methods

- (void)setupOriginImage {
    self.originImage = [UIImage imageNamed:kImageName];
    
    UIGraphicsBeginImageContextWithOptions(self.originImage.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.originImage.size.width, self.originImage.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, 0.3);
    
    CGContextDrawImage(ctx, area, self.originImage.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    self.ghostImage = newImage;
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

- (void)setupGameField {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    UIEdgeInsets gameFieldLimit = UIEdgeInsetsMake(0., 60., 0., 0.);
    
    self.gameFieldLimit = gameFieldLimit;
    
    CGRect gameFieldRect = CGRectMake(gameFieldLimit.left,
                                      gameFieldLimit.top,
                                      screenSize.width  - gameFieldLimit.left - gameFieldLimit.right,
                                      screenSize.height - gameFieldLimit.top   - gameFieldLimit.bottom );
    self.gameFieldRect = gameFieldRect;
}

@end
