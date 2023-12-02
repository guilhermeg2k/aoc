const std = @import("std");
const fs = std.fs;
const print = std.log.warn;
const expect = std.testing.expect;

fn getFirstDigit(str: []const u8) u8 {
    for (str) |char| {
        if (std.ascii.isDigit(char)) {
            return char;
        }
    }

    return 48;
}

fn getLastDigit(str: []const u8) u8 {
    for (str, 0..) |_, i| {
        const char = str[str.len - 1 - i];
        if (std.ascii.isDigit(char)) {
            return char;
        }
    }

    return 48;
}

fn solvePartOne(input_file: []const u8, allocator: std.mem.Allocator) !u32 {
    var result: u32 = 0;
    const file_content = try fs.cwd().readFileAlloc(allocator, input_file, 1000000);
    defer allocator.free(file_content);
    var file_lines = std.mem.splitSequence(u8, file_content, "\n");

    while (file_lines.next()) |line| {
        const first_digit = getFirstDigit(line);
        const last_digit = getLastDigit(line);
        const value = try std.fmt.parseInt(u32, &[2]u8{ first_digit, last_digit }, 10);
        result += value;
    }

    return result;
}

test "Day 1 - Part I" {
    const res = try solvePartOne("input", std.testing.allocator);
    std.log.warn("{!}", .{res});
    try expect(res == 55816);
}
