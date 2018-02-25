# XQListMenu
## 分类菜单选择器,支持单次点击回调,多选/反选,获取选中的item标题
### 使用方法
* 导入主头文件：`#import "XQListMenuController.h"`<br>
* 初始化`XQListMenuController`:
```objc

// 创建XQListMenuController实例
    XQListMenuController *menuVc = [[XQListMenuController alloc] init];
    
    // 设置大标题数组
    menuVc.titleArray = @[@"☆☆☆☆☆☆ 美食 ☆☆☆☆☆☆",@"☆☆☆☆☆☆ 娱乐 ☆☆☆☆☆☆",@"☆☆☆☆☆☆ 美容保健 ☆☆☆☆☆☆",@"☆☆☆☆☆☆ 酒店 ☆☆☆☆☆☆",@"☆☆☆☆☆☆ 电影 ☆☆☆☆☆☆"];
    
    // 设置内部文字数组
    menuVc.itemTitleArrays = @[
  @[@"火锅",@"自助餐",@"生日蛋糕",@"西餐",@"香锅烤鱼",@"云南菜",@"日韩料理",@"江浙菜",@"咖啡酒吧",@"素菜",@"川湘菜",@"西北菜",@"海鲜",@"蒙菜",@"中式烧烤",@"烤串",@"东南亚菜",@"汤",@"粥",@"炖菜",@"米饭",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13"],
  @[@"KTV",@"足疗按摩",@"运动健身",@"酒吧",@"咖啡",@"儿童乐园",@"桌游",@"电玩",@"密室逃脱",@"真人CS",@"演出赛事",@"DIY",@"手工",@"点播电影",@"体育赛事",@"国产单机",@"武侠网游",@"真人交友",@"舞厅",@"Disco",@"DJ",@"萨芬胡",@"多撒好的"],
  @[@"美容",@"美体",@"个护化妆",@"理发",@"食品保健",@"瑜伽",@"舞蹈",@"母婴玩具",@"服装",@"内衣",@"美甲",@"户外运动",@"图书杂志",@"阿斯顿",@"佛挡杀佛",@"工地上减肥",@"防守对方",@"狗肉馆",@"快回家回家",@"飞蛾晚饭"],
  @[@"经济型酒店",@"豪华酒店",@"主题酒店",@"度假酒店",@"公寓型酒店",@"客栈",@"青年旅店",@"如家酒店",@"7天连锁",@"奋斗是丰富",@"狗肉馆",@"粉色烦",@"如果他",@"飞蛾无关",@"法官入股",@"敢惹风格"],
  @[@"2D",@"3D",@"情侣电影",@"主题电影",@"爱情动作",@"武侠",@"言情",@"肥皂",@"都市异能",@"穿越",@"相声",@"小品",@"微电影",@"生活剧",@"发顺丰",@"都发生奋斗"]
  ];
  
```
* `XQListMenuController`是以`UITableViewController`为主体

### 1.单次点击<br>
#### 效果图:<br>
![](https://github.com/ChandHsu/XQListMenu/blob/master/1.gif)<br>
1.配置`XQListMenuConfig.h`内`menuType`枚举为`XQListMenuTypeSimpleSelectSection`(组单选)/`XQListMenuTypeSimpleSelectGlobal`(全局单选)<br>
2.在初始化栏目实现回调的block:
```objc
    
    menuVc.clickBlock = ^(NSString *title){
        // 添加你的代码,每次点击就会执行
    };

```
### 2.多选操作<br>
#### 效果图:<br>
![](https://github.com/ChandHsu/XQListMenu/blob/master/2.gif)<br>
1.配置`XQListMenuConfig`内`menuType`枚举为`XQListMenuTypeMultiSelect`<br>
2.调用`menuView`的方法:
```objc

/***  获取所有选中的item,返回每个分类的选中item数组，key就是大标题  **/
- (NSDictionary *)getSelectedDict;
/***  全选,反选  **/
-(void)reverseSelectAllItem;

```

### 3.配置数据<br>
数据采取结构体形式
```objc

typedef struct{
    XQListMenuType menuType;
    CGSize itemSize;
    BOOL furlable;//是否支持收拢,返回NO没有收拢箭头选项(如果 hideFunction 为 NO,此项设置无效)
    BOOL hideFunction;//是否开启隐藏功能
    int  beginHideLine;// 开始隐藏的行(只有超过这些行才会开始隐藏),返回 0 自动对半隐藏
}XQListMenuConfig;

```

其中有很多不足的地方,如果有什么建议或意见,还请一起交流探讨,大家共同进步,我的联系方式  QQ:296646879<br>
您的每一次 Star 都是给我的鼓励,如果对你有帮助,请 Star 或 Fork 一下.☺☺☺☺☺






