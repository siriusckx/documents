## fcntl的原型和介绍
1. fcntl函数是一个多功能文件工具箱，接收2个参数+1个变参。第一个参数是fd表示文件描述符，第二个参数是命令cmd，表示要进行哪个命令操作。变参是用来传递参数的，要配合cmd来使用。
2. cmd的样子类似于F_XXX，不同的cmd具有不同的功能。

## fcntl的常用cmd
1. F_DUPFD 这个cmd的作用是复制文件描述符（作用类似于dup和dup2）
