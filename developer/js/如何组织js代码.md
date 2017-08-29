## 如何组织js代码
### 1. 基础-函数版
```
function a(){};
function b(){};
```
### 2.入门-字面量版
```
var obj = {
    init : function(){
        this.a();
        this.b();
    },
    a : function(){},
    b : function(){}
}
// 在页面中调用obj.init();
```
### 3.进阶-命名空间版
```
var hogo = {
    ns : function(){};
}

hogo.ns('hogo.wx', {
    init : function(){
        this.a();
        this.b();
    },
    a : function(){},
    b : function(){}
});
hogo.wx.init();
```
### 4.提高 - 模块化版
```
define();
require();
```
