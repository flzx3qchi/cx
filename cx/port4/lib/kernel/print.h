#ifndef __LIB_KERNEL_PRINT_H // ���û��__LIB_KERNEL_PRINT_H�����������Ĵ���
#define __LIB_KERNEL_PRINT_H
#include "stdint.h"
void put_char(uint8_t char_asci); // ������8λ�޷�������,Ϊ�˺�֮ǰ���������cl�Ĵ��������Ǻ�
void put_str(char* message); // �ַ�����ӡ��������\0��β
void put_int(uint32_t num); // ��16���Ƶ���ʽ��ӡ����
#endif
