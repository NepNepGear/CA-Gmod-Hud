util.AddNetworkString( "attackercheck" )
util.AddNetworkString( "Hitboxgive" )
util.AddNetworkString( "Do_KillAccolades" )

hook.Add( "OnNPCKilled", "PostNotifyClientnpc", function( npc, attacker, inflictor )
		
		if GetConVar("ca_hud_accolades_enable"):GetBool() and attacker:IsPlayer() and IsValid(attacker) and IsValid(npc) then
			playerid = attacker:SteamID64()
			net.Start( "attackercheck" )
			net.WriteEntity( attacker )
			net.WriteBool(npc:IsNPC())
			net.Broadcast()
		end

end )

hook.Add( "PlayerDeath", "PostNotifyClientnpc", function( victim, inflictor, attacker)
		
		if GetConVar("ca_hud_accolades_enable"):GetBool() and attacker:IsPlayer() and IsValid(attacker) and IsValid(victim) and attacker != victim then
			playerid = attacker:SteamID64()
			net.Start( "attackercheck" )
			net.WriteEntity( attacker )
			net.WriteBool(victim:IsNPC())
			net.Broadcast()
		end

end )

hook.Add( "ScaleNPCDamage", "NotifyClientnpc", function( npc, hitbox, dmginfo )

			hitboxarea = hitbox


end )

hook.Add( "ScalePlayerDamage", "NotifyClientplayer", function( ply, hitbox, dmginfo )

			hitboxarea = hitbox


end )



net.Receive( "Hitboxgive", function()
	local playeridentify = net.ReadString()
	if playerid == playeridentify then
		
		if hitboxarea == HITGROUP_HEAD then
			net.Start( "Do_KillAccolades" )
			net.WriteBool( true )
			net.Broadcast()
		else 
			net.Start( "Do_KillAccolades" )
			net.WriteBool( false )
			net.Broadcast()
		end
	end
end)

CreateConVar( "ca_hud_enable", 1, FCVAR_ARCHIVE )
CreateConVar( "ca_hud_accolades_enable", 1, FCVAR_ARCHIVE )
CreateConVar( "ca_hud_radar_show_enemies", 1, FCVAR_ARCHIVE )
