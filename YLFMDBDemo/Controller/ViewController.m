//
//  ViewController.m
//  YLFMDBDemo
//
//  Created by yongliangP on 16/8/29.
//  Copyright © 2016年 yongliangP. All rights reserved.
//

#import "ViewController.h"
#import "HttpRequestTool.h"
#import "BookCell.h"
#import "DatabaseManager.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *bookArray;

@end

@implementation ViewController


-(NSMutableArray *)bookArray
{
    if (!_bookArray)
    {
        _bookArray = [NSMutableArray array];
    }
    
    return _bookArray;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpUI];
}


-(void)setUpUI
{
    
    if ([HttpRequestTool isNetWorkReachability])
    {
        [[HttpRequestTool shareTool] getWihtUrl:@"https://api.douban.com/v2/book/search?q=s" params:nil success:^(NSDictionary *response)
         {
             [self parseBookDataWithData:response];
             
         } failure:^(NSError *err)
         {
             
         }];
        
    }else
    {
        self.bookArray = [[[DatabaseManager databaseManager]queryAllObjectsFromDatabaseWithClass:[Book class]] mutableCopy];
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource&UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.bookArray.count;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BookCell * cell = [BookCell cellBookCellWithTableView:tableView];
    
    cell.book = self.bookArray[indexPath.row];
    
    return cell;
    
}



/**解析和封装数据模型 */
- (void)parseBookDataWithData:(NSDictionary *)response
{
    //1清空旧数据
    [[DatabaseManager databaseManager] deleteAllObjectsFromDatabaseWithClass:[Book class]];
    
    //2.封装数据模型
    NSArray *jsonArr = response[@"books"];
    
    for (NSDictionary *dic in jsonArr)
    {
        Book *book = [[Book alloc] init];
        
        [book setValuesForKeysWithDictionary:dic];
        
        //插入数据到数据库
        [[DatabaseManager databaseManager] insertObjectToDatabaseWithObject:book];
        
        //添加到数据源
        [self.bookArray addObject:book];
        
    }
    
    //3.刷新界面
    [self.tableView reloadData];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
