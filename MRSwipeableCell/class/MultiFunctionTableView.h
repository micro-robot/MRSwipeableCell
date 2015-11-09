//
//  MultiFunctionTableView.h
//  XZMultiFunctionCell
//
//  Created by xiazer on 15/1/5.
//  Copyright (c) 2015年 xiazer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverLayView.h"
#import "MultiFunctionCell.h"

@protocol MultiFunctionTableViewDelegate <NSObject>
- (void)returnCellMenuIndex:(NSIndexPath *)indexPath menuIndexNum:(NSInteger)menuIndexNum isLeftMenu:(BOOL)isLeftMenu;
- (void)cellWillShowRightMenu;
- (void)cellDidHideRightMenu;
@end

@interface MultiFunctionTableView : UITableView <OverLayViewDelegate,MultiFunctionCellActionDelegate>

@property (nonatomic, weak) id<MultiFunctionTableViewDelegate> multiTableDelegate;
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;
- (void)hideMenuActive:(BOOL)aninated;
@end
