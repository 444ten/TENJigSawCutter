//
//  ViewController.m
//  TENJigSawCutter
//
//  Created by 444ten on 8/5/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import "ViewController.h"

#import "TENCornerModel.h"
#import "TENTiles.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *originalImageView;

@property (nonatomic, strong)   TENCornerModel  *cornerModel;
@property (nonatomic, strong)   TENTiles        *tiles;

@property (nonatomic, assign)   BOOL    ghostPresent;

@end

@implementation ViewController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCornerModel];
    [self setupTiles];
    
    UIImage *image = [UIImage imageNamed:kImageName];
    
    self.originalImageView.image = image;
    self.ghostPresent = YES;

    [self addTilesOnView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark -
#pragma mark Accessors
-   (void)setGhostPresent:(BOOL)ghostPresent {
    if (_ghostPresent != ghostPresent) {
        _ghostPresent = ghostPresent;
        
        self.originalImageView.alpha = ghostPresent ? 0.3 : 0.0;
    }
}

#pragma mark -
#pragma mark TENCornerModel

- (void)setupCornerModel {
    TENCornerModel *cornerModel = [TENCornerModel new];

    cornerModel.fullWidth = 900.f;
    cornerModel.fullHeight = 700.f;
    cornerModel.countWidth = 3;
    cornerModel.countHeight = 3;
    
    [cornerModel setup];
    
    self.cornerModel = cornerModel;
}

- (void)setupTiles {
    TENTiles *tiles = [TENTiles new];
    
    tiles.fullWidth = 900.f;
    tiles.countWidth = 3;
    tiles.overlapRatioWidth = 0.5;
    
    tiles.fullHeight = 700.f;
    tiles.countHeight = 3;
    tiles.overlapRatioHeight = 0.5;
    
    [tiles setup];
    
    self.tiles = tiles;
}

#pragma mark -
#pragma mark Interface Handling

- (IBAction)tapOriginalImage:(UITapGestureRecognizer *)sender {
    [self.view bringSubviewToFront:sender.view];
}

- (IBAction)onGhost:(UIButton *)sender {
    self.ghostPresent = !self.ghostPresent;
}

#pragma mark -
#pragma mark Private Methods

- (void)addTilesOnView {
    UIView *rootView = self.view;
    
    for (TENTileModel *tileModel in self.tiles.tiles) {
        UIImageView *imageView = tileModel.imageView;
        
        imageView.userInteractionEnabled = YES;

        [imageView addGestureRecognizer:[self panRecognizer]];
        [imageView addGestureRecognizer:[self tapRecognizer]];
        
        imageView.center = CGPointFromValue(tileModel.center);
        
        [rootView addSubview:tileModel.imageView];
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
    NSLog(@"Coordinate...");
    
    UIView *recognizerView = recognizer.view;
    
    [self.view bringSubviewToFront:recognizerView];
    
    CGPoint translation = [recognizer translationInView:self.view];
    recognizerView.center = CGPointMake(recognizerView.center.x + translation.x,
                                         recognizerView.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
}

@end
