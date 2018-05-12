//
//  LVInfiniteScrollView.m
//  LVInfiniteScrollView
//
//  Created by 孔友夫 on 2018/5/11.
//  Copyright © 2018年 LV. All rights reserved.
//

#import "LVInfiniteScrollView.h"

@interface LVInfiniteScrollView()
<UIScrollViewDelegate>
    {
        NSUInteger currentIndex;
    }
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIPageControl *pageControl;
@property (nonatomic,strong)NSTimer *timer;


@end

static NSUInteger const LVImageViewCount = 3;
@implementation LVInfiniteScrollView

- (instancetype)initWithFrame:(CGRect)frame
    {
        if(self == [super initWithFrame:frame]){

            self.scrollView = ({
                UIScrollView *scrollView = [[UIScrollView alloc]init];
                scrollView.backgroundColor = [UIColor redColor];
                scrollView.showsVerticalScrollIndicator = NO;
                scrollView.showsHorizontalScrollIndicator = NO;
                scrollView.pagingEnabled = YES;
                scrollView.delegate = self;
                scrollView;
            });

            [self addSubview:self.scrollView];
            self.scrollView.bounces = NO;
            for(NSUInteger i = 0 ;i <LVImageViewCount ; i ++){
                UIImageView *imageView = [UIImageView new];
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                [_scrollView  addSubview:imageView];
            }


            self.pageControl = ({
                UIPageControl *pageControll = [[UIPageControl alloc]init];
                pageControll.backgroundColor = [UIColor blueColor];


                pageControll;

            });
            [self addSubview:self.pageControl];

            [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnView:)]];

            _animationDuration = 0.5;
            currentIndex= 0;
            [self startTimer];
        }

        return self;

}

    -(void)layoutSubviews{
        [super layoutSubviews];
        self.scrollView.frame = self.bounds;
        CGFloat pageControlW = 100;
        CGFloat pageControlH = 30;
        CGFloat pageControlX= self.bounds.size.width - pageControlW;
        CGFloat pageControlY = self.bounds.size.height - pageControlH;
        self.pageControl.frame = CGRectMake(pageControlX, pageControlY, pageControlW, pageControlH);


        CGFloat imageW = self.scrollView.frame.size.width;
        CGFloat imageH = self.scrollView.frame.size.height;
        for(NSUInteger i = 0; i<LVImageViewCount ;i++){
            UIImageView *imageView = self.scrollView.subviews[i];
            CGFloat imageX =i *imageW;
            CGFloat imageY = 0;
            imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
            imageView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];

        }
        self.scrollView.contentSize = CGSizeMake(LVImageViewCount*imageW, 0);


        [self updateContent];
    }


#pragma mark - 属性setter
- (void)setImageNames:(NSArray *)imageNames
    {
        _imageNames = imageNames;

        // 设置总页码
        self.pageControl.numberOfPages = imageNames.count;
    }


//    核心代码开头
#pragma mark - 其他方法

- (void)updateContent
    {
        // 1.从左到右重新设置每一个UIImageView的图片
        for (NSUInteger i = 0; i < LVImageViewCount; i++) {
            UIImageView *imageView = self.scrollView.subviews[i];

            // 求出i位置imageView对应的图片索引
            NSInteger imageIndex = 0; // 这里的imageIndex不能用NSUInteger
            if (i == 0) { // 当前页码 - 1
                imageIndex = self.pageControl.currentPage - 1;
                imageView.transform = CGAffineTransformMakeScale(0.8, 0.8);

            } else if (i == 2) { // 当前页码 + 1
                imageIndex = self.pageControl.currentPage + 1;
                imageView.transform = CGAffineTransformMakeScale(0.8, 0.8);

            } else { // // 当前页码
                imageIndex = self.pageControl.currentPage;
                [UIView animateWithDuration:0.5 animations:^{
                    imageView.transform = CGAffineTransformMakeScale(1, 1);

                }];
            }

            // 判断越界
            if (imageIndex == -1) { // 最后一张图片
                imageIndex = self.imageNames.count - 1;
            } else if (imageIndex == self.imageNames.count) { // 最前面那张
                imageIndex = 0;
            }

            imageView.image = [UIImage imageNamed:self.imageNames[imageIndex]];

            // 绑定图片索引到UIImageView的tag
            imageView.tag = imageIndex;
//            currentIndex = imageIndex;

        }

        // 2.重置UIScrollView的contentOffset.width == 1倍宽度
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    }
//    核心代码结束


#pragma mark -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
    {
        // imageView的x 和 scrollView偏移量x 的最小差值
        CGFloat minDelta = MAXFLOAT;

        // 找出显示在最中间的图片索引
        NSInteger centerImageIndex = 0;

        for (NSUInteger i = 0; i < LVImageViewCount; i++) {
            UIImageView *imageView = self.scrollView.subviews[i];

            // ABS : 取得绝对值
            CGFloat delta = ABS(imageView.frame.origin.x - self.scrollView.contentOffset.x);
            if (delta < minDelta) {
                minDelta = delta;
                centerImageIndex = imageView.tag;
            }
        }

        // 设置页码
        self.pageControl.currentPage = centerImageIndex;
        currentIndex = centerImageIndex;
    }


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
    {
        [self updateContent];
    }


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
    {
        [self stopTimer];
    }


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
    {
        [self startTimer];
    }

#pragma mark - 定时器处理
    // 开启定时器
- (void)startTimer
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }

    // 停止定时器
- (void)stopTimer
    {
        [self.timer invalidate];
        self.timer = nil;
    }

    // 显示下一页
- (void)nextPage
    {
        [UIView animateWithDuration:_animationDuration animations:^{
            self.scrollView.contentOffset = CGPointMake(2 * self.scrollView.frame.size.width, 0);
        } completion:^(BOOL finished) {
            [self  updateContent];
        }];
    }

    -(void)tapOnView:(UITapGestureRecognizer*)tap{

        if(self.delegate   &&[self.delegate respondsToSelector:@selector(LVInfinite:DidSelected:)]){

            [self.delegate LVInfinite:self DidSelected:currentIndex];
        }

    }
@end
