;--------------------   将小端字节序的数字变成对应的ascii后，倒置   -----------------------
;输入：栈中参数为待打印的数字
;输出：在屏幕上打印16进制数字,并不会打印前缀0x,如打印10进制15时，只会直接打印f，不会是0xf
;------------------------------------------------------------------------------------------

global put_int
put_int:
	pushad
	mov ebp, esp
	mov eax, [ebp + 4*9] ; call的返回地址占4字节再加上pushad的8个四字节
	mov edx, eax
	mov edi, 7	; 指定在put_int_buffer中初始的偏移量	
	mov ecx, 8	; 32位数字中，十六进制数字的位数是8个
	mov ebx, put_int_buffer
	
; 将32位数字按照十六进制的形式从低位到高位逐个处理
; 共处理8个十六进制数字
.16based_4bits:	; 每4位二进制是16进制数字的1位
; 遍历每一位十六进制数字
	and edx, 0x0000000F	; 解析十六进制数字的每一位
						; and与操作后，edx只有低4位有效
	cmp edx, 9			; 数字0~9和a~f需要分别处理成对应的字符
	jg .is_A2F
	add edx, '0'		; ASCII码是8位大小。add求和操作后，edx低8位有效
	jmp .store
.is_A2F:
	sub edx, 10			; A~F减去10所得到的差，再加上字符A的
						; ASCII码，便是A~F对应的ASCII码
	add edx, 'A'
; 将每一位数字转换成对应的字符后,按照类似“大端”的顺序存储到缓冲区put_int_buffer
; 高位字符放在低地址,低位字符要放在高地址,这样和大端字节序类似,只不过咱们这里是字符序.
.store:
; 此时dl中应该是数字对应的字符的ASCII码
	mov [ebx + edi], dl
	dec edi
	shr eax, 4
	mov edx, eax
	loop .16based_4bits
	
; 现在put_int_buffer中已全是字符，打印之前
; 把高位连续的字符去掉，比如把字符000123变成123
.ready_to_print:
	inc edi		; 此时edi退减为-1(0xffffffff),加上1使其为0
.skip_prefix_0:
	cmp edi, 8	; 若已经比较第9个字符了
				; 表示待打印的字符串为全0
	je .full0
; 找出连续的0字符，edi作为非0的最高位字符的偏移
.go_on_skip:
	mov cl, [put_int_buffer + edi]
	inc edi
	cmp cl, '0'
	je .skip_prefix_0	; 继续判断下一位字符是否为字符0(不是数字0)
	dec edi				; edi在上面的inc操作中指向了下一个字符
	; 若当前字符不为'0'，要使edi减1恢复指向当前字符
	jmp .put_each_num
	
.full0:
	mov cl, '0'			; 输入的数字为全0时，则只打印0
.put_each_num:
	push ecx			; 此时cl中为可打印的字符
	call put_char
	add esp, 4
	inc edi				; 使edi指向下一个字符
	mov cl, [put_int_buffer + edi] ; 获取下一个字符到cl寄存器
	cmp edi, 8
	jl .put_each_num
	popad
	ret