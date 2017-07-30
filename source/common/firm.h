#pragma once
#include "common.h"

#define FIRM_MAGIC ((u8[]){'F', 'I', 'R', 'M'})

typedef struct {
    u32 off;
    u32 addr;
    u32 size;
    u32 copyMethod;
    u8 shaHash[0x20];
} FirmSection;

typedef struct {
    u8 magic[4];
    u32 prio;
    u32 mpcoreEntry;
    u32 stdEntry;
    u8 reserved[0x30];
    FirmSection section[4];
    u8 rsaSignature[0x100];
} FirmHeader;
