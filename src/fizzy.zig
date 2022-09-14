const c = @cImport({
    @cInclude("fizzy/fizzy.h");
});

pub const Error = c.FizzyError;
pub const ExecutionResult = c.FizzyExecutionResult;
pub const ExternalFunction = c.FizzyExternalFunction;
pub const ExternalGlobal = c.FizzyExternalGlobal;
pub const ExternalTable = c.FizzyExternalTable;
pub const ExternalMemory = c.FizzyExternalMemory;
pub const FunctionType = c.FizzyFunctionType;
pub const Value = c.FizzyValue;

pub fn parse(wasm_binary: []const u8) ?*const Module {
    return @ptrCast(?*const Module, c.fizzy_parse(wasm_binary.ptr, wasm_binary.len, null));
}

pub const Module = opaque {
    pub fn deinit(self: *Module) void {
        c.fizzy_free_module(self);
    }

    pub fn clone(self: *const Module) ?*const Module {
        return c.fizzy_clone_module(self);
    }

    pub fn getTypeCount(self: *const Module) u32 {
        return c.fizzy_get_type_count(self);
    }

    pub fn getType(self: *const Module, type_idx: u32) FunctionType {
        return c.fizzy_get_type(self, type_idx);
    }

    pub fn getImportCount(self: *const Module) u32 {
        return c.fizzy_get_import_count(self);
    }

    // pub fn get_import_description(module: ?*const Module, import_idx: u32) FizzyImportDescription;
    // pub fn get_function_type(module: ?*const Module, func_idx: u32) FizzyFunctionType;
    // pub fn module_has_table(module: ?*const Module) bool;
    // pub fn module_has_memory(module: ?*const Module) bool;
    // pub fn get_global_count(module: ?*const Module) u32;
    // pub fn get_global_type(module: ?*const Module, global_idx: u32) FizzyGlobalType;
    // pub fn get_export_count(module: ?*const Module) u32;
    // pub fn get_export_description(module: ?*const Module, export_idx: u32) FizzyExportDescription;
    pub fn findExportedFunctionIndex(self: *const Module, name: []const u8) ?u32 {
        var out_func_idx: u32 = undefined;
        if (c.fizzy_find_exported_function_index(@ptrCast(*const c.FizzyModule, self), name.ptr, &out_func_idx))
            return out_func_idx;
        return null;
    }
    // pub fn module_has_start_function(module: ?*const Module) bool;
    // pub fn instantiate(module: ?*const Module, imported_functions: [*c]const FizzyExternalFunction, imported_functions_size: usize, imported_table: [*c]const FizzyExternalTable, imported_memory: [*c]const FizzyExternalMemory, imported_globals: [*c]const FizzyExternalGlobal, imported_globals_size: usize, memory_pages_limit: u32, @"error": [*c]FizzyError) ?*FizzyInstance;
    // pub fn resolve_instantiate(module: ?*const Module, imported_functions: [*c]const FizzyImportedFunction, imported_functions_size: usize, imported_table: [*c]const FizzyExternalTable, imported_memory: [*c]const FizzyExternalMemory, imported_globals: [*c]const FizzyImportedGlobal, imported_globals_size: usize, memory_pages_limit: u32, @"error": [*c]FizzyError) ?*FizzyInstance;
};

pub const Instance = opaque {
    pub fn deinit(self: *Instance) void {
        c.fizzy_free_instance(@ptrCast(*c.FizzyInstance, self));
    }
};

pub fn instantiate(
    module: *const Module,
    imported_functions: ?[]const ExternalFunction,
    imported_table: ?[]const ExternalTable,
    imported_memory: ?[]const ExternalMemory,
    imported_globals: ?[]const ExternalGlobal,
    memory_pages_limit: ?u32,
    err: ?*Error,
) ?*Instance {
    return @ptrCast(*Instance, c.fizzy_instantiate(
        @ptrCast(*const c.FizzyModule, module),
        if (imported_functions) |i| i.ptr else null,
        if (imported_functions) |i| i.len else 0,
        if (imported_table) |t| t.ptr else null,
        if (imported_memory) |m| m.ptr else null,
        if (imported_globals) |i| i.ptr else null,
        if (imported_globals) |g| g.len else 0,
        memory_pages_limit orelse c.FizzyMemoryPagesLimitDefault,
        err,
    ));
}

pub const ExecutionContext = opaque {
    pub fn deinit(self: *ExecutionContext) void {
        c.fizzy_free_execution_context(@ptrCast(*c.FizzyExecutionContext, self));
    }
};

pub fn createExecutionContext(depth: c_int) ?*ExecutionContext {
    return @ptrCast(?*ExecutionContext, c.fizzy_create_execution_context(depth));
}

pub fn execute(instance: *Instance, func_idx: u32, args: ?[]const Value, ctx: ?*ExecutionContext) ExecutionResult {
    return c.fizzy_execute(
        @ptrCast(*c.FizzyInstance, instance),
        func_idx,
        if (args) |a| a.ptr else null,
        @ptrCast(?*c.FizzyExecutionContext, ctx),
    );
}
