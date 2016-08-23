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

@interface ViewController ()
@property (nonatomic, strong)   UIImageView             *ghostView;
@property (nonatomic, strong)   PJWPuzzleParameterModel *parameterModel;

@property (nonatomic, strong)   PJWTilesModel           *tilesModel;
@property (nonatomic, strong)   NSSet                   *tileSet;

@property (nonatomic, assign)   BOOL    ghostPresent;

@end

@implementation ViewController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.parameterModel = [PJWPuzzleParameterModel sharedInstance];
    
    [self onRestart:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark -
#pragma mark Accessors
- (void)setGhostPresent:(BOOL)ghostPresent {
    _ghostPresent = ghostPresent;
    self.ghostView.alpha = ghostPresent ? 0.3 : 0.0;
}


#pragma mark -
#pragma mark Interface Handling

- (IBAction)onShuffle:(UIButton *)sender {
    PJWPuzzleParameterModel *parameterModel = self.parameterModel;
    CGRect gameFieldRect = parameterModel.gameFieldRect;
    
    CGFloat mostLeft  = gameFieldRect.origin.x + parameterModel.sliceWidth  / 2;
    CGFloat mostRight = gameFieldRect.origin.x + gameFieldRect.size.width  - parameterModel.sliceWidth / 2;
    CGFloat mostUp    = gameFieldRect.origin.y + parameterModel.sliceHeight / 2;
    CGFloat mostDown  = gameFieldRect.origin.y + gameFieldRect.size.height - parameterModel.sliceHeight / 2;
    
    for (PJWTileImageView *tileView in self.tileSet) {
        if (tileView.tileModel.linkedTileHashTable.count == 1) {
            [self.view bringSubviewToFront:tileView];
            
            UIEdgeInsets bezierInsets = tileView.tileModel.bezierInsets;
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
                                 tileView.center = center;
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
    for (UIImageView *view in self.tileSet) {
        [view removeFromSuperview];
    }
    
    [self setupParameterModel];
    
    [self setupGhost];
    
    self.tilesModel = [PJWTilesModel new];
    self.tileSet = self.tilesModel.tileSet;
    
    self.ghostPresent = NO;
    
    [self addTilesOnView];
}

- (IBAction)onGhost:(UIButton *)sender {
    self.ghostPresent = !self.ghostPresent;
}

#pragma mark -
#pragma mark Private Methods

- (void)setupParameterModel {
    PJWPuzzleParameterModel *parameterModel = [PJWPuzzleParameterModel sharedInstance];
    parameterModel.fullWidth = 800.f;
    parameterModel.countWidth = 20;
    parameterModel.overlapRatioWidth = 0.5;
    
    parameterModel.fullHeight = 600.f;
    parameterModel.countHeight = 15;
    parameterModel.overlapRatioHeight = 0.5;
    
    [parameterModel setup];
}

- (void)setupGhost {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    PJWPuzzleParameterModel *parameterModel = self.parameterModel;
    
    UIImageView *ghostView = [[UIImageView alloc] initWithFrame:
                              CGRectMake(0, 0, parameterModel.fullWidth, parameterModel.fullHeight)];
    
    ghostView.image = parameterModel.originImage;
    ghostView.center = CGPointMake(screenSize.width/2, screenSize.height/2);
    ghostView.contentMode = UIViewContentModeTopLeft;
    ghostView.clipsToBounds =  YES;
    
    [self.view addSubview:ghostView];
    
    self.ghostView = ghostView;
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
    result.maximumNumberOfTouches = 1;
    
    return result;
}

- (void)panAction:(UIPanGestureRecognizer *)recognizer {
    PJWPuzzleParameterModel *parameterModel = self.parameterModel;
    
    PJWTileImageView *recognizerView = (PJWTileImageView *)recognizer.view;
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

    NSLog(@"center %.1f offset %.1f inset %.1f", center.y, offset.y, segmentInsets.top);
    
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
        [self searchNeighborForView:recognizerView];
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

- (void)searchNeighborForView:(PJWTileImageView *)tileView {
    NSMutableSet *linkedSet = [NSMutableSet setWithSet:tileView.tileModel.linkedTileHashTable.setRepresentation];
    NSMutableSet *freeNeighborSet = [NSMutableSet new];
    
    [linkedSet enumerateObjectsUsingBlock:^(PJWTileImageView *obj, BOOL *stop) {
        PJWTileModel *tileModel = obj.tileModel;
        
        if ([self.tilesModel.calculatedTiles[tileModel.row][tileModel.col] boolValue]) {
            [freeNeighborSet unionSet:[self.tilesModel freeNeighborsForTileView:obj]];
        }
    }];
    
    if (freeNeighborSet.count == 0) {
        return;
    }
    
    PJWTileImageView *targetView = freeNeighborSet.allObjects[0];
    [tileView moveToTargetView:targetView];
    
    [linkedSet unionSet:freeNeighborSet];

    NSHashTable *linkedTileHashTable = [NSHashTable weakObjectsHashTable];

    [linkedSet enumerateObjectsUsingBlock:^(PJWTileImageView *obj, BOOL *stop) {
        [linkedTileHashTable unionHashTable:obj.tileModel.linkedTileHashTable];
    }];


    [linkedTileHashTable.setRepresentation enumerateObjectsUsingBlock:^(PJWTileImageView *obj, BOOL *stop) {
        [obj moveToTargetView:tileView];
        obj.tileModel.linkedTileHashTable = linkedTileHashTable;
    }];
    
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
