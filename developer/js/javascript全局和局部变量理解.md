## 全局变量和局部变量理解
>   一、Javascript的变量的scope是根据方法块来划分的（也就是说以function的一对大括号｛ ｝来划分）。切记，是function块，而for、while、if块并不是作用域的划分标准，可以看看以下几个例子：
```
    <script>  
    function test2(){  
        alert ("before for scope:"+i);    // i未赋值（并不是未声明！使用未声明的变量或函数全抛出致命错误而中断脚本执行）  
      
                                                        // 此时i的值是underfined  
        for(var i=0;i<3;i++){  
            alert("in for scope:"+i);  // i的值是 0、1、2, 当i为3时跳出循环  
        }  
        alert("after for scope:"+i);  // i的值是3，注意，此时已经在for scope以外，但i的值仍然保留为3  
          
        while(true){  
            var j = 1;  
            break;  
        }  
        alert(j);    // j的值是1，注意，此时已经在while scope以外，但j的值仍然保留为1  
      
        if(true){  
            var k = 1;  
        }  
        alert(k);  //k的值是1，注意，此时已经在if scope以外，但k的值仍然保留为1  
    }  
      
    test2();  
    //若在此时（function scope之外）再输出只存在于test2 这个function scope里的 i、j、k变量会发生神马效果呢？  
    alert(i); //error! 没错，是error，原因是变量i未声明（并不是未赋值，区分test2函数的第一行输出），导致脚本错误，程序到此结束！  
    alert("这行打印还会输出吗？"); //未执行  
    alert(j); //未执行  
    alert(k); //未执行  
    </script>  
```

>  二、Javascript在执行前会对整个脚本文件的声明部分做完整分析(包括局部变量)，从而确定实变量的作用域。怎么理解呢？看下面一个例子：

```
<script>  
    var a =1;  
    function test(){  
        alert(a); //a为undefined! 这个a并不是全局变量，这是因为在function scope里已经声明了（函数体倒数第4行）一个重名的局部变量,  
                     //所以全局变量a被覆盖了，这说明了Javascript在执行前会对整个脚本文件的定义部分做完整分析,所以在函数test()执行前,  
                     //函数体中的变量a就被指向内部的局部变量.而不是指向外部的全局变量. 但这时a只有声明，还没赋值，所以输出undefined。  
        a=4         
        alert(a);  //a为4,没悬念了吧？ 这里的a还是局部变量哦！  
        var a;     //局部变量a在这行声明  
        alert(a);  //a还是为4,这是因为之前已把4赋给a了  
    }  
    test();  
    alert(a); //a为1，这里并不在function scope内，a的值为全局变量的值  
</script> 
```

> 三、当全局变量跟局部变量重名时，局部变量的scope会覆盖掉全局变量的scope，当离开局部变量的scope后，又重回到全局变量的scope，而当全局变量遇上局部变量时，怎样使用全局变量呢？用window.globalVariableName。

```
    <script>  
        var a =1;  
        function test(){     
            alert(window.a);  //a为1,这里的a是全局变量哦！  
            var a=2;     //局部变量a在这行定义  
            alert(a);  //a为2,这里的a是局部变量哦！  
        }  
        test();  
        alert(a); //a为1，这里并不在function scope内，a的值为全局变量的值  
    </script>  
```