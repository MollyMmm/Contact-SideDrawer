# Contact-SideDrawer
simple contacts and using MMDrawerController

[MollyMmmm的CSDN](http://blog.csdn.net/Molly1521/article/details/50736349)

前言的废话...可以忽略
自从学会了使用Cocoapod,就欲罢不能了!因为太简单太赞了,不用再把源码粘到工程里了!
参见戴维营博客中的讲解:[Cocoapod 安装以及使用](http://io.diveinedu.com/2015/01/20/CocoaPods使用简介.html)
先上一下效果图,请原谅我手残录的效果不是很理想,大致就是这个意思![contacts](http://img.blog.csdn.net/20160219233133777)

接下来上代码!


#1.通讯录

通讯录主要的就是建立索引栏和section的关联,其次是初始化索引栏数据和每个section的title.关于索引栏数据,如果写接口的小哥人好的话就会直接帮你返回ABCD...如果很不幸,接口小哥不给你返回索引栏数据,那就得自己处理了!(处理方法后续再补上,现在先假设接收到了索引栏数据)

(1.)私有成员
     
     @property(nonatomic,strong)NSArray* bottomTableData;
     @property(nonatomic,strong)NSArray* indexData;
     
(2.)相关函数
		
		//每个section 的title
	- (UIView *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	
	    return [_indexData objectAtIndex:section];
	}
	//返回索引栏数据
	- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
	
	    return _indexData;
	}
	//建立索引栏和section的关联
		 - (NSInteger)tableView:(UITableView *)tableView 	         sectionForSectionIndexTitle:(NSString *)title
					    atIndex:(NSInteger)index{
					    
  	  NSInteger section = [_indexData indexOfObject:title];
  	  return section;
	}

#2.侧滑菜单

(1.)私有成员

	@property (weak, nonatomic) IBOutlet UITableView *topTableView;//新的好友,我的粉丝,我的群
	@property (nonatomic,strong)BottomTableView* bottomTabelView;//下半部分的通讯录
	@property(nonatomic,strong)UILabel* groupNameLbl;
	@property(nonatomic,strong)NSArray* topTableData;
	@property(nonatomic,strong)NSArray* bottomTableData;
	@property(nonatomic,strong)NSArray* indexData;//索引数据,对接接口后根据返回的相应数据进行修改
	@property(nonatomic,strong)NSArray* leftMenuData;//侧滑菜单 

(2.)相关函数
		
		1>.在viewDidLoad中初始化数据
		2>.设置侧滑菜单(使用MMDrawerController)!

	LeftSideDrawerViewController* leftMenuController = [[LeftSideDrawerViewController alloc] init];
		

    leftMenuController.imgData = @[@"allFriend",@"jiaren",@"pengyou",@"tongxue",@"weifenzu"];
	/**
	注意:每个页面要用NavigationViewController包一下.我不是在主页面写的侧滑菜单,而是在模态窗口里写的.这里的参数需要仔细检查,很容易出现错误,如果参数出现错误,界面效果会有问题的,具体的你可以自己试着改动一下,深刻的理解一下.我这里的self仅仅是一个ViewController,所以需要NavigationViewController再包一层.
	*/
    self.drawController = [[MMDrawerController alloc] initWithCenterViewController:[[NavigationViewController alloc] initWithRootViewController:self] leftDrawerViewController:leftController];
    
    [_drawController setShowsShadow:NO];

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

    3>.初始化数据
	
	_topTableData = @[@[@"新的朋友(0)",@"qunmemberaction"],@[@"我的粉丝(0)",@"qunweiboaction"],@[@"我的群(0)",@"qunmemberaction"]];   
	 
	 _bottomTableData = @[@[@"啊1",@"啊2"],@[@"波波",@"菠菜"],@[@"赫赫"],@[@"校内外助手",@"新人",@"小人",@"昕人"]];
    
    _indexData = @[@"A",@"B",@"H",@"X"];
   
    _leftMenuData = @[@"全部好友(2)",@"家人(0)",@"朋友(0)",@"同学(0)",@"未分组(2)"];
    4>.选择左侧菜单中某一项,侧滑菜单关闭并刷新主页面的数据
    a.侧滑菜单.m中
    - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

	    ContactsViewController* contactController = [[ContactsViewController alloc] initWithNibName:@"ContactsViewController" bundle:nil];

		self.leftDelegate = contactController;
  
	    [self.leftDelegate  passToContacts:[NSString  stringWithFormat:@"%ld",(long)indexPath.row]];
  
	    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
	}
	b.主页面.m中
	- (void)passToContacts:(NSString*)value{
	 //重新请求好友通讯录,并刷新tableview
	  groupIndex = [value intValue];
	  [self viewDidLoad];
	}

#3.从主页面返回上一级页面
	//更改window的根视图控制器
	- (void)pressCancleBtn:(id)sender{
	 
	    TabbarViewController* tabbarController =  [[TabbarViewController alloc]init];

	    tabbarController.selectedIndex = 4;
    self.window.rootViewController = tabbarController;
    
	    [self.window makeKeyAndVisible];

	}

#最后的啰嗦
	
	因为是菜鸟,所以希望大家多多提意见,共同进步!最后附代码地址:[MollyMmm的github](https://github.com/MollyMmm/Contact-SideDrawer)
