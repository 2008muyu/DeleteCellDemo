//
//  UITableViewCell+Delete.h
//  DeleteCellDemo
//
//  Created by mby on 15/5/22.
//  Copyright (c) 2015年 M3. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DELETE_VIEW_WIDTH 80.0f

@protocol DeleteCellDelegate <NSObject>
/**
 *  代理-删除方法
 *
 *  @param cell 当前cell
 */
- (void)deleteAction:(UITableViewCell*)cell;

@end

@interface UITableViewCell (Delete)

/**
 *  是否开启delete
 *
 *  @param enableDelete 是否开启
 */
- (void)enableDeleteMethod:(BOOL)enableDelete;

/**
 *  归位
 *
 *  @param animation 是否动画
 */
- (void)placeDeleteViewWithAnimation:(BOOL)animation;

/**
 *  获取删除imageview
 *
 *  @return 删除imageview
 */
- (UIImageView*)getDeleteImageView;

/**
 *  代理对象
 */
@property (nonatomic, weak) id <DeleteCellDelegate>deleteDelegate;

@property (nonatomic, assign) BOOL isShow;

@end
