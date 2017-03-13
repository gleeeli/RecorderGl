//
//  Common_define.h
//  HKC
//
//  Created by zhangshaoyu on 14-10-27.
//  Copyright (c) 2014年 zhangshaoyu. All rights reserved.
//  功能描述：常用宏定义

#ifndef HKC_Common_define_h
#define HKC_Common_define_h

/********************** 常用宏 ****************************/
#pragma mark - 常用宏

/// 判断无网络情况
#define GetNetworkStatusNotReachable ([Reachability reachabilityForInternetConnection].currentReachabilityStatus == NotReachable)

/// 当前版本号
#define GetCurrentVersion ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"])

/// 当前app delegate
#define GetAPPDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

#pragma mark - weakSelf

/// block self
#define kSelfWeak __weak typeof(self) weakSelf = self
#define kSelfStrong __strong __typeof__(self) strongSelf = weakSelf

#pragma mark - Local

/// Local
#define kLocalizedString(key) NSLocalizedString(key, nil)

#pragma mark - url

/// url
#define URLWithString(str)  [NSURL URLWithString:str]

#pragma mark - Height/Width

/// Height/Width

#define kScreenWidth        [UIScreen mainScreen].bounds.size.width
#define kScreenHeight       ([UIScreen mainScreen].bounds.size.height - 20.0)
#define kAllHeight          [UIScreen mainScreen].bounds.size.height
#define kBodyHeight         ([UIScreen mainScreen].bounds.size.height - 64.0)

#define kTabbarHeight       49
#define kSearchBarHeight    45
#define kStatusBarHeight    20
#define kNavigationHeight   44
/// 分类下拉框
#define kComboxListHeight kBodyHeight - kTabbarHeight - kComboxViewHeight- 88 //combox下拉框距tabbar上部88
#define kComboxViewHeight 75/2 //combox的高度

#pragma mark - System  Device

/// System  Device
#define ISiPhone    [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone
#define ISiPad      [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad
#define ISiPhone5   ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

// 测试 卜增彦 01.23
#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)) : NO)
// end

#pragma mark - system version

/// system version
#define ISIOS6 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) // IOS6的系统
#define ISIOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) // IOS7的系统
#define ISIOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) // IOS8的系统

#define UIInterfaceOrientationIsPortrait(orientation)  ((orientation) == UIInterfaceOrientationPortrait || (orientation) == UIInterfaceOrientationPortraitUpsideDown)
#define UIInterfaceOrientationIsLandscape(orientation) ((orientation) == UIInterfaceOrientationLandscapeLeft || (orientation) == UIInterfaceOrientationLandscapeRight)

#define INTERFACEPortrait self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown
#define INTERFACELandscape self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight

#pragma mark - Dlog

/// Dlog
#ifdef DEBUG
#   define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#   define ELog(err) {if(err) DLog(@"%@", err)}
#else
#   define DLog(...)
#   define ELog(err)
#endif

#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

#pragma mark - DataManager && UserModel

// DataManager && UserModel
#define GetDataManager [DataManager sharedManager]
#define GetDataUserModel [[DataManager sharedManager] userModel]

#pragma mark - 方便写接口

// 方便写接口
#define ParamsDic dic
#define CreateParamsDic NSMutableDictionary *ParamsDic = [NSMutableDictionary dictionary]
#define DicObjectSet(obj,key) [ParamsDic setObject:obj forKey:key]
#define DicValueSet(value,key) [ParamsDic setValue:value forKey:key]

#pragma mark - 数值转字符串

/// 数值转字符串
#define kIntToString(intValue) ([NSString stringWithFormat:@"%ld", intValue])
#define StrToInt(str) [str integerValue]
#define StrToDouble(str) [str doubleValue]
#define DoubleStringFormat(str) [NSString stringWithFormat:@"%.2f", [str doubleValue]]

/********************** 数值 ****************************/
#pragma mark - 数值

#define IQKeyboardDistanceFromTextField 10
#define IIViewleftSize 40.0 // 视图左侧栏视图间距
#define kTextFieldHeightCommon 44
#define kCommonlineHeight 0.5
#define kBaseTag 1000 //视图基本tag值
#define kCommonSeperateLineHeight 0.5 // 基本分割线高度
#define kloadfailedNotNetwork @"网络异常,请检查网络!" /// 网络断开

/********************** 标识 ****************************/

#define kSSToolkitTestsServiceName @"HKCUser"

#define kUserLoginAddressKey @"kUserLoginAddressKey"

//高德地图提醒标示
#define kHXCLMapShowMapAlert  @"hxclMapShowAlert"

/************************ 其他追加宏 **************************/

/**落落宏***/
#define LL_ORINGX(X) X.frame.origin.x
#define LL_ORINGY(Y) Y.frame.origin.y
#define LL_mmWidth(x) x.frame.size.width
#define LL_mmHeight(y) y.frame.size.height
#define LL_AUTO_ORINGX(w) (w.frame.origin.x+w.frame.size.width)
#define LL_AUTO_ORINGY(h) (h.frame.origin.y + h.frame.size.height)
#endif
