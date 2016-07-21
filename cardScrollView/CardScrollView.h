//
//  CardScrollView.h
//  GCCardViewController
//
//  Created by lele on 16/5/31.
//  Copyright © 2016年 lele. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CardMoveDirection) {
    CardMoveDirectionNone,
    CardMoveDirectionLeft,
    CardMoveDirectionRight
};

@protocol CardScrollViewDataSource <NSObject>

- (NSInteger)numberOfCards;
- (UIImageView *)cardReuseView:(UIImageView *)reuseView atIndex:(NSInteger)index;
@optional
- (void)deleteCardWithIndex:(NSInteger)index;

@end

@protocol CardScrollViewDelegate <NSObject>
-(void)changeLeftBackGoundAlphaWithIndex:(NSUInteger)index
                               withAlpha:(CGFloat)alpha;
-(void)changeRightBackGoundAlphaWithIndex:(NSUInteger)index
withAlpha:(CGFloat)alpha;
- (void)updateCard:(UIImageView *)card withProgress:(CGFloat)progress direction:(CardMoveDirection)direction;

@end

@interface CardScrollView : UIView
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, assign) NSInteger totalNumberOfCards;
@property (nonatomic, assign) NSInteger startCardIndex;
@property (nonatomic, assign) NSInteger currentCardIndex;
@property (nonatomic, weak) id<CardScrollViewDataSource>cardDataSource;

@property (nonatomic, weak) id<CardScrollViewDelegate>cardDelegate;
@property (nonatomic, assign) BOOL canDeleteCard;
@property (nonatomic, assign) BOOL preAlpha;
@property(nonatomic,assign) CGFloat originY;
@property(nonatomic,assign) CGFloat MaxOriginY;
- (void)loadCard;
- (void)reloadCard;
- (NSArray *)allCards;
- (NSInteger)currentCard;
-(CGPoint)centerForCardWithIndex:(NSUInteger)index;
- (void)reuseCardWithMoveDirection:(CardMoveDirection)moveDirection;
@end
