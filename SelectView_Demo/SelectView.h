//
//  SelectView.h
//  SelectView_Demo
//
//  Created by admin on 16/7/26.
//  Copyright © 2016年 AlezJi. All rights reserved.
//


//RGB Color
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//FullScreen
#define FUll_VIEW_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define FUll_VIEW_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define FUll_CONTENT_HEIGHT_WITHOUT_TAB ([[UIScreen mainScreen] bounds].size.height-64)
#define SELFWIDTH self.frame.size.width
#define SELFHEIGHT self.frame.size.height
#define NinaNavigationBarHeight 64

//Parameters
#define PerNum  3 //Better between 2~5   
#define View_Width FUll_VIEW_WIDTH
#define View_X (FUll_VIEW_WIDTH - View_Width) / 2
#define Button_X 15
#define Button_Height 30
#define Button_Width (View_Width - 2 * Button_X - (PerNum - 1) * Button_Space) / PerNum
#define Button_TopSpace 17.5
#define Button_Space 10
#define Hold_Duration 0.2




#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, PopDirection) {
    /**<  Pop from above   **/
    PopFromAboveToTop = 0,
    PopFromAboveToMiddle = 1,
    PopFromAboveToBottom = 2,
    /**<  Pop from below   **/
    PopFromBelowToTop = 3,
    PopFromBelowToMiddle = 4,
    PopFromBelowToBottom = 5,
    /**<  Pop from left   **/
    PopFromLeftToTop = 6,
    PopFromLeftToMiddle = 7,
    PopFromLeftToBottom = 8,
    /**<  Pop from right   **/
    PopFromRightToTop = 9,
    PopFromRightToMiddle = 10,
    PopFromRightToBottom = 11,
};

@protocol SelectionDelegate <NSObject>
@optional
- (void)selectAction:(UIButton *)button;
@end


@interface SelectView : UIScrollView
- (instancetype)initWithTitles:(NSArray *)titles PopDirection:(PopDirection)direction;
- (void)showOrDismissNinaViewWithDuration:(NSTimeInterval)duration;
- (void)showOrDismissNinaViewWithDuration:(NSTimeInterval)duration usingNinaSpringWithDamping:(CGFloat)dampingRatio initialNinaSpringVelocity:(CGFloat)velocity;
@property (nonatomic, assign) NSInteger defaultSelected;
@property (nonatomic, assign) BOOL shadowEffect;
@property (nonatomic, assign) CGFloat shadowAlpha;
@property (nonatomic, assign) CGFloat popY;
@property (nonatomic, weak)id<SelectionDelegate>selectionDelegate;
@end
