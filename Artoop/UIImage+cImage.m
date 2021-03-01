//
//  UIImage+CImage.m
//  
//
//  Created by Mr.C on 15/7/6.
//  Copyright (c) 2015年 Mr.C. All rights reserved.
//

#import "UIImage+cImage.h"
#import "YYImage/YYImage.h"

#define ZWScreenW [UIScreen mainScreen].bounds.size.width
#define ZWScreenH [UIScreen mainScreen].bounds.size.height
#define getMainWebPImagePath(file) [[NSBundle mainBundle] pathForResource:file ofType:@"webp"]

@implementation UIImage (cImage)

// 纯颜色图片
+ (UIImage *)imageWithColor:(UIColor *)color
{
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
}

// 特定尺寸纯颜色图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *)imageWithOriImage:(NSString *)imageName {
    return [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
// 获取圆图
+ (UIImage *)getCircleImage:(UIImage *)sourceImage withImageVSize:(CGSize)imageV
{
    //1.开启图片图形上下文:注意设置透明度为非透明
    UIGraphicsBeginImageContextWithOptions(imageV, NO, 0.0);
    //2.开启图形上下文
    CGContextRef ref = UIGraphicsGetCurrentContext();
    //3.绘制圆形区域(此处根据宽度来设置)
    CGRect rect = CGRectMake(0, 0, imageV.width, imageV.width);
    CGContextAddEllipseInRect(ref, rect);
    //4.裁剪绘图区域
    CGContextClip(ref);
    //5.绘制图片
    [sourceImage drawInRect:rect];
    //6.获取图片
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    //7.关闭图形上下文
    UIGraphicsEndImageContext();
    
    return image;
}

- (BOOL)imageHasAlpha: (UIImage *)image
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}
// 得到base64格式图片
- (NSString *)getImage2DataURL
{
    NSData *imageData = nil;
    NSString *mimeType = nil;
    if ([self imageHasAlpha:self]) {
        imageData = UIImagePNGRepresentation(self);
        mimeType = @"image/png";
    } else {
        imageData = UIImageJPEGRepresentation(self, 1.0f);
        mimeType = @"image/jpeg";
    }
    
    return [NSString stringWithFormat:@"data:%@;base64,%@", mimeType,
            [imageData base64EncodedStringWithOptions: 0]];
    
}
// 图片转字符串
+ (NSString *)UIImageToBase64Str:(NSData *)data {
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}
// 字符串转图片
+ (UIImage *)Base64StrToUIImage:(NSString *)_encodedImageStr {
    NSData *_decodedImageData = [[NSData alloc] initWithBase64EncodedString:_encodedImageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *_decodedImage    = [UIImage imageWithData:_decodedImageData];
    return _decodedImage;
}
// 重设图片大小
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize{
    
    // 并把它设置成为当前正在使用的context
    
    UIGraphicsBeginImageContext(newsize);
    
    // 绘制改变大小的图片
    
    [img drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    
    // 从当前context中创建一个改变大小后的图片
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    
    return scaledImage;  
    
}
+ (UIImage *)resizeImage:(UIImage *)oriImage {
    CGSize newSize = oriImage.size;
    if (newSize.width > 0 && newSize.width < 750) {
        return oriImage;
    } else {
        newSize = CGSizeMake(750, (int)(newSize.height * 750 / newSize.width));
    }
    UIGraphicsBeginImageContext(newSize);
    [oriImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
+ (UIImage *)resizeSquareImage:(UIImage *)oriImage {
    if (oriImage.size.height == oriImage.size.width) {
        return oriImage;
    }
    UIImageView *tempView = [[UIImageView alloc] initWithImage:oriImage];
    tempView.frame = CGRectMake(0, 0, 100, 100);
    tempView.contentMode = UIViewContentModeScaleAspectFill;
    tempView.clipsToBounds = YES;
    return [UIImage cutFromView:tempView];
}
// 图片拉伸
+ (UIImage *)resizedImageForStretchableEffect:(UIImage *)image {
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}
// 压缩
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize {
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

#pragma mark - 截特定形状图
// 为图像创建透明区域
-(CGImageRef) CopyImageAndAddAlphaChannel :(CGImageRef) sourceImage {
    CGImageRef retVal = NULL;
    size_t width = CGImageGetWidth(sourceImage);
    size_t height = CGImageGetHeight(sourceImage);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef offscreenContext = CGBitmapContextCreate(NULL, width, height,
                                                          8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    
    if (offscreenContext != NULL) {
        CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), sourceImage);
        
        retVal = CGBitmapContextCreateImage(offscreenContext);
        CGContextRelease(offscreenContext);
    }
    
    CGColorSpaceRelease(colorSpace);
    return retVal;
}
// 合成指定形状截图, 仅限特定形状图不为透明
- (UIImage *)maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    CGImageRef maskRef = maskImage.CGImage;
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef sourceImage = [image CGImage];
    CGImageRef imageWithAlpha = sourceImage;
    //add alpha channel for images that don’t have one (ie GIF, JPEG, etc…)
    //this however has a computational cost
    if (CGImageGetAlphaInfo(sourceImage) == kCGImageAlphaNone) {
        imageWithAlpha = [self CopyImageAndAddAlphaChannel :sourceImage];
    }
    
    CGImageRef masked = CGImageCreateWithMask(imageWithAlpha, mask);
    CGImageRelease(mask);
    
    //release imageWithAlpha if it was created by CopyImageAndAddAlphaChannel
    if (sourceImage != imageWithAlpha) {
        CGImageRelease(imageWithAlpha);
    }
    
    UIImage* retImage = [UIImage imageWithCGImage:masked];
    CGImageRelease(masked);
    return retImage;
}
// 抠掉图中某个区域的颜色
- (UIImage *)maskImage:(UIImage *)image withColor:(CGFloat *)color
{
    CGImageRef sourceImage = image.CGImage;
    
    CGImageAlphaInfo info = CGImageGetAlphaInfo(sourceImage);
    if (info != kCGImageAlphaNone) {
        NSData *buffer = UIImageJPEGRepresentation(image, 1);
        UIImage *newImage = [UIImage imageWithData:buffer];
        sourceImage = newImage.CGImage;
    }
    CGImageRef masked = CGImageCreateWithMaskingColors(sourceImage, color);
    UIImage *retImage = [UIImage imageWithCGImage:masked];
    CGImageRelease(masked);
    return retImage;
}
#pragma mark - 截图
/*
 *  直接截屏
 */
+ (UIImage *)cutScreen {
    return [self cutFromView:[UIApplication sharedApplication].keyWindow];
}

/**
 *  从View中截图/UIView转UIImage
 */
+ (UIImage *)cutFromView:(UIView *)view {
    
    BOOL isHen = view.isHidden;
    [view setHidden:NO];
    //开启图形上下文
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, [UIScreen mainScreen].scale);
    
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //在新建的图形上下文中渲染view的layer
    [view.layer renderInContext:context];
    
    [[UIColor clearColor] setFill];
    
    //获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭图形上下文
    UIGraphicsEndImageContext();
    
    if (isHen) {
        [view setHidden:YES];
    }
    
    return image;
    
}

/**
 *  从图片中截图
 */
- (UIImage *)cutWithFrame:(CGRect)frame {
    
    //创建CGImage ddd
    CGImageRef cgimage = CGImageCreateWithImageInRect(self.CGImage, frame);
    
    //创建image
    UIImage *newImage=[UIImage imageWithCGImage:cgimage];// scale:self.scale orientation:UIImageOrientationLeft];
    
    //释放CGImage
    CGImageRelease(cgimage);
    
    return newImage;
}

#pragma mark - Gif
/**
 *  播放动画
 *
 *  @param data 源文件（图片源）
 *
 *  @return
 */
+ (UIImage *)animatedGIFWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    
    // 加载所有图片
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    // 图片数量
    size_t count = CGImageSourceGetCount(source);
    
    UIImage *animatedImage;
    // 只有一张，直接加载
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    }
    // 多张图片，循环播放
    else {
        NSMutableArray *images = [NSMutableArray array];
        
        NSTimeInterval duration = 0.0f;
        
        for (size_t i = 0; i < count; i++) {
            
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            // 图片播放时间累加
            duration += [self frameDurationAtIndex:i source:source];
            
            [images addObject:[UIImage imageWithCGImage:image
                                                  scale:[UIScreen mainScreen].scale
                                            orientation:UIImageOrientationUp]];
            
            CGImageRelease(image);
        }
        
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        // 加载动画图片，指定动画播放时间
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    
    CFRelease(source);
    
    return animatedImage;
}

/**
 *  计算动画中每一张图片的播放时间
 *
 *  @param index  图片索引
 *  @param source 图片组
 *
 *  @return  播放时间
 */
+ (float)frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    
    // 字典转换
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    
    // 如果有延迟时间
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    }
    // 否则就获取播放下一张图片需要等待的时间
    else {
        
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    
    // 设置最小值
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    
    CFRelease(cfFrameProperties);
    return frameDuration;
}

/**
 *  播放gif动画
 *
 *  @param name 文件名
 *
 *  @return
 */
+ (UIImage *)animatedGIFNamed:(NSString *)name {
    CGFloat scale = [UIScreen mainScreen].scale;
    
    // 视网膜屏，可能要加载高清图
    if (scale > 1.0f) {
        // 文件名1
        NSString *retinaPath = [[NSBundle mainBundle] pathForResource:[name stringByAppendingString:@"@2x"] ofType:@"gif"];
        
        NSData *data = [NSData dataWithContentsOfFile:retinaPath];
        
        if (data) {
            return [UIImage animatedGIFWithData:data];
        }
        
        // 文件名2
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
        
        data = [NSData dataWithContentsOfFile:path];
        
        if (data) {
            return [UIImage animatedGIFWithData:data];
        }
        
        return [UIImage imageNamed:name];
    }
    // 普通屏幕
    else {
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
        
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        if (data) {
            return [UIImage animatedGIFWithData:data];
        }
        
        return [UIImage imageNamed:name];
    }
}

/**
 播放图片数组动画

 @param names 文件名数组
 @return 动图
 */
+ (UIImage *)animatedWithArrayNames: (NSArray *)names {
    CGFloat scale = [UIScreen mainScreen].scale;
    
    // 视网膜屏，可能要加载高清图
    if (scale > 1.0f) {
        // 文件名1
        NSString *retinaPath = [[NSBundle mainBundle] pathForResource:[names.firstObject stringByAppendingString:@"@2x"] ofType:@"png"];
        
        NSData *data = [NSData dataWithContentsOfFile:retinaPath];
        
        if (data) {
            NSMutableArray *datas = [NSMutableArray array];
            for (NSString *name in names) {
                NSString *retinaPath = [[NSBundle mainBundle] pathForResource:[name stringByAppendingString:@"@2x"] ofType:@"png"];
                NSData *data = [NSData dataWithContentsOfFile:retinaPath];
                [datas addObject:data];
            }
            return [UIImage animatedWithNames:datas];
        }
        
        // 文件名2
        NSString *path = [[NSBundle mainBundle] pathForResource:names.firstObject ofType:@"png"];
        
        data = [NSData dataWithContentsOfFile:path];
        
        if (data) {
            NSMutableArray *datas = [NSMutableArray array];
            for (NSString *name in names) {
                NSString *retinaPath = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
                NSData *data = [NSData dataWithContentsOfFile:retinaPath];
                [datas addObject:data];
            }
            return [UIImage animatedWithNames:datas];
        }
        
        return [UIImage imageNamed:names.firstObject];
    }
    // 普通屏幕
    else {
        NSString *path = [[NSBundle mainBundle] pathForResource:names.firstObject ofType:@"png"];
        
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        if (data) {
            NSMutableArray *datas = [NSMutableArray array];
            for (NSString *name in names) {
                NSString *retinaPath = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
                NSData *data = [NSData dataWithContentsOfFile:retinaPath];
                [datas addObject:data];
            }
            return [UIImage animatedWithNames:datas];;
        }
        
        return [UIImage imageNamed:names.firstObject];
    }
    
}

+ (UIImage *)animatedWithNames:(NSArray *)datas {
    NSUInteger count = datas.count;
    // animation
    UIImage *animatedImage;
    // 只有一张，直接加载
    if (count <= 1 && count > 0) {
        animatedImage = [[UIImage alloc] initWithData:datas.firstObject];
    }
    // 多张图片，循环播放
    else {
        NSMutableArray *images = [NSMutableArray array];
        
        NSTimeInterval duration = 0.0f;
        
        for (int i = 0; i < count; i++) {
            
            UIImage *image = [[UIImage alloc] initWithData:datas[i]];
            // 图片播放时间累加
            duration += 0.25;
            [images addObject:image];
        }
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        // 加载动画图片，指定动画播放时间
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    return animatedImage;
}

/**
 *  缩放动画
 *
 *  @param size 大小
 *
 *  @return
 */
- (UIImage *)animatedImageByScalingAndCroppingToSize:(CGSize)size {
    if (CGSizeEqualToSize(self.size, size) || CGSizeEqualToSize(size, CGSizeZero)) {
        return self;
    }
    
    CGSize scaledSize = size;
    CGPoint thumbnailPoint = CGPointZero;
    
    CGFloat widthFactor = size.width / self.size.width;
    CGFloat heightFactor = size.height / self.size.height;
    CGFloat scaleFactor = (widthFactor > heightFactor) ? widthFactor : heightFactor;
    scaledSize.width = self.size.width * scaleFactor;
    scaledSize.height = self.size.height * scaleFactor;
    
    if (widthFactor > heightFactor) {
        thumbnailPoint.y = (size.height - scaledSize.height) * 0.5;
    }
    else if (widthFactor < heightFactor) {
        thumbnailPoint.x = (size.width - scaledSize.width) * 0.5;
    }
    
    NSMutableArray *scaledImages = [NSMutableArray array];
    
    // 重绘制图片
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    for (UIImage *image in self.images) {
        [image drawInRect:CGRectMake(thumbnailPoint.x, thumbnailPoint.y, scaledSize.width, scaledSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        [scaledImages addObject:newImage];
    }
    
    UIGraphicsEndImageContext();
    
    return [UIImage animatedImageWithImages:scaledImages duration:self.duration];
}
#pragma mark - 旋转图片
/**
 *  旋转图片
 *
 *  @param isHorizontal 方向
 *
 *  @return 结果图片
 */
- (UIImage *)flip:(BOOL)isHorizontal {
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClipToRect(ctx, rect);
    if (isHorizontal) {
        CGContextRotateCTM(ctx, M_PI); // 旋转
        CGContextTranslateCTM(ctx, -rect.size.width, -rect.size.height);// 平移
    }
    CGContextDrawImage(ctx, rect, self.CGImage);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, self.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (CGRect)calculateImageViewSize:(UIImage *)image {
    CGSize imageSize = image.size;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat w = screenWidth;
    CGFloat h = w / imageSize.width * imageSize.height;
    CGFloat x = 0.0;
    CGFloat y = ([UIScreen mainScreen].bounds.size.height - h) * 0.5;
    if (h / w > 2) {
        y = 0.0;
    }
    return CGRectMake(x, y, w, h);
}

/**
 分离gif图片为数组
 @return 图片数组
 */
+ (NSArray *)imagesArrayWithGif:(NSString *)gifNameInBoundle {
    //    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:gifNameInBoundle withExtension:@"gif"];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:gifNameInBoundle ofType:@"gif"];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)fileUrl, NULL);
    size_t gifCount = CGImageSourceGetCount(gifSource);
    NSMutableArray *frames = [[NSMutableArray alloc]init];
    for (size_t i = 0; i< gifCount; i++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        [frames addObject:image];
        CGImageRelease(imageRef);
    }
    return frames;
}

+ (UIImage *)getMainWebPImage:(NSString *)webpName {
    NSString *fullPath = getMainWebPImagePath(webpName);
    if (fullPath == nil) {
        return [UIImage new];
    }
    return [YYImage imageWithContentsOfFile:fullPath];
}

@end

#pragma mark - 压缩图片data

@implementation NSData(CompressImage)

+ (NSData *)compressForThumbnail:(NSData *)imageData {
    UIImage *image = [UIImage imageWithData:imageData];
    CGSize size = image.size;
    UIImage *thumbnailImage = size.width * size.height > 200 * 200 ? [image scaleImage:image toScale:sqrt((200 * 200) / (size.width * size.height))] : image;
    NSData *newData = UIImageJPEGRepresentation(thumbnailImage, 1.0);
    return [newData compressWithMaxLength:30];
}
/**
 压缩图片
 
 @param maxLength 预设最大尺寸 单位kb
 @return 新的图片数据
 */
- (NSData *)compressWithMaxLength:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    maxLength *= 1024;
    UIImage *oriImage = [UIImage resizeImage:[[UIImage alloc] initWithData:self]];
    NSData *data = UIImageJPEGRepresentation(oriImage, compression);
    //NSLog(@"Before compressing quality, image size = %ld KB",data.length/1024);
    if (data.length < maxLength) return data;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(oriImage, compression);
        //NSLog(@"Compression = %.1f", compression);
        //NSLog(@"In compressing quality loop, image size = %ld KB", data.length / 1024);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    //NSLog(@"After compressing quality, image size = %ld KB", data.length / 1024);
    if (data.length < maxLength) return data;
    UIImage *resultImage = [UIImage imageWithData:data];
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        //NSLog(@"Ratio = %.1f", ratio);
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
        //NSLog(@"In compressing size loop, image size = %ld KB", data.length / 1024);
    }
    //NSLog(@"After compressing size loop, image size = %ld KB", data.length / 1024);
    return data;
}
@end
