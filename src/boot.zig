const std = @import("std");
const uefi = std.os.uefi;
const string = @import("string.zig");

pub var con_out: *uefi.protocols.SimpleTextOutputProtocol = undefined;

pub fn main() void {
    con_out = uefi.system_table.con_out.?;
    const boot_services = uefi.system_table.boot_services.?;
    _ = con_out.reset(false);

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

    _ = uefi.system_table.boot_services.?.stall(5_000_000);
}
