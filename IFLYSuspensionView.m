//
//  KADDragImageView.m
//  Medicare
//
//  Created by admin on 2018/6/26.
//  Copyright © 2018年 medicare. All rights reserved.
//

#import "IFLYSuspensionView.h"
#import "UIImage+GIF.h"
#import "UIImageView+WebCache.h"
#import "Common.h"
#import "IFLYAudioRetrievalVC.h"
#define kPrompt_DismisTime    0.2
@interface IFLYSuspensionView() {

}
@end
@implementation IFLYSuspensionView
+ (IFLYSuspensionView *)share {
    static IFLYSuspensionView *_prescription;
    static dispatch_once_t one;
    dispatch_once(&one, ^{
        _prescription = [[IFLYSuspensionView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [_prescription addGesturetheEvent];
    });
    return _prescription;
}


- (void)addGesturetheEvent {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMe)];
        [self addGestureRecognizer:tap];

        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changePostion:)];
        [self addGestureRecognizer:pan];
        
        [self sd_setImageWithURL:nil
                               placeholderImage:[Common setAnimatedGIFNamed:@"loading"]
                                        options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                            if (image) {
                                                [self setImage:image];
                                            } else {
                                                

                                            }
                                        }];
    }

- (void)setWithFrame:(CGRect)frame {
    self.frame = frame;
}

- (void)tapMe {
    NSLog(@"点击手势");
    UIViewController * viewcontroler = [Common getCurrentVC];
    [viewcontroler.navigationController pushViewController:[[IFLYAudioRetrievalVC alloc] init] animated:YES];
}


-(void)changePostion:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    CGRect originalFrame = self.frame;
    if (originalFrame.origin.x >= 0 && originalFrame.origin.x+originalFrame.size.width <= width) {
        originalFrame.origin.x += point.x;
    }
    if (originalFrame.origin.y >= 0 && originalFrame.origin.y+originalFrame.size.height <= height) {
        originalFrame.origin.y += point.y;
    }
    self.frame = originalFrame;
    [pan setTranslation:CGPointZero inView:self];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self beginPoint];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self changePoint];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self endPoint];
        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
            [self endPoint];
        }
            break;
            
        default:
            break;
    }
    
}
- (void)beginPoint {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [UIView animateWithDuration:kPrompt_DismisTime animations:^{
        
       
    }];
}
- (void)changePoint {
    BOOL isOver = NO;
    CGRect frame = self.frame;
    if (frame.origin.x < 0) {
        frame.origin.x = 0;
        isOver = YES;
    } else if (frame.origin.x+frame.size.width > kScreenWidth) {
        frame.origin.x = kScreenWidth - frame.size.width;
        isOver = YES;
    }
    if (frame.origin.y < 0) {
        frame.origin.y = 0;
        isOver = YES;
    } else if (frame.origin.y+frame.size.height > kScreenHeight) {
        frame.origin.y = kScreenHeight - frame.size.height;
        isOver = YES;
    }
    if (isOver) {
        [UIView animateWithDuration:kPrompt_DismisTime animations:^{
            self.frame = frame;
        }];
    }
}

static CGFloat _allowance = 30; //上下左右偏移量
- (void)endPoint {
    if (self.x <= kScreenWidth / 2 -  CGRectGetWidth(self.frame)/2) {
        if (self.y >=kScreenHeight -  CGRectGetHeight(self.frame) - _allowance) {
            [UIView animateWithDuration:kPrompt_DismisTime animations:^{
                self.y =kScreenHeight -  CGRectGetHeight(self.frame)/2.f - _allowance;
                self.x = CGRectGetWidth(self.frame)/2 + _allowance;
            }];
        } else {
            if (self.y <= _allowance) {
                [UIView animateWithDuration:kPrompt_DismisTime animations:^{
                    self.y = CGRectGetWidth(self.frame)/2 + _allowance;
                    self.x = CGRectGetWidth(self.frame)/2 + _allowance;
                }];
                
            } else {
                [UIView animateWithDuration:kPrompt_DismisTime animations:^{
                    self.x = CGRectGetWidth(self.frame)/2 + _allowance;
                }];
            }
        }
    } else {
        if (self.y >=kScreenHeight -  CGRectGetHeight(self.frame) - _allowance) {
            [UIView animateWithDuration:kPrompt_DismisTime animations:^{
                self.x =kScreenWidth - CGRectGetWidth(self.frame)/2 - _allowance;
                self.y = kScreenHeight -  CGRectGetHeight(self.frame)/2.f - _allowance;
            }];
        } else {
            if (self.y <= _allowance) {
                [UIView animateWithDuration:kPrompt_DismisTime animations:^{
                    self.y = CGRectGetWidth(self.frame)/2 + _allowance;
                    self.x =kScreenWidth - CGRectGetWidth(self.frame)/2 - _allowance;
                }];
            }else
            {
                [UIView animateWithDuration:kPrompt_DismisTime animations:^{
                    self.x = kScreenWidth - CGRectGetWidth(self.frame)/2 - _allowance;
                }];
            }
        }
    }
}


@end
