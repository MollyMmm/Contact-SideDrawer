//
//  ContactsViewController.m
//  MobileSchool
//
//  Created by Molly on 16/1/29.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "ContactsViewController.h"
#import "BottomTableView.h"
#import "MMDrawerController.h"
#import "LeftSideDrawerViewController.h"
#import "NavigationViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "TabbarViewController.h"

#import "NetworkingManager.h"
#import "GetFriendListOperator.h"
#import "UserModel.h"

@interface ContactsViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIGestureRecognizerDelegate,leftSideDrawerValueDelegate>{
    UISearchBar* mSearchBar;
    int groupIndex;
    }
@property (weak, nonatomic) IBOutlet UITableView *topTableView;
@property (nonatomic,strong)BottomTableView* bottomTabelView;
@property(nonatomic,strong)UILabel* groupNameLbl;
@property(nonatomic,strong)NSArray* topTableData;
@property(nonatomic,strong)NSArray* bottomTableData;
@property(nonatomic,strong)NSArray* indexData;
@property(nonatomic,strong)NSArray* leftMenuData;

@property (strong, nonatomic) NSArray *friendArr;

@property(nonatomic,strong)MMDrawerController* drawController;
@property(nonatomic,strong)UIWindow* window;
@end

@implementation ContactsViewController

- (BottomTableView*)bottomTabelView{
    if (!_bottomTabelView) {
        _bottomTabelView = [BottomTableView instanceView];
        _bottomTabelView.bottomTableData = _bottomTableData;
        _bottomTabelView.indexData = _indexData;
    }
    return _bottomTabelView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
    
    _topTableData = [[NSArray alloc] init];
    _bottomTableData = [[NSArray alloc] init];
    _indexData = [[NSArray alloc] init];
    _leftMenuData = [[NSArray alloc] init];
    _topTableData = @[@[@"新的朋友(0)",@"qunmemberaction"],@[@"我的粉丝(0)",@"qunweiboaction"],@[@"我的群(0)",@"qunmemberaction"]];
    _bottomTableData = @[@[@"啊1",@"啊2"],@[@"波波",@"菠菜"],@[@"赫赫"],@[@"校内外助手",@"新人",@"小人",@"昕人"]];
    _indexData = @[@"A",@"B",@"H",@"X"];
    _leftMenuData = @[@"全部好友(2)",@"家人(0)",@"朋友(0)",@"同学(0)",@"未分组(2)"];
    
    _topTableView.dataSource = self;
    _topTableView.delegate = self;
    
    LeftSideDrawerViewController* leftMenuController = [[LeftSideDrawerViewController alloc] init];
    leftMenuController.leftMenuData = _leftMenuData;
    leftMenuController.imgData = @[@"allFriend",@"jiaren",@"pengyou",@"tongxue",@"weifenzu"];
//    self.drawController = [[MMDrawerController alloc] initWithCenterViewController:self.navigationController leftDrawerViewController:leftMenuController];
    NavigationViewController* leftController = [[NavigationViewController alloc] initWithRootViewController:leftMenuController];
    self.drawController = [[MMDrawerController alloc] initWithCenterViewController:[[NavigationViewController alloc] initWithRootViewController:self] leftDrawerViewController:leftController];
    [_drawController setShowsShadow:NO];
    [_drawController setRestorationIdentifier:@"MMDrawer"];
    [_drawController setMaximumLeftDrawerWidth:kScreenWidth*4/5];
    [_drawController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [_drawController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIColor * tintColor = [UIColor colorWithRed:29.0/255.0
                                          green:173.0/255.0
                                           blue:234.0/255.0
                                          alpha:1.0];
    [_window setTintColor:tintColor];
    _window.rootViewController = _drawController;
    [_window makeKeyAndVisible];
   
    //导航栏按钮
    UIBarButtonItem* rightBarBtnItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"addBtn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(pressAddBtn:)];
    self.navigationItem.rightBarButtonItem  = rightBarBtnItem;
    UIBarButtonItem* leftBarBtnItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"leftBtn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(pressCancleBtn:)];
    self.navigationItem.leftBarButtonItem = leftBarBtnItem;
 
    //上部分
    mSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    [mSearchBar setPlaceholder:@"搜索"];
    [mSearchBar setBackgroundColor:[UIColor clearColor]];
    mSearchBar.delegate = self;
    UIView* searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    [searchView addSubview:mSearchBar];
    
    _topTableView.tableHeaderView = searchView;
    _topTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //下部分
    UIView* bottomHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    [bottomHeaderView setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
    UIButton* selectGroupBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, 5, 30, 30)];
    [selectGroupBtn setImage:[UIImage imageNamed:@"chooseOthers"] forState:UIControlStateNormal];
    [selectGroupBtn addTarget:self action:@selector(pressSelectGroupBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomHeaderView addSubview:selectGroupBtn];
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(selectGroupBtn.frame.origin.x+selectGroupBtn.frame.size.width + 8 ,10, 1, 20)];
    [lineView setBackgroundColor:[UIColor grayColor]];
    [bottomHeaderView addSubview:lineView];
    CGFloat groupNameLblX = lineView.frame.origin.x + lineView.frame.size.width + 8;
    _groupNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(groupNameLblX, 10, kScreenWidth-groupNameLblX, 20)];
    _groupNameLbl.text = [_leftMenuData objectAtIndex:groupIndex];
    [bottomHeaderView addSubview:_groupNameLbl];
    _topTableView.tableFooterView = self.bottomTabelView;
    [_topTableView.tableFooterView addSubview:bottomHeaderView];
    _topTableView.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight);
   _bottomTabelView.frame = CGRectMake(0,40, kScreenWidth,kScreenHeight- 40 - 60*3);
    [_bottomTabelView initData];
    
    //侧滑返回(系统自带)
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;      // 手势有效设置为YES  无效为NO
//        self.navigationController.interactivePopGestureRecognizer.delegate = self;    // 手势的代理设置为self
//    }

}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* cellIdentifier = @"cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellStyleDefault;
    
    NSString* imgName = [[_topTableData objectAtIndex:indexPath.row] objectAtIndex:1];
    [cell.imageView  setImage:[UIImage imageNamed:imgName]];
    cell.textLabel.text = [[_topTableData objectAtIndex:indexPath.row] objectAtIndex:0];
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [_topTableData count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}
#pragma mark - searchBar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
}

#pragma mark - leftDrawerDelegate
- (void)passToContacts:(NSString*)value{
    groupIndex = [value intValue];
    [self viewDidLoad];

    //[self.bottomTabelView initData];
    //重新请求好友通讯录,并刷新tableview--------------------
}
#pragma mark - public
- (void)pressSelectGroupBtn:(id)sender{
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
- (void)pressAddBtn:(id)sender{

}
- (void)pressCancleBtn:(id)sender{
    TabbarViewController* tabbarController =  [[TabbarViewController alloc]init];
    tabbarController.selectedIndex = 4;
    self.window.rootViewController = tabbarController;
    
    [self.window makeKeyAndVisible];

}
/**
 *  请求好友列表
 *  
 */
//
- (void)requestFriendList{
    
    GetFriendListOperator *friendListOperator = [[GetFriendListOperator alloc] initWithParamsDic:@{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]}];
    NetworkingManager *manager = [NetworkingManager sharedInstance];
    
    [manager asyncTaskWithOperator:friendListOperator withSuccessCallBack:^(BaseModel *model) {
        
        _friendArr = [[NSArray alloc] init];
        _friendArr = friendListOperator.friendArr;
        
        [_bottomTabelView initData];
        
    } andFaildCallBack:^(id response) {
        
    }];
}
@end
