const boot = @import("boot.zig");
const fmt = @import("std").fmt;

pub const Str16 = struct {
    chars: [:0]const u16,
};

pub fn printf(str: []u8, comptime format: []const u8, args: var) void {
    print(fmt.bufPrint(buf, format, args) catch unreachable);
}

pub fn print(str: [:0]const u8) void {
    for (str) |c| {
        _ = boot.con_out.outputString(&[_:0]u16{c});
    }
}

pub fn println(str: [:0]const u8) void {
    for (str) |c| {
        _ = boot.con_out.outputString(&[_:0]u16{c});
    }
    print("\r\n");
}
