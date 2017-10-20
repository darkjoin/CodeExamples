//
//  ViewController.m
//  CycleScrollView
//
//  Created by darkgm on 19/10/2017.
//  Copyright © 2017 darkgm. All rights reserved.
//

#import "ViewController.h"

#define MIDDLE_IMAGE_INDEX (self.currentPage + self.imagesArray.count) % self.imagesArray.count
#define LEFT_IMAGE_INDEX (self.currentPage + self.imagesArray.count - 1) % self.imagesArray.count
#define RIGHT_IMAGE_INDEX (self.currentPage + self.imagesArray.count + 1) % self.imagesArray.count

#define SCROLLVIEW_WIDTH CGRectGetWidth(self.scrollView.bounds)
#define SCROLLVIEW_HEIGHT CGRectGetHeight(self.scrollView.bounds)


@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *middleImageView;
@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation ViewController

#pragma mark - Accessor Methods
- (NSArray *)imagesArray
{
    if (!_imagesArray) {
        NSMutableArray *images = [[NSMutableArray alloc] init];
        for (int i = 0; i < 5; ++i) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%i", i]];
            [images addObject:image];
        }
        
        _imagesArray = [NSArray arrayWithArray:images];
    }
    
    return _imagesArray;
}

- (NSInteger)currentPage
{
    if (!_currentPage) {
        _currentPage = 0;
    }
    
    return _currentPage;
}

#pragma mark - ViewControl Lifecycle Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addScrollView];
    [self addImageViews];
    [self addPageControl];
    [self addTimer];
    
}

#pragma mark - Setup
- (void)addScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.scrollView.contentSize = CGSizeMake(SCROLLVIEW_WIDTH * 3, 0);
    self.scrollView.contentOffset = CGPointMake(SCROLLVIEW_WIDTH, 0);  // display middle imageView
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    
    [self.view addSubview:self.scrollView];
}

- (void)addImageViews
{
    // add left imageView
    self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];
    self.leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:self.leftImageView];
    
    // add middle imageView
    self.middleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCROLLVIEW_WIDTH, 0, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];
    self.middleImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:self.middleImageView];
    
    // add right imageView
    self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCROLLVIEW_WIDTH * 2, 0, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];
    self.rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:self.rightImageView];
    
    // add images
    [self addImages];
}

- (void)addImages
{
    self.leftImageView.image = [self.imagesArray objectAtIndex:LEFT_IMAGE_INDEX];
    self.middleImageView.image = [self.imagesArray objectAtIndex:MIDDLE_IMAGE_INDEX];
    self.rightImageView.image = [self.imagesArray objectAtIndex:RIGHT_IMAGE_INDEX];
}

- (void)addPageControl
{
    self.pageControl = [[UIPageControl alloc] init];
    CGSize pageControlSize = [self.pageControl sizeForNumberOfPages:self.imagesArray.count];
    self.pageControl.bounds = CGRectMake(0, 0, pageControlSize.width, pageControlSize.height);
    self.pageControl.center = CGPointMake(SCROLLVIEW_WIDTH * 0.5, SCROLLVIEW_HEIGHT * 0.8);
    
    self.pageControl.numberOfPages = self.imagesArray.count;
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    
    [self.view addSubview:self.pageControl];
}

- (void)addTimer
{
    self.timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(changeImages) userInfo:nil repeats:YES];
    
    NSRunLoop *runLoop = [NSRunLoop mainRunLoop];
    [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
}

#pragma mark - Selector Method

- (void)changeImages
{
//    self.currentPage = (self.currentPage + 1 + self.imagesArray.count) % self.imagesArray.count;
    self.currentPage = RIGHT_IMAGE_INDEX;
    
    self.pageControl.currentPage = self.currentPage;
    
    [self addImages];
    
    // animation
    [self.scrollView setContentOffset:CGPointMake(SCROLLVIEW_WIDTH * 2, 0) animated:YES];
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y);
}

#pragma mark - ScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.scrollView.contentOffset.x == SCROLLVIEW_WIDTH * 2) {
        self.currentPage = RIGHT_IMAGE_INDEX;
    }
    else if (self.scrollView.contentOffset.x == 0) {
        self.currentPage = LEFT_IMAGE_INDEX;
    }
    
    self.pageControl.currentPage = self.currentPage;
    
    [self addImages];
    
    // display middle imageView
    self.scrollView.contentOffset = CGPointMake(SCROLLVIEW_WIDTH, 0);
}


@end
