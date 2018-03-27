//
//  WebChatTableViewController.h
//  WebChat
//
//  Created by Jack on 2017/12/13.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebChatMessageInputBar.h"
@class CentreView;

@interface WebChatTableViewController : UIViewController
//数据模型
@property(nonatomic,strong)WebChatModel           *model;
//数据源
@property(nonatomic,retain)NSMutableArray         *dataArray;
//tabView
@property(nonatomic,strong)UITableView            *tableView;
//centreView
@property(nonatomic,strong)CentreView             *centreView;
//inputBar
@property(nonatomic,strong)WebChatMessageInputBar *inputBar;
@end
