# 把整个项目打包成sdk

为什么要这么麻烦打包整个项目成一个`framework`, 只可意会不可言传

> https://www.cnblogs.com/pengoeng/p/10689435.html

最终效果就是我在测试sdk项目中通过点击一个button, 或者任何触发方式, 把sdk的vc推进来

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

然后和上一步一样, new一个project, 只不过这次选的是iOS app.

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

1. 调整最低支持的iOS系统(建议跟微信保持一致, 直接去App Store搜微信 看设备兼容性 微信多少我们就设置多少)

### TARGETS -> Build Settings 设置SDK；

1. 搜索Mach-O Type设置为Static Library;

2. 搜索Dead Code Stripping 设置为NO;

3. 如果 SDK 有用到 Category，注意项目设置 Other Linker Flags 添加 -ObjC

4. ENABLE_BITCODE 设置为NO 

5. Build Active Architecture Only修改为NO，否则生成的静态库就只支持当前选择设备的架构 

### TARGETS -> Build Phases - Headers 设置SDK；

1. 可以看出有三个选项，分别是 Public 、Private 、Project ，把需要公开给别人的 .h 文件拖到 Public 中，把不想公开的，即为隐藏的 .h 文件拖到 Project 中

![86Uarw](https://picture-transmission.iplus-studio.top/uPic/86Uarw.png)

2. 完成上述步骤之后，在项目里默认生成的.h文件中，把上个步骤中public下的.h文件都用 #import 引入，不然编译后生成的.framework在引用的时候会有警告

![l0MOBP](https://picture-transmission.iplus-studio.top/uPic/l0MOBP.jpg)

## `framework`中依赖第三方`sdk`

> https://blog.csdn.net/shifang07/article/details/90053655

> https://www.jianshu.com/p/b2a2b6ca831c

需要注意的是：所有第三方公共使用的库和SDK不能添加到target里面

![A9696w](https://picture-transmission.iplus-studio.top/uPic/A9696w.png)

![DJaf0a](https://picture-transmission.iplus-studio.top/uPic/DJaf0a.jpg)

![45cKiO](https://picture-transmission.iplus-studio.top/uPic/45cKiO.png)

## 测试`demo`中依赖自制`framework`

![b45NWe](https://picture-transmission.iplus-studio.top/uPic/b45NWe.png)

![V01xtV](https://picture-transmission.iplus-studio.top/uPic/V01xtV.png)

![U1H03E](https://picture-transmission.iplus-studio.top/uPic/U1H03E.png)

## 测试`demo`中依赖上自制`framework`中的第三方sdk

比如高德地图sdk

否则编译会说找不到class

![mY6i06](https://picture-transmission.iplus-studio.top/uPic/mY6i06.png)

其实这也更加证明我们的sdk没有把第三方sdk打包进去.

![mKN1VG](https://picture-transmission.iplus-studio.top/uPic/mKN1VG.png)

![BZJEVW](https://picture-transmission.iplus-studio.top/uPic/BZJEVW.png)

![45cKiO](https://picture-transmission.iplus-studio.top/uPic/45cKiO.png)

# 编译并运行测试demo

![2VkXt8](https://picture-transmission.iplus-studio.top/uPic/2VkXt8.png)

# 关于主工程能否不依赖任何第三方sdk

经过测试, 就算sdk勾选上target也不会打包进去, 那就是主工程只能一定要去依赖第三方sdk
