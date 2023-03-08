const boot = @import("boot.zig");

pub const Str16 = struct {
    chars: [:0]const u16,
};

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
