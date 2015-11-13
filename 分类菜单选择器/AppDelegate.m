//
//  AppDelegate.m
//  分类菜单选择器
//
//  Created by 徐强 on 15/11/10.
//  Copyright © 2015年 xuqiang. All rights reserved.
//

#import "AppDelegate.h"
#import "XQListMenuView.h"

@interface AppDelegate ()

@property (nonatomic, weak) XQListMenuView *menuView;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    XQListMenuView *menuView = [[XQListMenuView alloc] init];
    
    menuView.titleArray = @[@"☆☆☆☆☆☆ 美食 ☆☆☆☆☆☆",@"☆☆☆☆☆☆ 娱乐 ☆☆☆☆☆☆",@"☆☆☆☆☆☆ 美容保健 ☆☆☆☆☆☆",@"☆☆☆☆☆☆ 酒店 ☆☆☆☆☆☆",@"☆☆☆☆☆☆ 电影 ☆☆☆☆☆☆"];
    menuView.itemTitleArrays = @[
  @[@"火锅",@"自助餐",@"生日蛋糕",@"西餐",@"香锅烤鱼",@"云南菜",@"日韩料理",@"江浙菜",@"咖啡酒吧",@"素菜",@"川湘菜",@"西北菜",@"海鲜",@"蒙菜",@"中式烧烤",@"烤串",@"东南亚菜",@"汤",@"粥",@"炖菜",@"米饭",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13"],
  @[@"KTV",@"足疗按摩",@"运动健身",@"酒吧",@"咖啡",@"儿童乐园",@"桌游",@"电玩",@"密室逃脱",@"真人CS",@"演出赛事",@"DIY",@"手工",@"点播电影",@"体育赛事",@"国产单机",@"武侠网游",@"真人交友",@"舞厅",@"Disco",@"DJ",@"萨芬胡",@"多撒好的"],
  @[@"美容",@"美体",@"个护化妆",@"理发",@"食品保健",@"瑜伽",@"舞蹈",@"母婴玩具",@"服装",@"内衣",@"美甲",@"户外运动",@"图书杂志",@"阿斯顿",@"佛挡杀佛",@"工地上减肥",@"防守对方",@"狗肉馆",@"快回家回家",@"飞蛾晚饭"],
  @[@"经济型酒店",@"豪华酒店",@"主题酒店",@"度假酒店",@"公寓型酒店",@"客栈",@"青年旅店",@"如家酒店",@"7天连锁",@"奋斗是丰富",@"狗肉馆",@"粉色烦",@"如果他",@"飞蛾无关",@"法官入股",@"敢惹风格"],
  @[@"2D",@"3D",@"情侣电影",@"主题电影",@"爱情动作",@"武侠",@"言情",@"肥皂",@"都市异能",@"穿越",@"相声",@"小品",@"微电影",@"生活剧",@"发顺丰",@"都发生奋斗"]
  ];
    
    menuView.clickBlock = ^(NSString *title){
        NSLog(@"------++++++++%@",title);
    };
    
    self.menuView = menuView;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:menuView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    menuView.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn1.frame = CGRectMake(0, 0, 30, 30);
    [btn1 addTarget:self action:@selector(btnClick1) forControlEvents:UIControlEventTouchUpInside];
    menuView.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    
    self.window.rootViewController = nav;
    return YES;
}

- (void)btnClick{

    NSDictionary *dict = [self.menuView getSelectedDict];
    NSLog(@"%@",dict);
}
- (void)btnClick1{
    [self.menuView reverseSelectAllItem];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
