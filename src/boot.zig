const std = @import("std");
const uefi = std.os.uefi;

var con_out: *uefi.protocols.SimpleTextOutputProtocol = undefined;

pub fn main() void {
    const boot_services = uefi.system_table.boot_services.?;

    con_out = uefi.system_table.con_out.?;
    _ = con_out.reset(false);
    print("MinOS Started\r\n");

    var memory_map: [*]uefi.tables.MemoryDescriptor = undefined;
    var memory_map_size: usize = 0;
    var memory_map_key: usize = undefined;
    var descriptor_size: usize = undefined;
    var descriptor_version: u32 = undefined;
    while (uefi.Status.BufferTooSmall == boot_services.getMemoryMap(&memory_map_size, memory_map, &memory_map_key, &descriptor_size, &descriptor_version)) {
        if (uefi.Status.Success != boot_services.allocatePool(uefi.tables.MemoryType.BootServicesData, memory_map_size, @ptrCast(*[*]align(8) u8, &memory_map))) {
            return;
        }
    }
    _ = boot_services.stall(5_000_000);
}

fn print(str: []const u8) void {
    for (str) |char| {
        _ = con_out.outputString(&[_:0]u16{char});
    }
}
