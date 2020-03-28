## 如何快速使用ligerUI
### 首先掌握获取ligerui的基本使用
   * 属性设置
   
   //我们将一个html文本框对象转换成ligerui文本框对象,并返回ligerui对象
   ```
    var g = $("#txt1").ligerTextBox(
    {
        //如果没有输入时,会提示不能为空
        nullText: '不能为空'
    });
   ```
   // 如何获取属性

   ```
    //方式一
    alert('方式一:' + g.get('disabled'));
    //方式二
    alert('方式二:' + $("#txt1").ligerTextBox('option', 'disabled'));
   ```
    如何设置属性
   ```
    //方式一
    g.set('disabled', true);
    //方式二 
    $("#txt1").ligerTextBox('option', 'disabled', false);

   ```
   * 事件调用
   
   //绑定事件
   ```
    g.bind('changeValue', function (value)
    {
        alert(value);
    });
   ```
   * 方法调用
   ```
    /*
    如何调用方法
    */
    //方式一
    g.setDisabled();
    //方式二 
    $("#txt1").ligerTextBox('setEnabled');
   ```

   参考地址：http://www.cnblogs.com/leoxie2011/archive/2012/01/16/2324106.html

### 快速掌握相应的例子
> 直接将代码工程下载下来，放到对应的目录里面，拷贝一份副本出来，需要什么东西直接在副本上进行试验和修改。看看能否达到对应的效果。
### 了解ligerUI大概有哪些模块

### 根据需要查看API文档

### 知道如何扩展ligerui

