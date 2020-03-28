# gvim在windows下的乱码设置
> 修改`_vimrc` 文件，路径如下：C:\Program Files (x86)\Vim\ \_vimrc
```
"vim8.1在windows下的编码设置
set encoding=utf-8
set fileencodings=utf-8,chinese,latin-1
if has("win32")
set fileencoding=chinese
else
set fileencoding=utf-8
endif
"解决菜单乱码
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
"解决consle输出乱码
language messages zh_CN.utf-8
```

# gvim全套的配置
https://zhuanlan.zhihu.com/p/21328642