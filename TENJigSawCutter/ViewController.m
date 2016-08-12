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
    parameterModel.countWidth = 4;
    parameterModel.overlapRatioWidth = 0.7;
    
    parameterModel.fullHeight = 700.f;
    parameterModel.countHeight = 3;
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
    
    for (NSArray *rowArray in self.tiles.tiles) {
        for (TENTileModel *tileModel in rowArray) {
            UIImageView *imageView = tileModel.imageView;
            
            imageView.userInteractionEnabled = YES;
            
            [imageView addGestureRecognizer:[self panRecognizer]];
            [imageView addGestureRecognizer:[self tapRecognizer]];
            //        [imageView addGestureRecognizer:[self longPressRecognizer]];
            
            
            CGPoint center = CGPointFromValue(tileModel.anchor);
            center.x += (1024. - self.parameterModel.fullWidth) / 2.0;
            center.y += ( 768. - self.parameterModel.fullHeight) / 2.0;
            
            imageView.center = center;
            
            [rootView addSubview:imageView];
        }
    }
}

- (UIPanGestureRecognizer *)panRecognizer {
    UIPanGestureRecognizer *result = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(panAction:)];
    result.minimumNumberOfTouches = 1;
    result.maximumNumberOfTouches = 2;
    
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
    
    PJWTileImageView *recognizerView = (PJWTileImageView *)recognizer.view;
    
    [self.view bringSubviewToFront:recognizerView];
    
    CGPoint translation = [recognizer translationInView:self.view];
    recognizerView.center = CGPointMake(recognizerView.center.x + translation.x,
                                         recognizerView.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Stop");
        [self searchNeighborForImageView:recognizerView];
    }
}

- (void)searchNeighborForImageView:(PJWTileImageView *)tileImageView {
    for (NSArray *rowArray in self.tiles.tiles) {
        for (TENTileModel *tileModel in rowArray) {
            PJWTileImageView *imageView = tileModel.imageView;
            
            if (tileImageView != imageView) {
                CGPoint center = imageView.center;
                
                BOOL isNeighbor = [self isNeighborDragView:tileImageView andView:imageView];
                if (isNeighbor) {
                    [self dragView:tileImageView moveToView:imageView];
                    NSLog(@"[%ld, %ld] -> center(%f, %f)", (long)tileModel.row, (long)tileModel.col, center.x, center.y);
                }
            }
        }
    }
}

- (void)dragView:(PJWTileImageView *)dragView moveToView:(PJWTileImageView *)view {
    CGPoint dragViewCenter = view.center;
    
//width drag
    if (dragView.row == view.row) {
        dragViewCenter.x += (dragView.col - view.col) * self.parameterModel.anchorWidth;
    }
    
//height drag
    if (dragView.col == view.col) {
        dragViewCenter.y += (dragView.row - view.row) * self.parameterModel.anchorHeight;
    }
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         dragView.center = dragViewCenter;
                     }];
}

- (BOOL)isNeighborDragView:(PJWTileImageView *)dragView andView:(PJWTileImageView *)view {
    CGFloat magneticDelta = 40;
    
    CGPoint dragViewCenter = dragView.center;
    CGPoint viewCenter = view.center;
    
    CGFloat deltaWidthAxis = fabsf(dragViewCenter.x - viewCenter.x);
    CGFloat deltaWidthNeighbor = fabsf(deltaWidthAxis - self.parameterModel.anchorWidth);

    CGFloat deltaHeightAxis = fabsf(dragViewCenter.y - viewCenter.y);
    CGFloat deltaHeightNeighbor = fabsf(deltaHeightAxis - self.parameterModel.anchorHeight);

//height neighbor
    if (deltaWidthAxis < magneticDelta && deltaHeightNeighbor < magneticDelta) {
        if (view.col == dragView.col) {
            NSInteger nextRow = view.row - dragView.row;
            NSInteger sign = (viewCenter.y > dragViewCenter.y) ? 1: -1;
            if ((sign * nextRow) == 1) {
                return YES;
            }
        }
    }
    
//width neighbor
    if (deltaHeightAxis < magneticDelta && deltaWidthNeighbor < magneticDelta) {
        if (view.row == dragView.row) {
            NSInteger nextCol = view.col - dragView.col;
            NSInteger sign = (viewCenter.x > dragViewCenter.x) ? 1: -1;
            if ((sign * nextCol) == 1) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (UILongPressGestureRecognizer *)longPressRecognizer {
    UILongPressGestureRecognizer *result = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(longPressAction:)];
    result.minimumPressDuration = 0.1;
    
    return result;
}

- (void)longPressAction:(UILongPressGestureRecognizer *)recognizer {
    [self.view bringSubviewToFront:recognizer.view];
}

@end
