//
//  CCNetworkManager.m
//  AFNetworking
//
//  Created by 赵郧陕 on 2023/1/5.
//

#import "CCNetworkManager.h"
#import "AFNetworking/AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>
#import "MJExtension/MJExtension.h"
#import "CCResponseModel.h"

@interface CCNetworkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *sesstionManager;

@property (nonatomic, strong) NSCache *cache;

@end

@implementation CCNetworkManager
+(instancetype)defaultManager{
    static CCNetworkManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CCNetworkManager alloc]init];
    });
    return manager;
}


-(AFHTTPSessionManager *)sesstionManager{
    if (_sesstionManager == nil) {
        _sesstionManager = [AFHTTPSessionManager manager];
        _sesstionManager.responseSerializer = [self responseSerializer];
        _sesstionManager.requestSerializer = [self requestSerializer];
    }
    return _sesstionManager;
}

-(NSCache *)cache{
    if (_cache == nil) {
        _cache = [[NSCache alloc]init];
    }
    return _cache;
}

-(AFHTTPResponseSerializer *)responseSerializer{
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"image/png",@"image/jpg",@"image/jpeg",@"text/json", nil];
    return responseSerializer;
}

-(AFHTTPRequestSerializer *)requestSerializer{
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    return requestSerializer;
}

-(AFHTTPRequestSerializer *)imageRequestSerializer{
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    return requestSerializer;
}

-(void)updateHeader:(NSDictionary *)header{
    for (NSString *keyPath in header) {
        [self.sesstionManager.requestSerializer setValue:header[keyPath] forHTTPHeaderField:keyPath];
    }
}

-(void)removeHeaderForKeyPath:(NSString *)keyPath{
    [self.sesstionManager.requestSerializer  setValue:@"" forHTTPHeaderField:keyPath];
}

#pragma mark - GET

+(void)GET:(NSString *)path params:(NSDictionary *_Nullable)params className:(NSString *_Nullable)className successHandle:(void (^_Nullable)(id data, NSString *_Nullable msg))success failureHandle:(void (^_Nullable)(NSError *err))failure{
    [self GET:path params:params className:className showLoadingHud:NO autoCancel:NO successHandle:success failureHandle:failure];
}

+(void)GET:(NSString *)path params:(NSDictionary *_Nullable)params className:(NSString *_Nullable)className showLoadingHud:(BOOL)loadingHud successHandle:(void (^_Nullable)(id data, NSString *_Nullable msg))success failureHandle:(void (^_Nullable)(NSError *err))failure{
    [self GET:path params:params className:className showLoadingHud:loadingHud autoCancel:NO successHandle:success failureHandle:failure];
}

+(void)GET:(NSString *)path params:(NSDictionary *_Nullable)params className:(NSString *_Nullable)className showLoadingHud:(BOOL)loadingHud autoCancel:(BOOL)cancel successHandle:(void (^_Nullable)(id data, NSString *_Nullable msg))success failureHandle:(void (^_Nullable)(NSError *err))failure{
    [self GET:path params:params className:className showLoadingHud:loadingHud autoCancel:cancel progressHandle:nil successHandle:success failureHandle:failure];
}

+(void)GET:(NSString *)path params:(NSDictionary *_Nullable)params className:(NSString *_Nullable)className showLoadingHud:(BOOL)loadingHud autoCancel:(BOOL)cancel progressHandle:(void(^_Nullable)(NSProgress* p))progress successHandle:(void (^_Nullable)(id data, NSString *_Nullable msg))success failureHandle:(void (^_Nullable)(NSError *err))failure{
    [self GET:path params:params headers:nil className:className showLoadingHud:loadingHud autoCancel:cancel progressHandle:progress successHandle:success failureHandle:failure];
}

+(void)GET:(NSString *)path params:(NSDictionary *_Nullable)params headers:(NSDictionary *_Nullable)headers className:(NSString *_Nullable)className showLoadingHud:(BOOL)loadingHud autoCancel:(BOOL)cancel progressHandle:(void(^_Nullable)(NSProgress* p))progress successHandle:(void (^_Nullable)(id data, NSString *_Nullable msg))success failureHandle:(void (^_Nullable)(NSError *err))failure{
    CCNetworkManager *manager = [CCNetworkManager defaultManager];
    if (cancel) [self removeTaskWithPath:path];
    if (loadingHud && manager.configLoadingHUD) manager.configLoadingHUD();
    NSURLSessionTask *task = [manager.sesstionManager GET:path parameters:params headers:headers progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(cancel) [self removeTaskWithPath:path];
        [self dealWithResponse:responseObject className:className success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(cancel) [self removeTaskWithPath:path];
        if(failure) failure(error);
    }];
    [task resume];
    if(cancel) [self cacheTask:task withPath:path];
}

#pragma mark - POST

+(void)POST:(NSString *)path params:(NSDictionary *_Nullable)params className:(NSString *_Nullable)className successHandle:(void (^_Nullable)(id data, NSString *_Nullable msg))success failureHandle:(void (^_Nullable)(NSError *err))failure{
    [self POST:path params:params className:className showLoadingHud:NO autoCancel:NO successHandle:success failureHandle:failure];
}

+(void)POST:(NSString *)path params:(NSDictionary *_Nullable)params className:(NSString *_Nullable)className showLoadingHud:(BOOL)loadingHud successHandle:(void (^_Nullable)(id data, NSString *_Nullable msg))success failureHandle:(void (^_Nullable)(NSError *err))failure{
    [self POST:path params:params className:className showLoadingHud:loadingHud autoCancel:NO successHandle:success failureHandle:failure];
}

+(void)POST:(NSString *)path params:(NSDictionary *_Nullable)params className:(NSString *_Nullable)className showLoadingHud:(BOOL)loadingHud autoCancel:(BOOL)cancel successHandle:(void (^_Nullable)(id data, NSString *_Nullable msg))success failureHandle:(void (^_Nullable)(NSError *err))failure{
    [self POST:path params:params className:className showLoadingHud:loadingHud autoCancel:cancel progressHandle:nil successHandle:success failureHandle:failure];
}

+(void)POST:(NSString *)path params:(NSDictionary *_Nullable)params className:(NSString *_Nullable)className showLoadingHud:(BOOL)loadingHud autoCancel:(BOOL)cancel progressHandle:(void(^_Nullable)(NSProgress* p))progress successHandle:(void (^_Nullable)(id data, NSString *_Nullable msg))success failureHandle:(void (^_Nullable)(NSError *err))failure{
    [self POST:path params:params headers:nil className:className showLoadingHud:loadingHud autoCancel:cancel progressHandle:progress successHandle:success failureHandle:failure];
}

+(void)POST:(NSString *)path params:(NSDictionary *_Nullable)params headers:(NSDictionary *_Nullable)headers className:(NSString *_Nullable)className showLoadingHud:(BOOL)loadingHud autoCancel:(BOOL)cancel progressHandle:(void(^_Nullable)(NSProgress* p))progress successHandle:(void (^_Nullable)(id data, NSString *_Nullable msg))success failureHandle:(void (^_Nullable)(NSError *err))failure{
    CCNetworkManager *manager = [CCNetworkManager defaultManager];
    if (cancel) [self removeTaskWithPath:path];
    if (loadingHud && manager.configLoadingHUD) manager.configLoadingHUD();
    NSURLSessionTask *task = [manager.sesstionManager POST:path parameters:params headers:headers progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(cancel) [self removeTaskWithPath:path];
        [self dealWithResponse:responseObject className:className success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(cancel) [self removeTaskWithPath:path];
        if(failure) failure(error);
    }];
    [task resume];
    if(cancel) [self cacheTask:task withPath:path];
}

+(void)dealWithResponse:(id)data className:(NSString *_Nullable)className success:(void (^_Nullable)(id data, NSString *_Nullable msg))success failure:(void (^_Nullable)(NSError *err))failure{
    if([CCNetworkManager defaultManager].dealWithResopnse){
        [CCNetworkManager defaultManager].dealWithResopnse(data, success, failure);
        return;
    }
    id jsonObject = data;
    /// 返回结果是data 则进行解析
    if ([data isKindOfClass:[NSData class]] ){
        NSError *err;
        jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
        if(err) {
            /// 如果返回格式不是json 则直接交给客户端处理
            NSString *content = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            if(success) success(content, nil);
            return;
        }
    }
    /// 如果返回格式是数组 则表明服务器未对数据进行封装
    if ( [jsonObject isKindOfClass:[NSArray class]]){
        NSArray *results = [self dealData:jsonObject className:className];
        if (success) success(results, nil);
        return;
    }
    CCResponseModel *responseModel = [CCResponseModel mj_objectWithKeyValues:jsonObject];
    /// 数据模型不匹配
    if ( responseModel == nil){
        if (success) {
            success(jsonObject, nil);
            return;
        }
    }else{
        if ([responseModel.code isEqualToString:responseModel.value]) {
            id result = responseModel.data;
            if ([result isKindOfClass:[NSDictionary class]]){
                id model = [self dealObject:result className:className];
                if (success) success(model, responseModel.msg);
            }else{
                id model = [self dealData:result className:className];
                if (success) success(model, responseModel.msg);
            }
        }else{
            if (failure){
                failure([self errWithMsg:responseModel.msg]);
            }
        }
    }
}

+(NSError *)errWithMsg:(NSString *)msg{
    NSError *err = [[NSError alloc]initWithDomain:@"AFNetworkError" code:-1 userInfo:@{
        NSLocalizedDescriptionKey: msg
    }];
    return err;
}

+(NSArray *)dealData:(NSArray *)data className:(NSString *_Nullable)className {
    if (className == nil || !NSClassFromString(className)) {
        return data;
    }
    Class clss = NSClassFromString(className);
    NSArray *results = [clss mj_objectArrayWithKeyValuesArray:data];
    return results;
}

+(id)dealObject:(NSDictionary *)data className:(NSString *_Nullable)className{
    if (className == nil || !NSClassFromString(className)) {
        return data;
    }
    Class clss = NSClassFromString(className);
    id result = [clss mj_objectWithKeyValues:data];
    return result;
}

+(void)cacheTask:(NSURLSessionTask *)task withPath:(NSString *)path{
    CCNetworkManager *manager = [CCNetworkManager defaultManager];
    NSCache *cache = manager.cache;
    NSString *md5String = [self md5String:path];
    NSURLSessionTask *oldTask = [cache objectForKey:md5String];
    if (oldTask) {
        [oldTask cancel];
    }
    [cache setObject:task forKey:md5String];
}

+(void)removeTaskWithPath:(NSString *)path{
    CCNetworkManager *manager = [CCNetworkManager defaultManager];
    NSCache *cache = manager.cache;
    NSString *md5String = [CCNetworkManager md5String:path];
    NSURLSessionTask *task = [cache objectForKey:md5String];
    if (task) {
        [cache removeObjectForKey:md5String];
    }
}

#pragma mark - UPLOAD
+(void)UPLOAD:(NSString *)path photos:(NSArray *)photos params:(NSDictionary *_Nullable)params progress:(void(^)(NSProgress * _Nonnull uploadProgress))progress success:(void (^_Nullable)(id data, NSString *_Nullable msg))success failure:(void (^_Nullable)(NSError *err))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [[CCNetworkManager defaultManager] responseSerializer];
    manager.requestSerializer = [[CCNetworkManager defaultManager] imageRequestSerializer];

    NSMutableArray *imageUrls = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i<photos.count; i++) {
        [manager POST:path parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSData *imgData = UIImagePNGRepresentation(photos[i]);
            NSString *fileName = [NSString stringWithFormat:@"IMG%ld.png",(NSInteger)[[NSDate date] timeIntervalSince1970]];
            [formData appendPartWithFileData:imgData name:@"file" fileName:fileName mimeType:@"image/png"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
                
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [imageUrls addObject:@""];
            if (imageUrls.count == photos.count) {
                if (success) success(imageUrls, nil);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [imageUrls addObject:@""];
            if (imageUrls.count == photos.count) {
                if (success) success(imageUrls, nil);
            }
        }];
    }
}


+ (NSString *)md5String:(NSString *)str
{
    //传入参数,转化成char
    const char *cStr = [str UTF8String];
    //开辟一个16字节的空间
    unsigned char result[16];
    /*
     extern unsigned char * CC_MD5(const void *data, CC_LONG len, unsigned char *md)官方封装好的加密方法
     把str字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了md这个空间中
     */
    CC_MD5(cStr, (unsigned)strlen(cStr), result);
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
    ];
}
@end
