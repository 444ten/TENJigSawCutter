//
//  ViewController.m
//  TENJigSawCutter
//
//  Created by 444ten on 8/5/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import "ViewController.h"

#import "PJWPuzzleParameterModel.h"
#import "TENTiles.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *originalImageView;

@property (nonatomic, strong)   PJWPuzzleParameterModel  *parameterModel;
@property (nonatomic, strong)   TENTiles        *tiles;

@property (nonatomic, assign)   BOOL    ghostPresent;

@end

@implementation ViewController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupParameterModel];
    
    self.tiles = [TENTiles new];
    
    self.originalImageView.image = self.parameterModel.originImage;
    self.ghostPresent = NO;

    [self addTilesOnView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark -
#pragma mark Accessors
- (void)setGhostPresent:(BOOL)ghostPresent {
    _ghostPresent = ghostPresent;
    
    self.originalImageView.alpha = ghostPresent ? 0.3 : 0.0;
}

#pragma mark -
#pragma mark TENCornerModel

- (void)setupParameterModel {
    PJWPuzzleParameterModel *parameterModel = [PJWPuzzleParameterModel sharedInstance];
    parameterModel.fullWidth = 900.f;
    parameterModel.countWidth = 20;
    parameterModel.overlapRatioWidth = 0.7;
    
    parameterModel.fullHeight = 700.f;
    parameterModel.countHeight = 15;
    parameterModel.overlapRatioHeight = 0.7;
    
    [parameterModel setup];
    
    self.parameterModel = parameterModel;
}

#pragma mark -
#pragma mark Interface Handling

- (IBAction)tapOriginalImage:(UITapGestureRecognizer *)sender {
//    [self.view bringSubviewToFront:sender.view];
}

- (IBAction)onGhost:(UIButton *)sender {
    self.ghostPresent = !self.ghostPresent;
}

#pragma mark -
#pragma mark Private Methods

- (void)addTilesOnView {
    UIView *rootView = self.view;
    
    for (TENTileModel *tileModel in self.tiles.tiles) {
//        UIImageView *imageView = tileModel.imageView;
        UIImageView *imageView = tileModel.simpleImageView;
        
        imageView.userInteractionEnabled = YES;

        [imageView addGestureRecognizer:[self panRecognizer]];
        [imageView addGestureRecognizer:[self tapRecognizer]];
        
        CGPoint center = CGPointFromValue(tileModel.anchor);
        center.x += (1024. - self.parameterModel.fullWidth) / 2.0;
        center.y += ( 768. - self.parameterModel.fullHeight) / 2.0;
        
        imageView.center = center;
        
        [rootView addSubview:imageView];
    }    
}

- (UIPanGestureRecognizer *)panRecognizer {
    UIPanGestureRecognizer *result = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(panAction:)];
    [result setMinimumNumberOfTouches:1];
    [result setMaximumNumberOfTouches:1];
    
    return result;
}

- (UITapGestureRecognizer *)tapRecognizer {
    UITapGestureRecognizer *result = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(tapAction:)];
    return result;
}

- (void)tapAction:(UITapGestureRecognizer *)recognizer {
    [self.view bringSubviewToFront:recognizer.view];
}

- (void)panAction:(UIPanGestureRecognizer *)recognizer {
//    NSLog(@"Coordinate...");
    
    UIView *recognizerView = recognizer.view;
    
    [self.view bringSubviewToFront:recognizerView];
    
    CGPoint translation = [recognizer translationInView:self.view];
    recognizerView.center = CGPointMake(recognizerView.center.x + translation.x,
                                         recognizerView.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Stop");
    }
}

@end
