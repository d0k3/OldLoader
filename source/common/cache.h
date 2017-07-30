#include "common.h"

void (*wbDC)(void) = (void(*)(void))(0xFFFF07FC);
void (*invDC)(void) = (void(*)(void))(0xFFFF07F0);
void (*invIC)(void) = (void(*)(void))(0xFFFF0AB4);

void (*wbDC_range)(void *s,void *e)  = (void(*)(void*,void*))(0xFFFF0884);
void (*invDC_range)(void *s,void *e) = (void(*)(void*,void*))(0xFFFF0868);
void (*invIC_range)(void *s,void *e) = (void(*)(void*,void*))(0xFFFF0AC0);
