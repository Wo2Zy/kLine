//
//  FYMacdModel.h
//  newOne
//
//  Created by fyzswh on 2018/5/19.
//  Copyright © 2018年 fyzswh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FYMacdModel : NSObject
@property(nonatomic,assign)double macd;
@property(nonatomic,assign)double ema12;
@property(nonatomic,assign)double ema26;
@property(nonatomic,assign)double dea;
@property(nonatomic,assign)double diff;
@end
@interface FYKDJModel : NSObject
@property(nonatomic,assign)double k;
@property(nonatomic,assign)double d;
@property(nonatomic,assign)double j;
@end
@interface FYRSIModel : NSObject
@property(nonatomic,assign)double rsi1;
@property(nonatomic,assign)double rsi2;
@property(nonatomic,assign)double rsi3;
@end
