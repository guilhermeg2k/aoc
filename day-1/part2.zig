const std = @import("std");
const fs = std.fs;
const print = std.log.warn;
const expect = std.testing.expect;

const SpeltNumber = enum { zero, one, two, three, four, five, six, seven, eight, nine };

fn getSpeltNumberAhead(str: []const u8, index: usize) ?u32 {
    var speltNumber: SpeltNumber = std.meta.stringToEnum(SpeltNumber, str[index..@min(index + 3, str.len)]) orelse .zero;
    speltNumber = std.meta.stringToEnum(SpeltNumber, str[index..@min(index + 4, str.len)]) orelse speltNumber;
    speltNumber = std.meta.stringToEnum(SpeltNumber, str[index..@min(index + 5, str.len)]) orelse speltNumber;
    const number: u32 = @intFromEnum(speltNumber);
    if (number == 0) return null;
    return number;
}

fn getFirstDigit(str: []const u8) u32 {
    for (str, 0..) |char, i| {
        if (std.ascii.isDigit(char)) return char - 48;
        if (getSpeltNumberAhead(str, i)) |number| return number;
    }
    return 0;
}

fn getLastDigit(str: []const u8) u32 {
    for (str, 0..) |_, i| {
        const index = str.len - 1 - i;
        const curr_char = str[index];
        if (std.ascii.isDigit(str[index])) return curr_char - 48;
        if (getSpeltNumberAhead(str, index)) |number| return number;
    }
    return 0;
}

fn solvePart2(input_file: []const u8, allocator: std.mem.Allocator) !u32 {
    var result: u32 = 0;
    const file_content = try fs.cwd().readFileAlloc(allocator, input_file, 1000000);
    defer allocator.free(file_content);
    var file_lines = std.mem.splitSequence(u8, file_content, "\n");

    while (file_lines.next()) |line| {
        const first_digit = getFirstDigit(line);
        const last_digit = getLastDigit(line);
        const value = (first_digit * 10 + last_digit);
        result += value;
    }

    return result;
}

test "Day 1 - Part 2" {
    const res = try solvePart2("input", std.testing.allocator);
    std.log.warn("{!}", .{res});
    try expect(res == 54980);
}
