//
//  DCReuseableScrollView.m
//  sd
//
//  Created by ma c on 16/3/11.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import "DCReuseableScrollView.h"

typedef NS_OPTIONS(NSInteger, DCReuseScrollViewDirection) {
    DCReuseScrollViewDirectionLast,       // 显示上一张图片
    DCReuseScrollViewDirectionNow,       // 显示当前图片
    DCReuseScrollViewDirectionNext      // 显示下一张图片
};

@interface DCReuseableScrollView ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIImageView *lastImage;
@property (nonatomic,strong) UIImageView *showImage;
@property (nonatomic,strong) UIImageView *nextImage;
@property (nonatomic,assign) NSInteger picNumber;
@property (nonatomic,assign) DCReuseScrollViewDirection direction;

@property (nonatomic,strong) NSTimer *timer;


@end

@implementation DCReuseableScrollView


- (instancetype)initWithFrame:(CGRect)frame picArray:(NSArray *)picArray {
    if (self = [super initWithFrame:frame]) {
        
        _picArray = picArray;
        _picNumber = 0;
        
        [self setBackgroundColor:[UIColor grayColor]];
        
        self.delegate = self;
        self.contentOffset = CGPointMake(frame.size.width, 0);
        self.contentSize = CGSizeMake(frame.size.width * 3, frame.size.height);
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        
        _lastImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_lastImage setImage:[picArray lastObject]];
        [self addSubview:_lastImage];
        
        _showImage = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width, 0, frame.size.width, frame.size.height)];
        [_showImage setImage:[picArray firstObject]];
        [self addSubview:_showImage];
        
        _nextImage = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width * 2, 0, frame.size.width, frame.size.height)];
        [_nextImage setImage:picArray[1]];
        [self addSubview:_nextImage];
        
        //添加定时器让轮播器自动滚动
//        [self addTimer];

        
        
    }
   return self;
}
//刷新图片数据的逻辑
- (void)reloadPicsWithDirection:(DCReuseScrollViewDirection)direction {
    
    [_showImage setImage:self.picArray[self.picNumber]];
    if (self.picNumber == 0) {
        [_lastImage setImage:[self.picArray lastObject]];
        [_nextImage setImage:self.picArray[self.picNumber + 1]];
    }else if (self.picNumber == self.picArray.count - 1){
        [_lastImage setImage:self.picArray[self.picNumber - 1]];
        [_nextImage setImage:[self.picArray firstObject]];
    }else {
        [_lastImage setImage:self.picArray[self.picNumber - 1]];
        [_nextImage setImage:self.picArray[self.picNumber + 1]];
    }
    
    //将偏移量转回原位
    self.contentOffset = CGPointMake(self.frame.size.width, 0);
    
    
    
}
//添加定时器
- (void)addTimer{
    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(nextPageAction) userInfo:nil repeats:YES];
    self.timer = timer;
    //消息循环
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    [runloop addTimer:timer forMode:NSRunLoopCommonModes];
}
//下一张图片的逻辑
- (void)nextPageAction {
    [UIView animateWithDuration:1 animations:^{
        [self setContentOffset:CGPointMake(self.frame.size.width * 2, 0)];
    } completion:^(BOOL finished) {
        [self scrollViewDidEndDecelerating:self];
    }];

}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //判断是显示上一张还是显示下一张
    /**
     *  direction为0的时候显示上一张
     *  direction为1的时候不变
     *  direction为2的时候显示下一张
     */
    DCReuseScrollViewDirection direction = (DCReuseScrollViewDirection)scrollView.contentOffset.x / self.frame.size.width ;
    //同时记录要显示图片的索引
    self.picNumber += direction - 1;
    //如果往左越界则返回最后一张图片的索引
    if (self.picNumber < 0) {
        self.picNumber = self.picArray.count - 1;
    //如果往右越界则返回第一张图片的索引
    }else if (self.picNumber == self.picArray.count){
        self.picNumber = 0;
    }
    //若方向为往左或往右时刷新图片数据
    if (direction != DCReuseScrollViewDirectionNow) {
        [self reloadPicsWithDirection:direction];
    }

}
//当对scrollView进行拖动的时候终止计时器的计时操作
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    [self.timer invalidate];
//}
//当对scrollView的拖动停止时，重新开始对计时器的计时操作
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    [self addTimer];
//}

@end
