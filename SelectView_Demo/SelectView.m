//
//  SelectView.m
//  SelectView_Demo
//
//  Created by admin on 16/7/26.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

#import "SelectView.h"

@interface SelectView ()
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UIView *bottomLine;
@end

@implementation SelectView
{
    NSInteger selectionHeight;//
    PopDirection direciton;//
    NSInteger columnNum;//
    NSArray *Titles;//
    NSMutableArray *buttonArray;//
    double tapDuration;//
    CGFloat tapDamping;//
    CGFloat tapVelocity;//
    BOOL showState;//
    BOOL verticalScrollMode;//
    BOOL horizontalScrollMode;//
    CGPoint StartPoint;//
    CGPoint OriginPoint;//
    BOOL Contain;//
}
#pragma mark - ---->step1  初始化         //传入数组                       //方向
- (instancetype)initWithTitles:(NSArray *)titles PopDirection:(PopDirection)direction {
    if (self = [super init]) {
        if (titles.count > 0) {
            self.hidden = YES;
            self.backgroundColor = [UIColor whiteColor];
            buttonArray = [NSMutableArray array];
            direciton = direction;
            Titles = titles;
            selectionHeight = 0;
            columnNum = 0;
            if (titles.count % PerNum == 0) {
                columnNum = titles.count / PerNum;
            }else {
                columnNum = titles.count / PerNum + 1;
            }
            selectionHeight = Button_TopSpace * 2 + (Button_Height + Button_Space) * columnNum - Button_Space;
            if (selectionHeight > FUll_CONTENT_HEIGHT_WITHOUT_TAB) {
                verticalScrollMode = YES;
            }
            if (View_X < 0) {
                horizontalScrollMode = YES;
            }
            CGFloat defaultY = 0;
            CGFloat defaultX = horizontalScrollMode?0:View_X;
            switch (direction / 3) {
                case 0:
                    defaultY = -(selectionHeight);
                    break;
                case 1:
                    defaultY = selectionHeight + FUll_VIEW_HEIGHT;
                    break;
                case 2:
                    defaultX = -(View_Width);
                    if (direction == 7) {
                        defaultY = verticalScrollMode?0:(FUll_CONTENT_HEIGHT_WITHOUT_TAB - selectionHeight) / 2;
                    }else if (direction == 8) {
                        defaultY = verticalScrollMode?0:FUll_CONTENT_HEIGHT_WITHOUT_TAB - selectionHeight;
                    }
                    break;
                case 3:
                    defaultX = (FUll_VIEW_WIDTH);
                    if (direction == 10) {
                        defaultY = verticalScrollMode?0:(FUll_CONTENT_HEIGHT_WITHOUT_TAB - selectionHeight) / 2;
                    }else if (direction == 11) {
                        defaultY = verticalScrollMode?0:FUll_CONTENT_HEIGHT_WITHOUT_TAB - selectionHeight;
                    }
                    break;
                default:
                    break;
            }
            if (verticalScrollMode) {
                self.alwaysBounceVertical = YES;
                self.showsVerticalScrollIndicator = YES;
                if (horizontalScrollMode) {
                    self.bounces = NO;
                    self.contentSize = CGSizeMake(View_Width, selectionHeight);
                    self.alwaysBounceHorizontal = YES;
                    self.showsHorizontalScrollIndicator = YES;
                    self.frame = CGRectMake(defaultX, defaultY, FUll_VIEW_WIDTH, FUll_CONTENT_HEIGHT_WITHOUT_TAB);
                }else {
                    self.contentSize = CGSizeMake(0, selectionHeight);
                    self.frame = CGRectMake(defaultX, defaultY, View_Width, FUll_CONTENT_HEIGHT_WITHOUT_TAB);
                }
            }else {
                if (horizontalScrollMode) {
                    self.contentSize = CGSizeMake(View_Width, 0);
                    self.alwaysBounceHorizontal = YES;
                    self.showsHorizontalScrollIndicator = YES;
                    self.frame = CGRectMake(defaultX, defaultY, FUll_VIEW_WIDTH, selectionHeight);
                }else {
                    self.scrollEnabled = NO;
                    self.frame = CGRectMake(defaultX, defaultY, View_Width, selectionHeight);
                }
            }
            [self createSelectionButton];
            [self addSubview:self.bottomLine];
        }else {
            NSLog(@"Titles-array's count should not be zero.");
        }
    }
    return self;
}

#pragma mark - SetMethod
- (void)setDefaultSelected:(NSInteger)defaultSelected {
    if (buttonArray.count > 0) {
        _defaultSelected = defaultSelected;
        UIButton *selectBtn = buttonArray[defaultSelected - 1];
        [self selectChangeColor:selectBtn];
    }
}

- (void)setShadowEffect:(BOOL)shadowEffect {
    _shadowEffect = shadowEffect;
    if (_shadowEffect) {
        [self.superview insertSubview:self.shadowView belowSubview:self];
        self.shadowView.alpha = 0.f;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDismissNinaView)];
        [self.shadowView addGestureRecognizer:tap];
    }
}

- (void)setShadowAlpha:(CGFloat)shadowAlpha {
    if (_shadowEffect && shadowAlpha > 0.f) {
        _shadowAlpha = shadowAlpha;
        self.shadowView.alpha = _shadowAlpha;
    }else {
        NSLog(@"You must set ShadowEffect to YES then shadowAlpha should be worked.");
    }
}

- (void)setpopY:(CGFloat)popY {
    if (popY > 0 && popY < FUll_CONTENT_HEIGHT_WITHOUT_TAB - SELFHEIGHT) {
        _popY = popY;
    }else {
        NSLog(@"Hey,your popY is not fit for show SelectView.");
    }
}

#pragma mark - LazyLoad
- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, FUll_CONTENT_HEIGHT_WITHOUT_TAB)];
        _shadowView.backgroundColor = [UIColor blackColor];
        _shadowView.alpha = 0.5f;
    }
    return _shadowView;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0,selectionHeight - 2, View_Width, 2)];
        _bottomLine.backgroundColor = UIColorFromRGB(0xb2b2b2);
    }
    return _bottomLine;
}

#pragma mark - NinaSelectionMethod
- (void)showOrDismissNinaViewWithDuration:(NSTimeInterval)duration {
    NSArray *locateArray = [self showOrDismissDetailMethodWithDuration:duration];
    if (locateArray.count != 2) {
        return;
    }
    CGFloat ninaViewX = [locateArray[0] floatValue];
    CGFloat ninaViewY = [locateArray[1] floatValue];
    if (verticalScrollMode) {
        [UIView animateWithDuration:duration animations:^{
            self.frame = CGRectMake(ninaViewX, ninaViewY, (horizontalScrollMode?FUll_VIEW_WIDTH:View_Width), FUll_CONTENT_HEIGHT_WITHOUT_TAB);
        }completion:^(BOOL finished) {
            if (showState == NO) {
                self.hidden = YES;
            }
        }];
    }else {
        if ((direciton == 1 || direciton == 4 || direciton == 7 || direciton == 10) && showState) {
            ninaViewX = horizontalScrollMode ?0:View_X;
            ninaViewY = verticalScrollMode?0:(FUll_CONTENT_HEIGHT_WITHOUT_TAB - selectionHeight) / 2;
        }
        [UIView animateWithDuration:duration animations:^{
            self.frame = CGRectMake(ninaViewX, (((_popY > 0) && showState == YES)?_popY:ninaViewY), (horizontalScrollMode?FUll_VIEW_WIDTH:View_Width), selectionHeight);
        } completion:^(BOOL finished) {
            if (showState == NO) {
                self.hidden = YES;
            }
        }];
    }
}

- (void)showOrDismissNinaViewWithDuration:(NSTimeInterval)duration usingNinaSpringWithDamping:(CGFloat)dampingRatio initialNinaSpringVelocity:(CGFloat)velocity {
    NSArray *locateArray = [self showOrDismissDetailMethodWithDuration:duration];
    if (locateArray.count != 2) {
        return;
    }
    CGFloat ninaViewX = [locateArray[0] floatValue];
    CGFloat ninaViewY = [locateArray[1] floatValue];
    CGFloat dampingOrNot = ((dampingRatio < 1) && (dampingRatio > 0))?dampingRatio:0.5;
    CGFloat damping = showState?dampingOrNot:1;
    CGFloat VelocityNum = ((velocity < 1) && (velocity > 0))?velocity:0.75;
    tapDamping = damping;
    tapVelocity = VelocityNum;
    if (verticalScrollMode) {
        [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:damping initialSpringVelocity:VelocityNum options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.frame = CGRectMake(ninaViewX, ninaViewY, (horizontalScrollMode?FUll_VIEW_WIDTH:View_Width), FUll_CONTENT_HEIGHT_WITHOUT_TAB);
        }completion:^(BOOL finished) {
            if (showState == NO) {
                self.hidden = YES;
            }
        }];
    }else {
        if ((direciton == 1 || direciton == 4 || direciton == 7 || direciton == 10) && showState) {
            ninaViewX = horizontalScrollMode ?0:View_X;
            ninaViewY = verticalScrollMode?0:(FUll_CONTENT_HEIGHT_WITHOUT_TAB - selectionHeight) / 2;
        }
        [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:damping initialSpringVelocity:VelocityNum options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.frame = CGRectMake(ninaViewX, (((_popY > 0) && showState == YES)?_popY:ninaViewY), (horizontalScrollMode?FUll_VIEW_WIDTH:View_Width), selectionHeight);
        } completion:^(BOOL finished) {
            if (showState == NO) {
                self.hidden = YES;
            }
        }];
    }
}

#pragma mark - PrivateMethod
- (NSArray *)showOrDismissDetailMethodWithDuration:(NSTimeInterval)duration {
    tapDuration = duration;
    CGFloat ninaViewY = 0;
    CGFloat ninaViewX = horizontalScrollMode ?0:View_X;
    if (direciton == 2 || direciton == 5 || direciton == 8 || direciton == 11) {
        if (selectionHeight <= FUll_CONTENT_HEIGHT_WITHOUT_TAB) {
            ninaViewY = FUll_CONTENT_HEIGHT_WITHOUT_TAB - selectionHeight;
        }
    }else if (direciton == 7 || direciton == 10) {
        ninaViewY = verticalScrollMode?0:(FUll_CONTENT_HEIGHT_WITHOUT_TAB - selectionHeight) / 2;
    }else if (direciton == 8 || direciton == 11) {
        ninaViewY = verticalScrollMode?0:FUll_CONTENT_HEIGHT_WITHOUT_TAB - selectionHeight;
    }
    if ((self.frame.origin.y == 0 && self.frame.origin.x == (horizontalScrollMode ?0:View_X)) || (self.frame.origin.y == _popY && self.frame.origin.x == (horizontalScrollMode ?0:View_X)) || (self.frame.origin.x == (horizontalScrollMode ?0:View_X) && self.frame.origin.y == (FUll_CONTENT_HEIGHT_WITHOUT_TAB - selectionHeight) / 2) || (self.frame.origin.y == FUll_CONTENT_HEIGHT_WITHOUT_TAB - selectionHeight && self.frame.origin.x == (horizontalScrollMode ?0:View_X))) {
        showState = NO;
        if (_shadowEffect) {
            [UIView animateWithDuration:duration animations:^{
                self.shadowView.alpha = 0.f;
            }];
        }
        switch (direciton / 3) {
            case 0:
                ninaViewY = verticalScrollMode?(-(FUll_CONTENT_HEIGHT_WITHOUT_TAB)):(-(selectionHeight));
                break;
            case 1:
                ninaViewY = verticalScrollMode?(FUll_CONTENT_HEIGHT_WITHOUT_TAB + FUll_VIEW_HEIGHT):(selectionHeight + FUll_VIEW_HEIGHT);
                break;
            case 2:
                ninaViewX = -(View_Width);
                break;
            case 3:
                ninaViewX = (FUll_VIEW_WIDTH);
                break;
            default:
                break;
        }
    }else {
        self.hidden = NO;
        showState = YES;
        [self.superview bringSubviewToFront:self];
        if (_shadowEffect) {
            [self.superview insertSubview:self.shadowView belowSubview:self];
            [UIView animateWithDuration:duration animations:^{
                if (_shadowAlpha > 0.f) {
                    self.shadowView.alpha = _shadowAlpha;
                }else {
                    self.shadowView.alpha = 0.5f;
                }
            }];
        }
    }
    return @[[NSString stringWithFormat:@"%f",ninaViewX],[NSString stringWithFormat:@"%f",ninaViewY]];
}

- (void)createSelectionButton {
    for (int i = 0; i < Titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i + 1;
        if(i < PerNum && i >= 0){
            button.frame = CGRectMake(Button_X +  i * (Button_Width + Button_Space) , Button_TopSpace,Button_Width, Button_Height);
        }else {
            button.frame = CGRectMake(Button_X +  (i % PerNum) * (Button_Width + Button_Space) , Button_TopSpace + (Button_Height + Button_Space) * (i / PerNum), Button_Width, Button_Height);
        }
        [button addTarget:self action:@selector(ButtonAciton:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:[Titles objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x656667) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.layer.cornerRadius = 4;
        button.layer.borderColor = UIColorFromRGB(0xDBDCDD).CGColor;
        button.layer.borderWidth = 1;
        [self addSubview:button];
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonLongPressed:)];
        [button addGestureRecognizer:longGesture];
        [buttonArray addObject:button];
    }
}

#pragma mark - UILongPressGestureRecognizerAction
- (void)buttonLongPressed:(UILongPressGestureRecognizer *)sender {
    UIButton *btn = (UIButton *)sender.view;
    if (sender.state == UIGestureRecognizerStateBegan) {
        StartPoint = [sender locationInView:sender.view];
        OriginPoint = btn.center;
        [UIView animateWithDuration:Hold_Duration animations:^{
            btn.transform = CGAffineTransformMakeScale(1.1, 1.1);
            btn.alpha = 0.7;
        }];
    }else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint newDragPoint = [sender locationInView:sender.view];
        CGFloat dragChangeX = newDragPoint.x - StartPoint.x;
        CGFloat dragChangeY = newDragPoint.y - StartPoint.y;
        btn.center = CGPointMake(btn.center.x + dragChangeX,btn.center.y + dragChangeY);
        NSInteger index = [self buttonIndexOfPoint:btn.center withDragButton:btn];
        if (index < 0) {
            Contain = NO;
        }else {
            [UIView animateWithDuration:Hold_Duration animations:^{
                CGPoint tempPoint = CGPointZero;
                UIButton *button = buttonArray[index];
                tempPoint = button.center;
                button.center = OriginPoint;
                btn.center = tempPoint;
                OriginPoint = btn.center;
                Contain = YES;
            }];
        }
    }else if (sender.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:Hold_Duration animations:^{
            btn.transform = CGAffineTransformIdentity;
            btn.alpha = 1.0;
            if (!Contain) {
                btn.center = OriginPoint;
            }
        }];
    }
}

- (NSInteger)buttonIndexOfPoint:(CGPoint)point withDragButton:(UIButton *)btn {
    for (NSInteger i = 0; i < buttonArray.count; i++) {
        UIButton *button = buttonArray[i];
        if (button != btn) {
            if (CGRectContainsPoint(button.frame, point)) {
                return i;
            }
        }
    }
    return -1;
}

#pragma mark - ButtonAction
- (void)ButtonAciton:(UIButton *)button {
    [self selectChangeColor:button];
    if ([self.selectionDelegate respondsToSelector:@selector(selectAction:)]) {
        [self.selectionDelegate selectAction:button];
    }
}

#pragma mark - SelectColorChangeAction
- (void)selectChangeColor:(UIButton *)changeBtn {
    for (NSInteger i = 0; i < buttonArray.count; i++) {
        UIButton *whiteButton = buttonArray[i];
        whiteButton.titleLabel.textColor = UIColorFromRGB(0x656667);
        whiteButton.backgroundColor = [UIColor whiteColor];
        whiteButton.layer.borderColor = UIColorFromRGB(0xDBDCDD).CGColor;
    }
    [changeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    changeBtn.backgroundColor = [UIColor colorWithRed:95/255.0f green:178/255.0f blue:244/255.0f alpha:1.0f];
    changeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
}

#pragma mark - TapAction
- (void)tapToDismissNinaView {
    if (tapDamping > 0 && tapVelocity > 0) {
        [self showOrDismissNinaViewWithDuration:tapDuration usingNinaSpringWithDamping:tapDamping initialNinaSpringVelocity:tapVelocity];
    }else {
        [self showOrDismissNinaViewWithDuration:tapDuration];
    }
}




@end
