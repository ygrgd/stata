sysuse auto,clear
edit
sum price
sum price weight
scatter price weight /*price 纵轴*/
line price weight,sort /*不加sort会乱*/
***** 生成新数据
clear
set obs 1000 //设置1000个数值，下一步会生成x=1-1000
gen x=_n
gen y=x+100

set more off
list
***** 

by f:sum p w //以foreign排序，对price和weight求和
sort f //数据表中按照foreign排序
by f:sum p w
by foreign, sort: sum price weight //上两步 合并计算
sort p //升序排列
gsort -p //降序排列
gsort foreign -price //先保证f按照国内国外排序，然后内部按照价格排序

****2.5 赋值及运输 exp
gen nprice = price + 10
list p np
replace nprice = nprice - 10 //赋值并替换

*****2.6 条件表达式 if exp
list price if foreign==0
list make price if foreign==0
list make price if foreign==1 & price>10000 //&表示和
list make price if foreign==1 | price>10000 //|表示或

*****2.7 范围筛选in range 
sort price
sum price in 1/5 //从1 到5 的意思，
sum price in 1/10 if foreign==0 //前10 台车中的国产车的平均价格

*****2.8 加权weight
clear
input score	num
650 	193
649 	 26
648 	 23
647 	 16
646 	 21
645 	 26
644 	 32
643 	 23
642 	 38
641 	 29
640 	 38
end
sum score
sum score [weight=num] /*加权计算，比较该结果与sum score 的区别，
实际上，不用权重选项时，相当于权重相等。*/

*****2.9 其他可选项,options
sum score, detail //可以简写为d，显示百分位数，最小最大5个数
sysuse auto, clear
list price in 1/30, sep(10) //每10 个观察值之间加一横线
list price in 10/30, sep(2) //每2 个观察值之间加一横线
list price, nohead //不要表头

*****3.1.2 从网络获取数据
webuse nlswork, clear //与前一命令等价，从STATA 官方数据库获取数据

*****3.2.1 数值变量：
clear
set obs 1 //将设定一个观察值
gen a=1 //生成一个新变量a,令a 取值为1
d /*d 为describ 命令的略写，describ 命令显示数据集的
属性信息，注意观察显示结果中，a 的storage type 为float 型，
浮点型为默认类型*/
. compress //在不损害信息的基础上压缩，使数据占用空间尽可能小
replace a=101 /* 注意a 的storage type 现在自动升为int 型，
因为byte 最大只能为100*/
. replace a=100
. compress
. d //重新变回到byte 型
. replace a=32741 //直接变到long 型,因为int 型最大只能到32740
. gen double b=1 //直接生成双精度变量b
. recast  double a //将a 变成双精度变量b
. d //注意到a 和b 均为双精度型

******3.2 数据类型**************************************************

webuse nlswork, clear
mvencode age,mv(-9996) //把缺失值转换成-9996
. mvdecode age,mv(-9996) //把-9996转换成空值

******3.3 数据类型转化
webuse destring1, clear
d //10个观测值，5个变了，全为字符
destring, replace //全部转换为数值型，replace 表示将原来的变量（值）更新
d

将字符型数据转换为数值型数据：去掉字符间的空格--

webuse destring2, clear
des //注意到所有的变量均为字符型 str,日期有空格，金额有美元符号，p有百分号
list date //注意到date 年月日之间均有空格
destring date, replace ///*由于含有非数值型字符
（即空格），因此没有更新，也即转换命令没有执行。*/
destring date, replace ignore(“ ”)
des //注意到date 的storage type 已变为long
list date //注意到空格消失了
destring price percent, gen(price2 percent2) ignore(“$ ,%”)

destring price,replace ignore("$")  //没有成功
destring percent,replace ignore("%") //成功

*******3.3.2 数值型转化为字符型：tostring
webuse tostring,clear 
des //注意到month 为字符型，而年和日为数值型
list
tostring year day, replace //将年和日转化为字符型
gen date1=month+"/"+day+"/"+year
gen date2=date(date1,"MDY") // date（）为日期函数，注意大小写
list //新生成的date2 表示总天数
format date2 %tddmy 
gen a=string(s1, "%12.0f") 如果格式不对，可以用这个办法转换
di date("1975/12/27","ymd") /*小游戏：请算算你活了多少天？示例：一个生于1975 年12 月27 日的家伙，
他活了？*/



*****3.4 数据显示格式:format
webuse census10,clear
format state %-14s // 数表示位数，s表示类型，-左对齐，没-表示右对齐
format region %-8.0g
format pop %11.0gc //后面加个c表示分位符，comma
format medage %8.1f //8.1表示8位数，1位小数



gen id=_n //生成一个新变量id，取值依次为1，2，3
replace id=9842 in 3
format id %5.0f  //正常显示

format id %05.0f //05表示，5位数，补足的前面用0补全
 

***************4.1 拆分与连接数据文件要掌握的命令
/*
命令 命令解释 用法示例
drop 删除变量或观察值 drop math
keep 保留变量或观察值 keep math
append 将两个数据集拼接(观察值拼接) append using math
merge 将两个数据集合并（变量合并） merge id using math
reshape 将数据重整 reshape long inc,i(id) j(yr)
stack 将多列数据转换成一列数据 stack a b c d, into(e f)
xpose 数据转置 xpose, clear
reshape 将数据重整 reshape long inc,i(id) j(yr)

*/
******************4.4.2 案例:面板数据重整

input id str10 name math2003 math2004 economy2003 economy2004 //注意name前的str1
1 John 40 13 68 55
2 Chris 80 64 52 87
3 Jack 90 55 76 25
4 Huang 43 60 90 4
5 Tom 70 68 96 42
6 Han 53 10 85 89
7 Phillip 85 61 36 52
8 Jin 95 6 65 84
end
reshape long math economy,i(id name)j(year) //重整
reshape wide math economy,i(id name)j(year)

keep if year == 2003
keep id math
xpose, clear //转置


scalar a="我爱" +"STATA" //要特别注意，引号必须是半角和英文模式
. scalar list a //scalar 命令将两个字符运算后的结果赋于a，然后显示a


input age
age
38
.
65
42
18
80
end
gen a = (age>=65)
gen b =(age>=65) if age<.
gen c =(age==65) if age<.

****************6.2 创造自己的命令：与STATA 互致问候

capture program drop hello
program hello
display "你好,老兄" //请注意引号一定要在中文状态下输入
end



