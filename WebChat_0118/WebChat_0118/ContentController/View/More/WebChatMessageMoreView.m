//
//  WebChatMessageMoreView.m
//  WebChat
//
//  Created by Jack on 2017/12/13.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import "WebChatMessageMoreView.h"
#import <Masonry.h>
#import <UIKit/UIKit.h>
#import "JackHttp.h"
#import <AFHTTPSessionManager.h>
#import "UIImage+aScaling.h"
NSString *const kNotificationImage = @"kNotificationImage";
@interface WebChatMessageMoreView()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    //AFN 上传管理者
    AFHTTPSessionManager *manager;
}
@end
@implementation WebChatMessageMoreView

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setUI];
    }
    return self;
}
#pragma 初始化UI界面
-(void)setUI{
    
    [self addSubview:self.mPhotoBtn];
    [self addSubview:self.mShotBtn];
    [self addSubview:self.mVideoBtn];
    
    NSMutableArray  *array = [NSMutableArray new];
    [array addObject:_mPhotoBtn];
    [array addObject:_mShotBtn];
    [array addObject:_mVideoBtn];
    
    [array mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:20 leadSpacing:20 tailSpacing:20];
    [array mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.height.mas_equalTo(90);
    }];
}
-(UIButton*)mPhotoBtn{
    if (!_mPhotoBtn) {
        _mPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mPhotoBtn setTitle:@"图片" forState:UIControlStateNormal];
        _mPhotoBtn.titleLabel.font=[UIFont systemFontOfSize:14.0f];
        [_mPhotoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_mPhotoBtn setTitleEdgeInsets:UIEdgeInsetsMake(30, -30, 0, 0)];
        [_mPhotoBtn setImageEdgeInsets:UIEdgeInsetsMake(-30, 30, 0, 0)];
        [_mPhotoBtn setImage:[UIImage imageNamed:@"photo"]
                    forState:UIControlStateNormal];
        [_mPhotoBtn addTarget:self action:@selector(aPhotoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mPhotoBtn;
}
-(UIButton*)mShotBtn{
    if (!_mShotBtn) {
        _mShotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mShotBtn setTitle:@"拍摄" forState:UIControlStateNormal];
        _mShotBtn.titleLabel.font=[UIFont systemFontOfSize:14.0f];
        [_mShotBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_mShotBtn setTitleEdgeInsets:UIEdgeInsetsMake(30, -30, 0, 0)];
        [_mShotBtn setImageEdgeInsets:UIEdgeInsetsMake(-30, 30, 0, 0)];
        [_mShotBtn setImage:[UIImage imageNamed:@"shot"]
                   forState:UIControlStateNormal];
        [_mShotBtn addTarget:self action:@selector(aShotBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mShotBtn;
}
-(UIButton*)mVideoBtn{
    if (!_mVideoBtn) {
        _mVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mVideoBtn setTitle:@"视频" forState:UIControlStateNormal];
        _mVideoBtn.titleLabel.font=[UIFont systemFontOfSize:14.0f];
        [_mVideoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_mVideoBtn setTitleEdgeInsets:UIEdgeInsetsMake(30, -30, 0, 0)];
        [_mVideoBtn setImageEdgeInsets:UIEdgeInsetsMake(-30, 30, 0, 0)];
        [_mVideoBtn setImage:[UIImage imageNamed:@"video"]
                    forState:UIControlStateNormal];
        [_mVideoBtn addTarget:self action:@selector(aVideoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mVideoBtn;
}
#pragma 照片Method
-(void)aPhotoBtnClick{
    UIImagePickerController *imageVC = [[UIImagePickerController alloc] init];
    imageVC.delegate   = self;
    imageVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [[self viewController].navigationController presentViewController:imageVC animated:YES completion:nil];
}
#pragma 拍照Method
-(void)aShotBtnClick{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: sourceType])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate   = self;
        picker.sourceType = sourceType;
        [[self viewController].navigationController presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"模拟器没有摄像头!!!");
    }
}
#pragma 视频Method
-(void)aVideoBtnClick{
    
}
#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //允许照片可编辑
    picker.allowsEditing = YES;
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //取出图片
        UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //按比例缩放图片,优化显示效果
        image = [image scaleWithHeight:200];
        WebChatModel *model = [[WebChatModel alloc]init];
        model.isSender      = YES;
        model.aImage        = image;
        model.chatCellType  = WebChatCellType_Image;
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationImage object:self userInfo:@{@"aImage":model}];
        
        //开启上传
        NSString *kFilePath  = info[@"UIImagePickerControllerImageURL"];
        [self uploadPhotoWith:image andImagePath:kFilePath];
        
        //关闭相册界面
        [[self viewController].navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)uploadPhotoWith:(UIImage*)img andImagePath:(NSString *)path{
    
    NSString   *typeString;
    NSString   *fileName;
    path = [NSString stringWithFormat:@"%@",path];
    path = [path substringFromIndex:7];
    
    if ([path containsString:@"jpeg"]) {
        typeString = @"image/jpeg";
        fileName   = @".jpeg";
    }else if ([path containsString:@"png"]){
        typeString = @"image/png";
        fileName   = @".png";
    }
    manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"application/json",
                                                         @"text/json",
                                                         @"text/html",
                                                         @"image/png",
                                                         @"image/jpeg",
                                                         @"application/octet-stream",
                                                         nil];
    
    manager.requestSerializer= [AFHTTPRequestSerializer serializer];
    manager.responseSerializer= [AFJSONResponseSerializer serializer];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",IP_URL,UpLoad_URL] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *data = [self imageData:img];
        
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:data
                                    name:@"file"
                                fileName:fileName
                                mimeType:typeString];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传成功===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败===%@",error);
    }];
    
}
#pragma 放弃选择
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[self viewController].navigationController dismissViewControllerAnimated:YES completion:nil];
}
#pragma 获取当前view的Controller
- (UIViewController *)viewController {
    for (UIView *next = [self superview];next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
#pragma 压缩图片大小
-(NSData *)imageData:(UIImage *)aimage{
    NSData *imageData = UIImageJPEGRepresentation(aimage, 1.0);
    if (imageData.length > 1024*1024) {
        //1M以及以上
        imageData = UIImageJPEGRepresentation(aimage, 0.2);
    }else if (imageData.length > 512*1024) {
        //0.5M-1M
        imageData = UIImageJPEGRepresentation(aimage, 0.5);
    }else if (imageData.length > 200*1024) {
        //0.25M-0.5M
        imageData = UIImageJPEGRepresentation(aimage, 0.8);
    }
    return imageData;
}
@end
