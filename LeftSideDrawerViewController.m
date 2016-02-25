//
//  LeftSideDrawerViewController.m
//  MobileSchool
//
//  Created by Molly on 16/1/30.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LeftSideDrawerViewController.h"
#import "ContactsViewController.h"

@interface LeftSideDrawerViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(retain,nonatomic)id<leftSideDrawerValueDelegate> leftDelegate;
@end

@implementation LeftSideDrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"好友分组列表";
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorInset = UIEdgeInsetsZero;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* cellIdentifier = @"cell";

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSString* imgName = [_imgData objectAtIndex:indexPath.row];
    [cell.imageView setImage:[UIImage imageNamed:imgName]];
    cell.textLabel.text = [_leftMenuData objectAtIndex:indexPath.row];
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_leftMenuData count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    ContactsViewController* contactController = [[ContactsViewController alloc] initWithNibName:@"ContactsViewController" bundle:nil];
    self.leftDelegate = contactController;
    [self.leftDelegate  passToContacts:[NSString  stringWithFormat:@"%ld",(long)indexPath.row]];
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
}

@end
