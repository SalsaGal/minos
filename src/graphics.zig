const std = @import("std");
const uefi = std.os.uefi;
const boot = @import("boot.zig");

pub var graphics: *uefi.protocols.GraphicsOutputProtocol = undefined;

pub var frame_buffer: [*]u8 = undefined;
pub var frame_size: Vec2(u32) = undefined;

pub const Color = struct {
    r: u8 = 0,
    b: u8 = 0,
    g: u8 = 0,
    a: u8 = 255,

    pub const BLACK = Color{};
    pub const WHITE = Color{ .r = 255, .g = 255, .b = 255 };
    pub const RED = Color{ .r = 255 };
    pub const GREEN = Color{ .g = 255 };
    pub const BLUE = Color{ .b = 255 };
};

pub fn Vec2(comptime T: type) type {
    return struct {
        const Self = @This();

        x: T,
        y: T,

        pub fn display(self: *const Self, buf: []u8) []const u8 {
            return std.fmt.bufPrint(buf, "({d},{d})", .{ self.x, self.y }) catch unreachable;
        }

        pub fn index(self: *const Self) u32 {
            return 4 * (self.x % frame_size.x + self.y / frame_size.y);
        }
    };
}

pub fn setPixel(index: usize, color: Color) void {
    frame_buffer[index] = color.b;
    frame_buffer[index + 1] = color.g;
    frame_buffer[index + 2] = color.r;
    frame_buffer[index + 3] = color.a;
}

pub fn clear(color: Color) void {
    var i: usize = 0;
    while (i < frame_size.x * frame_size.y * 4) : (i += 4) {
        setPixel(i, color);
    }
}

pub fn init(boot_services: *uefi.tables.BootServices) uefi.Status {
    const status = boot_services.locateProtocol(&uefi.protocols.GraphicsOutputProtocol.guid, null, @ptrCast(*?*anyopaque, &graphics));
    if (status == uefi.Status.Success) {
        frame_buffer = @intToPtr([*]u8, graphics.mode.frame_buffer_base);
        frame_size.x = graphics.mode.info.horizontal_resolution;
        frame_size.y = graphics.mode.info.vertical_resolution;
    }
    return status;
}
