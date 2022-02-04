#include "bsp_clk.h"
#include "bsp_led.h"
#include "bsp_delay.h"

int main(void)
{
    clk_enable();
    led_init();
    while(1)
    {
        led_on();
        delay_ms(500);
        led_off();
        delay_ms(500);
    }
    return 0;
}
