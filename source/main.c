#include "common.h"
#include "power.h"
#include "ff.h"
#include "firm.h"
#include "sha.h"

#define FIRM_PATH    ":/boot.firm"
#define FIRM_BUFFER  ((void*)0x27C00000)
#define FIRM_MAXSIZE (0x3FFB00)

#define RANGE(x,a,b) (((x)>=(a))&&((x)<=(b)))

u32 wlist[][2] = {
    {0x08000000, 0x08100000},
    {0x18000000, 0x18600000},
    {0x1FF00000, 0x1FFFFC00},
    {0x20000000, 0x23FFFE00},
    {0x24000000, (u32)FIRM_BUFFER}
};

bool FirmAddressValid(u32 loc, u32 dest, u32 size)
{
    bool ret=false;
    u32 regs = sizeof(wlist)/sizeof(wlist[0]);
    if (loc&0x1FF || dest&0x3 || size&0x1FF)
        return false;

    for (u32 i = 0; (ret == false) && (i < regs); i++) {
        ret |= (RANGE(dest, wlist[i][0], wlist[i][1]) &&
                RANGE(dest+size, wlist[i][0], wlist[i][1]));
    }
    return ret;
}

bool FirmValid(void *firm, u32 firm_size)
{
    FirmHeader *hdr;
    FirmSection *sect;
    bool mpcoreFound, stdFound;
    u32 firmSizeTotal;
    u8 sectionHash[0x20];

    hdr = (FirmHeader*)firm;
    if (firm_size < sizeof(FirmHeader) ||
        memcmp(hdr->magic, FIRM_MAGIC, 4)) {
        return false;
    }

    mpcoreFound = false;
    stdFound = false;
    firmSizeTotal = sizeof(FirmHeader);

    for (int i = 0; i < 4; i++) {
        u32 off, addr, size;
        sect = &(hdr->section[i]);
        off = sect->off;
        addr = sect->addr;
        size = sect->size;

        if (!size)
            continue;

        firmSizeTotal += size;
        if (firmSizeTotal > firm_size || !FirmAddressValid((u32)hdr + off, addr, size))
            return false;

        sha_quick(sectionHash, (void*)((u32)hdr + off), size, SHA256_MODE);
        if (memcmp(sectionHash, sect->shaHash, 0x20)) {
            return false;
        }

        if (!mpcoreFound && RANGE(hdr->mpcoreEntry, addr, addr + size))
            mpcoreFound = true;

        if (!stdFound && RANGE(hdr->stdEntry, addr, addr + size))
            stdFound = true;
    }

    if (!mpcoreFound)
        hdr->mpcoreEntry = 0;

    return stdFound;
}

void main(void)
{
    FATFS fs;
    FIL firm;
    FRESULT res;
    size_t flen, br;

    res = f_mount(&fs, "0:", 1);
    if ((res == FR_OK) && (f_open(&firm, "0"FIRM_PATH, FA_READ) == FR_OK) &&
        ((flen=f_size(&firm)) <= FIRM_MAXSIZE)) {
        res = f_read(&firm, FIRM_BUFFER, flen, &br);
        if ((flen == br) && (res == FR_OK) &&
            (FirmValid(FIRM_BUFFER, flen))) {
            BootFirm(FIRM_BUFFER);
        }
    }

    PowerOff();
    while(1);
}
