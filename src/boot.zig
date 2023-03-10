const std = @import("std");
const uefi = std.os.uefi;

var con_out: *uefi.protocols.SimpleTextOutputProtocol = undefined;
var graphics: *uefi.protocols.GraphicsOutputProtocol = undefined;
var frame_buffer: [*]u8 = undefined;
var buffer: [0xff]u8 = undefined;

pub fn main() void {
    const boot_services = uefi.system_table.boot_services.?;

    con_out = uefi.system_table.con_out.?;
    _ = con_out.reset(false);
    print("MinOS Started\r\n");

    if (boot_services.locateProtocol(&uefi.protocols.GraphicsOutputProtocol.guid, null, @ptrCast(*?*anyopaque, &graphics)) != uefi.Status.Success) {
        print("Failed to start graphics");
        _ = boot_services.stall(5_000_000);
        return;
    }
    const frame_width = graphics.mode.info.horizontal_resolution;
    const frame_height = graphics.mode.info.vertical_resolution;
    frame_buffer = @intToPtr([*]u8, graphics.mode.frame_buffer_base);

    printf(&buffer, "Frame: {d},{d}\r\n", .{ frame_width, frame_height });

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

    if (boot_services.exitBootServices(uefi.handle, memory_map_key) != uefi.Status.Success) {
        print("Failed to exit boot services\r\n");
        _ = boot_services.stall(5_000_000);
        return;
    }

    while (true) {}
}

fn printf(buf: []u8, comptime format: []const u8, args: anytype) void {
    print(std.fmt.bufPrint(buf, format, args) catch unreachable);
}

fn print(str: []const u8) void {
    for (str) |char| {
        _ = con_out.outputString(&[_:0]u16{char});
    }
}
