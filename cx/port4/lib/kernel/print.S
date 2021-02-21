;--------------------   ��С���ֽ�������ֱ�ɶ�Ӧ��ascii�󣬵���   -----------------------
;���룺ջ�в���Ϊ����ӡ������
;���������Ļ�ϴ�ӡ16��������,�������ӡǰ׺0x,���ӡ10����15ʱ��ֻ��ֱ�Ӵ�ӡf��������0xf
;------------------------------------------------------------------------------------------

global put_int
put_int:
	pushad
	mov ebp, esp
	mov eax, [ebp + 4*9] ; call�ķ��ص�ַռ4�ֽ��ټ���pushad��8�����ֽ�
	mov edx, eax
	mov edi, 7	; ָ����put_int_buffer�г�ʼ��ƫ����	
	mov ecx, 8	; 32λ�����У�ʮ���������ֵ�λ����8��
	mov ebx, put_int_buffer
	
; ��32λ���ְ���ʮ�����Ƶ���ʽ�ӵ�λ����λ�������
; ������8��ʮ����������
.16based_4bits:	; ÿ4λ��������16�������ֵ�1λ
; ����ÿһλʮ����������
	and edx, 0x0000000F	; ����ʮ���������ֵ�ÿһλ
						; and�������edxֻ�е�4λ��Ч
	cmp edx, 9			; ����0~9��a~f��Ҫ�ֱ����ɶ�Ӧ���ַ�
	jg .is_A2F
	add edx, '0'		; ASCII����8λ��С��add��Ͳ�����edx��8λ��Ч
	jmp .store
.is_A2F:
	sub edx, 10			; A~F��ȥ10���õ��Ĳ�ټ����ַ�A��
						; ASCII�룬����A~F��Ӧ��ASCII��
	add edx, 'A'
; ��ÿһλ����ת���ɶ�Ӧ���ַ���,�������ơ���ˡ���˳��洢��������put_int_buffer
; ��λ�ַ����ڵ͵�ַ,��λ�ַ�Ҫ���ڸߵ�ַ,�����ʹ���ֽ�������,ֻ���������������ַ���.
.store:
; ��ʱdl��Ӧ�������ֶ�Ӧ���ַ���ASCII��
	mov [ebx + edi], dl
	dec edi
	shr eax, 4
	mov edx, eax
	loop .16based_4bits
	
; ����put_int_buffer����ȫ���ַ�����ӡ֮ǰ
; �Ѹ�λ�������ַ�ȥ����������ַ�000123���123
.ready_to_print:
	inc edi		; ��ʱedi�˼�Ϊ-1(0xffffffff),����1ʹ��Ϊ0
.skip_prefix_0:
	cmp edi, 8	; ���Ѿ��Ƚϵ�9���ַ���
				; ��ʾ����ӡ���ַ���Ϊȫ0
	je .full0
; �ҳ�������0�ַ���edi��Ϊ��0�����λ�ַ���ƫ��
.go_on_skip:
	mov cl, [put_int_buffer + edi]
	inc edi
	cmp cl, '0'
	je .skip_prefix_0	; �����ж���һλ�ַ��Ƿ�Ϊ�ַ�0(��������0)
	dec edi				; edi�������inc������ָ������һ���ַ�
	; ����ǰ�ַ���Ϊ'0'��Ҫʹedi��1�ָ�ָ��ǰ�ַ�
	jmp .put_each_num
	
.full0:
	mov cl, '0'			; ���������Ϊȫ0ʱ����ֻ��ӡ0
.put_each_num:
	push ecx			; ��ʱcl��Ϊ�ɴ�ӡ���ַ�
	call put_char
	add esp, 4
	inc edi				; ʹediָ����һ���ַ�
	mov cl, [put_int_buffer + edi] ; ��ȡ��һ���ַ���cl�Ĵ���
	cmp edi, 8
	jl .put_each_num
	popad
	ret