//
//  ViewController.m
//  UIScrollView+UIPageControl
//
//  Created by 崔先生的MacBook Pro on 2022/9/22.
//

#import "ViewController.h"
#import "ZWWheelView.h"

#define     SCROLL_WIDTH    [UIScreen mainScreen].bounds.size.width
#define     SCROLL_HEIGHT   [UIScreen mainScreen].bounds.size.height/3
#define     img(imageName)  [UIImage imageNamed:imageName]

@interface ViewController () <UIScrollViewDelegate> {
    NSTimer *_timer;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    ZWWheelView *view = [[ZWWheelView alloc] initWithFrame:CGRectMake(0, [self getStatusBarHight], SCROLL_WIDTH, SCROLL_HEIGHT)];
    view.imageItem = [NSArray arrayWithObjects:img(@"0.jpg"), img(@"1.jpg"), img(@"2.jpg"), img(@"4.jpg"), nil];
    [self.view addSubview:view];
}

//获取状态栏高度
- (CGFloat)getStatusBarHight {
    NSSet *set = [UIApplication sharedApplication].connectedScenes;
    UIWindowScene *windowScean= [set anyObject];
    UIStatusBarManager *statusBarManager = windowScean.statusBarManager;
    return statusBarManager.statusBarFrame.size.height;
}

@end
