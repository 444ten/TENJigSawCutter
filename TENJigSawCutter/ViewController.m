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
@property (strong, nonatomic) IBOutlet UIImageView *originalImageView;

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

- (IBAction)onShuffle:(UIButton *)sender {
    PJWPuzzleParameterModel *parameterModel = self.parameterModel;
    CGFloat mostLeft  = parameterModel.mostLeftCenter;
    CGFloat mostRight = parameterModel.mostRightCenter;
    CGFloat mostUp    = parameterModel.mostUpCenter;
    CGFloat mostDown  = parameterModel.mostDownCenter;
    
    for (PJWTileImageView *tileView in self.tileSet) {
        UIEdgeInsets bezierInsets = tileView.tileModel.bezierInsets;
        CGFloat left  = bezierInsets.left;
        CGFloat right = bezierInsets.right;
        CGFloat up    = bezierInsets.top;
        CGFloat down  = bezierInsets.bottom;
        
        if (tileView.tileModel.linkedTileHashTable.count == 1) {
            CGPoint center;
            if (TENHeadOrTile) {
                center.x = mostLeft - left + arc4random_uniform(mostRight + right - mostLeft - left);
                center.y = TENHeadOrTile ? mostUp   - up   : mostDown  + down ;
            } else {
                center.x = TENHeadOrTile ? mostLeft - left : mostRight + right;
                center.y = mostUp - up     + arc4random_uniform(mostDown  + down  - mostUp   - up  );
            }
            
            [UIView animateWithDuration:1.0
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
    parameterModel.fullWidth = 900.f;
    parameterModel.countWidth = 4;
    parameterModel.overlapRatioWidth = 0.5;
    
    parameterModel.fullHeight = 700.f;
    parameterModel.countHeight = 3;
    parameterModel.overlapRatioHeight = 0.5;
    
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
    result.maximumNumberOfTouches = 1;
    
    return result;
}

- (void)panAction:(UIPanGestureRecognizer *)recognizer {
    PJWPuzzleParameterModel *parameterModel = [PJWPuzzleParameterModel sharedInstance];
    
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
    
    
    NSLog(@"center %.1f offset %.1f inset %.1f", center.x, offset.x, segmentInsets.left);
    
    
//    if (center.x + offset.x - segmentInsets.left < 0) {
//        offset.x = segmentInsets.left - center.x;
//    }
    
    CGFloat delta = center.x + offset.x - segmentInsets.left;
    
    if (delta < 0) {
        offset.x -= delta;
    }
    
//    center.x += offset.x;
//    center.y += offset.y;

//    if (center.x < parameterModel.mostLeftCenter - recognizerView.tileModel.bezierInsets.left) {
//        center.x = parameterModel.mostLeftCenter - recognizerView.tileModel.bezierInsets.left;
//    }
//    
//    if (center.x > parameterModel.mostRightCenter) {
//        center.x = parameterModel.mostRightCenter;
//    }
//
//    if (center.y < parameterModel.mostUpCenter) {
//        center.y = parameterModel.mostUpCenter;
//    }
//
//    if (center.y > parameterModel.mostDownCenter) {
//        center.y = parameterModel.mostDownCenter;
//    }

//    recognizerView.center = center;
    
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
