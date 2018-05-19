//
//  FYStockIndex.m
//  newOne
//
//  Created by fyzswh on 2018/5/19.
//  Copyright © 2018年 fyzswh. All rights reserved.
//

#import "FYStockIndex.h"
@implementation FYStockIndex
+(instancetype)sharedStockIndex{
    static FYStockIndex *once;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        once = [[FYStockIndex alloc]init];
    });
    return once;
}
-(NSMutableArray<FYMacdModel *>*)MACDData:(NSMutableArray<WWLineEntity *>*)dataArray{
    NSMutableArray<FYMacdModel *>* data = [NSMutableArray new];
    [dataArray enumerateObjectsUsingBlock:^(WWLineEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FYMacdModel *model = [FYMacdModel new];
        if (idx == 0) {
            if (model.ema12 <= 0) {
                model.ema12 = 0;
            }
            if (model.ema26<= 0) {
                model.ema26 = 0;
            }
            model.macd = 0;
            model.dea = 0;
            model.diff = 0;
        }else if(idx == 1){
            WWLineEntity *mo = dataArray[idx - 1];
            model.ema12 = mo.close *11/13 + obj.close*2/13;
            model.ema26 = mo.close *25/27 + obj.close*2/27;
            model.diff = model.ema12 - model.ema26;
            model.dea = model.diff *2 /10;
            model.macd = (model.diff - model.dea)*2;
        }else{
            FYMacdModel *mod = data[idx - 1];
            model.ema12 = mod.ema12 *11/13 + obj.close*2/13;
            model.ema26 = mod.ema26 *25/27 + obj.close *2/27;
            model.diff = model.ema12 - model.ema26;
            model.dea = mod.dea * 8 /10 + model.diff *2 / 10;
            model.macd = (model.diff - model.dea) *2;
        }
        [data addObject:model];
    }];
    return data;
}
-(NSMutableArray<FYKDJModel *> *)KDJData:(NSMutableArray<WWLineEntity *>*)dataArray{
    NSMutableArray<FYKDJModel *> *data = [NSMutableArray new];
    [dataArray enumerateObjectsUsingBlock:^(WWLineEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FYKDJModel *model = [FYKDJModel new];
        if (idx == 0) {
            model.k = 50;
            model.d = 50;
            model.j = model.k * 3 - model.d * 2;
        }else if (idx < 9){
            __block double minForNine = 0;
            __block double maxForNine = 0;
            FYKDJModel *mode = data[idx - 1];
            NSArray<WWLineEntity*>*beforeArray = [dataArray subarrayWithRange:NSMakeRange(0, idx - 1)];
            [beforeArray enumerateObjectsUsingBlock:^(WWLineEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                minForNine = minForNine < obj.low ? minForNine : obj.low;
                maxForNine = maxForNine > obj.high ? maxForNine : obj.high;
            }];
            double rsv = (obj.close - minForNine) / (maxForNine - minForNine) * 100;
            model.k = (rsv + 2 * mode.k) / 3;
            model.d = (model.k + 2 * mode.d) /3;
            model.j = 3*model.k - 2*model.d;
        }else{
            __block double minForNine = 0;
            __block double maxForNine = 0;
            FYKDJModel *mode = data[idx - 1];
            NSArray<WWLineEntity*>*beforeArray = [dataArray subarrayWithRange:NSMakeRange(idx - 9, 9)];
            [beforeArray enumerateObjectsUsingBlock:^(WWLineEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                minForNine = minForNine < obj.low ? minForNine : obj.low;
                maxForNine = maxForNine > obj.high ? maxForNine : obj.high;
            }];
            double rsv = (obj.close - minForNine) / (maxForNine - minForNine) * 100;
            model.k = (rsv + 2 * mode.k) / 3;
            model.d = (model.k + 2 * mode.d) /3;
            model.j = 3*model.k - 2*model.d;
        }
        [data addObject:model];
    }];
    return data;
}
-(NSMutableArray<FYRSIModel *> *)RSIData:(NSMutableArray<WWLineEntity *>*)dataArray{
    NSMutableArray<FYRSIModel *>*data = [NSMutableArray new];
    [dataArray enumerateObjectsUsingBlock:^(WWLineEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FYRSIModel *model = [FYRSIModel new];
        if (idx < 6) {
            model.rsi1 = 0;
            model.rsi2 = 0;
            model.rsi3 = 0;
        }else if (idx < 12){
            model.rsi1 = 100 - 100/(1+[self getRS:[dataArray subarrayWithRange:NSMakeRange(idx - 6, 6)]]);
            model.rsi2 = 0;
            model.rsi3 = 0;
        }else if (idx < 24){
            model.rsi3 = 0;
            model.rsi1 = 100 - 100/(1+[self getRS:[dataArray subarrayWithRange:NSMakeRange(idx - 6, 6)]]);
            model.rsi2 = 100 - 100/(1+[self getRS:[dataArray subarrayWithRange:NSMakeRange(idx - 12, 12)]]);
        }else{
         model.rsi1 = 100 - 100/(1+[self getRS:[dataArray subarrayWithRange:NSMakeRange(idx - 6, 6)]]);
         model.rsi2 = 100 - 100/(1+[self getRS:[dataArray subarrayWithRange:NSMakeRange(idx - 12, 12)]]);
         model.rsi3 = 100 - 100/(1+[self getRS:[dataArray subarrayWithRange:NSMakeRange(idx - 24, 24)]]);
        }
        [data addObject:model];
    }];
    return data;
}
-(double)getRS:(NSArray<WWLineEntity *>*)datArray{
    __block double rsUp = 0;
    __block double rsDown = 0;
    [datArray enumerateObjectsUsingBlock:^(WWLineEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.close - obj.open > 0) {
            rsUp += (obj.close - obj.open);
        }else{
            rsDown += (obj.close - obj.open);
        }
    }];
    return rsUp/rsDown;
}
@end
