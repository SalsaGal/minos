const std = @import("std");
const uefi = std.os.uefi;
const boot = @import("boot.zig");

pub var graphics: *uefi.protocols.GraphicsOutputProtocol = undefined;

pub var frame_buffer: [*]u8 = undefined;
pub var frame_size: Vec2(u32) = undefined;

pub fn Vec2(comptime T: type) type {
    return struct {
        const Self = @This();

        x: T,
        y: T,

        pub fn display(self: *Self, buf: []u8) []const u8 {
            return std.fmt.bufPrint(buf, "({d},{d})", .{ self.x, self.y }) catch unreachable;
        }
    };
}

pub fn init(boot_services: *uefi.tables.BootServices) uefi.Status {
    if (boot_services.locateProtocol(&uefi.protocols.GraphicsOutputProtocol.guid, null, @ptrCast(*?*anyopaque, &graphics)) != uefi.Status.Success) {}
    frame_buffer = @intToPtr([*]u8, graphics.mode.frame_buffer_base);
    frame_size.x = graphics.mode.info.horizontal_resolution;
    frame_size.y = graphics.mode.info.vertical_resolution;
    return uefi.Status.Success;
}
