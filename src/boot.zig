const uefi = @import("std").os.uefi;
const string = @import("string.zig");

var con_out: *uefi.protocols.SimpleTextOutputProtocol = undefined;
var memory_buffer: [0xffff]u8 = undefined;

pub fn main() void {
    con_out = uefi.system_table.con_out.?;

    const text = string.Str16{ .chars = &[_:0]u16{ 'H', 'i' } };

    _ = con_out.reset(false);
    _ = con_out.outputString(text.chars);

    _ = uefi.system_table.boot_services.?.stall(5_000_000);
}
