//
//  PJWCropImageView.h
//  TENJigSawCutter
//
//  Created by 444ten on 8/12/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PJWTileModel.h"

@interface PJWCropImageView : UIImageView

- (void)cropImageForTileModel:(PJWTileModel *)tileModel;

@end
