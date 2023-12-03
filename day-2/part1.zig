const std = @import("std");
const input = @embedFile("input");
const print = std.log.warn;
const expect = std.testing.expect;

const Color = enum {
    red,
    green,
    blue,
};

const MAX_CUBES = [_]u32{ 12, 13, 14 };

fn doesColorHasInvalidValue(line: []const u8, color: Color) !bool {
    const max_value = MAX_CUBES[@intFromEnum(color)];
    var line_split_by_spaces = std.mem.split(u8, line, " ");
    var previous_str: []const u8 = "";

    while (line_split_by_spaces.next()) |str| {
        if (std.mem.indexOf(u8, str, @tagName(color)) != null) {
            const value = try std.fmt.parseInt(u32, previous_str, 10);
            if (value > max_value) return true;
        }
        previous_str = str;
    }

    return false;
}

fn solve() !u32 {
    var file_lines = std.mem.split(u8, input, "\n");
    var result: u32 = 0;
    var curr_id: u32 = 1;

    while (file_lines.next()) |line| {
        const redIsValid = !try doesColorHasInvalidValue(line, .red);
        const greenIsValid = !try doesColorHasInvalidValue(line, .green);
        const blueIsValid = !try doesColorHasInvalidValue(line, .blue);

        if (redIsValid and greenIsValid and blueIsValid) {
            result += curr_id;
        }

        curr_id += 1;
    }

    return result + 1 - curr_id;
}

test "Day 2 - Part I" {
    const res = try solve();
    print("{!}", .{res});
    try expect(res == 2727);
}
