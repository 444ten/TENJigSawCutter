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
@property (nonatomic, strong)   NSDictionary *presetCount;

@property (nonatomic,assign) NSInteger newCountWidth;
@property (nonatomic,assign) NSInteger newCountHeight;

@end

@implementation PJWOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.presetCount = [self setupPresetCount];
}

#pragma mark -
#pragma mark Interface Handling

- (IBAction)onStart:(id)sender {
    PJWPuzzleParameterModel *parameterModel = [PJWPuzzleParameterModel sharedInstance];
    parameterModel.countWidth = self.newCountWidth;
    parameterModel.countHeight = self.newCountHeight;

    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate startGame];        
    }];

}

- (IBAction)onCancel:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changeCountTiles:(UISlider *)sender {
    NSInteger key = (int)(sender.value);
    
    NSArray *parameter = self.presetCount[@(key)];
    
    self.newCountWidth = [parameter[0] intValue];
    self.newCountHeight = [parameter[1] intValue];
    
    self.countLabel.text = [NSString stringWithFormat:@"%d x %d", [parameter[0] intValue], [parameter[1] intValue]];
}

#pragma mark -
#pragma mark Private Methods

- (NSDictionary *)setupPresetCount {
    return @{@(0) : @[@(2), @(2)],
             @(1) : @[@(3), @(2)],
             @(2) : @[@(4), @(3)],
             @(3) : @[@(5), @(4)],
             @(4) : @[@(6), @(5)],
             @(5) : @[@(8), @(6)],
             @(6) : @[@(9), @(7)],
             @(7) : @[@(10), @(8)],
             @(8) : @[@(12), @(9)],
             @(9) : @[@(15), @(11)],
             @(10) : @[@(16), @(12)],
             @(11) : @[@(18), @(14)],
             @(12) : @[@(20), @(15)]
             };
}

@end
