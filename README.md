
<p align="center">
  <img height="200" src="https://raw.githubusercontent.com/MrSouthWall/Monopoly-EBank/main/README_Assets/MonopolyLogo-Light-RoundedShadow.png">
</p>

<h1 align="center">大富翁电子银行</h1>

<p align="center">
  帮助您快捷跟踪大富翁纸质桌游的金钱交易。
</p>

<p align="center">
  <a href="https://developer.apple.com/swift/"><img alt="Static Badge" src="https://img.shields.io/badge/Language-Swift-F05138?logo=swift&logoColor=F05138"></a>
  <a href="https://developer.apple.com/cn/xcode/swiftui/"><img alt="Static Badge" src="https://img.shields.io/badge/UIFramework-SwiftUI-0062D4?logo=swift&logoColor=0062D4"></a>
  <a href="https://developer.apple.com/xcode/swiftdata/"><img alt="Static Badge" src="https://img.shields.io/badge/DataStorage-SwiftData-6F8C9C?logo=swift&logoColor=6F8C9C"></a>
  <a href="https://www.apple.com/ios/ios-17/"><img alt="Static Badge" src="https://img.shields.io/badge/Available-iOS 17+-green?logo=apple&logoColor=green"></a>
</p>

## 关于作者和本项目

大家好，我是 MrSouthWall 南墙先生。

这个项目，起源于前段时间沉迷桌游大富翁，但每次数纸钞又烦又累，后来买了有实体电子银行的版本，但仍然无法愉快地玩耍，电子银行在快速插拔银行卡时，还会偶现一些错误。

当时就在想，为什么不能把电子银行带到手机上呢？

心动不如行动，于是就有了这个项目，后续的设想是开发 iPad 版本，并且直接在 iPad 上抽取机会和命运，还有直接拖拽交易双方的头像，快速完成交易，等待时间去开发。

不过 App 现已可以正常游玩，我已经用它游玩多局，交易速度极快，体验甚好，欢迎大家一起体验。

（但大富翁的灵魂会不会就是在于数纸钞呢？）

## 安装方法

- 重设 Team：克隆仓库到本地，或下载完整代码，使用 Xcode 打开工程文件。在 Xcode 左侧边栏中点击有 AppStore 图标的项目，在 `Signing & Capabilities` 设置中，将 `Team` 设置为您自己的账户；
- 连接您的 iPhone：使用数据线将您的 Mac 和 iPhone 连接，Xcode 上方会出现 iPhone 的名字，若没出现则点击上方机型，选择您的 iPhone；
- 运行：使用快捷键 `Command + R`，或点击左上角 `▶️` 按钮，等待运行完成，iPhone 上自动打开 App。

如果运行时 Xcode 报错，大概率是您的 iPhone 没有打开开发者模式，在 iPhone 的 `设置/通用/隐私与安全/开发者模式` 中打开。

> [!note]
> 如果您不是 iOS 开发者，未支付苹果的开发者会员费，可能一段时间后您就无法在 iPhone 上打开 App，此时您只需重新运行代码，重新安装一遍到 iPhone 上即可解决；

## 游玩建议

- App 内选择交易人物时，先点击支出方，再点击收入方，App 会自行退出选人界面；
- App 内游戏时，先设定人物和初始资金，官方规则初始资金为15M；

## 持续优化

- 目前只能配合地产大亨官方版本纸质桌游游玩，或金额以 `M` 为单位的任意版本进行游玩；
- 目前 App 内许多参数固定写死，例如经过起点是固定获得 2M 金钱，后续可能会改进，有能力的朋友可以自行修改；
