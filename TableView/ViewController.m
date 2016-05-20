//
//  ViewController.m
//  TableView
//
//  Created by mac on 16/5/20.
//  Copyright © 2016年 dubo. All rights reserved.
//

#import "ViewController.h"

#import "HomeHeaderView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,FFScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) HomeHeaderView *homeHeaderView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.homeHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"HomeHeaderView" owner:self options:nil] firstObject];
    self.tableView.tableHeaderView = self.homeHeaderView;
    self.homeHeaderView .picScrollView.pageViewDelegate = self;
    
    NSArray *adsArr = @[@"1.png",@"2.png",@"3.png",@"4.png"];
    [_homeHeaderView.picScrollView initWithImgs:adsArr];
    
}

/**
 *  轮播图点击方法
 *
 *  @param pageNumber  
 */
- (void)scrollViewDidClickedAtPage:(NSInteger)pageNumber {
 
    NSLog(@"%ld",pageNumber);
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    
  cell.textLabel.text = @"666";
    
    return cell;
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
