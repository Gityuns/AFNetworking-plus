//
//  CCResponseModel.h
//  AFNetworking-plus
//
//  Created by 赵郧陕 on 2023/2/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCResponseModel : NSObject
/// 结果判断字段
@property (nonatomic, copy) NSString *code;
/// 成功判断值
@property (nonatomic, copy) NSString *value;
/// 结果字段
@property (nonatomic, strong) id data;
/// 错误信息字段
@property (nonatomic, copy) NSString *msg;
@end

NS_ASSUME_NONNULL_END
