//
//  MultiFunctionCell.m
//  XZMultiFunctionCell
//
//  Created by xiazer on 15/1/5.
//  Copyright (c) 2015年 xiazer. All rights reserved.
//

#import "MultiFunctionCell.h"
//#import "YXCellItem.h"
//定义屏幕高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
//定义屏幕宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define TASK_STR @"安排"

#define MAX_CELL_WIDTH  (60.f)

//#define CellMenuWidth 70.0


float CellMenuWidth = 70.0f;

NSUInteger DeviceSystemMajorVersion()
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}
#define IsSystemVersionOverSeven (DeviceSystemMajorVersion() >= 7.0)


@interface MultiFunctionCell () <UIGestureRecognizerDelegate>
@property (nonatomic, assign) float startX;
@property (nonatomic, assign) float cellStartX;
@property (nonatomic, strong) UIView *baseCellView;
@property (nonatomic, assign) float leftMargin;
@property (nonatomic, assign) float rightMargin;
@property (nonatomic, assign) BOOL isMoving;
@property (nonatomic, strong) UITableView *containTableView;

@property (nonatomic, retain) NSDictionary *tabNameDict;
@end

@implementation MultiFunctionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    unsigned long totalMenuCount = ((leftUtilityButtons != nil ? leftUtilityButtons.count : 0) + ((rightUtilityButtons != nil) ? rightUtilityButtons.count : 0));
    
    if(totalMenuCount < 3){
        CellMenuWidth = ScreenWidth * rightUtilityButtons.count / 5 / totalMenuCount;
    }else{
        CellMenuWidth = ScreenWidth * 4 / 5 / totalMenuCount;
    }
    
    CellMenuWidth = MIN(CellMenuWidth, MAX_CELL_WIDTH);
    
    if (self) {

        self.cellHeight = containingTableView.rowHeight;
        self.containTableView = containingTableView;

        [self initBaseView];
        
        self.leftMenus = [NSArray arrayWithArray:leftUtilityButtons];
        self.rightMenus = [NSArray arrayWithArray:rightUtilityButtons];
        
        [self addCellView];

        _swipeDisEnable = (totalMenuCount == 0);
        
        // 定义其辅助样式
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setRightMenus:(NSArray *)rightMenus leftMenus:(NSArray*)leftMenus{
    unsigned long totalMenuCount = ((leftMenus != nil ? leftMenus.count : 0) + ((rightMenus != nil) ? rightMenus.count : 0));

    if (totalMenuCount == 0) {
        CellMenuWidth = 0;
        return;
    }else if(totalMenuCount < 3){
        CellMenuWidth = ScreenWidth * rightMenus.count / 5 / totalMenuCount;
    }else{
        CellMenuWidth = ScreenWidth * 4 / 5 / totalMenuCount;
    }
    
    CellMenuWidth = MIN(CellMenuWidth, MAX_CELL_WIDTH);
    
    [self.rightMenuView removeFromSuperview];
    [self.leftMenuView removeFromSuperview];
    [self.cellContentView removeFromSuperview];

    self.rightMenus = [NSArray arrayWithArray:rightMenus];
    self.leftMenus = [NSArray arrayWithArray:leftMenus];

    self.leftMargin = 10+self.leftMenus.count*CellMenuWidth; //forbid the left slide
    self.rightMargin = 0-10-self.rightMenus.count*CellMenuWidth;

    [self.baseCellView addSubview:self.cellContentView];
}

- (void)initBaseView{
    self.baseCellView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.cellHeight)];
    self.baseCellView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.baseCellView];
}

- (void)addCellView{
    self.leftMargin = 10+self.leftMenus.count*CellMenuWidth; //forbid the left slide
    self.rightMargin = 0-10-self.rightMenus.count*CellMenuWidth;

    self.cellContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.cellHeight)];
    self.cellContentView.backgroundColor = [UIColor whiteColor];///
    [self.baseCellView addSubview:self.cellContentView];

    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cellPanGes:)];
    panGes.delegate = self;
    panGes.delaysTouchesBegan = YES;
    panGes.cancelsTouchesInView = NO;
    [self.cellContentView addGestureRecognizer:panGes];
}

- (void)setLeftMenus:(NSArray *)leftMenus{
    _leftMenus = leftMenus;

    if (_leftMenus.count > 0) {
        self.leftMenuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CellMenuWidth*_leftMenus.count, self.cellHeight)];
        self.leftMenuView.backgroundColor = [UIColor clearColor];
        [self.baseCellView addSubview:self.leftMenuView];

        NSArray *colorArray = [[NSArray alloc] initWithObjects:[UIColor colorWithRed:217.f/255.f green:53.f/255.f blue:31.f/255.f alpha:1.f], [UIColor colorWithRed:16.f/255.f green:181./255.f blue:101./255.f alpha:1.f], [UIColor colorWithRed:245.f/255.f green:174./255.f blue:32./255.f alpha:1.f], nil];
        
        NSInteger j = 0;
        UIColor *bgColor;
        for (NSInteger i = 0; i < _leftMenus.count; i++) {
            CGRect frame = CGRectMake(CellMenuWidth*i, 0, CellMenuWidth, self.cellHeight);
            if (j >= colorArray.count) {
                j = 0;
            }
            bgColor = [colorArray objectAtIndex:j];
            j++;
            UIButton *menuBtn = [self createBtn:frame title:_leftMenus[i] titleColor:[UIColor whiteColor] bgcolor:bgColor menuTag:100+i];
            menuBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:14];
            [self.leftMenuView addSubview:menuBtn];
        }
    }
}

- (void)setRightMenus:(NSArray *)rightMenus{
    _rightMenus = rightMenus;
    
    if (_rightMenus.count > 0) {
        self.rightMenuView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth-CellMenuWidth*_rightMenus.count, 0, CellMenuWidth*_rightMenus.count, self.cellHeight)];
        self.rightMenuView.backgroundColor = [UIColor clearColor];
        [self.baseCellView addSubview:self.rightMenuView];
//        NSMutableArray *colorArray = [NSMutableArray array];
        _tabNameDict = @{CELL_ITEM_CALENDAR:[UIColor colorWithRed:199.f/255.f green:200.f/255.f blue:205.f/255.f alpha:1.f],
                         CELL_ITEM_TAG:[UIColor colorWithRed:66.f/255.f green:179./255.f blue:61./255.f alpha:1.f],
                         CELL_ITEM_DOCUMENT:[UIColor colorWithRed:255.f/255.f green:175.f/255.f blue:1.f/255.f alpha:1.f],
                         CELL_ITEM_FINISH:[UIColor colorWithRed:255.f/255.f green:58./255.f blue:49./255.f alpha:1.f],
                         CELL_ITEM_CANCEL:[UIColor redColor],
                         CELL_ITEM_MORE:[UIColor orangeColor]};

        [_rightMenus enumerateObjectsUsingBlock:^(NSString *tabName, NSUInteger idx, BOOL *stop) {
            CGRect frame = CGRectMake(CellMenuWidth*idx, 0, CellMenuWidth, self.cellHeight);
            
            UIColor *color = [_tabNameDict objectForKey:tabName];
            
            if (!color) {
                color = [UIColor colorWithRed:199.0/255.0f green:199.0/255.0f blue:205.0f/255.f alpha:1];
            }
            
            UIButton *menuBtn = [self createBtn:frame title:tabName titleColor:[UIColor whiteColor] bgcolor:color menuTag:200+idx];
            menuBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:14];
            [self.rightMenuView addSubview:menuBtn];
        }];


//        NSInteger j = 0;
//        UIColor *bgColor;
//        for (NSInteger i = 0; i < _rightMenus.count; i++) {
//            CGRect frame = CGRectMake(CellMenuWidth*i, 0, CellMenuWidth, self.cellHeight);
////            if (j >= colorArray.count) {
////                j = 0;
////            }
////            bgColor = [colorArray objectAtIndex:j];
//            bgColor = [_tabNameDict objectForKey:_rightMenus[i]];
////            j++;
//            UIButton *menuBtn = [self createBtn:frame title:_rightMenus[i] titleColor:[UIColor whiteColor] bgcolor:bgColor menuTag:200+i];
//            menuBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:14];
//            [self.rightMenuView addSubview:menuBtn];
//        }


    }
}

#pragma mark * UIPanGestureRecognizer delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self];
        return fabs(translation.x) > fabs(translation.y);
    }

    return YES;
}

- (void)cellPanGes:(UIPanGestureRecognizer *)panGes{
    
#if DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
    
    if (self.selected) {
        [self setSelected:NO animated:NO];
    }
    
    CGPoint pointer = [panGes locationInView:self.contentView];
    
    switch (panGes.state) {
        case UIGestureRecognizerStateBegan:
        {
//            self.containTableView.scrollEnabled = NO;
            self.containTableView.allowsSelection = NO;
            
            if (!(self.isMoving || self.swipeDisEnable)) {
                self.startX = pointer.x;
                self.cellStartX = self.cellContentView.frame.origin.x;
            }

            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            if (!(self.isMoving || self.swipeDisEnable)) {
                if (self.cellActionDelegate && [self.cellActionDelegate respondsToSelector:@selector(tableMenuWillHideInCell:)]) {
                    [self.cellActionDelegate tableMenuWillShowInCell:self];
                }
                [self cellViewMoveToX:self.cellStartX + pointer.x - self.startX];
            }

            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
//            self.containTableView.scrollEnabled = YES;
            self.containTableView.allowsSelection = YES;
            
            if (!(self.isMoving || self.swipeDisEnable)) {
                [self resetCellContentView];
            }
        }
        default:
            break;
    }
}

- (void)cellViewMoveToX:(float)x{
    if (self.containTableView.editing == NO) {
//        self.selectedBackgroundView = nil;
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        NSLog(@"nowX-->>%f",x);
        if (x >= self.leftMargin) {
//            self.cellContentView.frame = CGRectMake(4, 0, ScreenWidth, self.cellHeight); // add for forbid the left slide
            return;
        } else if (x <= self.rightMargin) {
            return;
        }
        self.cellContentView.frame = CGRectMake(x, 0, ScreenWidth, self.cellHeight);
    }

}

- (void)resetCellContentView{
    float cellX = self.cellContentView.frame.origin.x;
    
    __weak typeof (self) weakSelf = self;
    
    if (cellX <= 10 && cellX >= -10) {
        self.isMoving = YES;
        if (IsSystemVersionOverSeven) {
            [UIView animateWithDuration:0.4f delay:0.0f usingSpringWithDamping:1.0f initialSpringVelocity:0.0f options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                weakSelf.cellContentView.frame = CGRectMake(0, 0, ScreenWidth, weakSelf.cellHeight);
            } completion:^(BOOL finished) {
                weakSelf.isMoving = NO;
                weakSelf.cellStauts = MultiFunctionCellTypeForNormal;
                [weakSelf.cellActionDelegate tableMenuDidHideInCell:weakSelf];
            }];
        } else {
            [UIView animateWithDuration:0.4 animations:^{
                weakSelf.cellContentView.frame = CGRectMake(0, 0, ScreenWidth, weakSelf.cellHeight);
            } completion:^(BOOL finished) {
                weakSelf.isMoving = NO;
                weakSelf.cellStauts = MultiFunctionCellTypeForNormal;
                [weakSelf.cellActionDelegate tableMenuDidHideInCell:weakSelf];
            }];
        }
    } else if ( cellX > 10) {
        self.isMoving = YES;
        if (IsSystemVersionOverSeven) {
            [UIView animateWithDuration:0.4f delay:0.0f usingSpringWithDamping:1.0f initialSpringVelocity:0.0f options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                weakSelf.cellContentView.frame = CGRectMake(weakSelf.leftMenus.count*CellMenuWidth, 0, ScreenWidth, weakSelf.cellHeight);
            } completion:^(BOOL finished) {
                weakSelf.isMoving = NO;
                weakSelf.cellStauts = MultiFunctionCellTypeForLeftMenu;
                [weakSelf.cellActionDelegate tableMenuDidShowInCell:weakSelf];
            }];
        } else {
            [UIView animateWithDuration:0.4 animations:^{
                weakSelf.cellContentView.frame = CGRectMake(weakSelf.leftMenus.count*CellMenuWidth, 0, ScreenWidth, weakSelf.cellHeight);
            } completion:^(BOOL finished) {
                weakSelf.isMoving = NO;
                weakSelf.cellStauts = MultiFunctionCellTypeForLeftMenu;
                [weakSelf.cellActionDelegate tableMenuDidShowInCell:weakSelf];
            }];
        }
    } else if (cellX < -10) {

//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_EDITBUTTON_HIDE object:nil];

        self.isMoving = YES;
        if (IsSystemVersionOverSeven) {
            [UIView animateWithDuration:0.4f delay:0.0f usingSpringWithDamping:1.0f initialSpringVelocity:0.0f options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                weakSelf.cellContentView.frame = CGRectMake(0.0-weakSelf.rightMenus.count*CellMenuWidth, 0, ScreenWidth, weakSelf.cellHeight);
            } completion:^(BOOL finished) {
                weakSelf.isMoving = NO;
                weakSelf.cellStauts = MultiFunctionCellTypeForRightMenu;
                [weakSelf.cellActionDelegate tableMenuDidShowInCell:weakSelf];
            }];
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.cellContentView.frame = CGRectMake(0.0 - weakSelf.rightMenus.count * CellMenuWidth, 0, ScreenWidth, weakSelf.cellHeight);
            } completion:^(BOOL finished) {
                weakSelf.isMoving = NO;
                weakSelf.cellStauts = MultiFunctionCellTypeForRightMenu;
                [weakSelf.cellActionDelegate tableMenuDidShowInCell:weakSelf];
            }];
        }
    }
}

- (void)setMenuHidden:(BOOL)hidden animated:(BOOL)animated completionHandler:(void (^)(void))completionHandler{

    if (self.selected) {
        [self setSelected:NO animated:NO];
    }
    
    CGRect frame = self.cellContentView.frame;
    
    if (hidden && frame.origin.x != 0) {
        
            __weak typeof (self) this = self;

            if (IsSystemVersionOverSeven) {
                [UIView animateWithDuration:0.4f delay:0.0f usingSpringWithDamping:1.0f initialSpringVelocity:0.0f options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                    [this initCellFrame:0];
                } completion:^(BOOL finished) {
                    [this.cellActionDelegate tableMenuDidHideInCell:self];
                    if (completionHandler) {
                        completionHandler();
                    }
                }];
            } else {
                [UIView animateWithDuration:0.2 animations:^{
                    [this initCellFrame:0];
                } completion:^(BOOL finished) {
                    [this.cellActionDelegate tableMenuDidHideInCell:self];
                    if (completionHandler) {
                        completionHandler();
                    }
                }];
            }
        
    }else{
        if (completionHandler) {
            completionHandler();
        }
    }
}

- (void)initCellFrame:(float)x{
    CGRect frame = self.cellContentView.frame;
    frame.origin.x = x;
    
    self.cellContentView.frame = frame;
}


- (UIButton *)createBtn:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor bgcolor:(UIColor *)bgcolor menuTag:(NSInteger)menuTag{
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = frame;
    [menuBtn setBackgroundColor:bgcolor];
    [menuBtn setTitle:title forState:UIControlStateNormal];
    [menuBtn setTitleColor:titleColor forState:UIControlStateNormal];
    menuBtn.tag = menuTag;
    [menuBtn addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return menuBtn;
}

- (void)menuClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    [self setMenuHidden:YES animated:YES completionHandler:nil];
    
    if (self.cellActionDelegate && [self.cellActionDelegate respondsToSelector:@selector(cellMenuIndex:menuIndexNum:isLeftMenu:)]) {
        if (btn.tag >= 200) {
            [self.cellActionDelegate cellMenuIndex:[self.containTableView indexPathForCell:self] menuIndexNum:btn.tag-200 isLeftMenu:NO];
        } else {
            [self.cellActionDelegate cellMenuIndex:[self.containTableView indexPathForCell:self] menuIndexNum:btn.tag-100 isLeftMenu:YES];
        }
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
