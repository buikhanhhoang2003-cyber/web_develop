#!/usr/bin/env bash
# Usage: bash recreate_script_ai_relay.sh
# Creates script_ai_relay next to this file.
set -eu

project_dir="$(dirname -- "$0")/script_ai_relay"
mkdir -- "$project_dir"
mkdir -p -- "$project_dir"/.vscode "$project_dir"/boards "$project_dir"/bsp "$project_dir"/bsp/include "$project_dir"/include "$project_dir"/lib "$project_dir"/src "$project_dir"/src/drivers "$project_dir"/test "$project_dir"/tools

cat > "$project_dir"/.gitignore <<'__SCRIPT_AI_RELAY_FILE__'
.pio
.vscode/.browse.c_cpp.db*
.vscode/c_cpp_properties.json
.vscode/launch.json
.vscode/ipch
__SCRIPT_AI_RELAY_FILE__

cat > "$project_dir"/.vscode/extensions.json <<'__SCRIPT_AI_RELAY_FILE__'
{
    // See http://go.microsoft.com/fwlink/?LinkId=827846
    // for the documentation about the extensions.json format
    "recommendations": [
        "platformio.platformio-ide"
    ],
    "unwantedRecommendations": [
        "ms-vscode.cpptools-extension-pack",
        "pioarduino.pioarduino-ide"
    ]
}
__SCRIPT_AI_RELAY_FILE__

cat > "$project_dir"/boards/smart_relay_ra6m5.json <<'__SCRIPT_AI_RELAY_FILE__'
{
  "name": "Smart Relay RA6M5",
  "vendor": "Smart Relay",
  "url": "https://www.renesas.com/en/products/ra6m5",
  "build": {
    "cpu": "cortex-m33",
    "mcu": "r7fa6m5bh3cfc",
    "f_cpu": "24000000L"
  },
  "debug": { "jlink_device": "R7FA6M5BH", "svd_path": "R7FA6M5BH.svd" },
  "upload": {
    "maximum_ram_size": 524288,
    "maximum_size": 2097152,
    "protocol": "custom",
    "protocols": ["custom", "jlink"]
  }
}
__SCRIPT_AI_RELAY_FILE__

cat > "$project_dir"/bsp/include/bsp_cfg.h <<'__SCRIPT_AI_RELAY_FILE__'
#ifndef BSP_CFG_H
#define BSP_CFG_H

#include "bsp_mcu_info.h"
#include "bsp_clock_cfg.h"
#include "r_ioport_cfg.h"

#define BSP_MCU_R7FA6M5BH3CFC
#define BSP_MCU_GROUP_RA6M5               1
#define BSP_CFG_MCU_PART_SERIES          6
#define BSP_MCU_FEATURE_SET              'B'
#define BSP_NUMBER_OF_CORES              1
#define BSP_CFG_CPU_CORE                 0
#define BSP_PACKAGE_LQFP
#define BSP_PACKAGE_PINS                 176
#define BSP_ROM_SIZE_BYTES               2097152
#define BSP_RAM_SIZE_BYTES               524288
#define BSP_DATA_FLASH_SIZE_BYTES        8192
#define BSP_CFG_MCU_VCC_MV               3300

#define BSP_CORTEX_VECTOR_TABLE_ENTRIES  16U
#define BSP_VECTOR_TABLE_MAX_ENTRIES     112U
#define BSP_CFG_INLINE_IRQ_FUNCTIONS     0
#define BSP_CFG_STACK_MAIN_BYTES         1024U
#define BSP_CFG_HEAP_BYTES               0U
#define BSP_CFG_C_RUNTIME_INIT           1
#define BSP_CFG_EARLY_INIT               1
#define BSP_CFG_PFS_PROTECT              1
#define BSP_CFG_PARAM_CHECKING_ENABLE    1
#define BSP_CFG_ASSERT                   0
#define BSP_CFG_ERROR_LOG                0
#define BSP_CFG_RTOS                     0
#define BSP_CFG_RTC_USED                 0
#define BSP_CFG_SKIP_INIT                0
#define BSP_CFG_STARTUP_CLOCK_REG_NOT_RESET 0
#define BSP_TZ_SECURE_BUILD              0
#define BSP_TZ_NONSECURE_BUILD           0
#define BSP_TZ_CFG_SKIP_INIT             0
#define BSP_CFG_CLOCKS_SECURE            0
#define BSP_CFG_C_CACHE_LINE_SIZE        1U /* 32-byte code cache lines. */

void bsp_init(void * p_args);

#endif
__SCRIPT_AI_RELAY_FILE__

cat > "$project_dir"/bsp/include/bsp_clock_cfg.h <<'__SCRIPT_AI_RELAY_FILE__'
#ifndef BSP_CLOCK_CFG_H
#define BSP_CLOCK_CFG_H

/* Smart_Relay_v2.pdf, sheet 3, X3. Run without a PLL for bring-up. */
#define BSP_CFG_XTAL_HZ                    24000000U
#define BSP_CLOCK_CFG_MAIN_OSC_POPULATED   1
#define BSP_CLOCK_CFG_MAIN_OSC_CLOCK_SOURCE 0
#define BSP_CLOCK_CFG_MAIN_OSC_WAIT        9
#define BSP_CLOCK_CFG_SUBCLOCK_POPULATED   0
#define BSP_CFG_HOCO_FREQUENCY             0
#define BSP_HOCO_HZ                       16000000U
#define BSP_MOCO_HZ                       8000000U
#define BSP_LOCO_HZ                       32768U
#define BSP_SUB_CLOCK_HZ                  32768U

#define BSP_CFG_CLOCK_SOURCE              BSP_CLOCKS_SOURCE_CLOCK_MAIN_OSC
#define BSP_CFG_ICLK_DIV                  BSP_CLOCKS_SYS_CLOCK_DIV_1
#define BSP_CFG_PCLKA_DIV                 BSP_CLOCKS_SYS_CLOCK_DIV_1
#define BSP_CFG_PCLKB_DIV                 BSP_CLOCKS_SYS_CLOCK_DIV_1
#define BSP_CFG_PCLKC_DIV                 BSP_CLOCKS_SYS_CLOCK_DIV_1
#define BSP_CFG_PCLKD_DIV                 BSP_CLOCKS_SYS_CLOCK_DIV_1
#define BSP_CFG_BCLK_DIV                  BSP_CLOCKS_SYS_CLOCK_DIV_1
#define BSP_CFG_FCLK_DIV                  BSP_CLOCKS_SYS_CLOCK_DIV_1
#define BSP_CFG_BCLK_OUTPUT               0

#define BSP_CFG_CLKOUT_SOURCE             BSP_CLOCKS_CLOCK_DISABLED
#define BSP_CFG_CANFDCLK_SOURCE           BSP_CLOCKS_CLOCK_DISABLED
#define BSP_CFG_CECCLK_SOURCE             BSP_CLOCKS_CLOCK_DISABLED
#define BSP_CFG_UCLK_SOURCE               BSP_CLOCKS_CLOCK_DISABLED
#define BSP_CFG_USB60CLK_SOURCE           BSP_CLOCKS_CLOCK_DISABLED
#define BSP_CFG_OCTACLK_SOURCE            BSP_CLOCKS_CLOCK_DISABLED
#define BSP_CFG_PLL_SOURCE                BSP_CLOCKS_CLOCK_DISABLED
#define BSP_CFG_PLL2_SOURCE               BSP_CLOCKS_CLOCK_DISABLED
#define BSP_CFG_USB_ENABLE                0
#define BSP_CFG_FLL_ENABLE                0

#endif
__SCRIPT_AI_RELAY_FILE__

cat > "$project_dir"/bsp/include/bsp_linker_info.h <<'__SCRIPT_AI_RELAY_FILE__'
#ifndef BSP_LINKER_INFO_H
#define BSP_LINKER_INFO_H

#include <stdint.h>

/* Initialization table interface used by FSP v6.6 SystemInit(). */
typedef struct
{
    uint32_t copy_64 : 8;
    uint32_t external : 8;
    uint32_t source_type : 8;
    uint32_t destination_type : 8;
} bsp_init_type_t;

typedef struct
{
    uint32_t * const p_base;
    uint32_t * const p_limit;
    bsp_init_type_t type;
} bsp_init_zero_info_t;

typedef struct
{
    uint32_t * const p_base;
    uint32_t * const p_limit;
    uint32_t * const p_load;
    bsp_init_type_t type;
} bsp_init_copy_info_t;

typedef struct
{
    uint32_t * const p_base;
    uint32_t * const p_limit;
} bsp_mpu_nocache_info_t;

typedef struct
{
    uint32_t zero_count;
    const bsp_init_zero_info_t * const p_zero_list;
    uint32_t copy_count;
    const bsp_init_copy_info_t * const p_copy_list;
    uint32_t nocache_count;
    const bsp_mpu_nocache_info_t * const p_nocache_list;
} bsp_init_info_t;

extern const bsp_init_info_t g_init_info;

#endif
__SCRIPT_AI_RELAY_FILE__

cat > "$project_dir"/bsp/include/vector_data.h <<'__SCRIPT_AI_RELAY_FILE__'
#ifndef VECTOR_DATA_H
#define VECTOR_DATA_H

#define VECTOR_DATA_IRQ_COUNT 4U
#define BSP_ICU_VECTOR_NUM_ENTRIES 4U

#define VECTOR_NUMBER_SPI0_RXI ((IRQn_Type) 0)
#define VECTOR_NUMBER_SPI0_TXI ((IRQn_Type) 1)
#define VECTOR_NUMBER_SPI0_TEI ((IRQn_Type) 2)
#define VECTOR_NUMBER_SPI0_ERI ((IRQn_Type) 3)

#endif
__SCRIPT_AI_RELAY_FILE__

cat > "$project_dir"/bsp/linker_data.c <<'__SCRIPT_AI_RELAY_FILE__'
#include "bsp_linker_info.h"

extern uint32_t __bss_start, __bss_end;
extern uint32_t __data_start, __data_end, __data_load;

static const bsp_init_zero_info_t zero_list[] = {
    { .p_base = &__bss_start, .p_limit = &__bss_end },
};

static const bsp_init_copy_info_t copy_list[] = {
    { .p_base = &__data_start, .p_limit = &__data_end, .p_load = &__data_load },
};

const bsp_init_info_t g_init_info = {
    .zero_count = sizeof(zero_list) / sizeof(zero_list[0]),
    .p_zero_list = zero_list,
    .copy_count = sizeof(copy_list) / sizeof(copy_list[0]),
    .p_copy_list = copy_list,
};
__SCRIPT_AI_RELAY_FILE__

cat > "$project_dir"/bsp/ra6m5.ld <<'__SCRIPT_AI_RELAY_FILE__'
ENTRY(Reset_Handler)

MEMORY
{
    FLASH (rx)  : ORIGIN = 0x00000000, LENGTH = 2M
    SRAM  (rwx) : ORIGIN = 0x20000000, LENGTH = 512K
}

SECTIONS
{
    .text ORIGIN(FLASH) :
    {
        KEEP(*(.fixed_vectors))
        KEEP(*(.application_vectors))
        . = ALIGN(4);
        *(.text .text.*)
        *(.rodata .rodata.*)
        . = ALIGN(4);
        __init_array_start = .;
        KEEP(*(SORT_BY_INIT_PRIORITY(.init_array.*)))
        KEEP(*(.init_array))
        __init_array_end = .;
    } > FLASH

    .ARM.extab : { *(.ARM.extab*) } > FLASH
    .ARM.exidx :
    {
        __exidx_start = .;
        *(.ARM.exidx*)
        __exidx_end = .;
    } > FLASH

    .noinit (NOLOAD) :
    {
        . = ALIGN(8);
        KEEP(*(.bss.g_main_stack))
        *(.ram_noinit .ram_noinit.*)
        *(.noinit .noinit.*)
        . = ALIGN(8);
    } > SRAM

    .data :
    {
        . = ALIGN(4);
        __data_start = .;
        *(.data .data.* .ramfunc .ramfunc.*)
        . = ALIGN(4);
        __data_end = .;
    } > SRAM AT > FLASH
    __data_load = LOADADDR(.data);

    .bss (NOLOAD) :
    {
        . = ALIGN(4);
        __bss_start = .;
        *(.bss .bss.* COMMON)
        . = ALIGN(4);
        __bss_end = .;
    } > SRAM
}
__SCRIPT_AI_RELAY_FILE__

cat > "$project_dir"/bsp/vector_data.c <<'__SCRIPT_AI_RELAY_FILE__'
#include "bsp_api.h"

void spi_rxi_isr(void);
void spi_txi_isr(void);
void spi_tei_isr(void);
void spi_eri_isr(void);

BSP_DONT_REMOVE const fsp_vector_t g_vector_table[BSP_ICU_VECTOR_NUM_ENTRIES]
    BSP_PLACE_IN_SECTION(BSP_SECTION_APPLICATION_VECTORS) = {
    [VECTOR_NUMBER_SPI0_RXI] = spi_rxi_isr,
    [VECTOR_NUMBER_SPI0_TXI] = spi_txi_isr,
    [VECTOR_NUMBER_SPI0_TEI] = spi_tei_isr,
    [VECTOR_NUMBER_SPI0_ERI] = spi_eri_isr,
};

const bsp_interrupt_event_t g_interrupt_event_link_select[BSP_ICU_VECTOR_NUM_ENTRIES] = {
    [VECTOR_NUMBER_SPI0_RXI] = ELC_EVENT_SPI0_RXI,
    [VECTOR_NUMBER_SPI0_TXI] = ELC_EVENT_SPI0_TXI,
    [VECTOR_NUMBER_SPI0_TEI] = ELC_EVENT_SPI0_TEI,
    [VECTOR_NUMBER_SPI0_ERI] = ELC_EVENT_SPI0_ERI,
};
__SCRIPT_AI_RELAY_FILE__

cat > "$project_dir"/include/README <<'__SCRIPT_AI_RELAY_FILE__'

This directory is intended for project header files.

A header file is a file containing C declarations and macro definitions
to be shared between several project source files. You request the use of a
header file in your project source file (C, C++, etc) located in `src` folder
by including it, with the C preprocessing directive `#include'.

```src/main.c

#include "header.h"

int main (void)
{
 ...
}
```

Including a header file produces the same results as copying the header file
into each source file that needs it. Such copying would be time-consuming
and error-prone. With a header file, the related declarations appear
in only one place. If they need to be changed, they can be changed in one
place, and programs that include the header file will automatically use the
new version when next recompiled. The header file eliminates the labor of
finding and changing all the copies as well as the risk that a failure to
find one copy will result in inconsistencies within a program.

In C, the convention is to give header files names that end with `.h'.

Read more about using header files in official GCC documentation:

* Include Syntax
* Include Operation
* Once-Only Headers
* Computed Includes

https://gcc.gnu.org/onlinedocs/cpp/Header-Files.html
__SCRIPT_AI_RELAY_FILE__

cat > "$project_dir"/lib/README <<'__SCRIPT_AI_RELAY_FILE__'

This directory is intended for project specific (private) libraries.
PlatformIO will compile them to static libraries and link into the executable file.

The source code of each library should be placed in a separate directory
("lib/your_library_name/[Code]").

For example, see the structure of the following example libraries `Foo` and `Bar`:

|--lib
|  |
|  |--Bar
|  |  |--docs
|  |  |--examples
|  |  |--src
|  |     |- Bar.c
|  |     |- Bar.h
|  |  |- library.json (optional. for custom build options, etc) https://docs.platformio.org/page/librarymanager/config.html
|  |
|  |--Foo
|  |  |- Foo.c
|  |  |- Foo.h
|  |
|  |- README --> THIS FILE
|
|- platformio.ini
|--src
   |- main.c

Example contents of `src/main.c` using Foo and Bar:
```
#include <Foo.h>
#include <Bar.h>

int main (void)
{
  ...
}

```

The PlatformIO Library Dependency Finder will find automatically dependent
libraries by scanning project source files.

More information about PlatformIO Library Dependency Finder
- https://docs.platformio.org/page/librarymanager/ldf.html
__SCRIPT_AI_RELAY_FILE__

cat > "$project_dir"/platformio.ini <<'__SCRIPT_AI_RELAY_FILE__'
; PlatformIO Project Configuration File
;
;   Build options: build flags, source filter
;   Upload options: custom upload port, speed and extra flags
;   Library options: dependencies, extra library storages
;   Advanced options: extra scripting
;
; Please visit documentation for the other options and examples
; https://docs.platformio.org/page/projectconf.html

[env:smart_relay_ra6m5]
platform = platformio/renesas-ra@1.9.0
platform_packages =
    platformio/toolchain-gccarmnoneeabi@1.140201.0
    platformio/tool-jlink@1.92000.0
board = smart_relay_ra6m5
board_build.ldscript = bsp/ra6m5.ld
extra_scripts = pre:tools/platformio_build.py
build_type = debug
debug_tool = jlink
debug_speed = 1000
upload_protocol = custom
upload_command = "$PYTHONEXE" "$PROJECT_DIR/tools/jlink_upload.py" "$JLINK_COMMANDER" "$JLINK_DEVICE" "$JLINK_SPEED" "$BUILD_DIR/${PROGNAME}.elf"
__SCRIPT_AI_RELAY_FILE__

cat > "$project_dir"/README.md <<'__SCRIPT_AI_RELAY_FILE__'
# Smart Relay RA6M5 LCD bring-up

Run these commands from this PlatformIO project directory.

```powershell
pio run
pio run -t upload
```

On Windows, if `pio` is off `PATH`, use `& "$env:USERPROFILE\.platformio\penv\Scripts\pio.exe"` in its place. The build uses the official PlatformIO Renesas RA platform and this board's FSP v6.6.0 configuration. The first build fetches the pinned Renesas FSP, Arm CMSIS and FreeRTOS source archives over HTTPS and extracts them under `.pio/reference`.

To reuse the PlatformIO packages cached during this bring-up, set `$env:PLATFORMIO_CORE_DIR = (Resolve-Path '../../.pio/pio-core').Path` in the same PowerShell session.

The flash image is `.pio/build/smart_relay_ra6m5/firmware.elf`. Upload runs J-Link Commander with `R7FA6M5BH`, SWD at 1000 kHz and the ELF `loadfile` command. The script resets and runs the target after programming. PlatformIO also has `debug_tool = jlink` configured for this environment.

## GUI trên host PC

Dùng Python 3 để cài PyQt5 và mở GUI từ thư mục dự án.

```powershell
python -m pip install -r tools/requirements.txt
python tools/host_gui.py
```

**Build firmware** chạy `pio run`. **Nạp qua J-Link** chạy `pio run -t upload` và dùng kết nối SWD đã cấu hình. Cửa sổ hiển thị log và kết quả của từng tác vụ. Nếu GUI không tự tìm được PlatformIO, dùng **Chọn tệp…** để trỏ đến `pio.exe` hoặc `pio`.

## Bench connections

Power the board from its own supply. Connect main-board **JP1** pin 1 to J-Link VTref, pin 2 to RESET, pin 3 to SWDIO, pin 4 to SWCLK, and pin 5 to GND. For the 20-pin ARM J-Link connector those signals are pins 1, 15, 7, 9 and 4 respectively. VTref senses the target's 3.3 V rail.

| LCD signal | MCU pin | Board net |
| --- | --- | --- |
| CS | P406 | `LCD_SSLA3_C` |
| MISO | P700 | `LCD_MISOA_C` |
| MOSI | P701 | `LCD_MOSIA_C` |
| SCK | P702 | `LCD_RSPCKA_C` |
| D/C | P703 | `LCD_DC` |
| RESET | P704 | `LCD_RESET` |
| VDD and backlight | 3.3 V | `VDD_3.3V` |
| GND | GND | `GND` |

The main-board schematic (sheet 3) and pinout workbook (`RA6M5_Pinout!A3:C11`) agree on SPI0 pin group C. The main-board JP5 and display-board JP1 drawings number mating positions differently. Use the net names and check continuity before making a hand-wired connection. The display schematic (sheet 1) ties the backlight to the 3.3 V rail.

The BSP runs from the board's 24 MHz crystal. This bench image drives P206 (`WDT_EN`) low during FSP startup to disable the external watchdog timer. The voltage supervisor remains active. If U12 is populated as `BD37B34FVM-CTR`, measure its 3.3 V supply and `RESET_MCU` before troubleshooting software. The part's nominal 3.4 V detection threshold can keep the MCU in reset on a nominal 3.3 V rail.

## Expected result

The LCD task cycles red, green, blue, white and black, holding each completed screen for 1000 ms. Transferring a frame at 1 MHz takes at least 1.23 s before that hold. In a debugger, `lcd_test_error` shows the last FSP status, `lcd_test_frames` counts completed transfers, and `lcd_test_color` holds the most recent RGB565 value.

If the panel stays white, check `LCD_RESET` for a low-to-high transition, then check P406 CS, P702 SCK, P701 MOSI and P703 D/C for the initialization sequence `11`, `3A 55`, `36 00`, `29`, followed by window setup `2A`, `2B` and pixel data `2C`. If red and blue appear swapped, verify the panel's color order using MADCTL bit 3.
__SCRIPT_AI_RELAY_FILE__

cat > "$project_dir"/src/drivers/ili9341.c <<'__SCRIPT_AI_RELAY_FILE__'
#include "ili9341.h"

#include "FreeRTOS.h"
#include "task.h"
#include "lcd_board.h"

enum
{
    ILI9341_WIDTH = 240,
    ILI9341_HEIGHT = 320,
    ILI9341_SLPOUT = 0x11,
    ILI9341_DISPON = 0x29,
    ILI9341_CASET = 0x2A,
    ILI9341_PASET = 0x2B,
    ILI9341_RAMWR = 0x2C,
    ILI9341_MADCTL = 0x36,
    ILI9341_COLMOD = 0x3A
};

static bool spi_open;
static volatile fsp_err_t spi_result;
static uint8_t pixel_row[2U * ILI9341_WIDTH];

void lcd_spi_callback(spi_callback_args_t * p_args)
{
    if (SPI_EVENT_TRANSFER_COMPLETE != p_args->event)
    {
        spi_result = FSP_ERR_TRANSFER_ABORTED;
    }
    else if (FSP_ERR_IN_USE == spi_result)
    {
        spi_result = FSP_SUCCESS;
    }
}

static fsp_err_t stop_spi(fsp_err_t failure)
{
    if (spi_open)
    {
        fsp_err_t err = R_SPI_Close(&lcd_spi_ctrl);
        spi_open = false;
        if (FSP_SUCCESS != err)
        {
            return err;
        }
    }
    return failure;
}

static fsp_err_t write_spi(const uint8_t * bytes, uint32_t count)
{
    const TickType_t start = xTaskGetTickCount();
    spi_result = FSP_ERR_IN_USE;

    fsp_err_t err = R_SPI_Write(&lcd_spi_ctrl, bytes, count, SPI_BIT_WIDTH_8_BITS);
    if (FSP_SUCCESS != err)
    {
        return stop_spi(err);
    }

    while (FSP_ERR_IN_USE == spi_result)
    {
        if ((TickType_t)(xTaskGetTickCount() - start) >= pdMS_TO_TICKS(100))
        {
            /* Stop accessing the buffer before returning to the caller. */
            return stop_spi(FSP_ERR_TIMEOUT);
        }
        vTaskDelay(1);
    }
    return spi_result;
}

static fsp_err_t begin_command(uint8_t command)
{
    fsp_err_t err = R_IOPORT_PinWrite(&lcd_ioport_ctrl, LCD_DC_PIN, BSP_IO_LEVEL_LOW);
    if (FSP_SUCCESS == err)
    {
        err = R_IOPORT_PinWrite(&lcd_ioport_ctrl, LCD_CS_PIN, BSP_IO_LEVEL_LOW);
    }
    if (FSP_SUCCESS == err)
    {
        err = write_spi(&command, 1);
    }
    return err;
}

static fsp_err_t end_command(fsp_err_t transfer_result)
{
    fsp_err_t err = R_IOPORT_PinWrite(&lcd_ioport_ctrl, LCD_CS_PIN, BSP_IO_LEVEL_HIGH);
    return (FSP_SUCCESS == transfer_result) ? err : transfer_result;
}

static fsp_err_t write_command(uint8_t command, const uint8_t * data, uint32_t count)
{
    fsp_err_t err = begin_command(command);
    if (FSP_SUCCESS == err && 0U != count)
    {
        err = R_IOPORT_PinWrite(&lcd_ioport_ctrl, LCD_DC_PIN, BSP_IO_LEVEL_HIGH);
        if (FSP_SUCCESS == err)
        {
            err = write_spi(data, count);
        }
    }
    return end_command(err);
}

fsp_err_t ili9341_init(void)
{
    const uint8_t rgb565 = 0x55;
    /* Portrait with RGB filters. Set bit 3 for a BGR panel. */
    const uint8_t portrait = 0x00;

    if (spi_open)
    {
        return FSP_ERR_ALREADY_OPEN;
    }

    fsp_err_t err = R_SPI_CalculateBitrate(1000000U, &lcd_spi_extend.spck_div);
    if (FSP_SUCCESS == err)
    {
        err = R_SPI_Open(&lcd_spi_ctrl, &lcd_spi_cfg);
    }
    if (FSP_SUCCESS != err)
    {
        return err;
    }
    spi_open = true;

    err = R_IOPORT_PinWrite(&lcd_ioport_ctrl, LCD_RESET_PIN, BSP_IO_LEVEL_LOW);
    if (FSP_SUCCESS == err)
    {
        vTaskDelay(pdMS_TO_TICKS(20) + 1U);
        err = R_IOPORT_PinWrite(&lcd_ioport_ctrl, LCD_RESET_PIN, BSP_IO_LEVEL_HIGH);
    }
    if (FSP_SUCCESS == err)
    {
        /* RESX release to Sleep Out, then wait for the controller to wake up. */
        vTaskDelay(pdMS_TO_TICKS(120) + 1U);
        err = write_command(ILI9341_SLPOUT, NULL, 0);
    }
    if (FSP_SUCCESS == err)
    {
        vTaskDelay(pdMS_TO_TICKS(120) + 1U);
        err = write_command(ILI9341_COLMOD, &rgb565, 1);
    }
    if (FSP_SUCCESS == err)
    {
        err = write_command(ILI9341_MADCTL, &portrait, 1);
    }
    if (FSP_SUCCESS == err)
    {
        err = write_command(ILI9341_DISPON, NULL, 0);
    }
    return (FSP_SUCCESS == err) ? FSP_SUCCESS : stop_spi(err);
}

fsp_err_t ili9341_fill_screen(uint16_t color)
{
    static const uint8_t columns[] = {0x00, 0x00, 0x00, ILI9341_WIDTH - 1};
    static const uint8_t pages[] = {0x00, 0x00, (ILI9341_HEIGHT - 1) >> 8,
                                   (ILI9341_HEIGHT - 1) & 0xFF};

    if (!spi_open)
    {
        return FSP_ERR_NOT_OPEN;
    }

    for (uint32_t pixel = 0; pixel < ILI9341_WIDTH; ++pixel)
    {
        pixel_row[2U * pixel] = (uint8_t)(color >> 8);
        pixel_row[2U * pixel + 1U] = (uint8_t)color;
    }

    fsp_err_t err = write_command(ILI9341_CASET, columns, sizeof(columns));
    if (FSP_SUCCESS == err)
    {
        err = write_command(ILI9341_PASET, pages, sizeof(pages));
    }
    if (FSP_SUCCESS == err)
    {
        err = begin_command(ILI9341_RAMWR);
        if (FSP_SUCCESS == err)
        {
            err = R_IOPORT_PinWrite(&lcd_ioport_ctrl, LCD_DC_PIN, BSP_IO_LEVEL_HIGH);
        }
        for (uint32_t row = 0; row < ILI9341_HEIGHT && FSP_SUCCESS == err; ++row)
        {
            err = write_spi(pixel_row, sizeof(pixel_row));
        }
        err = end_command(err);
    }
    return (FSP_SUCCESS == err) ? err : stop_spi(err);
}
__SCRIPT_AI_RELAY_FILE__

cat > "$project_dir"/src/drivers/ili9341.h <<'__SCRIPT_AI_RELAY_FILE__'
#ifndef ILI9341_H
#define ILI9341_H

#include "bsp_api.h"

/* Call from the LCD task after the FreeRTOS scheduler starts. */
fsp_err_t ili9341_init(void);
fsp_err_t ili9341_fill_screen(uint16_t color);

#endif
__SCRIPT_AI_RELAY_FILE__

cat > "$project_dir"/src/FreeRTOSConfig.h <<'__SCRIPT_AI_RELAY_FILE__'
#ifndef FREERTOS_CONFIG_H
#define FREERTOS_CONFIG_H

#include <stdint.h>

extern uint32_t SystemCoreClock;
void lcd_test_assert(void);

#define configCPU_CLOCK_HZ                    (SystemCoreClock)
#define configTICK_RATE_HZ                    1000U
#define configTICK_TYPE_WIDTH_IN_BITS         TICK_TYPE_WIDTH_32_BITS
#define configMAX_PRIORITIES                  2U
#define configMINIMAL_STACK_SIZE              128U
#define configUSE_PREEMPTION                  1
#define configUSE_IDLE_HOOK                   0
#define configUSE_TICK_HOOK                   0
#define configUSE_TASK_NOTIFICATIONS          0
#define configSUPPORT_STATIC_ALLOCATION       1
#define configSUPPORT_DYNAMIC_ALLOCATION      0
#define configENABLE_MPU                      0
#define configENABLE_FPU                      0
#define configENABLE_TRUSTZONE                0
#define configRUN_FREERTOS_SECURE_ONLY        1
#define configMAX_SYSCALL_INTERRUPT_PRIORITY  0x50U /* RA6M5 implements four priority bits. */
#define configASSERT(condition)               do { if (!(condition)) { lcd_test_assert(); } } while (0)
#define INCLUDE_vTaskDelay                    1

#define vPortSVCHandler    SVC_Handler
#define xPortPendSVHandler PendSV_Handler

#endif
__SCRIPT_AI_RELAY_FILE__

cat > "$project_dir"/src/lcd_board.c <<'__SCRIPT_AI_RELAY_FILE__'
#include "lcd_board.h"
#include "vector_data.h"

#define LCD_SPI_PIN (IOPORT_CFG_PERIPHERAL_PIN | IOPORT_PERIPHERAL_SPI)
#define GPIO_LOW    (IOPORT_CFG_PORT_DIRECTION_OUTPUT | IOPORT_CFG_PORT_OUTPUT_LOW)
#define GPIO_HIGH   (IOPORT_CFG_PORT_DIRECTION_OUTPUT | IOPORT_CFG_PORT_OUTPUT_HIGH)
#define WDT_EN_PIN  BSP_IO_PORT_02_PIN_06

static const ioport_pin_cfg_t lcd_pins[] = {
    { .pin = LCD_CS_PIN,            .pin_cfg = GPIO_HIGH },
    { .pin = LCD_DC_PIN,            .pin_cfg = GPIO_LOW },
    { .pin = LCD_RESET_PIN,         .pin_cfg = GPIO_LOW },
    { .pin = WDT_EN_PIN,            .pin_cfg = GPIO_LOW },
    { .pin = BSP_IO_PORT_07_PIN_00, .pin_cfg = LCD_SPI_PIN }, /* MISO */
    { .pin = BSP_IO_PORT_07_PIN_01, .pin_cfg = LCD_SPI_PIN }, /* MOSI */
    { .pin = BSP_IO_PORT_07_PIN_02, .pin_cfg = LCD_SPI_PIN }, /* SCK */
};

static const ioport_cfg_t lcd_pin_cfg = {
    .number_of_pins = sizeof(lcd_pins) / sizeof(lcd_pins[0]),
    .p_pin_cfg_data = lcd_pins,
};

ioport_instance_ctrl_t lcd_ioport_ctrl;
spi_instance_ctrl_t lcd_spi_ctrl;
fsp_err_t lcd_board_init_status = FSP_ERR_NOT_OPEN;

spi_extended_cfg_t lcd_spi_extend = {
    .spi_clksyn = SPI_SSL_MODE_SPI,
    .spi_comm = SPI_COMMUNICATION_TRANSMIT_ONLY,
    .ssl_polarity = SPI_SSLP_LOW,
    .ssl_select = SPI_SSL_SELECT_SSL3,
    .mosi_idle = SPI_MOSI_IDLE_VALUE_FIXING_LOW,
    .parity = SPI_PARITY_MODE_DISABLE,
    .byte_swap = SPI_BYTE_SWAP_DISABLE,
    .spck_delay = SPI_DELAY_COUNT_1,
    .ssl_negation_delay = SPI_DELAY_COUNT_1,
    .next_access_delay = SPI_DELAY_COUNT_1,
    .burst_interframe_delay = SPI_BURST_TRANSFER_WITHOUT_DELAY,
};

const spi_cfg_t lcd_spi_cfg = {
    .channel = 0,
    .rxi_irq = VECTOR_NUMBER_SPI0_RXI,
    .txi_irq = VECTOR_NUMBER_SPI0_TXI,
    .tei_irq = VECTOR_NUMBER_SPI0_TEI,
    .eri_irq = VECTOR_NUMBER_SPI0_ERI,
    .rxi_ipl = 4,
    .txi_ipl = 4,
    .tei_ipl = 4,
    .eri_ipl = 4,
    .operating_mode = SPI_MODE_MASTER,
    .clk_phase = SPI_CLK_PHASE_EDGE_ODD,
    .clk_polarity = SPI_CLK_POLARITY_LOW,
    .mode_fault = SPI_MODE_FAULT_ERROR_DISABLE,
    .bit_order = SPI_BIT_ORDER_MSB_FIRST,
    .p_callback = lcd_spi_callback,
    .p_extend = &lcd_spi_extend,
};

void R_BSP_WarmStart(bsp_warm_start_event_t event)
{
    if (event == BSP_WARM_START_RESET)
    {
        /* INH low disables the external watchdog for this bench image. */
        R_BSP_PinAccessEnable();
        R_BSP_PinCfg(WDT_EN_PIN, GPIO_LOW);
        R_BSP_PinAccessDisable();
    }
}

void bsp_init(void * p_args)
{
    (void) p_args;
    lcd_board_init_status = R_IOPORT_Open(&lcd_ioport_ctrl, &lcd_pin_cfg);
}
__SCRIPT_AI_RELAY_FILE__

cat > "$project_dir"/src/lcd_board.h <<'__SCRIPT_AI_RELAY_FILE__'
#ifndef LCD_BOARD_H
#define LCD_BOARD_H

#include "r_ioport.h"
#include "r_spi.h"

#define LCD_CS_PIN    BSP_IO_PORT_04_PIN_06
#define LCD_DC_PIN    BSP_IO_PORT_07_PIN_03
#define LCD_RESET_PIN BSP_IO_PORT_07_PIN_04

extern ioport_instance_ctrl_t lcd_ioport_ctrl;
extern spi_instance_ctrl_t lcd_spi_ctrl;
extern spi_extended_cfg_t lcd_spi_extend;
extern const spi_cfg_t lcd_spi_cfg;
extern fsp_err_t lcd_board_init_status;

void lcd_spi_callback(spi_callback_args_t * p_args);

#endif
__SCRIPT_AI_RELAY_FILE__

cat > "$project_dir"/src/main.c <<'__SCRIPT_AI_RELAY_FILE__'
#include "lcd_board.h"
#include "drivers/ili9341.h"
#include "FreeRTOS.h"
#include "task.h"

/* Inspect these in a debugger during bring-up. */
volatile fsp_err_t lcd_test_error = FSP_SUCCESS;
volatile uint32_t lcd_test_frames;
volatile uint16_t lcd_test_color;

static StaticTask_t lcd_task_storage;
static StackType_t lcd_task_stack[384];

void vApplicationGetIdleTaskMemory(StaticTask_t ** storage, StackType_t ** stack, uint32_t * depth)
{
    static StaticTask_t idle_storage;
    static StackType_t idle_stack[configMINIMAL_STACK_SIZE];

    *storage = &idle_storage;
    *stack = idle_stack;
    *depth = configMINIMAL_STACK_SIZE;
}

void lcd_test_assert(void)
{
    __disable_irq();
    for (;;)
    {
        __NOP();
    }
}

static void lcd_test_task(void * arg)
{
    (void) arg;
    static const uint16_t colors[] = { 0xF800, 0x07E0, 0x001F, 0xFFFF, 0x0000 };

    lcd_test_error = ili9341_init();
    while (lcd_test_error == FSP_SUCCESS)
    {
        for (size_t i = 0; i < sizeof(colors) / sizeof(colors[0]); ++i)
        {
            lcd_test_error = ili9341_fill_screen(colors[i]);
            if (lcd_test_error != FSP_SUCCESS)
            {
                break;
            }

            lcd_test_color = colors[i];
            ++lcd_test_frames;
            vTaskDelay(pdMS_TO_TICKS(1000));
        }
    }

    for (;;)
    {
        vTaskDelay(pdMS_TO_TICKS(1000));
    }
}

int main(void)
{
    lcd_test_error = lcd_board_init_status;
    if (lcd_test_error == FSP_SUCCESS)
    {
        TaskHandle_t task = xTaskCreateStatic(lcd_test_task, "LCD",
                                             sizeof(lcd_task_stack) / sizeof(lcd_task_stack[0]),
                                             NULL, 1, lcd_task_stack, &lcd_task_storage);
        if (task != NULL)
        {
            vTaskStartScheduler();
        }
        lcd_test_error = FSP_ERR_INTERNAL;
    }
    lcd_test_assert();
    return 0;
}
__SCRIPT_AI_RELAY_FILE__

cat > "$project_dir"/src/r_ioport_cfg.h <<'__SCRIPT_AI_RELAY_FILE__'
#ifndef R_IOPORT_CFG_H
#define R_IOPORT_CFG_H

#define IOPORT_CFG_PARAM_CHECKING_ENABLE 1
#define IOPORT_CFG_CCD_SUPPORT_ENABLE   0

#endif
__SCRIPT_AI_RELAY_FILE__

cat > "$project_dir"/src/r_spi_cfg.h <<'__SCRIPT_AI_RELAY_FILE__'
#ifndef R_SPI_CFG_H
#define R_SPI_CFG_H

#define SPI_CFG_PARAM_CHECKING_ENABLE 1
#define SPI_TRANSMIT_FROM_RXI_ISR    0

#endif
__SCRIPT_AI_RELAY_FILE__

cat > "$project_dir"/test/README <<'__SCRIPT_AI_RELAY_FILE__'

This directory is intended for PlatformIO Test Runner and project tests.

Unit Testing is a software testing method by which individual units of
source code, sets of one or more MCU program modules together with associated
control data, usage procedures, and operating procedures, are tested to
determine whether they are fit for use. Unit testing finds problems early
in the development cycle.

More information about PlatformIO Unit Testing:
- https://docs.platformio.org/en/latest/advanced/unit-testing/index.html
__SCRIPT_AI_RELAY_FILE__

cat > "$project_dir"/tools/host_gui.py <<'__SCRIPT_AI_RELAY_FILE__'
from codecs import getincrementaldecoder
from pathlib import Path
from shutil import which
import os
import sys

from PyQt5.QtCore import QProcess, QProcessEnvironment, Qt, QUrl
from PyQt5.QtGui import QDesktopServices, QFontDatabase, QTextCursor
from PyQt5.QtWidgets import (
    QApplication, QFileDialog, QHBoxLayout, QLabel, QLineEdit, QPlainTextEdit,
    QPushButton, QVBoxLayout, QWidget,
)


PROJECT_DIR = Path(__file__).resolve().parent.parent
BUILD_DIR = PROJECT_DIR / ".pio" / "build" / "smart_relay_ra6m5"


def platformio_path():
    on_path = which("pio") or which("platformio")
    if on_path:
        return on_path

    default = Path.home() / ".platformio" / "penv"
    default /= "Scripts/pio.exe" if os.name == "nt" else "bin/pio"
    return str(default) if default.is_file() else ""


class HostWindow(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Smart Relay RA6M5 · Công cụ firmware")
        self.resize(870, 550)
        font = self.font()
        font.setPointSize(10)
        self.setFont(font)
        self.setStyleSheet(
            "QPushButton { min-height: 27px; padding: 0 10px; }"
            "QLineEdit { min-height: 27px; padding: 0 6px; }"
        )

        self.process = QProcess(self)
        self.process.setWorkingDirectory(str(PROJECT_DIR))
        self.process.setProcessChannelMode(QProcess.MergedChannels)
        self.process.setStandardInputFile(QProcess.nullDevice())
        self.process.readyReadStandardOutput.connect(self.read_log)
        self.process.finished.connect(self.operation_finished)
        self.process.errorOccurred.connect(self.process_error)
        self.operation = ""
        self.decoder = getincrementaldecoder("utf-8")(errors="replace")

        layout = QVBoxLayout(self)
        layout.setContentsMargins(20, 18, 20, 16)
        layout.setSpacing(12)

        title = QLabel("Smart Relay RA6M5")
        title.setStyleSheet("font-size: 24px; font-weight: 600;")
        layout.addWidget(title)

        project = QLabel(str(PROJECT_DIR))
        project.setTextFormat(Qt.PlainText)
        project.setTextInteractionFlags(Qt.TextSelectableByMouse)
        project.setWordWrap(True)
        layout.addWidget(project)

        self.pio = QLineEdit(platformio_path())
        self.pio.setPlaceholderText("Đường dẫn tới pio hoặc pio.exe")
        self.browse = QPushButton("Chọn tệp…")
        self.browse.clicked.connect(self.choose_platformio)
        path_label = QLabel("PlatformIO")
        path_label.setBuddy(self.pio)
        path_row = QHBoxLayout()
        path_row.addWidget(path_label)
        path_row.addWidget(self.pio, 1)
        path_row.addWidget(self.browse)
        layout.addLayout(path_row)

        self.build = QPushButton("Build firmware")
        self.build.clicked.connect(lambda: self.start_operation("Build", ["run"]))
        self.upload = QPushButton("Nạp qua J-Link")
        self.upload.clicked.connect(lambda: self.start_operation("Nạp", ["run", "-t", "upload"]))
        self.open_build = QPushButton("Mở thư mục bản build")
        self.open_build.clicked.connect(self.open_build_directory)
        actions = QHBoxLayout()
        actions.addWidget(self.build)
        actions.addWidget(self.upload)
        actions.addStretch()
        actions.addWidget(self.open_build)
        layout.addLayout(actions)

        self.log = QPlainTextEdit()
        self.log.setReadOnly(True)
        self.log.setPlaceholderText("Log của PlatformIO và J-Link")
        self.log.setFont(QFontDatabase.systemFont(QFontDatabase.FixedFont))
        self.log.setLineWrapMode(QPlainTextEdit.NoWrap)
        self.log.setMaximumBlockCount(5000)
        self.log.setStyleSheet("background: #182334; color: #f0f4f8; padding: 8px;")
        layout.addWidget(self.log, 1)

        self.status = QLabel("Sẵn sàng")
        clear_log = QPushButton("Xóa log")
        clear_log.clicked.connect(self.log.clear)
        status_row = QHBoxLayout()
        status_row.addWidget(self.status, 1)
        status_row.addWidget(clear_log)
        layout.addLayout(status_row)
        self.set_busy(False)

    def choose_platformio(self):
        filename, _ = QFileDialog.getOpenFileName(self, "Chọn chương trình PlatformIO")
        if filename:
            self.pio.setText(filename)

    def set_busy(self, busy):
        for widget in (self.build, self.upload, self.pio, self.browse):
            widget.setEnabled(not busy)
        self.open_build.setEnabled((BUILD_DIR / "firmware.elf").is_file())

    def open_build_directory(self):
        if not QDesktopServices.openUrl(QUrl.fromLocalFile(str(BUILD_DIR))):
            self.status.setText("Không mở được thư mục bản build")

    def start_operation(self, operation, arguments):
        if self.process.state() != QProcess.NotRunning:
            return
        program = self.pio.text().strip().strip('"')
        if not program:
            self.status.setText("Chọn đường dẫn tới PlatformIO để tiếp tục")
            self.pio.setFocus()
            return

        environment = QProcessEnvironment.systemEnvironment()
        environment.insert("PYTHONUNBUFFERED", "1")
        environment.insert("PYTHONIOENCODING", "utf-8")
        # Use the cache prepared for this checkout if the shell has no override.
        cached_core = PROJECT_DIR.parent.parent / ".pio" / "pio-core"
        if not environment.contains("PLATFORMIO_CORE_DIR") and (cached_core / "platforms" / "renesas-ra").is_dir():
            environment.insert("PLATFORMIO_CORE_DIR", str(cached_core))
        self.process.setProcessEnvironment(environment)

        self.operation = operation
        self.decoder.reset()
        self.write_log(f'\n> "{program}" {" ".join(arguments)}\n')
        self.status.setText(f"Đang {operation.lower()}…")
        self.set_busy(True)
        self.process.start(program, arguments)

    def read_log(self, final=False):
        data = bytes(self.process.readAllStandardOutput())
        self.write_log(self.decoder.decode(data, final=final))

    def write_log(self, text):
        self.log.moveCursor(QTextCursor.End)
        self.log.insertPlainText(text.replace("\r\n", "\n").replace("\r", "\n"))

    def operation_finished(self, code, exit_status):
        self.read_log(final=True)
        if exit_status == QProcess.NormalExit and code == 0:
            message = f"{self.operation} thành công"
        else:
            message = f"{self.operation} thất bại (mã {code})"
        self.status.setText(message)
        self.write_log(f"\n{message}\n")
        self.set_busy(False)

    def process_error(self, error):
        self.write_log(f"\n{self.process.errorString()}\n")
        if error == QProcess.FailedToStart:
            self.status.setText("Không chạy được PlatformIO. Kiểm tra đường dẫn đã chọn.")
            self.set_busy(False)

    def closeEvent(self, event):
        if self.process.state() != QProcess.NotRunning:
            self.status.setText("Đợi tác vụ hoàn tất trước khi đóng cửa sổ")
            event.ignore()
            return
        super().closeEvent(event)


if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = HostWindow()
    window.show()
    sys.exit(app.exec_())
__SCRIPT_AI_RELAY_FILE__

cat > "$project_dir"/tools/jlink_upload.py <<'__SCRIPT_AI_RELAY_FILE__'
from pathlib import Path
import subprocess
import sys


if __name__ == "__main__":
    commander, device, speed, image = sys.argv[1:]
    elf = Path(image).resolve(strict=True)
    script = elf.with_suffix(".jlink")
    script.write_text(f'h\nloadfile "{elf.as_posix()}"\nr\ng\nq\n', encoding="utf-8")
    sys.exit(subprocess.call([
        commander, "-Device", device, "-If", "SWD", "-Speed", speed,
        "-AutoConnect", "1", "-NoGui", "1", "-ExitOnError", "1",
        "-CommandFile", str(script),
    ]))
__SCRIPT_AI_RELAY_FILE__

cat > "$project_dir"/tools/platformio_build.py <<'__SCRIPT_AI_RELAY_FILE__'
from hashlib import sha256
from os import name as os_name
from pathlib import Path
from shutil import copyfileobj
from tempfile import TemporaryDirectory
from time import sleep
from urllib.request import urlopen
from zipfile import ZipFile

Import("env")


def source_archive(directory, github_path, digest, required_file):
    source = cache / directory
    if (source / required_file).is_file():
        return source

    cache.mkdir(parents=True, exist_ok=True)
    url = "https://codeload.github.com/" + github_path
    archive = cache / (directory + ".zip")
    with TemporaryDirectory(dir=cache) as temp_dir:
        temporary = Path(temp_dir)
        if not archive.is_file():
            print(f"Downloading {directory}")
            download = temporary / "source.zip"
            with urlopen(url, timeout=60) as response, download.open("wb") as output:
                copyfileobj(response, output)
        else:
            download = archive

        if sha256(download.read_bytes()).hexdigest() != digest:
            raise RuntimeError(f"Invalid archive for {directory}. Expected {url} at {archive}.")
        with ZipFile(download) as package:
            package.extractall(temporary)
        # Windows can briefly lock files after extraction.
        for attempt in range(6):
            try:
                (temporary / directory).rename(source)
                break
            except OSError as error:
                if (source / required_file).is_file():
                    break
                if os_name != "nt" or not isinstance(error, PermissionError) or attempt == 5:
                    raise
                sleep(0.2 * (attempt + 1))
    return source


if env.IsCleanTarget():
    Return()

project = Path(env.subst("$PROJECT_DIR"))
cache = project / ".pio" / "reference"
fsp = source_archive(
    "fsp-6.6.0", "renesas/fsp/zip/refs/tags/v6.6.0",
    "976131ecfa738808576836893a9ad0e984ca0d4e6fbab038a3923a1e9b3576ad",
    "ra/fsp/src/r_spi/r_spi.c",
) / "ra" / "fsp"
cmsis = source_archive(
    "CMSIS_6-6.2.0", "ARM-software/CMSIS_6/zip/refs/tags/v6.2.0",
    "e8fd98b142365278cf0bdeb7889eb8b37a3d9890010236904466392d1542bec7",
    "CMSIS/Core/Include/core_cm33.h",
)
kernel = source_archive(
    "FreeRTOS-Kernel-11.1.0", "FreeRTOS/FreeRTOS-Kernel/zip/refs/tags/V11.1.0",
    "d5875acad2479817b35b2031dc1c7c22d100f45c7f3c9f6039cb217437a298a2",
    "portable/GCC/ARM_CM33_NTZ/non_secure/port.c",
)
port = kernel / "portable/GCC/ARM_CM33_NTZ/non_secure"

env.Append(
    CFLAGS=["-std=gnu11"],
    CPPPATH=[str(path) for path in (
        project / "src", project / "bsp/include",
        fsp / "inc", fsp / "inc/api", fsp / "inc/instances", fsp / "src",
        fsp / "src/bsp/mcu/ra6m5", cmsis / "CMSIS/Core/Include",
        kernel / "include", port,
    )],
    LINKFLAGS=["-nostartfiles", "--specs=nano.specs"],
)

env.BuildSources("$BUILD_DIR/bsp", str(project / "bsp"), "+<*.c>")
env.BuildSources("$BUILD_DIR/fsp", str(fsp / "src"), [
    "+<bsp/cmsis/Device/RENESAS/Source>",
    "+<bsp/mcu/all>", "+<r_spi>", "+<r_ioport>",
])
env.BuildSources("$BUILD_DIR/freertos", str(kernel), [
    "+<tasks.c>", "+<list.c>",
    "+<portable/GCC/ARM_CM33_NTZ/non_secure/port.c>",
    "+<portable/GCC/ARM_CM33_NTZ/non_secure/portasm.c>",
])

jlink = Path(env.PioPlatform().get_package_dir("tool-jlink"))
env.Replace(
    JLINK_COMMANDER=str(jlink / ("JLink.exe" if os_name == "nt" else "JLinkExe")),
    JLINK_DEVICE=env.BoardConfig().get("debug.jlink_device"),
    JLINK_SPEED=env.GetProjectOption("debug_speed"),
)
__SCRIPT_AI_RELAY_FILE__

cat > "$project_dir"/tools/requirements.txt <<'__SCRIPT_AI_RELAY_FILE__'
PyQt5==5.15.11
__SCRIPT_AI_RELAY_FILE__

printf 'Created %s\n' "$project_dir"
