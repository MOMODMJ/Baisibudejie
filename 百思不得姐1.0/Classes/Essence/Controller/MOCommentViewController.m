//
//  MOCommentViewController.m
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/5/12.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "MOCommentViewController.h"
#import "MOTopicCell.h"
#import "MOEssenceModel.h"
#import "MOCommentModel.h"
#import "MOCommentCell.h"


@interface MOCommentViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;


@property (weak, nonatomic) IBOutlet UITableView *tableViewComment;

/** 最热评论 */
@property (nonatomic, strong) NSArray *hotComments;
/** 最新评论 */
@property (nonatomic, strong) NSMutableArray *latestComments;
/*页数*/
@property (nonatomic, assign) NSInteger page;

@end

static NSString * const MOCommentId = @"comment";
@implementation MOCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //控制器View的基本设置
    [self setupBasic];
    
    //tableView的顶部设置
    [self setupHeader];
    
    
    [self setupRefresh];

    
   
}
#pragma mark - ---刷新，加载，顶部设置，tableview基本设置

- (void)setupRefresh{

   
   /******  下拉刷新*******/
    self.tableViewComment.header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
    [self.tableViewComment.header beginRefreshing];
    
    /***** 上拉加载 ******/
    self.tableViewComment.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
    self.tableViewComment.footer.hidden = YES;//隐藏footer
    
}
#pragma mark -  不懂？ lastObject?-------------------------?????????????
- (void)loadMoreComments{
    
    // 结束之前的所有请求
    [[AFHTTPSessionManager manager].tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 页码
    NSInteger page = self.page + 1;
    
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"page"] = @(page);
    MOCommentModel *cmt = [self.latestComments lastObject];//?????????????
    params[@"lastcid"] = cmt.ID;
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // 如果没有数据，因服务器返回数据类型变化，按需增加此判断。以防为空后崩
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            self.tableViewComment.footer.hidden = YES;
            return;
        }
        
        // 最新评论
        NSArray *newComments = [MOCommentModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.latestComments addObjectsFromArray:newComments];
        
        // 保存页码
        self.page = page;
        
        // 刷新数据
        [self.tableViewComment reloadData];
        
        // 控制footer的状态
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComments.count >= total) { // 全部加载完毕
            self.tableViewComment.footer.hidden = YES;
        } else {
            // 结束刷新状态
            [self.tableViewComment.footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableViewComment.footer endRefreshing];
    }];
}

- (void)loadNewComments{
    
    //结束之前的所有请求，重新开始，避免浪费性能以及冲突
    [[AFHTTPSessionManager manager].tasks makeObjectsPerformSelector:@selector(cancel)];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"hot"] = @"1";
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php"  parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        

        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            [self.tableViewComment.header endRefreshing];
            return;
        } // 说明没有评论数据
        
        self.hotComments = [MOCommentModel objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        self.latestComments = [MOCommentModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
       
        // 页码
        self.page = 1;
        //刷新数据
        [self.tableViewComment reloadData];
        
        // 控制footer的状态
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComments.count >= total) { // 全部加载完毕
            self.tableViewComment.footer.hidden = YES;
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableViewComment.header endRefreshing];
    }];
    
}

- (void)setupHeader{
    
    //设置header
    UIView *header = [[UIView alloc]init];
    header.height = self.topic.cellHeight + MOTopicCellMargin;
    
    //添加cell
    MOTopicCell *cell = [MOTopicCell cell];
    cell.topic = self.topic;
    cell.size = CGSizeMake(MAINSCREENWIDTH, self.topic.cellHeight);
    [header addSubview:cell];
    
//    self.tableViewComment.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
    
    //设置header
    self.tableViewComment.tableHeaderView = header;
    
}

- (void)setupBasic{
    
    self.title = @"评论";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"comment_nav_item_share_icon" highImage:@"comment_nav_item_share_icon_click" target:nil action:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.tableViewComment.backgroundColor = MOGlobalBg;
   
    self.tableViewComment.estimatedRowHeight = 44;
    self.tableViewComment.rowHeight = UITableViewAutomaticDimension;
    //注册xib
      [self.tableViewComment registerNib:[UINib nibWithNibName:NSStringFromClass([MOCommentCell class]) bundle:nil] forCellReuseIdentifier:MOCommentId];
}

#pragma  mark - ---- keyboardWillChangeFrame----

//[UIKeyboard...UserInfoKey]键盘出现时，将原来内容向上顶起的方法--
- (void)keyboardWillChangeFrame: (NSNotification *)note{
    //键盘显示/隐藏完毕的frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //修改底部约束
    self.bottomSpace.constant = MAINSCREENHEIGHT - frame.origin.y;
    //动画时间
    CGFloat duration = [note.userInfo [UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    //动画
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];//必要时，强制布局
    }];

}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - <UITableViewDataSource>

//此方法？？
- (NSArray *)commentsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.hotComments.count ? self.hotComments : self.latestComments;
    }
    return self.latestComments;
}

- (MOCommentModel *)commentInIndexPath:(NSIndexPath *)indexPath
{
    return [self commentsInSection:indexPath.section][indexPath.row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger hotCount = self.hotComments.count;
    NSInteger latestCount = self.latestComments.count;
    
    if (hotCount) return 2; // 有"最热评论" + "最新评论" 2组
    if (latestCount) return 1; // 有"最新评论" 1 组
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger hotCount = self.hotComments.count;
    NSInteger latestCount = self.latestComments.count;
    if (section == 0) {
        return hotCount ? hotCount : latestCount;
    }
    
    return latestCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MOCommentCell *cell = [_tableViewComment dequeueReusableCellWithIdentifier:MOCommentId];
    //    if (cell == nil) {
    //        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"comment"];
    //    }
    
    
    cell.comment = [self commentInIndexPath:indexPath];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSInteger hotCount = self.hotComments.count;
    
    if (section == 0) {
        return hotCount? @"最热评论": @"最新评论";
    }
    return  @"最新评论";
}


#pragma mark - ----tableView 代理方法--UIMenuController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
    }else{
     
        MOCommentCell *cell = (MOCommentCell *) [_tableViewComment cellForRowAtIndexPath:indexPath];
    
        UIMenuItem *ding = [[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(ding:)];
        UIMenuItem *replay = [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(replay:)];
        UIMenuItem *report = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(report:)];
        menu.menuItems = @[ding, replay, report];
    
        [cell becomeFirstResponder];
        CGRect rect = CGRectMake(0, 0.5*cell.height, 0.5*cell.width, 0.5*cell.height);
        [menu setTargetRect:rect inView:cell];
        [menu setMenuVisible:YES animated:YES];
    }
    
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
    [[UIMenuController sharedMenuController]setMenuVisible:NO animated:YES];
    
}


- (void)ding:(UIMenuController *)menu
{
    NSIndexPath *indexPath = [self.tableViewComment indexPathForSelectedRow];
    NSLog(@"%s %@ %zd", __func__ , menu, indexPath.row);
}

- (void)replay:(UIMenuController *)menu
{
    NSIndexPath *indexPath = [_tableViewComment indexPathForSelectedRow];
    NSLog(@"%s %@ %@", __func__ , menu, [self commentInIndexPath:indexPath].content);
}

- (void)report:(UIMenuController *)menu
{
    NSLog(@"%s %@", __func__ , menu);
}




//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 60;
//}


//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    
//    NSInteger hotCount = self.hotComments.count;
//    NSInteger latestCount = self.latestComments.count;
//    if (hotCount) {
//        return 2;
//    }else if(latestCount){
//        return 1;
//    }
//    return  0;
//}
//
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSInteger hotCount = self.hotComments.count;
//    NSInteger latestCount = self.latestComments.count;
//    if (section == 0 ) {
//      return   hotCount ? hotCount : latestCount;
//    }
//    return latestCount;
//}
//


@end
