//
//  PJWPuzzleParameterModel.m
//  TENJigSawCutter
//
//  Created by 444ten on 8/10/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import "PJWPuzzleParameterModel.h"

#import "UIImage+Resize.h"

@interface PJWPuzzleParameterModel ()
@property (nonatomic, assign) CGFloat widthOffset;
@property (nonatomic, assign) CGFloat heightOffset;

@end


@implementation PJWPuzzleParameterModel

@dynamic fullWidth;
@dynamic fullHeight;

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
    }
    
    return self;
}

#pragma mark -
#pragma mark Accessors

- (CGFloat)fullWidth {
    return self.ghostRect.size.width;
}

- (CGFloat)fullHeight {
    return self.ghostRect.size.height;
}

- (NSInteger)countWidth {
    return [[PJWConstants presetCutterType][self.cutterType][0] integerValue];
}

- (NSInteger)countHeight {
    return [[PJWConstants presetCutterType][self.cutterType][1] integerValue];
}

#pragma mark -
#pragma mark Public Methods

- (void)setup {
    [self setupGameField];
    [self calculateSlice];
    
    [self setupOriginImage];
    
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
    @synchronized (self.originImage) {    
        UIImage *selectedImage = [UIImage imageNamed:kImageName];
        UIImage *originImage = [selectedImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill
                                                                   bounds:self.ghostRect.size
                                                     interpolationQuality:kCGInterpolationHigh];
        CGSize originSize = originImage.size;
        
        self.originImage = originImage;
        
        UIGraphicsBeginImageContextWithOptions(originSize, NO, 0.0f);
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGRect area = CGRectMake(0, 0, originSize.width, originSize.height);
        
        CGContextScaleCTM(ctx, 1, -1);
        CGContextTranslateCTM(ctx, 0, -area.size.height);
        CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
        CGContextSetAlpha(ctx, 0.3);
        CGContextDrawImage(ctx, area, originImage.CGImage);
        
        self.ghostImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
}

- (void)setupGameField {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    CGRect gameRect = CGRectMake(self.menuWidth, 0.0,
                               screenSize.width - self.menuWidth - self.trayWidth, screenSize.height);
    
    CGFloat doubleGhostInset = self.isLargerPieces ? kPJWDoubleGhostInsetSmall : kPJWDoubleGhostInsetBig;
    
    CGFloat ghostWidth = gameRect.size.width - doubleGhostInset;
    CGFloat ghostHeight = ghostWidth / 4 * 3;
    
    if (ghostHeight > (screenSize.height - doubleGhostInset)) {
        ghostHeight = screenSize.height - doubleGhostInset;
        ghostWidth = ghostHeight * 4 / 3;
    }
    
    CGRect ghostRect = CGRectMake(0, 0, ghostWidth, ghostHeight);
    
    
    self.gameRect = gameRect;
    self.ghostRect = ghostRect;
    
    self.widthOffset  = (gameRect.size.width  - ghostWidth) / 2;
    self.heightOffset = (gameRect.size.height - ghostHeight) / 2;
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
