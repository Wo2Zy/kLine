//
//  FYStockIndex.h
//  newOne
//
//  Created by fyzswh on 2018/5/19.
//  Copyright © 2018年 fyzswh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WWLineEntity.h"
#import "FYMacdModel.h"
@interface FYStockIndex : NSObject
+(instancetype)sharedStockIndex;
-(NSMutableArray<FYMacdModel *>*)MACDData:(NSMutableArray<WWLineEntity *>*)dataArray;
-(NSMutableArray<FYKDJModel *> *)KDJData:(NSMutableArray<WWLineEntity *>*)dataArray;
-(NSMutableArray<FYRSIModel *> *)RSIData:(NSMutableArray<WWLineEntity *>*)dataArray;
@end
