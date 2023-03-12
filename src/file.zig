const std = @import("std");
const uefi = std.os.uefi;

pub var files: *uefi.protocols.FileProtocol = undefined;

pub fn init(boot_services: *uefi.tables.BootServices) uefi.Status {
    const status = boot_services.locateProtocol(&uefi.protocols.SimpleFileSystemProtocol.guid, null, @ptrCast(*?*anyopaque, &files));
    return status;
}
