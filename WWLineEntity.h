//
//  WWLineEntity.h
//  WWLineChartView
//
//  Created by 自由之翼 on 2018/5/11.
//  Copyright © 2018年 htgb. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface WWLineEntity : NSObject
@property (nonatomic,assign)CGFloat open;
@property (nonatomic,assign)CGFloat high;
@property (nonatomic,assign)CGFloat low;
@property (nonatomic,assign)CGFloat close;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,strong)NSString * date;
@property (nonatomic,assign)CGFloat volume;
@property (nonatomic,assign)CGFloat ma5;
@property (nonatomic,assign)CGFloat ma10;
@property (nonatomic,assign)CGFloat ma20;
@property (nonatomic,assign)CGFloat preClosePx;
@property (nonatomic,strong)NSString *rate;

@end
