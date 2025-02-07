const std = @import("std");

pub fn build(b: *std.Build) void {
    _ = b.addModule("webview", .{
        .source_file = .{ .path = "src/webview.zig" },
        .dependencies = &[_]std.Build.ModuleDependency{},
    });

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const objectFile = b.addObject(.{
        .name = "webviewObject",
        .optimize = optimize,
        .target = target,
    });
    objectFile.defineCMacro("WEBVIEW_STATIC", null);
    objectFile.linkLibCpp();
    switch(target.os_tag orelse @import("builtin").os.tag) {
        .windows => {
            objectFile.addCSourceFile(.{ .file = .{ .path = "webview/webview.cc"}, .flags = &.{"-std=c++14"}});
            objectFile.addIncludePath(std.build.LazyPath.relative("external/libs/Microsoft.Web.WebView2.1.0.2365.46/build/native/include/"));
            objectFile.linkSystemLibrary("ole32");
            objectFile.linkSystemLibrary("shlwapi");
            objectFile.linkSystemLibrary("version");
            objectFile.linkSystemLibrary("advapi32");
            objectFile.linkSystemLibrary("shell32");
            objectFile.linkSystemLibrary("user32");
        },
        .macos => {
            objectFile.addCSourceFile(.{ .file = .{ .path = "webview/webview.cc"}, .flags = &.{"-std=c++11"}});
            objectFile.linkFramework("WebKit");
        },
        else => {
            objectFile.addCSourceFile(.{ .file = .{ .path = "webview/webview.cc"}, .flags = &.{"-std=c++11"}});
            objectFile.linkSystemLibrary("gtk+-3.0");
            objectFile.linkSystemLibrary("webkit2gtk-4.0");
        }
    }

    const staticLib = b.addStaticLibrary(.{
        .name = "webviewStatic",
        .optimize = optimize,
        .target = target,
    });
    staticLib.defineCMacro("WEBVIEW_STATIC", null);
    staticLib.linkLibCpp();
    switch(target.os_tag orelse @import("builtin").os.tag) {
        .windows => {
            staticLib.addCSourceFile(.{ .file = .{ .path = "webview/webview.cc"}, .flags = &.{"-std=c++14"}});
            staticLib.addIncludePath(std.build.LazyPath.relative("external/libs/Microsoft.Web.WebView2.1.0.2365.46/build/native/include/"));
            staticLib.linkSystemLibrary("ole32");
            staticLib.linkSystemLibrary("shlwapi");
            staticLib.linkSystemLibrary("version");
            staticLib.linkSystemLibrary("advapi32");
            staticLib.linkSystemLibrary("shell32");
            staticLib.linkSystemLibrary("user32");
        },
        .macos => {
            staticLib.addCSourceFile(.{ .file = .{ .path = "webview/webview.cc"}, .flags = &.{"-std=c++11"}});
            staticLib.linkFramework("WebKit");
        },
        else => {
            staticLib.addCSourceFile(.{ .file = .{ .path = "webview/webview.cc"}, .flags = &.{"-std=c++11"}});
            staticLib.linkSystemLibrary("gtk+-3.0");
            staticLib.linkSystemLibrary("webkit2gtk-4.0");
        }
    }
    b.installArtifact(staticLib);

    const sharedLib = b.addSharedLibrary(.{
        .name = "webviewShared",
        .optimize = optimize,
        .target = target,
    });
    sharedLib.defineCMacro("WEBVIEW_BUILD_SHARED", null);
    sharedLib.linkLibCpp();
    switch(target.os_tag orelse @import("builtin").os.tag) {
        .windows => {
            sharedLib.addCSourceFile(.{ .file = .{ .path = "webview/webview.cc"}, .flags = &.{"-std=c++14"}});
            sharedLib.addIncludePath(std.build.LazyPath.relative("external/libs/Microsoft.Web.WebView2.1.0.2365.46/build/native/include/"));
            sharedLib.linkSystemLibrary("ole32");
            sharedLib.linkSystemLibrary("shlwapi");
            sharedLib.linkSystemLibrary("version");
            sharedLib.linkSystemLibrary("advapi32");
            sharedLib.linkSystemLibrary("shell32");
            sharedLib.linkSystemLibrary("user32");
        },
        .macos => {
            sharedLib.addCSourceFile(.{ .file = .{ .path = "webview/webview.cc"}, .flags = &.{"-std=c++11"}});
            sharedLib.linkFramework("WebKit");
        },
        else => {
            sharedLib.addCSourceFile(.{ .file = .{ .path = "webview/webview.cc"}, .flags = &.{"-std=c++11"}});
            sharedLib.linkSystemLibrary("gtk+-3.0");
            sharedLib.linkSystemLibrary("webkit2gtk-4.0");
        }
    }
    b.installArtifact(sharedLib);
}
