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

#### 1.3.1.1 创建日期对象

>空的构造函数会创建一个值为not_a_date_time的无效日期，顺序传入年月日值则创建一个对应日期的date对象，例如：

```
date d1;    //一个无效的日期
date d2(2010, 1, 1);    //使用数字构造日期
date d3(2010, Jan, 1);  //也可以使用英文指定日期
date d4(d2);    //date支持拷贝构造

assert(d1 == date(not_a_date_time));    //比较一个临时对象
assert(d2 == d4);    //date支持比较操作
```

> date也可以从一个字符串产生，这需要使用工厂函数`from_string()`和`from_undelimited_string()`。前者使用分隔符（斜杠或者连字符符）分隔年月日格式的字符串，后者则是无分隔符的的纯字符串格式。

```
date d1 = from_string("1999-12-31");
date d2(from_string("2000/1/1"));
date d3 = from_undelimited_string("20181118");
```

> day_clock是一个天级别的时钟，它也是一个工厂类，调用它的静态成员函数local_day()和universal_day()会返回一个当天的日期对象，分别是本地日期和UTC日期。day_clock内部使用了C标准库的localtime()和gmtime()函数，因此local_day()的行为依赖于操作系统的时区设置。

```
cout << day_clock::local_day() << endl;
cout << day_clock::universal_day() << endl;
```

>我们也可以使用特殊时间概念枚举 special_values创建一些特殊的日期，在处理如无限期的某些情形下会很有用：

```
date d1(neg_infin);         //负无限日期
date d2(pos_infin);         //正无限日期
date d3(not_a_date_time);   //无效日期
date d4(max_date_time);     //最大可能日期 9999-12-31
date d5(min_date_time);     //最小可能日期 1400-01-01
```

>如果创建日期对象时使用了非法的值，例如日期超过了1400-01-01到9999-12-31的范围，使用不存在的月分或日期，那么date_time库会抛出异常（而不是转换为一个无效日期），可以使用what()获得具体的错误信息。

#### 1.3.1.2 访问日期

> date类的对外接口很像C语言中的tm结构，也可以获得它保存的年、月、日、星期等成分，但date提供了更多的操作。

>成员函数year()、month()和day()分别返回日期的年、月、日。year_month_day()返回一个date::ymd_type结构，可以一次性地获取年月日数据：

```
date d(2010, 4, 1);
date::ymd_type ymd = d.year_month_day();
cout << ymd.year << endl;
cout << ymd.month<< endl;
cout << ymd.day<< endl;
```

>成员函数day_of_week()返回date的星期数，0表示星期天。day_of_year()返回date是当年的第几天（最多是366）。end_of_month()返回当月的最后一天的date对象。

```
date d(2010, 4, 1);
assert(d.day_of_week() == 4);
assert(d.day_of_year() == 91);
assert(d.end_of_month() == date(2010, 4, 30));
```

> date还有五个is_XXX()函数，用于检验日期是否是一个特殊日期，它们是：

```
is_infinity() : 是否是一个无限日期
is_neg_infinity():是否是一个负无限日期
is_pos_infinity():是否是一个正无限日期
is_not_a_date():是否是一个无效日期
is_special():是否是任意一个特殊日期
```

#### 1.3.1.3 日期的输出
> date对象可以很方便地转换成字符串，它提供了三个自由函数：
> to_simple_string(date d): 转换为YYYY-mmm-DD格式的字符串，其中的mmm为3字符的英文月份名。
> to_iso_string(date d):转换为YYYYMMDD格式的数字字符串；
> to_iso_extended_string(date d):转换为YYYY-MM-DD格式的数字字符串
> date也支持流输入输出，默认使用YYYY-mmm-DD格式。

```
date d(2008, 11, 20);

cout << to_simple_string(d) << endl; //2008-Nov-20
cout << to_iso_string(d) << endl; //20081120
cout << to_iso_extended_string(d) << endl; //2008-11-20
cout << d << endl; //2008-Nov-20
```

#### 1.3.1.4 与tm结构的转换

> date支持与C标准库中的tm结构相互转换，转换的规则和函数如下：

> to_tm(date):date转换到tm。tm的时分秒成员（tm_hour, tm_min, tm_sec）均置为0，夏令时标志tm_isdst轩为-1（表示未知）

> date_from_tm(tm datetm):tm转换到date。只使用年、月、日三个成员（tm_year, tm_mon, tm_mday），其他成员均被忽略。

```
date d(2010, 2, 1);

tm t = to_tm(d);
assert(t.tm_hour == 0 && t.tm_min == 0);
assert(t.tm_year == 2010 && t.tm_mday == 1);

date d2 = date_from_tm(t);
assert(d == d2);
```

#### 1.3.1.5 日期长度

> 日期长度是以天为单位的时长，是度量时间长度的一个标量。它与日期不同，值可以是任意的整数，可正可负。基本的日期长度类是date_duration.

> date_duration可以使用构造函数构建一个日期长度，成员函数days()返回时长的天数，如果传入特殊时间枚举值则构造出一个特殊时长对象。is_special()和is_negative()可以判断date_duration对象是否为特殊值、是否是负值。unit()返回时长的最小单位，即date_duratin(1)。

> date_duration支持全序 比较操作（== != < <=）等，也支持完全的加减法和递增递减操作，用起来很像一个整数。此外data_duration还支持除法运算，可以除以一个整数，但不能除以另一个date_duration。

> date_time库为date_duration定义了一个常用的typedef::days，这个新名字更好地说明了date_duration的含义，它是一个天数的计量。

```
days dd1(10) dd2(-100) dd3(255);

assert(dd1 > dd2 && dd1 < dd3);
assert(dd1 + dd2 == days(-90));
assert((dd1+dd3).days() == 265);
assert(dd3/5==days(51));

```

> date_time还提供了months、years、weeks等另外三个时长类，分别用来表示n个月、n个年和n个星期，它们的含义与days类似，但行为不太相同。

> months和years全面支持加减乘除运算，使用成员函数number_of_months()和number_of_years()可获得表示的月数和年数。weeks是date_duration的子类，除了构造函数以7为单位外，其他的行为与days的相同。

```
weeks w(3); //3个星期
assert(w.days() == 21) ;

months m(5);  //5个月

years y(2);   //2年

months m2 = y + m ; //2年零5个月

assert(m2.number_of_months() == 29);
assert((y * 2).number_of_years() == 4); 

```

#### 1.3.1.6 日期运算

> date支持加减运算，两个date对象的加操作是无意义的，date主要是与时长概念配合运算。

> 日期与特殊日期长度、特殊日期与日期长度进行运算的结果也会是特殊日期。

> 在与months、years这两个时长类进行计算时要注意：如果日期是月末的最后一天，那么加减月或年会得到同样的月末时间，而不是简单的月份或者年份中1，这是合乎生活常识的。但当天数是月末的28、29时，如果加减月份到2月份，那么随后的运算就总是月末操作，天数信息就会丢失。

```
date d(2010, 3, 30);
d -= months(1);  //2010-2-28,变为月末端，原30的日期信息丢失
d -= months(1);  //2010-1-31
d += months(2);  //2010-3-31
```

> 使用days不会出现同样的问题，如果担心weeks、months、years这些时长类被无意使用进行而扰乱了代码，可以undef宏BOOST_DATE_TIME_OPTIONAL_GREGORIAN_TYPES,这将使用date_time库不包含定义头文件<boos/date_time/date_duration_types.hpp>

#### 1.3.1.7 日期区间

> date_time库使用date_period类来表示日期区间的概念，它时时间轴上的一个左闭右开区间，端点是两个date对象。区间的左值必须小于右值，否则date_period将表示一个无效的日期区间。

> date_period可以指定区间的两个端点构造，也可以指定左端点再加上时长构造，通常后一种方法比较常用，相当于生活中从某天开始的一个周期。如：

```
date_period dp1(date(2010, 1, 1), days(20));
date_period dp2(date(2010,1,1), date(2009, 1, 1)); //无效
date_period dp3(date(2010,3,1), days(-20)); //无效
```

> 成员函数begin()和last()返回日期区间的两个端点，而end()返回last()后的第一天，与STL中的end()含义相同，是一个“逾尾的位置”。length()返回日期区间的长度，以天为单位。如果日期区间在构造时使用了左大右小的端点或者日期长度是0，那么is_null()函数将返回true。

```
date_period dp(date(2010, 1, 1), days(20));

assert(!dp.is_null());
assert(dp.begin().day() == 1);
assert(dp.last.day() == 20);
assert(dp.end().day() == 21);
assert(dp.length().days() == 20);
```


