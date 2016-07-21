//
//  CardScrollView.m
//  GCCardViewController
//
//  Created by lele on 16/5/31.
//  Copyright © 2016年 lele. All rights reserved.
//

#import "CardScrollView.h"
#define kGCRatio 0.7
#define kGCViewWidth CGRectGetWidth(self.frame)
#define kGCViewHeight CGRectGetHeight(self.frame)
#define kGCScrollViewWidth kGCViewWidth*kGCRatio

@interface CardScrollView ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@end

@implementation CardScrollView
{
    NSUInteger lastIndex;
    CGFloat lastOffsetX;
    CardMoveDirection currentMoveDirection;
}
#pragma mark - initialize

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    CGFloat rate = [[UIScreen mainScreen] bounds].size.width/320;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kGCScrollViewWidth, kGCViewHeight)];
    self.scrollView.center = CGPointMake(self.center.x, self.center.y-13*rate);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    [self addSubview:self.scrollView];
    self.cards = [NSMutableArray array];
    self.startCardIndex = 0;
    self.currentCardIndex = 0;
    self.canDeleteCard = YES;
}

#pragma mark - public methods

- (void)loadCard {
    for (UIImageView *card in self.cards) {
        [card removeFromSuperview];
    }
    
    self.totalNumberOfCards = [self.cardDataSource numberOfCards];
    if (self.totalNumberOfCards == 0) {
        return;
    }
    [self.scrollView setContentSize:CGSizeMake(kGCScrollViewWidth*self.totalNumberOfCards, kGCViewHeight)];
    [self.scrollView setContentOffset:[self contentOffsetWithIndex:0]];
    for (NSInteger index = 0; index < (self.totalNumberOfCards < 4 ? self.totalNumberOfCards : 4); index++) {
        UIImageView *card = [self.cardDataSource cardReuseView:nil atIndex:index];
        card.center =[self centerForCardWithIndex:index];
        card.tag = index + 10000;
        self.originY=card.frame.origin.y+50*self.frame.size.width/320;
        self.MaxOriginY=self.originY+30;
        [self.scrollView addSubview:card];
        [self.cards addObject:card];
        
        [self.cardDelegate updateCard:card withProgress:1 direction:CardMoveDirectionNone];
    }
}

- (void)reloadCard {
    self.totalNumberOfCards = [self.cardDataSource numberOfCards];
    if (self.totalNumberOfCards == 0) {
        return;
    }
    [self.scrollView setContentSize:CGSizeMake(kGCScrollViewWidth*self.totalNumberOfCards, kGCViewHeight)];
    [self reuseCardWithMoveDirection:currentMoveDirection];
}

- (NSArray *)allCards {
    return self.cards;
}

- (NSInteger)currentCard {
    return self.currentCardIndex;
}

#pragma mark - private methods

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated {
    
    [self.scrollView setContentOffset:[self contentOffsetWithIndex:index] animated:animated];
}

- (CGPoint)centerForCardWithIndex:(NSUInteger)index {
    return CGPointMake(kGCScrollViewWidth*(index + 0.5), self.scrollView.center.y);
}

- (CGPoint)contentOffsetWithIndex:(NSUInteger)index {
    return CGPointMake(kGCScrollViewWidth*index, 0);
}

- (void)reuseCardWithMoveDirection:(CardMoveDirection)moveDirection {
    BOOL isLeft = moveDirection == CardMoveDirectionLeft;
    UIView *card = nil;
    if (isLeft) {
        if (self.currentCardIndex > self.totalNumberOfCards - 3 || self.currentCardIndex < 2) {
            return;
        }
        card = [self.cards objectAtIndex:0];
        card.tag+=4;
    } else {
        if (self.currentCardIndex > self.totalNumberOfCards - 4 ||
            self.currentCardIndex < 1) {
            return;
        }
        card = [self.cards objectAtIndex:3];
        card.tag-=4;
    }
    card.center = [self centerForCardWithIndex:card.tag - 10000];
    [self.cardDataSource cardReuseView:(UIImageView *)card atIndex:card.tag - 10000];
    [self ascendingSortCards];
}


- (void)resetTagFromIndex:(NSInteger)index {
    [self.cards enumerateObjectsUsingBlock:^(UIView *card, NSUInteger idx, BOOL * _Nonnull stop) {
        if ((NSInteger)idx > index) {
            card.tag-=1;
            [UIView animateWithDuration:0.3 animations:^{
                card.center = [self centerForCardWithIndex:card.tag - 10000];
            }];
        }
    }];
}

- (void)ascendingSortCards {
    [self.cards sortUsingComparator:^NSComparisonResult(UIView *obj1, UIView *obj2) {
        return obj1.tag > obj2.tag;
    }];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat orginContentOffset = self.currentCardIndex*kGCScrollViewWidth;
    CGFloat diff = scrollView.contentOffset.x - orginContentOffset;
    
    CardMoveDirection direction = diff > 0 ? CardMoveDirectionLeft : CardMoveDirectionRight;
    CGFloat x;
    x=scrollView.contentOffset.x;
    CGFloat scrollOffsetX=kGCScrollViewWidth;
    if (scrollView.contentOffset.x<=lastOffsetX&&scrollView.contentOffset.x>0&&scrollView.contentOffset.x<self.scrollView.contentSize.width-scrollOffsetX) {
        
        
        int y=(x+.5)/scrollOffsetX;CGFloat z;
        if (y==0) {
            z=scrollView.contentOffset.x/scrollOffsetX;
        }else{
            z=(scrollView.contentOffset.x-y*scrollOffsetX)/scrollOffsetX;
        }
        if ([[NSString stringWithFormat:@"%.2f",z] floatValue]==1.00f) {
            z=0.0f;
        }else{
            [self.cardDelegate changeLeftBackGoundAlphaWithIndex:y withAlpha:z];
        }
    }else if (scrollView.contentOffset.x>lastOffsetX&&scrollView.contentOffset.x>0&&scrollView.contentOffset.x<self.scrollView.contentSize.width-scrollOffsetX){
        int y=(x-.5)/scrollOffsetX;CGFloat z;
        if (y==0) {
            z=scrollView.contentOffset.x/scrollOffsetX;
        }else{
            z=(scrollView.contentOffset.x-y*scrollOffsetX)/scrollOffsetX;
        }
        if (scrollView.contentOffset.x!=0&&z==0) {
            z=1.0f;
        }else if (z<0){
            z=1.0f;
        }else{
            
            [self.cardDelegate changeRightBackGoundAlphaWithIndex:y+1 withAlpha:z];
        }
        
        
    }
    lastIndex=x;
    currentMoveDirection = direction;
    
    if (fabs(diff) >= kGCScrollViewWidth*kGCRatio) {
        self.currentCardIndex = direction == CardMoveDirectionLeft ? self.currentCardIndex + 1 : self.currentCardIndex - 1;
        [self reuseCardWithMoveDirection:direction];
    }
    
    lastOffsetX=scrollView.contentOffset.x;
}

@end
