const std = @import("std");

const fizzy = @cImport({
    @cInclude("fizzy/fizzy.h");
});

pub fn main() !void {
    const wasm_binary = @embedFile("test.wasm");
    if (executeMain(i32, wasm_binary, wasm_binary.len)) |result|
        std.debug.print("success, result: {}", .{result})
    else |err|
        std.debug.print("error {}", .{err});
}

fn executeMain(comptime T: type, wasm_binary: []const u8, wasm_binary_size: usize) !?T {
    // Parse and validate binary module.
    const module = fizzy.fizzy_parse(wasm_binary.ptr, wasm_binary_size, null);

    // Find main function.
    var main_fn_index: u32 = undefined;
    if (!fizzy.fizzy_find_exported_function_index(module, "main", &main_fn_index))
        return error.FunctionNotExported;

    // Instantiate module without imports.
    const instance_opt = fizzy.fizzy_instantiate(module, null, 0, null, null, null, 0, fizzy.FizzyMemoryPagesLimitDefault, null);
    if (instance_opt == null)
        return error.InstantiateFailed;
    const instance = instance_opt.?;
    defer fizzy.fizzy_free_instance(instance);

    const ctx_opt = fizzy.fizzy_create_execution_context(0);
    if (ctx_opt == null)
        return error.CreateExecutionContextFailed;
    const ctx = ctx_opt.?;
    defer fizzy.fizzy_free_execution_context(ctx);

    // Execute main function with single argument
    var args: [1]fizzy.FizzyValue = undefined;
    args[0] = fizzy.FizzyValue{ .i32 = 1 };
    const result = fizzy.fizzy_execute(instance, main_fn_index, &args, ctx);
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
