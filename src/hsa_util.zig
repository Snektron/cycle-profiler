const std = @import("std");
const Allocator = std.mem.Allocator;

const c = @import("c.zig");

pub const Error = error{
    Generic,
    InvalidArgument,
    InvalidQueueCreation,
    InvalidAllocation,
    InvalidAgent,
    InvalidRegion,
    InvalidSignal,
    InvalidQueue,
    OutOfResources,
    InvalidPacketFormat,
    ResourceFree,
    NotInitialized,
    RefcountOverflow,
    IncompatibleArguments,
    InvalidIndex,
    InvalidIsa,
    InvalidIsaName,
    InvalidCodeObject,
    InvalidExecutable,
    FrozenExecutable,
    InvalidSymbolName,
    VariableAlreadyDefined,
    VariableUndefined,
    Exception,
    InvalidCodeSymbol,
    InvalidExecutableSymbol,
    InvalidFile,
    InvalidCodeObjectReader,
    InvalidCache,
    InvalidWavefront,
    InvalidSignalGroup,
    InvalidRuntimeState,
    Fatal,
};

/// Convert a HSA error to a Zig error.
pub fn check(status: c.hsa_status_t) Error!void {
    return switch (status) {
        c.HSA_STATUS_SUCCESS => {},
        c.HSA_STATUS_ERROR => error.Generic,
        c.HSA_STATUS_ERROR_INVALID_ARGUMENT => error.InvalidArgument,
        c.HSA_STATUS_ERROR_INVALID_QUEUE_CREATION => error.InvalidQueueCreation,
        c.HSA_STATUS_ERROR_INVALID_ALLOCATION => error.InvalidAllocation,
        c.HSA_STATUS_ERROR_INVALID_AGENT => error.InvalidAgent,
        c.HSA_STATUS_ERROR_INVALID_REGION => error.InvalidRegion,
        c.HSA_STATUS_ERROR_INVALID_SIGNAL => error.InvalidSignal,
        c.HSA_STATUS_ERROR_INVALID_QUEUE => error.InvalidQueue,
        c.HSA_STATUS_ERROR_OUT_OF_RESOURCES => error.OutOfResources,
        c.HSA_STATUS_ERROR_INVALID_PACKET_FORMAT => error.InvalidPacketFormat,
        c.HSA_STATUS_ERROR_RESOURCE_FREE => error.ResourceFree,
        c.HSA_STATUS_ERROR_NOT_INITIALIZED => error.NotInitialized,
        c.HSA_STATUS_ERROR_REFCOUNT_OVERFLOW => error.RefcountOverflow,
        c.HSA_STATUS_ERROR_INCOMPATIBLE_ARGUMENTS => error.IncompatibleArguments,
        c.HSA_STATUS_ERROR_INVALID_INDEX => error.InvalidIndex,
        c.HSA_STATUS_ERROR_INVALID_ISA => error.InvalidIsa,
        c.HSA_STATUS_ERROR_INVALID_ISA_NAME => error.InvalidIsaName,
        c.HSA_STATUS_ERROR_INVALID_CODE_OBJECT => error.InvalidCodeObject,
        c.HSA_STATUS_ERROR_INVALID_EXECUTABLE => error.InvalidExecutable,
        c.HSA_STATUS_ERROR_FROZEN_EXECUTABLE => error.FrozenExecutable,
        c.HSA_STATUS_ERROR_INVALID_SYMBOL_NAME => error.InvalidSymbolName,
        c.HSA_STATUS_ERROR_VARIABLE_ALREADY_DEFINED => error.VariableAlreadyDefined,
        c.HSA_STATUS_ERROR_VARIABLE_UNDEFINED => error.VariableUndefined,
        c.HSA_STATUS_ERROR_EXCEPTION => error.Exception,
        c.HSA_STATUS_ERROR_INVALID_CODE_SYMBOL => error.InvalidCodeSymbol,
        c.HSA_STATUS_ERROR_INVALID_EXECUTABLE_SYMBOL => error.InvalidExecutableSymbol,
        c.HSA_STATUS_ERROR_INVALID_FILE => error.InvalidFile,
        c.HSA_STATUS_ERROR_INVALID_CODE_OBJECT_READER => error.InvalidCodeObjectReader,
        c.HSA_STATUS_ERROR_INVALID_CACHE => error.InvalidCache,
        c.HSA_STATUS_ERROR_INVALID_WAVEFRONT => error.InvalidWavefront,
        c.HSA_STATUS_ERROR_INVALID_SIGNAL_GROUP => error.InvalidSignalGroup,
        c.HSA_STATUS_ERROR_INVALID_RUNTIME_STATE => error.InvalidRuntimeState,
        c.HSA_STATUS_ERROR_FATAL => error.Fatal,
        else => error.Generic,
    };
}

/// Convert a Zig error to a HSA error.
pub fn toStatus(err: (Error || error{OutOfMemory})) c.hsa_status_t {
    return switch (err) {
        error.Generic => c.HSA_STATUS_ERROR,
        error.InvalidArgument => c.HSA_STATUS_ERROR_INVALID_ARGUMENT,
        error.InvalidQueueCreation => c.HSA_STATUS_ERROR_INVALID_QUEUE_CREATION,
        error.InvalidAllocation => c.HSA_STATUS_ERROR_INVALID_ALLOCATION,
        error.InvalidAgent => c.HSA_STATUS_ERROR_INVALID_AGENT,
        error.InvalidRegion => c.HSA_STATUS_ERROR_INVALID_REGION,
        error.InvalidSignal => c.HSA_STATUS_ERROR_INVALID_SIGNAL,
        error.InvalidQueue => c.HSA_STATUS_ERROR_INVALID_QUEUE,
        error.OutOfResources => c.HSA_STATUS_ERROR_OUT_OF_RESOURCES,
        error.InvalidPacketFormat => c.HSA_STATUS_ERROR_INVALID_PACKET_FORMAT,
        error.ResourceFree => c.HSA_STATUS_ERROR_RESOURCE_FREE,
        error.NotInitialized => c.HSA_STATUS_ERROR_NOT_INITIALIZED,
        error.RefcountOverflow => c.HSA_STATUS_ERROR_REFCOUNT_OVERFLOW,
        error.IncompatibleArguments => c.HSA_STATUS_ERROR_INCOMPATIBLE_ARGUMENTS,
        error.InvalidIndex => c.HSA_STATUS_ERROR_INVALID_INDEX,
        error.InvalidIsa => c.HSA_STATUS_ERROR_INVALID_ISA,
        error.InvalidIsaName => c.HSA_STATUS_ERROR_INVALID_ISA_NAME,
        error.InvalidCodeObject => c.HSA_STATUS_ERROR_INVALID_CODE_OBJECT,
        error.InvalidExecutable => c.HSA_STATUS_ERROR_INVALID_EXECUTABLE,
        error.FrozenExecutable => c.HSA_STATUS_ERROR_FROZEN_EXECUTABLE,
        error.InvalidSymbolName => c.HSA_STATUS_ERROR_INVALID_SYMBOL_NAME,
        error.VariableAlreadyDefined => c.HSA_STATUS_ERROR_VARIABLE_ALREADY_DEFINED,
        error.VariableUndefined => c.HSA_STATUS_ERROR_VARIABLE_UNDEFINED,
        error.Exception => c.HSA_STATUS_ERROR_EXCEPTION,
        error.InvalidCodeSymbol => c.HSA_STATUS_ERROR_INVALID_CODE_SYMBOL,
        error.InvalidExecutableSymbol => c.HSA_STATUS_ERROR_INVALID_EXECUTABLE_SYMBOL,
        error.InvalidFile => c.HSA_STATUS_ERROR_INVALID_FILE,
        error.InvalidCodeObjectReader => c.HSA_STATUS_ERROR_INVALID_CODE_OBJECT_READER,
        error.InvalidCache => c.HSA_STATUS_ERROR_INVALID_CACHE,
        error.InvalidWavefront => c.HSA_STATUS_ERROR_INVALID_WAVEFRONT,
        error.InvalidSignalGroup => c.HSA_STATUS_ERROR_INVALID_SIGNAL_GROUP,
        error.InvalidRuntimeState => c.HSA_STATUS_ERROR_INVALID_RUNTIME_STATE,
        error.Fatal => c.HSA_STATUS_ERROR_FATAL,

        // Also handle some common errors
        error.OutOfMemory => c.HSA_STATUS_ERROR_OUT_OF_RESOURCES,
    };
}

pub fn alloc(hsa_amd: *const c.AmdExtTable, pool: c.hsa_amd_memory_pool_t, size: usize) ![]u8 {
    var buf: [*]u8 = undefined;
    try check(hsa_amd.memory_pool_allocate(
        pool,
        size,
        0,
        @ptrCast(*?*anyopaque, &buf),
    ));
    return buf[0..size];
}

pub fn free(hsa_amd: *const c.AmdExtTable, buf: anytype) void {
    const ptr = switch (@typeInfo(@TypeOf(buf)).Pointer.size) {
        .Slice => buf.ptr,
        else => buf,
    };
    std.debug.assert(hsa_amd.memory_pool_free(ptr) == c.HSA_STATUS_SUCCESS);
}

pub fn allowAccess(hsa_amd: *const c.AmdExtTable, ptr: anytype, agents: []const c.hsa_agent_t) !void {
    try check(hsa_amd.agents_allow_access(
        @intCast(u32, agents.len),
        agents.ptr,
        null,
        ptr,
    ));
}
