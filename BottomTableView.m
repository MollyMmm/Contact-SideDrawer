//
//  BottomTableView.m
//  MobileSchool
//
//  Created by Molly on 16/1/29.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "BottomTableView.h"

@implementation BottomTableView
+ (BottomTableView *)instanceView
{
    BottomTableView *bottomTableView = [[NSBundle mainBundle] loadNibNamed:@"BottomTableView" owner:nil options:nil][0];
    
    return bottomTableView;
}
- (void)initData{
    
    _bottomTableView.dataSource = self;
    _bottomTableView.delegate = self;

    _bottomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _bottomTableView.tableFooterView = [[UIView alloc] init];
    
    _bottomTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
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
    
    [cell.imageView  setImage:[UIImage imageNamed:@"qunmemberaction"]];
    cell.textLabel.text = [[_bottomTableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_bottomTableData objectAtIndex:section] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [_indexData count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView* indexView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    [indexView setBackgroundColor:[UIColor colorWithRed:247/255.0 green:247/255.0 blue:248/255.0 alpha:1]];
    UILabel* indexLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, kScreenWidth, 12)];
    indexLbl.text = [_indexData objectAtIndex:section];
    [indexView addSubview:indexLbl];
    
    return indexView;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.f;
}
//每个section 的title
- (UIView *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_indexData objectAtIndex:section];
}
//返回索引栏数据
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return _indexData;
}
//建立索引栏和section的关联
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    NSInteger section = [_indexData indexOfObject:title];
    return section;
}
#pragma mark - public
@end
