转载自：http://zhidao.baidu.com/question/493376840.html，

                http://blog.sina.com.cn/s/blog_71261a2d0100wmbj.html

谢谢！


1.Shell脚本 有那些类型 比如说 .csh . py .sh 这些脚本又有什么区别

通常写一个shell脚本都要在第一行注明使用什么解释器来解释这个脚本，即写成：#!/bin/bash
这样的形式，意思是告诉系统要使用/bin/bash这个解释器来解释下面的语句。
shell的脚本一般用.sh作为后缀，就如1楼说的后缀名在Linux下并没有特别意义，只是便于人类区分而已，只要你写的脚本的第一行有#!/bin/bash或者是其他的解释器，如#!/bin/csh，执行该脚本时系统会使用该注明的解释器来解释。


.csh大概是用来区分，这个脚本使用csh这个shell解释器来解释。
.sh用来区分，这个脚本使用bash或sh解释器来解释。
.py则是使用python来解释。

2.sh,bash,csh,tcsh等shell的区别

Bourne Shell(即sh)是UNIX最初使用的shell，平且在每种UNIX上都可以使用。Bourne Shell在shell编程方便相当优秀，但在处理与用户的交互方便作得不如其他几种shell。
LinuxOS默认的是Bourne Again Shell，它是Bourne Shell的扩展，简称bash，与Bourne Shell完全兼容，并且在Bourne Shell的基础上增加，增强了很多特性。可以提供命令补全，命令编辑和命令历史等功能。它还包含了很多C Shell和Korn Shell中的优点，有灵活和强大的编辑接口，同时又很友好的用户界面

C Shell是一种比Bourne Shell更适合的变种Shell，它的语法与C语言很相似。Linux为喜欢使用C Shell的人提供了Tcsh。
Tcsh是C Shell的一个扩展版本。Tcsh包括命令行编辑，可编程单词补全，拼写校正，历史命令替换，作业控制和类似C语言的语法，他不仅和Bash Shell提示符兼容，而且还提供比Bash Shell更多的提示符参数。

Korn Shell集合了C Shell和Bourne Shell的优点并且和Bourne Shell完全兼容。Linux系统提供了pdksh（ksh的扩展），它支持人物控制，可以在命令行上挂起，后台执行，唤醒或终止程序。