# iOS14TabbarHiddenFix
解决iOS14下pop多层控制器至主页时，tabbar不显示问题

iOS14上，popToRoot或者popTo指定控制器，立马去拿viewControllers属性与iOS13有区别，iOS14会包含当前控制器，例如：A->B->C，这时候在C pop到A，viewControllers为[C,A]，在iOS13是[A]，而通过汇编查看了下系统的实现，系统会去拿数组中的控制器先翻转成[A,C]，然后遍历获取hidesBottomBarWhenPushed属性，因此A最外层为YES会被C的hidesBottomBarWhenPushed覆盖，从而隐藏了tabbar，根据该思路，可以分类hook hidesBottomBarWhenPushed，判断当前控制器是否被pop了，从而返回最topViewController.hidesBottomBarWhenPushed

Demo运行过程：
  点击红色页面时会push至黄色页面，停留3s后又push黄色页面，持续3次，待不再push时，点击pop页面会进行popToRoot操作，可以看到tabbar并未被隐藏；
Demo中主要文件TianMuiOS14BugFix，拖拽至项目中即可，就不做cocoapods了

解决方法1:
```objective-c
// 如果popTo之后立马调用pushViewController此时之前的C控制器还未从导航栈中移除，可以延时0.5秒左右让pop动画完成(系统动画默认0.25s)再push，或者直接使用解决方案2
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
  if (@available(iOS 14.0, *)) {
    if (self.viewControllers.count > 1) {
      self.viewControllers[1].hidesBottomBarWhenPushed = YES;
    }
    viewController.hidesBottomBarWhenPushed = self.viewControllers.count == 1;
  }
  [super pushViewController:viewController animated:animated];
}
```
解决方案2
```objective-c
- (NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    if (@available(iOS 14, *)) {
        self.topViewController.hidesBottomBarWhenPushed = NO;
    }
    NSArray<__kindof UIViewController *> *vcs = [super popToRootViewControllerAnimated:animated];
    return vcs;
}

- (NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (@available(iOS 14, *)) {
        if (viewController == self.viewControllers.firstObject) {
            self.topViewController.hidesBottomBarWhenPushed = NO;
        } else {
            viewController.hidesBottomBarWhenPushed = YES;
        }
    }
    NSArray<__kindof UIViewController *> *vcs = [super popToViewController:viewController animated:animated];
    return vcs;
}
```
栈为[A,B,C,D]页面，系统每次显示与隐藏都是反向遍历，获取属性，push每次最后拿到的是B的hidesBottomBarWhenPushed为YES，隐藏tabbar，当popToRoot时,栈变成了[D,A]，反向遍历拿到的是D，D这个时候的hidesBottomBarWhenPushed为NO，就显示了tabbar
