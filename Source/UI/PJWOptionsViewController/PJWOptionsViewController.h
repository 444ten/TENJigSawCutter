//
//  PJWOptionsViewController.h
//  TENJigSawCutter
//
//  Created by 444ten on 8/23/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PJWOptionsViewControllerProtocol
- (void)startGame;

@end

@interface PJWOptionsViewController : UIViewController
@property (nonatomic, weak) id<PJWOptionsViewControllerProtocol>  delegate;


@end
