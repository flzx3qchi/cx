# 介绍及其问题

如何访问到 IO 接口呢？
答案就是 **IO 接口上面有一些寄存器，访问 IO 接口本质上就是访问这些寄存器**，这些寄存器就是人们常说的端口。这些端口是人家 IO 接口给咱们提供的接口。人家接口电路也有自己的思维（系统），看到寄存器中写了什么就做出相应的反应。

用户态与内核态是对 CPU 来讲的，是指 CPU 运行在用户态（特权 3 级）还是内核态（特权 0 级），很多人误以为是对用户进程来讲的。

**用户进程陷入内核态是指**：由于内部或外部中断发生，当前进程被暂时终止执行，其上下文被内核的中断程序保存起来后，开始执行一段内核的代码。是内核的代码，不是用户程序在内核的代码，用户代码怎么可能在内核中存在，所以**“用户态与内核态”是对 CPU 来说的**。

当应用程序陷入内核后，它自己已经下 CPU 了，以后发生的事，应用程序完全不知道，它的上下文环境已经被保存到自己的 0 特权级栈中了，那时在 CPU 上运行的程序已经是内核程序了。所以要清楚，**内核代码并不是成了应用程序的内核化身，操作系统是独立的部分**，用户进程永远不会因为进入内核态而变身为操作系统了。

1M 是 2 的 20 次方，1MB 内存需要 20 位的地址 才能访问到，
如何做到用 16 位寄存器访问 20 位地址空间呢？
在 8086 的寻址方式中，**有基址寻址**，这是用基址寄存器 bx 或 bp 来提供偏移地址的，如“mov [bx]，0x5；”指令便是将立即数 0x5 存入 ds：bx 指向的内存。( **直接寻址**

 ![image-20201013164456919](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201013164456919.png)

这是因为 CPU 设计者在地址处理单元中动了手脚，该地址部件接到“**段基址+段内偏移地址**”的地址后，自动将段基址乘以 16，即左移了 4 位，然后再和 16 位的段内偏移地址相加，这下地址变成了 20 位了吧

**Section Headers**：列出了程序中所有的 section，这些 section 是 gcc 编译器帮忙划分的。
**Program Headers**：列出了程序中的段，即 segment，这是程序中 section 合并后的结果。
**Section to Segment mapping**：列出了一个 segment 中包含了哪些 section。

CPU 内部的段寄存器（Segment reg）如下。
（1）**CS—代码段寄存器（Code Segment Register）**，其值为代码段的段基值。
（2）**DS—数据段寄存器（Data Segment Register）**，其值为数据段的段基值。
（3）**ES—附加段寄存器（Extra Segment Register）**，其值为附加数据段的段基值，称为“附加”是因为此段寄存器用途不像其他 sreg 那样固定，可以额外做他用。
（4）**FS—附加段寄存器（Extra Segment Register）**，其值为附加数据段的段基值，同上，用途不固定，使用上灵活机动。
（5）**GS—附加段寄存器（Extra Segment Register）**，其值为附加数据段的段基值。
（6）**SS—堆栈段寄存器（Stack Segment Register）**，其值为堆栈段的段值。

**OSI 七层模型**，
它规定数据的第一层，也就是**最外层物理层**，这一层包含的是**电路相关的数据**。发送方和接收方都彼此认同最外层的就是电路传输用的数据。每一层中的前几个固定的字节必须是描述当前层的属性，根据此属性就能找到需要的数据。各层中的数据部分都是更上一层的数据，如第一层（**物理层**）中的数据部分是第二层（**数据链路层**）的属性+数据，第三层（**网络**）的数据部分是第四层（**传输层**）TCP 或 UDP 的属性+数据。各层都是如此，直到第七层（**应用层**）的数据部分才是真正应用软件所需要的数据。由此可见，对方一大串数据发过来后，经过层层剥离处理，到了最终的接收方（应用软件），只是一小点啦。

 ![image-20201013165647506](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201013165647506.png)

C 程序大体上分为 **预处理、编译、汇编和链接** 4 个阶段。
**预处理阶段**是预处理器将高级语言中的宏展开，去掉代码注释，为调试器添加行号等。
**编译阶段**是将预处理后的高级语言进行词法分析、语法分析、语义分析、优化，最后生成汇编代码。
**汇编阶段**是将汇编代码编译成目标文件，也就是转换成了目标机器平台上的机器指令。
**链接阶段**是将目标文件连接成可执行文件。

**MBR 与 EBR 介绍**

**MBR** 和 **EBR** 是**分区工具创建维护的**，不属于操作系统管理的范围，因此操作系统不可以往里面写东 西，注意这里所说的是“不可以”，其实操作系统是有能力读写任何地址的，只是如果这样做的话会破坏 “系统控制权接力赛”所使用的数据，下次开机后就无法启动了。**OBR** 是各分区（**主分区或逻辑分区**）最 开始的扇区，因此属于操作系统管理。

 **DBR、OBR、MBR、EBR** 都包含引导程序，因此它们都称为**引导扇区**，只要该扇区中存在可执行的 程序，该扇区就是可引导扇区。若该扇区位于整个硬盘最开始的扇区，并且以 **0x55** 和 **0xaa** 结束，BIOS 就认为该扇区中存在 **MBR**，该扇区就是 **MBR 引导扇区**。若该扇区位于各分区最开始的扇区，并且以 **0x55** 和 **0xaa** 结束，**MBR** 就认为该扇区中有操作系统引导程序 **OBR**，该扇区就是 **OBR 引导扇区**。

**DBR、OBR、MBR、EBR** 结构中都有引导代码和结束标记 **0x55** 和 **0xaa**，它们最大的区别是分区表只在 **MBR** 和 **EBR** 中存在，**DBR** 或 **OBR** 中绝对没有分区表。

![image-20201013170354801](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201013170354801.png)

在 CPU 眼里，为什么我们插在主板上的物理内存不是它眼里“全部的内存”。 地址总线宽度决定了可以访问的内存空间大小，如 16 位机的地址总线为 20 位，其地址范围是 1MB，32 位地址总线宽度是 32 位，其地址范围是 4GB。但以上的地址范围是指地址总线可以触及到的边界，是指计算机在寻址上可以到达的疆域。

物理内存多大都没用，主要是看地线总线的宽度。还要看地址总线的设计，是不是全部用于访问 DRAM。所以说，地址总线是决定我们访问哪里、访问什么，以及访问范围的关键。

 ![](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201013214309389.png)

 ![image-20201014144139482](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201014144139482.png)

**CPU工作原理**：控制单元要取下一条待运行的指令，该指令的地址在**程序计数器 PC** 中，在 x86CPU 上，程序计数器就是 **cs：ip**。于是读取 **ip寄存器**后，将此地址送上**地址总线**，CPU 根据此地址便得到了指令，并将其存入到**指令寄存器 IR** 中。这时候轮到指令译码器上场了，它根据指令格式检查指令寄存器中的指令，先确定**操作码是什么**，再检查**操作数类型**，若是在内存中，就将相应操作数 从内存中取回放入自己的存储单元，若操作数是在寄存器中就直接用了，免了取操作数这一过程。操作码有了， 操作数也齐了，操作控制器给运算单元下令，开工，于是运算单元便真正开始执行指令了。**ip 寄存器的值**被加上**当前指令的大小**，于是 ip又指向了下一条指令的地址。接着控制单元又要取下一条指令了，流程回到了本段开头，CPU 便开始了日复一日的循环，由于 CPU 特别不容易坏，所以唯一它停下来的条件就是停电。

CPU 中的**一级缓存 L1**、**二级缓存 L2**，它们都是 **SRAM**，即静态随机访问存储器，它是最快的存储器。**SRAM** 是用寄存器来**存储数据的**，这就是 SRAM **快**的原因。寄存器是使用**触发器**实现的，这也是一种**存储电路**，工作速度极快，是**纳秒级别**的。

**CPU 中的寄存器大致上分为两大类。**

1. **第一类**是其**内部使用**的，对程序员**不可见**。“是否可见”不是说寄存器是否能看得见，是指程序员**是否能使用**。CPU 内部有其自己的运行机制，是按照某个预定框架进行的，为了CPU 能够运行下去，必然会有一些寄存器来做**数据的支撑**，给 CPU 内部的数据提供**存储空间**。这一部分对外是不可见的，我们**无法使用它们**，比如全局描述符表寄存器 GDTR、中断描述符表寄存器 IDTR、局部描述符表寄存器 LDTR、 任务寄存器 TR、控制寄存器 CR0～3、指令指针寄存器 IP、标志寄存器 flags、调试寄存器 DR0～7。
2. **第二类**是对程序员**可见**的寄存器。我们进行汇编语言程序设计时，能够直接操作的就是这些寄存器，如段寄存器、通用寄存器。

**通用寄存器**

 ![image-20201014150329706](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201014150329706.png)

 ![image-20201014150218707](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201014150218707.png)

**CPU8086寻址方式**，从大方向来看可以分为三大类：
（1）寄存器寻址；
（2）立即数寻址；
（3）内存寻址。
在第三种内存寻址中又分为：
（1）直接寻址；
（2）基址寻址；
（3）变址寻址；
（4）基址变址寻址。

**标志位寄存器**

 ![image-20201014163727780](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201014163727780.png)

```
以下标志位仅在 8088 以上 CPU 中有效。

第 0 位的是 CF 位，即 Carry Flag，意为进位。运算中，数值的最高位有可能是进位，也有可能是借位，所以 carry 表示 这两种状态。不管最高位是进位，还是借位，CF 位都会置 1，否则为 0。它可用于检测无符号数加减法是否有溢出，因为 CF 为 1 时，也就是最高位有进位或借位，肯定是溢出。
再说点没用的，第 1、3、5、15 位没有专门的标志位，空着占位用。
第 2 位为 PF 位，即 Parity Flag，意为奇偶位。用于标记结果低 8 位中 1 的个数，如果为偶数，PF 位
为 1，否则为 0。注意啦，是最低的那 8 位，不管操作数是 16 位，还是 32 位。奇偶校验经常用于数据传
输开始时和结束后的对比，判断传输过程中是否出现错误。
第 4 位为 AF 位，即 Auxiliary carry Flag，意为辅助进位标志，用来记录运算结果低 4 位的进、借位
情况，即若低半字节有进、借位，AF 为 1，否则为 0。
第 6 位为 ZF 位，即 Zero Flag，意为零标志位。若计算结果为 0，此标志为 1，否则为 0。
第 7 位为 SF 位，即 Sign Flag，意为符号标志位。若运算结果为负，则 SF 位为 1，否则为 0
第 8 位为 TF 位，即 Trap Flag，意为陷阱标志位。此位若为 1，用于让 CPU 进入单步运行方式，若为0，则为连续工作的方式。平时我们用的 debug 程序，在单步调试时，原理上就是让 TF 位为 1。可见，软件上的很多功能，必须有硬件的原生支持才能得以实现。
第 9 位为 IF 位，即 Interrupt Flag，意为中断标志位。若 IF 位为 1，表示中断开启，CPU 可以响应外部可屏蔽中断。若为 0，表示中断关闭，CPU 不再响应来自 CPU 外部的可屏蔽中断，但 CPU 内部的异常还是要响应的，因为它关不住。
第 10 位为 DF 位，即 Direction Flag，意为方向标志位。此标志位用于字符串操作指令中，当 DF 为 1 时，指令中的操作数地址会自动减少一个单位，当 DF 为 0 时，指令中的操作数地址会自动增加一个单位，意即给地址的变化提供个方向。其中提到的这个单位的大小，取决于用什么指令。
第 11 位为 OF 位，即 Overflow Flag，意为溢出标志位。用来标识计算的结果是否超过了数据类型可
表示的范围，若超出了范围，就像水从锅里溢出去了一样。若 OF 为 1，表示有溢出，为 0 则未发生溢出。
专门用于检测有符号数运算结果是否有溢出现象。

以下标志位仅在 80286 以上 CPU 中有效。相对于 8088，它支持特权级和多任务。
第 12～13 位为 IOPL，即 Input Output Privilege Level，这用在有特权级概念的 CPU 中。有 4 个任务特权级，即特权级 0、特权级 1、特权级 2 和特权级 3。故 IOPL 要占用 2 位来表示这 4 种特权级。如果您对此感到迷茫，不用担心，这些将来咱们在保护模式下也得实践。
第 14 位为 NT，即 Nest Task，意为任务嵌套标志位。8088 支持多任务，一个任务就是一个进程。当一个任务中又嵌套调用了另一个任务（进程）时，此 NT 位为 1，否则为 0。

以下标志位仅用于 80386 以上的 CPU。
第 16 位为 RF 位，即 Resume Flag，意即恢复标志位。该标志位用于程序调试，指示是否接受调试故
障，它需要与调试寄存器一起使用。当 RF 为 1 时忽略调试故障，为 0 时接受。
第 17 位为 VM 位，即 Virtual 8086 Model，意为虚拟 8086 模式。这是实模式向保护模式过渡时的产物，现在已经没有了。CPU 有了保护模式后，功能更加强大了，但为了兼容实模式下的用户程序，允许将此位置为 1，这样便可以在保护模式下运行实模式下的程序了。实模式下的程序不支持多任务，而且程序中的地址就是真实的物理地址。所以在保护模式下每运行一个实模式下的程序，就要为其虚拟一个实模式环境，故称为虚拟模式。

以下标志位仅用于 80486 以上的 CPU。
第 18 位为 AC 位，即 Alignment Check，意为对齐检查。什么是对齐呢？是指程序中的数据或指令其内存地址是否是偶数，是否是 16、32 的整数倍，没有余数，这样硬件每次对地址以自增地方式（每次自加 2、16、32 等）访问内存时，自增后的地址正好对齐数据所在的起始地址上，这就是对齐的原理。对齐并不是软件逻辑中的要求，而是硬件上的偏好，如果待访问的内存地址是 16 或 32 的整数倍，硬件上好处理，所以运行较快。若 AC 位为 1 时，则进行地址对齐检查，为 0 时不检查。

以下标志位只对 80586（奔腾）以上 CPU 有效。
第 19 位为 VIF 位，即 Virtual Interrupt Flag，意为虚拟中断标志位，虚拟模式下的中断标志。
第 20 位为 VIP 位，即 Virtual Interrupt Pending，意为虚拟中断挂起标志位。在多任务情况下，为操作
系统提供的虚拟中断挂起信息，需要与 VIF 位配合。
第 21 位为 ID 位，即 Identification，意思为识别标志位。系统经常要判断 CPU 型号，若 ID 为 1，表示当前 CPU 支持 CPU id 指令，这样便能获取 CPU 的型号、厂商等信息。若 ID 为 0，则表示当前 CPU 不支持 CPU id 指令。
其余剩下的 22～31 位都没有实际用途，纯粹是占位用，为了将来扩展。
```

flags 寄存器一般与跳转有关联

条件转移指令中所说的条件就是指标志寄存器中的标志位。

jxx 中的 xx，就是各种条件的分类，每种 条件有不同的转移指令。

![image-20201014164609509](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201014164609509.png)

这些转移指令是由意义明确的字符拼成的 。。。

```
a 表示 above
b 表示 below
c 表示 carry
e 表示 equal
g 表示 great
j 表示 jmp
l 表示 less
n 表示 not
o 表示 overflow
p 表示 parity 
```

方便我们去记忆

**摘录的一段话**

```
如果您有一般的软件开发经验，就会了解，很少有程序能一下就编译通过。当然，如果您的编程经验 无比丰富，代码无比规范，无比了解编译器，确实不需要虚拟机来调试了，编写完成后直接就能运行。以 上我用了三个“无比”，打造了似乎没有人能达到这种水平的假象，其实是有的。不知道大家听说过 Jon Skeet 没有，他是谷歌软件工程师，《C# In Depth》就是他的作品。看看别人对他是怎样评价的，看完之后您就 知道我说的并不夸张了。
“他并不需要调试器，只要他盯着代码看几眼，Bug 自己就跑出来了”。
“他根本不需要什么编程规范，他的代码就是规范”。
“如果他的代码没有通过编译，编译器厂商就会道歉”。
```

学无止境。。。。。。

# 部署环境

**软件 是 VMware Workstation Pro**

**虚拟机镜像 是 ubuntu 16.04 x64**

**虚拟环境（加载在虚拟机中）:bochs-2.6.2**

## Bochs 下载安装 

官网 https://sourceforge.net/projects/bochs/files/bochs/

下载 **bochs-2.6.2** 

在虚拟机里面 解压压缩包 

```
--tar zxvf bochs-2.6.2.tar.gz
--cd bochs-2.6.2
```

然后开始 **configure、make、make install** 三步曲

```
./configure \
--prefix=/your_path/bochs-2.6.2 \  
--enable-debugger\
--enable-disasm \
--enable-iodebug \
--enable-x86-debugger \
--with-x \
--with-x11 

--prefix=/your_path/bochs 是用来指定 bochs 的安装目录，根据个人实际情况将 your_path 替换为自己待安装的路径。
--enable-debugger 打开 bochs 自己的调试器。
--enable-disasm 使 bochs 支持反汇编。
--enable-iodebug 启用 io 接口调试器。
--enable-x86-debugger 支持 x86 调试器。
--with-x 使用 x windows。
--with-x11 使用 x11 图形用户接口。
    
```

**configure** 之后，会生成 **Makefile**，可以开始编译了。

如果报错 （ 其余报错 google 一般都有

```
undefined reference to 'pthread_create'
undefined reference to 'pthread_join' 
```

我们需要在 **Makefile**文件`LIBS =`这句最后面添加上`-lpthread`

```
LIBS =  -lm -lgtk-x11-2.0 -lgdk-x11-2.0 -lpangocairo-1.0 -latk-1.0 -lcairo -lgdk_pixbuf-2.0 -lgio-2.0 -lpangoft2-1.0 -lpango-1.0 -lgobject-2.0 -lglib-2.0 -lfontconfig -lfreetype -lpthread
```

然后重新编译

```
--sudo make
--sudo make install
```

## 配置 bochs

设置配置文件 bochsrc.disk 放在 bochs 安装目录下

```
# Configuration file for Bochs
# 运行过程中能够使用的内存，本例为 32MB。
# 关键字为：megs
megs： 32

# 设置对应真实机器的 BIOS 和 VGA BIOS。
romimage: file=/实际路径/bochs-2.6.2/share/bochs/BIOS-bochs-latest
vgaromimage: file=/实际路径/bochs-2.6.2/share/bochs/VGABIOS-lgpl-latest

# Bochs 所使用的磁盘，软盘的关键字为 floppy。
# 若只有一个软盘，则使用 floppya 即可，若有多个，则为 floppya，floppyb…
#floppya: 1_44=a.img, status=inserted

# 选择启动盘符。
#boot: floppy #默认从软盘启动，将其注释
boot: disk #改为从硬盘启动。我们的任何代码都将直接写在硬盘上，所以不会再有读写软盘的操作。

# 设置日志文件的输出。
log: bochs.out

# 开启或关闭某些功能。
# 下面是关闭鼠标，并打开键盘。
mouse: enabled=0
keyboard:keymap=/实际路径/bochs-2.6.2/share/bochs/keymaps/x11-pc-us.map

# 硬盘设置
ata0: enabled=1, ioaddr1=0x1f0, ioaddr2=0x3f0, irq=14

# 下面的是增加的 bochs 对 gdb 的支持，这样 gdb 便可以远程连接到此机器的 1234 端口调试了
# gdbstub: enabled=1, port=1234, text_base=0, data_base=0, bss_base=0

```

```
--sudo bin/bochs -f bochsrc.disk

出现 ...
You can also start bochs with the -q option to skip these menus.

1. Restore factory default configuration
2. Read options from...
3. Edit options
4. Save options to...
5. Restore the Bochs state from...
6. Begin simulation
7. Quit now

Please choose one: [6]
```

回车后 会出现2个窗口

在主窗口 输入c 进行进程，

提示没有的这个“bootable device”就是启动盘，现在就创建启动盘吧。

```
-fd 创建软盘。
-hd 创建硬盘。
-mode 创建硬盘的类型，有 flat、sparse、growing 三种。
-size 指创建多大的硬盘，以 MB 为单位。
-q 以静默模式创建，创建过程中不会和用户交互。

bin/bximage -hd -mode="flat" -size=60 -q hd60M.img
这个命令串中最后一个 hd60M.img 是咱们创建的虚拟硬盘的名称。
```

然后继续运行

之前报错原因是 boot failed: could not read the boot disk，这是无法读取启动盘。

而现在这里的报错是 boot failed: not a bootable disk，这 不是一个启动盘。（ 下部分解决

其实在这里配置 就完了。。。

# 编写MBR主引导记录

从按下主机上的 power 键后，第一个运行的软件是 BIOS。

BIOS 全称叫 Base Input & Output System，即基本输入输出系统。

**实模式下1MB 内存的布局 ：**![image-20201013211922504](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201013211922504.png)

**BIOS 的主要工作是**

1. **检测、初始化硬件**，怎么初始化的？硬件自己提 供了一些初始化的功能调用，BIOS 直接调用就好了。BIOS 还做了一件伟大的事情，
2. **建立了中断向量表**，这样 就可以通过“int 中断号”来实现相关的硬件调用，当然 BIOS 建立的这些功能就是对硬件的 IO 操作，也就是输入输出，但由于就 64KB 大小的空间，不可能把所有硬件的 IO 操作实现得面面俱到，而且也没必要实现那么多， 毕竟是在实模式之下，对硬件支持得再丰富也白搭，精彩的世界是在进入保护模式以后才开始，所以挑一些重要的、保证计算机能运行的那些硬件的基本 IO 操作，就行了。
3. **校验启动盘中位于 0 盘 0 道 1 扇区的内容**，在计算机中是习惯以 0 作为起始索引的，因为人们已经习惯了偏移量的概念， 无论是机器眼里和程序员眼里，用“相对”的概念，即偏移量来表示位置显得很直观，所以很多指令中的 操作数都是用偏移量表示的。0 盘 0 道 1 扇区本质上就相当于 0 盘 0 道 0 扇区。MBR 所在的位置是磁盘上最开始的那个扇区。此扇区末尾的两个字节分别是魔数 0x55 和 0xaa，BIOS 便认为此扇区中确实存在可执 行的程序（此程序便是久闻大名的主引导记录 MBR），便加载到物理地址 0x7c00，随 后跳转到此地址，继续执行。

BIOS 跳转到 0x7c00 是用 jmp 0：0x7c00 实现的，这是 jmp 指令的直接绝对远转移 用法，段寄存器 cs 会被替换，这里的段基址是 0，即 cs 由之前的 0xf000 变成了 0。 如果此扇区的最后 2 个不是 0x55 和 0xaa，即使里面有可执行代码也无济于事了，BIOS 不认，它也 许还认为此扇区是没格干净呢。

MBR 的大小必须是 512 字节，这是为了保证 0x55 和 0xaa 这两个 魔数恰好出现在该扇区的最后两个字节处，即第 510 字节处和第 511 字节处，这是按起始偏移为 0 算起的。 由于我们的 bochs 模拟的是 x86 平台，所以是小端字节序，故其最后两个字节内容是 0xaa55，写到一起后 似乎有点不认识了，不要怕，拆开就是 0x55 和 0xaa。

**nasm的安装与使用**

```
--sudo apt install nasm

usage: nasm [-@ response file] [-o outfile] [-f format] [-l listfile]
            [options...] [--] filename
    or nasm -v (or --v) for version info

    -t          assemble in SciTech TASM compatible mode
    -g          generate debug information in selected format
    -E (or -e)  preprocess only (writes output to stdout by default)
    -a          don't preprocess (assemble only)
    -M          generate Makefile dependencies on stdout
    -MG         d:o, missing files assumed generated
    -MF <file>  set Makefile dependency file
    -MD <file>  assemble and generate dependencies
    -MT <file>  dependency target name
    -MQ <file>  dependency target name (quoted)
    -MP         emit phony target

    -Z<file>    redirect error messages to file
    -s          redirect error messages to stdout

    -F format   select a debugging format

    -o outfile  write output to an outfile

    -f format   select an output format

    -l listfile write listing to a listfile

    -I<path>    adds a pathname to the include file path
    -O<digit>   optimize branch offsets
                -O0: No optimization
                -O1: Minimal optimization
                -Ox: Multipass optimization (default)

    -P<file>    pre-includes a file
    -D<macro>[=<value>] pre-defines a macro
    -U<macro>   undefines a macro
    -X<format>  specifies error reporting format (gnu or vc)
    -w+foo      enables warning foo (equiv. -Wfoo)
    -w-foo      disable warning foo (equiv. -Wno-foo)

    -h          show invocation summary and exit

--prefix,--postfix
  this options prepend or append the given argument to all
  extern and global variables
```

 **开始代码啦**

功能：在屏幕上打印字符串“1 MBR”，背景色为黑色，前景色为绿色。

```asm
 ;主引导程序
 ;------------------------------------------------------------
 SECTION MBR vstart=0x7c00
 mov ax,cs
 mov ds,ax
 mov es,ax
 mov ss,ax
 mov fs,ax
 mov sp,0x7c00
 ; 清屏利用 0x06 号功能,上卷全部行,则可清屏｡
 ; -----------------------------------------------------------
 ;INT 0x10 功能号:0x06 功能描述:上卷窗口
 ;------------------------------------------------------
 ;输入:
 ;AH 功能号= 0x06
 ;AL = 上卷的行数(如果为 0,表示全部)
 ;BH = 上卷行属性
 ;(CL,CH) = 窗口左上角的(X,Y)位置
 ;(DL,DH) = 窗口右下角的(X,Y)位置
 ;无返回值:
 mov ax, 0x600
 mov bx, 0x700
 mov cx, 0 ; 左上角: (0, 0)
 mov dx, 0x184f ; 右下角: (80,25),
 ; VGA 文本模式中,一行只能容纳 80 个字符,共 25 行｡
 ; 下标从 0 开始,所以 0x18=24,0x4f=79
 int 0x10 ; int 0x10

 ;;;;;;;;; 下面这三行代码获取光标位置 ;;;;;;;;;
 ;.get_cursor 获取当前光标位置,在光标位置处打印字符｡
 mov ah, 3 ; 输入: 3 号子功能是获取光标位置,需要存入 ah 寄存器
 mov bh, 0 ; bh 寄存器存储的是待获取光标的页号

 int 0x10 ; 输出: ch=光标开始行,cl=光标结束行
 ; dh=光标所在行号,dl=光标所在列号

 ;;;;;;;;; 获取光标位置结束 ;;;;;;;;;;;;;;;;
 
 ;;;;;;;;; 打印字符串 ;;;;;;;;;;;
 ;还是用 10h 中断,不过这次调用 13 号子功能打印字符串
 mov ax, message
 mov bp, ax ; es:bp 为串首地址,es 此时同 cs 一致,
 ; 开头时已经为 sreg 初始化

 ; 光标位置要用到 dx 寄存器中内容,cx 中的光标位置可忽略
 mov cx, 5 ; cx 为串长度,不包括结束符 0 的字符个数
 mov ax, 0x1301 ;子功能号 13 显示字符及属性,要存入 ah 寄存器,
 ; al 设置写字符方式 ah=01: 显示字符串,光标跟随移动
 ;（1）al=0，显示字符串，并且光标返回起始位置。
 ;（2）al=1，显示字符串，并且光标跟随到新位置。
 ;（3）al=2，显示字符串及其属性，并且光标返回起始位置。
 ;（4）al=3，显示字符串及其属性，光标跟随到新位置。
 mov bx, 0x2 ; bh 存储要显示的页号,此处是第 0 页,
 ; bl 中是字符属性,属性黑底绿字(bl = 02h)
 int 0x10 ; 执行 BIOS 0x10 号中断
 ;;;;;;;;; 打字字符串结束 ;;;;;;;;;;;;;;;

 jmp $ ; 使程序悬停在此

 message db "1 MBR"
 times 510-($-$$) db 0
 db 0x55,0xaa 
```

**$$** 是指本 **section** 的起始地址，上面说过了 **$** 是本行所在的地址，故 **$-$$** 是本行到 **本 section 的偏移量**。由于 **MBR** 的最后两个字节是固定的内容，分别是 **0x55** 和 **0xaa**，要预留出这 2 个字节，故本 扇区内前 512-2=510 字节要填满，用 510 字节减去上面通过 **$-$$** 得到的偏移量，其结果便是本扇区内的剩余量，也就是要填充的字节数。由此可见 “**times 510 -（$-$$） db 0**” 是在用 0 将本扇区剩余空间填充。

```
编译
--nasm -o mbr.bin mbr.S

Linux 命令：dd
dd 是用于磁盘操作的命令，可以深入磁盘的任何一个扇区，它也可以删除 Linux 操作系统自己的文件。
-- dd --help
用法：dd [操作数] ...
　或：dd 选项
　
Copy a file, converting and formatting according to the operands.
  bs=BYTES        read and write up to BYTES bytes at a time
  cbs=BYTES       convert BYTES bytes at a time
  conv=CONVS      convert the file as per the comma separated symbol list
  count=N         copy only N input blocks
  ibs=BYTES       read up to BYTES bytes at a time (default: 512)
  if=FILE         read from FILE instead of stdin
  iflag=FLAGS     read as per the comma separated symbol list
  obs=BYTES       write BYTES bytes at a time (default: 512)
  of=FILE         write to FILE instead of stdout
  oflag=FLAGS     write as per the comma separated symbol list
  seek=N          skip N obs-sized blocks at start of output
  skip=N          skip N ibs-sized blocks at start of input
  status=LEVEL    The LEVEL of information to print to stderr;
                  'none' suppresses everything but error messages,
                  'noxfer' suppresses the final transfer statistics,
                  'progress' shows periodic transfer statistics

N and BYTES may be followed by the following multiplicative suffixes:
c =1, w =2, b =512, kB =1000, K =1024, MB =1000*1000, M =1024*1024, xM =M
GB =1000*1000*1000, G =1024*1024*1024, and so on for T, P, E, Z, Y.

Each CONV symbol may be:
  ascii     from EBCDIC to ASCII
  ebcdic    from ASCII to EBCDIC
  ibm       from ASCII to alternate EBCDIC
  block     pad newline-terminated records with spaces to cbs-size
  unblock   replace trailing spaces in cbs-size records with newline
  lcase     change upper case to lower case
  ucase     change lower case to upper case
  sparse    try to seek rather than write the output for NUL input blocks
  swab      swap every pair of input bytes
  sync      pad every input block with NULs to ibs-size; when used
            with block or unblock, pad with spaces rather than NULs
  excl		fail if the output file already exists
  nocreat	do not create the output file
  notrunc	不截断输出文件
  noerror	读取数据发生错误后仍然继续
  fdatasync	结束前将输出文件数据写入磁盘
  fsync	类似上面，但是元数据也一同写入

FLAG 符号可以是：

  append	追加模式(仅对输出有意义；隐含了conv=notrunc)
  direct	使用直接I/O 存取模式
  directory	除非是目录，否则 directory 失败
  dsync		使用同步I/O 存取模式
  sync		与上者类似，但同时也对元数据生效
  fullblock	为输入积累完整块(仅iflag)
  nonblock	使用无阻塞I/O 存取模式
  noatime	不更新存取时间
  nocache   Request to drop cache.  See also oflag=sync
  noctty	不根据文件指派控制终端
  nofollow	不跟随链接文件
  count_bytes  treat 'count=N' as a byte count (iflag only)
  skip_bytes  treat 'skip=N' as a byte count (iflag only)
  seek_bytes  treat 'seek=N' as a byte count (oflag only)

Sending a USR1 signal to a running 'dd' process makes it
print I/O statistics to standard error and then resume copying.
```

```
常用的几个 dd指令参数
if=FILE
read from FILE instead of stdin
此项是指定要读取的文件。
of=FILE
write to FILE instead of stdout
此项是指定把数据输出到哪个文件。
bs=BYTES
read and write BYTES bytes at a time (also see ibs=,obs=)
此项指定块的大小，dd 是以块为单位来进行 IO 操作的，得告诉人家块是多大字节。此项是统计配置
了输入块大小 ibs 和输出块大小 obs。这两个可以单独配置。
count=BLOCKS
copy only BLOCKS input blocks
此项是指定拷贝的块数。
seek=BLOCKS
skip BLOCKS obs-sized blocks at start of output
此项是指定当我们把块输出到文件时想要跳过多少个块。
conv=CONVS
convert the file as per the comma separated symbol list
此项是指定如何转换文件。
append append mode (makes sense only for output; conv=notrunc suggested
```

介绍完了 指令dd 该我们安排了

```
-- sudo dd if=/your_path/mbr.bin of=/your_path/bochs/hd60M.img bs=512 count=1 conv=notrunc
-- sudo dd if=/home/fyz/sc/bochs-2.6.2/mbr.bin of=/home/fyz/sc/bochs-2.6.2/hd60M.img bs=512 count=1 conv=notrunc
```

输入文件是刚刚编译出来的 **mbr.bin**，输出是我们虚拟出来的硬盘 **hd60M.img**，块大小指定为 512 字节， 只操作 1 块，即总共 1*512=512 字节。由于想写入第 0 块，所以没用 seek 指定跳过的块数。 执行上面的命令后，会有如下输出。

```
记录了1+0 的读入
记录了1+0 的写出
512 bytes copied, 0.0248785 s, 20.6 kB/s
```

mbr.bin 已经写进 hd60M.img 的第 0 块了。

开始模拟了

```
-- sudo bin/bochs -f bochsrc.disk
```

 ![image-20201014004258509](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201014004258509.png)

回车后 输入c继续 得到结果。。。

 ![image-20201014004414356](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201014004414356.png)

## 完善 MBR

先看下显卡各种模式的内存分布 ![image-20201014171240987](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201014171240987.png)

从起始地址 0xB8000 到 0xBFFFF，这片 32KB 大小的内存区域是用于文本显示。

我们往 0xB8000 处输出的字符直接会落到显存中，显存中有了数据，自然显卡就将其搬到显示器屏幕上了，这后续的事情咱们是不需要处理的，咱们只要保证写进显存的数据是正确的就可以。

 ![image-20201014171446377](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201014171446377.png)

用 R 红色、G 绿色、B 蓝色这三种颜色以任意比例混 合，可以搭配出其他颜色，其他颜色被认为都可以由这三种颜色组合 而成。不过由于在文本模式下的颜色极其有限，RGB 的各部分比例要么是 1（全部），要么是 0（没有），所以其组合出的颜色屈指可数，为了让大家测试字符颜色更加方便， 给大家提供这三种颜色的组合。![image-20201014171517655](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201014171517655.png)

改进 MBR，直接操作显卡 

通过 BIOS 的输出改为通过显存。。。

```asm
 ;主引导程序
 ;
 ;LOADER_BASE_ADDR equ 0xA000
 ;LOADER_START_SECTOR equ 0x2
 ;------------------------------------------------------------
 SECTION MBR vstart=0x7c00
 mov ax,cs
 mov ds,ax
 mov es,ax
 mov ss,ax
 mov fs,ax
 mov sp,0x7c00
 mov ax,0xb800
 mov gs,ax
 ;清屏
 ;利用 0x06 号功能，上卷全部行，则可清屏
 ; -----------------------------------------------------------
 ;INT 0x10 功能号：0x06 功能描述：上卷窗口
 ;------------------------------------------------------
 ;输入：
 ;AH 功能号= 0x06
 ;AL = 上卷的行数（如果为 0，表示全部）
 ;BH = 上卷行属性
 ;(CL,CH) = 窗口左上角的(X,Y)位置
 ;(DL,DH) = 窗口右下角的(X,Y)位置
 ;无返回值:
 mov ax, 0600h
 mov bx, 0700h
 mov cx, 0 ; 左上角: (0, 0)
 mov dx, 184fh ; 右下角: (80,25),
 ; VGA 文本模式中，一行只能容纳 80 个字符，共 25 行
 ; 下标从 0 开始，所以 0x18=24，0x4f=79
 int 10h ; int 10h

 ; 输出背景色绿色，前景色红色，并且跳动的字符串"1 MBR" 
 mov byte [gs:0x00],'1'
 mov byte [gs:0x01],0xA4 ; A 表示绿色背景闪烁，4 表示前景色为红色
 mov byte [gs:0x02],' '
 mov byte [gs:0x03],0xA4

 mov byte [gs:0x04],'M'
 mov byte [gs:0x05],0xA4

 mov byte [gs:0x06],'B'
 mov byte [gs:0x07],0xA4

 mov byte [gs:0x08],'R'
 mov byte [gs:0x09],0xA4

 jmp $ ; 通过死循环使程序悬停在此

 times 510-($-$$) db 0
 db 0x55,0xaa 
```

编译 写入虚拟硬盘

```
编译
--nasm -o mbr.bin mbr.S 
下面将生成的 mbr.bin 写入我们的虚拟硬盘，还是用 dd 命令。
--sudo dd if=/your_path/mbr.bin of=/your_path/bochs/hd60M.img bs=512 count=1 conv=notrunc
--sudo dd if=/home/fyz/sc/bochs-2.6.2/mbr.bin of=/home/fyz/sc/bochs-2.6.2/hd60M.img bs=512 count=1 conv=notrunc
模拟
--sudo bin/bochs -f bochsrc.disk
```

 结果

 ![image-20201014193903262](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201014193903262.png)

## 让 MBR 使用硬盘

### 什么是硬盘？

首先说一下硬盘的概念：英文名：Hard Disk Drive,简称HDD，硬盘是电脑主要的存储媒介之一，由一个或者多个铝制或者玻璃制的碟片组成。 这个就是一个硬盘：大部分的硬盘是由磁头臂组支架，转轴，读写头，磁头臂，磁道，扇区，柱面，盘面组成的。

 ![image-20201014202541118](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201014202541118.png)

磁头靠近主轴接触的表面，即线速度最小的地方，是一个特殊的区域，它不存放任何数据，称为启停区或着陆区（Landing Zone），启停区外就是数据区。在最外圈，离主轴最远的地放是“0”磁道，硬盘数据的存放就是从最外圈开始的。

**盘面、磁道、柱面和扇区**

硬盘的读写是和扇区有着紧密关系的。在说扇区和读写原理之前先说一下和扇区相关的”盘面”、“磁道”、和“柱面”。

**1.盘面**  ：硬盘的盘片一般用铝合金材料做基片，高速硬盘也可能用玻璃做基片。

**2.磁道** ：磁盘在格式化时被划分成许多同心圆，这些同心圆轨迹叫做磁道（Track）。磁道从外向内从0开始顺序编号。硬盘的每一个盘面有300～1 024个磁道，新式大容量硬盘每面的磁道数更多。

**3.柱面** ：所有盘面上的同一磁道构成一个圆柱，通常称做柱面（Cylinder），每个圆柱上的磁头由上而下从“0”开始编号。数据的读/写按柱面进行，即磁头读/写数据时首先在同一柱面内从“0”磁头开始进行操作，依次向下在同一柱面的不同盘面即磁头上进行操作，只在同一柱面所有的磁头全部读/写完毕后磁头才转移到下一柱面，因为选取磁头只需通过电子切换即可，而选取柱面则必须通过机械切换。

**4.扇区** ：操作系统以扇区（Sector）形式将信息存储在硬盘上，每个扇区包括512个字节的数据和一些其他信息。一个扇区有两个主要部分：**存储数据地点的标识符**和**存储数据的数据段**。扇区的**第一个主要部分是标识符**。包括组成扇区三维地址的三个数字：扇区所在的磁头（或盘面）、磁道（或柱面号）以及扇区在磁道上的位置即扇区号。扇区的**第二个主要部分是存储数据的数据段**。

**硬盘的读写原理**

系统将文件存储到磁盘上时，按柱面、磁头、扇区的方式进行，即最先是第1磁道的第一磁头下（也就是第1盘面的第一磁道）的所有扇区，然后，是同一柱面的下一磁头，……，一个柱面存储满后就推进到下一个柱面，直到把文件内容全部写入磁盘。

系统也以相同的顺序读出数据。读出数据时通过告诉磁盘控制器要读出扇区所在的柱面号、磁头号和扇区号（物理地址的三个组成部分）进行。

扇区到来时，磁盘控制器读出每个扇区的头标，把这些头标中的地址信息与 期待检出的磁头和柱面号做比较（即寻道），然后，寻找要求的扇区号。待磁盘控制器找到该扇区头标时，根据其任务是写扇区还是读扇区，来决定是转换写电路， 还是读出数据和尾部记录。

**硬盘控制器端口** 

硬盘控制器属于 IO 接口， 让硬盘工作，我们需要通过读写硬盘控制器的端口，端口的概念在此重复一下，端口就是位于 IO 控制器上的寄存器，此处的端口是指硬盘控制器上的寄存器。

使用硬盘时的端口范围![image-20201014203719299](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201014203719299.png)

端口可以被分为两组，**Command Block registers** 和 **Control Block registers**。Command Block registers 用于向硬盘驱动器写入命令字或者从硬盘控制器获得硬盘状态，Control Block registers 用于控制硬盘工作 状态。在 Control Block registers 组中的寄存器已经精减了，而且咱们基本上用不到。

端口是按照**通道**给出的，一个通道上的**主、从两块硬盘**都用这些端口号。要想操作某通道上的某块硬盘，需要单独指定。 有个叫 **device 的寄存器**，顾名思义，指的就是**驱动器设备**，也就是和硬盘相关。不过此寄存器是 8 位的，一个通道上就两块硬盘，指定哪一个硬盘只用 1 位就够了，寄存器可是很宝贝的资源，不能浪费， 所以此寄存器是个杂项，很多设置都需集中在此寄存器中了，其中的第 4 位，便是指定通道上的主或从硬盘，**0 为主盘，1 为从盘**。

**data 寄存器** **:** **负责管理数据的**，它相当于数据的门，数据能进，也能出，所以其 作用是读取或写入数据。数据的读写还是越快越好，所以此寄存器较其他寄存器宽一些，16 位（已经很不错了，表中其他寄存器都是 8 位的）。在读硬盘时，硬盘准备好的数据后，硬盘控制器将其放在内部的缓冲区中，不断读此寄存器便是读出缓冲区中的全部数据。在写硬盘时，我们要把数据源源不断地输送到此端口， 数据便被存入缓冲区里，硬盘控制器发现这个缓冲区中有数据了，便将此处的数据写入相应的扇区中。

**Error 寄存器 (Feature 寄存器)** : 读硬盘时，**端口 0x171 或 0x1F1 的寄存器** ，只在**读取硬盘失败**时有用，里面才会记录失败的信息，尚未读取的扇区数在 **Sector count 寄存器**中。在写硬盘时，此寄存器有了别的用途，所以有了新的名字，叫 **Feature 寄存器**。有些命令需要指定额外参数，这些参数就写在 **Feature 寄存器**中。 强调一下，**error 和 feature 这两个名字指的是同一个寄存器**，只是因为不同环境下有不同的用途，为了区别这两种用途，所以在相应环境下有不同的名字。这两个寄存器都是 **8 位宽度**。

**Sector count 寄存器** : 用来指定待读取或待写入的扇区数。硬盘每完成一个扇区，就会将此寄存器的值减 1，所以如果中间失败了，此寄存器中的值便是尚未完成的扇区。这是 8 位寄存器，最大值为 255，若 指定为 0，则表示要操作 256 个扇区。

**CHS** : 硬盘中的扇区在物理上是用“**柱面-磁头-扇区**”来定位的（**Cylinder Head Sector**），但每 次我们要事先算出扇区是在哪个盘面，哪个柱面上，这太麻烦了，这对于磁头来说很直观，它就是根据这些信息来定位扇区的。这就引出了**LBA**。。。

**LBA 的定义 **: 一种逻辑上为扇区址的方法，全称为**逻辑块地址**（Logical Block Address）。LBA 分为两种，**一种是 LBA28**，用 28 位比特来描述一个扇区的地址。最大寻址范围是 2 的 28 次方等 于 268435456 个扇区，每个扇区是 512 字节，最大支持 128GB。 **另外一种是 LBA48**，用 48 位比特来描述一个扇区的地址，最大可寻址范围是 2 的 48 次方， 等于 281474976710656 个扇区，乘以 512 字节后，最大支持 131072TB，即 128PB。

**LBA 寄存器** ：**LBA low、LBA mid、LBA high**（8位）。LBA low 寄存器用来存储 28 位地址的第 **0～7** 位，LBA mid 寄存器用来存储第 **8～15** 位， LBA high 寄存器存储第 **16～23** 位。

**device 寄存器** ：宽度是 8 位，它的**低 4 位**用来存储 **LBA 地址 的第 24～27 位**。结合上面的三个 LBA 寄存器。**第 4 位用来指定通道上的主盘或从盘**，0 代表主盘，1 代表从盘。**第 6 位用来设置是否启用 LBA 方式**，1 代表启用 **LBA** 模式，0 代表启用 **CHS** 模式。另外的两位： **第 5 位和第 7 位**是固定为 1 的，称为 **MBS** 位。

 ![image-20201014210843981](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201014210843981.png)

**Status寄存器** ： 在读硬盘时，端口 0x1F7 或 0x177 的寄存器（8位）。用来给出**硬盘的状态信息**。**第 0 位是 ERR 位**，如果此位为 1，表示命令出错了，具体原因可见 error 寄存器。**第 3 位是 data request 位**，如果此位为 1，表示硬盘已经把数据准备好了，主机现在可以把数据读出来。**第 6 位是 DRDY**， 表示硬盘就绪，此位是在对硬盘诊断时用的，表示硬盘检测正常，可以继续执行一些命令。**第 7 位是 BSY 位**，表示硬盘是否繁忙，如果为 1 表示硬盘正忙着，此寄存器中的其他位都无效。另外的 4 位暂不关注。

 ![image-20201014210935449](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201014210935449.png)

**command寄存器** ： 在写硬盘时，端口 0x1F7 或 0x177 的寄存器。它和 **status 寄存器**是同一个。此寄存器用来**存储让硬盘执行的命令**，只要把命令写进此寄存器，硬盘就开始工作了

我们系统主要执行3个命令（ 感兴趣的 可以去看 ATA 手册

```
（1）identify：0xEC，即硬盘识别。
（2）read sector：0x20，即读扇区。
（3）write sector：0x30，即写扇区。
```

总结下寄存器 **error、feature** 和 **status、command**，大家可以这样来助记：这两组都是同一寄存器（也就是同一端口）多个用途，对同一端口写操作时，硬盘控制器认为这是个命令，对同一端口读操作时，硬盘控制器认为是想获得状态。

### **常用的硬盘操作方法**

最主要的顺序就是 command 寄 存器一定得是最后写，因为一旦 command 寄存器被写入后，硬盘就开始干活啦，它才不管其他寄存器中 的值对不对，一律拿来就用，有问题的话报错就好啦。其他寄存器顺序不是很重要。

*（1）先选择通道，往该通道的 sector count 寄存器中写入待操作的扇区数。*
*（2）往该通道上的三个 LBA 寄存器写入扇区起始地址的低 24 位。*
*（3）往 device 寄存器中写入 LBA 地址的 24～27 位，并置第 6 位为 1，使其为 LBA 模式，设置第 4位，选择操作的硬盘（master 硬盘或 slave 硬盘）。*
*（4）往该通道上的 command 寄存器写入操作命令。*
*（5）读取该通道上的 status 寄存器，判断硬盘工作是否完成。*
*（6）如果以上步骤是读硬盘，进入下一个步骤。否则，完工。*
*（7）将硬盘数据读出。*

硬盘工作完成后，它已经准备好了数据，咱们该怎么获取呢？一般常用的数据传送方式如下。

*（1）无条件传送方式。*
*（2）查询传送方式。*
*（3）中断传送方式。*
*（4）直接存储器存取方式（DMA）。*
*（5）I/O 处理机传送方式。*

**第 1 种 “无条件传送方式”**，应用此方式的数据源设备一定是随时准备好了数据，CPU 随时取随时拿都没问题，如寄存器、内存就是类似这样的设备，CPU 取数据时不用提前打招呼。 

**第 2 种 “查询传送方式”**，也称为程序 I/O、PIO（Programming Input/Output Model），是指传输之前， 由程序先去检测设备的状态。数据源设备在一定的条件下才能传送数据，这类设备通常是低速设备，比 CPU 慢很多。CPU 需要数据时，先检查该设备的状态，如果状态为“准备好了可以发送”，CPU 再去获取数据。硬盘有 status 寄存器，里面保存了工作状态，所以对硬盘可以用此方式来获取数据。 

**第 3 种 “中断传送方式”**，也称为中断驱动 I/O。上面提到的“查询传送方式”有这样的缺陷，由于 CPU 需要不断查询设备状态，所以意味着只有最后一刻的查询才是有意义的，之前的查询都是发生在数据尚未准 备好的时间段里，所以说效率不高，仅对于不要求速度的系统可以采用。可以改进的地方是如果数据源设备将数据准备好后再通知 CPU 来取，这样效率就高了。通知 CPU 可以采用中断的方式，当数据源设备准备好 数据后，它通过发中断来通知 CPU 来拿数据，这样避免了 CPU 花在查询上的时间，效率较高。

 **第 4 种 “直接存储器存取方式（DMA）”**。在中断传送方式中，虽然极大地提高了 CPU 的利用率，但通过中断方式来通知 CPU，CPU 就要通过压栈来保护现场，还要执行传输指令，最后还要恢复现场。没有浪费 CPU 资源，不让 CPU 参与传输，完全由数据源设备和内存直接传输。CPU 直接到内存中拿数据就好了。这就是此方式中“直接”的意思。不过 DMA 是由硬件实现的，不是软件概念，所以需要 DMA 控制器才行。

 **第 5 种 “I/O 处理机传送方式”**。不知大家发现了没有，在说上面每一种的时候都把它们各自说得特别好，似乎完美不可替代了。DMA 已经借助其他硬件了，CPU 已经很轻松了，难道还有更爽的方式？是啊，DMA 方式中 CPU 还嫌爽的不够，毕竟数据输入之后或输出之前还是有一部分工作要由 CPU 来完成的，如数据交换、组合、校验等。 如果 DMA 控制器再强大一点，把这些工作帮 CPU 做了就好。也是哦，既然为了解放 CPU，都已经引用一个硬件（DMA）了，干脆一不做二不休，再引入一个硬件吧。于是，I/O 处理机诞生啦，听名字就知道它专门用于处理 IO，并且它其实是一种处理器，只不过用的是另一套擅长 IO 的指令系统，随时可以处 理数据。有了 I/O 处理机的帮忙，CPU 甚至可以不知道有传输这回事，这下 CPU 才真正爽到家啦。同样， 这也是需要单独的硬件来支持。 

综上所述，硬盘不符合第 1 种方法，因为它需要在某种条件下才能传输。第 4 种和第 5 种需要单独 4的硬件支持，先不说我们的 bochs 能否模拟这两种硬件，单独学习这两类硬件的操作方法就很头疼，所以我们用了第 2、3 这两种软件传输方式。

## **改造MBR**

由于MBR 只有 512 字节，这小小的空间，着实干不了什么大事 。。。所以做个稍微大一点的改进，经过这个改进后，我们的 MBR 可以读取硬盘。

这时候 **loader** ，即**加载器**出现了，它在另一个程序中完成初始化环境及加载内核的任务。

**MBR** 负责从硬盘上把 **loader 加载到内存**

**细节要求** ： 首先 loader 中要定义一些**数据结构**（如 GDT 全局描述符表，不懂没关系，以后会说），这些数据结构将来的内核还是要用的，所以 loader 加载到内存后不能被覆盖。 其次，随着咱们不断添加功能，内核必然越来越大，其所在的内存地址也会向越来越高的地方发展，所以，尽量把 loader 放在低处。

```asm
 ;主引导程序
 ;------------------------------------------------------------
 %include "boot.inc"
 SECTION MBR vstart=0x7c00
 mov ax,cs
 mov ds,ax
 mov es,ax
 mov ss,ax
 mov fs,ax
 mov sp,0x7c00
 mov ax,0xb800
 mov gs,ax

 ;清屏
 ;利用 0x06 号功能，上卷全部行，则可清屏
 ; -----------------------------------------------------------
 ;INT 0x10 功能号：0x06 功能描述：上卷窗口
 ;------------------------------------------------------
 ;输入：
 ;AH 功能号= 0x06
 ;AL = 上卷的行数（如果为 0，表示全部）
 ;BH = 上卷行属性
 ;(CL,CH) = 窗口左上角的(X,Y)位置
 ;(DL,DH) = 窗口右下角的(X,Y)位置
 ;无返回值：
 mov ax, 0600h
 mov bx, 0700h
 mov cx, 0 ; 左上角: (0, 0)
 mov dx, 184fh ; 右下角: (80,25),
 ; 因为 VGA 文本模式中，一行只能容纳 80 个字符，共 25 行
 ; 下标从 0 开始，所以 0x18=24，0x4f=79
 int 10h ; int 10h

 ; 输出字符串:MBR
 mov byte [gs:0x00],'1'
 mov byte [gs:0x01],0xA4

 mov byte [gs:0x02],' '
 mov byte [gs:0x03],0xA4

 mov byte [gs:0x04],'M'
 mov byte [gs:0x05],0xA4
;A 表示绿色背景闪烁,4 表示前景色为红色
 
 mov byte [gs:0x06],'B'
 mov byte [gs:0x07],0xA4

 mov byte [gs:0x08],'R'
 mov byte [gs:0x09],0xA4
 
 mov eax,LOADER_START_SECTOR ; 起始扇区 lba 地址
 mov bx,LOADER_BASE_ADDR ; 写入的地址
 mov cx,1 ; 待读入的扇区数
 call rd_disk_m_16 ; 以下读取程序的起始部分(一个扇区)

 jmp LOADER_BASE_ADDR

 ;-------------------------------------------------------------------------------
 ;功能:读取硬盘 n 个扇区
 rd_disk_m_16:
 ;-------------------------------------------------------------------------------
 ; eax=LBA 扇区号
 ; bx=将数据写入的内存地址
 ; cx=读入的扇区数
 mov esi,eax ;备份 eax
 mov di,cx ;备份 cx
 ;读写硬盘:
 ;第 1 步:设置要读取的扇区数
 mov dx,0x1f2
 mov al,cl
 out dx,al ;读取的扇区数

 mov eax,esi ;恢复 ax

 ;第 2 步:将 LBA 地址存入 0x1f3 ～ 0x1f6

 ;LBA 地址 7～0 位写入端口 0x1f3
 mov dx,0x1f3
 out dx,al

 ;LBA 地址 15～8 位写入端口 0x1f4
 mov cl,8
 shr eax,cl
 mov dx,0x1f4
 out dx,al
 
 ;LBA 地址 23～16 位写入端口 0x1f5
 shr eax,cl
 mov dx,0x1f5
 out dx,al

 shr eax,cl
 and al,0x0f ;lba 第 24～27 位
 or al,0xe0 ; 设置 7～4 位为 1110,表示 lba 模式
 mov dx,0x1f6
 out dx,al
  
 ;第 3 步:向 0x1f7 端口写入读命令,0x20
 mov dx,0x1f7
 mov al,0x20
 out dx,al

 ;第 4 步:检测硬盘状态
 .not_ready:
 ;同一端口,写时表示写入命令字,读时表示读入硬盘状态
 nop
 in al,dx
 and al,0x88 ;第 4 位为 1 表示硬盘控制器已准备好数据传输
 ;第 7 位为 1 表示硬盘忙
 cmp al,0x08
 jnz .not_ready ;若未准备好,继续等

 ;第 5 步:从 0x1f0 端口读数据
 mov ax, di
 mov dx, 256
 mul dx
 mov cx, ax
 ; di 为要读取的扇区数,一个扇区有 512 字节,每次读入一个字
 ; 共需 di*512/2 次,所以 di*256
 mov dx, 0x1f0
 
 .go_on_read:
 in ax,dx
 mov [bx],ax
 add bx,2
 loop .go_on_read
 ret

 times 510-($-$$) db 0
 db 0x55,0xaa 
```

```
汇编语言中，CPU对外设的操作通过专门的端口读写指令来完成；
读端口用IN指令，写端口用OUT指令。
例子如下：
IN AL,21H；表示从21H端口读取一字节数据到AL
IN AX,21H；表示从端口地址21H读取1字节数据到AL，从端口地址22H读取1字节到AH
MOV DX,379H
IN AL,DX ；从端口379H读取1字节到AL
OUT 21H,AL；将AL的值写入21H端口
OUT 21H,AX；将AX的值写入端口地址21H开始的连续两个字节。（port[21H]=AL,port[22h]=AH）
MOV DX,378H
OUT DX,AX ；将AH和AL分别写入端口379H和378H
```

boot.inc 是我们的配置文件，我们目前关于加载器的配置信息就写在里面。

```
;------------- loader 和 kernel ----------
LOADER_BASE_ADDR equ 0x900
LOADER_START_SECTOR equ 0x2
```

编译 写入虚拟硬盘

```
添加个库目录 + 编译
--nasm -I include/ -o mbr.bin mbr.S  
下面将生成的 mbr.bin 写入我们的虚拟硬盘，还是用 dd 命令。
--sudo dd if=/your_path/mbr.bin of=/your_path/bochs/hd60M.img bs=512 count=1 conv=notrunc
--sudo dd if=/home/fyz/sc/bochs-2.6.2/mbr.bin of=/home/fyz/sc/bochs-2.6.2/hd60M.img bs=512 count=1 conv=notrunc
```

我们先不要运行 因为我们 loader 还没写，若此时执行此 MBR，CPU 会直接跳到 0x900 的地方。。。

**现在我们开始写 loader** 

```asm
 ;loader.S
 %include "boot.inc" 
 section loader vstart=LOADER_BASE_ADDR 
 
 mov byte [gs:0x00],'2'
 mov byte [gs:0x01],0xA4 ; A 表示绿色背景闪烁，4 表示前景色为红色

 mov byte [gs:0x02],' '
 mov byte [gs:0x03],0xA4

 mov byte [gs:0x04],'L'
 mov byte [gs:0x05],0xA4

 mov byte [gs:0x06],'O'
 mov byte [gs:0x07],0xA4

 mov byte [gs:0x08],'A'
 mov byte [gs:0x09],0xA4

 mov byte [gs:0x0a],'D'
 mov byte [gs:0x0b],0xA4

 mov byte [gs:0x0c],'E'
 mov byte [gs:0x0d],0xA4

 mov byte [gs:0x0e],'R'
 mov byte [gs:0x0f],0xA4

 jmp $ ; 通过死循环使程序悬停在此
```

```
添加个库目录 + 编译
--nasm -I include/ -o loader.bin loader.S
将生成的 loader.bin 写入硬盘第 2 个扇区。第 0 个扇区是 MBR，第 1 个扇区是空的未使用。（ 我就喜欢 你咋的
--sudo dd if=./loader.bin of=/your_path/bochs/hd60M.img bs=512 count=1 seek=2 conv=notrunc
--sudo dd if=./loader.bin of=/home/fyz/sc/bochs-2.6.2/hd60M.img bs=512 count=1 seek=2 conv=notrunc

得到
记录了0+1 的读入
记录了0+1 的写出
98 bytes copied, 0.0976747 s, 1.0 kB/s

模拟
--sudo bin/bochs -f bochsrc.disk
```

已经成功运行

 ![image-20201015111210074](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201015111210074.png)

# 保护模式

**实模式的缺点：**

1. 操作系统和用户程序处于同一特权级。
2. 用户程序所引用的地址都是指向真实的物理地址。
3. 用户程序可以自行修改段基址，可以访问所有内存。
4. 访问超过 64KB 的内存区域要切换段基址。
5. 一次只能运行一个程序。
6. 共 20 条地址线，最大可用内存 1 MB 。

## **寄存器扩展**

各寄存器在原有 16 位的基础上，再次向高位扩展了 16 位，成为了 32 位寄存器。经过 extend 后的寄存器，统 一在名字前加了 e 表示扩展。

 ![image-20201016212543280](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201016212543280.png)

**段描述符缓冲寄存器（Descriptor Cache Registers）** ： ，在 80286 的保护模式中，为了提高获取段信息的效率，对段寄存器率先应用了缓存技术，将段信息用一个寄存器来缓存。CPU 每次将千辛万苦获取到的内存段信息，整理成“完整的、通顺、不蹩脚”的形式后，存入段描述符缓冲寄存器， 以后每次访问相同的段时，就直接读取该段寄存器对应的段描述符缓冲寄存器。

**段描述符缓冲寄存器结构**

 ![image-20201016212645319](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201016212645319.png)

**保护模式之寻址扩展** 

 ![image-20201016213443567](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201016213443567.png)



## **段描述符** 

段描述符格式

 ![image-20201016214958082](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201016214958082.png)

```
段描述符的低32位 
: 0-15      段界限的前 0～15 位
: 16-31     存储段基址的 0～15 位
段描述符的高32位 
: 0-7       段基址的 16～23
: 8-11      type字段 -> 描述符的类型
: 12        S字段  ->  是否是系统段      
: 13-14     DPL(Descriptor Privilege Level)描述符特权级 -> 有 0、1、2、3 级特权，数字越小，特权级越大
: 15        P字段(Present) -> 段是否存在
: 16-19     段界限的第 16～19 位
: 20        AVL字段 -> 操作系统可以随意用此位(馈赠)
: 21        L字段 -> 是否设置64位代码段
: 22        D/B字段 -> 指示有效地址（段内偏移地址）及操作数的大小
: 23        G字段 -> 指定段界限的单位大小
: 24-31     是段基址的第 24～31 位
```

继续解释下字段。（ 需要的时候来查看

```
高32位 0-7位是段基址的16-23 + 24-31位是段基址的24-31位 + 低32位 16-31位是段基址0-15位 == 32位基地址。

高32位 16-19位是段界限的16-19 + 低32位 16-31位是段界限0-15 == 20位的段界限。

高32位 8-11位是 type 字段，共4位，用来指定本描述符的类型。(用于表示内存段或门的子类型)

S字段 : CPU 眼里分为两大类，要么描述的是系统段，要么描述的是数据段，这是由段描述符中的 S 位决定的，用它指示是否是系统段。在 CPU 眼里，凡是硬件运行需要用到的东西都可称之为系统，凡是软件（操作系统也属于软件，CPU 眼中，它与用户程序无区别）需要的东西都称为数据，无论是代码，还是数据，甚至包括栈，它们都作为硬件的输入，都是给硬件的数据而已，所以代码段在段描述符中也属于数据段（非系统段）。S 为 0 时表示系统段，S 为 1 时表示数据段。type 字段是要和 S 字段配合在一起才能确定段描述符的确切类型，只有 S 字段的值确定后，type 字段的值才有具体意义。

DPL字段 : 这是保护模式提供的安全解决方案，将计算机世界按权力划分成不同等级，每一种等级称为一种特权级。由于段描述符用来描述一个内存段或一段代码的情况（若描述符类型为“门”），所以描述符中的 DPL是指所代表的内存段的特权级。这两位能表示 4 种特权级，分别是 0、1、2、3 级特权，数字越小，特权级越大。特权级是保护模式下才有的东西，CPU 由实模式进入保护模式后，特权级自动为 0。因为保护模式下的代码已经是操作系统的一部分啦，所以操作系统应该处于最高的 0 特权级。用户程序通常处于 3 特权级，权限最小。某些指令只能在 0 特权级下执行，从而保证了安全。

P字段 : 段是否存在。如果段存在于内存中，P 为 1，否则 P 为 0。P 字段是由 CPU 来检查的，如果为 0，CPU 将抛出异常，转到相应的异常处理程序，此异常处理程序是咱们来写的，在异常处理程序处理完成后要将 P 置 1。也就是说，对于 P 字段，CPU 只负责检查，咱们负
责赋值。不过在通常情况下，段都是在内存中的。当初 CPU 的设计是当内存不足时，可以将段描述符中对应的内存段换出，也就是可以把不常用的段直接换出到硬盘，待使用时再加载进来。但现在即使内存不足时，也没有将整个段都换出去的，现在基本都是平坦模型，一般情况下，段都要 4GB 大小，换到硬盘不也是很占空间吗？而且这些平坦的段都是公用的，换出去就麻烦啦。所以这些是未开启分页时的解决方案，保护模式下有分页功能，可以按页（4KB）的单位来将内存换入换出。

AVL字段 : 从名字上看它是 AVaiLable，可用的。不过这“可用的”是对用户来说的，也就是操作系统可以随意用此位。对硬件来说，它没有专门的用途，就当作是硬件给软件的馈赠吧。

L字段 : 用来设置是否是 64 位代码段。L 为 1 表示 64 位代码段，否则表示 32位代码段。这目前属于保留位，在我们 32 位 CPU 下编程，将其置为 0 便可。

D/B字段 : 用来指示有效地址（段内偏移地址）及操作数的大小。有没有觉得奇怪，实模式已经是 32 位的地址线和操作数了，难道操作数不是 32 位大小吗？其实这是为了兼容 286 的保护模式，286 的保护模式下的操作数是 16 位。既然是指定“操作数”的大小，也就是对“指令”来说
的，与指令相关的内存段是代码段和栈段，所以此字段是 D 或 B。

对于代码段来说，此位是 D 位，若 D 为 0，表示指令中的有效地址和操作数是 16 位，指令有效地址用 IP 寄存器。若 D 为 1，表示指令中的有效地址及操作数是 32 位，指令有效地址用 EIP 寄存器。对于栈段来说，此位是 B 位，用来指定操作数大小，此操作数涉及到栈指针寄存器的选择及栈的地址上限。若 B 为 0，使用的是 sp 寄存器，也就是栈的起始地址是 16 位寄存器的最大寻址范围，0xFFFF。
若 B 为 1，使用的是 esp 寄存器，也就是栈的起始地址是 32 位寄存器的最大寻址范围，0xFFFFFFFF。段描述符的第 23 位是 G 字段，Granularity，粒度，用来指定段界限的单位大小。所以此位是用来配合段界限的，它与段界限一起来决定段的大小。若 G 为 0，表示段界限的单位是 1 字节，这样段最大是 2的 20 次方*1 字节，即 1MB。若 G 为 1，表示段界限的单位是 4KB，这样段最大是 2 的 20 次方*4KB 字节，即 4GB。
```

 ![image-20201017005810206](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201017005810206.png)

**TYPE:** 
位0:A(accessed)位,表明描述符是否已被访问;把选择子装入段寄存器时,该位被标记为1 
位3:E(EXECUTABLE?)位,0说明所描述段为数据段;1为可执行段(代码段) 

当为数据段时, 
  位1为W位,说明该数据段是否可写(0只读,1可写) 
  位2为ED位,说明该段的扩展方向(0向高位扩展,1向低位扩展) 
当为可执行段是, 
  位1为R位,说明该执行段是否可读(0只执行,1可读) 
  位2为C位,0说明该段不是一致码段(普通代码段),1为一致码段 

**全局描述符表 GDT、局部描述符表 LDT 及选择子**

**全局描述符表GDT（Global Descriptor Table）**：在整个系统中，全局描述符表GDT只有一张(一个处理器对应一个GDT)，GDT可以被放在内存的任何位置，但CPU必须知道GDT的入口，也就是基地址放在哪里，Intel的设计者门提供了一个**寄存器GDTR**用来存放GDT的入口地址，程序员将GDT设定在内存中某个位置之后，可以通过**LGDT指令**将GDT的入口地址装入此寄存器，从此以后，CPU就根据此寄存器中的内容作为GDT的入口来访问GDT了。GDTR中存放的是GDT在内存中的基地址和其表长界限。

 ![image-20201016234534734](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201016234534734.png)

不过，对此寄存器的访问，不能够用 mov gdtr，xxx 这样的指令为 gdtr 初始化，有专门的指令来做这件事，这就是 **lgdt 指令**。虽然我们是为了进入保护模式才讲述的 lgdt，因此看上去此指令是在实模式下执行的，但实际上，此指令在保护模式下也能够执行。言外之意便是进入保护模式需要有 GDT，但进入保护模式后，还可以再重新换个 GDT 加载。在保护模式下重新换个 GDT 的原因是实模式下只能访问低端 1MB 空间，所以 GDT 只能位于 1MB 之内。根据操作系统的实际情况，有可能需要把 GDT 放在其他的内存位置，所以在进入保护模式后，访问的内存空间突破了 1MB，可以将 GDT 放在合适的位置后再重新加载进来。

**段选择子包括三部分：描述符索引（index）、TI（指示从GDT还是LDT中找）、请求特权级（RPL）。**

1. index部分表示所需要的段的描述符在描述符表的**位置**，由这个位置再根据在GDTR中存储的描述符表基址就可以找到相应的描述符gdt_entry。然后用描述符gdt_entry中的段基址SEL加上逻辑地址OFFSET就可以转换成线性地址SEL:OFFSET（看下面给的例子应该就是它们的和SEL+OFFSET）
2. 段选择子中的TI值只有一位0或1，0代表选择子是在GDT选择，1代表选择子是在LDT选择。
3. 请求特权级（RPL）则代表选择子的特权级，共有4个特权级（0级、1级、2级、3级），0级最高。关于特权级的说明：任务中的每一个段都有一个特定的级别。每当一个程序试图访问某一个段时，就将该程序所拥有的特权级与要访问的特权级进行比较，以决定能否访问该段。系统约定，**CPU只能访问同一特权级或级别较低特权级的段**。

 ![image-20201017002922334](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201017002922334.png)



**局部描述符表LDT（Local Descriptor Table）** ： 局部描述符表可以有若干张，每个任务可以有一张。我们可以这样理解GDT和LDT：GDT为一级描述符表，LDT为二级描述符表。LDT和GDT从本质上说是相同的，只是LDT嵌套在GDT之中。LDTR记录局部描述符表的起始位置，与GDTR不同LDTR的内容是一个段选择子。由于LDT本身同样是一段内存，也是一个段，所以它也有个描述符描述它，这个描述符就存储在GDT中，对应这个表述符也会有一个选择子，LDTR装载的就是这样一个选择子。LDTR可以在程序中随时改变，通过使用lldt指令。

 

现在来梳理下**保护模式下的寻址方式**：

1. 段寄存器存放段选择子；
2. CPU 根据段选择子从GDT中找到对应段描述符；
3. 从段描述符中取出段基址。
4. 根据之前的公式，结合段基址和段内偏移，计算出物理地址。

![image-20201017004131211](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201017004131211.png) ![image-20201016213941806](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201016213941806.png)

```
例如选择子是 0x8，将其加载到 ds 寄存器后，访问 ds：0x9 这样的内存，其过程是：0x8 的低 2 位是RPL，其值为 00。第 2 是 TI，其值 0，表示是在 GDT 中索引段描述符。用 0x8 的高 13 位 0x1 在 GDT 中索引，也就是 GDT 中的第 1 个段描述符（GDT 中第 0 个段描述符不可用）。假设第 1 个段描述符中的 3个段基址部分，其值为 0x1234。CPU 将 0x1234 作为段基址，与段内偏移地址 0x9 相加，0x1234+0x9=0x123d。用所得的和 0x123d 作为访存地址。
值得注意的是上面括号中提到了 GDT 中的第 0 个段描述符是不可用的，原因是定义在 GDT 中的段描述符是要用选择子来访问的，如果使用的选择子忘记初始化，选择子的值便会是 0，这便会访问到第 0 个段描述符。为了避免出现这种因忘记初始化选择子而选择到第 0 个段描述符的情况，GDT 中的第 0 个段描述符不可用。也就是说，若选择到了 GDT 中的第 0 个描述符，处理器将发出异常。
```



**打开 A20 地址线** 

地址（Address）线从 0 开始编号，在 8086/8088 中，只有 20 位地址线，即 **A0～A19**。20 位地址线表 示的内存是 2 的 20 次方，最大是 1MB，即 0x0～0xFFFFF。内存若超过 1MB，是需要第 21 条地址线支 持的。所以说，若地址进位到 1MB 以上，如 0x100000，由于没有第 21 位地址线，相当于丢掉了进位 1， 变成了 0x00000。

![image-20201017035122422](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201017035122422.png) 

对于 80286 后续的 CPU，通过 A20GATE 来控制 A20 地址线。

IBM 在键盘控制器上的一些输出线来控制第 21 根地址线（A20）的有效性，故被称为 **A20Gate**。 如果 A20Gate 被打开，当访问到 0x100000～0x10FFEF 之间的地址时，CPU 将真正访问这块物理内存。如果 A20Gate 被禁止，当访问 0x100000～0x10FFEF 之间的地址时，CPU 将采用 8086/8088 的地址回绕。 上面描述了地址回绕的原理，但地址回绕是为了兼容 8086/8088 的实模式。如今我们是在保护模式下， 我们需要突破第 20 条地址线（A20）去访问更大的内存空间。而这一切，只有关闭了地址回绕才能实现。 而关闭地址回绕，就是上面所说的打开 A20Gate。

打开 A20Gate 的方式是 **将端口 0x92 的第 1 位置 1 就可以了**

```asm
in al，0x92
or al，0000_0010B
out 0x92，al 
```



**保护模式的开关，CR0 寄存器的 PE 位** 

 ![image-20201017035748978](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201017035748978.png)

![image-20201017035808867](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201017035808867.png)

当打开 CR0 寄存器的 PE 位后，CPU 才真正进入保护模式，所以这是进入保护模式三步中的最后一步。

 PE 为 0 表示在实模式下运行，PE 为 1 表示在保护模式下运行。

```asm
 mov eax, cr0
 or eax, 0x00000001
 mov cr0, eax 
```

## 保护模式内存管理

IA-32架构内存管理机制分两部分：**分段机制和分页机制**。分段机制使代码段、数据段和堆栈段**相互独立**，这样多任务才可以在一个处理器上运行还不会被其它程序干扰。分页机制为传统需求页、虚拟内存系统提供了实现机制。其中虚拟内存系统用于实现程序代码按需映射到物理内存中。分页也使多任务之前相关隔离。在保护模式下，**分段机制是必须实现的**，没有模式位用来关键分段；但是**分页机制是可选的。**

这两种机制可以支持单任务系统、多任务系统或者支持共享内存的多处理器系统。**如下图**分段制机制提供处理器可寻址内存空（线性地址）到段地址空间的地址变换。段可用来存放数据、代码、堆栈以及系统数据结构**TSS和LDT**。假如一个处理器上有多个任务（程序）同时运行，那么每个任务都有自己段集。然后处理器可以加强这些段之前的界线，并且确保一个程序不会通过写入另一个程序的段而干扰程序的执行。段机制对段进行了分类，这样对特别类型的段的访问能够受限制。

 ![image-20201020154053429](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201020154053429.png)

一个系统中的所有段都在处理器的线性地址空间中。为了定位段中的一个字节，必须提供**逻辑地址**（logical  address，也叫远指针）。一个逻辑地址由段选择符和偏移值组成。段选择符唯一标志一个段，除此之外，段选择符还提供描述符表（比如GDT）中称为段描述符的数据结构的偏移地址。每一个段都有一个段描述符，它用来指定段的大小，访问权限，段的特权级，段类型和线性地址空间中的段基地址。逻辑地址中的偏移地址加上段基地址就可以定位段中的一个字节。所以基地址加上偏移地址就形成了处理器线性地址空间中的线性地址（linear address）。

**假如没有启用分页**，那么处理器的线性地址就直接映射到物理地址空间。物理地址空间的大小范围由处理器的数据总线位数决定。

因为多任务系统定义的线性地址空间通常比实际物理内存大，所以需要某种虚拟化线性地址空间的方法。虚拟化线性地址空间就是通过处理器的分页机制实现的。

分页支持的虚拟内存环境，需要由小块的物理内存（RAN或ROM）和一些硬盘存储介质来模拟大容量的线性地址空间。当使用分页时，每个段被分成很多页（典型的页大小为4KB），页存储在物理内存或者硬盘中。操作系统通过维护一个页目录和一组页表集来跟踪页。当一个程序尝试访问线性地址空间中的地址时，处理器通过页目录和页表把线性地址空间转换到物理地址空间中，然后在物理内存位置完成相应的操作请求（读或写）。

**假如被访问的页不在当前物理内存中**，那么处理器将中断当前程序执行（通过产生页错误异常），然后操作系统或执行指令从硬盘读取页到物理内存中并继续执行当前中断的程序。

**当操作系统正确的完成分页时，**硬盘和物理内存的交换对于程序正确的执行是透明的。



### 基本的平坦模型

**系统最简单的内存模型称为“基本平坦模型”**，这种模型下操作系统和应用程序都可以访问连续的、不分段的地址空间。对于系统设计者和应用程序开发者来说最大限度的隐藏了分段机制。

为了实现内存基本平坦模型，至少需要**两个段描述符，一个用来指向代码段，另一个指向数据段**，如下图所示。这两个段都映射到整个线性地址空间：也就是说，两个段描述符都有同样的基地址为0和同样的段限长4GBytes。通过设置4GBytes的段限长，当访问超过出了段限长分段机制也不会产生异常，甚至所访问的地址并没有物理内存。ROM（EPROM）通常过被放在物理内存最高地址处，因为处理器一开始执行FFFFFFF0H处RAM（DRAM）被放在地址空间最低处，因为在系统复位后DS数据段基地址被初始化为0。

![image-20201020154412911](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201020154412911.png) 

### 保护模式平坦模型

保护模式平坦模型和基本平坦模型类似，只不过段限长的范围设置成实际物理内存大小。

当访问实际不存在的物理地址空间时会生成一个普通的保护异常，如图8所示。这种模型提供了最低级别的硬件保护来访问一些程序bug。

这种保护模型平坦模型可以变得更复杂来提供更多保护。例如，为了分页机制中提供普通用户和超级用户的代码和数据，必须定义四个段：普通用户特权级为3的代码和数据段，超级用户特权级为0的代码和数据段。通常这些段相互重叠并且从线性地址0开始。这种平坦分段模型加上一个简单的分页结构就可以在应用程序和操作系统之间起保护作用，如果为每个任务增加一个单独的页结构，那么就可以给应用程序之前提供保护了。同样的设计被用于一些流行的多任务操作系统。

 ![image-20201020154508729](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201020154508729.png)

### 多段模型

一个多段模型，充分发挥了段机制的对代码、数据结构和程序提供硬件保护的能力。每个程序都有自己的段描述符表和自己的段。段可以完全属于程序私有也可以和其它程序之前共享。

访问权限的检查不仅仅用来保护地址越界，也可以保护某一特定段不允许操作。例如代码段是只读段，硬件可以阻击向代码段进行写操作。为段建立的访问权限信息也可以用来建议保护级别。保护级别可以用来防止未认证的应用层程序访问操作系统程序

 ![image-20201020154628781](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201020154628781.png)

## 进入保护模式

要进入保护模式，要完成 3 步：

1. 设置 GDT 表。
2. 打开 A20 地址线。
3. 将 cr0 寄存器的 pe 位置 1 。

### 完善代码

首先我们需要增大 mbr.S 中加载 loader.bin 的读入扇区数。

loader.bin 是由 mbr.bin 中的函数 rd_disk_m_16 负责加载的，其参数“读入扇区数”存入 cx 寄存器中。 所以，如果 loader.bin 的大小**超过** mbr 所读取的扇区数，切记**一定要修改** mbr.S 中函数 rd_disk_m_16 的读 入扇区数。

修改后的 mbr.S  ->  将扇区数修改为 4 。

```asm
 ;主引导程序
 ;------------------------------------------------------------
 %include "boot.inc"
 SECTION MBR vstart=0x7c00
 mov ax,cs
 mov ds,ax
 mov es,ax
 mov ss,ax
 mov fs,ax
 mov sp,0x7c00
 mov ax,0xb800
 mov gs,ax

 ;清屏
 ;利用 0x06 号功能，上卷全部行，则可清屏
 ; -----------------------------------------------------------
 ;INT 0x10 功能号：0x06 功能描述：上卷窗口
 ;------------------------------------------------------
 ;输入：
 ;AH 功能号= 0x06
 ;AL = 上卷的行数（如果为 0，表示全部）
 ;BH = 上卷行属性
 ;(CL,CH) = 窗口左上角的(X,Y)位置
 ;(DL,DH) = 窗口右下角的(X,Y)位置
 ;无返回值：
 mov ax, 0600h
 mov bx, 0700h
 mov cx, 0 ; 左上角: (0, 0)
 mov dx, 184fh ; 右下角: (80,25),
 ; 因为 VGA 文本模式中，一行只能容纳 80 个字符，共 25 行
 ; 下标从 0 开始，所以 0x18=24，0x4f=79
 int 10h ; int 10h

 ; 输出字符串:MBR
 mov byte [gs:0x00],'1'
 mov byte [gs:0x01],0xA4

 mov byte [gs:0x02],' '
 mov byte [gs:0x03],0xA4

 mov byte [gs:0x04],'M'
 mov byte [gs:0x05],0xA4
;A 表示绿色背景闪烁,4 表示前景色为红色
 
 mov byte [gs:0x06],'B'
 mov byte [gs:0x07],0xA4

 mov byte [gs:0x08],'R'
 mov byte [gs:0x09],0xA4
 
 mov eax,LOADER_START_SECTOR ; 起始扇区 lba 地址
 mov bx,LOADER_BASE_ADDR ; 写入的地址
 mov cx,4 ; 待读入的扇区数
 call rd_disk_m_16 ; 以下读取程序的起始部分(一个扇区)

 jmp LOADER_BASE_ADDR

 ;-------------------------------------------------------------------------------
 ;功能:读取硬盘 n 个扇区
 rd_disk_m_16:
 ;-------------------------------------------------------------------------------
 ; eax=LBA 扇区号
 ; bx=将数据写入的内存地址
 ; cx=读入的扇区数
 mov esi,eax ;备份 eax
 mov di,cx ;备份 cx
 ;读写硬盘:
 ;第 1 步:设置要读取的扇区数
 mov dx,0x1f2
 mov al,cl
 out dx,al ;读取的扇区数

 mov eax,esi ;恢复 ax

 ;第 2 步:将 LBA 地址存入 0x1f3 ～ 0x1f6

 ;LBA 地址 7～0 位写入端口 0x1f3
 mov dx,0x1f3
 out dx,al

 ;LBA 地址 15～8 位写入端口 0x1f4
 mov cl,8
 shr eax,cl
 mov dx,0x1f4
 out dx,al
 
 ;LBA 地址 23～16 位写入端口 0x1f5
 shr eax,cl
 mov dx,0x1f5
 out dx,al

 shr eax,cl
 and al,0x0f ;lba 第 24～27 位
 or al,0xe0 ; 设置 7～4 位为 1110,表示 lba 模式
 mov dx,0x1f6
 out dx,al
  
 ;第 3 步:向 0x1f7 端口写入读命令,0x20
 mov dx,0x1f7
 mov al,0x20
 out dx,al

 ;第 4 步:检测硬盘状态
 .not_ready:
 ;同一端口,写时表示写入命令字,读时表示读入硬盘状态
 nop
 in al,dx
 and al,0x88 ;第 4 位为 1 表示硬盘控制器已准备好数据传输
 ;第 7 位为 1 表示硬盘忙
 cmp al,0x08
 jnz .not_ready ;若未准备好,继续等

 ;第 5 步:从 0x1f0 端口读数据
 mov ax, di
 mov dx, 256
 mul dx
 mov cx, ax
 ; di 为要读取的扇区数,一个扇区有 512 字节,每次读入一个字
 ; 共需 di*512/2 次,所以 di*256
 mov dx, 0x1f0
 
 .go_on_read:
 in ax,dx
 mov [bx],ax
 add bx,2
 loop .go_on_read
 ret

 times 510-($-$$) db 0
 db 0x55,0xaa 
```

接着需要修改 include/boot.inc 。里面是一些配置信息，loader.S 中用到的配置都是定义在 boot.inc 中的符号。

（  \ 建议去掉，可能报错。

```asm
 ;------------- loader 和 kernel ----------

 LOADER_BASE_ADDR equ 0x900
 LOADER_START_SECTOR equ 0x2

 ;-------------- gdt 描述符属性 -------------
 DESC_G_4K equ 1_00000000000000000000000b
 DESC_D_32 equ 1_0000000000000000000000b
 DESC_L equ 0_000000000000000000000b
 ;64 位代码标记,此处标记为 0 便可
 DESC_AVL equ 0_00000000000000000000b
 ; CPU 不用此位,暂置为 0
 DESC_LIMIT_CODE2 equ 1111_0000000000000000b
 DESC_LIMIT_DATA2 equ DESC_LIMIT_CODE2
 DESC_LIMIT_VIDEO2 equ 0000_000000000000000b
 DESC_P equ 1_000000000000000b
 DESC_DPL_0 equ 00_0000000000000b
 DESC_DPL_1 equ 01_0000000000000b
 DESC_DPL_2 equ 10_0000000000000b
 DESC_DPL_3 equ 11_0000000000000b
 DESC_S_CODE equ 1_000000000000b
 DESC_S_DATA equ DESC_S_CODE
 DESC_S_sys equ 0_000000000000b
 DESC_TYPE_CODE equ 1000_00000000b
 ;x=1,c=0,r=0,a=0 代码段是可执行的，非一致性，不可读，已访问位 a 清 0
 DESC_TYPE_DATA equ 0010_00000000b
 ;x=0,e=0,w=1,a=0 数据段是不可执行的，向上扩展的，可写，已访问位 a 清 0

 DESC_CODE_HIGH4 equ (0x00 << 24) + DESC_G_4K + DESC_D_32 + \ 
DESC_L + DESC_AVL + DESC_LIMIT_CODE2 + \ 
DESC_P + DESC_DPL_0 + DESC_S_CODE + \ 
DESC_TYPE_CODE + 0x00
 DESC_DATA_HIGH4 equ (0x00 << 24) + DESC_G_4K + DESC_D_32 + \ 
DESC_L + DESC_AVL + DESC_LIMIT_DATA2 + \ 
DESC_P + DESC_DPL_0 + DESC_S_DATA + \ 
DESC_TYPE_DATA + 0x00
 DESC_VIDEO_HIGH4 equ (0x00 << 24) + DESC_G_4K + DESC_D_32 + \ 
DESC_L + DESC_AVL + DESC_LIMIT_VIDEO2 + DESC_P + \ 
DESC_DPL_0 + DESC_S_DATA + DESC_TYPE_D ATA + 0x00

 ;-------------- 选择子属性 ---------------
 RPL0 equ 00b
 RPL1 equ 01b
 RPL2 equ 10b
 RPL3 equ 11b
 TI_GDT equ 000b
 TI_LDT equ 100b 
```

主要是新增**段描述符的属性及选择子**，都是以**宏**的方式实现的。

equ 是 nasm 提供的伪指令，意为 equal，即等于，用于给表达式起个意义更明确的符号名，其指令格式是： **符号名称 equ 表达式**

描述符中的各个字段都是由 equ 来定义的，符号名一律采用 **“DESC字段名字段相关信息” **的形式。

在保护模式中，我们还是学习 Linux 等主流操作系统的内存段，用平坦模型。平坦模型之前已经提到 过了，就是整个内存都在一个段里，不用再像实模式那样用切换段基址的方式访问整个地址空间。在 32 位保护模式中，寻址空间是 4G，所以，平坦模型在我们定义的描述符中，段基址是 0，段界限*粒度等于 4G。粒度我们选的是 4k，故段界限是 0xFFFFF。

```
DESC_G_4K : 表示描述符的 G 位为 4K 粒度，其值等于（equ）1_00000000000000000000000b。 其中结尾的 b 表示二进制，之所以这样用二进制写属性位，就是为了在格式中的位置容易对比，最左边的 1 正好处在第 23 位，也就是段描述符中 G 的位次。1 右边的字符 “_” 没有特别的意义，只是我人为加上去的，这样人眼“看”起来显得比较清晰明朗，nasm 编译器做得很人性化，为了人看得方便，它特意支持这种分隔符的写法，在编译阶段会忽略此分隔符。

DESC_TYPE_CODE equ 1000_00000000b : 这是定义了一个代码段的 type 字段，右边的二进制串的 高 4 位就是 type 中的 4 位，右边用 ' _' 字符来分隔，确实直观了很多，如果您忘记了 type 中各位的意义， 赶紧回去翻看段描述符格式。此定义的意义在注释中已写得很清楚了：x=1，c=0，r=0，a=0 代码段是可执行的，非一致性，不可读，已访问位 a 清 0 。

DESC_CODE_HIGH4 : 就是定义了代码段的高 4 字节。equ 后面那一串加法表达式，就是在凑足段描述符这高 4 字节内容。其中（0x00 << 24）表示“段基址 24～31”字段，该字段位于段描述符高 4 字节中的第 24～31 位，由于平垣模式段基址是 0，所以咱们用 0 偏移 24 位填充该字段。当然这只是一部分段基址，段基址在 8 字节的段描述符中存在 3 处，它们在每处都会是 0 。

DESC_D_32 : 表示描述符中的 D/B 字段，对代码段来说是 D 位，在此表示 32 位操作数。
DESC_L : 表示段描述符中的 L 位，其值见代码 4-2 的第 9 行，为 0，表示为 32 位代码段。
DESC_AVL : 等于 0，此位没实际意义，是留给操作系统用的。
DESC_LIMIT_CODE2 : 是代码段的段界限的第 2 部分（段界限的第 1 部分在段描述符的低 4 字节中），此处值为 1111b，它与段界限的第 1 部分将组成 20 个二进制 1，即总共的段界限将是 0xFFFFF 。

DESC_P : 表示段存在。
DESC_DPL_0 : 表示该段描述符对应的内存段的特权级是 0，即最高特权级。当 CPU 在该段上运行时，将有至高无上的特权。
DESC_S_CODE : 表示代码段的 S 位，此值为 1，表示它是个普通的内存段，不是系统段。
DESC_TYPE_CODE : 上面有介绍，意义为 x=1，c=0，r=0，a=0 ，即代码段是可执行的，非一致性，不可读，已访问位 a 清 0。
0x00 : 是段基址的第 16～23 位，位于段描述符高 4字节的起始 8 位，如前所述，由于是平坦模型，所以段基址的任意部分都是 0。

```

这里并没有把选择子定义到这里，因为选择子中的高 13 位是用来索引段描述符的，它的值取决于段描述符的具体位置，而段描述符我们在 loader.S 中定义，所以最终的选择子是在 loader.S 中定义的，这样修改段描述符的位置时，顺便就把选择子修改了，否则放在多个文件中容易遗漏。

**开始修改 loader.S 文件**

```asm
     %include "boot.inc"
     section loader vstart=LOADER_BASE_ADDR
     LOADER_STACK_TOP equ LOADER_BASE_ADDR
     jmp loader_start

     ;构建 gdt 及其内部的描述符
     GDT_BASE: dd 0x00000000
               dd 0x00000000

     CODE_DESC: dd 0x0000FFFF
                dd DESC_CODE_HIGH4

     DATA_STACK_DESC: dd 0x0000FFFF
                      dd DESC_DATA_HIGH4

     VIDEO_DESC: dd 0x80000007 ;limit=(0xbffff-0xb8000)/4k=0x7
                 dd DESC_VIDEO_HIGH4 ;此时 dpl 为 0

     GDT_SIZE equ $ - GDT_BASE
     GDT_LIMIT equ GDT_SIZE - 1
     times 60 dq 0 ; 此处预留 60 个描述符的空位
     SELECTOR_CODE equ (0x0001<<3) + TI_GDT + RPL0
     ; 相当于(CODE_DESC - GDT_BASE)/8 + TI_GDT + RPL0
     SELECTOR_DATA equ (0x0002<<3) + TI_GDT + RPL0 ; 同上
     SELECTOR_VIDEO equ (0x0003<<3) + TI_GDT + RPL0 ; 同上

     ; 以下是 gdt 的指针，前 2 字节是 gdt 界限，后 4 字节是 gdt 起始地址

     gdt_ptr dw GDT_LIMIT
     dd GDT_BASE
     loadermsg db '2 loader in real.'
 loader_start:

     ;------------------------------------------------------------
     ;INT 0x10 功能号:0x13 功能描述:打印字符串
     ;------------------------------------------------------------
     ; 输入:
     ; AH 子功能号=13H
     ; BH = 页码
     ; BL = 属性(若 AL=00H 或 01H)
     ; CX=字符串长度
     ; (DH､ DL)=坐标(行 列､ )
     ; ES:BP=字符串地址
     ; AL=显示输出方式
     ; 0—字符串中只含显示字符，其显示属性在 BL 中
     ; 显示后，光标位置不变
     ; 1—字符串中只含显示字符，其显示属性在 BL 中
     ; 显示后，光标位置改变
     ; 2—字符串中含显示字符和显示属性。显示后，光标位置不变
     ; 3—字符串中含显示字符和显示属性。显示后，光标位置改变
     ; 无返回值
     mov sp, LOADER_BASE_ADDR
     mov bp, loadermsg ; ES:BP = 字符串地址
     mov cx, 17 ; CX = 字符串长度
     mov ax, 0x1301 ; AH = 13, AL = 01h
     mov bx, 0x001f ; 页号为 0(BH = 0) 蓝底粉红字(BL = 1fh)
     mov dx, 0x1800
     int 0x10 ; 10h 号中断

     ;-------------------- 准备进入保护模式 -------------------------------
     ;1 打开 A20
     ;2 加载 gdt
     ;3 将 cr0 的 pe 位置 1


     ;----------------- 打开 A20 ----------------
     in al,0x92
     or al,0000_0010B
     out 0x92,al

     ;----------------- 加载 GDT ----------------
     lgdt [gdt_ptr]

     ;----------------- cr0 第 0 位置 1 ----------------
     mov eax, cr0
     or eax, 0x00000001
     mov cr0, eax

     jmp dword SELECTOR_CODE:p_mode_start ; 刷新流水线


 [bits 32]
 p_mode_start:
     mov ax, SELECTOR_DATA
     mov ds, ax
     mov es, ax
     mov ss, ax
     mov esp,LOADER_STACK_TOP
     mov ax, SELECTOR_VIDEO
     mov gs, ax
	
     mov byte [gs:160], 'P'

     jmp $
```

```
添加个库目录 + 编译
--nasm -I include/ -o mbr.bin mbr.S  
下面将生成的 mbr.bin 写入我们的虚拟硬盘，还是用 dd 命令。
--sudo dd if=/your_path/mbr.bin of=/your_path/bochs/hd60M.img bs=512 count=1 conv=notrunc
--sudo dd if=/home/fyz/sc/bochs-2.6.2/mbr.bin of=/home/fyz/sc/bochs-2.6.2/hd60M.img bs=512 count=1 conv=notrunc

记录了1+0 的读入
记录了1+0 的写出
512 bytes copied, 0.000546068 s, 938 kB/s

添加个库目录 + 编译
--nasm -I include/ -o loader.bin loader.S
将生成的 loader.bin 写入硬盘第 2 个扇区。第 0 个扇区是 MBR，第 1 个扇区是空的未使用。（ 我就喜欢 你咋的
--sudo dd if=./loader.bin of=/your_path/bochs/hd60M.img bs=512 count=2 seek=2 conv=notrunc
--sudo dd if=./loader.bin of=/home/fyz/sc/bochs-2.6.2/hd60M.img bs=512 count=2 seek=2 conv=notrunc
（由于是612字节大小 所以 count=2

记录了1+1 的读入
记录了1+1 的写出
612 bytes copied, 0.000632655 s, 967 kB/s

模拟
--sudo bin/bochs -f bochsrc.disk
```

运行成功

 ![image-20201020173853277](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201020173853277.png)

![image-20201020174409769](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201020174409769.png)

PE位 已经变成1 成功进入了保护模式。

解释下为什么要加 jmp 。。。

**起到刷新流水线的作用**

为什么要用 jmp 远转移。

1.段描述符缓冲寄存器未更新，它还是实模式下的值，进入保护模式后需要填入正确的信息。

2.流水线中指令译码错误。

在jmp后面的代码是 32 位指令格式，而 CPU 是将其按照 16 位指令格式来译码的，译码之后在其执行时，必然是错误的。

解决问题的关键就是既要**改变代码段描述符缓冲寄存器的值**，又要**清空流水线**。

代码段寄存器 cs，只有用远过程调用指令 call、远转移指令 jmp、远返回指令 retf 等指令间接改变， 没有直接改变 cs 的方法，如直接 mov cs，xx 是不行的。另外，之前介绍过了流水线原理，CPU 遇到 jmp 指令时，之前已经送上流水线上的指令只有清空，所以 jmp 指令有清空流水线的神奇功效。

### 流水线

1.流水线是什么呢？

计算机中的流水线是把一个重复的过程分解为若干个子过程，每个子过程与其他子过程并行进行。由于这种工作方式与工厂中的生产流水线十分相似， 因此称为流水线技术。从本质上讲，流水线技术是一种**时间并行技术**

2.指令重叠方式

顺序执行：控制简单，节省设备；但是速度慢，功能部件的利用率低
重叠执行方式 ：指令的执行时间缩短 ，功能部件的利用率明显提高 ；但是需要增加一些硬件；控制过程稍复杂

3.流水线工作设计

基本思想：延伸重叠方式，使指令解释过程进一步细化， 提高各部件的利用率，以提高指令执行速度
理想目标：完成任务的时间与操作处理过程无关，只与提供操作的速度有关

4.流水线的描述方法

**时间—空间图 I**

横坐标：表示时间，即各个任务在流水线中所经过的时间
纵坐标：表示空间，即流水线的各个子过程，也称为级、 段、流水线深度(Stage)

![image-20201021151156990](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201021151156990.png)

**时间—空间图 II**

横坐标：表示时间，即各个任务或指令在流水线中 所在该时刻所对应的子过程
纵坐标：表示某个任务或某条指令，即流水线依次 处理的任务或指令

 ![image-20201021151312547](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201021151312547.png)

**IF :** Instruction Fetch,**取指令**,用到部件:指令存储器，Adder（ 全加器，full-adder，是用门电路实现两个二进制数相加并求出和的组合线路，称为一位全加器。一位全加器可以处理低位进位，并输出本位加法进位。多个一位全加器进行级联可以得到多位全加器。常用二进制四位全加器74LS283）
**ID :** Instruction Decode,**译码**（应该是取数同时译码的过程），用到部件：指令译码器寄存器堆读口（这里面的寄存器堆的读口和写口可以看作两个不同的部件），这块有大量寄存器，WB也是从写口将数据写到这块的寄存器中。
**EX :** Exec,**执行**，计算内存单元地址。用到部件：ALU，扩展器
MEM ：**访存**，从数据存储器中读。用到部件：数据存储器。
**WB :** Write Back,**写回**，将数据写到寄存器中。用到部件：寄存器堆写口。

#### **乱序执行**

乱序执行，是指在 CPU 中运行的指令并不按照代码中的顺序执行，而是按照一定的策略打乱顺序执行，也许后面的指令先执行，当然，得保证指令之间不具备相关性。即 ：指令流出顺序  ！=  指令流入顺序

举个简单的例子，比如如下两行代码就无法乱序执行。

```asm
mov eax, [0x1234]
add eax, ebx 
```

第 2 行的 add 加法，需要知道 eax 的值，但 eax 的值需要在第 1 行中的 mov 操作后才能确定，而且内存访问相对来说非常慢，第 2 步不得不等待第 1 步完成后才能进行。所以只能是先执行第 1 步，再执行第 2 步。

稍微改点后。

```asm
mov eax, [0x1234]
add ecx,ebx｡
```

这样就可以在执行第 1 步内存访问后的等待中执行第 2 步啦。由于第 2 步不依赖第 1 步，所以有利于放在流水线上。

x86 最初用的指令集是 **CISC** 。意为复杂指令集计算机，为什么复杂呢？当初的 CPU 工程师们为了让 CPU 更加强大，不断地往 CPU 中添加各种指令，甚至在 CPU 硬件一级直接支持软件中的某些操作，以至于指令集越来越庞大笨重复杂。

例如 push 指令，它相当于多个子操作的合成，拿保护模式中的栈来说，

**push eax** 相当于：push 指令先将栈指针 esp 减去操作数的字长，如 **sub esp,4**。
                              再将操作数 mov 到新的 esp 指向的地址，如 **mov [esp],eax**。

与 CISC 指令集相对应的是 **RISC**（Reduced Instruction Set Computer），意为精简指令集计算机。根据二八定律，最常用的指令只有 20%，但它们占了整个程序指令数的 80%。而不常用的指令占 80%，但它们只占整个程序指令数的 20%。

还是拿栈举例，如下三行代码

```asm
mov eax , [0x1234]
push eax
call function
```

第 1 步需要内存访问，由于内存较慢，所以寻址等待过程中可以做其他事。 
第 2 步的 push 指令拆分成 **sub esp,4** 和 **mov [esp],eax**。 
第 3 步的 call 函数调用，需要在栈中压入返回地址，所以说 call 指令需要用栈指针。

由于第 2 步中的微操作 sub esp，4，可以让 CPU 知道 esp 的最新值，不用等到 mov [esp], eax 完成， 第 3 步 call 指令向栈中压入返回地址的操作就可以执行了。故第 2 步未执行完就开始第 3 步的执行了，也 许第 3 步先于第 2 步完成。

乱序执行的好处就是后面的操作可以放到前面来做，利于装载到流水线上提高效率。

#### **缓存**

缓存是 20 世纪最大的发明，其原理是用一些存取速度较快的存储设备作为数据缓冲区，避免频繁访问速度较慢的低速存储设备，归根结底的原因是低速存储设备是整个系统的瓶颈，缓存用来缓解“瓶颈设备”的压力。

在上面提到过，CPU 中有**一级缓存 L1**、**二级缓存 L2**， 甚至**三级缓存 L3** 等。它们都是 **SRAM**，即静态随机访问存储器，它是最快的存储器啦。之所以把 SRAM 和寄存器放到一块说，是因为很多同学在感观上觉得寄存器是 CPU 直接使用的存储单元，所以寄存器比 SRAM 更快。其实它们在速度上是同一级别的东西，因为寄存器和 SRAM 都是用相同的存储电路实现的， 用的都是**触发器**，它可是工作速度极快的，属于纳秒级别。

有哪些东西可以被缓存呢？无论是程序中的数据，还是指令，在 CPU 眼里全是一样形式的二进制 01 串，没有任何区别，都是 CPU 待处理的“数据”。所以我们眼中的指令和数据都可以被缓存到 SRAM 中。

什么时候能缓存呢？可以根据程序的局部性原理采取缓存策略。局部性原理是：程序 90%的时间都运行在程序中 10%的代码上。

局部性分为以下两个方面。 一方面是**时间局部性**：最近访问过的指令和数据，在将来一段时间内依然经常被访问。另一方面是**空间局部性**：靠近当前访问内存空间的内存地址，在将来一段时间也会被访问。

例如 我们经常写的循环嵌套代码。

```
int array[100][100];
int sum = 0;
…
数组 array 元素被赋值，略
…
for (int i=0, i<100,i++) {
 for(int j=0;j<100,j++) {
 sum+=array[i][j];
 }
} 
```

以上是将二维数组中的所有元素相加求和的代码。循环中经常被用到的地址是 sum 所在的地址，经常被用到的指令是加法求和指令，这是在时间上的局部性。未来要访问的地址是与当前访问地址**&array[ i ] [ j ]**  相邻的地址**&array[ i ] [ j+1 ]**，它们之间只差一个整型变量的大小，这是空间上的局部性的。（当然，这些局部性都是编译器编译的结果，编译器就是这样安排的。）CPU 利用此特性，将当前用到的指令和当前位置附近的 数据都加载到缓存中，这就大大提高了 CPU 效率，下次直接从缓存中拿数据，不用再去内存中取啦。 当然，上面说的是理想的状态，如果缓存中没有相应的数据，还是要去内存中加载，然后再放到缓存中。

#### **流水线相关及冲突**

**1.流水线相关**（dependence）： 两条指令之间存在某种依赖关系。

 **数据相关**
1.先写后读：后面指令用到前面指令的结果
2.或间接使用

**名相关：**换名技术（使用相同的寄存器或存储器单元名称/地址
1.反相关：**先读后写**
2.输出相关：**先写后写**
3.真相关：**先写后读**

**控制相关**
由分支指令引起的相关

**2.流水线冲突**(hazards)

​    流水线冲突是指对于具体的流水线来说，由于**"相关"**的存在，使得指令流中的下一条指令不能在指定的时钟周期执行

- **数据冲突**:当指令在流水线中重叠执行时，因需要用到前面指令的执行结果而发生的冲突

- **控制冲突**:流水线遇到分支指令和其他会改变PC值的指令所引起的冲突

- **结构冲突**:因硬件资源满足不了指令重叠执行的要求而发生的冲突,比如说，前面后面指令同时访问存储器

例如 **分支预测**

CPU 中的指令是在流水线上执行。分支预测，是指当处理器遇到一个分支指令时，是该把分支左边的指令放到流水线上，还是把分支右边的指令放在流水线上呢？ 如 C 语言程序中的 if、switch、for 等语言结构，编译器将它们编译成汇编代码后，在汇编一级来说， 这些结构都是用跳转指令来实现的，所以，汇编语言中的无条件跳转指令很丰富，以至于称之为跳转指令 “族”，多得足矣应对各种转移方式。

**预测的算法**

对于无条件跳转，没啥可犹豫的，直接跳过去就是了。所谓的预测是针对有条件跳转来说的，因为不 知道条件成不成立。最简单的统计是根据上一次跳转的结果来预测本次，如果上一次跳转啦，这一次也预 测为跳转，否则不跳。

最简单的方法是 **2 位预测法**。用 2 位 bit 的计数器来记录跳转状态，每跳转一次就加 1，直到加到最大值 3 就不再加啦，如果未跳转就减 1，直到减到最小值 0 就不再减了。当遇到跳转指令时，如果计数器 的值大于 1 则跳转，如果小于等于 1 则不跳。这只是最简单的分支预测算法，CPU 中的预测法远比这个复杂，不过它们都是从 2 位预测法发展起来的。

**CPU的实现**

Intel 的分支预测部件中用了分支目标缓冲器（Branch Target Buffer，BTB）。

 ![image-20201021164338183](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201021164338183.png)

如果 BTB 中没有相同记录该怎么办呢？这时候可以使用 Static Predictor，**静态预测器**。为什么称为静态呢？这是因为存储在里面的预测策略是固定写死的，它是由人们经过大量统计之后，根据某些特征总结出来的。比如，转移目标的地址若小于当前转移指令的地址，则认为转移会发生，因为通常循环结构中都 用这种转移策略，为的是组成循环回路。所以静态预测器的策略是：若向上跳转则转移会发生，若向下跳转则转移不发生。

![image-20201021164606445](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201021164606445.png) 

程序在实际执行转移分支指令后，再将转移记录录入到 BTB。 还记得之前反复强调的重叠吗？其实是用在这的。如果分支预测错了， 也就是说，当前指令执行结果与预测的结果不同，这也没关系，只要将流水线清空就好了。因为处于执行阶段的是当前指令，即分支跳转指令。处于“译 码”“取指”的是尚未执行的指令，即错误分支上的指令。只要错误分支上的 指令还没到执行阶段就可以挽回，所以，直接清空流水线就是把流水线上错 误分支上的指令清掉，再把正确分支上的指令加入到流水线，只是清空流水线代价比较大。

## 内存段的保护

保护模式中的保护二字体现在哪里？其实主要体现在段描述符的属性字段中。每个字段都不是多余 的。这些属性只是用来描述一块内存的性质，是用来给 CPU 做参考的，当有实际动作在这片内存上发生 时，CPU 用这些属性来检查动作的合法性，从而起到了保护的作用。

### 向段寄存器加载选择子时的保护 

**判断段描述符是否超越界限**

 ![image-20201021172649044](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201021172649044.png)

选择子的高 13 位是段描述符的索引值，第 0～1 位是 RPL，第 2 位是 TI 位。

1. **先判断选择子否是正确的**。

   是选择子的索引值一定要小于等于 描述符表（GDT 或 LDT）中描述符的个数。即 段描述符的最后 1 字节一定要在描述符表（GDT 或 LDT）的界限地址之内。

2. **选择子中的索引值**

   描述符表基地址+选择子中的索引值*8+7 <= 描述符表基地址+描述符表界限值。

检查过程如下：处理器先检查 TI 的值，如果 TI 是 0，则从全局描述符表**寄存器 gdtr** 中拿到 GDT 基地址和 GDT 界限值。如果 TI 是 1，则从局部描述符表寄存器 ldtr 中拿到 LDT 基地址和 LDT 界限 值。有了描述符表基地址和描述符表界限值后，把选择子的高 13 位代入上面的表达式，若不成立， 处理器则抛出异常。

**注意：** GDT 中的第 0 个描述符是空描述符，如果选择子的索引值为 0 则会引用到它。所以，不允许往 CS 和 SS 段寄存器中加载索引值为 0 的选择子。虽然可以往 DS、ES、FS、GS 寄存器中加载值为 0 的选择子，但真正在使用时 CPU 将会抛出异常， 毕竟第 0 个段描述符是哑的，不可用。

段描述符中还有个 type 字段，这用来表示段的类型，也就是不同的段有不同的作用。

**在选择子检查过后，就要检查段的类型了。** 这里主要是检查段寄存器的用途和段类型是否匹配。

大的原则如下：

1. 只有具备可执行属性的段（代码段）才能加载到 CS 段寄存器中。 
2. 只具备执行属性的段（代码段）不允许加载到除 CS 外的段寄存器中。
3. 只有具备可写属性的段（数据段）才能加载到 SS 栈段寄存器中。 
4. 至少具备可读属性的段才能加载到 DS、ES、FS、GS 段寄存器中。 

如果 CPU 发现有任意上述规则不符，检查就不会通过。

![image-20201021173722675](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201021173722675.png)

检查完 type 后，还会再**检查段是否存在**

CPU 通过段描述符中的 **P 位来确认内存段是否存在**，
**如果 P 位为 1**，则表示存在，这时候就可以将选择子载入段寄存器了，同时段描述符缓冲寄存器也会更新为选 择子对应的段描述符的内容，随后处理器将段描述符中的 A 位置为 1，表示已经访问过了。
**如果 P 位为 0**， 则表示该内存段不存在，不存在的原因可能是由于内存不足，操作系统将该段移出内存转储到硬盘上了。 这时候处理器会抛出异常，自动转去执行相应的异常处理程序，异常处理程序将段从硬盘加载到内存后并 将 P 位置为 1，随后返回。CPU 继续执行刚才的操作，判断 P 位。

**注意：** 以上所涉及到的 P 位，其值由软件（通常是操作系统）来设置，由 CPU 来检查。A 位由 CPU 来设置。



### 代码段和数据段的保护 

对于代码段和数据段来说，CPU 每访问一个地址，都要确认该地址不能超过其所在内存段的范围。

实际段界限的值为： **（描述符中段界限+1）*（段界限的粒度大小：4k 或者 1）-1**。

对于 G 位为 1 的 4k 粒度大小的段来说，其实用下面这个公式更为直接。 
**实际段界限大小 = 描述符中段界限0x1000+0xFFF** 
其中，0xFFF 是 4k（0x1000）中以 0 为起始的最后一字节。所以此公式的意义是以 0 为起始的段偏移量，即段界限。

实际的段界限大小，是段内最后一个可访问的有效地址。由于有了段界限的限制，我们给 CPU 提交的每 一个内存地址，无论是指令的地址，还是数据的地址，CPU 都要帮我们检查地址的有效性。首先地址指向的 数据是有宽度的，CPU 要保证该数据一定要落在段内，不能“骑”在段边界上。

访问内存就要用**分段策略**，这是它的宿命，逃不掉的 ^_^。代码段既然也是内存中的区域，所以对于代码段的访问也要用“段基址：段内偏移地址”的形式， 在 32 位保护模式下，段基址存放在 CS 寄存器中，段内偏移地址，即有效地址，存放在 EIP 寄存器中。

CPU 得确保指令“完全、完整”地任意一部分都在当前的代码段内 即 **EIP 中的偏移地址+指令长度-1≤实际段界限大小**

CPU 也要保证操 作数要“完全、完整”地任意部分都要在当前数据段内。 即 **偏移地址+数据长度-1≤实际段界限大小**

 ![image-20201021183203196](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201021183203196.png)

举个例子，假设数据段描述符的段界限是 0x12345，段基址为 0x00000000。 如果 G 位为 0，那么实际段界限便是 0x12345。如果 G 位为 1，那么实际段界限便是 0x12345 * 0x1000+0xFFF=0x12345FFF。如果访问的数据地址是 0x12345FFF，还要看访问的数据宽度。 若数据大小是 1 字节，如 mov ax，byte [0x12345fff]，这种内存操作一点问题都没有，数据完全在实 际段界限之内。 若该数据大小是 2 字节，如 mov ax，word [0x12345fff]，这种内存操作超过了实际的段界限，数据所在地址分别是 0x12345FFF 和 0x12346000 这两个字节，CPU 会抛异常。

### 栈段的保护 

虽然段描述符 type 中的 **e 位**用来表示段的**扩展方向**，但它和别的描述符属性一样，仅仅是用来描述段的性质，即使 e 等于 1 向下扩展，依然可以引用不断向上递增的内存地址，即使 e 等于 0 向上扩展，也依然可以引用不断向下递减的内存地址。栈顶指针[e]sp 的值逐渐降低，这是 push 指令的作用，与描述符是否向下扩展无关，也就是说，是数据段就可以用作栈。

CPU 对数据段的检查，其中一项就是看地址是否超越段界限。如果将向上扩展的数据段用作栈，那 CPU 将按照上一节提到的数据段的方式检查该段。如果用向下扩展的段做栈的话，情况有点复杂，这体现在段界限的意义上。

对于向上扩展的段，实际的段界限是段内可以访问的最后一字节。 
对于向下扩展的段，实际的段界限是段内不可以访问的第一个字节

为了避免碰撞，将段界限地址+1 视为栈可以访问的下限。

 ![image-20201021191555885](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201021191555885.png)

# 向内核迈进

## 获取物理内存容量

inux获取内存容量方法有三种，本质上分别是BIOS中断0x15的3个子功能，BIOS是实模式下的方法，只能在保护模式之前调用。

**利用BIOS中断0x15子功能0xe820获取内存**

此方法最灵活，返回的内容也最丰富，内存信息的内容是地址范围描述符来描述的(ARDS)，每个字段4字节，一共20字节，调用0x15返回的也就是这个结构。其中Type字段表示内存类型，1表示这段内存可以使用；2表示不可用使用此内存；其它表示未定义，将来会用到。

 ![image-20201022190231494](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201022190231494.png)

用0x15子功能0xe820调用说明和调用步骤如下

1. 填写好"调用前输入"中列出的寄存器
2. 执行中断调用 int 0x15
3. 在CF位为0的情况下，"返回后输出"中对应的寄存器中就有结果

 ![image-20201022190424025](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201022190424025.png)

**利用BIOS中断0x15子功能0xe801获取内存**

此方法最多识别4G的内存，结果存放在两组寄存器中，操作起来要简便一些，调用说明和调用步骤如下

1. AX寄存器写入0xE801
2. 执行中断调用 int 0x15
3. 在CF位为0的情况下，"返回后输出"中对应的寄存器中就有结果

![image-20201022190558027](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201022190558027.png)

**利用BIOS中断0x15子功能0x88获取内存**

此方法最多识别64MB内存，操作起来最简单，调用说明和调用步骤如下

1. AX寄存器写入0x88
2. 执行中断调用 int 0x15
3. 在CF位为0的情况下，"返回后输出"中对应的寄存器中就有结果

![image-20201022190849105](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201022190849105.png)



下面结合这三种方式改进我们的实验代码，下面是`loader`，我们将结果保存在了`total_mem_bytes`中。

```asm
   %include "boot.inc"
   section loader vstart=LOADER_BASE_ADDR
   LOADER_STACK_TOP equ LOADER_BASE_ADDR
   
;构建gdt及其内部的描述符
   GDT_BASE:   dd    0x00000000 
	          dd    0x00000000

   CODE_DESC:  dd    0x0000FFFF 
	          dd    DESC_CODE_HIGH4

   DATA_STACK_DESC:  dd    0x0000FFFF
	                dd    DESC_DATA_HIGH4

   VIDEO_DESC:  dd    0x80000007	   ; limit=(0xbffff-0xb8000)/4k=0x7
	           dd    DESC_VIDEO_HIGH4  ; 此时dpl为0
 
   GDT_SIZE   equ   $ - GDT_BASE
   GDT_LIMIT   equ   GDT_SIZE -	1 
   times 60 dq 0					 ; 此处预留60个描述符的空位(slot)
   SELECTOR_CODE equ (0x0001<<3) + TI_GDT + RPL0     ; 相当于(CODE_DESC - GDT_BASE)/8 + TI_GDT + RPL0
   SELECTOR_DATA equ (0x0002<<3) + TI_GDT + RPL0	 ; 同上
   SELECTOR_VIDEO equ (0x0003<<3) + TI_GDT + RPL0	 ; 同上 

   ; total_mem_bytes用于保存内存容量,以字节为单位,此位置比较好记。
   ; 当前偏移loader.bin文件头0x200字节,loader.bin的加载地址是0x900,
   ; 故total_mem_bytes内存中的地址是0xb00.将来在内核中咱们会引用此地址
   total_mem_bytes dd 0					 
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ;以下是定义gdt的指针，前2字节是gdt界限，后4字节是gdt起始地址
   gdt_ptr  dw  GDT_LIMIT 
	    dd  GDT_BASE

   ;人工对齐:total_mem_bytes4字节+gdt_ptr6字节+ards_buf244字节+ards_nr2,共256字节
   ards_buf times 244 db 0
   ards_nr dw 0		      ;用于记录ards结构体数量

   loader_start:
   
;-------  int 15h eax = 0000E820h ,edx = 534D4150h ('SMAP') 获取内存布局  -------

   xor ebx, ebx		      ;第一次调用时，ebx值要为0
   mov edx, 0x534d4150	  ;edx只赋值一次，循环体中不会改变
   mov di, ards_buf	      ;ards结构缓冲区
.e820_mem_get_loop:	      ;循环获取每个ARDS内存范围描述结构
   mov eax, 0x0000e820	  ;执行int 0x15后,eax值变为0x534d4150,所以每次执行int前都要更新为子功能号。
   mov ecx, 20		      ;ARDS地址范围描述符结构大小是20字节
   int 0x15
   jc .e820_failed_so_try_e801   ;若cf位为1则有错误发生，尝试0xe801子功能
   add di, cx		      ;使di增加20字节指向缓冲区中新的ARDS结构位置
   inc word [ards_nr]	  ;记录ARDS数量
   cmp ebx, 0		      ;若ebx为0且cf不为1,这说明ards全部返回，当前已是最后一个
   jnz .e820_mem_get_loop

;在所有ards结构中，找出(base_add_low + length_low)的最大值，即内存的容量。
   mov cx, [ards_nr]	  ;遍历每一个ARDS结构体,循环次数是ARDS的数量
   mov ebx, ards_buf 
   xor edx, edx		      ;edx为最大的内存容量,在此先清0
.find_max_mem_area:	      ;无须判断type是否为1,最大的内存块一定是可被使用
   mov eax, [ebx]	      ;base_add_low
   add eax, [ebx+8]	      ;length_low
   add ebx, 20		      ;指向缓冲区中下一个ARDS结构
   cmp edx, eax		      ;冒泡排序，找出最大,edx寄存器始终是最大的内存容量
   jge .next_ards
   mov edx, eax		      ;edx为总内存大小
.next_ards:
   loop .find_max_mem_area
   jmp .mem_get_ok

;------  int 15h ax = E801h 获取内存大小,最大支持4G  ------
; 返回后, ax cx 值一样,以KB为单位,bx dx值一样,以64KB为单位
; 在ax和cx寄存器中为低16M,在bx和dx寄存器中为16MB到4G。
.e820_failed_so_try_e801:
   mov ax,0xe801
   int 0x15
   jc .e801_failed_so_try88   ;若当前e801方法失败,就尝试0x88方法

;1 先算出低15M的内存,ax和cx中是以KB为单位的内存数量,将其转换为以byte为单位
   mov cx,0x400	     ;cx和ax值一样,cx用做乘数
   mul cx 
   shl edx,16
   and eax,0x0000FFFF
   or edx,eax
   add edx, 0x100000 ;ax只是15MB,故要加1MB
   mov esi,edx	     ;先把低15MB的内存容量存入esi寄存器备份

;2 再将16MB以上的内存转换为byte为单位,寄存器bx和dx中是以64KB为单位的内存数量
   xor eax,eax
   mov ax,bx		
   mov ecx, 0x10000	;0x10000十进制为64KB
   mul ecx		    ;32位乘法,默认的被乘数是eax,积为64位,高32位存入edx,低32位存入eax.
   add esi,eax		;由于此方法只能测出4G以内的内存,故32位eax足够了,edx肯定为0,只加eax便可
   mov edx,esi		;edx为总内存大小
   jmp .mem_get_ok

;-----------------  int 15h ah = 0x88 获取内存大小,只能获取64M之内  ----------
.e801_failed_so_try88: 
   ;int 15后，ax存入的是以kb为单位的内存容量
   mov  ah, 0x88
   int  0x15
   jc .error_hlt
   and eax,0x0000FFFF
      
   ;16位乘法，被乘数是ax,积为32位.积的高16位在dx中，积的低16位在ax中
   mov cx, 0x400     ;0x400等于1024,将ax中的内存容量换为以byte为单位
   mul cx
   shl edx, 16	     ;把dx移到高16位
   or edx, eax	     ;把积的低16位组合到edx,为32位的积
   add edx,0x100000  ;0x88子功能只会返回1MB以上的内存,故实际内存大小要加上1MB

.mem_get_ok:
   mov [total_mem_bytes], edx	 ;将内存换为byte单位后存入total_mem_bytes处。


;-----------------   准备进入保护模式   -------------------
;1 打开A20
;2 加载gdt
;3 将cr0的pe位置1

   ;-----------------  打开A20  ----------------
   in al,0x92
   or al,0000_0010B
   out 0x92,al

   ;-----------------  加载GDT  ----------------
   lgdt [gdt_ptr]

   ;-----------------  cr0第0位置1  ----------------
   mov eax, cr0
   or eax, 0x00000001
   mov cr0, eax

   jmp dword SELECTOR_CODE:p_mode_start	   ; 刷新流水线，避免分支预测的影响,这种cpu优化策略，最怕jmp跳转，
					                     ; 这将导致之前做的预测失效，从而起到了刷新的作用。
.error_hlt:		      ;出错则挂起
   hlt

[bits 32]
p_mode_start:
   mov ax, SELECTOR_DATA
   mov ds, ax
   mov es, ax
   mov ss, ax
   mov esp,LOADER_STACK_TOP
   mov ax, SELECTOR_VIDEO
   mov gs, ax

   mov byte [gs:160], 'P'

   jmp $
```

在`mbr.S`中也需要修改一处内容，我们跳转的内容要加上0x300，原因是在 loader.S 中`loader_start`计算如下

> (4个段描述符 + 60个段描述符槽位) * 8字节 = total_mem_bytes_offset
>
> (4 + 60) * 8 = 512 = 0x200
>
> total_mem_bytes + gdt_ptr + ards_buf + adrs_nr + total_mem_bytes_offset = loader_start
>
> 4 + 6 + 244 + 2 + 0x200 = 0x300

修改片断如下

```asm
[...] 
   mov eax,LOADER_START_SECTOR
   mov bx,LOADER_BASE_ADDR
   mov cx,4
   call rd_disk_m_16
  
   jmp LOADER_BASE_ADDR+0x300 ; 这里

rd_disk_m_16:	   
[...]
```

```
添加个库目录 + 编译
--nasm -I include/ -o mbr.bin mbr.S  
下面将生成的 mbr.bin 写入我们的虚拟硬盘，还是用 dd 命令。
--sudo dd if=/your_path/mbr.bin of=/your_path/bochs/hd60M.img bs=512 count=1 conv=notrunc
--sudo dd if=/home/fyz/sc/bochs-2.6.2/mbr.bin of=/home/fyz/sc/bochs-2.6.2/hd60M.img bs=512 count=1 conv=notrunc

记录了1+0 的读入
记录了1+0 的写出
512 bytes copied, 0.000546068 s, 938 kB/s

添加个库目录 + 编译
--nasm -I include/ -o loader.bin loader.S
将生成的 loader.bin 写入硬盘第 2 个扇区。第 0 个扇区是 MBR，第 1 个扇区是空的未使用。（ 我就喜欢 你咋的
--sudo dd if=./loader.bin of=/your_path/bochs/hd60M.img bs=512 count=2 seek=2 conv=notrunc
--sudo dd if=./loader.bin of=/home/fyz/sc/bochs-2.6.2/hd60M.img bs=512 count=2 seek=2 conv=notrunc
（由于是1000字节大小 所以 count=2

记录了1+1 的读入
记录了1+1 的写出
1000 bytes (1.0 kB) copied, 0.000761711 s, 1.3 MB/s

```

运行结果如下，这里我们用`xp 0xb00`查看我们的结果，`0x02000000`换算过来刚好是我们`bochsrc.disk`中 megs 设置的32MB大小

 ![image-20201022204208877](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201022204208877.png)

## 启动分页机制

分页机制是当物理内存不足时，或者内存碎片过多无法容纳新进程等情况的一种应对措施。假如说此时未开启分页功能，而物理内存空间又不足，如下图所示.

![image-20201023164539146](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201023164539146.png) 

此时进程C想要执行，但是内存空间已经不足。要么就等待进程A或者进程B执行完成，这样就有连续的内存空间了。要么就讲进程A的A3段或者进程B的B1段换到硬盘上，腾出一部分空间，同样可以容纳进程C执行.

等待是极其不好的用户体验，那么只能将段置换到硬盘上了，但是段的大小并不固定，如何段过大，那么IO操作过多，机器的响应速度就会非常慢。

出现这种情况的本质其实是在分段机制下，线性地址等价于物理地址。那么即使在进程B的下面还有10M的可用空间，但因为两块可用空间并不连续，所以进程C无法使用进程B下面的10M可用空间。

按照这种思路，只需要通过某种映射关系，将线性地址映射到任意的物理地址，就可以解决这种问题了。实现线性地址的连续，而物理地址不需要连续，于是分页机制就诞生了。

### 一级页表

尽管在保护模式中段寄存器中的内容已经是选择子，但选择子最终就是为了要找到段基址，其内存访问的核心机制依然是**“段基址：段内偏移地址”**，这两个地址在相加之后才是绝对地址，也就是我们所说的**线性地址**，此线性地址在分段机制下被 CPU 认为是物理地址，直接拿来就能用，也就是说，此线性地址可以直接送上地址总线。

分页机制是工作在分段机制下的，在保护模式下，通过选择子找到段基址，通过段基址：段内偏移的方式组合成线性地址，拿到线性地址之后会根据是否开启分页来找到实际的物理地址。

![image-20201023165737231](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201023165737231.png)

分页机制的思想是：通过映射，可以使连续的线性地址与任意物理内存地址相关联，逻辑上连续的线性地址其对应的物理地址可以不连续。

分页机制的作用有两方面。

> 1.将线性地址转换成物理地址。 
> 2.用大小相等的页代替大小不等的段

如图所示：

需要通过分页机制来映射的线性地址便是我们通常叫的 **虚拟地址**

 ![image-20201023170120868](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201023170120868.png)

我们需要平衡页的大小与页的数量的关系，因为**页大小*页数量=4GB**，想要减少页表的大小，只能增加一页的大小。最终通过数学求极限，定下4KB为最佳页大小。

![image-20201023171618309](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201023171618309.png) 

这种情况下，4GB的内存被划分为1MB个内存块，每个内存块的大小为4KB。

页表和内存的映射关系如图

 ![image-20201023171819242](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201023171819242.png)

页部件的工作：用线性地址的高 20 位在页表中索引页表项，用线性地址的低 12 位与页表项中的物理地址相加，所求的和便是最终线性地址对应的物理地址。

例如 mov ax，[0x1234] 。

 ![image-20201023172031920](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201023172031920.png)



### 二级页表

无论是几级页表，标准页的尺寸都是4KB。所以4GB的线性地址空间最多有1M个标准页。一级页表是将这1M个标准页放置到一张页表中，二级页表是将这1M个标准页平均放置1K个页表中，每个页表包含有1K个页表项。页表项是4字节大小，页表包含1K个页表项，故页表的大小同样为4KB，刚好为一页。

为了管理页表的物理地址，专门有一个页目录表来存放这些页表。页目录表中存储的页表称为页目录项(PDE)，页目录项同样为4KB，且最多有1K个页目录项，所以页目录表也是4KB，如下图所示

![image-20201023201356840](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201023201356840.png) 

二级页表中虚拟地址到物理地址的转换也有很大的变化，具体步骤如下

- 用虚拟地址的高 10 位乘以 4，作为页目录表内的偏移地址，加上页目录表的物理地址，所得的和，便是页目录项的物理地址。读取该页目录项，从中获取到页表的物理地址。
- 用虚拟地址的中间 10 位乘以 4，作为页表内的偏移地址，加上在第 1 步中得到的页表物理地址，所得的和，便是页表项的物理地址。读取该页表项，从中获取到分配的物理页地址。
- 虚拟地址的高 10 位和中间 10 位分别是 PDE PIE 的索引值，所以它们需要乘以 4。但低 12 位就不是索引值了，其表示的范围是 0~0xfff，作为页内偏移最合适，所以虚拟地址的低 12 位加上第二步中得到的物理页地址，所得的和便是最终转换的物理地址。

 下图表示`mov ax, [0x1234567]`的转换过程，可以发现cr3寄存器其实指向的是页目录表基地址

![image-20201023201922880](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201023201922880.png)

PDE和PTE的结构如下图所示

 ![image-20201023202117714](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201023202117714.png)

从右到左各属性总结如下表

| 属性位 | 意义                                                         |
| ------ | :----------------------------------------------------------- |
| P      | 存在位，为1时表示该页在物理内存中，为0表示不在物理内存中     |
| RW     | 读写位，为1时可读可写，为0是可读不可写                       |
| US     | 特权位，为1时表示处于普通用户，0~~3特权级可访问，为0表示超级用户，0~~2特权级可访问 |
| PWT    | 页级通写位，为1表示此项采用通写方式，表示该页不仅是普通内存，还是高速缓存 |
| PCD    | 页级高速缓存禁止位，为1表示该页启用高速缓存                  |
| A      | 访问位，为1表示该页被CPU访问过                               |
| D      | 脏页位，当CPU对一个页面执行写操作，此为被赋1                 |
| PAT    | 页属性表位，能够在页面一级的粒度上设置内存属性               |
| G      | 全局位，为1表示该页在高速缓存TLB中一直保存                   |
| AVL    | 表示软件，系统可用该位，和CPU无关                            |



**启用分页机制**，我们要按顺序做好三件事。 

（1）准备好页目录表及页表。 
（2）将页表地址写入控制寄存器 cr3。
（3）寄存器 cr0 的 PG 位置 1。

![image-20201023204710038](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201023204710038.png) 

> **CR0** 是系统内的控制寄存器之一。控制寄存器是一些特殊的寄存器，它们可以控制CPU的一些重要特性。
> **第 0 位**是**保护允许位PE**(Protedted Enable)，用于启动保护模式，如果PE位置1，则保护模式启动，如果PE=0，则在实模式下运行。
> **第 1 位**是**监控协处理位MP**(Moniter coprocessor)，它与第3位一起决定：当TS=1时操作码WAIT是否产生一个“协处理器不能使用”的出错信号。
> **第 2 位**是**模拟协处理器位EM** (Emulate coprocessor)，如果EM=1，则不能使用协处理器，如果EM=0，则允许使用协处理器。
> **第 3 位**是**任务转换位TS**(Task Switch)，当一个任务转换完成之后，自动将它置1。随着TS=1，就不能使用协处理器。
> **第 4 位**是**微处理器的扩展类型位 ET**(Processor Extension Type)，其内保存着处理器扩展类型的信息，如果ET=0，则标识系统使
> 用的是287协处理器，如果 ET=1，则表示系统使用的是387浮点协处理器。
> **第16位**是**写保护未即WP位**(486系列之后)，只要将这一位置0就可以禁用写保护，置1则可将其恢复
> **第31位**是**分页允许位PG**(Paging Enable)，它表示芯片上的分页部件是否允许工作。
>
> **CR1**是未定义的控制寄存器，供将来的处理器使用。
> **CR2**是页故障线性地址寄存器，保存最后一次出现页故障的全32位线性地址。
> **CR3**是页目录基址寄存器，保存页目录表的物理地址，页目录表总是放在以4K字节为单位的存储器边界上，因此，它的地址的低12位总为0，不起作用，即使写上内容，也不会被理会。
> **CR4**在Pentium系列（包括486的后期版本）处理器中才实现，它处理的事务包括诸如何时启用虚拟8086模式等

### 启动分页机制

![image-20201109200141630](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201109200141630.png) 

创建页目录及页表的代码

```asm
; 创建页目录及页表
setup_page:
; 先把页目录占用的空间逐字节清零
	mov ecx, 4096
	mov esi, 0
.clear_page_dir:
	mov byte [PAGE_DIR_TABLE_POS + esi], 0
	inc esi
	loop .clear_page_dir

; 开始创建页目录项(PDE)
.create_pde:        ; 创建PDE
	mov eax, PAGE_DIR_TABLE_POS
	add eax, 0x1000 ; 此时eax为第一个页表的位置及属性
	mov ebx, eax    ; 此处为ebx赋值,是为.create_pte做准备,ebx为基址

; 下面将页目录项0和0xc00都存为第一个页表的地址，每个页表表示4MB内存
; 这样0xc03fffff以下的地址和0x003fffff以下的地址都指向相同的页表
; 这是为将地址映射为内核地址做准备
	or eax, PG_US_U | PG_RW_W | PG_P      ; 页目录项的属性RW和P位为1,US为1,表示用户属性,所有特权级别都可以访问.
	mov [PAGE_DIR_TABLE_POS + 0x0], eax   ; 第1个目录项,在页目录表中的第1个目录项写入第一个页表的位置(0x101000)及属性(7)
	mov [PAGE_DIR_TABLE_POS + 0xc00], eax ; 一个页表项占用四字节
	; 0xc00表示第768个页表占用的目录项,0xc00以上的目录项用于内核空间
	; 也就是页表的0xc0000000~0xffffffff这1G属于内核
	; 0x0~0xbfffffff这3G属于用户进程
	sub eax, 0x1000
	mov [PAGE_DIR_TABLE_POS + 4092], eax  ; 使最后一个目录项指向页目录表自己的地址
	
; 下面创建页表项(PTE)
	mov ecx, 256	; 1M低端内存 / 每页大小 4K = 256
	mov esi, 0
	mov edx, PG_US_U | PG_RW_W | PG_P	; 属性为7
.create_pte:		; 创建PTE
	mov [ebx+esi*4], edx ; 此时的edx为0x101000,也就是第一个页表的地址
	add edx, 4096
	inc esi
	loop .create_pte

; 创建内核其他页表的PDE
	mov eax, PAGE_DIR_TABLE_POS
	add eax, 0x2000						; 此时eax为第二个页表的位置
	or eax, PG_US_U | PG_RW_W | PG_P	; 属性为7
	mov ebx, PAGE_DIR_TABLE_POS
	mov ecx, 254						; 范围为第769~1022的所有目录项数量
	mov esi, 769
.create_kernel_pde:
	mov [ebx+esi*4], eax
    inc esi
    add eax, 0x1000
    loop .create_kernel_pde
    ret
```

在boot.inc中添加如下信息

```asm
; loader 和 kernel
PAGE_DIR_TABLE_POS equ 0x100000
; 页表相关属性
PG_P equ 1b
PG_RW_R equ 00b
PG_RW_W equ 10b
PG_US_S equ 000b
PG_US_U equ 100b
```

行完第一步的内容，之后的操作相对就简单了，将页表地址写入控制寄存器cr3寄存器和将cr0的PG位置1的操作整合起来的`loader.S`如下所示

```asm
%include "boot.inc"
section loader vstart=LOADER_BASE_ADDR
LOADER_STACK_TOP equ LOADER_BASE_ADDR

;构建gdt及其内部的描述符
GDT_BASE:   dd    0x00000000 
            dd    0x00000000

CODE_DESC:  dd    0x0000FFFF 
            dd    DESC_CODE_HIGH4

DATA_STACK_DESC:  dd    0x0000FFFF
	              dd    DESC_DATA_HIGH4

VIDEO_DESC: dd    0x80000007	   ; limit=(0xbffff-0xb8000)/4k=0x7
            dd    DESC_VIDEO_HIGH4  ; 此时dpl为0

GDT_SIZE   equ   $ - GDT_BASE
GDT_LIMIT   equ   GDT_SIZE -	1 
times 60 dq 0					 ; 此处预留60个描述符的空位(slot)
SELECTOR_CODE equ (0x0001<<3) + TI_GDT + RPL0     ; 相当于(CODE_DESC - GDT_BASE)/8 + TI_GDT + RPL0
SELECTOR_DATA equ (0x0002<<3) + TI_GDT + RPL0	 ; 同上
SELECTOR_VIDEO equ (0x0003<<3) + TI_GDT + RPL0	 ; 同上 

; total_mem_bytes用于保存内存容量,以字节为单位,此位置比较好记。
; 当前偏移loader.bin文件头0x200字节,loader.bin的加载地址是0x900,
; 故total_mem_bytes内存中的地址是0xb00.将来在内核中咱们会引用此地址
total_mem_bytes dd 0					 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;以下是定义gdt的指针，前2字节是gdt界限，后4字节是gdt起始地址
gdt_ptr  dw  GDT_LIMIT 
    dd  GDT_BASE

;人工对齐:total_mem_bytes4字节+gdt_ptr6字节+ards_buf244字节+ards_nr2,共256字节
ards_buf times 244 db 0
ards_nr dw 0		      ;用于记录ards结构体数量

loader_start:

;-------  int 15h eax = 0000E820h ,edx = 534D4150h ('SMAP') 获取内存布局  -------

   xor ebx, ebx		      ;第一次调用时，ebx值要为0
   mov edx, 0x534d4150	  ;edx只赋值一次，循环体中不会改变
   mov di, ards_buf	      ;ards结构缓冲区
.e820_mem_get_loop:	      ;循环获取每个ARDS内存范围描述结构
   mov eax, 0x0000e820	  ;执行int 0x15后,eax值变为0x534d4150,所以每次执行int前都要更新为子功能号。
   mov ecx, 20		      ;ARDS地址范围描述符结构大小是20字节
   int 0x15
   jc .e820_failed_so_try_e801   ;若cf位为1则有错误发生，尝试0xe801子功能
   add di, cx		      ;使di增加20字节指向缓冲区中新的ARDS结构位置
   inc word [ards_nr]	  ;记录ARDS数量
   cmp ebx, 0		      ;若ebx为0且cf不为1,这说明ards全部返回，当前已是最后一个
   jnz .e820_mem_get_loop

;在所有ards结构中，找出(base_add_low + length_low)的最大值，即内存的容量。
   mov cx, [ards_nr]	  ;遍历每一个ARDS结构体,循环次数是ARDS的数量
   mov ebx, ards_buf 
   xor edx, edx		      ;edx为最大的内存容量,在此先清0
.find_max_mem_area:	      ;无须判断type是否为1,最大的内存块一定是可被使用
   mov eax, [ebx]	      ;base_add_low
   add eax, [ebx+8]	      ;length_low
   add ebx, 20		      ;指向缓冲区中下一个ARDS结构
   cmp edx, eax		      ;冒泡排序，找出最大,edx寄存器始终是最大的内存容量
   jge .next_ards
   mov edx, eax		      ;edx为总内存大小
.next_ards:
   loop .find_max_mem_area
   jmp .mem_get_ok

;------  int 15h ax = E801h 获取内存大小,最大支持4G  ------
; 返回后, ax cx 值一样,以KB为单位,bx dx值一样,以64KB为单位
; 在ax和cx寄存器中为低16M,在bx和dx寄存器中为16MB到4G。
.e820_failed_so_try_e801:
   mov ax,0xe801
   int 0x15
   jc .e801_failed_so_try88   ;若当前e801方法失败,就尝试0x88方法

;1 先算出低15M的内存,ax和cx中是以KB为单位的内存数量,将其转换为以byte为单位
   mov cx,0x400	     ;cx和ax值一样,cx用做乘数
   mul cx 
   shl edx,16
   and eax,0x0000FFFF
   or edx,eax
   add edx, 0x100000 ;ax只是15MB,故要加1MB
   mov esi,edx	     ;先把低15MB的内存容量存入esi寄存器备份

;2 再将16MB以上的内存转换为byte为单位,寄存器bx和dx中是以64KB为单位的内存数量
   xor eax,eax
   mov ax,bx		
   mov ecx, 0x10000	;0x10000十进制为64KB
   mul ecx		    ;32位乘法,默认的被乘数是eax,积为64位,高32位存入edx,低32位存入eax.
   add esi,eax		;由于此方法只能测出4G以内的内存,故32位eax足够了,edx肯定为0,只加eax便可
   mov edx,esi		;edx为总内存大小
   jmp .mem_get_ok

;-----------------  int 15h ah = 0x88 获取内存大小,只能获取64M之内  ----------
.e801_failed_so_try88: 
   ;int 15后，ax存入的是以kb为单位的内存容量
   mov  ah, 0x88
   int  0x15
   jc .error_hlt
   and eax,0x0000FFFF
      
   ;16位乘法，被乘数是ax,积为32位.积的高16位在dx中，积的低16位在ax中
   mov cx, 0x400     ;0x400等于1024,将ax中的内存容量换为以byte为单位
   mul cx
   shl edx, 16	     ;把dx移到高16位
   or edx, eax	     ;把积的低16位组合到edx,为32位的积
   add edx,0x100000  ;0x88子功能只会返回1MB以上的内存,故实际内存大小要加上1MB

.mem_get_ok:
   mov [total_mem_bytes], edx	 ;将内存换为byte单位后存入total_mem_bytes处。


;-----------------   准备进入保护模式   -------------------
;1 打开A20
;2 加载gdt
;3 将cr0的pe位置1

   ;-----------------  打开A20  ----------------
   in al,0x92
   or al,0000_0010B
   out 0x92,al

   ;-----------------  加载GDT  ----------------
   lgdt [gdt_ptr]

   ;-----------------  cr0第0位置1  ----------------
   mov eax, cr0
   or eax, 0x00000001
   mov cr0, eax

   jmp dword SELECTOR_CODE:p_mode_start	   ; 刷新流水线，避免分支预测的影响,这种cpu优化策略，最怕jmp跳转，
					                     ; 这将导致之前做的预测失效，从而起到了刷新的作用。
.error_hlt:		      ;出错则挂起
   hlt

[bits 32]
p_mode_start:
   mov ax, SELECTOR_DATA
   mov ds, ax
   mov es, ax
   mov ss, ax
   mov esp,LOADER_STACK_TOP
   mov ax, SELECTOR_VIDEO
   mov gs, ax

   ; 创建页目录及页表并初始化内存位图
   call setup_page
  
   ; 要将描述符表地址及偏移量写入内存gdt_ptr,一会儿用新地址重新加载
   sgdt [gdt_ptr] ; 储存到原来gdt所有位置
   
   ; 将gdt描述符中视频段描述符中的段基址+0xc0000000
   mov ebx, [gdt_ptr + 2] ; gdt地址
   or dword [ebx + 0x18 + 4], 0xc0000000
   ; 视频段是第3个段描述符,每个描述符是8字节,故0x18
   ; 段描述符的高4字节的最高位是段基址的第31~24位
   
   ; 将gdt的基址加上0xc0000000使其成为内核所在的高地址
   add dword [gdt_ptr + 2], 0xc0000000
   add esp, 0xc0000000 ; 将栈指针同样映射到内核地址

   ; 把页目录地址赋给cr3
   mov eax, PAGE_DIR_TABLE_POS
   mov cr3, eax
   
   ; 打开cr0的pg位(第31位)
   mov eax, cr0
   or eax, 0x80000000
   mov cr0, eax
   
   ; 在开启分页后，用gdt新的地址重新加载
   lgdt [gdt_ptr] ; 重新加载
   
   mov byte [gs:160], 'V'
   ; 视频段段基址已经被更新,用字符V表示virtual addr
   jmp $
   
;-------------   创建页目录及页表   ---------------
; 创建页目录以及页表
setup_page:
    ; 页目录表占据4KB空间，清零之
    mov ecx, 4096
    mov esi, 0
.clear_page_dir:   
    mov byte [PAGE_DIR_TABLE_POS + esi], 0
    inc esi
    loop .clear_page_dir

; 创建页目录表(PDE)
.create_pde:
    mov eax, PAGE_DIR_TABLE_POS
    ; 0x1000为4KB，加上页目录表起始地址便是第一个页表的地址
    add eax, 0x1000
    mov ebx, eax

    ; 设置页目录项属性
    or eax, PG_US_U | PG_RW_W | PG_P
    ; 设置第一个页目录项
    mov [PAGE_DIR_TABLE_POS], eax
    ; 第768(内核空间的第一个)个页目录项，与第一个相同，这样第一个和768个都指向低端4MB空间
    mov [PAGE_DIR_TABLE_POS + 0xc00], eax
    ; 最后一个表项指向自己，用于访问页目录本身
    sub eax, 0x1000
    mov [PAGE_DIR_TABLE_POS + 4092], eax

; 创建页表
    mov ecx, 256
    mov esi, 0
    mov edx, PG_US_U | PG_RW_W | PG_P
.create_pte:
    mov [ebx + esi * 4], edx
    add edx, 4096
    inc esi
    loop .create_pte

; 创建内核的其它PDE
    mov eax, PAGE_DIR_TABLE_POS
    add eax, 0x2000
    or eax, PG_US_U | PG_RW_W | PG_P 
    mov ebx, PAGE_DIR_TABLE_POS
    mov ecx, 254
    mov esi, 769
.create_kernel_pde:
    mov [ebx + esi * 4], eax
    inc esi
    add eax, 0x1000
    loop .create_kernel_pde
    ret
```

运行之后 （ 已成功

![image-20201109210146952](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201109210146952.png) 

运行结果如下图，其中 gdt段基址 已经修改为大于 0xc0000000，也就是3GB之上的内核地址空间，通过`info tab`可查看地址映射关系，其中箭头左边是虚拟地址，右边是对应的物理地址

 ![image-20201109210300503](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201109210300503.png)

总结虚拟地址获取物理地址的过程：

先要从 CR3 寄存器中获取页目录表物理地址，然后用虚拟地址的高 10 位乘以 4 的积作为在页目录表中的偏移量去寻址目录项 pde ，从 pde 中读出页表物理地址，然后再用虚拟地址的中间 10 位乘以 4 的积作为在该页表中的偏移量去寻址页表项 pte，从该 pte 中读出页框物理地址，用虚拟地址的低 12 位作为该物理页框的偏移量。

总结用虚拟地址获取页表中各数据类型的方法：

获取页目录表物理地址：让虚拟地址的高 20 位为 0xfffff，低 12 位为 0x000，即 0xfffff000，这也是页目录表中第 0 个页目录项自身的物理地址。 
访问页目录中的页目录项，即获取页表物理地址：要使虚拟地址为 0xfffffxxx，其中 xxx 是页目录 项的索引乘以 4 的积。
访问页表中的页表项：要使虚拟地址高 10 位为 0x3ff，目的是获取页目录表物理地址。中间 10 位 为页表的索引，因为是 10 位的索引值，所以这里不用乘以 4。低 12 位为页表内的偏移地址，用来定位页 表项，它必须是已经乘以 4 后的值。 公式为 0x3ff<<22+中间 10 位<<12+低 12 位。

### 快表 TLB

TLB，即 Translation Lookaside Buffer，俗称快表 ：处理器准备了一个高速缓存，可以匹配高速的处理器速率和低速的内存访问速度，它专门用来存放虚拟地址页框与物理地址页框的映射关系。（ 调整缓存

 ![image-20201110174049306](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201110174049306.png)

TLB 中的条目是虚拟地址的高 20 位到物理地址高 20 位的映射结果，实际上就是从虚拟页框到物理页框的映射。除此之外 TLB 中还有一些属性位，比如页表项的 RW 属性。 有了 TLB，处理器在寻址之前会用虚拟地址的高 20 位作为索引来查找 TLB 中的相关条目，如果命中 （匹配到相关条目）则返回虚拟地址所映射的物理页框地址，否则会查询内存中的页表，获得页框物理地址后再更新 TLB。

更新TLB的方法有两种，**重新加载CR3** 和 **指令`invlpg m`**，其中m表示操作数为虚拟内存地址，如更新虚拟地址0x1234对应的条目指令为`invlpg [0x1234]`;



## ELF格式浅析

### elf格式的二进制文件

ELF 指的是 Executable and Linkable Format，可执行链接格式。最初是由 UNIX 系统实验室（USL） 作为应用程序二进制接口（ABI）而开发和发行的。工具接口标准委员会（TIS）选择了它作为 IA32 体系 结构上不同操作系统之间的可移植二进制文件格式，于是它就发展成为了事实上的二进制文件格式标准。

elf目标文件有待重定位文件，可共享目标文件，可执行文件。这里重点描述可执行文件。

![image-20201112212147244](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201112212147244.png)

### 节、段

**节（section）**是指在汇编源码中由section或segment修饰，的指令区域或者数据区域。不同的汇编器关键字可能不一样。汇编器将这两个关键字修饰的区域在目标文件中编译成节，所以说节是在待重定位文件目标文件时产生的。
**段（segment）**是链接器根据待重定位文件中属性相同的多个section合并成section集合，这个集合就是段（segment）。链接器最后生成的是可执行文件，所以段是在可执行文件中生成的。平时所说的数据段，代码段就是这里说的segment。

### 节头表、程序头表、节头、程序头

一个程序中，节和段的大小和数量是不固定的，所以就需要一个专门的表来描述它们，这个表就是所说的**节头表**（section header table）和**程序头表**（program header table）。节头表中描述的信息是多个节头（section header），段头表中描述的信息是多个段头（program header）。在表中，每一个成员称为条目，及entry，一个条目代表一个段或者一个节的头信息。

### elf header

因为程序中的段和节的大小和数量不确定，所以程序头表和节头表的大小就是不确定的，表在程序文件中的存储顺序也是由先后的，所以这两个表的位置也是不确定的。这时就必须在用一个固定的结构来描述这些不确定的信息，这个结构就是elf header，它位于文件最开始的部分。

>  elf文件格式作用是在文件链接和运行时方便进行程序的重定位。

### elf 结构

ELF 格式的作用体现在两方面，一是链接阶段， 另一方面是运行阶段，它们在文件中组织布局从这两方面展示。

![image-20201112212754030](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201112212754030.png) 

有关elf 的任何定义，包括变量、常量及取值范围，都可以在 Linux 系统的 **/usr/include/elf.h** 中找到，这里面的定义才是最全最权威的。

#### elf header

用到的数据类型如下

| 数据类型名称 | 字节大小 | 对齐 | 意义                 |
| :----------- | :------- | :--- | :------------------- |
| Elf32_Half   | 2        | 2    | 无符号中等大小的整数 |
| Elf32_Word   | 4        | 4    | 无符号大整数         |
| Elf32_Addr   | 4        | 4    | 无符号程序运行地址   |
| Elf32_Off    | 4        | 4    | 无符号的文件偏移量   |

```
//elf header结构
typedef struct
{
  unsigned char	e_ident[EI_NIDENT];	/* Magic number and other info */ //elf文件的魔数
  Elf32_Half	e_type;			//elf文件的格式
  Elf32_Half	e_machine;	 //描述elf文件的体系结构类型
  Elf32_Word	e_version;		 //版本信息
  Elf32_Addr	e_entry;		 //操作系统运行程序时,将控制权交到的虚拟地址
  Elf32_Off 	e_phoff;		//程序头表在文件内的偏移量
  Elf32_Off	    e_shoff;		//节头表在文件内的偏移量
  Elf32_Word	e_flags;		//与处理器相关的标志
  Elf32_Half	e_ehsize;		 //elf header的大小
  Elf32_Half	e_phentsize;		 //程序头表中每个条目的大小
  Elf32_Half	e_phnum;		 //程序头表中条目的数量
  Elf32_Half	e_shentsize;		//节头表中每个条目的大小
  Elf32_Half	e_shnum;		 //节头表中条目的数量
  Elf32_Half	e_shstrndx;		//string name table在节头表中的索引
} Elf32_Ehdr;
```

```
# xxd hello的结果，只截取了elf header相关的部分
00000000: 7f45 4c46 0101 0100 0000 0000 0000 0000   .ELF............
00000010: 0300 0300 0100 0000 e003 0000 3400 0000  ............4...
00000020: a817 0000 0000 0000 3400 2000 0900 2800  ........4. ...(.
00000030: 1d00 1c00 0600 0000 3400 0000 3400 0000  ........4...4...

#readelf -h hello的结果
ELF 头：
  Magic：   7f 45 4c 46 01 01 01 00 00 00 00 00 00 00 00 00 
  类别:                              ELF32
  数据:                              2 补码，小端序 (little endian)
  版本:                              1 (current)
  OS/ABI:                            UNIX - System V
  ABI 版本:                          0
  类型:                              DYN (共享目标文件)
  系统架构:                          Intel 80386
  版本:                              0x1
  入口点地址：               0x3e0
  程序头起点：          52 (bytes into file)
  Start of section headers:          6056 (bytes into file)
  标志：             0x0
  本头的大小：       52 (字节)
  程序头大小：       32 (字节)
  Number of program headers:         9
  节头大小：         40 (字节)
  节头数量：         29
  字符串表索引节头： 28
```

e_ident [16]是 16 字节大小的数组，用来表示 elf 字符等信息，开头的 4 个字 节是固定不变的，是 elf 文件的魔数，它们分别是 0x7f，以及字符串 ELF 的 ascall 码：0x45, 0x4c, 0x46。

![image-20201112214041441](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201112214041441.png)

e_ident[5]大小端字节序， 可以利用 **flie** 指令来看。。。

**e_type** 占用2字节，指定 elf 目标文件的类型

| elf目标文件类型 | 取值   | 意义                                       |
| :-------------- | :----- | :----------------------------------------- |
| ET_NONE         | 0      | 未知目标文件格式                           |
| ET_REL          | 1      | 可重定位文件                               |
| ET_EXEC         | 2      | 可执行文件                                 |
| ET_DYN          | 3      | 动态共享目标文件                           |
| ET_CORE         | 4      | core文件，即程序崩溃时其内存映像的转储格式 |
| ET_LOPROC       | 0xff00 | 特定处理器文件的扩展下边界                 |
| ET_HIPROC       | 0xffff | 特定处理器文件的扩展上边界                 |

取值为 2 的 ET_EXEC 类型，它的意义为程序可执行.

**其余的字段**

| 字段        | 大小(字节) |                             意义                             |
| :---------- | :--------- | :----------------------------------------------------------: |
| e_machine   | 2          |                        支持的硬件平台                        |
| e_version   | 4          |                         表示版本信息                         |
| e_entry     | 4          |        操作系统运行该程序时，将控制权转交到的虚拟地址        |
| e_phoff     | 4          |   程序头表在文件内的字节偏移量。如果没有程序头表，该值为0    |
| e_shoff     | 4          |      节头表在文件内的字节偏移量。若没有节头表，该值为0       |
| e_flags     | 4          |                      与处理器相关的标志                      |
| e_ehsize    | 2          |                  指明 elf header 的字节大小                  |
| e_phentsize | 2          | 指明程序头表(program header table )中每个条目(entry)的字节大小 |
| e_phnum     | 2          |         指明程序头表中条目的数量。实际上就是段的个数         |
| e_shentsize | 2          | 节头表中每个条目的字节大小，即每个用来描述节信息的数据结构的字节大小 |
| e_shnum     | 2          |          指明节头表中条目的数量。实际上就是节的个数          |
| e_shstrndx  | 2          |        指明 string name table 在节头表中的索引 index         |

e_machine 占用 2 字节，用来描述 elf 目标文件的体系结构类型，也就是说该文件要在哪种硬件平台（哪 种机器）上才能运行。

![image-20201126082647857](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201126082647857.png) 

#### struct Elf32_Phd

此段是指程序中的某个数据或代码的区域段落，例如数据段或代码段，并不是内存中的段，到现在为止我们都在讨论位于磁盘上的程序文件呢。struct Elf32_Phdr 结构的功能类似 GDT 中段描述符的作用，段描述符用来描述物理内存中的一个内存段，而 struct Elf32_Phdr 是**用来描述位于磁盘上的程序中的一个段**，它被加载到内存后才属于 GDT 中段描述符所指向的内存段的子集。

```
struct Elf32_Phdr
{
    Elf32_Word p_type;
    Elf32_Off p_offset;
    Elf32_Addr p_vaddr;
    Elf32_Addr p_paddr;
    Elf32_Word p_filesz;
    Elf32_Word p_memsz;
    Elf32_Word p_flags;
    Elf32_Word p_align;
};
```

各个字段意思

| 字段     |             意义             |
| :------- | :--------------------------: |
| p_type   |            段类型            |
| p_offset |      本段在文件的偏移量      |
| p_vaddr  |  本段在内存中起始的虚拟地址  |
| p_paddr  | 仅用于与物理地址相关的系统中 |
| p_filesz |      本段在文件中的大小      |
| p_memsz  |      本段在内存中的大小      |
| p_flags  |        本段相关的标志        |
| p_align  | 本段在文件和内存中的对齐方式 |



p_type 占用 4 字节，用来指明程序中该段的类型。

 ![image-20201126083519569](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201126083519569.png)

p_flag的取值

![image-20201126083630966](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201126083630966.png) 

p_align 占用 4 字节，用来指明本段在文件和内存中的对齐方式。如果值为 0 或 1，则表示不对齐。否则 p_align 应该是 2 的幂次数。

#### ELF32_Shdr

每个节区头部可以用下面的数据结构进行描述：

```
typedef struct {
    ELF32_Word      sh_name;
    ELF32_Word      sh_type;
    ELF32_Word      sh_flags;
    ELF32_Addr      sh_addr;
    ELF32_Off       sh_offset;
    ELF32_Word      sh_size;
    ELF32_Word      sh_link;
    ELF32_Word      sh_info;
    ELF32_Word      sh_addralign;
    ELF32_Word      sh_entsize;
} Elf32_Shdr;
```

| 成员         | 说明                                                         |
| ------------ | ------------------------------------------------------------ |
| sh_name      | 节名称，是节区头字符串表节区中（Section Header String Table Section）的索引，因此该字段实际是一个数值。在字符串表中的具体内容是以 NULL 结尾的字符串。 |
| sh_type      | 根据节的内容和语义进行分类，具体的类型下面会介绍。           |
| sh_flags     | 每一比特代表不同的标志，描述节是否可写，可执行，需要分配内存等属性。 |
| sh_addr      | 如果节区将出现在进程的内存映像中，此成员给出节区的第一个字节应该在进程镜像中的位置。否则，此字段为 0。 |
| sh_offset    | 给出节区的第一个字节与文件开始处之间的偏移。SHT_NOBITS 类型的节区不占用文件的空间，因此其 sh_offset 成员给出的是概念性的偏移。 |
| sh_size      | 此成员给出节区的字节大小。除非节区的类型是 SHT_NOBITS ，否则该节占用文件中的 sh_size 字节。类型为 SHT_NOBITS 的节区长度可能非零，不过却不占用文件中的空间。 |
| sh_link      | 此成员给出节区头部表索引链接，其具体的解释依赖于节区类型。   |
| sh_info      | 此成员给出附加信息，其解释依赖于节区类型。                   |
| sh_addralign | 某些节区的地址需要对齐。例如，如果一个节区有一个 doubleword 类型的变量，那么系统必须保证整个节区按双字对齐。也就是说，sh_addr%sh_addralignsh_addr%sh_addralign=0。目前它仅允许为 0，以及 2 的正整数幂数。 0 和 1 表示没有对齐约束。 |
| sh_entsize   | 某些节区中存在具有固定大小的表项的表，如符号表。对于这类节区，该成员给出每个表项的字节大小。反之，此成员取值为 0。 |

索引为零（SHN_UNDEF）的节区头也存在，此索引标记的是未定义的节区引用。这一项的信息如下

正如之前所说，索引为零（SHN_UNDEF）的节区头也存在，此索引标记的是未定义的节区引用。这一项的信息如下

| 字段名称     | 取值      | 说明       |
| ------------ | --------- | ---------- |
| sh_name      | 0         | 无名称     |
| sh_type      | SHT_NULL  | 限制       |
| sh_flags     | 0         | 无标志     |
| sh_addr      | 0         | 无地址     |
| sh_offset    | 0         | 无文件偏移 |
| sh_size      | 0         | 无大小     |
| sh_link      | SHN_UNDEF | 无链接信息 |
| sh_info      | 0         | 无辅助信息 |
| sh_addralign | 0         | 无对齐要求 |
| sh_entsize   | 0         | 无表项     |

#### 特殊下标

节头表中比较特殊的几个下标如下

| 名称          | 值     | 含义                                                         |
| ------------- | ------ | ------------------------------------------------------------ |
| SHN_UNDEF     | 0      | 标志未定义的，丢失的，不相关的或者其它没有意义的节引用。例如，与节号SHN_UNDEF相关的“定义”的符号就是一个未定义符号。**注：虽然0号索引被保留用于未定义值，节头表仍然包含索引0的项。也就是说，如果ELF头的e_shnum为6，那么索引应该为0~5。更加详细的内容在后面会说明。** |
| SHN_LORESERVE | 0xff00 | 保留索引值范围的下界。                                       |
| SHN_LOPROC    | 0xff00 | 处理器相关的下界                                             |
| SHN_HIPROC    | 0xff1f | 处理器相关的上界                                             |
| SHN_ABS       | 0xfff1 | 相关引用的绝对值。例如与节号SHN_ABS相关的符号拥有绝对值，它们不受重定位的影响 |
| SHN_COMMON    | 0xfff2 | 这一节区相定义的符号是通用符号，例如FORTRAN COMMON，C语言中未分配的外部变量。 |
| SHN_HIRESERVE | 0xffff | 保留索引值范围的上界。                                       |

**系统保留在`SHN_LORESERVE`到`SHN_HIRESERVE`之间(包含边界)的索引值，这些值不在节头表中引用。也就是说，节头表不包含保留索引项。没特别理解。**

#### 部分节头字段

##### sh_type

节类型目前有下列可选范围，其中 SHT 是**Section Header Table** 的简写。

| 名称         | 取值       | 说明                                                         |
| ------------ | ---------- | ------------------------------------------------------------ |
| SHT_NULL     | 0          | 该类型节区是非活动的，这种类型的节头中的其它成员取值无意义。 |
| SHT_PROGBITS | 1          | 该类型节区包含程序定义的信息，它的格式和含义都由程序来决定。 |
| SHT_SYMTAB   | 2          | 该类型节区包含一个符号表（**SYMbol TABle**）。目前目标文件对每种类型的节区都只  能包含一个，不过这个限制将来可能发生变化。  一般，SHT_SYMTAB 节区提供用于链接编辑（指 ld  而言） 的符号，尽管也可用来实现动态链接。 |
| SHT_STRTAB   | 3          | 该类型节区包含字符串表（ **STRing TABle** ）。               |
| SHT_RELA     | 4          | 该类型节区包含显式指定位数的重定位项（ **RELocation entry with Addends** ），例如，32 位目标文件中的 Elf32_Rela 类型。此外，目标文件可能拥有多个重定位节区。 |
| SHT_HASH     | 5          | 该类型节区包含符号哈希表（ **HASH table** ）。               |
| SHT_DYNAMIC  | 6          | 该类型节区包含动态链接的信息（ **DYNAMIC linking** ）。      |
| SHT_NOTE     | 7          | 该类型节区包含以某种方式标记文件的信息（**NOTE**）。         |
| SHT_NOBITS   | 8          | 该类型节区不占用文件的空间，其它方面和SHT_PROGBITS相似。尽管该类型节区不包含任何字节，其对应的节头成员sh_offset 中还是会包含概念性的文件偏移。 |
| SHT_REL      | 9          | 该类型节区包含重定位表项（**RELocation entry without Addends**），不过并没有指定位数。例如，32位目标文件中的 Elf32_rel 类型。目标文件中可以拥有多个重定位节区。 |
| SHT_SHLIB    | 10         | 该类型此节区被保留，不过其语义尚未被定义。                   |
| SHT_DYNSYM   | 11         | 作为一个完整的符号表，它可能包含很多对动态链接而言不必  要的符号。因此，目标文件也可以包含一个 SHT_DYNSYM  节区，其中保存动态链接符号的一个最小集合，以节省空间。 |
| SHT_LOPROC   | 0X70000000 | 此值指定保留给处理器专用语义的下界（ **LOw PROCessor-specific semantics** ）。 |
| SHT_HIPROC   | OX7FFFFFFF | 此值指定保留给处理器专用语义的上界（ **HIgh PROCessor-specific semantics** ）。 |
| SHT_LOUSER   | 0X80000000 | 此值指定保留给应用程序的索引下界。                           |
| SHT_HIUSER   | 0X8FFFFFFF | 此值指定保留给应用程序的索引上界。                           |

##### sh_flags

节头中 `sh_flags`  字段的每一个比特位都可以给出其相应的标记信息，其定义了对应的节区的内容是否可以被修改、被执行等信息。如果一个标志位被设置，则该位取值为1，未定义的位都为0。目前已定义值如下，其他值保留。

| 名称          | 值         | 说明                                                         |
| ------------- | ---------- | ------------------------------------------------------------ |
| SHF_WRITE     | 0x1        | 这种节包含了进程运行过程中可以被写的数据。                   |
| SHF_ALLOC     | 0x2        | 这种节在进程运行时占用内存。对于不占用目标文件的内存镜像空间的某些控制节，该属性处于关闭状态(off)。 |
| SHF_EXECINSTR | 0x4        | 这种节包含可执行的机器指令（**EXECutable INSTRuction**）。   |
| SHF_MASKPROC  | 0xf0000000 | 所有在这个掩码中的比特位用于特定处理器语义。                 |

##### sh_link & sh_info

当节区类型的不同的时候，sh_link 和 sh_info 也会具有不同的含义。

| sh_type               | sh_link                                                      | sh_info                    |
| --------------------- | ------------------------------------------------------------ | -------------------------- |
| SHT_DYNAMIC           | 节区中使用的字符串表的节头索引                               | 0                          |
| SHT_HASH              | 此哈希表所使用的符号表的节头索引                             | 0                          |
| SHT_REL/SHT_RELA      | 与符号表相关的的节头索引                                     | 重定位应用到的节的节头索引 |
| SHT_SYMTAB/SHT_DYNSYM | 操作系统特定信息，Linux 中的 ELF 文件中该项指向符号表中符号所对应的字符串节区在 Section Header Table 中的偏移。 | 操作系统特定信息           |
| other                 | `SHN_UNDEF`                                                  | 0                          |



## 载入内核

Linux下可以用`readelf`命令解析ELF文件，下面是我们在kernel目录下新添加的测试代码，因为是64位操作系统，编译命令需要如下修改，我们下一步就是将这个简单的elf文件加载入内核，物理内存中0x900是loader.bin的加载地址，其开始部分是不能覆盖的GDT，预计其大小是小于2000字节，保守起见这里选起始的物理地址为0x1500，所以链接命令指定虚拟起始地址0xc0001500。

![img](https://thunderjie.github.io/2020/05/10/%E7%AE%80%E5%8D%95%E5%86%85%E6%A0%B8%E5%AE%9E%E7%8E%B0%E7%AC%94%E8%AE%B0-part-1/42.png)

下面通过`dd`命令将其写入磁盘，为了不纠结count的赋值，这里直接赋值为200，seek赋值为9，写在第9扇区

```
sudo dd if=./kernel.bin of=/home/guang/soft/bochs-2.6.2/bin/hd60M.img bs=512 count=200 seek=9 conv=notrunc
```

写完之后我们需要修改loader.S中的内容，分两步完成

- 加载内核：内核文件加载到内存缓冲区
- 初始化内核：需要在分页后，将加载进来的elf内核文件安置到相应的虚拟内存地址，然后跳过去执行，从此loader的工作结束

内核的加载地址选取的是`0x7e00~0x9fbff`范围中的0x70000，添加如下片断

```
; ------------------ 加载内核 ------------------
mov eax, KERNEL_START_SECTOR  ; kernel.bin所在的扇区号0x9
mov ebx, KERNEL_BIN_BASE_ADDR ; 0x70000
; 从磁盘读出后,写入到ebx指定的地址
mov ecx, 200 ; 读入的扇区数

call rd_disk_m_32 ; eax,ebx,ecx均为参数,从硬盘上读取数据

; 创建页目录及页表并初始化页内存位图
call setup_page
```

下一步是初始化内核的工作，我们需要遍历`kernel.bin`程序中所有的段，因为它们才是程序运行的实质指令和数据的所在地，然后将各段拷贝到自己被编译的虚拟地址中，如下添加的是在`loader.S`中的内容，注释已经很详细了

```
   ; -------------------------   加载kernel  ----------------------
   [略...]
   ; 打开cr0的pg位(第31位)
   mov eax, cr0
   or eax, 0x80000000
   mov cr0, eax
   
   ; 在开启分页后，用gdt新的地址重新加载
   lgdt [gdt_ptr] ; 重新加载
   
   jmp SELECTOR_CODE:enter_kernel	  ; 强制刷新流水线,更新gdt,不刷新也可以
enter_kernel:  
   call kernel_init
   mov esp, 0xc009f000     ;进入内核之后栈也要修改
   jmp KERNEL_ENTRY_POINT  ; 用地址0x1500访问测试，结果ok
;----------将kernel.bin中的segment拷贝到编译的地址----------
kernel_init:
   xor eax, eax
   xor ebx, ebx	; 记录程序头表地址
   xor ecx, ecx	; cx记录程序头表中的program header数量
   xor edx, edx	; dx记录program header尺寸,即e_phentsize
	
   mov dx, [KERNEL_BIN_BASE_ADDR + 42] ; 偏移文件42字节处的属性是e_phentsize,表示program header大小
   mov ebx, [KERNEL_BIN_BASE_ADDR + 28] ; 偏移文件开始部分28字节的地方是e_phoff,表示第1个program header在文件中的偏移量

   add ebx, KERNEL_BIN_BASE_ADDR
   mov cx, [KERNEL_BIN_BASE_ADDR + 44]    ; 偏移文件开始部分44字节的地方是e_phnum,表示有几个program header
.each_segment:
   cmp byte [ebx + 0], PT_NULL ; 若p_type等于 PT_NULL,说明此program header未使用。
   je .PTNULL
   
   ;为函数memcpy压入参数,参数是从右往左依然压入.函数原型类似于 memcpy(dst,src,size)
   push dword [ebx + 16] ; program header中偏移16字节的地方是p_filesz,压入函数memcpy的第三个参数:size
   mov eax, [ebx + 4] ; 距程序头偏移量为4字节的位置是p_offset
   add eax, KERNEL_BIN_BASE_ADDR	  ; 加上kernel.bin被加载到的物理地址,eax为该段的物理地址
   push eax
   push dword [ebx + 8] ; 压入函数memcpy的第一个参数:目的地址,偏移程序头8字节的位置是p_vaddr，这就是目的地址
   call mem_cpy ; 调用mem_cpy完成段复制
   add esp,12   ; 清理栈中压入的三个参数, 3 * 4 = 12 字节
.PTNULL:
   add ebx, edx				  ; edx为program header大小,即e_phentsize,在此ebx指向下一个program header 
   loop .each_segment
   ret
   
;----------  逐字节拷贝 mem_cpy(dst,src,size) ------------
;输入:栈中三个参数(dst,src,size)
;输出:无
;---------------------------------------------------------
mem_cpy:
	cld ; 控制重复字符递增方式,也就是edi和esi每复制一次就加一个单位大小,相对的指令为std
	push ebp
	mov esp, ebp
	push ecx ; rep指令用到了ecx，但ecx对于外层段的循环还有用，故先入栈备份
	mov edi, [ebp + 8]  ; dst
	mov esi, [ebp + 12] ; src
	mov ecx, [ebp + 16] ; size
	rep movsb ; 逐字节拷贝,直到ecx为0
	
	; 恢复环境
	pop ecx
	pop ebp
	ret
```

最终的一个内存布局如下，参考之前的1MB实模式地址图来对应就明白了

![img](https://thunderjie.github.io/2020/05/10/%E7%AE%80%E5%8D%95%E5%86%85%E6%A0%B8%E5%AE%9E%E7%8E%B0%E7%AC%94%E8%AE%B0-part-1/43.png) 



## 特权级深入浅出

### 特权级简介

特权级按照权力从大到小分为 0、1、2、3 级，没错，数字越小，权力越大，**0 级特权能力最大，3 级特权能力最小**。

![image-20201201111343825](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201201111343825.png) 

操作系统位于最内环的 0 级特权，它要直接控制硬件，掌控各种核心数据，所以它的权利必须最大。系统程序分别位于 1 级特权和 2 级特权，运行在这两层的程序一般是虚拟机、驱 动程序等系统服务。在最外层的是 3 级特权，我们的用户程序就运行在此层，用户程序被设计为“有需求时找操作系统”，所以它不需要太大的能力，能完成一般工作即可，因此它的权利最弱。

### TSS 简介 

**任务状态段**（Task-State Segment(**TSS**)），保存任务状态信息的系统段为任务状态段。

![image-20201201112920210](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20201201112920210.png) 

TSS 是一种数据结构，它用于存储任务的环境。TSS主要分为**动态字段和静态字段**。

> 在任务切换过程中当任务挂起时，处理器会更新动态字段，动态字段有：
>  （1）通用寄存器字段—任务切换之前，EAX,ECX,EDX,EBX,ESP,EBP,ESI,EDI寄存器状态。
>  （2）段选择符字段—任务切换之前，ES,CS,SS,DS,FS,GS寄存器保存的段选择符。
>  （3）EFLAGS寄存器字段—任务切换之前，EFAGS寄存器的状态。
>  （4）EIP字段—任务切换之前，EIP寄存器的状态。
>  （5）先前任务链接字段—包含先前任务的TSS的段选择符。该字段禁止任务通过使用IRET指令返回先前的任务。
>
> 当任务创建时会创建静态字段，静态字段可读，不可写：
>  （1）LDT段选择符字段—包含任务LDT的段选择符。
>  （2）CR3控制寄存器字段—包含任务使用的页目录的物理基地址。CR3也被称为page directory base register(PDBR)页目录基址寄存器。
>  （3）特权级0,1,2栈指针字段—包含栈段（因为任务运行在不同特权级下，需要不同的栈段，故相应的SS0，SS1，SS2）的段选择符的逻辑地址和栈的偏移（不同特权级相应的ESP0，ESP1，ESP2）。在特定的任务中该字段是静态的，但是如果栈切换发生在单个任务中，SS和EIP的值就会改变。
>  （4）T标志（调试陷阱，100字节，位0）—如果设置，当切换任务时，会引起调试异常。
>  （5）I/O映射基址字段—是16位的偏移，包含从I/O权限位图和中断导向表中TSS的基地址。

TSS 是每个任务都有的结构，它用于一个任务的标识，相当于**任务的身份证**，程序拥有此结构才能运行，这是处理器硬件上用于任务管理的系统结构，处理器能够识别其中每一个字段。该结构看上去也有点复杂，里面众多寄存器都囊括到这 104 字节中啦，其实这 104 字节只是 TSS 的最小尺寸（其中有很多寄存器信息，**而TSS则是由TR寄存器加载的**），根据需要，还可以再接上个 IO 位图，这些内容将在后面章节用到时补充。这里目前只需要关注 28 字节之下的部分，这里包括了 3 个栈指针。

每个特权级只能有一个栈，特权级在变换的时候需要用到不同特权级下的栈，特权转移分为两类，一类是中断门和调用门实现低权限到高权限，另一类是由调用返回指令从高权限到低权限，这是唯一一种让处理器降低权限的方法。

对于低权限到高权限的情况，处理器需要提前记录目标栈的地方，更新SS和ESP，也就是说我们只需要提前在TSS中记录好高特权级的栈地址即可，也就是说TSS不需要记录3级特权的栈，因为它的权限最低。

对于高权限到低权限的情况，一方面因为处理器不需要在TSS中寻找低特权级目标栈的，也就是说TSS也不需要记录3级特权的栈，另一方面因为低权限的栈地址已经存在了，这是由处理器的向高特权级转移指令(int、call等)实现机制决定的。

# 完善内核

## 调用约定

 调用约定主要体现在以下三方面：

1. 参数的传递方式，参数是存放在寄存器中还是栈中
2. 参数的传递顺序，是从左到右传递还是从右到左传递
3. 是调用者保存寄存器环境还是被调用者保存

有如下常见的调用约定，我们主要关注cdecl、stdcall、thiscall即可

![image-20210122113800177](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20210122113800177.png)

为 C 语言遵循的调用约定是 cdecl 。stdcall与之对比。

### **stdcall 调用约定**

stdcall 的调用约定意味着

> （1）调用者将所有参数从右向左入栈。
>
> （2）被调用者清理参数所占的栈空间。 

**例子**

```c
subtract(int a, int b) { //被调用者
 return a-b; 
} 
int sub = subtract(3,2); //主调用者
//函数 subtract 返回 a 减 b 的差，这里只要代入实参
```

在 stdcall 调用约定下，这个 c 代码被编译后的汇编语句是：

主调用者：

```asm
; 从右到左将参数入栈
push 2 ;压入参数 b 
push 3 ;压入参数 a 
call subtract ;调用函数 subtract 
```

被调用者：

```asm
push ebp ;压入 ebp 备份
mov ebp,esp ;将 esp 赋值给 ebp 
; 用 ebp 作为基址来访问栈中参数
mov eax,[ebp+0x8] ;偏移 8 字节处为第 1 个参数 a 
add eax,[ebp+0xc] ;偏移 0xc 字节处是第 2 个参数 b 
; 参数 a 和 b 相加后存入 eax 
mov esp,ebp ;为防止中间有入栈操作,用 ebp 恢复 esp 
; 本句在此例子中可有可无,属于通用代码
pop ebp ;将 ebp 恢复
ret 8 ;数字 8 表示返回后使 esp+8 
; 函数返回时由被调函数清理了栈中参数
```

当执行流进入到 subtract 后，在它的内部为了用 ebp 作为基址引用栈中参数，先执行了 push ebp 来备份 ebp，再将栈指针赋给了 ebp。

 ![image-20210123103020130](C:\Users\Administrator.DESKTOP-NNL9G58\AppData\Roaming\Typora\typora-user-images\image-20210123103020130.png)

stdcall 是被调用者负责清理栈空间，这里的被调用者是函数 subtract。

也就是说，subtract 需要在返回前或返回时完成。在返回前清理栈相对困难一些，清理栈是指将栈顶回退到参数之前。因为返回地址在参数之下，ret 指令执行时必须保证当前栈顶是返回地址。所以通常在返回时“顺便”完成。于是 ret 指令便有了这样的变体。

其格式为：

```a's'm
ret 16 位立即数
```

stdcall 是调用者在栈中压入参数，由被调用者回收栈空间。貌似分工很明确，配合很默契。因为被调用者知道自己需要几个参数，所以知道要回收多少栈空间。



### **cdecl 调用约定**

cdecl 调用约定由于起源于 C 语言，所以又称为 C 调用约定，是 C 语言默认的调用约定。

cdecl 的调用约定意味着

> （1）调用者将所有参数从右向左入栈。
>
> （2）调用者清理参数所占的栈空间。

很容易发现它和 stdcall 一样都是从右向左将参数入栈的，区别就是 cdecl 由调用者清理栈空间。

例子同上

```c
subtract(int a, int b) { //被调用者
 return a-b; 
} 
int sub = subtract(3,2); //主调用者
//函数 subtract 返回 a 减 b 的差，这里只要代入实参
```

主调用者：

```asm
; 从右到左将参数入栈
push 2 ;压入参数 b 
push 3 ;压入参数 a 
call subtract ;调用函数 subtract 
add esp, 8 ;回收（清理）栈空间
```

被调用者：

```asm
push ebp ;压入 ebp 备份
mov ebp,esp ;将 esp 赋值给 ebp 
; 用 ebp 作为基址来访问栈中参数
mov eax,[ebp+0x8] ;偏移 8 字节处为第 1 个参数 a 
add eax,[ebp+0xc] ;偏移 0xc 字节处是第 2 个参数 b 
; 参数 a 和 b 相加后存入 eax 
mov esp,ebp ;为防止中间有入栈操作，用 ebp 恢复 esp 
; 本句在此例子中可有可无,属于通用代码
pop ebp ;将 ebp 恢复
ret
```

和 stdcall 相比，在 cdecl 调用约定下生成的汇编代码，就是在被调用者中的回收栈空间操作挪到了主调用者中，

在主调用者代码中的第 4 行，通过将 esp 加上 8 字节的方式回收了参数 a 和参数 b，本例中的其他代码都和 stdcall 一样。

## 系统调用

汇编语言和 C 语言混合编程可分为两大类。

> （1）单独的汇编代码文件与单独的 C 语言文件分别编译成目标文件后，一起链接成可执行程序。
>
> （2）在 C 语言中嵌入汇编代码，直接编译生成可执行程序。

为了更加理解系统调用，在后面会更频繁的结合C和汇编进行操作，下面做一个实验，分别用三种方式调用write函数，模拟下面C调用库函数的过程。

```c
#include<unistd.h>
int main(){
    write(1,"hello,world\n",4);
    return 0;
}
```

为了使用 c 标准库中的 write 函数，文件开头包含了标准头文件 unistd.h，通过该函数可以使用系统的 write 系统调用，该文件在磁盘上的路径是/usr/include/unistd.h。

调用“系统调用”有两种方式。

> （1）将系统调用指令封装为 c 库函数，通过库函数进行系统调用，操作简单。
>
> （2）不依赖任何库函数，直接通过汇编指令 int 与操作系统通信。

这里介绍第二种

eax 寄存器用来存储子功能号（寄存器 eip、ebp、esp 是不能使用的）。5 个参数存放在以下寄存器中，

传送参数的顺序如下。

> （1）ebx 存储第 1 个参数。
>
> （2）ecx 存储第 2 个参数。
>
> （3）edx 存储第 3 个参数。
>
> （4）esi 存储第 4 个参数。
>
> （5）edi 存储第 5 个参数。

模拟代码`syscall_write.S`如下

```asm
section .data
str_c_lib: db "C library says: hello world!", 0xa ; 0xa为换行符
str_c_lib_len equ $-str_c_lib

str_syscall: db "syscall says: hello world!", 0xa
str_syscall_len equ $-str_syscall

section .text
global _start
_start:
; ssize_t write(int fd,const void *buf,size_t count);
; 方法一:模拟C语言中系统调用库函数write
	push str_c_lib_len
	push str_c_lib
	push 1
	
	call my_write
	add esp, 12
	
; 方法二:系统调用
	mov eax, 4               ; 系统调用号
	mov ebx, 1               ; fd
	mov ecx, str_syscall     ; buf
	mov edx, str_syscall_len ; count
	int 0x80
	
; 退出程序
	mov eax, 1 ; exit()
	int 0x80

; 下面模拟write系统调用
my_write:
	push ebp
	mov esp, ebp
	mov eax, 4
	mov ebx, [ebp + 8]    ; fd
	mov ecx, [ebp + 0xc]  ; buf
	mov edx, [ebp + 0x10] ; count
	int 0x80
	pop ebp
	ret
```

运行结果如下

