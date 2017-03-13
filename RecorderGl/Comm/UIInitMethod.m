//
//  UIInitMethod.m
//  DemoUIInit
//
//  Created by zhangshaoyu on 14-5-21.
//  Copyright (c) 2014年 zhangshaoyu. All rights reserved.
//

#import "UIInitMethod.h"

@implementation UIInitMethod



/****************************************************************/

#pragma mark - 创建UI

#pragma mark UIAlertView
UIAlertView *SimpleAlert(UIAlertViewStyle style, NSString *title, NSString *message, NSInteger tag, id delegate, NSString *cancel, NSString *ok)
{
	UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancel otherButtonTitles:ok, nil];
    alertview.alertViewStyle = style;
    alertview.tag = tag;
	[alertview show];
    
    return [alertview autorelease];
}

UIAlertView *ActivityIndicatiorAlert(NSString *message, NSInteger tag, id delegate)
{
	UIAlertView *alertview = [[[UIAlertView alloc] initWithTitle:message message:nil delegate:delegate cancelButtonTitle:nil otherButtonTitles:nil] autorelease];
    alertview.tag = tag;
    [alertview show];
	
	//Adjust the indicator so it is up a few pixels from the bottom of the alert
	int x = alertview.bounds.size.width / 2;
	int y = alertview.bounds.size.height - 50.0;
    if (x == 0 || y == -50)
    {
        return nil;
    }
	
    __autoreleasing	UIActivityIndicatorView *indicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
    indicator.center = CGPointMake(x, y);
	[indicator startAnimating];
    
	[alertview addSubview:indicator];
    
	return alertview;
}

UIAlertView *AlertSetString(NSString *title, NSString *cancel, NSString *ok, NSString *set, NSInteger tag, id delegate, SEL selector)
{
	__strong UIAlertView *alertview = [[[UIAlertView alloc] initWithTitle:title message:@"\r\r" delegate:delegate cancelButtonTitle:cancel otherButtonTitles:ok, nil] autorelease];
    alertview.tag = tag;
    [alertview show];
	
	int x = alertview.bounds.size.width;
	int y = alertview.bounds.size.height;
    if (x == 0 || y == 0)
    {
        alertview = nil;
        return nil;
    }
    
	UITextField *myTextField = [[[UITextField alloc] initWithFrame:CGRectMake(x * 0.04, y - 110, x * 0.91, 25)] autorelease];
	myTextField.text = set;
    [myTextField addTarget:delegate action:selector forControlEvents:UIControlEventEditingDidEndOnExit];
	//[alert setTransform:myTransform];
	myTextField.tag = 100;
	[myTextField setBackgroundColor:[UIColor whiteColor]];
    
	[alertview addSubview:myTextField];
    
	return alertview;
}

#pragma mark UIDatePicker
UIDatePicker *SetDate(UIView *view, NSInteger tag, id delegate, UIInterfaceOrientation orientation)
{
	NSString *title = UIDeviceOrientationIsLandscape(orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n";
	
	UIActionSheet *actionsheet = [[[UIActionSheet alloc] initWithTitle:title
                                                              delegate:delegate
                                                     cancelButtonTitle:nil
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:nil] autorelease];
    actionsheet.tag = tag;
    [actionsheet showInView:view];
	
    __autoreleasing	UIDatePicker *datePicker = [[[UIDatePicker alloc] initWithFrame:actionsheet.bounds] autorelease];
	datePicker.tag = 101;
    
	[actionsheet addSubview:datePicker];
	
    return datePicker;
}

#pragma mark UIScrollView
UIScrollView *InsertScrollView(UIView *superView, CGRect rect, int tag,id<UIScrollViewDelegate> delegate)
{
    UIScrollView *scrollView = [[[UIScrollView alloc] initWithFrame:rect] autorelease];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scrollView.tag = tag;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = delegate;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    if (superView)
    {
        [superView addSubview:scrollView];
    }
    
    return scrollView;
}

#pragma mark UILabel
UILabel *InsertLabel(id superView, CGRect cRect, NSTextAlignment align, NSString *contentStr, UIFont *textFont, UIColor *textColor, BOOL resize)
{
    return InsertLabelWithShadow(superView, cRect, align, contentStr, textFont, textColor, resize, NO, nil, CGSizeMake(0.0, 0.0));
}

UILabel *InsertLabelWithShadow(id superView, CGRect cRect, NSTextAlignment align, NSString *contentStr, UIFont *textFont, UIColor *textColor, BOOL resize, BOOL shadow, UIColor *shadowColor, CGSize shadowOffset)
{
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:cRect];
    tempLabel.backgroundColor = [UIColor clearColor];
    tempLabel.textAlignment = align;
    tempLabel.textColor = textColor;
    tempLabel.font = textFont;
    tempLabel.text = contentStr;
    [tempLabel setNumberOfLines:1];
    
    if (superView)
    {
        [superView addSubview:tempLabel];
    }
    
    // 自适应大小
    if (resize && nil != contentStr)
    {
        [tempLabel setNumberOfLines:0];
        tempLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        CGSize size = CGSizeMake(cRect.size.width, 9999.9);
        CGSize labelsize = [contentStr sizeWithFont:textFont constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        tempLabel.frame = CGRectMake(cRect.origin.x, cRect.origin.y, labelsize.width, labelsize.height);
    }
    
    if (shadow)
    {
        if (shadowColor)
        {
            tempLabel.shadowColor = shadowColor;
        }
        tempLabel.shadowOffset = shadowOffset;
    }
	
    return [tempLabel autorelease];
}

#pragma mark UIWebView
UIWebView *InsertWebView(id superView,CGRect cRect, id<UIWebViewDelegate>delegate, int tag)
{
    UIWebView *tempWebView = [[UIWebView alloc] initWithFrame:cRect];
    tempWebView.tag = tag;
    [tempWebView setOpaque:NO];
    tempWebView.backgroundColor = [UIColor clearColor];
    tempWebView.delegate = delegate;
    tempWebView.scalesPageToFit = NO;
    tempWebView.scrollView.scrollEnabled = NO;
    
    if (superView)
    {
        [superView addSubview:tempWebView];
    }
    
    return [tempWebView autorelease];
}

void WebSimpleLoadRequest(UIWebView *web, NSString *strURL)
{
    NSURLRequest *request = [[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:strURL]] autorelease];
    
    [web loadRequest:request];
}

void WebSimpleLoadRequestWithCookie(UIWebView *web, NSString *strURL, NSString *cookies)
{
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strURL]] autorelease];
    [request addValue:cookies forHTTPHeaderField:@"Cookie"];
    [web loadRequest:request];
}

#pragma mark UIbutton
UIButton *InsertButtonRoundedRect(id view,  CGRect rc, int tag, NSString *title, id target, SEL action)
{
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = rc;
	[btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	[btn setTitle:title forState:UIControlStateNormal];
	[btn setTag:tag];
	
    if (view)
    {
        [view addSubview:btn];
    }
    
	return btn;
}

UIButton *InsertImageButton(id view, CGRect rc, int tag, UIImage *img, UIImage *imgH, id target, SEL action)
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = rc;
	[btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	[btn setTag:tag];
    
    if (nil != img)
    {
        [btn setBackgroundImage:img forState:UIControlStateNormal];
    }
    
    if (nil != imgH)
    {
        [btn setBackgroundImage:imgH forState:UIControlStateHighlighted];
    }
    
    if (view)
    {
        [view addSubview:btn];
    }
    
    return btn;
}

UIButton *InsertImageButtonWithTitle(id view, CGRect rc, int tag, UIImage *img, UIImage *imgH, NSString *title, UIEdgeInsets edgeInsets, UIFont *font, UIColor *color, id target, SEL action)
{
    UIButton *btn = InsertImageButton(view, rc, tag, img, imgH, target, action);
    
    if (nil != font)
    {
        btn.titleLabel.font = font;
    }
    if (nil != color)
    {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
    
    if (nil != title)
    {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    
    btn.titleEdgeInsets = edgeInsets;
    
    return btn;
}

UIButton *InsertTitleAndImageButton(id view, CGRect rc, int tag, NSString *title, UIEdgeInsets edgeInsets, UIFont *font, UIColor *color, UIColor *colorH, UIImage *img, UIImage *imgH, id target, SEL action)
{
    UIButton *btn = InsertImageButton(view, rc, tag, img, imgH, target, action);
    
    if (nil != font)
    {
        btn.titleLabel.font = font;
    }
    if (nil != color)
    {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
    if (nil != colorH)
    {
        [btn setTitleColor:colorH forState:UIControlStateHighlighted];
    }
    
    if (nil != title)
    {
        [btn setTitle:title forState:UIControlStateNormal];
        btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    
    btn.titleEdgeInsets = edgeInsets;
    
    return btn;
}

UIButton *InsertImageButtonWithSelectedImage(id view, CGRect rc, int tag, UIImage *img, UIImage *imgH, UIImage *imgSelected, BOOL selected, id target, SEL action)
{
    UIButton *btn = InsertImageButton(view, rc, tag, img, imgH, target, action);
    [btn setBackgroundImage:imgSelected forState:UIControlStateSelected];
    btn.selected = selected;
    
    return btn;
}

UIButton *InsertImageButtonWithSelectedImageAndTitle(id view, CGRect rc, int tag, UIImage *img, UIImage *imgH, UIImage *imgSelected, BOOL selected, NSString *title, UIEdgeInsets edgeInsets, UIFont *font, UIColor *color, id target, SEL action)
{
    UIButton *btn = InsertImageButtonWithSelectedImage(view, rc, tag, img, imgH, imgSelected, selected, target, action);
    
    if (nil != font)
    {
        btn.titleLabel.font = font;
    }
    if (nil != color)
    {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
    
    if (nil != title)
    {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    btn.titleEdgeInsets = edgeInsets;
    
    return btn;
}

UIButton *InsertButtonWithType(id view, CGRect rc, int tag, id target, SEL action, UIButtonType type)
{
    UIButton *btn = [UIButton buttonWithType:type];
    btn.frame = rc;
	[btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	[btn setTag:tag];
    btn.backgroundColor = [UIColor clearColor];
	
    if (view)
    {
        [view addSubview:btn];
    }
    
    return btn;
}

#pragma mark UITableView
UITableView *InsertTableView(id superView, CGRect rect, id<UITableViewDataSource> dataSoure, id<UITableViewDelegate> delegate, UITableViewStyle style, UITableViewCellSeparatorStyle cellStyle)
{
    UITableView *tabView = [[UITableView alloc] initWithFrame:rect style:style];
    tabView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    if (dataSoure)
    {
        tabView.dataSource = dataSoure;
    }
    if (delegate)
    {
        tabView.delegate = delegate;
    }
    tabView.separatorStyle = cellStyle;
    tabView.backgroundView = nil;
    
    if (superView)
    {
        [superView addSubview:tabView];
    }
    
    return [tabView autorelease];
}

#pragma mark UITextField
UITextField *InsertTextField(id view, id delegate, CGRect rc, NSString *placeholder, UIFont *font, NSTextAlignment textAlignment, UIControlContentVerticalAlignment contentVerticalAlignment)
{
    return InsertTextFieldWithTextColor(view, delegate, rc, placeholder, font, textAlignment, contentVerticalAlignment, nil);
}

UITextField *InsertTextFieldWithTextColor(id view, id delegate, CGRect rc, NSString *placeholder, UIFont *font, NSTextAlignment textAlignment, UIControlContentVerticalAlignment contentVerticalAlignment, UIColor *textFieldColor)
{
    return InsertTextFieldWithBorderAndCorRadius(view, delegate, rc, placeholder, font, textAlignment, contentVerticalAlignment, 0.0, nil, textFieldColor, 0.0);
}

UITextField *InsertTextFieldWithBorderAndCorRadius(id view, id delegate, CGRect rc, NSString *placeholder, UIFont *font, NSTextAlignment textAlignment, UIControlContentVerticalAlignment contentVerticalAlignment, float borderwidth, UIColor *bordercolor, UIColor *textFieldColor, float cornerRadius)
{
    UITextField *myTextField = [[UITextField alloc] initWithFrame:rc];
    myTextField.delegate = delegate;
	myTextField.placeholder = placeholder;
	myTextField.font = font;
    myTextField.textAlignment = textAlignment;
    myTextField.contentVerticalAlignment = contentVerticalAlignment;
    myTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    myTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    if (!textFieldColor)
    {
        myTextField.textColor = [UIColor whiteColor];
    }
    else
    {
        myTextField.textColor = textFieldColor;
    }
    
    if (bordercolor && 0.0 != borderwidth)
    {
        myTextField.layer.borderWidth = borderwidth;
        myTextField.layer.borderColor = bordercolor.CGColor;
    }
    
    if (0.0 != cornerRadius)
    {
        myTextField.layer.cornerRadius = cornerRadius;
    }
    
    if (view)
    {
        [view addSubview:myTextField];
    }
    
	return [myTextField autorelease];
}

#pragma mark UITextView
UITextView *InsertTextView(id view, id delegate, CGRect rc, UIFont *font, NSTextAlignment textAlignment)
{
    return InsertTextViewWithTextColor(view, delegate, rc, font, textAlignment, nil);
}

UITextView *InsertTextViewWithTextColor(id view, id delegate, CGRect rc, UIFont *font, NSTextAlignment textAlignment, UIColor *textcolor)
{
    return InsertTextViewWithBorderAndCorRadius(view, delegate, rc, font, textAlignment, 0.0, nil, textcolor, 0.0);
}

UITextView *InsertTextViewWithBorderAndCorRadius(id view, id delegate, CGRect rc, UIFont *font, NSTextAlignment textAlignment, float borderwidth, UIColor *bordercolor, UIColor *textcolor, float cornerRadius)
{
    UITextView *textview = [[UITextView alloc] initWithFrame:rc];
    textview.delegate = delegate;
	textview.font = font;
    textview.textAlignment = textAlignment;
    textview.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textview.autocorrectionType = UITextAutocorrectionTypeNo;
    
    if (!textcolor)
    {
        textview.textColor = [UIColor whiteColor];
    }
    else
    {
        textview.textColor = textcolor;
    }
    
    if (bordercolor && 0.0 != borderwidth)
    {
        textview.layer.borderWidth = borderwidth;
        textview.layer.borderColor = bordercolor.CGColor;
    }
    
    if (0.0 != cornerRadius)
    {
        textview.layer.cornerRadius = cornerRadius;
    }
    
    if (view)
    {
        [view addSubview:textview];
    }
    
	return [textview autorelease];
}

#pragma mark UISwitch
UISwitch *InsertSwitch(id view, CGRect rc)
{
	UISwitch *sw = [[UISwitch alloc] initWithFrame:rc];
    
    if (view)
    {
        [view addSubview:sw];
    }
    
	return [sw autorelease];
}

#pragma mark UIImageView
UIImageView *InsertImageView(id view, CGRect rect, UIImage *image)
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    
    if (image)
    {
        [imageView setImage:image];
    }
    
    imageView.userInteractionEnabled = YES;
    
    if (view)
    {
        [view addSubview:imageView];
    }
    
    return [imageView autorelease];
}

#pragma mark UIView
UIView *InsertView(id view, CGRect rect, UIColor *backColor)
{
    return InsertViewWithBorder(view, rect, backColor, 0.0, nil);
}

UIView *InsertViewWithBorder(id view, CGRect rect, UIColor *backColor, CGFloat borderwidth, UIColor *bordercolor)
{
    return InsertViewWithBorderAndCorRadius(view, rect, backColor, borderwidth, bordercolor, 0.0);
}

UIView *InsertViewWithBorderAndCorRadius(id view, CGRect rect, UIColor *backColor, CGFloat borderwidth, UIColor *bordercolor, CGFloat corRadius)
{
    UIView *_view = [[UIView alloc] initWithFrame:rect];
    _view.backgroundColor = backColor;
    
    if (view)
    {
        [view addSubview:_view];
    }
    
    if (bordercolor && 0.0 != borderwidth)
    {
        _view.layer.borderWidth = borderwidth;
        _view.layer.borderColor = bordercolor.CGColor;
    }
    
    if (0.0 != corRadius)
    {
        _view.layer.cornerRadius = corRadius;
    }
    
    return [_view autorelease];
}

#pragma mark UIPickerView
UIPickerView *InsertPickerView(id view, CGRect rect)
{
    UIPickerView *_view = [[UIPickerView alloc] initWithFrame:rect];
    _view.showsSelectionIndicator = YES;
    
    if (view)
    {
        [view addSubview:_view];
    }
    
    return [_view autorelease];
}

#pragma mark UIBarButtonItem
UIBarButtonItem *InsertBarButtonItem(CGRect rect, int tag, UIImage *normalImage, UIImage *hightlightImage, NSString *titleBtn, UIFont *titleFont, UIColor *titleColor, id target, SEL action)
{
    UIButton *btn = InsertImageButtonWithTitle(nil, rect, tag, normalImage, hightlightImage, titleBtn, UIEdgeInsetsMake(0,0,0,0), titleFont, titleColor, target, action);
    
    UIBarButtonItem *barButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
    
    return barButtonItem;
}

#pragma mark UIProgressView
UIProgressView *InsertProgressView(id view, CGRect rect, UIProgressViewStyle style, CGFloat progressValue, UIColor *progressColor, UIColor *backColor)
{
    UIProgressView *progressView = [[[UIProgressView alloc] initWithFrame:rect] autorelease];
    
    if (view)
    {
        [view addSubview:progressView];
    }
    
    progressView.backgroundColor = [UIColor clearColor];
    progressView.progressViewStyle = style;
    progressView.progress = progressValue;
    
    if (progressColor && [progressView respondsToSelector:@selector(setProgressTintColor:)])
    {
        progressView.progressTintColor = progressColor;
    }
    
    if (backColor && [progressView respondsToSelector:@selector(setTrackTintColor:)])
    {
        progressView.trackTintColor = backColor;
    }
    
    return progressView;
}

#pragma mark UIActivityIndicatorView
UIActivityIndicatorView *InsertActivityIndicatorView(id view, CGRect rect, UIColor *backColor, UIColor *styleColor, UIActivityIndicatorViewStyle style)
{
    UIActivityIndicatorView *activityView = [[[UIActivityIndicatorView alloc] initWithFrame:rect] autorelease];
    
    // 添加到父视图
    if (view)
    {
        [view addSubview:activityView];
    }
    
    // 背景颜色
    activityView.backgroundColor = (backColor ? backColor : [UIColor clearColor]);
    
    // 类型
    activityView.activityIndicatorViewStyle = style;
    
    // 转圈圈图标颜色（iOS5.0以下才支持颜色设置）
    if (styleColor && [activityView respondsToSelector:@selector(setColor:)])
    {
        activityView.color = styleColor;
    }
    
    return activityView;
}

#pragma mark UIActionSheet
// 两个按钮（取消与确定）
UIActionSheet *InsertActionSheet(id view, id delegate, UIActionSheetStyle style, NSString *title, NSString *canael, NSString *confirm)
{
    return InsertActionSheetWithTwoSelected(view, delegate, style, title, canael, nil, confirm, nil);
}

// 三个按钮（取消与其他）
UIActionSheet *InsertActionSheetWithTwoSelected(id view, id delegate, UIActionSheetStyle style, NSString *title, NSString *canael, NSString *confirm, NSString *firstBtn, NSString *sectionBtn)
{
    UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:title
                                                              delegate:delegate
                                                     cancelButtonTitle:canael
                                                destructiveButtonTitle:confirm
                                                     otherButtonTitles:firstBtn, sectionBtn, nil] autorelease];
    
    if (view)
    {
        [actionSheet showInView:view];
    }
    
    actionSheet.actionSheetStyle = style;
    
    return actionSheet;
}

#pragma mark UISearchBar
// 搜索视图
UISearchBar *InsertSearchBar(id view, CGRect rect, id delegate, NSString *placeholder)
{
    return InsertSearchBarWithStyle(view, rect, delegate, placeholder, 0, nil, nil, nil);
}

// 搜索视图（可自定义样式）
UISearchBar *InsertSearchBarWithStyle(id view, CGRect rect, id delegate, NSString *placeholder, UISearchBarStyle style, UIColor *tintColor, UIColor *barColor, UIImage *backImage)
{
    UISearchBar *searchBar = [[[UISearchBar alloc] initWithFrame:rect] autorelease];
    
    if (view)
    {
        [view addSubview:searchBar];
    }
    
    searchBar.delegate = delegate;
    searchBar.placeholder = placeholder;
    
    if (0 != style && [searchBar respondsToSelector:@selector(setSearchBarStyle:)])
    {
        searchBar.searchBarStyle = UISearchBarStyleProminent;
    }
    
    if (tintColor && [searchBar respondsToSelector:@selector(setTintColor:)])
    {
        searchBar.tintColor = tintColor;
    }
    
    if (barColor && [searchBar respondsToSelector:@selector(setBarTintColor:)])
    {
        searchBar.barTintColor = barColor;
    }
    
    if (backImage && [searchBar respondsToSelector:@selector(setBackgroundImage:)])
    {
        searchBar.backgroundImage = backImage;
    }
    
    return searchBar;
}

#pragma mark UIPageControl
UIPageControl *InsertPageControl(id view, CGRect rect, NSInteger pageCounts, NSInteger currentPage, UIColor *backColor, UIColor *pageColor, UIColor *currentPageColor)
{
    UIPageControl *pageCtr = [[[UIPageControl alloc] initWithFrame:rect] autorelease];
    
    if (view)
    {
        [view addSubview:pageCtr];
    }
    
    pageCtr.backgroundColor = (backColor ? backColor : [UIColor clearColor]);
    
    pageCtr.numberOfPages = pageCounts;
    pageCtr.currentPage = currentPage;
    
    if (pageColor && [pageCtr respondsToSelector:@selector(setPageIndicatorTintColor:)])
    {
        pageCtr.pageIndicatorTintColor = pageColor;
    }
    
    if (currentPageColor && [pageCtr respondsToSelector:@selector(setCurrentPageIndicatorTintColor:)])
    {
        pageCtr.currentPageIndicatorTintColor = currentPageColor;
    }
    
    return pageCtr;
}

#pragma mark UISlider
// 创建UISlider
UISlider *insertSlider(id view, CGRect rect, id target, SEL action)
{
    return insertSliderWithValue(view, rect, target, action, 0.0, 0.0);
}

// 创建UISlider（自定义最大最小值）
UISlider *insertSliderWithValue(id view, CGRect rect, id target, SEL action, CGFloat minVlaue, CGFloat maxValue)
{
    return insertSliderWithValueAndColor(view, rect, target, action, minVlaue, maxValue, nil, nil, nil);
}

// 创建UISlider（自定义最大最小值，及颜色显示）
UISlider *insertSliderWithValueAndColor(id view, CGRect rect, id target, SEL action, CGFloat minVlaue, CGFloat maxValue, UIColor *minColor, UIColor *maxColor, UIColor *thumbTintColor)
{
    return insertSliderWithValueAndColorAndImage(view, rect, target, action, minVlaue, maxValue, minColor, maxColor, thumbTintColor, nil, nil);
}

// 创建UISlider（自定义最大最小值，及颜色，图标显示）
UISlider *insertSliderWithValueAndColorAndImage(id view, CGRect rect, id target, SEL action, CGFloat minVlaue, CGFloat maxValue, UIColor *minColor, UIColor *maxColor, UIColor *thumbTintColor, UIImage *minImage, UIImage *maxImage)
{
    UISlider *sliderView = [[[UISlider alloc] initWithFrame:rect] autorelease];
    
    if (view)
    {
        [view addSubview:sliderView];
    }
    
    sliderView.backgroundColor = [UIColor clearColor];
    
    if (minVlaue != maxValue)
    {
        sliderView.minimumValue = minVlaue;
        sliderView.maximumValue = maxValue;
    }
    
    if (minColor && [sliderView respondsToSelector:@selector(setMinimumTrackTintColor:)])
    {
        sliderView.minimumTrackTintColor = minColor;
    }
    
    if (maxColor && [sliderView respondsToSelector:@selector(setMaximumTrackTintColor:)])
    {
        sliderView.maximumTrackTintColor = maxColor;
    }
    
    if (thumbTintColor && [sliderView respondsToSelector:@selector(setThumbTintColor:)])
    {
        sliderView.thumbTintColor = thumbTintColor;
    }
    
    if (minImage && [sliderView respondsToSelector:@selector(setMinimumValueImage:)])
    {
        sliderView.minimumValueImage = minImage;
    }
    
    if (maxImage && [sliderView respondsToSelector:@selector(setMaximumValueImage:)])
    {
        sliderView.maximumValueImage = maxImage;
    }
    
    [sliderView addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    
    return sliderView;
}

#pragma mark UISegmentedControl
// 创建UISegmentedControl
UISegmentedControl *insertSegment(id view, NSArray *titleArray, CGRect rect, id target, SEL action)
{
    return insertSegmentWithColor(view, titleArray, rect, target, action, nil);
}

// 创建UISegmentedControl（设置颜色）
UISegmentedControl *insertSegmentWithColor(id view, NSArray *titleArray, CGRect rect, id target, SEL action, UIColor *tintColor)
{
    return insertSegmentWithSelectedIndexAndColor(view, titleArray, rect, target, action, 0, tintColor);
}

// 创建UISegmentedControl（设置颜色及被始化被选择索引）
UISegmentedControl *insertSegmentWithSelectedIndexAndColor(id view, NSArray *titleArray, CGRect rect, id target, SEL action, NSInteger selectedIndex, UIColor *tintColor)
{
    UISegmentedControl *segmentCtr = [[[UISegmentedControl alloc] initWithItems:titleArray] autorelease];
    
    if (view)
    {
        [view addSubview:segmentCtr];
    }
    
    segmentCtr.backgroundColor = [UIColor clearColor];
    segmentCtr.frame = rect;
    segmentCtr.momentary = YES;
    
    if (tintColor && [segmentCtr respondsToSelector:@selector(setTintColor:)])
    {
        segmentCtr.tintColor = tintColor;
    }
    
    segmentCtr.selectedSegmentIndex = selectedIndex;
    
    [segmentCtr addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    
    return segmentCtr;
}

#pragma mark UIImagePickerController
UIImagePickerController *InsertImagePicker(UIImagePickerControllerSourceType style, id delegate, UIImage *navImage)
{
    UIImagePickerController *imagePickCtr = [[[UIImagePickerController alloc] init] autorelease];
    imagePickCtr.sourceType = style;
    imagePickCtr.delegate = delegate;
    if (navImage && [imagePickCtr respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [imagePickCtr.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
    }
    
    return imagePickCtr;
}

/****************************************************************/

#pragma mark - 父视图或父视图控制器的操作

void AddSubController(UIView *view, UIViewController *ctrl, BOOL animation)
{
    [ctrl viewWillAppear:animation];
    [view addSubview:ctrl.view];
    [ctrl viewDidAppear:animation];
}

void RemoveSubController(UIViewController *ctrl, BOOL animation)
{
    [ctrl viewWillDisappear:animation];
    [ctrl.view removeFromSuperview];
    [ctrl viewDidDisappear:animation];
}

void RemoveAllSubviews(UIView *view)
{
    for (int i = view.subviews.count; i > 0; i--)
    {
        [[view.subviews objectAtIndex:i-1] removeFromSuperview];
    }
}

/****************************************************************/

#pragma mark - 设置时间定时器

NSTimer *SetTimer(NSTimeInterval timeElapsed, id target, SEL selector)
{
    NSTimer *ret = [NSTimer timerWithTimeInterval:timeElapsed target:target selector:selector userInfo:nil repeats:YES];
    if (nil == ret)
    {
        return nil;
    }
    
    [[NSRunLoop currentRunLoop] addTimer:ret forMode:NSDefaultRunLoopMode];
    
    return ret;
}

NSTimer *SetTimerWithUserData(NSTimeInterval timeElapsed, id data, id target, SEL selector)
{
    NSTimer *ret = [NSTimer timerWithTimeInterval:timeElapsed target:target selector:selector userInfo:data repeats:YES];
    if (nil == ret)
    {
        return nil;
    }
    
    [[NSRunLoop currentRunLoop] addTimer:ret forMode:NSDefaultRunLoopMode];
    
    return ret;
}

void KillTimer(NSTimer *timer)
{
    if ([timer isValid])
    {
        [timer invalidate];
        timer = nil;
    }
}

@end
