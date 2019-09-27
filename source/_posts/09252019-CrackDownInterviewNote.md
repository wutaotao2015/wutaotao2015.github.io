---
title: CrackDownInterviewNote
categories: Interview
tags:
  - Interview
image: 'http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190925_1.jpg'
updated: 2019-09-27 14:57:07
date: 2019-09-25 22:02:43
abbrlink:
---
CrackdownInterview note
<!-- more -->
## big O

### 一个类比
一个大文件进行远距离传输，用网络传输是O(size), 传输时间随文件大小线性增长;
直接使用飞机或其他物理方式传输是O(1), 即传输时间不受文件大小影响，是一个常量。
可以看到，无论这个常量多么巨大，线性增长速度多慢，线性增长总会在某个时间点超过常量时间。

### 时间复杂度 
学术界:
O(n) big O 代表一个算法的上界，即最慢需要的时间，如O(n^2), O(2^n)等。
Ω(n) big Omega代表一个算法的下界，即最快需要的时间，如Ω(1), Ω(log N)等。
θ(n) big Theta 同时代表上下界，给出了运行时间的闭合区间。
工业界:
通常用O(n)来说明Θ(n)的范围，即工业界说O(n)指的是一个闭合区间。如说某个算法是O(n)，实际上
指的是其上下界都是O(n)级别。

上面的参数代表了运行时间随输入规模的增长速度，对于个别的输入数据，有最快测试案例，最慢测试
案例和中等测试案例。

### 空间复杂度
有时空间占有程度不随调用次数递增(如递归就是每调用一次就增加一个调用栈，为O(n)), 有的方法
调用完成后就释放了相应的空间，所以总的空间复杂度实际为O(1).

### 去除常量
O(2n)相当于O(n)，因为O(n)只是描述了时间或空间的增长速度。
需要记住的是O(n)级别的算法并不总是比O(n^2)级别算法快。

### 去除不重要的项
如O(n^2 + n)等同于O(n^2), O(n + log n)等同于O(n).

### 多步骤算法: 数量级的加法和乘法
1. 先做A，做完后再做B,就是加法O(A + B).2个独立的循环
2. 在做A的时候，每一步都要做B,就是乘法O(A * B). 循环嵌套。

### 平摊的时间 
ArrayList是一个动态数组实现的列表。那么插入一个新元素需要多大的数量级呢？
如果数组全满了，需要扩容一倍，将现有元素复制到新数组后再插入，需要O(n).如果没满，只需要O(1)
即可。如何得到平均值？这时我们就需要用到时间的分摊。

我们知道数组的大小是翻倍增长的，大小为1, 2, 4, 8..., 所以插入x个元素的总时间为
1+2+4+8+...+x, 这个求和算式可以反过来看即x+x/2+x/4+...+1, 可以看到大小约为2x.
所以平均插入一个元素的时间为2x/x = 1即O(1).
注： 求解1 + 2 + 2^2 + 2^3 + ... + 2^n的和，还可以通过二进制来计算，即1 + 10 + 100 + 
1000 + ...  + 1...0(n个0) = 1...1(n个1), 即2^(n + 1) - 1. 

再注: 高斯求和 1+2+3+...+n, 当n是奇数时，n和1配对，有n/2对和为(n+1)的数据对，和为n(n+1)/2;
当n是偶数时，n和0配对，有(n+1)/2对和为n的数据对，和也为n(n+1)/2.

### Log N 级别的运行时间 
二分查找法为什么是log N级别？
二分查找法在已经排好序的数列中每次选择中间值进行比较，比较过后砍去一半值，这样需要查找的
范围就缩小了一半，X, X/2, X/4,..., 1, 如何得到需要比较的次数？
同上面求ArrayList插入元素的性能类似，可以反过来看，从1开始递增，1,2,4, ..., X, 每次都乘2
最后得到X, 即2^n = X, 从而可以得到需要比较的次数为n = logX, 即log N级别。

注: 对数换底公式推导。loga P = V, 求logbP? 
loga P = V;  (1) =>  P = a^V;
使用底数b两边求对数:
logb P = logb a^V; 
=> logb P = V * logb a;
=> logb P / logb a = V; 
同时一开始有loga P = V;  (1)
所以得出 loga P = logb P / logb a;

从换底公式可以看出对于任意的底数都可以使用换底公式进行转换，这样不同数量级间就只相差一个
1/logb a的常量因子，不影响数量级。

### Recursive Runtimes
如下的递归函数的时间复杂度是多少？
```txt
int f(n) {
 if (n <= 1) return 1; 
 return f(n - 1) + f(n - 1);
}
```
每次递归调用都调用了2次f函数，所以总的调用次数为1 + 2 + 2^2 + 2^3 + ... 2^n = 2^(n+1) - 1.
所以这个函数的时间复杂度为O(2^n).
一般来说，递归的数量级是O(branches^depth), branches为每次递归调用的调用次数，depth为递归
调用栈的深度。
注: 和logN数量级不同，指数的底数不能被忽略，如2^n和8^n，因为8^n = 2 ^ 3n = 2^n * 2^2n, 
这里的因子为2^2n，不是常量，无法被忽略。

这个函数的空间复杂度为O(n)。

注: 经测试f(n - 1) + f(n - 1)的耗时和2 * f(n - 1)是不一样的！！！后者明显快很多(在n = 30时)，
所以编写代码时应尽量优化算式，尽可能减少显式调用。

再注: 如果分支是1, 如f(n)只调用了f(n - 1)，此时如果套用公式是O(1)常量时间，显然是不对的。
同前面计算分支数为2时一样，这里每次递归调用都为1次，所以总次数为1 × n = n次，所以时间复杂度
为O(n). 从这里也可以看出，递归调用的时间随着分支数的增加是非常迅猛的增加的, O(N),
O(2^N), O(3^N)...

再注: 尾递归
普通的递归方法在递归调用结束后还需要执行其他语句，所以调用前需要保留当前栈(方法)的环境以供
调用方法返回后进一步处理，而尾递归调用中方法调用结束后无需进行其他处理，所以不需要保存当前栈
的环境，直接返回上一步即可(这种直接覆盖调用栈的机制称为尾调用优化TCO: Tail Call Optimization，
Java编译器不支持TCO, C编译器支持TCO, 所以Java中可以使用循环，C语言使用尾递归)。

普通递归容易产生栈溢出，而尾递归只存在一个调用记录，所以永远不会发生栈溢出的问题。
不过尾递归需要额外的变量来保存每一次调用的中间结果，它以这种方式来得到最终结果。
因为尾递归不需要保存当前的栈环境，所以它只占用恒定大小的内存。
```txt
function f(x) {
  let y = g(x);  
  return y;
}
```
这种情况也不算尾调用, 因为递归完成后还需要进行赋值操作，即使它和直接`return g(x);`语义相同。

尾递归例子，计算阶乘。
```txt
// 普通递归
function fac(n) { 
  if (n <= 0) return 1;   
  return n * fac(n - 1);
}
fac(5);

// 尾递归
function facTail(n, total) { 
  if (n <= 0) return 1;   
  return facTail(n - 1, n * total);
}
facTail(5, 1);   // total初始值为1，保存每次调用时得到的中间结果
```
将一般的递归方法改造成尾递归时，将所有的中间变量改写为函数参数，在方法最后直接调用自身即可。
另外对于外界调用者来说调用facTail(5, 1)得到5！的值有时很费解，可以用以下2种办法解决:
```txt
1. 外面再套一层函数
function int fac(int n){
  return facTail(n, 1); 
}
或者
function seal(fn, n) {
  return function(m) {
    return fn.call(this, m, n); // 这里利用闭包特性保存了fn中的参数作为m  
  } 
}
const ff = seal(facTail, 1); // total = 1
ff(5);
2. 使用函数式编程中的柯里化的概念，将多参数变为单参数，返回由剩下参数组成的函数
// 柯里化函数
function curry(fn) {
    var args = Array.prototype.slice.call(arguments, 1);
    return function () {
        var innerArgs = Array.prototype.slice.call(arguments);
        var finalArgs = innerArgs.concat(args);
        return fn.apply(null, finalArgs);
    }
}
var factorial = curry(facTail, 1); 
factorial(5);

// jdk 8 λ表达式的柯里化
Function<Integer, Supplier<Integer>> curry = x -> () -> facTail(x, 1);
curry.apply(5).get();  // 按照箭头顺序从左到右执行
```

### 例子和练习
1. 
```txt
for(int i = 0; i < a.length; i++) {
  for(int j = 0; j < b.length; j++) {
    if (b[j] < a[i]) {
      System.out.println(a[i] + ", " + b[j]); 
    } 
  } 
}
```
if语句本身是O(1), 所以整体的时间复杂度为O(ab)，不是O(N^2), 因为这不是1个输入，2个不同的
输入都有影响。
注: 如果if语句换成for(int k = 0; k < 100000; k++){....}, 复杂度仍然是O(ab), 常量不影响，
无论它有多大...

2. O(n + p) 当p < n/2时，n占据主导地位，p可以舍去，所以O(n + p)与O(n)数量级相同。
同理O(n + logN), O(2n)都相同，而O(N + M)因为M与N关系不明，所以无法等同于O(N).

3. 有一个字符串数组，如果需要先对其中每个字符串进行排序，然后对整个数组排序，它的时间复杂度
是多少?

这里最大的错误就是简单的用O(n)之类的表达式来表示，因为它有2个输入集合(与题1一样)，数组的
长度a和最大字符串的长度s。
  1. 字符串排序，快排实现复杂度为O(slog s), a个元素就是O(a * slog s);
  2. 数组排序，这里不是简单的O(alog a), 因为字符串比较与字符或数字比较不同，它不是常量时间，
而是线性的O(s), 所以数组排序为O(s * a log a);
  3. 总体排序时间是用加法，即O(as * (log a + log s));

4. 二叉查找树所有结点值的和
```txt
int sum(Node n){
  if (n == null) return 0; 
  return sum(n.left) + n.value + sum(n.right);
}
```
  1. 从算法的含义看，由于要加上所有节点的和，所以每个节点都会被遍历一次，所以复杂度即O(N). 
  2. 从递归模型看，前面说到O(branches^depth), branches = 2, 由于是二叉查找树，前面计算过
二叉查找树(从1累乘2到n)需要的次数为logN，即它的高度depth=logN, 所以为O(2^logN) = O(N).

5. 判断一个数是不是质数。
如33 = 11 * 3; 11 > sqrt(33), 这意味着如果33可以整除一个比它的平方根大的数，那么它一定也可以
整除一个比平方根小的数，如这里的3.
所以可以这样判断是否是素数:
```txt
boolean isPrime(int n) {
  for (int x = 2; x * x <= n; x++) {
    if (n % x == 0) return false;
  }
  return true;
}
```
这个方法的复杂度是O(sqrt(N)), N的二分之一次方。不能近似为O(N)!

6. 打印出一个字符串中所有字符的全排列all permutations of a string
下面这个算法巧妙利用了循环中的递归(类似深度优先排序)的方法实现了全排列:
```txt
void permutation(String str) {
  permutation(str, ""); 
  // 空前缀代表全排列，这里有值时最终结果是str所有排列前都有相同的前缀(由以下算法实现决定)
}
void permutation(String str, String prefix) {
  
  if (str.length() == 0) {
     System.out.println(prefix);  // 已无可排字符，打印出一种组合   
  }else{
     for (int i = 0; i < str.length(); i++) {
       String remainder = str.subString(0, i) + subString(i+1); // 挖掉str.charAt(i)
       permutation(remainder, prefix + str.charAt(i));   
       // 每次排好(挖掉)一个后，继续排列剩余部分 
     }
  }
}
```
如何计算它的时间复杂度?
循环中套用递归，它的函数栈可以理解为一颗巨大的树。我们可以从一些特性出发得到该算法的一个
近似上界。

```txt
1. 计算permutation(String, prefix)调用的总次数。

  1. 先计算base permutation的次数，即执行了打印语句的permutation()方法的调用次数，也可以
理解为整棵树的叶子节点个数。

考虑所有排列的种数，对于长度为n的字符串，
第一个位置有n种选择，第一个位置排好后，对于第二个位置有n-1种选择(对应于前面第一个位置的
每种情况)，依次类推，可以得到全部排列的总数为n*(n-1)*(n-2)*... = n!.
因为每种排列都需要列出并打印，所以叶子节点个数为O(n!).

  2. 计算base permutation调用前调用permutation()方法的次数，即那些不满足打印条件未打印的
permutation方法调用次数，也可以理解为树中非叶子节点的个数。

可以从树的角度出发，一共有n!个叶子节点，每个节点到根节点的距离都是n(每次循环都挖掉(排列)
一个字符，得到最终的排列结果需要每个位置都排好，所以路径长度是n), 所以树的总节点个数不
超过n! * n个。

2. 计算每次permutation(string, prefix)方法调用消耗的时间。

对于打印语句执行的次数: str即remainder, 当remainder为空时就打印一次(由于循环中每次挖掉一个
字符), 即只剩一个字符时打印一次(当多于一个字符时str.length() > 0不满足条件不打印).
每个字符都要打印，所以打印语句的执行次数即为字符串的长度，为O(n).
同理，由于循环内每次循环都是挖掉一个字符，循环内的拼接字符串和递归调用也是执行O(n)次。
所以每次permutation方法执行的复杂度是O(n)。

3. 计算总共花的时间 
单此调用为O(n)次，总共需要调用O(n * n!)次，所以时间复杂度为O(n^2 * n!)。
```

7. 斐波纳契数列的复杂度
```txt
function fib(n) {
  if (n <= 0) return 0;
  if (n == 1) return 1;
  return fib(n - 1) + fib(n - 2);
}
```
由前面递归的公式得出时间复杂度为O(2^N), 高度为n(从n一直到1)
注: 更精确的上界为O(1.6^n).可由特征根方程得出。

8. 顺序打印斐波纳契数列中的数字
```txt
void allFib(int n) {
  for (int i = 0; i < n; i++) {
    System.out.println(i + ":" + fib(i));  
  } 
}
```
复杂度为1 + 2^1 + 2^2 + 2^3 +...+2^n = 2^(n+1);所以复杂度仍然为O(2^n);

## 










<hr />
<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20190925_1.jpg" class="full-image" />

