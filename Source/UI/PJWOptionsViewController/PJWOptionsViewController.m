//
//  PJWOptionsViewController.m
//  TENJigSawCutter
//
//  Created by 444ten on 8/23/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import "PJWOptionsViewController.h"
#import "PJWPuzzleParameterModel.h"

@interface PJWOptionsViewController ()

@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UISlider *cutterTypeSlider;

@property (nonatomic, strong)   NSNumber    *oldCutterType;

@end

@implementation PJWOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PJWPuzzleParameterModel *parameterModel = [PJWPuzzleParameterModel sharedInstance];
    self.oldCutterType = parameterModel.cutterType;
    
    [self fillWithModel:parameterModel];
}

#pragma mark -
#pragma mark Interface Handling

- (IBAction)onStart:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        [self.delegate restartGame];
    }];
}

- (IBAction)onCancel:(UIButton *)sender {
    [PJWPuzzleParameterModel sharedInstance].cutterType = self.oldCutterType;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changeCountTiles:(UISlider *)sender {
    PJWPuzzleParameterModel *parameterModel = [PJWPuzzleParameterModel sharedInstance];
    
    parameterModel.cutterType = @((int)sender.value);
    
    [self fillWithModel:parameterModel];
}

#pragma mark -
#pragma mark Private Methods

- (void)fillWithModel:(PJWPuzzleParameterModel *)parameterModel {
    self.cutterTypeSlider.value = [parameterModel.cutterType integerValue];
    
    self.countLabel.text = [NSString stringWithFormat:@"%d x %d = %d",
                            (int)parameterModel.countWidth,
                            (int)parameterModel.countHeight,
                            (int)(parameterModel.countWidth * parameterModel.countHeight)];
    
}

@end













