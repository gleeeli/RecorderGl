//
//  UIInitMethod.h
//  DemoUIInit
//
//  Created by zhangshaoyu on 14-5-21.
//  Copyright (c) 2014年 zhangshaoyu. All rights reserved.
//  功能描述：用于创建UI子类，避免重复编码，造成代码冗余

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIInitMethod : NSObject


/****************************************************************/

#pragma mark - 创建UI

#pragma mark UIAlertView
/// 实例化UIAlertView
UIAlertView *SimpleAlert(UIAlertViewStyle style, NSString *title, NSString *message, NSInteger tag, id delegate, NSString *cancel, NSString *ok);

/// 实例化UIAlertView
UIAlertView *ActivityIndicatiorAlert(NSString *message, NSInteger tag, id delegate);

/// 实例化UIAlertView
UIAlertView *AlertSetString(NSString *title, NSString *cancel, NSString *ok, NSString *set, NSInteger tag, id delegate, SEL selector);

#pragma mark UIDatePicker
/// 实例化UIDatePicker
UIDatePicker *SetDate(UIView *view, NSInteger tag, id delegate, UIInterfaceOrientation orientation);

#pragma mark UIScrollView
/// 实例化UIScrollView
UIScrollView *InsertScrollView(UIView *superView, CGRect rect, int tag,id<UIScrollViewDelegate> delegate);

#pragma mark UILabel
/// 实例化UILabel，带自适应高度
UILabel *InsertLabel(id superView, CGRect cRect, NSTextAlignment align, NSString *contentStr, UIFont *textFont, UIColor *textColor, BOOL resize);

/// 实例化UILabel，带阴影
UILabel *InsertLabelWithShadow(id superView, CGRect cRect, NSTextAlignment align, NSString *contentStr, UIFont *textFont, UIColor *textColor, BOOL resize, BOOL shadow, UIColor *shadowColor, CGSize shadowOffset);

#pragma mark UIWebView
/// 实例化UIWebView
UIWebView *InsertWebView(id superView,CGRect cRect, id<UIWebViewDelegate>delegate, int tag);

/// UIWebView使用
void WebSimpleLoadRequest(UIWebView *web, NSString *strURL);
void WebSimpleLoadRequestWithCookie(UIWebView *web, NSString *strURL, NSString *cookies);

#pragma mark UIbutton
/// 实例化UIbutton（带标题的圆角样式）
UIButton *InsertButtonRoundedRect(id view, CGRect rc, int tag, NSString *title, id target, SEL action);

/// 实例化UIbutton（带图片的自定义样式）
UIButton *InsertImageButton(id view, CGRect rc, int tag, UIImage *img, UIImage *imgH, id target, SEL action);

/// 实例化UIbutton（带图片及标题的自定义样式）
UIButton *InsertImageButtonWithTitle(id view, CGRect rc, int tag, UIImage *img, UIImage *imgH, NSString *title, UIEdgeInsets edgeInsets, UIFont *font, UIColor *color, id target, SEL action);

/// 实例化UIbutton（带标题与图片的自定义样式）
UIButton *InsertTitleAndImageButton(id view, CGRect rc, int tag, NSString *title, UIEdgeInsets edgeInsets, UIFont *font, UIColor *color, UIColor *colorH, UIImage *img, UIImage *imgH, id target, SEL action);

/// 实例化UIbutton（带选中图片的自定义样式）
UIButton *InsertImageButtonWithSelectedImage(id view, CGRect rc, int tag, UIImage *img, UIImage *imgH, UIImage *imgSelected, BOOL selected, id target, SEL action);

/// 实例化UIbutton（带选中图片及标题的自定义样式）
UIButton *InsertImageButtonWithSelectedImageAndTitle(id view, CGRect rc, int tag, UIImage *img, UIImage *imgH, UIImage *imgSelected, BOOL selected, NSString *title, UIEdgeInsets edgeInsets, UIFont *font, UIColor *color, id target, SEL action);

/// 实例化UIbutton（自定义样式）
UIButton *InsertButtonWithType(id view, CGRect rc, int tag, id target, SEL action, UIButtonType type);

#pragma mark UITableView
/// 实例化UITableView
UITableView *InsertTableView(id superView, CGRect rect, id<UITableViewDataSource> dataSoure, id<UITableViewDelegate> delegate, UITableViewStyle style, UITableViewCellSeparatorStyle cellStyle);

#pragma mark UITextField
/// 实例化UITextField，未设置字体颜色
UITextField *InsertTextField(id view, id delegate, CGRect rc, NSString *placeholder, UIFont *font, NSTextAlignment textAlignment, UIControlContentVerticalAlignment contentVerticalAlignment);

/// 实例化UITextField，设置字体颜色
UITextField *InsertTextFieldWithTextColor(id view, id delegate, CGRect rc, NSString *placeholder, UIFont *font, NSTextAlignment textAlignment, UIControlContentVerticalAlignment contentVerticalAlignment, UIColor *textFieldColor);

/// 实例化UITextField，带边框及圆角
UITextField *InsertTextFieldWithBorderAndCorRadius(id view, id delegate, CGRect rc, NSString *placeholder, UIFont *font, NSTextAlignment textAlignment, UIControlContentVerticalAlignment contentVerticalAlignment, float borderwidth, UIColor *bordercolor, UIColor *textFieldColor, float cornerRadius);

#pragma mark UITextView
/// 实例化UITextView，未设置字体颜色
UITextView *InsertTextView(id view, id delegate, CGRect rc, UIFont *font, NSTextAlignment textAlignment);

/// 实例化UITextView，设置字体颜色
UITextView *InsertTextViewWithTextColor(id view, id delegate, CGRect rc, UIFont *font, NSTextAlignment textAlignment, UIColor *textcolor);

/// 实例化UITextView，带边框及圆角
UITextView *InsertTextViewWithBorderAndCorRadius(id view, id delegate, CGRect rc, UIFont *font, NSTextAlignment textAlignment, float borderwidth, UIColor *bordercolor, UIColor *textcolor, float cornerRadius);

#pragma mark UISwitch
/// 实例化UISwitch
UISwitch *InsertSwitch(id view, CGRect rc);

#pragma mark UIImageView
/// 实例化UIImageView
UIImageView *InsertImageView(id view, CGRect rect, UIImage *image);

#pragma mark UIView
/// 实例化UIView
UIView *InsertView(id view, CGRect rect, UIColor *backColor);

/// 实例化UIView，带边框
UIView *InsertViewWithBorder(id view, CGRect rect, UIColor *backColor, CGFloat borderwidth, UIColor *bordercolor);

/// 实例化UIView，带边框和圆角
UIView *InsertViewWithBorderAndCorRadius(id view, CGRect rect, UIColor *backColor, CGFloat borderwidth, UIColor *bordercolor, CGFloat corRadius);

#pragma mark UIPickerView
/// 实例化UIPickerView
UIPickerView *InsertPickerView(id view, CGRect rect);

#pragma mark UIBarButtonItem
UIBarButtonItem *InsertBarButtonItem(CGRect rect, int tag, UIImage *normalImage, UIImage *hightlightImage, NSString *titleBtn, UIFont *titleFont, UIColor *titleColor, id target, SEL action);

#pragma mark UIProgressView
UIProgressView *InsertProgressView(id view, CGRect rect, UIProgressViewStyle style, CGFloat progressValue, UIColor *progressColor, UIColor *backColor);

#pragma mark UIActivityIndicatorView
UIActivityIndicatorView *InsertActivityIndicatorView(id view, CGRect rect, UIColor *backColor, UIColor *styleColor, UIActivityIndicatorViewStyle style);

#pragma mark UIActionSheet
/// 两个按钮（取消与确定）
UIActionSheet *InsertActionSheet(id view, id delegate, UIActionSheetStyle style, NSString *title, NSString *canael, NSString *confirm);

/// 四个按钮（取消与确定与其他）
UIActionSheet *InsertActionSheetWithTwoSelected(id view, id delegate, UIActionSheetStyle style, NSString *title, NSString *canael, NSString *confirm, NSString *firstBtn, NSString *sectionBtn);

#pragma mark UISearchBar
/// 搜索视图
UISearchBar *InsertSearchBar(id view, CGRect rect, id delegate, NSString *placeholder);

/// 搜索视图（可自定义样式）
UISearchBar *InsertSearchBarWithStyle(id view, CGRect rect, id delegate, NSString *placeholder, UISearchBarStyle style, UIColor *tintColor, UIColor *barColor, UIImage *backImage);

#pragma mark UIPageControl
UIPageControl *InsertPageControl(id view, CGRect rect, NSInteger pageCounts, NSInteger currentPage, UIColor *backColor, UIColor *pageColor, UIColor *currentPageColor);

#pragma mark UISlider
/// 创建UISlider
UISlider *insertSlider(id view, CGRect rect, id target, SEL action);

/// 创建UISlider（自定义最大最小值）
UISlider *insertSliderWithValue(id view, CGRect rect, id target, SEL action, CGFloat minVlaue, CGFloat maxValue);

/// 创建UISlider（自定义最大最小值，及颜色显示）
UISlider *insertSliderWithValueAndColor(id view, CGRect rect, id target, SEL action, CGFloat minVlaue, CGFloat maxValue, UIColor *minColor, UIColor *maxColor, UIColor *thumbTintColor);

/// 创建UISlider（自定义最大最小值，及颜色，图标显示）
UISlider *insertSliderWithValueAndColorAndImage(id view, CGRect rect, id target, SEL action, CGFloat minVlaue, CGFloat maxValue, UIColor *minColor, UIColor *maxColor, UIColor *thumbTintColor, UIImage *minImage, UIImage *maxImage);

#pragma mark UISegmentedControl
/// 创建UISegmentedControl
UISegmentedControl *insertSegment(id view, NSArray *titleArray, CGRect rect, id target, SEL action);

/// 创建UISegmentedControl（设置颜色）
UISegmentedControl *insertSegmentWithColor(id view, NSArray *titleArray, CGRect rect, id target, SEL action, UIColor *tintColor);

/// 创建UISegmentedControl（设置颜色及被始化被选择索引）
UISegmentedControl *insertSegmentWithSelectedIndexAndColor(id view, NSArray *titleArray, CGRect rect, id target, SEL action, NSInteger selectedIndex, UIColor *tintColor);

#pragma mark UIImagePickerController
UIImagePickerController *InsertImagePicker(UIImagePickerControllerSourceType style, id delegate, UIImage *navImage);

/****************************************************************/

#pragma mark - 视图或视图控制器的操作
/// 视图上添加子视图控制器
void AddSubController(UIView *view, UIViewController *ctrl, BOOL animation);

/// 移除父视图控制器中的子视图控制器
void RemoveSubController(UIViewController *ctrl, BOOL animation);

/// 移除父视图中的子视图
void RemoveAllSubviews(UIView *view);

/****************************************************************/

#pragma mark - 设置时间定时器

/// 设置时间定时器
NSTimer *SetTimer(NSTimeInterval timeElapsed, id target, SEL selector);

/// 设置时间定时器，附带用户数据信息
NSTimer *SetTimerWithUserData(NSTimeInterval timeElapsed, id data, id target, SEL selector);

/// 停止时间定时器
void KillTimer(NSTimer *timer);

@end
