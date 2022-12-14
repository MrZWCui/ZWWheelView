//
//  ZWWheelView.m
//  UIScrollView+UIPageControl
//
//  Created by 崔先生的MacBook Pro on 2022/9/22.
//

#import "ZWWheelView.h"

#define     SCROLL_WIDTH      self.frame.size.width
#define     SCROLL_HEIGHT     self.frame.size.height

@interface ZWWheelView () <UIScrollViewDelegate> {
    NSTimer *_timer;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;


@end

@implementation ZWWheelView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _imageItems = [NSArray new];
    }
    return self;
}

#pragma mark - 私有方法

//定时到3s,开始切换图片
- (void)changeImage:(NSTimer *)timer {
    CGPoint tempPoint = self.scrollView.contentOffset;
    tempPoint.x += SCROLL_WIDTH;
    if (tempPoint.x / SCROLL_WIDTH >= _imageItems.count + 2) {
        tempPoint.x = 0;
    }
    [UIView animateWithDuration:1.0 animations:^{
        self.scrollView.contentOffset = tempPoint;
        [self updateCurrentPage];
    }];
//    [self updateContentOffset];
    self.scrollView.contentOffset = [self updateContentOffset];
}

//更新当前的图片
- (CGPoint)updateContentOffset {
    CGPoint point = self.scrollView.contentOffset;
    if (self.scrollView.contentOffset.x >= SCROLL_WIDTH * _imageItems.count + 1) {
        point = CGPointMake(SCROLL_WIDTH, 0);
    } else if (self.scrollView.contentOffset.x <= 0) {
        point = CGPointMake(SCROLL_WIDTH * _imageItems.count, 0);
    }
    return point;
}

//更新当前页数
- (void)updateCurrentPage {
    NSInteger currentPage = (self.updateContentOffset.x - SCROLL_WIDTH) / SCROLL_WIDTH;
    if (currentPage < 0) {
        currentPage = 0;
    } else if (currentPage > _imageItems.count - 1) {
        currentPage = _imageItems.count - 1;
    }
    self.pageControl.currentPage = currentPage;
}

#pragma mark - UIScrollViewDelegate

//用户的手离开屏幕后执行
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    if(!decelerate){
//        if (scrollView.contentOffset.x >= SCROLL_WIDTH * 4) {
//            scrollView.contentOffset = CGPointMake(SCROLL_WIDTH, 0);
//        } else if (scrollView.contentOffset.x <= 0) {
//            scrollView.contentOffset = CGPointMake(SCROLL_WIDTH * 3, 0);
//        }
//    }
//}

// 准备开始滑动 (仅手动拖拽时调用；代码设置setContentOffset:/scrollRectToVisible:不会调用)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_timer setFireDate:[NSDate distantFuture]];//很久之后才触发,相当于暂停
}

//已经停止加速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _timer.fireDate = [NSDate dateWithTimeInterval:3.0 sinceDate:[NSDate date]];
//    [self updateContentOffset];
    self.scrollView.contentOffset = [self updateContentOffset];
    [self updateCurrentPage];
}


#pragma mark - 懒加载

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        // 实例化
        _scrollView = [[UIScrollView alloc] init];
        // 设置尺寸大小
        _scrollView.frame = CGRectMake(0, 0, SCROLL_WIDTH, SCROLL_HEIGHT);
        // 设置滚动区域
        _scrollView.contentSize = CGSizeMake(SCROLL_WIDTH * (_imageItems.count + 2), SCROLL_HEIGHT);
        // 隐藏水平滑条
        _scrollView.showsHorizontalScrollIndicator = NO;
        // 设置分页(每次滑动一页)
        _scrollView.pagingEnabled = YES;
        // 弹簧效果(边界拉出来一小段会弹回去)
        _scrollView.bounces = NO;    //关闭
        _scrollView.contentOffset = CGPointMake(SCROLL_WIDTH, 0);
        _scrollView.delegate = self;
    }
    
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.frame = CGRectMake(0, 50 + SCROLL_HEIGHT - 30, SCROLL_WIDTH, 30);
        //设置总页数
        _pageControl.numberOfPages = _imageItems.count;
        //设置背景色
        _pageControl.backgroundColor = [UIColor clearColor];
        //设置当前页颜色
        _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        //设置其他页颜色
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    }
    return _pageControl;
}

- (void)setImageItems:(NSArray *)imageItems {
    _imageItems = imageItems;
    for(int i = 0; i < _imageItems.count + 2; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(SCROLL_WIDTH * i, 0, SCROLL_WIDTH, SCROLL_HEIGHT);
        if (i == 0) {
            imageView.image = _imageItems[_imageItems.count - 1];
        } else if (i == _imageItems.count + 1){
            imageView.image = _imageItems[0];
        } else {
            imageView.image = _imageItems[i - 1];
        }
        // 将imageView添加到scrollView
        [self.scrollView addSubview:imageView];
    }
    
    // 添加scrollView到self.view
    [self addSubview:self.scrollView];
    
    //添加pageControl到self.view
    [self addSubview:self.pageControl];
    
    //启动定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(changeImage:) userInfo:nil repeats:YES];
}

@end
