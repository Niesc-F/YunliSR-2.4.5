const std = @import("std");
const protocol = @import("protocol");
const CmdID = protocol.CmdID;
const Session = @import("../Session.zig");
const Packet = @import("../Packet.zig");
const Allocator = std.mem.Allocator;
const B64Decoder = std.base64.standard.Decoder;

pub fn onPlayerHeartBeat(session: *Session, packet: *const Packet, allocator: Allocator) !void {
    const req = try packet.getProto(protocol.PlayerHeartBeatCsReq, allocator);

    const downloadDataBin = "";
    const size = try B64Decoder.calcSizeForSlice(downloadDataBin);
    const buf = try allocator.alloc(u8, size);
    _ = try B64Decoder.decode(buf, downloadDataBin);
    const data = try protocol.ClientDownloadData.decode(buf, allocator);

    const rsp = protocol.PlayerHeartBeatScRsp{
        .retcode = 0,
        .client_time_ms = req.client_time_ms,
        .server_time_ms = @intCast(std.time.milliTimestamp()),
        .download_data = data,
    };

    try session.send(CmdID.CmdPlayerHeartBeatScRsp, rsp);
}
