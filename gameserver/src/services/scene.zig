const std = @import("std");
const protocol = @import("protocol");
const CmdID = protocol.CmdID;
const Session = @import("../Session.zig");
const Packet = @import("../Packet.zig");
const Allocator = std.mem.Allocator;

const log = std.log.scoped(.scene_service);

pub fn onGetCurSceneInfo(session: *Session, _: *const Packet, allocator: Allocator) !void {
    var scene_info = protocol.SceneInfo.init(allocator);
    scene_info.JDEFJHMIGII = 0;
    scene_info.game_mode_type = 2;
    scene_info.plane_id = 20111;
    scene_info.floor_id = 20111001;
    scene_info.entry_id = 2011101;

        { // Character
        var scene_group = protocol.SceneGroupInfo.init(allocator);
        scene_group.state = 1;

        try scene_group.entity_list.append(.{
            //unused
            //.entity_id = 0,
            //.group_id = 0,
            //.inst_id = 0,
            .actor = .{
                .base_avatar_id = 1314,
                .avatar_type = .AVATAR_FORMAL_TYPE,
                .uid = 666,
                .map_layer = 2,
            },
            //.motion = .{ .pos = .{ .x = 32342, .y = 192820, .z = 434276 }, .rot = .{} },
            .motion = .{ .pos = .{ .x = 75856, .y = 2267, .z = 193953 }, .rot = .{} },
        });

        try scene_info.scene_group_list.append(scene_group);
    }

    { // Calyx prop
        var scene_group = protocol.SceneGroupInfo.init(allocator);
        scene_group.state = 1;
        scene_group.group_id = 26;

        var prop = protocol.ScenePropInfo.init(allocator);
        prop.prop_id = 808;
        prop.prop_state = 26;

        try scene_group.entity_list.append(.{
            .group_id = 26,
            .inst_id = 300001,
            .entity_id = 1337,
            .prop = prop,
            //.motion = .{ .pos = .{ .x = 31440, .y = 192820, .z = 433790 }, .rot = .{} },
            .motion = .{ .pos = .{ .x = 75806, .y = 2267, .z = 193903 }, .rot = .{} },
        });

        try scene_info.scene_group_list.append(scene_group);
    }

    try session.send(CmdID.CmdGetCurSceneInfoScRsp, protocol.GetCurSceneInfoScRsp{
        .scene = scene_info,
        .retcode = 0,
    });
}

pub fn onSceneEntityMove(session: *Session, packet: *const Packet, allocator: Allocator) !void {
    const req = try packet.getProto(protocol.SceneEntityMoveCsReq, allocator);

    for (req.entity_motion_list.items) |entity_motion| {
        if (entity_motion.motion) |motion| {
            log.debug("[POSITION] entity_id: {}, motion: {}", .{ entity_motion.entity_id, motion });
        }
    }

    try session.send(CmdID.CmdSceneEntityMoveScRsp, protocol.SceneEntityMoveScRsp{
        .retcode = 0,
        .entity_motion_list = req.entity_motion_list,
        .download_data = null,
    });
}
