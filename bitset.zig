const std = @import("std");

pub fn BitSet(comptime T: type) type {
    return struct {
        data: DataType = zero,

        const bit_count = (std.meta.fields(T)).len;
        const DataType = std.meta.Int(.unsigned, bit_count);
        const zero = @as(DataType, 0);
        const one = @as(DataType, 1);
        const Self = @This();

        pub fn put(self: *Self, item: T) void {
            self.*.data |= one << @enumToInt(item);
        }

        pub fn putAll(self: *Self) void {
            self.*.data = ~zero;
        }

        pub fn del(self: *Self, item: T) void {
            self.*.data &= ~(one << @enumToInt(item));
        }

        pub fn delAll(self: *Self) void {
            self.*.data = zero;
        }

        pub fn eql(self: Self, other: Self) bool {
            return self.data == other.data;
        }

        pub fn has(self: Self, item: T) bool {
            return ((self.data >> @enumToInt(item)) & one) == one;
        }

        pub fn isEmpty(self: Self) bool {
            return self.size == 0;
        }

        pub fn size(self: Self) usize {
            return @popCount(@TypeOf(self.data), self.data);
        }
    };
}

test "BitSet" {
    const expect = std.testing.expect;
    const MouseBtn = enum { Left, Right, Middle };

    var clicks = BitSet(MouseBtn){};
    expect(clicks.size() == 0);
    clicks.put(.Left);
    clicks.put(.Right);
    expect(clicks.size() == 2);
    expect(clicks.has(.Left));
    expect(!clicks.has(.Middle));
    clicks.delAll();
    expect(clicks.size() == 0);
    clicks.putAll();
    expect(clicks.size() == 3);
}
