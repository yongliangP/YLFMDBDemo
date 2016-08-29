//
//  Book.h
//  YLFMDBDemo
//
//  Created by yongliangP on 16/8/29.
//  Copyright © 2016年 yongliangP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject

/**图书标题*/
@property (nonatomic, copy) NSString *title;

/**大图*/
@property (nonatomic, copy) NSString *large;

/**出版社*/
@property (nonatomic, copy) NSString *publisher;

@end
