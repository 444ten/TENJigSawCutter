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
@property (nonatomic, strong)   NSSet                   *tileSet;

@property (nonatomic, assign)   BOOL    ghostPresent;

@end

@implementation ViewController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.parameterModel = [PJWPuzzleParameterModel sharedInstance];
    
    self.originalImageView.image = self.parameterModel.originImage;
    
    [self onRestart:nil];
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
#pragma mark Interface Handling

- (IBAction)tapOriginalImage:(UITapGestureRecognizer *)sender {
//    [self.view bringSubviewToFront:sender.view];
}

- (IBAction)onGhost:(UIButton *)sender {
    self.ghostPresent = !self.ghostPresent;
}

- (IBAction)onRestart:(UIButton *)sender {
    for (UIImageView *view in self.tileSet) {
        [view removeFromSuperview];
    }
    
    [self setupParameterModel];
    
    self.tileSet = [PJWTilesModel new].tileSet;
    
    self.ghostPresent = NO;
    
    [self addTilesOnView];
}

#pragma mark -
#pragma mark Private Methods

- (void)setupParameterModel {
    PJWPuzzleParameterModel *parameterModel = [PJWPuzzleParameterModel sharedInstance];
    parameterModel.fullWidth = 900.f;
    parameterModel.countWidth = 20;
    parameterModel.overlapRatioWidth = 0.7;
    
    parameterModel.fullHeight = 700.f;
    parameterModel.countHeight = 15;
    parameterModel.overlapRatioHeight = 0.7;
    
    [parameterModel setup];
}

- (void)addTilesOnView {
    UIView *rootView = self.view;
    
    for (PJWTileImageView *tileView in self.tileSet) {
        
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
    
    [recognizerView moveSegmentWithOffset:[recognizer translationInView:rootView] animated:NO];
    
    [recognizer setTranslation:CGPointZero inView:rootView];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Stop");
        [self searchNeighborForView:recognizerView];
    }
}

- (void)searchNeighborForView:(PJWTileImageView *)tileView {
    NSSet *linkedSet = tileView.tileModel.linkedTileHashTable.setRepresentation;
    
    NSMutableArray *freeNeighbors = [NSMutableArray new];
    
    for (PJWTileImageView *view in linkedSet) {
        [freeNeighbors addObjectsFromArray:[view freeNeighborsFromSet:self.tileSet]];
    }
    
    if (freeNeighbors.count > 0) {
        [tileView stickToView:freeNeighbors[0]];
    }

    for (NSInteger index = 1; index < freeNeighbors.count; index++) {
        [freeNeighbors[index] stickToView:tileView];
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
