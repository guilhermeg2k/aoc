const std = @import("std");
const input = @embedFile("input");
const print = std.log.warn;
const expect = std.testing.expect;

const Color = enum {
    red,
    green,
    blue,
};

fn getMinRequiredCubesForColor(line: []const u8, color: Color) !u32 {
    var line_split_by_spaces = std.mem.split(u8, line, " ");
    var previous_str: []const u8 = "";
    var required_value: u32 = 0;

    while (line_split_by_spaces.next()) |str| {
        if (std.mem.indexOf(u8, str, @tagName(color)) != null) {
            const value = try std.fmt.parseInt(u32, previous_str, 10);
            if (value > required_value) required_value = value;
        }
        previous_str = str;
    }

    return required_value;
}

fn solve() !u32 {
    var file_lines = std.mem.split(u8, input, "\n");
    var result: u32 = 0;

    while (file_lines.next()) |line| {
        const min_value_for_red = try getMinRequiredCubesForColor(line, .red);
        const min_value_for_green = try getMinRequiredCubesForColor(line, .green);
        const min_value_for_blue = try getMinRequiredCubesForColor(line, .blue);
        result += min_value_for_red * min_value_for_blue * min_value_for_green;
    }
    return result;
}

test "Day 2 - Part II" {
    const res = try solve();
    print("{!}", .{res});
    try expect(res == 56580);
}
