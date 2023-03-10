const std = @import("std");
const uefi = std.os.uefi;
const boot = @import("boot.zig");

pub var graphics: *uefi.protocols.GraphicsOutputProtocol = undefined;

pub var frame_buffer: [*]u8 = undefined;
pub var frame_width: u32 = undefined;
pub var frame_height: u32 = undefined;

pub fn init(boot_services: *uefi.tables.BootServices) uefi.Status {
    if (boot_services.locateProtocol(&uefi.protocols.GraphicsOutputProtocol.guid, null, @ptrCast(*?*anyopaque, &graphics)) != uefi.Status.Success) {}
    frame_buffer = @intToPtr([*]u8, graphics.mode.frame_buffer_base);
    frame_width = graphics.mode.info.horizontal_resolution;
    frame_height = graphics.mode.info.vertical_resolution;
    return uefi.Status.Success;
}
