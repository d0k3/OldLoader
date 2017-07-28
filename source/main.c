#include "power.h"
#include "chainload.h"
#include "qff.h"

#define PAYLOAD_PATH "0:/arm9loaderhax.bin"
#define PAYLOAD_BUFFER ((u8*) 0x21000000)
#define BUFFER_SIZE (0x100000)

void main(int argc, char** argv)
{
    (void) argc; // unused
    (void) argv; // unused
    UINT payload_size = 0;
    
    // init filesystem, load payload
    if ((fs_init() != FR_OK) ||
        (f_qread(PAYLOAD_PATH, PAYLOAD_BUFFER, 0, BUFFER_SIZE, &payload_size) != FR_OK) ||
        (!payload_size) || (payload_size >= BUFFER_SIZE))
        PowerOff();
        
    // chainload payload
    Chainload(PAYLOAD_BUFFER, payload_size);
    while(1);
}
