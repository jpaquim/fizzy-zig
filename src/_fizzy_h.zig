pub const FizzySuccess: c_int = 0;
pub const FizzyErrorMalformedModule: c_int = 1;
pub const FizzyErrorInvalidModule: c_int = 2;
pub const FizzyErrorInstantiationFailed: c_int = 3;
pub const FizzyErrorMemoryAllocationFailed: c_int = 4;
pub const FizzyErrorOther: c_int = 5;
pub const enum_FizzyErrorCode = c_uint;
pub const FizzyErrorCode = enum_FizzyErrorCode;
pub const FizzyMemoryPagesLimitDefault: c_int = 4096;
const enum_unnamed_1 = c_uint;
pub const struct_FizzyError = extern struct {
    code: FizzyErrorCode,
    message: [256]u8,
};
pub const FizzyError = struct_FizzyError;
pub const struct_FizzyModule = opaque {};
pub const FizzyModule = struct_FizzyModule;
pub const struct_FizzyInstance = opaque {};
pub const FizzyInstance = struct_FizzyInstance;
pub const union_FizzyValue = extern union {
    i32: u32,
    i64: u64,
    f32: f32,
    f64: f64,
};
pub const FizzyValue = union_FizzyValue;
pub const struct_FizzyExecutionResult = extern struct {
    trapped: bool,
    has_value: bool,
    value: FizzyValue,
};
pub const FizzyExecutionResult = struct_FizzyExecutionResult;
pub const struct_FizzyExecutionContext = opaque {};
pub const FizzyExecutionContext = struct_FizzyExecutionContext;
pub const FizzyExternalFn = ?fn (?*anyopaque, ?*FizzyInstance, [*c]const FizzyValue, ?*FizzyExecutionContext) callconv(.C) FizzyExecutionResult;
pub const FizzyValueType = u8;
pub const FizzyValueTypeI32: FizzyValueType = 127;
pub const FizzyValueTypeI64: FizzyValueType = 126;
pub const FizzyValueTypeF32: FizzyValueType = 125;
pub const FizzyValueTypeF64: FizzyValueType = 124;
pub const FizzyValueTypeVoid: FizzyValueType = 0;
pub const struct_FizzyFunctionType = extern struct {
    output: FizzyValueType,
    inputs: [*c]const FizzyValueType,
    inputs_size: usize,
};
pub const FizzyFunctionType = struct_FizzyFunctionType;
pub const struct_FizzyExternalFunction = extern struct {
    type: FizzyFunctionType,
    function: FizzyExternalFn,
    context: ?*anyopaque,
};
pub const FizzyExternalFunction = struct_FizzyExternalFunction;
pub const struct_FizzyGlobalType = extern struct {
    value_type: FizzyValueType,
    is_mutable: bool,
};
pub const FizzyGlobalType = struct_FizzyGlobalType;
pub const struct_FizzyTable = opaque {};
pub const FizzyTable = struct_FizzyTable;
pub const struct_FizzyLimits = extern struct {
    min: u32,
    max: u32,
    has_max: bool,
};
pub const FizzyLimits = struct_FizzyLimits;
pub const struct_FizzyExternalTable = extern struct {
    table: ?*FizzyTable,
    limits: FizzyLimits,
};
pub const FizzyExternalTable = struct_FizzyExternalTable;
pub const struct_FizzyMemory = opaque {};
pub const FizzyMemory = struct_FizzyMemory;
pub const struct_FizzyExternalMemory = extern struct {
    memory: ?*FizzyMemory,
    limits: FizzyLimits,
};
pub const FizzyExternalMemory = struct_FizzyExternalMemory;
pub const struct_FizzyExternalGlobal = extern struct {
    value: [*c]FizzyValue,
    type: FizzyGlobalType,
};
pub const FizzyExternalGlobal = struct_FizzyExternalGlobal;
pub const FizzyExternalKindFunction: c_int = 0;
pub const FizzyExternalKindTable: c_int = 1;
pub const FizzyExternalKindMemory: c_int = 2;
pub const FizzyExternalKindGlobal: c_int = 3;
pub const enum_FizzyExternalKind = c_uint;
pub const FizzyExternalKind = enum_FizzyExternalKind;
const union_unnamed_2 = extern union {
    function_type: FizzyFunctionType,
    memory_limits: FizzyLimits,
    table_limits: FizzyLimits,
    global_type: FizzyGlobalType,
};
pub const struct_FizzyImportDescription = extern struct {
    module: [*c]const u8,
    name: [*c]const u8,
    kind: FizzyExternalKind,
    desc: union_unnamed_2,
};
pub const FizzyImportDescription = struct_FizzyImportDescription;
pub const struct_FizzyExportDescription = extern struct {
    name: [*c]const u8,
    kind: FizzyExternalKind,
    index: u32,
};
pub const FizzyExportDescription = struct_FizzyExportDescription;
pub const struct_FizzyImportedFunction = extern struct {
    module: [*c]const u8,
    name: [*c]const u8,
    external_function: FizzyExternalFunction,
};
pub const FizzyImportedFunction = struct_FizzyImportedFunction;
pub const struct_FizzyImportedGlobal = extern struct {
    module: [*c]const u8,
    name: [*c]const u8,
    external_global: FizzyExternalGlobal,
};
pub const FizzyImportedGlobal = struct_FizzyImportedGlobal;
pub extern fn fizzy_validate(wasm_binary: [*c]const u8, wasm_binary_size: usize, @"error": [*c]FizzyError) bool;
pub extern fn fizzy_parse(wasm_binary: [*c]const u8, wasm_binary_size: usize, @"error": [*c]FizzyError) ?*const FizzyModule;
pub extern fn fizzy_free_module(module: ?*const FizzyModule) void;
pub extern fn fizzy_clone_module(module: ?*const FizzyModule) ?*const FizzyModule;
pub extern fn fizzy_get_type_count(module: ?*const FizzyModule) u32;
pub extern fn fizzy_get_type(module: ?*const FizzyModule, type_idx: u32) FizzyFunctionType;
pub extern fn fizzy_get_import_count(module: ?*const FizzyModule) u32;
pub extern fn fizzy_get_import_description(module: ?*const FizzyModule, import_idx: u32) FizzyImportDescription;
pub extern fn fizzy_get_function_type(module: ?*const FizzyModule, func_idx: u32) FizzyFunctionType;
pub extern fn fizzy_module_has_table(module: ?*const FizzyModule) bool;
pub extern fn fizzy_module_has_memory(module: ?*const FizzyModule) bool;
pub extern fn fizzy_get_global_count(module: ?*const FizzyModule) u32;
pub extern fn fizzy_get_global_type(module: ?*const FizzyModule, global_idx: u32) FizzyGlobalType;
pub extern fn fizzy_get_export_count(module: ?*const FizzyModule) u32;
pub extern fn fizzy_get_export_description(module: ?*const FizzyModule, export_idx: u32) FizzyExportDescription;
pub extern fn fizzy_find_exported_function_index(module: ?*const FizzyModule, name: [*c]const u8, out_func_idx: [*c]u32) bool;
pub extern fn fizzy_module_has_start_function(module: ?*const FizzyModule) bool;
pub extern fn fizzy_instantiate(module: ?*const FizzyModule, imported_functions: [*c]const FizzyExternalFunction, imported_functions_size: usize, imported_table: [*c]const FizzyExternalTable, imported_memory: [*c]const FizzyExternalMemory, imported_globals: [*c]const FizzyExternalGlobal, imported_globals_size: usize, memory_pages_limit: u32, @"error": [*c]FizzyError) ?*FizzyInstance;
pub extern fn fizzy_resolve_instantiate(module: ?*const FizzyModule, imported_functions: [*c]const FizzyImportedFunction, imported_functions_size: usize, imported_table: [*c]const FizzyExternalTable, imported_memory: [*c]const FizzyExternalMemory, imported_globals: [*c]const FizzyImportedGlobal, imported_globals_size: usize, memory_pages_limit: u32, @"error": [*c]FizzyError) ?*FizzyInstance;
pub extern fn fizzy_free_instance(instance: ?*FizzyInstance) void;
pub extern fn fizzy_get_instance_module(instance: ?*FizzyInstance) ?*const FizzyModule;
pub extern fn fizzy_get_instance_memory_data(instance: ?*FizzyInstance) [*c]u8;
pub extern fn fizzy_get_instance_memory_size(instance: ?*FizzyInstance) usize;
pub extern fn fizzy_find_exported_function(instance: ?*FizzyInstance, name: [*c]const u8, out_function: [*c]FizzyExternalFunction) bool;
pub extern fn fizzy_free_exported_function(external_function: [*c]FizzyExternalFunction) void;
pub extern fn fizzy_find_exported_table(instance: ?*FizzyInstance, name: [*c]const u8, out_table: [*c]FizzyExternalTable) bool;
pub extern fn fizzy_find_exported_memory(instance: ?*FizzyInstance, name: [*c]const u8, out_memory: [*c]FizzyExternalMemory) bool;
pub extern fn fizzy_find_exported_global(instance: ?*FizzyInstance, name: [*c]const u8, out_global: [*c]FizzyExternalGlobal) bool;
pub extern fn fizzy_create_execution_context(depth: c_int) ?*FizzyExecutionContext;
pub extern fn fizzy_create_metered_execution_context(depth: c_int, ticks: i64) ?*FizzyExecutionContext;
pub extern fn fizzy_free_execution_context(ctx: ?*FizzyExecutionContext) void;
pub extern fn fizzy_get_execution_context_depth(ctx: ?*FizzyExecutionContext) [*c]c_int;
pub extern fn fizzy_get_execution_context_ticks(ctx: ?*FizzyExecutionContext) [*c]i64;
pub extern fn fizzy_execute(instance: ?*FizzyInstance, func_idx: u32, args: [*c]const FizzyValue, ctx: ?*FizzyExecutionContext) FizzyExecutionResult;
pub const FIZZY_NOEXCEPT = "";
