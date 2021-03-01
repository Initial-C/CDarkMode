//
//  UIImage+CImage.h
//  
//
//  Created by Mr.C on 15/7/6.
//  Copyright (c) 2015年 Mr.C. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>

@interface UIImage (cImage)

#pragma mark - 颜色图
// 根据颜色生成一张尺寸为1*1的相同颜色图片
+ (UIImage *)imageWithColor:(UIColor *)color;
/**
 特定尺寸纯颜色图片
 
 @param color 颜色
 @param size 尺寸
 @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
#pragma mark - 防止图片渲染
// 防止图片被渲染
+ (UIImage *)imageWithOriImage:(NSString *)imageName;

#pragma mark - 圆图
+ (UIImage *)getCircleImage:(UIImage *)sourceImage withImageVSize:(CGSize)imageV;

#pragma mark - Base64图
- (NSString *)getImage2DataURL; // 图片转base64
+ (NSString *)UIImageToBase64Str:(NSData *)data;
+ (UIImage *)Base64StrToUIImage:(NSString *)_encodedImageStr;

#pragma mark - 设图大小
// 重设图片大小
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize;
// 压缩图片大小
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;
/**
 重设图为标准大小
 @return 新图
 */
+ (UIImage *)resizeImage:(UIImage *)oriImage;


/**
 重设正方形图片

 @param oriImage 原图
 @return 矫正图
 */
+ (UIImage *)resizeSquareImage:(UIImage *)oriImage;
/**
 图片拉伸
 @param image 图片拉伸效果
 @return 返回一个延展拉伸完毕的图片
 */
+ (UIImage *)resizedImageForStretchableEffect:(UIImage *)image;

#pragma mark - 裁图
/**
 裁剪特殊形状图片
 @param image 要裁剪的图
 @param maskImage 遮板图
 @return 裁剪完成的图(以遮板图为模板合成的图)
 */
- (UIImage *)maskImage:(UIImage *)image withMask:(UIImage *)maskImage;
// 抠掉图中某个区域的颜色
- (UIImage *)maskImage:(UIImage *)image withColor:(CGFloat *)color;
#pragma mark - 截图
/**
 *  从给定UIImage和指定Frame截图：
 */
- (UIImage *)cutWithFrame:(CGRect)frame;
/**
 *  从给定UIView中截图：UIView转UIImage
 */
+ (UIImage *)cutFromView:(UIView *)view;
/*
 *  直接截屏
 */
+ (UIImage *)cutScreen;

#pragma mark - GIF
/**
 *  从NSData播放gif动画
 *
 *  @param data 源文件（图片源）
 *
 *  @return 动图
 */
+ (UIImage *)animatedGIFWithData:(NSData *)data;
/**
 *  计算动画中每一张图片的播放时间
 *
 *  @param index  图片索引
 *  @param source 图片组
 *
 *  @return  播放时间
 */
+ (float)frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source;

/**
 *  从图片名播放gif动画
 *
 *  @param name 文件名
 *
 *  @return 动图
 */
+ (UIImage *)animatedGIFNamed:(NSString *)name;


/**
 从图片名数组播放动画

 @param names 图片名数组
 @return 动图
 */
+ (UIImage *)animatedWithArrayNames: (NSArray *)names;

/**
 *  图片缩放动画
 *
 *  @param size 大小
 *
 *  @return 动图
 */
- (UIImage *)animatedImageByScalingAndCroppingToSize:(CGSize)size;

- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha;

+ (CGRect)calculateImageViewSize:(UIImage *)image;

+ (NSArray *)imagesArrayWithGif:(NSString *)gifNameInBoundle;

+ (UIImage *)getMainWebPImage:(NSString *)webpName; // webp


@end

@interface NSData (CompressImage)

/**
 压缩图片
 
 @param maxLength 预设最大尺寸 单位kb
 @return 新的图片数据
 */
- (NSData *)compressWithMaxLength:(NSUInteger)maxLength;

/** 压缩成缩略图片 */
+ (NSData *)compressForThumbnail:(NSData *)imageData;

@end
