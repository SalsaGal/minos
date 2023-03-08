const uefi = @import("std").os.uefi;

pub fn main() void {
    const con_out = uefi.system_table.con_out.?;

    _ = con_out.reset(false);
    _ = con_out.outputString(&[_:0]u16{ 'H', 'i' });

    _ = uefi.system_table.boot_services.?.stall(5_000_000);
}
