//
//  CCNetworkManager.h
//  AFNetworking
//
//  Created by 赵郧陕 on 2023/1/5.
//

#import <Foundation/Foundation.h>

typedef void (^CCSuccessHandle)(id _Nullable data);

typedef void (^CCFailureHandle)(NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface CCNetworkManager : NSObject


+(instancetype)defaultManager;

-(void)updateHeader:(NSDictionary *)header;

-(void)removeHeaderForKeyPath:(NSString *)keyPath;

+(void)GET:(NSString *)urlString params:(NSDictionary *_Nullable)params cancelLast:(BOOL)cancel success:(CCSuccessHandle _Nullable)success failure:(CCFailureHandle _Nullable)failure;

+(void)POST:(NSString *)urlString params:(NSDictionary *_Nullable)params cancelLast:(BOOL)cancel  success:(CCSuccessHandle _Nullable)success failure:(CCFailureHandle _Nullable)failure;

+(void)POST:(NSString *)urlString photos:(NSArray *)photos params:(NSDictionary *_Nullable)params progress:(void(^)(NSProgress * _Nonnull uploadProgress))progress success:(CCSuccessHandle _Nullable)success failure:(CCFailureHandle _Nullable)failure;
@end

NS_ASSUME_NONNULL_END
