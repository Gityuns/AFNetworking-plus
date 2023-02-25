//
//  CCNetworkManager.h
//  AFNetworking
//
//  Created by 赵郧陕 on 2023/1/5.
//

#import <Foundation/Foundation.h>

typedef  void (^CCSuccessHandle)(id _Nonnull data, NSString *_Nullable msg);

typedef void (^CCFailureHandle)(NSError * _Nonnull err);


NS_ASSUME_NONNULL_BEGIN

@interface CCNetworkManager : NSObject

/// 自定义处理返回逻辑
@property (nonatomic, copy) void (^dealWithResopnse)(id resopnse, CCSuccessHandle success,CCFailureHandle failure);
/// 自定义处理请求动画
@property (nonatomic, copy) void (^configLoadingHUD)(void);


+(instancetype)defaultManager;

-(void)updateHeader:(NSDictionary *)header;

-(void)removeHeaderForKeyPath:(NSString *)keyPath;

#pragma mark - GET
+(void)        GET:(NSString *)path
            params:(NSDictionary *_Nullable)params
         className:(NSString * _Nullable)className
     successHandle:(void (^_Nullable)(id data, NSString *_Nullable msg))success
     failureHandle:(void (^_Nullable)(NSError *err))failure;

+(void)        GET:(NSString *)path
            params:(NSDictionary *_Nullable)params
         className:(NSString * _Nullable)className
    showLoadingHud:(BOOL)loadingHud
     successHandle:(void (^_Nullable)(id data, NSString *_Nullable msg))success
     failureHandle:(void (^_Nullable)(NSError *err))failure;

+(void)        GET:(NSString *)path
            params:(NSDictionary *_Nullable)params
         className:(NSString * _Nullable)className
    showLoadingHud:(BOOL)loadingHud
        autoCancel:(BOOL)cancel
     successHandle:(void (^_Nullable)(id data, NSString *_Nullable msg))success
    failureHandle:(void (^_Nullable)(NSError *err))failure;

+(void)        GET:(NSString *)path
            params:(NSDictionary *_Nullable)params
         className:(NSString * _Nullable)className
    showLoadingHud:(BOOL)loadingHud
        autoCancel:(BOOL)cancel
    progressHandle:(void(^_Nullable)(NSProgress *p))progress
     successHandle:(void (^_Nullable)(id data, NSString *_Nullable msg))success
     failureHandle:(void (^_Nullable)(NSError *err))failure;

+(void)        GET:(NSString *)path
            params:(NSDictionary *_Nullable)params
           headers:(NSDictionary *_Nullable)headers
         className:(NSString * _Nullable)className
    showLoadingHud:(BOOL)loadingHud
        autoCancel:(BOOL)cancel
    progressHandle:(void(^_Nullable)(NSProgress *p))progress
     successHandle:(void (^_Nullable)(id data, NSString *_Nullable msg))success
     failureHandle:(void (^_Nullable)(NSError *err))failure;

#pragma mark - POST

+(void)       POST:(NSString *)path
            params:(NSDictionary *_Nullable)params
         className:(NSString * _Nullable)className
     successHandle:(void (^_Nullable)(id data, NSString *_Nullable msg))success
     failureHandle:(void (^_Nullable)(NSError *err))failure;

+(void)       POST:(NSString *)path
            params:(NSDictionary *_Nullable)params
         className:(NSString * _Nullable)className
    showLoadingHud:(BOOL)loadingHud
     successHandle:(void (^_Nullable)(id data, NSString *_Nullable msg))success
    failureHandle:(void (^_Nullable)(NSError *err))failure;

+(void)       POST:(NSString *)path
            params:(NSDictionary *_Nullable)params
         className:(NSString * _Nullable)className
    showLoadingHud:(BOOL)loadingHud
        autoCancel:(BOOL)cancel
     successHandle:(void (^_Nullable)(id data, NSString *_Nullable msg))success
    failureHandle:(void (^_Nullable)(NSError *err))failure;

+(void)       POST:(NSString *)path
            params:(NSDictionary *_Nullable)params
         className:(NSString * _Nullable)className
    showLoadingHud:(BOOL)loadingHud
        autoCancel:(BOOL)cancel
    progressHandle:(void(^_Nullable)(NSProgress *p))progress
     successHandle:(void (^_Nullable)(id data, NSString *_Nullable msg))success
     failureHandle:(void (^_Nullable)(NSError *err))failure;

+(void)       POST:(NSString *)path
            params:(NSDictionary *_Nullable)params
           headers:(NSDictionary *_Nullable)headers
         className:(NSString * _Nullable)className
    showLoadingHud:(BOOL)loadingHud
        autoCancel:(BOOL)cancel
    progressHandle:(void(^_Nullable)(NSProgress *p))progress
     successHandle:(void (^_Nullable)(id data, NSString *_Nullable msg))success
     failureHandle:(void (^_Nullable)(NSError *err))failure;

#pragma mark - UPLOAD
+(void)     UPLOAD:(NSString *)path
            photos:(NSArray *)photos
            params:(NSDictionary *_Nullable)params
          progress:(void(^)(NSProgress * _Nonnull p))progress
           success:(void (^_Nullable)(id data, NSString *_Nullable msg))success
           failure:(void (^_Nullable)(NSError *err))failure;
@end

NS_ASSUME_NONNULL_END
