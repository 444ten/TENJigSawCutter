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

@property (nonatomic, strong)   PJWTilesModel           *tilesModel;
@property (nonatomic, strong)   NSSet                   *tileSet;

@property (nonatomic, assign)   BOOL    ghostPresent;

@property (nonatomic, strong)   UIView  *testView;

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
    
    self.tilesModel = [PJWTilesModel new];
    self.tileSet = self.tilesModel.tileSet;
    
    self.ghostPresent = NO;
    
//    [self setupTestView];
    
    [self addTilesOnView];
}

- (void)setupTestView {
    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 980, 740)];
    testView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
    [testView addGestureRecognizer:[self panRecognizerTest]];
    [testView addGestureRecognizer:[self tapRecognizer]];
    
    self.testView = testView;

    [self.view addSubview:testView];
}

- (UIPanGestureRecognizer *)panRecognizerTest {
    UIPanGestureRecognizer *result = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(panActionTest:)];
    result.minimumNumberOfTouches = 1;
    result.maximumNumberOfTouches = 2;
    
    return result;
}

- (void)panActionTest:(UIPanGestureRecognizer *)recognizer {
    UIView *view = recognizer.view;
    UIView *rootView = self.view;

    CGPoint translation = [recognizer translationInView:rootView];
    
    view.center = CGPointMake(view.center.x + translation.x,
                              view.center.y + translation.y);

    [recognizer setTranslation:CGPointZero inView:rootView];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Stop");
    }
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
//        [self.testView addSubview:tileView];
        
    }
}

- (UIPanGestureRecognizer *)panRecognizer {
    UIPanGestureRecognizer *result = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(panAction:)];
    result.minimumNumberOfTouches = 1;
    result.maximumNumberOfTouches = 2;
    
    return result;
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

- (UITapGestureRecognizer *)tapRecognizer {
    UITapGestureRecognizer *result = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(tapAction:)];
    return result;
}

- (void)tapAction:(UITapGestureRecognizer *)recognizer {
    [self.view bringSubviewToFront:recognizer.view];
}


- (void)searchNeighborForView:(PJWTileImageView *)tileView {
    NSMutableSet *linkedSet = [NSMutableSet setWithSet:tileView.tileModel.linkedTileHashTable.setRepresentation];
    
    NSSet *tileSet = self.tileSet;
    
    NSMutableSet *freeNeighborSet = [NSMutableSet new];
    
    NSEnumerator *enumerator = [linkedSet objectEnumerator];
    PJWTileImageView *view;
    while (view = [enumerator nextObject]) {
        if ([self.tilesModel.calculatedTiles[view.tileModel.row][view.tileModel.col] boolValue]) {
            [freeNeighborSet unionSet:[view freeNeighborsFromSet:tileSet]];            
        }
    }

    enumerator = [freeNeighborSet objectEnumerator];
    while (view = [enumerator nextObject]) {
        [tileView stickToView:view];
    }
    
    [self.tilesModel updateCalculatedTilesWithView:tileView];
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
