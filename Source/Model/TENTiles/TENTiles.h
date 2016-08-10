//
//  TENTiles.h
//  TENJigSawCutter
//
//  Created by 444ten on 8/9/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import "TENTileModel.h"
//#import "TENCornerModel.h"

//static NSString * const kImageName = @"04.jpg";
//static NSString * const kImageName = @"200x200";
static NSString * const kImageName = @"900x700.jpg";

@interface TENTiles : NSObject
@property (nonatomic, strong)   NSMutableArray<TENTileModel *>  *tiles;

@property (nonatomic, assign)   CGFloat     fullWidth;
@property (nonatomic, assign)   CGFloat     fullHeight;
@property (nonatomic, assign)   NSInteger   countWidth;
@property (nonatomic, assign)   NSInteger   countHeight;
@property (nonatomic, assign)   CGFloat     overlapRatioWidth;
@property (nonatomic, assign)   CGFloat     overlapRatioHeight;

//@property (nonatomic, strong)   TENCornerModel  *cornerModel;

- (void)setup;

@end
