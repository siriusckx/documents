# 1 概述
> Boost使用timer和date_time库完美地解决了，C++一直以来缺乏时间和日期处理能力的问题。timer库提供简易的度量时间和进度显示功能，可以用于性能测试等需要计时的任务。
> 
> timer库包含三个组件，分别是：计时器类timer、progress_timer和进度指示类progress_display。
> 
> date_time库基于我们日常使用的公历（格里高利历），可以提供时间相关的各种所需功能，如精确定义的时间点，时间段和时间长度，加减若干天/月/年、日期迭代器等等。date_time库还支持无限时间和无效时间这种实际生活中有用的概念，同时可以与C的传统时间结构tm相互转换，提供向下支持。

## 1.1 timer
>需要包含头文件
```
#include <boost/timer.hpp>
```

>timer对象一旦被声明，它的构造函数就启动了计时工作，之后就可以随时用elapsed()函数简单地测量自对象创建后所流逝的时间。成员函数elapsed_min()返回timer测量时间的最小精度，elapsed_max()返回timer能够测量的最大时间范围，两者的单位都是秒。

>timer的计时使用了标准库头文件\<ctime\>里的std::clock()函数，它返回自进程启动以来的clock数，每秒的clock数则由宏CLOCKS_PER_SEC定义。CLOCKS_PER_SEC的值由操作系统而不同，在Win32下是1000，而在Linux下则是1000000，也就是说在Win32下的精度是毫秒，而Linux下的精度是微秒。

>timer的构造函数记录当前的clock数作为计时起点，保存在私有成员变量_start_time中，每当调用elapsec()时就获取此时的clock数，减去计时起点_start_time,再除以CLOCKS_PER_SEC获得以秒为单位的已经流逝的时间。如果调用函数restart()，则重置_start_time重新开始计时。

>函数elasped_min()返回timer能够测量的最小时间单位，是CLOCKS_PER_SEC的倒数。函数elasped_max()使用了标准库的数值极限类numeric_limits，获得clock_t类型的最大值，采用类似elapsed()的方式计算可能的最大时间范围。

>timer不适合高精度的时间测量任务，它的精度依赖于操作系统或编译器，难以做到跨平台，也不适合做大跨度时间段的测量，可提供的最大时间跨度只有几百个小时。

## 1.2 progress_timer

>progress_timer也是一个计时器，它继承自timer，会在析构的时候自动输出时间，省去了timer手动调用elapsed()的工作，是一个用于自动计时相当方便的小工具。

>progress_timer用于计时非常方便，但可惜的是它的对外输出精度只有小数点后两位，即只精确到百分之一秒。我们可以使用模板技术仿造progress_timer编写一个新类：new_progress_timer，以实现任意精度的输出。

```
#include <boost/progress.hpp>
#include <boost/static_assert.hpp>

template<int N = 2>
class new_progress_timer: public boost::timer
{
    new_progress_timer(std::ostream & os = std::cout):m_os(os)
    {
        BOOST_STATIC_ASSERT(N >=0 && N <= 10);  //静态断言
    }

    ~new_progress_timer(void)
    {
        try
        {
            //保存流的状态
            std::iostream::fmtflags old_flags;
            old_flags = m_os.setf(std::istream::fixed, std::istream::floatfield);
            std::streamsize old_prec = m_os.precision(N);

            //输出时间
            m_os << elapsed() <<  " s\n" << std::endl;  //"s"表示秒

            //恢复流状态
            m_os.flags(old_flags);
            m_os.precision(old_prec);
        }
        catch(...)
        { } //析构绝对不能抛出异常，这非常重要
    }

    private:
        std::ostream &m_os;
};


//使用例子
#include <new_progress_timer.h>
int main()
{
    new_progress_timer<10> t;

    //do something ....
}
```

## 1.3 date_time

>**编译date_time库**:date_time库是Boost中少数需要编译的库之一，直接编译date_time需运行bjam命令：

```
bjam --toolset=msvc --with-date_time --build-type=complete stdlib=stlport stage
```

>明确几个和时间相关的一些基本概念：把时间想像成一个向前和一个向后都无限延伸的实数轴。

>**时间点**：就是数轴上的一个点   

>**时间段**：两个时间点之间确定的一个区间。

>**时长（时间长度）**:则是一个有正负号的标量，它是两个时间点之差，不属于数轴。

> 时间点、时间段、时长三者之间可以进行运算，这些运算都基于生活常识，很容易理解。date_time库支持无限时间和无效时间这样特殊的时间概念，类似于数学中极限的涵义。date_time库中用枚举special_values定义了这些特殊的时间概念，它位于名字空间boost::date_time中，具体如下：

```
pos_infin:  表示正无限
neg_infin:  表示负无限
not_a_date_time: 无效时间
min_date_time:可表示最小日期或时间
max_date_time:可表示最大日期或时间
```

### 1.3.1 处理日期

> date_time库的日期基于格里高利历，支持从1400-01-01到9999-12-31之间的日期计算（很遗憾，它不能处理公元前的日期，不能用它来研究古老的历史）。它位于名字空间boost::gregorian，为了使用date_time库的日期功能，需要包含头文件

```
#include <boost/date_time/gregorian/gregorian.hpp>
```
