//
//  BookCell.m
//  YLFMDBDemo
//
//  Created by yongliangP on 16/8/29.
//  Copyright © 2016年 yongliangP. All rights reserved.
//

#import "BookCell.h"
#import "UIImageView+WebCache.h"
@interface BookCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation BookCell


+(instancetype)cellBookCellWithTableView:(UITableView*)tableView
{
    //直接使用类名作为唯一标识
    NSString *cellName=NSStringFromClass([self class]);
    
    UINib *nib=[UINib nibWithNibName:NSStringFromClass([self class])bundle:nil];
    //使用注册机制 xib文件不需要再去加上重用标识了
    [tableView registerNib:nib forCellReuseIdentifier:cellName];
    //1.如果有给你返回一个可重用的cell
    //2.如果没有自动创建一个给你
    return [tableView dequeueReusableCellWithIdentifier:cellName];
}

-(void)setBook:(Book *)book
{
    _book = book;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:book.large]];
    self.titleLabel.text = book.title;
    self.desLabel.text = book.publisher;

}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
