const uefi = @import("std").os.uefi;
const string = @import("string.zig");

pub fn main() void {
    const con_out = uefi.system_table.con_out.?;

    const text = string.Str16{ .chars = &[_:0]u16{ 'H', 'i' } };

    _ = con_out.reset(false);
    _ = con_out.outputString(text.chars);

    _ = uefi.system_table.boot_services.?.stall(5_000_000);
}
