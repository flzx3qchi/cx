/******************����ģʽ ******************* 
b -- ����Ĵ��� QImode ���ƣ����Ĵ����е���� 8 λ:[a-d]l
w -- ����Ĵ��� HImode ���ƣ����Ĵ����� 2 ���ֽڵĲ���,��[a-d]x 
  
HImode 
"Half-Integer"ģʽ����ʾһ�����ֽڵ�����
QImode 
"Quarter-Integer"ģʽ����ʾһ��һ�ֽڵ�����
******************************************************/

#ifndef _LIB_IO_H
#define _LIB_IO_H

#include "stdint.h"

/**
 *  ��ָ���Ķ˿�д��һ���ֽڵ�����.
 	�Զ˿�ָ�� N ��ʾ 0��255, d ��ʾ�� dx �洢�˿ں�, 
    %b0 ��ʾ��Ӧ al , %w1 ��ʾ��Ӧ dx */
 */ 
static inline void outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %b0, %w1" : : "a" (data), "Nd" (port));   
}

/**
 *  ��addr��ʼ����word_cnt���ֽ�д��˿�port.
   	'+' ��ʾ�����Ƽ�������,�������. 
  	outsw �ǰ� ds:esi ���� 16 λ������д�� port �˿ڣ����������ö�������ʱ, 
  	�Ѿ��� ds,es,ss �ε�ѡ���Ӷ�����Ϊ��ͬ��ֵ�ˣ���ʱ���õ������ݴ���?
 */ 
static inline void outsw(uint16_t port, const void* addr, uint32_t word_cnt) {
    asm volatile ("cld; rep outsw" : "+S" (addr), "+c" (word_cnt) : "d" (port));
}

/**
 *  ���Ӷ˿�port�����һ���ֽڷ���.
 */ 
static inline uint8_t inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %w1, %b0" : "=a" (data) : "Nd" (port));
    return data;
}

/**
 *  ����port��ȡ��word_cnt�ֽ�д��addr.
 	insw �ǽ��Ӷ˿� port ������� 16 λ����д�� es:edi ָ����ڴ�, 
   	���������ö�������ʱ���Ѿ��� ds,es,ss �ε�ѡ���Ӷ�����Ϊ��ͬ��ֵ��, 
 	��ʱ���õ������ݴ���? 
 */ 
static inline void insw(uint16_t port, void* addr, uint32_t word_cnt) {
    asm volatile ("cld; rep insw" : "+D" (addr), "+c" (word_cnt) : "d" (port) : "memory");
}

#endif
