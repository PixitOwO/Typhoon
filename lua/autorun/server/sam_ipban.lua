SAMIP = SAMIP or {}
local sam = sam
local ips = {}
function SAMIP:GetPlayerIp(steamid)
    if !ips[steamid] then return end
    return ips[steamid]
end
gameevent.Listen( "player_connect" )
hook.Add( "player_connect", "IPLog", function( data )
    local steamid = data.networkid
	local ip = data.address
    if file.Exists("banned-ips.txt", "DATA") then
        local bannedIps = util.JSONToTable(file.Read("banned-ips.txt", "DATA"))
        for bannedID,bannedIP in pairs(bannedIps) do
            if steamid ~= bannedID && ip == bannedIP then
                sam.player.ban_id(steamid, 0, "Ban Evading", "STEAM_0:1:26929632")
                break
            end
        end
    end
    if !ips then return end
    ips[steamid] = ip
end )

hook.Add("SAM.BannedPlayer", "IpBan", function(ply)
    local steamid = ply:SteamID()
    if file.Exists("banned-ips.txt", "DATA") then
        local bannedIps = util.JSONToTable(file.Read("banned-ips.txt", "DATA"))
        local ip = SAMIP:GetPlayerIp(steamid)
        if !ip then return end
        bannedIps[steamid] = ip
        file.Write("banned-ips.txt", util.TableToJSON(bannedIps))
    else
        local ip = SAMIP:GetPlayerIp(steamid)
        if !ip then return end
        local bannedIps = {}
        bannedIps[steamid] = ip
        file.Write("banned-ips.txt", util.TableToJSON(bannedIps))
    end
end)
hook.Add("SAM.BannedSteamID", "IpIDBan", function(steamid)
    if file.Exists("banned-ips.txt", "DATA") then
        local bannedIps = util.JSONToTable(file.Read("banned-ips.txt", "DATA"))
        local ip = SAMIP:GetPlayerIp(steamid)
        if !ip then return end
        bannedIps[steamid] = ip
        file.Write("banned-ips.txt", util.TableToJSON(bannedIps))
    else
        local ip = SAMIP:GetPlayerIp(steamid)
        if !ip then return end
        local bannedIps = {}
        bannedIps[steamid] = ip
        file.Write("banned-ips.txt", util.TableToJSON(bannedIps))
    end
end)
hook.Add("SAM.UnbannedSteamID", "IpUnban", function(steamid)
    if file.Exists("banned-ips.txt", "DATA") then
        local bannedIps = util.JSONToTable(file.Read("banned-ips.txt", "DATA"))
        bannedIps[steamid] = nil
        file.Write("banned-ips.txt", util.TableToJSON(bannedIps))
    end
end)