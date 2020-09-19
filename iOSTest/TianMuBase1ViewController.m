//
//  TianMuBase1ViewController.m
//  iOSTest
//
//  Created by wsong on 2020/9/19.
//

#import "TianMuBase1ViewController.h"

@interface TianMuBase1ViewController ()

@end

@implementation TianMuBase1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popToViewController:self.navigationController.childViewControllers.firstObject
                                          animated:YES];
    NSLog(@"%@ -- %@", self.navigationController.childViewControllers, self.navigationController.viewControllers);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
