const std = @import("std");
const uefi = std.os.uefi;

var con_out: *uefi.protocols.SimpleTextOutputProtocol = undefined;

pub fn main() void {
    const boot_services = uefi.system_table.boot_services.?;

    con_out = uefi.system_table.con_out.?;
    _ = con_out.reset(false);

    print("foo\r\n");
    print("Bar");

    _ = boot_services.stall(5_000_000);
}

fn print(str: []const u8) void {
    for (str) |char| {
        _ = con_out.outputString(&[_:0]u16{char});
    }
}
