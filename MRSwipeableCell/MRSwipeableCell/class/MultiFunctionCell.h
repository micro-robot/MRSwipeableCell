//
//  MultiFunctionCell.h
//  XZMultiFunctionCell
//
//  Created by xiazer on 15/1/5.
//  Copyright (c) 2015年 xiazer. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CELL_ITEM_CALENDAR @"安排"
#define CELL_ITEM_TAG @"标记"
#define CELL_ITEM_DOCUMENT @"收藏"
#define CELL_ITEM_DELETE @"删除"
#define CELL_ITEM_SHARE @"分享"
#define CELL_ITEM_MORE @"更多"

#define CELL_ITEM_FINISH @"完成"
#define CELL_ITEM_CANCEL @"取消"

@class MultiFunctionCell;

typedef NS_ENUM(NSInteger, MultiFunctionCellType) {
    MultiFunctionCellTypeForNormal = 0, // 常见状态，cell没有任何移动
    MultiFunctionCellTypeForLeftMenu = 1, // 左侧menu可见
    MultiFunctionCellTypeForRightMenu = 2, // 右侧menu可见
};


@protocol MultiFunctionCellActionDelegate <NSObject>
- (void)tableMenuDidShowInCell:(MultiFunctionCell *)cell;
- (void)tableMenuWillShowInCell:(MultiFunctionCell *)cell;
- (void)tableMenuDidHideInCell:(MultiFunctionCell *)cell;
- (void)tableMenuWillHideInCell:(MultiFunctionCell *)cell;
- (void)deleteCell:(MultiFunctionCell *)cell;
- (void)cellMenuIndex:(NSIndexPath *)indexPath menuIndexNum:(NSInteger)menuIndexNum isLeftMenu:(BOOL)isLeftMenu;
@end

    
@interface MultiFunctionCell : UITableViewCell <UIScrollViewDelegate>
@property (nonatomic, weak) id<MultiFunctionCellActionDelegate> cellActionDelegate;

@property (nonatomic, strong) NSArray *leftMenus;
@property (nonatomic, strong) NSArray *rightMenus;
@property (nonatomic, assign) float cellHeight;
@property (nonatomic, strong) UIView *cellContentView;
@property (nonatomic, assign) MultiFunctionCellType cellStauts;
@property (nonatomic, strong) UIView *leftMenuView;
@property (nonatomic, strong) UIView *rightMenuView;
@property (nonatomic, assign) BOOL swipeDisEnable;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons;

- (void)setMenuHidden:(BOOL)hidden animated:(BOOL)animated completionHandler:(void (^)(void))completionHandler;

- (void)setRightMenus:(NSArray *)menus leftMenus:(NSArray*)leftMenus;
@end
