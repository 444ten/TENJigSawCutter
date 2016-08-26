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
#import "PJWSegmentModel.h"

#import "PJWOptionsViewController.h"

@interface ViewController () <PJWOptionsViewControllerProtocol>
@property (nonatomic, strong)   UIImageView             *ghostView;
@property (nonatomic, strong)   UIView                  *gameView;
@property (nonatomic, strong)   UIView                  *puzzleView;

@property (nonatomic, strong)   PJWPuzzleParameterModel *parameterModel;

@property (nonatomic, strong)   PJWTilesModel           *tilesModel;
@property (nonatomic, strong)   NSSet                   *tileSet;

@property (strong, nonatomic) IBOutlet UIButton *edgesButton;

@end

@implementation ViewController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PJWPuzzleParameterModel *parameterModel = [PJWPuzzleParameterModel sharedInstance];

    parameterModel.cutterType = @(4);
    
    parameterModel.menuWidth = 60.;
    parameterModel.trayWidth =  30.; //80
    
    parameterModel.overlapRatioWidth = 0.5;
    parameterModel.overlapRatioHeight = 0.5;
    
    self.parameterModel = parameterModel;

    [self startGame];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark -
#pragma mark Interface Handling

- (IBAction)onGhost:(UIButton *)sender {
    PJWPuzzleParameterModel *parameterModel = self.parameterModel;
    BOOL ghostPresent = !parameterModel.ghostPresent;
    
    self.ghostView.image = ghostPresent ? parameterModel.ghostImage : nil;
    
    if (!ghostPresent) {
        for (PJWTileImageView *obj in self.tileSet) {
            obj.tileModel.isGhostFix = NO;
        }
    }
    
    parameterModel.ghostPresent = ghostPresent;
}

- (IBAction)onEdges:(UIButton *)sender {
    PJWPuzzleParameterModel *parameterModel = self.parameterModel;
    BOOL edgesPresent = !parameterModel.edgesPresent;
    
    [self.edgesButton setTitle: edgesPresent ? @"View All" : @"Edges" forState:UIControlStateNormal];
    
    for (PJWTileImageView *obj in self.tileSet) {
        if (!obj.tileModel.isSide) {
            obj.alpha = edgesPresent ? 0.0 : 1.0;
        }
    }
    
    parameterModel.edgesPresent = edgesPresent;
}

- (IBAction)onBorder:(UIButton *)sender {
    PJWPuzzleParameterModel *parameterModel = self.parameterModel;
    BOOL borderPresent = !parameterModel.borderPresent;
    
    self.ghostView.layer.borderWidth = borderPresent ? 1.0 : 0.0;
    
    if (!borderPresent) {
        for (PJWTileImageView *obj in self.tileSet) {
            obj.tileModel.isBorderFix = NO;
        }
    }

    
    parameterModel.borderPresent = borderPresent;
}

- (IBAction)onShuffle:(UIButton *)sender {
    PJWPuzzleParameterModel *parameterModel = self.parameterModel;
    CGSize gameSize   = parameterModel.gameRect.size;
    CGSize puzzleSize = parameterModel.ghostRect.size;
    
    CGFloat widthOffset  = (gameSize.width  - puzzleSize.width ) / 2;
    CGFloat heightOffset = (gameSize.height - puzzleSize.height) / 2;
    CGFloat halfSliceWidth  = parameterModel.sliceWidth  / 2;
    CGFloat halfSliceHeight = parameterModel.sliceHeight / 2;
    
    CGFloat mostLeft  = - widthOffset + halfSliceWidth;
    CGFloat mostRight = puzzleSize.width + widthOffset  - halfSliceWidth;
    CGFloat mostUp    = - heightOffset + halfSliceHeight;
    CGFloat mostDown  = puzzleSize.height + heightOffset - halfSliceHeight;
    
    for (PJWTileImageView *obj in self.tileSet) {
        PJWTileModel *tileModel = obj.tileModel;
        
        if (tileModel.isGhostFix || tileModel.isBorderFix) {
            continue;
        }
        
        if (parameterModel.edgesPresent && !tileModel.isSide) {
            continue;
        }
        
        if (tileModel.linkedTileHashTable.count == 1) {
            [self.view bringSubviewToFront:obj];
            
            UIEdgeInsets bezierInsets = tileModel.bezierInsets;
            CGFloat left  = bezierInsets.left;
            CGFloat right = bezierInsets.right;
            CGFloat up    = bezierInsets.top;
            CGFloat down  = bezierInsets.bottom;
            
            CGPoint center;
            if (TENHeadOrTile) {
                center.x = mostLeft - left + arc4random_uniform(mostRight + right - mostLeft - left);
                center.y = TENHeadOrTile ? mostUp   - up   : mostDown  + down ;
            } else {
                center.x = TENHeadOrTile ? mostLeft - left : mostRight + right;
                center.y = mostUp - up     + arc4random_uniform(mostDown  + down  - mostUp   - up  );
            }
            
            [UIView animateWithDuration:0.3
                             animations:^{
                                 obj.center = center;
                             }];
        }
    }
}

- (IBAction)onOrder:(UIButton *)sender {
    for (PJWTileImageView *tileView in self.tileSet) {
        
        if (tileView.tileModel.linkedTileHashTable.count == 1) {
            CGPoint center = CGPointFromValue(tileView.tileModel.anchor);
            center.x += (1024. - self.parameterModel.fullWidth) / 2.0;
            center.y += ( 768. - self.parameterModel.fullHeight) / 2.0;
            
            [UIView animateWithDuration:1.0
                             animations:^{
                                 tileView.center = center;
                             }];
        }
    }
}

- (IBAction)onRestart:(UIButton *)sender {
    PJWOptionsViewController *vc = [PJWOptionsViewController new];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.delegate = self;
    
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark -
#pragma mark Private Methods

- (void)startGame {
    [self setupParameterModel];
    
    [self setupGhostGamePuzzleView];
    
    self.tilesModel = [PJWTilesModel new];
    self.tileSet = self.tilesModel.tileSet;
    
    [self addTilesOnPuzzleView];
    
    [self.edgesButton setTitle:[PJWPuzzleParameterModel sharedInstance].edgesPresent ? @"View All" : @"Edges"
                      forState:UIControlStateNormal];
}

- (void)setupParameterModel {
    
    [self.parameterModel setup];
}

- (void)setupGhostGamePuzzleView {
    [self.puzzleView removeFromSuperview];
    [self.gameView removeFromSuperview];
    [self.ghostView removeFromSuperview];

    PJWPuzzleParameterModel *parameterModel = self.parameterModel;
    
    UIImageView *ghostView  = [[UIImageView alloc] initWithFrame:parameterModel.ghostRect];
    UIView *gameView   = [[UIView alloc] initWithFrame:parameterModel.gameRect ];
    UIView *puzzleView = [[UIView alloc] initWithFrame:parameterModel.ghostRect];

    ghostView.center = gameView.center;
    ghostView.layer.borderColor = [UIColor blackColor].CGColor;
    
    gameView.backgroundColor = [UIColor clearColor];;
    gameView.layer.borderColor = [UIColor redColor].CGColor;
    gameView.layer.borderWidth = 1.0;
    
    puzzleView.center = gameView.center;
    puzzleView.backgroundColor = [UIColor clearColor];
    
    UIView *rootView = self.view;
    
    [rootView addSubview:ghostView];
    [rootView addSubview:gameView];
    [rootView addSubview:puzzleView];
    
    self.ghostView = ghostView;
    self.gameView = gameView;
    self.puzzleView = puzzleView;
}

- (void)addTilesOnPuzzleView {
    UIView *puzzleView = self.puzzleView;
    
    for (PJWTileImageView *tileView in self.tileSet) {
        
        tileView.userInteractionEnabled = YES;
        
        [tileView addGestureRecognizer:[self panRecognizer]];
        [tileView addGestureRecognizer:[self tapRecognizer]];
        //        [imageView addGestureRecognizer:[self longPressRecognizer]];
        
        tileView.center = CGPointFromValue(tileView.tileModel.anchor);;
        
        [puzzleView addSubview:tileView];
    }
}

- (UIPanGestureRecognizer *)panRecognizer {
    UIPanGestureRecognizer *result = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(panAction:)];
    result.minimumNumberOfTouches = 1;
    result.maximumNumberOfTouches = 1;
    
    return result;
}

- (void)panAction:(UIPanGestureRecognizer *)recognizer {
    PJWPuzzleParameterModel *parameterModel = self.parameterModel;
    PJWTileImageView *recognizerView = (PJWTileImageView *)recognizer.view;
    PJWTileModel *tileModel = recognizerView.tileModel;
    
    
    if (   (parameterModel.edgesPresent  && !tileModel.isSide     )
        || (parameterModel.ghostPresent  &&  tileModel.isGhostFix )
        || (parameterModel.borderPresent &&  tileModel.isBorderFix) )
    {
        return;
    }

    UIView *rootView = self.view;
    NSSet *linkedSet = recognizerView.tileModel.linkedTileHashTable.setRepresentation;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self bringSegmentToFront:recognizerView];
    }
    
    CGPoint offset = [recognizer translationInView:rootView];
    CGPoint center = recognizerView.center;

    PJWSegmentModel *segmentModel = [[PJWSegmentModel alloc] initWithTileView:recognizerView];
    UIEdgeInsets segmentInsets = segmentModel.segmentInsets;
    
    UIEdgeInsets gameFieldLimit = parameterModel.gameFieldLimit;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;

//    NSLog(@"center %.1f offset %.1f inset %.1f", center.y, offset.y, segmentInsets.top);
    
    CGFloat delta;
    
//left side
    delta = center.x + offset.x - segmentInsets.left + 0.f - gameFieldLimit.left;
    if (delta < 0) {
        offset.x -= delta;
    }

//right side
    delta = center.x + offset.x + segmentInsets.right - screenSize.width + gameFieldLimit.right;
    if (delta > 0) {
        offset.x -= delta;
    }
    
//up side
    delta = center.y + offset.y - segmentInsets.top + 0.f - gameFieldLimit.top;
    if (delta < 0) {
        offset.y -= delta;
    }

//down side
    delta = center.y + offset.y + segmentInsets.bottom - screenSize.height + gameFieldLimit.bottom;
    if (delta > 0) {
        offset.y -= delta;
    }
    
    [linkedSet enumerateObjectsUsingBlock:^(PJWTileImageView *obj, BOOL *stop) {
        obj.center = CGPointMake(obj.center.x + offset.x,
                                 obj.center.y + offset.y);
    }];

    
    [recognizer setTranslation:CGPointZero inView:rootView];

    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self moveToNeighborTileView:recognizerView];
        
        if (parameterModel.ghostPresent) {
            [self moveToGhostTileView:recognizerView];
        }
    
        if (parameterModel.borderPresent) {
            [self moveToBorderTileView:recognizerView];
        }
        
    }
}

- (void)moveToBorderTileView:(PJWTileImageView *)tileView {
    @synchronized (tileView) {
        UIView *rootView = self.view;
        UIImageView *ghostView = self.ghostView;
        CGFloat deltaGhost = self.parameterModel.deltaGhost;
        PJWTileModel *tileModel = tileView.tileModel;

        if (tileModel.isSide) {
            CGPoint center = [rootView convertPoint:tileView.center toView:ghostView];
            CGPoint anchor = CGPointFromValue(tileModel.anchor);
            
            if (fabs(center.x - anchor.x) < deltaGhost && fabs(center.y - anchor.y) < deltaGhost ) {
                CGPoint targetPoint = [ghostView convertPoint:anchor toView:rootView];
                
                [tileView moveSegmentToPoint:targetPoint animated:YES];
                
                for (PJWTileImageView *obj in tileModel.linkedTileHashTable) {
                    obj.tileModel.isBorderFix = YES;
                    [rootView sendSubviewToBack:obj];
                }
                
                [rootView sendSubviewToBack:ghostView];
            }
        }
    }
}

- (void)moveToGhostTileView:(PJWTileImageView *)tileView {
    @synchronized (tileView) {
        UIView *rootView = self.view;
        UIImageView *ghostView = self.ghostView;
        CGFloat deltaGhost = self.parameterModel.deltaGhost;
        PJWTileModel *tileModel = tileView.tileModel;
        
        CGPoint center = [rootView convertPoint:tileView.center toView:ghostView];
        
        CGPoint anchor = CGPointFromValue(tileModel.anchor);
        
        if (fabs(center.x - anchor.x) < deltaGhost && fabs(center.y - anchor.y) < deltaGhost ) {
            CGPoint targetPoint = [ghostView convertPoint:anchor toView:rootView];
            
            [tileView moveSegmentToPoint:targetPoint animated:YES];
            
            for (PJWTileImageView *obj in tileModel.linkedTileHashTable) {
                obj.tileModel.isGhostFix = YES;
                [rootView sendSubviewToBack:obj];
            }
            
            [rootView sendSubviewToBack:ghostView];
        }
    }
}

- (void)moveToNeighborTileView:(PJWTileImageView *)tileView {
    @synchronized (tileView) {
        NSMutableSet *linkedSet = [NSMutableSet setWithSet:tileView.tileModel.linkedTileHashTable.setRepresentation];
        NSMutableSet *freeNeighborSet = [NSMutableSet new];
        
//seek free neighbors
        for (PJWTileImageView *obj in linkedSet) {
            PJWTileModel *tileModel = obj.tileModel;
            
            if ([self.tilesModel.calculatedTiles[tileModel.row][tileModel.col] boolValue]) {
                [freeNeighborSet unionSet:[self.tilesModel freeNeighborsForTileView:obj]];
            }
        }
        
        if (freeNeighborSet.count == 0) {
            return;
        }
        
        PJWTileImageView *targetView = freeNeighborSet.allObjects[0];
        [tileView moveToTargetView:targetView];
        
        [linkedSet unionSet:freeNeighborSet];
        
        NSHashTable *linkedTileHashTable = [NSHashTable weakObjectsHashTable];
        BOOL isSide = NO;
        
//generate common hashTable
        for (PJWTileImageView *obj in linkedSet) {
            PJWTileModel *tileModel = obj.tileModel;
            
            [linkedTileHashTable unionHashTable:tileModel.linkedTileHashTable];
            if (!isSide && tileModel.isSide) {
                isSide = YES;
            }
        }

//move segment
        for (PJWTileImageView *obj in linkedTileHashTable) {
            PJWTileModel *tileModel = obj.tileModel;

            [obj moveToTargetView:tileView];
            tileModel.linkedTileHashTable = linkedTileHashTable;
            tileModel.isSide = isSide;
        }
        
        [self.tilesModel updateCalculatedTilesWithView:tileView];
    }
}


- (UITapGestureRecognizer *)tapRecognizer {
    UITapGestureRecognizer *result = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(tapAction:)];
    return result;
}

- (void)tapAction:(UITapGestureRecognizer *)recognizer {
    [self bringSegmentToFront:(PJWTileImageView *)recognizer.view];
}

- (void)bringSegmentToFront:(PJWTileImageView *)tileView {
    NSSet *linkedSet = tileView.tileModel.linkedTileHashTable.setRepresentation;
    UIView *rootView = self.view;
    NSInteger count = linkedSet.count;
    
    if (count < 70) {
        [linkedSet enumerateObjectsUsingBlock:^(PJWTileImageView *obj, BOOL *stop) {
            [rootView bringSubviewToFront:obj];
        }];
        
    } else {
        NSArray *subViews = rootView.subviews;
        NSInteger index = subViews.count - 1;
        
        BOOL isCheckToEnd = NO;
        UIView *view;
        
        while (count > 0) {
            view = subViews[index];
            
            if ([linkedSet containsObject:view]) {
                count--;
            } else {
                [rootView sendSubviewToBack:view];
                isCheckToEnd = YES;
            }
            
            index--;
        }
        
        if (isCheckToEnd) {
            while (index >= 0) {
                view = subViews[index];
                [rootView sendSubviewToBack:view];
                index--;
            }
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
