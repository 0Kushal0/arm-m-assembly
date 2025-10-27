/*
 * Create a FLASH memory and RAM memory.
 * Add sections vectors, text in FLASH memory.
 * Add sections data & stackaddress in RAM memory.
 */

MEMORY {
    FLASH : ORIGIN = 0x0, LENGTH = 0x4000
    RAM : ORIGIN = 0x20000000, LENGTH = 0x800
}

SECTIONS {
    .text : {
        *(.vectors)
        *(.text*)
    } > FLASH

    .data : {
        *(.data*)
        *(.stackaddress)
    } > RAM AT > RAM
}