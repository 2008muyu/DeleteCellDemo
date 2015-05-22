//
//  UITableViewCell+Delete.m
//  DeleteCellDemo
//
//  Created by mby on 15/5/22.
//  Copyright (c) 2015年 M3. All rights reserved.
//

#import "UITableViewCell+Delete.h"

#import <objc/runtime.h>

char* const ASSOCIATION_DELEGATE = "ASSOCIATION_DELEGATE";
char* const ASSOCIATION_IS_SHOW = "ASSOCIATION_IS_SHOW";

@implementation UITableViewCell (Delete)
@dynamic deleteDelegate, isShow;

#pragma mark prepoty method
- (void)setDeleteDelegate:(id<DeleteCellDelegate>)deleteDelegate {
    return objc_setAssociatedObject(self, ASSOCIATION_DELEGATE, deleteDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<DeleteCellDelegate>)deleteDelegate {
    return objc_getAssociatedObject(self, ASSOCIATION_DELEGATE);
}

- (void)setIsShow:(BOOL)isShow {
    return objc_setAssociatedObject([self getSuperView], ASSOCIATION_IS_SHOW, [NSNumber numberWithBool:isShow], OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isShow {
    return objc_getAssociatedObject([self getSuperView], ASSOCIATION_IS_SHOW);
}

/**
 *  获取删除imageview
 *
 *  @return 删除imageview
 */
- (UIImageView*)getDeleteImageView {
    UIImageView* deleteImg = (UIImageView*)[self viewWithTag:10010];
    return deleteImg;
}
/**
 *  是否开启delete
 *
 *  @param enableDelete 是否开启
 */
- (void)enableDeleteMethod:(BOOL)enableDelete {
    [self isEnableDelete];
}
/**
 *  构造
 */
- (void)isEnableDelete {
    UISwipeGestureRecognizer* leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeAction:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:leftSwipe];
    
    UISwipeGestureRecognizer* rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeAction:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:rightSwipe];
    
    UIImageView* deleteImageView = [[UIImageView alloc] init];
    deleteImageView.tag = 10010;
    deleteImageView.backgroundColor = [UIColor redColor];
    deleteImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0, DELETE_VIEW_WIDTH, self.frame.size.height);
    deleteImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer* deleteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteAction)];
    [deleteImageView addGestureRecognizer:deleteTap];
    
    [self.contentView addSubview:deleteImageView];
}

#pragma mark event action
/**
 *  左滑事件
 *
 *  @param leftSwipe 左滑手势对象
 */
- (void)leftSwipeAction:(UISwipeGestureRecognizer*)leftSwipe {
    UITableView* tableView = [self getSuperView];
    NSArray* visibleCells = [tableView visibleCells];
    for (UITableViewCell* cell in visibleCells) {
        if (cell && cell!=self && cell.isShow) {
            [cell placeDeleteViewWithAnimation:YES];
        }
    }
    UIImageView* deleteImg = (UIImageView*)[self viewWithTag:10010];
    [UIView animateWithDuration:0.3 animations:^{
        deleteImg.frame = CGRectMake(self.frame.size.width-DELETE_VIEW_WIDTH, 0, DELETE_VIEW_WIDTH, self.frame.size.height);
        self.isShow = YES;
    }];
}
/**
 *  右滑事件
 *
 *  @param rightSwipe 右滑手势对象
 */
- (void)rightSwipeAction:(UISwipeGestureRecognizer*)rightSwipe {
    [self placeDeleteViewWithAnimation:YES];
}
/**
 *  删除事件
 */
- (void)deleteAction {
    NSLog(@"is a deleta aciton!");
    
    if ([self.deleteDelegate respondsToSelector:@selector(deleteAction:)]) {
        [self.deleteDelegate deleteAction:self];
    }
}

/**
 *  归位
 *
 *  @param animation 是否动画
 */
- (void)placeDeleteViewWithAnimation:(BOOL)animation {
    UIImageView* deleteImg = [self getDeleteImageView];
    double duration;
    if (animation) {
        duration = 0.3f;
    }else {
        duration = 0.0f;
    }
    [UIView animateWithDuration:duration animations:^{
        deleteImg.frame = CGRectMake(self.frame.size.width, 0, DELETE_VIEW_WIDTH, self.frame.size.height);
        self.isShow = NO;
    }];
}

/**
 *  获取父视图
 *
 *  @return 父视图
 */
- (UITableView*)getSuperView {
    UITableView *tableView;
    float Version=[[[UIDevice currentDevice] systemVersion] floatValue];
    if(Version>=7.0)
    {
        tableView = (UITableView *)self.superview.superview;
    }
    else
    {
        tableView=(UITableView *)self.superview;
    }
    return tableView;
}

@end
