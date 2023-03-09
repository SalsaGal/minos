const std = @import("std");
const uefi = std.os.uefi;
const string = @import("string.zig");

pub var con_out: *uefi.protocols.SimpleTextOutputProtocol = undefined;

pub fn main() void {
    con_out = uefi.system_table.con_out.?;
    const boot_services = uefi.system_table.boot_services.?;
    _ = con_out.reset(false);

    string.println("MinOS starting");

    // Load memory map
    var memory_map: [*]uefi.tables.MemoryDescriptor = undefined;
    var memory_map_size: usize = 0;
    var memory_map_key: usize = undefined;
    var descriptor_size: usize = undefined;
    var descriptor_version: u32 = undefined;
    // Fetch the memory map.
    // Careful! Every call to boot services can alter the memory map.
    while (uefi.Status.BufferTooSmall == boot_services.getMemoryMap(&memory_map_size, memory_map, &memory_map_key, &descriptor_size, &descriptor_version)) {
        const allocate_status = boot_services.allocatePool(uefi.tables.MemoryType.BootServicesData, memory_map_size, @ptrCast(*[*]align(8) u8, &memory_map));
        if (uefi.Status.Success != allocate_status) {
            return;
        }
    }

    var buf: [0xffff]u8 = undefined;
    var i: usize = 0;
    string.printf(buf[0..], "Memory Descriptors: {d}\r\n", .{memory_map_size / descriptor_size});
    while (i < memory_map_size / descriptor_size) : (i += 1) {}

    _ = uefi.system_table.boot_services.?.stall(5_000_000);
}
