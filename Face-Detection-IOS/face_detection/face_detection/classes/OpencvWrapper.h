//
//  OpencvWrapper.h
//  face_detection
//
//  Created by Yuhan Tang
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OpencvWrapper : NSObject
+ (int)xValue;
+ (int)yValue;
+ (NSString *)returnName;
+ (void)addUser:(NSString *)name andToken:(NSString *)token;
+ (UIImage *)detect:(UIImage *)source;
@end
