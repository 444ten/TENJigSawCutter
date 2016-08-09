//
//  TENTileModel.h
//  TENJigSawCutter
//
//  Created by 444ten on 8/9/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TENMacros.h"

@interface TENTileModel : NSObject
@property (nonatomic, strong)   NSValue *upLeft;
@property (nonatomic, strong)   NSValue *upRight;
@property (nonatomic, strong)   NSValue *downRight;
@property (nonatomic, strong)   NSValue *downLeft;

@property (nonatomic, strong)   UIImageView *imageView;

- (void)setupImageViewWithOriginImage:(UIImage *)originImage;


@end
