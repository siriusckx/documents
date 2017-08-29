## 手动安装atom插件
> Atom是一款非常优秀的开源的编辑器，在国内安装时经常会遇到无法安装情况，下面介绍一种手动安装Package的办法

1. 下载安装git;
2. 下载安装node.js，设置好环境变量；
3. 在atom的setting页面中点击open config folder进入到atom的配置项目，然后我们转到该项目下的windows窗口进入package文件夹，这将是我们放置插件包的地方。C:\Users\Administrator\.atom\packages
4. 在github上找到自己要安装的插件，复制对应的github地址；
5. 在packages目录中运行git bash，将该插件克隆到目录中如：
```
git clone https://github.com/t9md/atom-vim-mode-plus.git
```
6. 进入到插件目录，如`atom-vim-mode-plus`，执行`npm install`
7. 重启atom。
8. 备注，如果安装过程中出现，如下错误，可以多执行几次，`npm cache verify`然后再安装。

```
npm WARN optional SKIPPING OPTIONAL DEPENDENCY: ajv@4.11.8 (node_modules/ajv):
npm WARN optional SKIPPING OPTIONAL DEPENDENCY: sha1-gv+wKynmYq5TvcIK8VlHcGc5xTY= integrity checksum failed when using sha1: wanted sha1-gv+wKynmYq5TvcIK8VlHcGc5xTY= but got sha1-cAF9SVToi/PIXzaXpT9w7YYk2TE=. (344219 bytes)

npm ERR! code EINTEGRITY
npm ERR! sha1-UlwPIWkJZ4kWP7J/AoNKOC3wIwQ= integrity checksum failed when using sha1: wanted sha1-UlwPIWkJZ4kWP7J/AoNKOC3wIwQ= but got sha1-Q/Ec9Ui4rnFLVAc2LhRXrzJmBug=. (845391 bytes)
```
