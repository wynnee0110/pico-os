void kernel_main(void) {
  volatile unsigned short *video = (volatile unsigned short *)0xB8000;

  const char *message = "Welcome to pico";

  for (int i = 0; message[i] != '\0'; i++) {
    video[i] = (unsigned short)message[i] | 0x0700;
  }

  for (;;) {
    __asm__ volatile("hlt");
  }
}