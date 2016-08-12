//
//  PJWPuzzleParameterModel.h
//  TENJigSawCutter
//
//  Created by 444ten on 8/10/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PJWOffsetCornerModel.h"
#import "PJWOffsetSideModel.h"

@interface PJWPuzzleParameterModel : NSObject
@property (nonatomic, strong)   UIImage     *originImage;

@property (nonatomic, assign)   CGFloat     fullWidth;
@property (nonatomic, assign)   NSInteger   countWidth;
@property (nonatomic, assign)   CGFloat     overlapRatioWidth;

@property (nonatomic, assign)   CGFloat     fullHeight;
@property (nonatomic, assign)   NSInteger   countHeight;
@property (nonatomic, assign)   CGFloat     overlapRatioHeight;


@property (nonatomic, assign)   CGFloat     overlapWidth;
@property (nonatomic, assign)   CGFloat     baseWidth;
@property (nonatomic, assign)   CGFloat     sliceWidth;

@property (nonatomic, assign)   CGFloat     overlapHeight;
@property (nonatomic, assign)   CGFloat     baseHeight;
@property (nonatomic, assign)   CGFloat     sliceHeight;

@property (nonatomic, strong)   PJWOffsetCornerModel    *offsetCornerModel;
@property (nonatomic, strong)   PJWOffsetSideModel      *offsetSideModel;

@property (nonatomic, strong)   UIImage *lastImage;

+ (instancetype)sharedInstance;

- (void)setup;

@end
