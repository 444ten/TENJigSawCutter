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
@property (strong, nonatomic) IBOutlet UIImageView *centerImageView;
@property (strong, nonatomic) IBOutlet UIImageView *originalImageView;

@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;

@property (nonatomic, strong) TENCornerModel *cornerModel;

@property (nonatomic, strong)   TENTiles    *tiles;

@end

@implementation ViewController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCornerModel];
    [self setupTiles];
    
    UIImage *image = [UIImage imageNamed:kImageName];
    
//    self.centerImageView.image = image;
    self.originalImageView.image = image;

    [self addTilesOnView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark -
#pragma mark TENCornerModel

- (void)setupCornerModel {
    TENCornerModel *cornerModel = [TENCornerModel new];

    cornerModel.fullWidth = 200.f;
    cornerModel.fullHeight = 200.f;
    cornerModel.countWidth = 3;
    cornerModel.countHeight = 4;
    
    [cornerModel setup];
    
    self.cornerModel = cornerModel;
}

- (void)setupTiles {
    TENTiles *tiles = [TENTiles new];
    tiles.cornerModel = self.cornerModel;
    
    [tiles setup];
    
    self.tiles = tiles;
}

#pragma mark -
#pragma mark Interface Handling

- (IBAction)tapOriginalImage:(UITapGestureRecognizer *)sender {
    [self.view bringSubviewToFront:sender.view];
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
        
        [rootView addSubview:tileModel.imageView];
    }
}

- (UIImageView *)tileViewWithRect:(CGRect)tileRect {
    UIImageView *result = [[UIImageView alloc] initWithImage:[self tileWithRect:tileRect]];
    
//    result.layer.borderWidth = 1.0;
    result.userInteractionEnabled = YES;
    
    [result addGestureRecognizer:[self panRecognizer]];
    [result addGestureRecognizer:[self tapRecognizer]];
        
    return result;
}

- (UIImage *)tileWithRect:(CGRect)tileRect {
    UIImage *originImage = [UIImage imageNamed:kImageName];
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(originImage.CGImage, tileRect);
    
    UIImage *result = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return result;
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
    [self.view bringSubviewToFront:recognizer.view];
    
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
}

@end
