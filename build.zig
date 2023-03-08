const std = @import("std");
const Target = std.Target;
const CrossTarget = std.zig.CrossTarget;

pub fn build(b: *std.build.Builder) void {
    const bootx64 = b.addExecutable("bootx64", "src/boot.zig");
    bootx64.setBuildMode(b.standardReleaseOptions());
    bootx64.setTarget(CrossTarget{
        .cpu_arch = Target.Cpu.Arch.x86_64,
        .os_tag = Target.Os.Tag.uefi,
        .abi = Target.Abi.msvc,
    });
    bootx64.setOutputDir("esp/efi/boot");
    b.default_step.dependOn(&bootx64.step);
}
