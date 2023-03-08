const uefi = @import("std").os.uefi;
const string = @import("string.zig");

pub var con_out: *uefi.protocols.SimpleTextOutputProtocol = undefined;

pub fn main() void {
    con_out = uefi.system_table.con_out.?;
    _ = con_out.reset(false);

    string.print("Foo");

    _ = uefi.system_table.boot_services.?.stall(5_000_000);
}
