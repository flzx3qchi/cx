#include "init.h" 
#include "print.h" 
#include "interrupt.h" 
 
/*�����ʼ������ģ�� */ 
void init_all() { 
    put_str("init_all\n"); 
    idt_init(); //��ʼ���ж�
}
