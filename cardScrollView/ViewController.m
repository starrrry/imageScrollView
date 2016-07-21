//
//  ViewController.m
//  cardScrollView
//
//  Created by lele on 16/7/21.
//  Copyright © 2016年 tianyu. All rights reserved.
//

#import "ViewController.h"

#define kGCCardWIDTHRatio 0.3
#define kGCCardRatio 0.7
#define kGCCardWidth CGRectGetWidth(self.view.frame)*kGCCardRatio
#define kGCCardHeight kGCCardWidth/kGCCardRatio

@interface ViewController ()

@property (strong, nonatomic) NSArray *imageArrays;
@property (strong, nonatomic) CardScrollView *cardScrollView;
@property (nonatomic, strong) NSMutableArray *cards;
@property (assign, nonatomic) CGFloat screenRate;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageArrays = @[@"1.jpg" ,@"2.jpg" ,@"3.jpg" ,@"4.jpg" ,@"5.jpg", @"6.jpg" ,@"7.jpg" ,@"8.jpg"];
    _screenRate = self.view.frame.size.width / 320;
    [self updateDataSource];
}

#pragma mark - CardScrollViewDelegate
- (void)updateCard:(UIImageView *)card withProgress:(CGFloat)progress direction:(CardMoveDirection)direction {
    
}

-(void)changeLeftBackGoundAlphaWithIndex:(NSUInteger)index
                               withAlpha:(CGFloat)alpha{
    [self setChangeFrameWithIndex:index withLastIndex:index+1 withPreIndex:index+2 withAlpha:1-alpha withPreTwoIndex:index-1];
}
- (void)changeRightBackGoundAlphaWithIndex:(NSUInteger)index withAlpha:(CGFloat)alpha{
    [self setChangeFrameWithIndex:index withLastIndex:index-1 withPreIndex:index-2 withAlpha:alpha withPreTwoIndex:index+1];
}

#pragma CardScrollView
-(void)updateDataSource {
    self.cardScrollView = [[CardScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50-60)];
    self.cardScrollView.preAlpha=1.0f;
    self.cardScrollView.cardDelegate = self;
    self.cardScrollView.cardDataSource = self;
    [self.cardScrollView setAlpha:1.0f];
    [self.view addSubview:self.cardScrollView];
    [self.cardScrollView loadCard];
    [self setChangeFrameWithIndex:0 withLastIndex:0 withPreIndex:0 withAlpha:1 withPreTwoIndex:0];
}

-(void)setChangeFrameWithIndex:(NSUInteger)index
                 withLastIndex:(NSUInteger)lastIndex
                  withPreIndex:(NSUInteger)preIndex
                     withAlpha:(CGFloat)alpha
               withPreTwoIndex:(NSUInteger)preTwoIndex{
    CGFloat scrollViewWidth = self.cardScrollView.frame.size.width;
    
    for (int i=0; i<self.imageArrays.count; i++) {
        if (index == i ){
            UIImageView* im=(UIImageView*)[self.cardScrollView.scrollView  viewWithTag:10000+i];
            CGRect frame=im.frame;
            frame.origin.y=self.cardScrollView.originY-30*_screenRate*alpha;
            frame.size.width=scrollViewWidth*kGCCardRatio*0.75+scrollViewWidth*kGCCardRatio*0.25*alpha;
            frame.size.height=scrollViewWidth*kGCCardRatio*0.78+scrollViewWidth*kGCCardRatio*0.22*alpha;
            frame.origin.x=scrollViewWidth*kGCCardRatio*i+0.25/2*scrollViewWidth*kGCCardRatio*(1-alpha);
            im.frame=frame;
        } else if (lastIndex == i){
            UIImageView *im2=(UIImageView*)[self.cardScrollView.scrollView viewWithTag:10000+i];
            
            if ([self.cardScrollView.scrollView.subviews containsObject:im2]) {
                CGRect frame=im2.frame;
                frame.origin.y=self.cardScrollView.originY-30*_screenRate+30*_screenRate*alpha;
                frame.size.width=scrollViewWidth*kGCCardRatio-scrollViewWidth*kGCCardRatio*0.25*alpha;
                frame.size.height=scrollViewWidth*kGCCardRatio-scrollViewWidth*kGCCardRatio*0.22*alpha;
                frame.origin.x=scrollViewWidth*kGCCardRatio*i+0.25/2*scrollViewWidth*kGCCardRatio*alpha;
                im2.frame=frame;
            }
        } else if (preIndex == i) {
            UIImageView *im2=(UIImageView*)[self.cardScrollView.scrollView viewWithTag:10000+i];
            if ([self.cardScrollView.scrollView.subviews containsObject:im2]) {
                CGRect frame=im2.frame;
                frame.origin.y=self.cardScrollView.originY-30*_screenRate*alpha;
                frame.size.width=scrollViewWidth*kGCCardRatio*0.75-scrollViewWidth*kGCCardRatio*0.25*alpha;
                frame.size.height=scrollViewWidth*kGCCardRatio*0.78;
                frame.origin.x=scrollViewWidth*kGCCardRatio*i+0.25/2*scrollViewWidth*kGCCardRatio+0.25/2*scrollViewWidth*kGCCardRatio*alpha;
                im2.frame=frame;
            }
        }else if (preTwoIndex == i){
            UIImageView *im2=(UIImageView*)[self.cardScrollView.scrollView viewWithTag:10000+i];
            
            if ([self.cardScrollView.scrollView.subviews containsObject:im2]) {
                CGRect frame=im2.frame;
                frame.origin.y=self.cardScrollView.originY-30*_screenRate+30*_screenRate*alpha;
                frame.size.width=scrollViewWidth*kGCCardRatio-scrollViewWidth*kGCCardRatio*0.25*alpha;
                frame.size.height=scrollViewWidth*kGCCardRatio-scrollViewWidth*kGCCardRatio*0.22*alpha;
                frame.origin.x=scrollViewWidth*kGCCardRatio*i+0.25/2*scrollViewWidth*kGCCardRatio*alpha;
                im2.frame=frame;
            }
        }  else {
            
            UIImageView *im2=(UIImageView*)[self.cardScrollView.scrollView viewWithTag:10000+i];
            if ([self.cardScrollView.scrollView.subviews containsObject:im2]) {
                CGRect frame=im2.frame;
                frame.origin.y=self.cardScrollView.originY-30*_screenRate+50*_screenRate*alpha;
                frame.size.width=scrollViewWidth*kGCCardRatio-scrollViewWidth*kGCCardRatio*kGCCardWIDTHRatio*alpha;
                frame.size.height=scrollViewWidth*kGCCardRatio-scrollViewWidth*kGCCardRatio*0.22*alpha;
                frame.origin.x=scrollViewWidth*kGCCardRatio*i+kGCCardWIDTHRatio/2*scrollViewWidth*kGCCardRatio;
                im2.frame=frame;
            }
        }
    }
}


#pragma mark - CardScrollViewDataSource
- (NSInteger)numberOfCards {
    return self.imageArrays.count;
}

- (UIImageView *)cardReuseView:(UIImageView *)reuseView atIndex:(NSInteger)index {
    if (reuseView) {
        reuseView.tag=index+10000;
        reuseView.image = [UIImage imageNamed:_imageArrays[index]];
        
        return reuseView;
    }
    UIImageView *card = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kGCCardWidth , kGCCardWidth)];
    card.contentMode=UIViewContentModeScaleAspectFill;
    card.clipsToBounds=YES;
    card.alpha=1.0f;
    card.tag=index+10000;
    card.userInteractionEnabled=YES;
    card.image = [UIImage imageNamed:_imageArrays[index]];
    
    return card;
}

- (void)deleteCardWithIndex:(NSInteger)index {
    [self.cards removeObjectAtIndex:index];
}



@end
