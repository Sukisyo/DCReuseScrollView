//
//  DCReuseableScrollView.h
//  sd
//
//  Created by ma c on 16/3/11.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCReuseableScrollView : UIScrollView

@property (nonatomic,strong) NSArray *picArray;

/**
 *  加载本地图片
 */
- (instancetype)initWithFrame:(CGRect)frame picArray:(NSArray *)picArray;


@end
