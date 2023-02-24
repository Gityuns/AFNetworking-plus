//
//  CCNetworkManager.m
//  AFNetworking
//
//  Created by 赵郧陕 on 2023/1/5.
//

#import "CCNetworkManager.h"
#import "AFNetworking/AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>

@interface CCNetworkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *sesstionManager;

@property (nonatomic, strong) NSMutableDictionary *caches;

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

-(NSMutableDictionary *)caches{
    if (_caches == nil) {
        _caches = [[NSMutableDictionary alloc]init];
    }
    return _caches;
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

+(void)GET:(NSString *)urlString params:(NSDictionary *_Nullable)params cancelLast:(BOOL)cancel  success:(CCSuccessHandle _Nullable)success failure:(CCFailureHandle _Nullable)failure{
    AFHTTPSessionManager *manager = [CCNetworkManager defaultManager].sesstionManager;
    NSURLSessionDataTask *task = [manager GET:urlString parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self removeRecordWithURL:urlString];
        [self dealWithResponse:responseObject success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self removeRecordWithURL:urlString];
        if (failure) {
            failure(error);
        }
    }];
    [task resume];
    if (cancel) {
        [self recordRequest:urlString task:task];
    }
}

+(void)POST:(NSString *)urlString params:(NSDictionary *_Nullable)params cancelLast:(BOOL)cancel  success:(CCSuccessHandle _Nullable)success failure:(CCFailureHandle _Nullable)failure{
    AFHTTPSessionManager *manager = [CCNetworkManager defaultManager].sesstionManager;
    NSURLSessionDataTask *task = [manager POST:urlString parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self removeRecordWithURL:urlString];
        [self dealWithResponse:responseObject success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self removeRecordWithURL:urlString];
        if (failure) {
            failure(error);
        }
        
    }];
    [task resume];
    if (cancel) {
        [self recordRequest:urlString task:task];
    }
}

+(void)POST:(NSString *)urlString photos:(NSArray *)photos params:(NSDictionary *_Nullable)params progress:(void(^)(NSProgress * _Nonnull uploadProgress))progress success:(CCSuccessHandle _Nullable)success failure:(CCFailureHandle _Nullable)failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [[CCNetworkManager defaultManager] responseSerializer];
    manager.requestSerializer = [[CCNetworkManager defaultManager] imageRequestSerializer];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSMutableArray *imageUrls = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i<photos.count; i++) {
        NSData *imgData = UIImagePNGRepresentation(photos[i]);
        NSString *fileName = [NSString stringWithFormat:@"IMG%ld.png",(NSInteger)[[NSDate date] timeIntervalSince1970]];
        [manager POST:urlString parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:imgData name:@"file" fileName:fileName mimeType:@"image/png"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
                
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [imageUrls addObject:@""];
            if (imageUrls.count == photos.count) {
                if (success) success(imageUrls);
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [imageUrls addObject:@""];
            if (imageUrls.count == photos.count) {
                if (success) success(imageUrls);
            }
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
}


+(void)dealWithResponse:(id)data success:(CCSuccessHandle _Nullable)success failure:(CCFailureHandle _Nullable)failure{
    
}


+(void)recordRequest:(NSString *)urlString task:(NSURLSessionTask *)task{
    CCNetworkManager *manager = [CCNetworkManager defaultManager];
    NSMutableDictionary *caches = manager.caches;
    NSString *md5String = [self md5String:urlString];
    NSURLSessionTask *oldTask = [caches objectForKey:md5String];
    if (oldTask) {
        [oldTask cancel];
    }
    [caches setObject:task forKey:md5String];
}

+(void)removeRecordWithURL:(NSString *)urlString{
    CCNetworkManager *manager = [CCNetworkManager defaultManager];
    NSMutableDictionary *caches = manager.caches;
    NSString *md5String = [CCNetworkManager md5String:urlString];
    NSURLSessionTask *task = [caches objectForKey:md5String];
    if (task) {
        [caches removeObjectForKey:md5String];
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
