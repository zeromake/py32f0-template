add_rules("mode.debug", "mode.release")

set_languages("c17")
set_plat("cross")
set_arch("arm")

add_repositories("zero https://github.com/zeromake/xrepo.git")
add_requires("arm-toolchain")
set_toolchains("arm-toolchain@arm-toolchain")

toolchain("arm-toolchain")
    set_kind("cross")
    set_formats("binary", "%$%(name%).elf")
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
    on_load(function (toolchain)
        toolchain:load_cross_toolchain()
    end)
toolchain_end()

target("main")
    set_kind("binary")
    add_files("User/*.c")
    add_defines("PY32F003x4")
    add_files("Libraries/PY32F0xx_HAL_Driver/Src/*.c")
    add_files("Libraries/PY32F0xx_HAL_BSP/Src/*.c")
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
