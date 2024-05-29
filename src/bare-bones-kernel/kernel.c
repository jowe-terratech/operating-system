// These headers are provided by GCC
#include <stddef.h>
#include <stdint.h>

// Check we are using the correct compiler
#if defined(__linux__)
    #error "This code must be compiled with a cross-compiler"
#elif !defined(__i386__)
    #error "This code must be compiled with an x86-elf compiler"
#endif

volatile uint16_t* vga_buffer = (uint16_t*)0xb8000; // Video Memory Address in Offset Notation
const int VGA_COLS = 80; // 80 columns in each row
const int VGA_ROWS = 25; // 25 rows in the screen

int terminal_col = 0; // Current Column
int terminal_row = 0; // Current Row
uint8_t terminal_color = 0x0f; // White on Black

void terminal_init() {
    /* Overrides the screen with 0x20 (Space) */
    for (int x = 0; x < VGA_COLS; x++) {
        for (int y = 0; y < VGA_ROWS; y++) {
            const size_t vga_offset = y * VGA_COLS + x;
            vga_buffer[vga_offset] = ((uint16_t)terminal_color << 8) | 0x20; // Attribute + Character
        }
    }
}

void kernel_cprint(char c) {
    // We dont display all characters
    switch (c) {
        case '\n': {
            terminal_col = 0;
            terminal_row++;
            break;
        }
        default: {
            const size_t vga_offset = terminal_row * VGA_COLS + terminal_col;
            vga_buffer[vga_offset] = ((uint16_t)terminal_color << 8) | c; // Attribute + Character
            terminal_col++;
            break;
        }
    }
    // Wrap if we reach the end of the row
    if (terminal_col >= VGA_COLS) {
        terminal_col = 0;
        terminal_row++;
    }
    // Reset to the top of the screen if we reach the end
    if (terminal_row >= VGA_ROWS) {
        terminal_col = 0;
        terminal_row = 0;
    }
}

void kernel_sprint(const char* str) {
    // Print characters until we reach the null terminator
    for (size_t i = 0; str[i] != '\0'; i++) {
        kernel_cprint(str[i]);
    }
}

void kernel_main() {
    terminal_init();
    kernel_sprint("Hello, World from the Kernel!");
}