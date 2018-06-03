//
//  OpencvWrapper.m
//  face_detection
//
//  Created by Yuhan Tang
//

#import "OpencvWrapper.h"
//#import "face_detection-Swift.h"
#import <opencv2/opencv.hpp>
#import <opencv2/objdetect/objdetect.hpp>
#import <opencv2/objdetect.hpp>
#import "FCPPSDK.h"
using namespace std;

@implementation OpencvWrapper

cv::CascadeClassifier face_cascade;
cv::CascadeClassifier eyes_cascade;
bool cascade_loaded = false;
static int count_num = 1;
static int x_value = 0;
static int y_value = 0;
static NSString *current_name = @"";
static NSMutableArray *users = [NSMutableArray array];

+ (int)xValue
{
    return x_value;
}

+ (int)yValue
{
    return y_value;
}

+ (NSString *)returnName
{
    //extern int counter;
    return current_name;
}

+ (void)addUser:(NSString *)name andToken:(NSString *)token{
    NSDictionary *dic = @{@"Name":name,@"Face_token":token};
    [users addObject:dic];
}

+ (UIImage *)detect:(UIImage *)source {
    [self addUser:@"唐玉涵" andToken:@"b4a469cb9c21e72937008131a4a1ba4b"];
    [self addUser:@"徐玥" andToken:@"de9388b17afafd0c95e42750d7bf2b25"];
    [self addUser:@"郭元晨" andToken:@"628b7417f3564fbba9440bf9787f01bd"];
    [self addUser:@"陈禹东" andToken:@"1074e7821756facce06616738524e292"];
    
    ///1. Convert input UIImage to Mat
    std::vector<cv::Rect> faces;
    CGImageRef image = CGImageCreateCopy(source.CGImage);
    CGFloat cols = CGImageGetWidth(image);
    CGFloat rows = CGImageGetHeight(image);
    cv::Mat frame(rows, cols, CV_8UC4);
    
    CGBitmapInfo bitmapFlags = kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault;
    size_t bitsPerComponent = 8;
    size_t bytesPerRow = frame.step[0];
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image);
    
    CGContextRef context = CGBitmapContextCreate(frame.data, cols, rows, bitsPerComponent, bytesPerRow, colorSpace, bitmapFlags);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, cols, rows), image);
    CGContextRelease(context);
    cv::Mat frame_gray;
    
    cvtColor( frame, frame_gray, CV_BGR2GRAY );
    equalizeHist( frame_gray, frame_gray );
    
    ///2. detection
    NSString *eyes_cascade_name = [[NSBundle mainBundle] pathForResource:@"haarcascade_eye" ofType:@"xml"];
    NSString *face_cascade_name = [[NSBundle mainBundle] pathForResource:@"haarcascade_frontalface_default" ofType:@"xml"];
    if(!cascade_loaded){
        std::cout<<"loading ..";
        if( !eyes_cascade.load( std::string([eyes_cascade_name UTF8String]) ) ){ printf("--(!)Error loading\n"); return source;};
        if( !face_cascade.load( std::string([face_cascade_name UTF8String]) ) ){ printf("--(!)Error loading\n"); return source;};
        cascade_loaded = true;
    }
    face_cascade.detectMultiScale(frame_gray, faces, 1.3, 5);
    if(faces.size() == 0){
        current_name = @"";
    }
    for( size_t i = 0; i < faces.size(); i++ )
    {
        count_num = count_num + 1;
        
        cv::Rect rec = cv::Rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
        rectangle(frame,  rec, cv::Scalar( 0, 100, 255 ), 3, 8, 0);
        x_value = faces[i].x + faces[i].width * 0.5 - 10;
        y_value = (faces[i].y + faces[i].height) * 1.26;
    }
    
//    if(count_num % 10 == 0){
//        FCPPFace *face = [[FCPPFace alloc] initWithImage:source];
//        FCPPFaceSet *faceSet = [[FCPPFaceSet alloc] initWithOuterId:@"fc01"];
//
//        [face searchFromFaceSet:faceSet returnCount:1 completion:^(id info, NSError *error) {
//            if (info) {
//                NSArray *faces = info[@"faces"];
//                if (faces.count) {
//                    //                [hud hideAnimated:YES];
//                    NSDictionary *result = [info[@"results"] firstObject];
//                    NSDictionary *thresholds = info[@"thresholds"];
//                    NSString *faceToken = result[@"face_token"];
//                    CGFloat confidence = [result[@"confidence"] floatValue];
//                    //                CGFloat maxThreshold = [thresholds[@"1e-5"] floatValue];
//                    CGFloat midThreshold = [thresholds[@"1e-4"] floatValue];
//                    //                CGFloat minThreshold = [thresholds[@"1e-3"] floatValue];
//
//                    BOOL vaild = confidence > midThreshold;//置信度大于阈值,才算搜到的是一个人
//                    if (faceToken && vaild) {//搜索到人脸
//                        //                        cout<<"找到的人脸："<<faceToken<<endl;
//
//                        NSLog(@"找到的人脸：%@ hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh",faceToken);
//                        for(NSObject* user in users){
//                            if([[user valueForKey:@"Face_token"] isEqualToString:faceToken]){
//                                current_name = [user valueForKey:@"Name"];
//                                break;
//                            }
//                        }
////                        for user in users:
////                            if(user['Face_token'] == face_token):
////                                current_name =  user['Name']
//
//                        //5.根据faceToken的映射关系,取出相应信息
//                        //                    if ([self.dataArray containsObject:faceToken]) {
//                        //                        NSInteger index = [self.dataArray indexOfObject:faceToken];
//                        //                        self.faceIndex = index;
//                        //                        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
//                        //                        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
//                        //                    }
//                    }else{
//                        NSLog(@"没有搜索到合适的人脸");
//                        current_name = @"";
//                    }
//                }else{
//                    NSLog(@"没有检测到人脸");
//                    current_name = @"";
//                }
//            }else{
//                NSLog(@"网络请求失败");
//                current_name = @"";
//            }
//        }];
//    }
    
//    std::string text = "Hello Yuhan World!";
//    int font_face = cv::FONT_HERSHEY_SIMPLEX;
//    double font_scale = 0.8;
//    int thickness = 1.5;
//    int baseline;
//    //获取文本框的长宽
//    cv::Size text_size = cv::getTextSize(text, font_face, font_scale, thickness, &baseline);
//
//    //将文本框居中绘制
//    cv::Point origin;
//    origin.x = cols / 2 - text_size.width / 2;
//    origin.y = rows / 2 + text_size.height / 2;
//    cv::putText(frame, text, origin, font_face, font_scale, cv::Scalar(255, 255, 255), thickness, 8, 0);
    
    ///3. Convert Mat to UIImage
    NSData *data = [NSData dataWithBytes:frame.data length:frame.elemSize() * frame.total()];
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    bitmapFlags = kCGImageAlphaNone | kCGBitmapByteOrderDefault;
    bitsPerComponent = 8;
    bytesPerRow = frame.step[0];
    colorSpace = (frame.elemSize() == 1 ? CGColorSpaceCreateDeviceGray() : CGColorSpaceCreateDeviceRGB());
    
    image = CGImageCreate(frame.cols, frame.rows, bitsPerComponent, bitsPerComponent * frame.elemSize(), bytesPerRow, colorSpace, bitmapFlags, provider, NULL, false, kCGRenderingIntentDefault);
    UIImage *result = [UIImage imageWithCGImage:image];
    
    CGImageRelease(image);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return result;
}


@end

