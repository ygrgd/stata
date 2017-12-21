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

