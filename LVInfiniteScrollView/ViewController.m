//
//  ViewController.m
//  LVInfiniteScrollView
//
//  Created by 孔友夫 on 2018/5/11.
//  Copyright © 2018年 LV. All rights reserved.
//

#import "ViewController.h"
#import "LVInfiniteScrollView.h"

#import "ImageViewController.h"
@interface ViewController ()
<LVInfiniteDelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.


    LVInfiniteScrollView *scroolView  = [[LVInfiniteScrollView alloc]initWithFrame:self.view.bounds ];


    [self.view addSubview:scroolView];
    scroolView.imageNames = @[@"1",@"2",@"4",@"3"];//,@"",@""];

    scroolView.delegate = self;

    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];

}
    
    -(void)LVInfinite:(LVInfiniteScrollView *)infiniteView DidSelected:(NSInteger)index{

        NSLog(@"%ld",index);

        ImageViewController *iamge = [[ImageViewController alloc]init];
        iamge.iamgenemae = @[@"1",@"2",@"4",@"3"][index];
        [self.navigationController pushViewController:iamge animated:YES];

    }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
