//
//  ViewController.m
//  TENJigSawCutter
//
//  Created by 444ten on 8/5/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import "ViewController.h"

#import "PJWPuzzleParameterModel.h"
#import "PJWTilesModel.h"
#import "PJWTileImageView.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *originalImageView;

@property (nonatomic, strong)   PJWPuzzleParameterModel *parameterModel;
@property (nonatomic, strong)   NSArray                 *tiles;

@property (nonatomic, assign)   BOOL    ghostPresent;

@end

@implementation ViewController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupParameterModel];
    
    self.tiles = [PJWTilesModel new].tiles;
    
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
    
    for (NSArray *rowArray in self.tiles) {
        for (PJWTileImageView *tileView in rowArray) {
            
            tileView.userInteractionEnabled = YES;
            
            [tileView addGestureRecognizer:[self panRecognizer]];
            [tileView addGestureRecognizer:[self tapRecognizer]];
            //        [imageView addGestureRecognizer:[self longPressRecognizer]];
            
            
            CGPoint center = CGPointFromValue(tileView.tileModel.anchor);
            center.x += (1024. - self.parameterModel.fullWidth) / 2.0;
            center.y += ( 768. - self.parameterModel.fullHeight) / 2.0;
            
            tileView.center = center;
            
            [rootView addSubview:tileView];
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
    PJWTileImageView *recognizerView = (PJWTileImageView *)recognizer.view;
    UIView *rootView = self.view;
    
    [recognizerView moveSegmentWithOffset:[recognizer translationInView:rootView]];
    
    [recognizer setTranslation:CGPointZero inView:rootView];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Stop");
        [self searchNeighborForImageView:recognizerView];
    }
}

- (void)searchNeighborForImageView:(PJWTileImageView *)tileImageView {
    BOOL allDoneNow = NO;
    
    for (NSArray *rowArray in self.tiles) {
        for (PJWTileImageView *view in rowArray) {
            
            if (tileImageView != view) {
                
                if ([tileImageView isNeighborToView:view]) {
                    [tileImageView stickToView:view];
                    
                    allDoneNow = YES;
                    break;
                }
            }
        }
        
        if (allDoneNow) {
            break;
        }
    }
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
