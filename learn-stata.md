
##### 注释方法
- 整行注释，开头写 * 或者 //
- 结尾注释，结尾写 //
- 多行注释，开头结尾写/*
- 长命令换行，结尾写 ||///

##### 开头结尾设置
为了使do文件能够顺利工作，一般需要编辑do文件的“头”和“尾”。这里给出我使用的“头”和“尾”。
　　/*（标签。简单记下文件的使命。） */
　　capture clear 
　　（清空内存中的数据）
　　capture log close
　　（关闭所有打开的日志文件）
　　set mem 128m
　　（设置用于stata使用的内存容量）
　　set more off
　　（关闭more选项。如果打开该选项，那么结果分屏输出，即一次只输出一屏结果。你按空格键后再输出下一屏，直到全部输完。如果关闭则中间不停，一次全部输出。）
　　set matsize 4000
　　（设置矩阵的最大阶数。我用的是不是太大了?）
　　cd D：
　　（进入数据所在的盘符和文件夹。和dos的命令行很相似。）
　　log using （文件名）．log，replace （打开日志文件，并更新。日志文件将记录下所有文件运行后给出的结果，如果你修改了文件内容，replace选项可以将其更新为最近运行的结果。）
　　use （文件名），clear　（打开数据文件。）
　　（文件内容）
　　log close
　　（关闭日志文件。）
　　exit，clear
　　（退出并清空内存中的数据。）
　　这个do文件的“头尾”并非我的发明，而是从沈明高老师那里学到的。版权归沈明高老师。（待续）

##### log文件使用
cd E:\git\stata\logfile 切换目录
log using 20171221 在目录下创建log文件
log close

##### 数据类型
- 1、数值 byte,int,long,float,double
d = describe 显示数据类型
compress 压缩数据
recast double x  将x变成double类型
字符
"""" 表示缺失值
"" "" 表示空值
日期
1960年1月1日为0天，往前为-1，往后为1

数值转字符：destring xx,replace
字符转数值：tostring xx,replace
destring, replace 字符串转数值

- 2、日期的转换 date函数
假设数据格式为may 15 2017，一个字符和两个数值
tostring day year，replace 全部转换成str
gen date1=month+"/"+day+"/"+year 生成一个字符串
gen date2=date(date1,"mdy")  mdy表示 month day year
gen a=string(s1, "%12.0f") 设置日期


- 3、显示格式
format var %-14s/g/gc/f
负号表示左对齐，无负号表示右对齐，数字表示显示位数，数字前加0表示用0补全长度
s表示类型，g不知道，c表示加分节符，f不知道

- 4、数据清洗
命令 命令解释 用法示例
drop 删除变量或观察值 drop math
keep 保留变量或观察值 keep math
append 将两个数据集拼接(观察值拼接) append using math
merge 将两个数据集合并（变量合并） merge id using math
reshape 将数据重整 reshape long inc,i(id) j(yr) 比较重要
stack 将多列数据转换成一列数据 stack a b c d, into(e f)
xpose 数据转置 xpose, clear
reshape 将数据重整 reshape long inc,i(id) j(yr)

把数据转换成布尔，gen a =(age>=65) if age<.

-5、数学运算 


- 6、程序
创建简单的程序 
capture program drop hello //表示如果有了hello命令就丢掉，没有就忽略
program hello
display "你好,老兄" //请注意引号一定要在中文状态下输入
end

保存为ado文件，重启后就还能用


