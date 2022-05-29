# HXPT TPM Flutter APP

## 相关技术
### Flutter
由谷歌开发的开源移动应用软件开发工具包，用于为Android、iOS、 Windows、Mac、Linux、Google Fuchsia开发应用
### Dart
Dart是一种开源通用编程语言，它最初是由Google开发
### Fish redux
阿里闲鱼团队的flutter的开发框架，也是flutter开发使用较为广泛的框架
目录lib下分多个包，然后右键 new 选择 FishReduxTemplate，选择page选项
这个包下有6个dart文件：action、effect、page、reducer、state、view。
一个page是由state 、view、effect、reducer组成。

模块内dart文件说明
* page.dart: 界面、函数等全局定义
* view.dart: 界面实现UI/UE
* reducer.dart: 函数定义
* effect.dart: 函数实现
* action.dart: 函数接口
* state.dart: 保存数据及状态值

触发UI上面的交互事件，并context.dispatch一个意图给到effect，而这个意图就是action，根据需要在action.dart中进行声明；
effect根据意图来进行数据的读取、创建，亦或者进行页面的跳转，这里重点说明effect不对state中数据进行处理；
effect中得到的数据通过context.dispatch传递给reducer，而reducer是针对state中相关数据进行处理的，并返回新的state，从而触发页面的刷新。

## 功能模块
lib/login            : 登录界面  
lib/firstPage        : Home界面= 登陆成功后首页  
lib/one_list         : 一级目录 = 基站页面 Site  
lib/category         : 二级目录 = 目录列表 Two  
lib/category_two     : 三级目录 = 目录列表 Third  
lib/category_three   : 上传界面，跳转功能  
lib/uploadPicture    : 实际上传页面。实现上传功能  
lib/Api              : 与服务端各接口URL定义  
lib/resources        : 配置信息。app server端URL配置等  
lib/utils            : 工具包  

## 20200520 修改后                                              数据
lib/firstPage        : Home界面= 登陆成功后首页                   
lib/one_list         : 基站目录 Site                            appSites       dirSitePage
lib/category         : 第一级目录         childCategory          dirTwos        dirOnePage
lib/category_new     : 中间一级目录       twoPlusCategory        dirTwoPluss     dirTwoPage  从category拷贝。 插入目录(20200520新增)
lib/category_two     : 最后一级目录       secondChildCategory    dirThrees       dirThreePage
lib/category_three   : 上传界面,跳转功能   categoryThreePage                      uploadPage
lib/uploadPicture    : 实际上传页面。实现上传功能
lib/model/HomeResModel.dart: Home接口返回数据定义

