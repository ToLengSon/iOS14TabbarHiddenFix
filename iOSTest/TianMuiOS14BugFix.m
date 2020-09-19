//
//  TianMuiOS14BugFix.m
//  iOSTest
//
//  Created by wsong on 2020/9/19.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UIViewController (TianMuiOS14BugFix)

@property (nonatomic, assign) BOOL tianMuiOS14BugFix_isPoped;

@end

@implementation UIViewController (TianMuiOS14BugFix)

+ (void)load {
    if (@available(iOS 14, *)) {
        method_exchangeImplementations(class_getInstanceMethod(self, @selector(hidesBottomBarWhenPushed)),
                                       class_getInstanceMethod(self, @selector(tianMuiOS14BugFix_hidesBottomBarWhenPushed)));
    }
}

- (BOOL)tianMuiOS14BugFix_hidesBottomBarWhenPushed {
    if (self.tianMuiOS14BugFix_isPoped) {
        return self.navigationController.topViewController.hidesBottomBarWhenPushed;
    }
    return [self tianMuiOS14BugFix_hidesBottomBarWhenPushed];
}

- (void)setTianMuiOS14BugFix_isPoped:(BOOL)tianMuiOS14BugFix_isPoped {
    objc_setAssociatedObject(self, @selector(tianMuiOS14BugFix_isPoped), @(tianMuiOS14BugFix_isPoped), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)tianMuiOS14BugFix_isPoped {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end

@implementation UINavigationController (TianMuiOS14BugFix)

+ (void)load {
    if (@available(iOS 14, *)) {
        method_exchangeImplementations(class_getInstanceMethod(self, @selector(popToRootViewControllerAnimated:)),
                                       class_getInstanceMethod(self, @selector(tianMuiOS14BugFix_popToRootViewControllerAnimated:)));
        method_exchangeImplementations(class_getInstanceMethod(self, @selector(popToViewController:animated:)),
                                       class_getInstanceMethod(self, @selector(tianMuiOS14BugFix_popToViewController:animated:)));
    }
}


- (NSArray<__kindof UIViewController *> *)tianMuiOS14BugFix_popToRootViewControllerAnimated:(BOOL)animated {
    for (NSInteger i = 1; i < self.viewControllers.count; i++) {
        self.viewControllers[i].tianMuiOS14BugFix_isPoped = YES;
    }
    // 这句写在后面，因为系统调用popToRoot就会去遍历控制器获取hidesBottomBarWhenPushed来显示隐藏tabbar
    return [self tianMuiOS14BugFix_popToRootViewControllerAnimated:animated];
}

- (NSArray<__kindof UIViewController *> *)tianMuiOS14BugFix_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    for (UIViewController *childViewController in self.viewControllers.reverseObjectEnumerator) {
        if (viewController == childViewController) {
            break;
        }
        childViewController.tianMuiOS14BugFix_isPoped = YES;
    }
    // 这句写在后面，因为系统调用popToViewController就会去遍历控制器获取hidesBottomBarWhenPushed来显示隐藏tabbar
    return [self tianMuiOS14BugFix_popToViewController:viewController animated:animated];
}

@end
