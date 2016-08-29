//
//  BookCell.h
//  YLFMDBDemo
//
//  Created by yongliangP on 16/8/29.
//  Copyright © 2016年 yongliangP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"
@interface BookCell : UITableViewCell

@property (nonatomic, strong) Book *book;

+(instancetype)cellBookCellWithTableView:(UITableView*)tableView;

@end
