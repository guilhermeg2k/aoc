const std = @import("std");
const fs = std.fs;
const print = std.log.warn;
const expect = std.testing.expect;

// PART 1 //
fn getFirstDigit(str: []const u8) u8 {
    for (str) |char| {
        if (std.ascii.isDigit(char)) {
            return char;
        }
    }

    return '0';
}

fn getLastDigit(str: []const u8) u8 {
    for (str, 0..) |_, i| {
        const char = str[str.len - 1 - i];
        if (std.ascii.isDigit(char)) {
            return char;
        }
    }

    return '0';
}

fn solvePart1(input_file: []const u8, allocator: std.mem.Allocator) !u32 {
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
    const res = try solvePart1("input", std.testing.allocator);
    std.log.warn("{!}", .{res});
    try expect(res == 55816);
}

// Part II //

fn getSpelledNumberAhead(str: []const u8, index: usize) ?u8 {
    if (std.mem.eql(u8, str[index..@min(index + 3, str.len)], "one")) {
        return '1';
    }

    if (std.mem.eql(u8, str[index..@min(index + 3, str.len)], "two")) {
        return '2';
    }

    if (std.mem.eql(u8, str[index..@min(index + 5, str.len)], "three")) {
        return '3';
    }

    if (std.mem.eql(u8, str[index..@min(index + 4, str.len)], "four")) {
        return '4';
    }

    if (std.mem.eql(u8, str[index..@min(index + 4, str.len)], "five")) {
        return '5';
    }

    if (std.mem.eql(u8, str[index..@min(index + 3, str.len)], "six")) {
        return '6';
    }

    if (std.mem.eql(u8, str[index..@min(index + 5, str.len)], "seven")) {
        return '7';
    }

    if (std.mem.eql(u8, str[index..@min(index + 5, str.len)], "eight")) {
        return '8';
    }

    if (std.mem.eql(u8, str[index..@min(index + 4, str.len)], "nine")) {
        return '9';
    }

    return null;
}

fn getFirstNumber(str: []const u8) u8 {
    for (str, 0..) |char, i| {
        if (std.ascii.isDigit(char)) {
            return char;
        }

        if (getSpelledNumberAhead(str, i)) |c| {
            return c;
        }
    }

    return '0';
}

fn getLastNumber(str: []const u8) u8 {
    for (str, 0..) |_, i| {
        const index = str.len - 1 - i;
        const curr_char = str[index];
        if (std.ascii.isDigit(str[index])) {
            return curr_char;
        }

        if (getSpelledNumberAhead(str, index)) |char| {
            return char;
        }
    }

    return '0';
}

fn solvePart2(input_file: []const u8, allocator: std.mem.Allocator) !u32 {
    var result: u32 = 0;
    const file_content = try fs.cwd().readFileAlloc(allocator, input_file, 1000000);
    defer allocator.free(file_content);
    var file_lines = std.mem.splitSequence(u8, file_content, "\n");

    while (file_lines.next()) |line| {
        const first_digit = getFirstNumber(line);
        const last_digit = getLastNumber(line);
        const value = try std.fmt.parseInt(u32, &[2]u8{ first_digit, last_digit }, 10);
        result += value;
    }

    return result;
}

test "Day 1 - Part 2" {
    const res = try solvePart2("input", std.testing.allocator);
    std.log.warn("{!}", .{res});
    try expect(res == 54980);
}
