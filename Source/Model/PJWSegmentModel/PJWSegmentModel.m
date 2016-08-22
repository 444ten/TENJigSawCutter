//
//  PJWSegmentModel.m
//  TENJigSawCutter
//
//  Created by 444ten on 8/19/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import "PJWSegmentModel.h"

#import "PJWPuzzleParameterModel.h"

@interface PJWSegmentModel ()

@end

@implementation PJWSegmentModel

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)initWithTileView:(PJWTileImageView *)tileView {
    self = [super init];
    if (self) {
        self.segmentInsets = [self segmentInsetsWithTileView:tileView];
    }
    
    return self;
}

#pragma mark -
#pragma mark Private Methods

- (UIEdgeInsets)segmentInsetsWithTileView:(PJWTileImageView *)tileView {
    PJWTileImageView *leftView = tileView;
    PJWTileImageView *rightView = tileView;
    PJWTileImageView *upView = tileView;
    PJWTileImageView *downView = tileView;

    PJWTileModel *tileModel = tileView.tileModel;
    NSHashTable *linkedTable = tileModel.linkedTileHashTable;

    for (PJWTileImageView *view in linkedTable) {
        PJWTileModel *viewModel = view.tileModel;
        NSInteger row = viewModel.row;
        NSInteger col = viewModel.col;
        UIEdgeInsets viewInsets = viewModel.bezierInsets;
        
//left
        PJWTileModel *leftModel = leftView.tileModel;
        if (col < leftModel.col) {
            leftView = view;
        } else if (col == leftModel.col) {
            if (viewInsets.left < leftModel.bezierInsets.left) {
                leftView = view;
            }
        }
        
//right
        PJWTileModel *rightModel = rightView.tileModel;
        if (col > rightModel.col) {
            rightView = view;
        } else if (col == rightModel.col) {
            if (viewInsets.right < leftModel.bezierInsets.right) {
                rightView = view;
            }
        }
        
//up
        PJWTileModel *upModel = upView.tileModel;
        if (row < upModel.row) {
            upView = view;
        } else if (row == upModel.row) {
            if (viewInsets.top < upModel.bezierInsets.top) {
                upView = view;
            }
        }
        
//down
        PJWTileModel *downModel = downView.tileModel;
        if (row > downModel.row) {
            downView = view;
        } else if (row == downModel.row) {
            if (viewInsets.bottom < downModel.bezierInsets.bottom) {
                downView = view;
            }
        }
        
    }
    
    PJWPuzzleParameterModel *parameterModel = [PJWPuzzleParameterModel sharedInstance];
    NSInteger tileRow = tileModel.row;
    NSInteger tileCol = tileModel.col;
    
    PJWTileModel *leftModel = leftView.tileModel;
    CGFloat leftInset = (tileCol - leftModel.col + 0.5) * parameterModel.sliceWidth - leftModel.bezierInsets.left;

    PJWTileModel *rightModel = rightView.tileModel;
    CGFloat rightInset = (rightModel.col - tileCol + 0.5) * parameterModel.sliceWidth - rightModel.bezierInsets.right;

    PJWTileModel *upModel = upView.tileModel;
    CGFloat upInset = (tileRow - upModel.row + 0.5) * parameterModel.sliceHeight - upModel.bezierInsets.top;
  
    PJWTileModel *downModel = downView.tileModel;
    CGFloat downInset = (downModel.row - tileRow + 0.5) * parameterModel.sliceHeight - downModel.bezierInsets.bottom;
    
    return UIEdgeInsetsMake(upInset, leftInset, downInset, rightInset);
}

@end

























