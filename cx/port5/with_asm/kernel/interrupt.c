# include "stdint.h"
# include "global.h"
# include "io.h"
# include "interrupt.h"

# define IDT_DESC_CNT 0x21 //֧�ֵ��ж���
# define PIC_M_CTRL 0x20
# define PIC_M_DATA 0x21
# define PIC_S_CTRL 0xa0
# define PIC_S_DATA 0xa1

/*�ж����������ṹ��*/
struct gate_desc {
    uint16_t func_offset_low_word;
    uint16_t selector;
    uint8_t dcount; //����Ϊ˫�ּ����ֶΣ������������еĵ� 4 �ֽ�
                    //����̶�ֵ�����ÿ���
    uint8_t attribute;
    uint16_t func_offset_high_word;
};

static void make_idt_desc(struct gate_desc* p_gdesc, uint8_t attr, intr_handler function);
static struct gate_desc idt[IDT_DESC_CNT];  // idt ���ж���������
                                            //�����Ͼ��Ǹ��ж�������������
extern intr_handler intr_entry_table[IDT_DESC_CNT]; // �������ö����� kernel.S  
                                                    // �е��жϴ������������

/**
 * �����ж���������.
 */ 
static void make_idt_desc(struct gate_desc* p_gdesc, uint8_t attr, intr_handler function) {
    p_gdesc->func_offset_low_word = (uint32_t) function & 0x0000FFFF;
    p_gdesc->selector = SELECTOR_K_CODE;
    p_gdesc->dcount = 0;
    p_gdesc->attribute = attr;
    p_gdesc->func_offset_high_word = ((uint32_t) function & 0xFFFF0000) >> 16;
}

/**
 * ��ʼ���ж���������.
 */ 
static void idt_desc_init(void) {
    int i;
    for (i = 0; i < IDT_DESC_CNT; i++) {
        make_idt_desc(&idt[i], IDT_DESC_ATTR_DPL0, intr_entry_table[i]);
    }
    put_str("idt_desc_init done.\n");
}

static void pic_init(void) {
    // ��ʼ����Ƭ
    outb(PIC_M_CTRL, 0x11); // ICW1: ���ش���,���� 8259, ��Ҫ ICW4
    outb(PIC_M_DATA, 0x20); // ICW2: ��ʼ�ж�������Ϊ 0x20
                            // Ҳ���� IR[0-7] Ϊ 0x20 �� 0x27
    outb(PIC_M_DATA, 0x04); // ICW3: IR2 �Ӵ�Ƭ
    outb(PIC_M_DATA, 0x01); // ICW4: 8086 ģʽ, ���� EOI

    outb(PIC_S_CTRL, 0x11); // ICW1: ���ش���,���� 8259, ��Ҫ ICW4
    outb(PIC_S_DATA, 0x28); // ICW2: ��ʼ�ж�������Ϊ 0x28
                            // Ҳ���� IR[8-15]Ϊ 0x28 �� 0x2F
    outb(PIC_S_DATA, 0x02); // ICW3: ���ô�Ƭ���ӵ���Ƭ�� IR2 ����
    outb(PIC_S_DATA, 0x01); // ICW4: 8086 ģʽ, ���� EOI
    /*����Ƭ�� IR0,Ҳ����Ŀǰֻ����ʱ�Ӳ������ж� */
    outb(PIC_M_DATA, 0xfe);
    outb(PIC_S_DATA, 0xff);

    put_str("pic_init done.\n");
}

/*����й��жϵ����г�ʼ������*/
void idt_init() {
    put_str("idt_init start.\n");
    idt_desc_init();  // ��ʼ���ж���������
    pic_init();       // ��ʼ�� 8259A

    // ����idt
    uint64_t idt_operand = ((sizeof(idt) - 1) | ((uint64_t) ((uint32_t) idt << 16)));
    asm volatile ("lidt %0" : : "m" (idt_operand));
    put_str("idt_init done.\n");
}