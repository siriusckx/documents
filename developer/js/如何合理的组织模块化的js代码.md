## 万变不离其宗：横向切割业务/功能，纵向切割技术层。
> 先从功能出发把 site.js 分成多个独立的模块：如果 site.js 只用在一个页面上，就按照页面上的功能拆分成模块；又或者 site.js 用在多个页面中，可以将 site.js 拆分成一对一页面的入口小模块，这些页面之间可能有相似的模块，这些模块也单独拆出来，入口模块放置每个页面单独的逻辑，并组织共享的模块。以一个聊天工具为例，可以拆解为：
```
├── chat.js
├── sender.js
├── editor.js
├── messge-list.js
└── message.js
```
虽然是平行放置的，但组件是有层次的，小组件功能独立，大组件负责初始化和组合小组件。
```
├── chat.js
└──── sender.js
|  └── editor.js
└──── messge-list.js
   └── message.js
```
再从技术架构的角度将代码划分为多个层次： 注意，并不是所有的项目都需要划分层次，可以按照项目的大小和复杂程度划分层次。项目越复杂就越需要注意将代码划分成不同的层次，而简单的项目就没有必要了，甚至代码都不用放在不同的文件。技术分层的方案就是 MVC，不管你或者流行的框架如何解读 MVC，MVC 是一种以不变应万变的架构。例如：
```
.
├── components
│   └── chat
│       ├── chat.js
│       ├── style.css
│       └── view.html
├── model
└── router
```
* components 就放着 View + Controller，View 和 Controller 相对来说联系是比较紧密的，可以放在一起：
   * chat.js 主要用来初始化其他模块，绑定事件，处理事件，充当 Controller
   * style.css 样式，没什么可说的view.html 放着模板，业务简单的话，也可以去掉 
   * view.html 直接在 chat.js 中拼接字符串
* model：如果项目简单这里放的就是和服务器端进行数据交互的部分，比如 Ajax 请求等。如果项目复杂的话，可以分成两层 Ajax 请求和 Model（View Model 或者数据集中管理的地方）。这部分很可能在很多 component 都会用到，所以可以独立。
* router：不多说，如果你的项目复杂到一定程度，有 router 的话，这是单独放置的。  

单独说说 component：
```
class Chat {
  config:{}
  state:{}
  constructor(initData) {
    this.bindEvents()
  }
  bindEvents(){}
  eventHandler(){}
  modifyView(){}
}
```
一个模块基础组成：
* config：配置，来自源全局，或者来自于父组件
* state：自身的状态，比如是聊天是通畅还是短线了，其他方法运行的过程中需要这些状态来判断进一步的操作
* bindEvents：可以把大堆大堆的 $ 选择绑定事件的代码都放在这里
* eventHandler：很多事件处理器modifyView：很多对视图更改

每个层都会有很多模块，这些模块又是按照业务/功能切分的。
## 工具篇：
切分原则都有了，工具的选择也没什么难的。
* 项目不复杂，不重要，模块拆下来之后也不多，那可以用像 RequireJS，Sea.js 这样的加载器。主要就是处理下 JS 的模块化。直接撸了之后，压缩下，也不用合并，就在线上跑着也没啥问题。
* 项目复杂，重要，模块多，那可以用用 browserify，使用 CommonJS，来组织代码（也可以继续使用 RequireJS，生态和工具还可以）。上线的时通过工具做好合并压缩。
* 如果你采用的非常标准的模块化开发，即每个模块都有独自的模板、Controller、样式、图片，那用 webpack 吧，webpack 的优势就如它的名字一样，不是 js bundle，不是js loader，是 webpack，即其他资源也可以帮你打包处理好，这对于全模块化开发来讲就爽多了。不用想该怎么组织除了 JS 之外的资源。

作：寸志
链接：https://www.zhihu.com/question/39412918/answer/81229395
来源：知乎
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。