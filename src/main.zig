const std = @import("std");
const fizzy = @import("./fizzy.zig");

pub fn main() !void {
    const wasm_binary = @embedFile("test.wasm");
    if (executeMain(i32, wasm_binary)) |result|
        std.debug.print("success, result: {}\n", .{result})
    else |err|
        std.debug.print("error {}\n", .{err});
}

fn executeMain(comptime T: type, wasm_binary: []const u8) !?T {
    // Parse and validate binary module.
    const module = fizzy.parse(wasm_binary) orelse return error.InvalidWasmBinary;
    // defer module.deinit();

    // Find main function.
    const main_fn_index = module.findExportedFunctionIndex("main") orelse return error.FunctionNotExported;

    // Instantiate module without imports.
    const instance = fizzy.instantiate(module, null, null, null, null, null, null) orelse return error.InstantiateFailed;
    defer instance.deinit();

    const ctx = fizzy.createExecutionContext(0) orelse return error.CreateExecutionContextFailed;
    defer ctx.deinit();

    // Execute main function with single argument
    const args: [1]fizzy.Value = .{ .{ .i32 = 1} };
    const result = fizzy.execute(instance, main_fn_index, args[0..1], ctx);
    if (result.trapped)
        return error.ExecutionTrapped;
    if (result.has_value) {
        switch (T) {
            i32 => return @intCast(i32, result.value.i32),
            i64 => return result.value.i64,
            f32 => return result.value.f32,
            f64 => return result.value.f64,
            else => @compileError("unsupported result type: " ++ T),
        }
        if (T == i32)
            return result.value.i32;
        return result.value.i32;
    }
    return null;
}
