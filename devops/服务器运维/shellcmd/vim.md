# vim命令图
![vim](./img/vim.keys.jpg)
# vim同时编辑多个文件
* 打开文件
```
vim a.txt b.txt
```
* 在编辑窗口，打开另一个文件
```
:e
```
* 顺序切换到下一个编辑的文件
```
:n
```
* 顺序切换到上一个编辑的文件
```
:N
```
* 显示有多少个待编辑的文件
```
:buffers
```
* 跳转到指定待编辑的文件
```
:buffer 数字
```
# 正在vim编辑，执行其他命令，再切回vim
```
Ctrl+Z  #暂停当前的编辑，回到命令窗口

……      # 执行其他的命令

fg      #唤回正在编辑的命令窗口
```

# vim内部执行命令
```
:! ls
```
>冒号(:) 表明我们处于vim的退出模式  
>感叹号(!)表明我们正在运行shell命令  
>ls 表示要执行的命令（例子）  
另一个例子：vim中使用下面的命令来保存需要root访问权限来保存数据
```
:w !sudo tee %
```
# vim编辑列
>编译列生效的重要一点，最后要按两个Esc
1. Ctrl + V + 方向键选择要编辑的列
2. r 将选中的内容，全部替换成1个相同的字符
3. d或x 将选中的内容进行删除
4. c 输入对应的内容，按两个Esc，将选中的内容，替换成输入的内容
5. shift + i 进入输入模式，在选中列的左边输入，按两下Esc键，将输入的内容展现出来
# vim假死状态解决
> 使用vim时，如果你不小心按了 Ctrl + s后，你会发现不能输入任何东西了，像死掉了一般，其实vim并没有死掉，这时vim只是停止向终端输出而已，要想退出这种状态，只需按Ctrl + q 即可恢复正常。

# Vim 编辑文件乱码问题

```sh
:e ++enc=utf-8
```

甲： 首先查看系统对中文的支持
locale -a | grep zh_CN

乙: 存在3个变量：
1.    encoding (内部编码)    --该选项使用于缓冲的文本(你正在编辑的文件)，寄存器，Vim 脚本文件等等。
2.     fileencoding(文件编码)    --该选项是vim写入文件时采用的编码类型。
3.     termencoding(输出编码)    --该选项代表输出到客户终端（Term）采用的编码类型。
进一步解释
encoding—-与系统当前locale相同，所以编辑文件的时候要考虑当前locale，否则要设置的东西就比较多了。
fileencoding—-vim打开文件时自动辨认其编码，fileencoding就为辨认的值。
        为空则保存文件时采用encoding的编码
termencoding—-默认空值，也就是输出到终端不进行编码转换。

解决乱码举例：
1. 一个文件，在windows下用gvim打开正常，在linux 用vim打开乱码。
观察：windows 下，查看. encoding(cp936), fileencoding(cp936), termencoding()
    linux (乱码), 查看 encoding(utf-8), fileencoding(latin1), termencoding()
分析：是fileencoding 检查出错所致， 但是查看 fileencodings 设置， gvim(windows) 和 vim(linux) 都是
    set fileencodings=utf-8,utf-16,cp936,cs-bom,latin-1
    可见在linux 下并没有真正检测出文件编码类型为 cp936(虽然它在前面）, 而误认为latin-1

解决办法:
    1.指定以cp936格式重新加载文件。 :e ++enc=cp936
      注意。不是se fileencodings=cp936, 那只是把文件保存为cp936
    2. 搞定vim 文件编码判定过程， 例如在首行添加一个中文。例如: //中文， 就能正确识别。推荐此法

总之，搞清这三个变量，可解决乱码问题。
原文链接：https://blog.csdn.net/hejinjing_tom_com/java/article/details/7789321