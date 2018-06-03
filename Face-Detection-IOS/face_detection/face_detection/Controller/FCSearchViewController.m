//
//  FCAddFaceViewController.m
//  FaceSDKDemo
//
//  Created by Yang Yunxing on 2017/7/4.
//  Copyright © 2017年 Yang Yunxing. All rights reserved.
//

#import "FCSearchViewController.h"
#import "FCPPSDK.h"
#import "MBProgressHUD.h"
#import "SDImageCache.h"

static NSString *cellId = @"faceCellId";
#define faceFilePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"face.plist"]

@interface FCSearchViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong , nonatomic) FCPPFaceSet *faceSet;

@property (strong , nonatomic) NSMutableDictionary *faceMap;

@property (strong , nonatomic) NSMutableArray *dataArray;

@property (assign , nonatomic) BOOL addFace;

@property (assign , nonatomic) NSInteger faceIndex;
@end

@implementation FCSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.faceIndex = -1;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellId];
    self.faceSet = [[FCPPFaceSet alloc] initWithOuterId:@"fc01"];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.addFace) {
            [self addImage:image];
        }
    }];
}

- (void)addImage:(UIImage *)image{
    
    __weak typeof(self) weakSelf = self;
    
    self.imageView.image = image;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在检测人脸...";
    //2.0检测人脸
    FCPPFaceDetect *faceDetector = [[FCPPFaceDetect alloc] initWithImage:image];
    [faceDetector detectFaceWithReturnLandmark:NO attributes:nil completion:^(id info, NSError *error) {
        if (error) {
            hud.label.text = @"人脸检测失败,请重新添加";
            [hud hideAnimated:YES afterDelay:1.5];
        }else{
            hud.label.text = @"正在添加到人脸集合...";
            NSArray *faceTokens = [info[@"faces"] valueForKeyPath:@"face_token"];

            //3.添加到人脸集合
            if (faceTokens.count && weakSelf.faceSet) {
                [weakSelf.faceSet addFaceTokens:faceTokens completion:^(id info, NSError *error) {
                    if (error == nil) {
                        //2.1建立映射关系
                        for (NSString *faceToken in faceTokens) {
                            //把图片存储到本地，faceToken作为key存储图片
                            [[SDImageCache sharedImageCache] storeImage:image forKey:faceToken];
                            NSLog(@"faceToken: %@", faceToken);
                            NSDictionary *dic = @{@"imageKey": faceToken,  //对应的本地的图片
//                                                  @"personName" : @"xxx", //设置对应人的名字
                                                    @"" : @"",              //其他自定义对应的信息
                                                 };
                            [weakSelf.faceMap setObject:dic forKey:faceToken];//建立映射
                            [weakSelf.dataArray addObject:faceToken];
                        }
                        [weakSelf.faceMap writeToFile:faceFilePath atomically:YES];
                        [weakSelf.collectionView reloadData];
                        [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.dataArray.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
                        hud.label.text = @"添加成功";
                    }else{
                        hud.label.text = @"添加失败";
                    }
                    [hud hideAnimated:YES afterDelay:1.5];
                }];
            }else{
                hud.label.text = @"添加失败";
                [hud hideAnimated:YES afterDelay:1.5];
            }
        }
    }];
}

- (IBAction)addFace:(UIButton *)sender {
    self.addFace = YES;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    NSString *faceToken = self.dataArray[indexPath.item];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:faceToken];
    cell.backgroundView = imageView;
    if (indexPath.item == self.faceIndex) {
        imageView.layer.borderColor = [UIColor greenColor].CGColor;
        imageView.layer.borderWidth = 2;
    }else{
        imageView.layer.borderWidth = 0;
    }
    return cell;
}

- (NSMutableDictionary *)faceMap{
    if (_faceMap == nil) {
        _faceMap = [NSDictionary dictionaryWithContentsOfFile:faceFilePath].mutableCopy;
    }
    
    if (_faceMap == nil) {
        _faceMap = [NSMutableDictionary dictionary];
    }
    return _faceMap;
}

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = self.faceMap.allKeys.mutableCopy;
    }
    
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)dismissSelf:(UIButton *)sender{
    [self dismissViewControllerAnimated:NO completion:^{}];
}

@end
