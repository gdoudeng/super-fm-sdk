# 把整个项目打包成 sdk

为什么要这么麻烦打包整个项目成一个`framework`, 只可意会不可言传

> https://www.cnblogs.com/pengoeng/p/10689435.html

最终效果就是我在测试 sdk 项目中通过点击一个 button, 或者任何触发方式, 把 sdk 的 vc 推进来

# 预览

![ezgif.com-gif-maker](https://picture-transmission.iplus-studio.top/uPic/ezgif.com-gif-maker.gif)

# 创建两个空项目

先找个地方新建一个文件夹, 两个项目都是放在这里.

## 新建 `SuperFmSDK` 文件夹

![zYCG0b](https://picture-transmission.iplus-studio.top/uPic/zYCG0b.png)

然后打开`XCode`, 在这个文件夹里新建一个`xcworkspace`

![e7WqWS](https://picture-transmission.iplus-studio.top/uPic/e7WqWS.jpg)

这里我起名`SuperFmSDK`, 完成后如上图.

## 新建`framework`项目

![VgMpGL](https://picture-transmission.iplus-studio.top/uPic/VgMpGL.png)

![vGdoXl](https://picture-transmission.iplus-studio.top/uPic/vGdoXl.png)

这里有个非常重要的点, 新建的`framework`工程一定要加在原来的`xcworkspace`上

## 新建测试`SDK`的`demo`

完成上一步后, 关掉`Xcode`, 重新双击`xcworkspace`打开

然后和上一步一样, new 一个 project, 只不过这次选的是 iOS app.

![gUxmuh](https://picture-transmission.iplus-studio.top/uPic/gUxmuh.png)

![IMnyiZ](https://picture-transmission.iplus-studio.top/uPic/IMnyiZ.png)

![RHlMAy](https://picture-transmission.iplus-studio.top/uPic/RHlMAy.png)

![uG4WvH](https://picture-transmission.iplus-studio.top/uPic/uG4WvH.png)

## 最终效果

再次把`Xcode`关掉, 双击`xcworkspace`打开

![JQ90f7](https://picture-transmission.iplus-studio.top/uPic/JQ90f7.png)

这样就把`SDK`和`demo`都创建好了，这样创建`SDK`加`demo`可以方便调试，如果`SDK`中有问题，可以直接在`SDK`中断点调试。

## 配置`framework`

> https://blog.csdn.net/u010263943/article/details/93596039

选中`framework`

![esGPsU](https://picture-transmission.iplus-studio.top/uPic/esGPsU.png)

1. 调整最低支持的 iOS 系统(建议跟微信保持一致, 直接去 App Store 搜微信 看设备兼容性 微信多少我们就设置多少)

### TARGETS -> Build Settings 设置 SDK；

1. 搜索 Mach-O Type 设置为 Static Library;

2. 搜索 Dead Code Stripping 设置为 NO;

3. 如果 SDK 有用到 Category，注意项目设置 Other Linker Flags 添加 -ObjC

4. ENABLE_BITCODE 设置为 NO

5. Build Active Architecture Only 修改为 NO，否则生成的静态库就只支持当前选择设备的架构

### TARGETS -> Build Phases - Headers 设置 SDK；

1. 可以看出有三个选项，分别是 Public 、Private 、Project ，把需要公开给别人的 .h 文件拖到 Public 中，把不想公开的，即为隐藏的 .h 文件拖到 Project 中

![86Uarw](https://picture-transmission.iplus-studio.top/uPic/86Uarw.png)

2. 完成上述步骤之后，在项目里默认生成的.h 文件中，把上个步骤中 public 下的.h 文件都用 #import 引入，不然编译后生成的.framework 在引用的时候会有警告

![wxx87f](https://picture-transmission.iplus-studio.top/uPic/wxx87f.png)

## `framework`中依赖第三方`sdk`

> https://blog.csdn.net/shifang07/article/details/90053655

> https://www.jianshu.com/p/b2a2b6ca831c

需要注意的是：所有第三方公共使用的库和 SDK 不能添加到 target 里面

![A9696w](https://picture-transmission.iplus-studio.top/uPic/A9696w.png)

![DJaf0a](https://picture-transmission.iplus-studio.top/uPic/DJaf0a.jpg)

![45cKiO](https://picture-transmission.iplus-studio.top/uPic/45cKiO.png)

## 测试`demo`中依赖自制`framework`

![b45NWe](https://picture-transmission.iplus-studio.top/uPic/b45NWe.png)

![V01xtV](https://picture-transmission.iplus-studio.top/uPic/V01xtV.png)

![U1H03E](https://picture-transmission.iplus-studio.top/uPic/U1H03E.png)

## 测试`demo`中依赖上自制`framework`中的第三方 sdk

比如高德地图 sdk

否则编译会说找不到 class

![mY6i06](https://picture-transmission.iplus-studio.top/uPic/mY6i06.png)

其实这也更加证明我们的 sdk 没有把第三方 sdk 打包进去.

![mKN1VG](https://picture-transmission.iplus-studio.top/uPic/mKN1VG.png)

![BZJEVW](https://picture-transmission.iplus-studio.top/uPic/BZJEVW.png)

![45cKiO](https://picture-transmission.iplus-studio.top/uPic/45cKiO.png)

# 编译并运行测试 demo

![2VkXt8](https://picture-transmission.iplus-studio.top/uPic/2VkXt8.png)

# 关于主工程能否不依赖任何第三方 sdk

经过测试, 就算 sdk 勾选上`target`也不会打包进去, 那就是主工程只能一定要去依赖第三方 sdk

# 处理 SDK 中的资源

比如图片, 视频, 音频, `plist`文件, 等除了代码的文件, 这些是需要用一个`bundle`打包的, 然后`sdk`或者主工程再从`bundle`中读取资源.

## 创建`bundle`资源包

在`target`中点击右下角的+号，选择`macOS`，找到`Framework&Library`，选择`Bundle`。如图

![96kCdK](https://picture-transmission.iplus-studio.top/uPic/96kCdK.png)

![3rL2hy](https://picture-transmission.iplus-studio.top/uPic/3rL2hy.png)

![QrtB5K](https://picture-transmission.iplus-studio.top/uPic/QrtB5K.png)

## 修改配置文件

![pmUj0x](https://picture-transmission.iplus-studio.top/uPic/pmUj0x.png)

- "Base SDK" 设置为 "IOS"

  ~~- "Build Active Architecture Only" 设置为 "YES"~~
  ~~- "Debug Information Format" 设置为 "DWARF with dSYM File"~~
  ~~- "Skip Install" 设置为 "NO"~~
  ~~- "Strip Debug Symbols During Copy" 中"Release"模式设置为 "YES"~~

- "IOS Deployment Target" 设置为 "IOS 12.0"（具体根据自己的项目，设置系统版本）
- "COMBINE_HIDPI_IMAGES" 设置为 "NO"
- ENABLE_BITCODE 设置为 NO

1. 注意 xib 打包后为二进制 nib 文件

2. xib 中使用的图片需要带后缀名比如 xxx.png 否

3. 只能用 Xcode 创建 bundle 否则 xib 无法显示图片

## 编译 `bundle`

先去调成release模式, **注意这里bundle和sdk我都是调成了release模式**.

![c3nnzk](https://picture-transmission.iplus-studio.top/uPic/c3nnzk.png)

![D94IDJ](https://picture-transmission.iplus-studio.top/uPic/D94IDJ.png)

- 还没验证的注意的地方

> https://www.jianshu.com/p/55676b12b687

1. 删除bundle里的执行文件：找到工程中的xxx.Bundle，右键单击后 选择 "显示包内容"，找到里面黑色的可执行文件xxx，删除掉  否者上传商店会报错 ERROR ITMS-90166 ERROR ITMS-90171

2. 找到framework与bundle里面的info.plist文件 ，删除掉Executable file 字段，否者上传商店会报错 ERROR ITMS-90166 ERROR ITMS-90171

![iwsTIA](https://picture-transmission.iplus-studio.top/uPic/iwsTIA.png)

## 使用 `bundle`

![YwWAZa](https://picture-transmission.iplus-studio.top/uPic/YwWAZa.png)

所有加载的资源文件从 bundle 中加载, 主工程要加上上面编译出来的bundle

```objectivec
// 调用自定义View的Xib
+(MyView *)instancePubView
{
    NSArray * nibView =  [[NSBundle mainBundle] loadNibNamed:@"SuperFm.bundle/MyView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

// 调用视图控制器的Xib
-(instancetype)init {
    NSBundle * bundle = [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"SuperFm.bundle"]];
    self = [super initWithNibName:@"MonitoringGeoFenceRegionViewController" bundle:bundle];
    return self;
}

//调用图片
UIImage *image = [UIImage imageNamed:@"home_banner_icon.png" inBundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"SuperFm" ofType:@"bundle"]] compatibleWithTraitCollection:nil];
[self.BGimageView setImage:image];

//storyboard
UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"testStoryboard" bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"SuperFm" ofType:@"bundle"]]];

//mp3
NSString *path = [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"SuperFm" ofType:@"bundle"]] pathForResource:@"test" ofType:@"mp3"];
NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: path];

//plist
NSString *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"SuperFm" ofType:@"bundle"]] pathForResource: @"test" ofType: @"plist"];
NSDictionary *plistDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
```

## 效果

![IMG_99A1419C77FB-1](https://picture-transmission.iplus-studio.top/uPic/IMG_99A1419C77FB-1.jpeg)

底部那个就是xib渲染的

# 关于`PCH`

高德地图官方`demo`没用`PCH`, 但是如果你要打包的项目用到了, 那么需要重新修改`.pch` 文件路径，搜索`prefix header` 修改路径：例如`$(SRCROOT)/$(PROJECT_NAME)/SuperFmSDKHeader.pch`

# 代码

[官方高德地图 sdk demo](https://lbs.amap.com/api/ios-location-sdk/download)

[本项目代码](https://github.com/gdoudeng/super-fm-sdk)

我没上传高德的sdk, 需要自己去下回来, 然后拷贝两份, 分别放到这两个路径

`SuperFmClient/SuperFmClient/Frameworks/`

`SuperFmSDK/SuperFmSDK/Frameworks/`

![ewaQkY](https://picture-transmission.iplus-studio.top/uPic/ewaQkY.png)
