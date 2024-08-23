const std = @import("std");
const httpz = @import("httpz");
const protocol = @import("protocol");
const Base64Encoder = @import("std").base64.standard.Encoder;

pub fn onQueryDispatch(_: *httpz.Request, res: *httpz.Response) !void {
    std.log.debug("onQueryDispatch", .{});

    var proto = protocol.GlobalDispatchData.init(res.arena);

    proto.retcode = 0;
    try proto.server_list.append(.{
        .name = .{ .Const = "FeixiaoSR" },
        .display_name = .{ .Const = "FeixiaoSR" },
        .env_type = .{ .Const = "2" },
        .title = .{ .Const = "FeixiaoSR" },
        .dispatch_url = .{ .Const = "http://127.0.0.1:21000/query_gateway" },
    });

    const data = try proto.encode(res.arena);
    const size = Base64Encoder.calcSize(data.len);
    const output = try res.arena.alloc(u8, size);
    _ = Base64Encoder.encode(output, data);

    res.body = output;
}

pub fn onQueryGateway(_: *httpz.Request, res: *httpz.Response) !void {
    std.log.debug("onQueryGateway", .{});

    var proto = protocol.Gateserver.init(res.arena);

    proto.retcode = 0;
    proto.port = 23301;
    proto.ip = .{ .Const = "127.0.0.1" };
    proto.lua_version = .{ .Const = "7852981" };
    proto.ifix_version = .{ .Const = "0" };
    proto.lua_url = .{ .Const = "https://autopatchcn.bhsr.com/lua/BetaLive/output_7852981_757d6a2b7feb" };
    proto.asset_bundle_url = .{ .Const = "https://autopatchcn.bhsr.com/asb/BetaLive/output_7852702_3da63958007e" };
    proto.ex_resource_url = .{ .Const = "https://autopatchcn.bhsr.com/design_data/BetaLive/output_7857075_9f5efd1b38f2" };
    proto.HAFCIPEGPIN = true;
    proto.FKENKKHLHHD = true;
    proto.OPGMNLINAKC = true;
    proto.MBDACJEJAMF = true;
    proto.BGPCCKKDDMB = true;
    proto.GJAEGHBEAIO = true;
    proto.LAMJDOGMFAM = true;
    proto.GEDIONGPDHA = true;
    proto.MOIKMLHOIAP = true;
    proto.KJADMKNDDJL = true;

    const data = try proto.encode(res.arena);
    const size = Base64Encoder.calcSize(data.len);
    const output = try res.arena.alloc(u8, size);
    _ = Base64Encoder.encode(output, data);

    res.body = output;
}
