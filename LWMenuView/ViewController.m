//
//  ViewController.m
//  LWMenuView
//
//  Created by lwmini on 2018/9/20.
//  Copyright © 2018年 lw. All rights reserved.
//

#import "ViewController.h"
#import "BNCMenuView.h"

#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT  [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()<BNCMenuViewDelegate>
@property (nonatomic, strong) BNCMenuView *menuView;
@end

@implementation ViewController


- (BNCMenuView *)menuView{
    if (_menuView == nil) {
        _menuView = [[BNCMenuView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) showCloseButton:YES  lineNum:2 rowNum:4];
        _menuView.delegate = self;
        _menuView.hidden = YES;
        _menuView.mainMenuView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
        _menuView.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _menuView.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        [_menuView.closeButton setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    }
    return _menuView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"show" forState:(UIControlStateNormal)];
    [btn setFrame:CGRectMake(100, 64, 100, 100)];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    [self.view addSubview:self.menuView];
    [self loadData];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)btnClick:(UIButton *)sender{
    [self p_showMenuView];
}
- (void)loadData{
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    for (int i =0; i <20; i++) {
        BNCMenuModel *model = [[BNCMenuModel alloc]init];
        model.itemId = [NSString stringWithFormat:@"%3d",i];
        model.title = [NSString stringWithFormat:@"标题%d",i];
        model.placeholderImage = [UIImage imageNamed:@"icon_tongyong"];
        model.isDrag = YES;
        if (i%4 == 0) {
            model.badgeNum = [NSString stringWithFormat:@"%d",i*2] ;
        }
        [dataArray addObject:model];
    }
    [self.menuView reloadMenuData:dataArray];
}
-(void)p_showMenuView{
    CGRect rect = self.menuView.mainMenuView.frame;
    self.menuView.mainMenuView.frame = CGRectMake(0,CGRectGetMaxY(rect) , rect.size.width, rect.size.height);
    __weak typeof(self) tempSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        tempSelf.menuView.mainMenuView.frame = rect;
        tempSelf.menuView.hidden = NO;
    }];
}

#pragma mark - BNCMenuViewDelegate

- (void)overflowUpMenuModel:(BNCMenuModel *)model andMenuView:(BNCMenuView *)menuView andTouchView:(BNCTouchView *)touchView{
    NSLog(@"%s:-- %@",__func__,model.title);
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"您拖动了第%@cell 到视图上面",model.itemId] preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:alertAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)didSelectItemMenuModel:(BNCMenuModel *)model andMenuView:(BNCMenuView *)menuView{
    NSLog(@"%s:-- %@",__func__,model.title);
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"您点击了第%@cell",model.itemId] preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:alertAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (void)closeButtonActionAndBlankTapAction:(UIButton *)sender andMenuView:(BNCMenuView *)menuView{
    CGRect rect = menuView.mainMenuView.frame;
    [UIView animateWithDuration:0.5 animations:^{
        menuView.mainMenuView.frame = CGRectMake(0,CGRectGetMaxY(rect) , rect.size.width, 0);
    }completion:^(BOOL finished) {
        menuView.hidden = YES;
        menuView.mainMenuView.frame = rect;
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
