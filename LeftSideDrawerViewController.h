//
//  LeftSideDrawerViewController.h
//  MobileSchool
//
//  Created by Molly on 16/1/30.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"

@protocol leftSideDrawerValueDelegate
- (void)passToContacts:(NSString* )value;
@end

@interface LeftSideDrawerViewController : UIViewController
@property(nonatomic,strong)NSArray* leftMenuData;
@property(nonatomic,strong)NSArray* imgData;
//@property(nonatomic,strong)MMDrawerController* drawController;


@end
