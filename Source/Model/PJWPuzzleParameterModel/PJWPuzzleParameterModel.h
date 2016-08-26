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

@property (nonatomic, assign)   CGFloat     menuWidth;
@property (nonatomic, assign)   CGFloat     trayWidth;
@property (nonatomic, assign)   CGRect      gameRect;
@property (nonatomic, assign)   CGRect      ghostRect;

@property (nonatomic, assign)   BOOL    ghostPresent;
@property (nonatomic, assign)   BOOL    borderPresent;
@property (nonatomic, assign)   BOOL    edgesPresent;

@property (nonatomic, strong)   UIImage     *originImage;
@property (nonatomic, strong)   UIImage     *ghostImage;

//
@property (nonatomic, assign)   CGRect          gameFieldRect;
@property (nonatomic, assign)   UIEdgeInsets    gameFieldLimit;

@property (nonatomic, strong)   NSNumber    *cutterType;

@property (nonatomic, readonly) CGFloat     fullWidth;
@property (nonatomic, readonly) NSInteger   countWidth;
@property (nonatomic, assign)   CGFloat     overlapRatioWidth;

@property (nonatomic, readonly) CGFloat     fullHeight;
@property (nonatomic, readonly) NSInteger   countHeight;
@property (nonatomic, assign)   CGFloat     overlapRatioHeight;


@property (nonatomic, assign)   CGFloat     overlapWidth;
@property (nonatomic, assign)   CGFloat     baseWidth;
@property (nonatomic, assign)   CGFloat     sliceWidth;
@property (nonatomic, assign)   CGFloat     anchorWidth;

@property (nonatomic, assign)   CGFloat     overlapHeight;
@property (nonatomic, assign)   CGFloat     baseHeight;
@property (nonatomic, assign)   CGFloat     sliceHeight;
@property (nonatomic, assign)   CGFloat     anchorHeight;

@property (nonatomic, assign)   CGFloat     deltaGhost;

@property (nonatomic, strong)   PJWOffsetCornerModel    *offsetCornerModel;
@property (nonatomic, strong)   PJWOffsetSideModel      *offsetSideModel;

@property (nonatomic, strong)   UIImage *lastImage;

+ (instancetype)sharedInstance;

- (void)setup;

@end
