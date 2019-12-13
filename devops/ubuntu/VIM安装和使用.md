# 一、编译安装VIM8.0
[编译安装vim8.0 参考地址](http://blog.csdn.net/a464057216/article/details/52821171)
 * 安装依赖库
 * 删除原有vim
 * 下载vim源码
 * 设置vim为默认编辑器
## 安装依赖库
 >如果您不需要对Python 3、Lua、Ruby的支持的话，可以选择不安装相应的依赖或者编译Vim时不添加支持。
 ```
 sudo apt-get install libncurses5-dev libgnome2-dev libgnomeui-dev \
     libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
     libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
     python3-dev ruby-dev lua5.1 lua5.1-dev git
 ```
## 删除原有VIM
>首先查询系统中有哪些与vim相关的软件，我的是vim、vim-common和vim-run，然后彻底删除他们：
```
dpkg -l | grep vim
sudo dpkg -P vim vim-common vim-run
```
## 下载vim源码安装
>安装前先获取Python的配置路径，通过whereis python来获取，我的路径是`/usr/lib/python2.7`
```
git clone https://github.com/vim/vim.git
cd vim
./configure --with-features=huge \
            --enable-multibyte \
            --enable-rubyinterp \
            --enable-pythoninterp \
            --with-python-config-dir=/usr/lib/python2.7 \
            --enable-perlinterp \
            --enable-luainterp \
            --enable-gui=gtk2 --enable-cscope --prefix=/usr
make VIMRUNTIMEDIR=/usr/share/vim/vim80
sudo make install
```
## 设置vim为默认编辑器
```
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim 1
sudo update-alternatives --set editor /usr/bin/vim
sudo update-alternatives --install /usr/bin/vi vi /usr/bin/vim 1
sudo update-alternatives --set vi /usr/bin/vim
```
>最后，删除vim源码包，执行vim --version命令查看vim的版本号、补丁号以及是否成功开启了Python的支持（包含+python）。
# 二、配置VIM插件
>对于vim插件的配置[vim-bootstrap](http://vim-bootstrap.com/)提供了一些现成的模板，只需要选中自己想要支持的语言，即可生成对应的generate.vim文件，将其改名为.vimrc放到家目录下，安装好插件即可使用。当然要想安装提供的模板之外的插件，接下来对vim插件的管理方式进行一些了解，并自行安装另外的插件markdown。
# 三、了解VIM插件管理
[插件管理参考地址](https://segmentfault.com/a/1190000010063958)  
**主流的插件管理器有**[pathogen](https://github.com/tpope/vim-pathogen)、[Vundle](https://github.com/VundleVim/Vundle.vim)、[vim-plug](https://github.com/junegunn/vim-plug)、[dein.vim](https://github.com/Shougo/dein.vim)，在这几个插件当中，比较主要用过的有`Vundle`、`vim-plug`这两个插件管理方式比较文件使用，本文里面提到的`vim-bootstrap`使用的是`vim-plug`的管理方式。具体如何使用，可参照官方文档进行查看即可。
# 四、安装MARKDOWN
以`vim-plug`安装插件为例，安装markdown，在使用`vim-bootstrap`的基础上要添加其他的插件，一般情况下可采用如下三个步骤进行：
1. 在github上找到对应的插件目录，如：https://github.com/plasticboy/vim-markdown 则在`.vimrc`文件中添加
```
Plug 'plasticboy/vim-markdown'
```
2. 接下来配置插件使用的一些快捷键或相应的配置，如：
```
" MarkdownPreview GitHub
map <leader>m :MarkdownPreview GitHub<CR> 
"在这里<leader>由"let mapleader=" "决定
```
3. 保存`.vimrc`文件并关闭，然后重新打开，自行安装插件。
>同理，在安装好markdown的时候，需要安装一个markdown预览插件，当调用预览插件的时候，是通过调用火狐浏览器来进行预览的，该插件为[iamcco/markdown-preview.vim](https://github.com/iamcco/markdown-preview.vim)
## VIM的使用
1. 假死状态解决
> 使用vim时，如果你不小心按了 Ctrl + s后，你会发现不能输入任何东西了，像死掉了一般，其实vim并没有死掉，这时vim只是停止向终端输出而已，要想退出这种状态，只需按Ctrl + q 即可恢复正常。
