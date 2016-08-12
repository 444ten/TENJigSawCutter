//
//  PJWCropImageView.h
//  TENJigSawCutter
//
//  Created by 444ten on 8/12/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PJWCropImageView : UIImageView
@property (nonatomic, strong)   UIBezierPath *bezierPath;

- (void)cropImageForRow:(NSInteger)row col:(NSInteger)col;

@end
