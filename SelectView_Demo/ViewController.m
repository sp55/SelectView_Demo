//
//  ViewController.m
//  SelectView_Demo
//
//  Created by admin on 16/7/26.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

#import "ViewController.h"
#import "SelectView.h"
@interface ViewController ()<SelectionDelegate>
@property (nonatomic, strong) SelectView *selectionView;

@end

@implementation ViewController{
    NSString *changeStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Houston Rocket 08~09 Season";
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"Tap" style:UIBarButtonItemStylePlain target:self action:@selector(popAction)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.selectionView];
}
#pragma mark - LazyLoad
- (SelectView *)selectionView {
    if (!_selectionView) {
        _selectionView = [[SelectView alloc] initWithTitles:[self titlesArray] PopDirection:PopFromAboveToTop];
        _selectionView.selectionDelegate = self;
        _selectionView.defaultSelected = 1;
        _selectionView.shadowEffect = YES;
        _selectionView.shadowAlpha = 0.1;
    }
    return _selectionView;
}


#pragma mark - RightBarButtonItemAction
- (void)popAction {
    [self.selectionView showOrDismissNinaViewWithDuration:0.5 usingNinaSpringWithDamping:0.8 initialNinaSpringVelocity:0.3];
    //    [self.ninaSelectionView showOrDismissNinaViewWithDuration:0.3];
}

#pragma mark - SelectionDelegate
- (void)selectAction:(UIButton *)button {
    NSLog(@"Choose %li button----text--->%@",(long)button.tag,button.titleLabel.text);
    changeStr = button.titleLabel.text;
    [self.selectionView showOrDismissNinaViewWithDuration:0.3];
}

#pragma mark - TitlesArray
- (NSArray *)titlesArray {
    return @[
             @"Aaron Brooks",
             @"Tracy Mcgrady",
             @"Luther Head",
             @"Luis Scola",
             @"Yao Ming",
             @"Rafer Alston",
             @"Von Wafer",
             @"Carl Landry",
             @"Brent Barry",
             @"Shane Battier",
             @"Chuck hayes",
             @"Dikembe Mutombo",
             @"Ron Artest"
             ];
}

@end
