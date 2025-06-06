add_rules("mode.debug", "mode.release")

set_languages("c17")
set_plat("cross")
set_arch("arm")

add_requires("arm-toolchain")

toolchain("arm-toolchain")
    local prefix = "arm-none-eabi-"
    set_kind("standalone")
    set_formats("object", "$(name).o")
    set_formats("binary", "$(name).elf")
    set_formats("static", "$(name).lib")
    set_formats("shared", "lib$(name).so")
    set_formats("symbol", "$(name).sym")
    set_toolset("cc", prefix .. "gcc")
    set_toolset("cxx", prefix .. "gcc", prefix .. "g++")
    set_toolset("ld", prefix .. "g++", prefix .. "gcc")
    set_toolset("sh", prefix .. "g++", prefix .. "gcc")
    set_toolset("ar", prefix.."ar")
    set_toolset("ex", prefix.."ar")
    set_toolset("strip", prefix.."strip")
    set_toolset("as", prefix .. "gcc")
    add_cxflags(
        "-mcpu=cortex-m0plus",
        "-gdwarf-3",
        "-Wall",
        "-ffunction-sections",
        "-fdata-sections",
        {force = true}
    )
    add_asflags(
        "-mcpu=cortex-m0plus",
        "-gdwarf-3",
        "-Wa,--warn",
        {force = true}
    )
    add_ldflags(
        "-mcpu=cortex-m0plus",
        "-specs=nano.specs",
        "-specs=nosys.specs",
        "-Wl,--gc-sections",
        "-Wl,--print-memory-usage",
        "-Wl,--no-warn-rwx-segments",
        {force = true}
    )
    set_archs("arm", "arm64")
    add_syslinks("c", "m")
    on_check(function (toolchain)
        return import("lib.detect.find_tool")(prefix.."gcc")
    end)
toolchain_end()


target("main")
    set_kind("binary")
    add_files("User/*.c")
    add_defines("PY32F003x4")
    add_files("Libraries/PY32F0xx_HAL_Driver/Src/*.c")
    add_files("Libraries/PY32F0xx_HAL_BSP/Src/*.c")
    add_packages("arm-toolchain")
    set_toolchains("@arm-toolchain")
    add_files(
        "Libraries/CMSIS/Device/PY32F0xx/Source/system_py32f0xx.c",
        "Libraries/CMSIS/Device/PY32F0xx/Source/gcc/startup_py32f003.s"
    )
    add_includedirs(
        "User",
        "Libraries/CMSIS/Core/Include",
        "Libraries/CMSIS/Device/PY32F0xx/Include",
        "Libraries/PY32F0xx_HAL_Driver/Inc",
        "Libraries/PY32F0xx_HAL_BSP/Inc"
    )
    add_ldflags("-T./Libraries/LDScripts/py32f003x4.ld", {force = true})
