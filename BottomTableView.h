//
//  BottomTableView.h
//  MobileSchool
//
//  Created by Molly on 16/1/29.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomTableView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *bottomTableView;
@property(nonatomic,strong)UILabel* groupNameLbl;;
@property(nonatomic,strong)NSArray* bottomTableData;
@property(nonatomic,strong)NSArray* indexData;
- (void)initData;
+ (BottomTableView *)instanceView;
@end
