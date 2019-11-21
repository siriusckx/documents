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

#### 1.3.1.8 日期区间运算

> date_period同date、days一样，也支持很多运算。成员函数shift()和expand()可以变动区间：shift()将日期区间平移n天而长度不变，expand()将日期区间向两端延伸n天，相当于区间长度加2n天。

```
date_period dp(date(2010,1,1), days(20));

dp.shift(days(3));
assert(dp.begin().day() == 4);
assert(dp.length().days() == 20);

dp.expend(days(3));
assert(dp.begin().day() == 1);
assert(dp.length().days() == 26);
```

> date_period还可以使用成员函数判断某个日期是否在区间内，或者计算日期区间的交集：

```
is_before()、is_after():日期区间是否在日期前或后；
contains():日期区间是否包含另一个区间或者日期；
intersects():两个日期区间是否存在交集；
intersection():返回两个区间的交集，如果无交集返回一个无效区间；
is_adjacent():两个日期区间是否相邻；
```

```
date_period dp(date(2010,1,1), days(20)); //1-1 至 1-20
assert(dp.is_after(date(2009,12,1)));
assert(dp.is_before(date(2010,2,1)));
assert(dp.contains(date(2010,1,10)));
assert(dp.intersects(dp2));
assert(dp.intersection(dp2) == dp2);

date_period dp3(date(2010, 1, 21), days(5)); //1-21 至 1-26
assert(!dp3.intersects(dp2));
assert(dp3.intersection(dp2).is_null());
assert(dp.is_adjacent(dp3));
assert(!dp.intersects(dp3));

```

> date_period提供了两种并集操作：

```
merge(): 返回两个区间的并集，如果区间无交集或者不相信则返回无效区间；
span():合并两日期区间及两者间的间隔，相当于广义的merge()；
```

```
date_period dp1(date(2010,1,1), days(20));
date_period dp2(date(2010,1,5), days(10))
date_period dp3(date(2010,2,1), days(5));
date_period dp4(date(2010,1,15), days(10));

assert(dp1.contains(dp2) && dp1.merge(dp2) == dp1);
assert(!dp1.intersects(dp3) && dp1.merge(dp3).is_null());
assert(dp1.intersects(dp2) && dp1.merge(dp4).end() == dp4.end());
assert(dp1.span(dp3).end() == dp3.end());
```

#### 1.3.1.9 日期迭代器

> date_time库为日期处理提供了迭代器的概念，可以用简单的递增或者递减操作符连续访问日期，这些迭代器包括date_iterator、week_iterator、month_iterator和year_iterator,它们分别以天、周、月和年为单位增减。为了方便用户使用，日期迭代器还重载了比较操作符，不需要用解引用操作符就可以直接与其他日期对象比较大小。

```
date d(2006, 11, 26);
day_iterator d_iter(d);    //增减步长默认为1天

assert(d_iter == d);
++d_iter;     //递增1天
assert(d_iter == date(2006, 11, 27));

year_iterator y_iter(*d_iter, 3); //增减步长为3年
assert(y_iter == d + days(1));

++y_iter;         //递增3年
assert(y_iter->year() ==  2009);
```

### 1.3.2 处理时间

> date_time库在格里高利历的基础上提供微秒级别的时间系统，但如果需要，它最高可以达到纳秒级别的精确度。

> 需要包含头文件：

```
#include <boost/date_time/posix_time/posix_time.hpp>
```

#### 1.3.2.1 时间长度

> 与日期长度date_duration类似，date_time库使用time_duration度量时间长度。time_duration很像C中tm结构的时分秒部分，可以度量基本的小时、分钟和秒钟，在秒以下精确到微秒。如果在头文件`<boost/date_time/posix_time/posix_time.hpp>`之前定义了宏`BOOST_DATE_TIME_POSIX_TIME_STD_CONFIG`，那么它可以精确到纳秒级。

#### 1.3.2.2 操作时间长度

> time_duration可以在构造函数指定时分秒和微秒来构造，例如创建一个1小时10分钟30秒1毫秒（1000微秒）的时间长度。

```
time_duration td(1, 10, 30, 1000);
```

> 为了方便使用， time_duration也有几个子类，可以度量不同的时间分辨率，分别是：hours、minutes、seconds、millisec/milliseconds、microsec/microseconds和nanosec/nanoseconds。

```
hours h(1);
minutes m(10);
seconds s(30);
millisec ms(1);

time_duration td = h + m + s + ms;
time_duration td2 = hours(2) + seconds(10);
```

>使用工厂函数duration_from_string(), time_duration也可以从一个字符串创建，字符串中的时、分、秒和微秒需要用冒号隔开。

```
time_duration td = duration_from_string("1:10:30:001");
```

>time_duration里的时分秒可以用hours()、minutes()和seconds()成员函数访问。total_seconds()、total_milliseconds()和total_microseconds()分别返回时间长度的总秒数、总毫秒数和总微秒数。fractional_seconds()以long返回微秒数。

> time_duration支持完整的比较操作和四则运算，因此它处理起来比date对象更加容易。如果想要得到time_duration对象的字符串表示，可以使用自由函数to_simple_string(time_duration) 和 to_iso_string(time_duration),它们分别返回HH::MM::SS.fffffffff和HHMMSS,fffffffff格式的字符串。如：

```
time_duration td(1, 10, 30, 1000);
cout << to_simple_string(td) << endl; // 01:10:30.001000
cout << to_iso_string(td) << endl;   // 011030.001000
```

> time_duration也可以转换到tm结构，同样使用to_tm()函数，但不能进行反向转换。

#### 1.3.2.3 时间长度的精确度

> date_time库默认时间的精确度是微秒，纳秒相关的类和函数如nanosec和成员函数nanoseconds()、total_nanoseconds()都不可用，秒以下的时间度量都使用微秒。当定义了宏BOOST_DATE_TIME_POSIX_TIME_STD_CONFIG时，time_duration的一些行为将发生变化，它的时间分辨率将精确到纳秒，构造函数中秒以下的时间度量单位也会变成纳秒。

```
#define BOOST_DATE_TIME_POSIX_TIME_STD_CONFIG //定义纳秒精度宏
#define BOOST_DATE_TIME_SOURCE
#include <boost/date_time/posix_time/posix_time.hpp>

time_duration td(1, 10, 30, 1000);  //1000纳秒， 即1微秒
assert(td.total_milliseconds() == td.total_seconds() * 1000); //计算总毫秒数时微秒将被忽略
```

> 成员函数fractional_seconds()仍然返回秒的小数部分，但单位是纳秒，这也是它的名称不叫milli_seconds()或者nano_seconds()的原因。

>time_duration提供静态成员函数resolution()和num_fractional_digits()来检测当前的精度：
>resolution()可以返回一个枚举值time_resolutions,表示时间长度的分辨率；
>静态成员函数num_fractional_digits()返回秒的小数部分的位数（微秒6位，纳秒9位）
```
assert(td.resolution() == date_time::nano);
assert(td.num_fractional_digits() == 9);
```

#### 1.3.2.4 时间点

>ptime是date_time库处理时间的核心类，它使用64位（微秒级别）或者96位（纳秒级别）的整数在内部存储时间数据，依赖于date和time_duration，因此接口很小。
>ptime同date一样，也是一个轻量级的对象，可以被高效地任意拷贝赋值，也支持全序比较和加减运算。

#### 1.3.2.5 创建时间点对象

> 最基本的创建ptime的方式是在构造函数中同时指定date和time_duration对象，令ptime等于一个日期加当天的时间偏移量。如果不指定time_duration,则默认为当天的零点。如：

```
using namespace boost::gregorian;
ptime p(date(2010,3,5), hours(1));  //2010年3月5日凌晨1时
```

>ptime也可以从字符串构造，使用工厂函数time_from_string()和from_iso_string().前者使用分隔符分隔日期时间成分，后者则是连续的数字，日期与时间用字母T隔开。

```
ptime p1 = time_from_string("2010-3-5 01:00:00");
ptime p2 = from_iso_string("20100305T010000");
```

>date_time库为ptime也提供了时钟类，可以从时钟产生当前时间。因为时间具有不同的分辨率，有两个类second_clock和microsec_clock分别提供秒级和微秒级的分辨率，它们的接口是相同的，local_time()获得本地当前时间，universal_time()获得UTC当前时间。

```
ptime p1 = second_clock::local_time();        //秒精度
ptime p2 = microsec_clock::universal_time();  //微秒精度
```

#### 1.3.2.6 操作时间点对象

> 由于ptime相当于date+time_duration，因此对它的操作可以分解为对这两个组成部分的操作。ptime使用date()和time_of_day()两个成员函数获得时间点中的日期和时间长度，然后进行分别处理。

```
ptime p(date(2010,3,20), hours(12) + minutes(30));

date d =p.date();
time_duration td = p.time_of_day();
assert(d.month() == 3 && d.day() == 20);
```

> ptime提供了三个自由函数转换为字符串，分别是：

```
to_simple_string(ptime);  //转换为YYYY-mmm-DD HH:MM:SS.fffffffff 格式
to_iso_string(ptime); //转换为 YYYYMMDDTHHMMSS,fffffffff格式；
to_iso_extended_string(ptime); //转换为YYYY-MM-DDTHH:MM:SS,fffffffff格式
```

#### 1.3.2.7 与tm、time_t等结构的转换

> 使用自由函数to_tm()，ptime可以单向转换到tm结构，转换规则是date和time_duration的组合。例如：

```
ptime p(date(2010,2,14), hours(20));
tm t = to_tm(p);
```

> 没有一个叫做time_from_tm()的函数可以把tm结构转换成ptime，这与date对象的date_from_tm()是不同的。如果想要把tm转成ptime,可以使用date_from_tm()得到date对象，然后手工操作tm结构得到time_duration对象，最后创建出ptime。另两个函数from_time_t(time_t)和from_ftime\<ptime\>(FILETIME),它们可以从time_t和FILETIME结构创建出ptime对象。这种转换也是单向的，不存在逆向的转换。

#### 1.3.2.8 时间区间

> 与日期区间date_period对应，date_time库也有时间区间的概念，使用类time_period,使用ptime作为区间的两个端点，同样是左闭右开区间。

> time_period的用法与date_period的基本相同，可以用begin()和last()返回区间的两个端点，length()返回区间的长度shift()和expand()变动营销部，也能计算时间区间的交集和并集，就像是date_period的一个时间分辨率的增强版。因此，time_period的详细操作函数可参考date_period。

```
ptime p(date(2010,1,1), hours(12)); //2010年元旦中午
time_period tp1(p, hours(8)); //一个8小时的区间
time_period tp2(p+hours(8), hours(1)); //1小时的区间

assert(tp1.end() == tp2.begin() && tp1.is_adjacent(tp2));
assert(!tp1.intersects(tp2)); //两个区间相令但不相交

tp1.shift(hours(1));   //tp1 平移1小时
assert(tp1.is_after(p)); //tp1在中午之后
tp2.expand(hours(10));//tp2向两端扩展10个小时

assert(tp2.contains(p) && tp2.contains(tp1)); 
```

#### 1.3.2.9 时间迭代器

> 不同于日期迭代器，时间迭代器只有一个time_iterator.它在构造时传入一个起始时间点ptime对象和一个步长time_duration,然后就同日期迭代器一样使用前置式operator++、operator--来递增或递减时间，解引用操作符返回一个ptime对象。time_iterator也可以直接与ptime比较，无须再使用解引用操作符。以下代码使用时间迭代器以10分钟为步长打印时间：

```
ptime p(date(2010,2,27), hours(10));
for(time_iterator t_iter(p, minutes(10)); t_iter < p + hours(1) ; ++t_iter)
{
    cout << *t_iter << endl;
}
```

### 1.3.3 date_time库的高级议题

#### 1.3.3.1 格式化时间
> date_time库默认的日期格式简单、标准且是英文。date_time库提供了专门的格式化对象date_facet、time_facet等来搭配IO流，定制日期时间的表现形式。这些格式化对象就像是printf()函数，使用一个格式化字符串来定制日期或时间的格式，也同样有大量的格式标志符。示范格式化的使用、把日期格式化为中文显示的代码如下：

```
date d(2010, 3, 6);
date_facet* dfacet = new date_facet("%Y年%m月%d日");
cout.imbue(locale(cout.getloc(), dfacet));
cout << d << endl;

time_facet *tfacet = new time_facet("%年%m月%d日%H点%M分%S%F秒");
cout.imbue(locale(cout.getloc(), tfacet));
cout << ptime(d, hours(21) + minutes(50) + millisec(100)) << endl;

//输出结果如下
2010年03月06日
2010年03月06日21点50分00.001秒
```

#### 1.3.3.2 本地时间

> 之前对date_time库的讨论都基于简单的时间，通常对于日常工作和生活是足够的，但如果考虑到世界各地不同时区的因素，时间就变得复杂了，两个不同时区对同一个时间点的日期和时间表示可能会不同，如果再加上某些地区的夏令时因素就更加复杂了。

> date_time库使用time_zone_base、posix_time_zone、custom_time_zone、local_date_time等类和一个文本格式的时区数据库来解决本地时间中时区和夏令时的问题。

> 本地时间功能位于名字空间boost::local_time，为了使用本地时间功能，需要包含头文件\<boost/date_time/local_time/local_time.hpp\>

> time_zone_base是时区表示的抽象类，通常我们使用一个typedef:time_zone_ptr,它是一个指向time_zone_base的智能指针。

> local_date_time是一个含有时区信息的时间对象，它可以由date+time_duration+时区构造，构造时必须指定这个时间是否是夏令时，本地时间在内部以UTC的形式保存以方便计算。

#### 1.3.3.3 序列化

> date_time库可以使用boost::serialization库的能力实现数据序列化，把日期时间数据存入某个文件，之后在任意的时刻读取恢复，如同流操作一样简单方便。