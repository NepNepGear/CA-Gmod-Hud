function ScaleW(px)
	local resolution = ScrW() / ScrH()
	if resolution > 1.8 and GetConVar("ca_hud_ultrawide_scale"):GetBool() then
		-- scale as if the ultrawide screen was scaling 16:9
		return ((px / 1024) * ScrH() * 1.7777)
	else
		return (px / 1024) * ScrW()
	end
end

function ScaleX(px)
	local resolution = ScrW() / ScrH()
	if resolution > 1.8 and GetConVar("ca_hud_ultrawide_scale"):GetBool() then
		-- the centering of the hud to 16:9 if the user has 21:9 
		return ((px / 1024) * ScrH() * 1.7777)+((ScrW()-(math.ceil (ScrH() * 1.7777)))/2)
	else
		return (px / 1024) * ScrW()
	end
end

hook.Add("Initialize", "CAFonts", function()
	surface.CreateFont("CA_Font", {
        font = "Living Hell",
        size = ScaleH(35),
        weight = 200,
    })
	surface.CreateFont("CA_Font_Shadow", {
        font = "Living Hell",
        size = ScaleH(40),
        weight = 200,
    })
	plykill = 0
	multikills = 1
	combokills = 1
end)

local function killacclade(check)
	
	
end

net.Receive( "attackercheck", function()
	attacker = net.ReadEntity()
	if GetConVar("ca_hud_accolades_enable"):GetBool() and IsValid(attacker) and attacker == LocalPlayer() then
		playerattacker = LocalPlayer():SteamID64()
		npc_or_nah = net.ReadBool()
		net.Start( "Hitboxgive" )
		
		net.WriteString(tostring(playerattacker))
		net.SendToServer()
	end
end )


net.Receive( "Do_KillAccolades", function()
	
	local headshotcheck = net.ReadBool()
	
	if (timer.Exists("killingtime" .. LocalPlayer():SteamID64())) then
		timer.Remove("killingtime" .. LocalPlayer():SteamID64())
		hook.Remove("HUDPaint", "CA_Acclade")
		if(npc_or_nah == true) then
			combokills = combokills + 1
		elseif multikills < 7 then
			multikills = multikills + 1
		end
	else
		multikills = 1
		combokills = 1
	end
	
	plykill = plykill + 1
	
	hook.Add("HUDPaint", "CA_Acclade", function()
		surface.SetDrawColor(255, 255, 255, 255)
	
	if multikills > 1 then
		surface.SetMaterial(Material("gearsyfox/CA Accolades/Kill_" .. tostring(multikills) .. ".png", "noclamp"))
		surface.DrawTexturedRect(ScaleX(330), ScaleH(110), ScaleW(512), ScaleH(128))
		
		if headshotcheck == true then
			surface.SetMaterial(Material("gearsyfox/CA Accolades/SKULL.png", "noclamp"))
			surface.DrawTexturedRect(ScaleX(480), ScaleH(50), ScaleW(64), ScaleH(128))
		end
	elseif combokills > 1 then
			surface.SetMaterial(Material("gearsyfox/CA Accolades/COMBO.png", "noclamp"))
			surface.DrawTexturedRect(ScaleX(425), ScaleH(110), ScaleW(256), ScaleH(128))
			
			local Killfstd = math.floor(combokills % 10)
			local firstkills = "gearsyfox/CA Accolades/NUMBER_" .. tostring(Killfstd) .. ".png"
			local Killsecd = math.floor((combokills % 100) / 10)
			local secondkills = "gearsyfox/CA Accolades/NUMBER_" .. tostring(Killsecd) .. ".png"
			local Killsthrd = math.floor(combokills / 100)
			local thirdkills = "gearsyfox/CA Accolades/NUMBER_" .. tostring(Killsthrd) .. ".png"
				
			if combokills < 10 then	
				surface.SetMaterial(Material(firstkills, "noclamp"))
				surface.DrawTexturedRect(ScaleX(385), ScaleH(110), ScaleW(64), ScaleH(128))
			elseif combokills < 100 then
				surface.SetMaterial(Material(firstkills, "noclamp"))
				surface.DrawTexturedRect(ScaleX(385), ScaleH(110), ScaleW(64), ScaleH(128))
				surface.SetMaterial(Material(secondkills, "noclamp"))
				surface.DrawTexturedRect(ScaleX(345), ScaleH(110), ScaleW(64), ScaleH(128))
			elseif combokills >= 1000 then
				surface.SetMaterial(Material("gearsyfox/CA Accolades/NUMBER_9.png", "noclamp"))
				surface.DrawTexturedRect(ScaleX(385), ScaleH(110), ScaleW(64), ScaleH(128))
				surface.SetMaterial(Material("gearsyfox/CA Accolades/NUMBER_9.png", "noclamp"))
				surface.DrawTexturedRect(ScaleX(345), ScaleH(110), ScaleW(64), ScaleH(128))
				surface.SetMaterial(Material("gearsyfox/CA Accolades/NUMBER_9.png", "noclamp"))
				surface.DrawTexturedRect(ScaleX(305), ScaleH(110), ScaleW(64), ScaleH(128))
			else
				surface.SetMaterial(Material(firstkills, "noclamp"))
				surface.DrawTexturedRect(ScaleX(385), ScaleH(110), ScaleW(64), ScaleH(128))
				surface.SetMaterial(Material(secondkills, "noclamp"))
				surface.DrawTexturedRect(ScaleX(345), ScaleH(110), ScaleW(64), ScaleH(128))
				surface.SetMaterial(Material(thirdkills, "noclamp"))
				surface.DrawTexturedRect(ScaleX(305), ScaleH(110), ScaleW(64), ScaleH(128))
			end
			
			if headshotcheck == true then
				surface.SetMaterial(Material("gearsyfox/CA Accolades/SKULL.png", "noclamp"))
				surface.DrawTexturedRect(ScaleX(480), ScaleH(50), ScaleW(64), ScaleH(128))
			end
	elseif headshotcheck == true and comboskills == 1 and mutikills == 1 then
		surface.SetMaterial(Material("gearsyfox/CA Accolades/HEAD_SHOT.png", "noclamp"))
		surface.DrawTexturedRect(ScaleX(340), ScaleH(110), ScaleW(512), ScaleH(128))
		surface.SetMaterial(Material("gearsyfox/CA Accolades/SKULL.png", "noclamp"))
		surface.DrawTexturedRect(ScaleX(480), ScaleH(50), ScaleW(64), ScaleH(128))
	else
		if (plykill < 2)then
			surface.SetMaterial(Material("gearsyfox/CA Accolades/KILL.png", "noclamp"))
		else 
			surface.SetMaterial(Material("gearsyfox/CA Accolades/KILLS.png", "noclamp"))
		end
			surface.DrawTexturedRect(ScaleX(415), ScaleH(110), ScaleW(256), ScaleH(128))
			local Killfstd = math.floor(plykill % 10)
			local firstkills = "gearsyfox/CA Accolades/NUMBER_" .. tostring(Killfstd) .. ".png"
			local Killsecd = math.floor((plykill % 100) / 10)
			local secondkills = "gearsyfox/CA Accolades/NUMBER_" .. tostring(Killsecd) .. ".png"
			local Killsthrd = math.floor(plykill / 100)
			local thirdkills = "gearsyfox/CA Accolades/NUMBER_" .. tostring(Killsthrd) .. ".png"
				
			if plykill < 10 then	
				surface.SetMaterial(Material(firstkills, "noclamp"))
				surface.DrawTexturedRect(ScaleX(375), ScaleH(110), ScaleW(64), ScaleH(128))
			elseif plykill < 100 then
				surface.SetMaterial(Material(firstkills, "noclamp"))
				surface.DrawTexturedRect(ScaleX(375), ScaleH(110), ScaleW(64), ScaleH(128))
				surface.SetMaterial(Material(secondkills, "noclamp"))
				surface.DrawTexturedRect(ScaleX(335), ScaleH(110), ScaleW(64), ScaleH(128))
			elseif plykill >= 1000 then
				surface.SetMaterial(Material("gearsyfox/CA Accolades/NUMBER_9.png", "noclamp"))
				surface.DrawTexturedRect(ScaleX(375), ScaleH(110), ScaleW(64), ScaleH(128))
				surface.SetMaterial(Material("gearsyfox/CA Accolades/NUMBER_9.png", "noclamp"))
				surface.DrawTexturedRect(ScaleX(335), ScaleH(110), ScaleW(64), ScaleH(128))
				surface.SetMaterial(Material("gearsyfox/CA Accolades/NUMBER_9.png", "noclamp"))
				surface.DrawTexturedRect(ScaleX(295), ScaleH(110), ScaleW(64), ScaleH(128))
			else
				surface.SetMaterial(Material(firstkills, "noclamp"))
				surface.DrawTexturedRect(ScaleX(375), ScaleH(110), ScaleW(64), ScaleH(128))
				surface.SetMaterial(Material(secondkills, "noclamp"))
				surface.DrawTexturedRect(ScaleX(335), ScaleH(110), ScaleW(64), ScaleH(128))
				surface.SetMaterial(Material(thirdkills, "noclamp"))
				surface.DrawTexturedRect(ScaleX(295), ScaleH(110), ScaleW(64), ScaleH(128))
			end

	end
	end)
			
	timer.Create("killingtime" .. LocalPlayer():SteamID64(),3,1, function()
		hook.Remove("HUDPaint", "CA_Acclade")
	end)

end )

function ScaleH(px)
	return (px / 768) * ScrH()
end

function surface.DrawTexturedRectRotatedPoint( x, y, w, h, rot, x0, y0 )
	
	local c = math.cos( math.rad( rot ) )
	local s = math.sin( math.rad( rot ) )
	
	local newx = y0 * s - x0 * c
	local newy = y0 * c + x0 * s
	
	surface.DrawTexturedRectRotated( x + newx, y + newy, w, h, rot )
	
end

function callgunbase(wep)
	
	if wep.Base == "arc9_base" then
	local firemode_arc9 = wep:GetCurrentFiremodeTable()
		
		if firemode_arc9.Mode == -1 then 
			surface.SetMaterial(Material("gearsyfox/CA HUD/FIRE_MODE_AUTO.png", "noclamp"))
			surface.DrawTexturedRect(ScaleX(920), ScaleH(750), ScaleW(256), ScaleH(16))
		elseif firemode_arc9.Mode >= 2 then 
			surface.SetMaterial(Material("gearsyfox/CA HUD/FIRE_MODE_THREE.png", "noclamp"))
			surface.DrawTexturedRect(ScaleX(920), ScaleH(750), ScaleW(256), ScaleH(16))
		elseif firemode_arc9.Mode == 1 then 
			surface.SetMaterial(Material("gearsyfox/CA HUD/FIRE_MODE_ONE.png", "noclamp"))
			surface.DrawTexturedRect(ScaleX(920), ScaleH(750), ScaleW(256), ScaleH(16))
		end
	end
end

hook.Add("HUDPaint", "CA_HUD", function()
	if GetConVar("ca_hud_enable"):GetBool() then
		--all player related stats
		local ply = LocalPlayer()
		local hp = ply:Health()
		local ap = ply:Armor()
		local sp = ply:GetSuitPower()
		local wep = ply:GetActiveWeapon()
		local kills = ply:Frags()
		
		--all weapon related stats
		if IsValid(wep) then
			local mag = ply:GetActiveWeapon(wep:Clip1())
			local res = ply:GetActiveWeapon(wep:GetPrimaryAmmoType())
		end
	
	
		if IsValid(ply) and ply:Alive() then
			if hp <= 30 then
				surface.SetDrawColor(255, 0, 0, 255)
			else
				surface.SetDrawColor(255, 255, 255, 255)
			end
		
			-- draw the health points
		
			surface.SetMaterial(Material("gearsyfox/CA HUD/HP.png", "noclamp"))
			surface.DrawTexturedRect(ScaleX(34), ScaleH(715), ScaleW(32), ScaleH(32))
		
			local HPfstd = math.floor(hp % 10)
			local firsthp = "gearsyfox/CA HUD/HUD_BULLET_BIG_" .. tostring(HPfstd) .. ".png"
			local HPsecd = math.floor((hp % 100) / 10)
			local secondhp = "gearsyfox/CA HUD/HUD_BULLET_BIG_" .. tostring(HPsecd) .. ".png"
			local HPthrd = math.floor(hp / 100)
			local thirdhp = "gearsyfox/CA HUD/HUD_BULLET_BIG_" .. tostring(HPthrd) .. ".png"
			local HPford = hp / 1000
		
		
			if HPford >= 1 then	
				surface.SetMaterial(Material("gearsyfox/CA HUD/HUD_BULLET_BIG_9.png", "noclamp"))
				surface.DrawTexturedRect(ScaleX(60), ScaleH(713), ScaleW(32), ScaleH(32))
				surface.DrawTexturedRect(ScaleX(76), ScaleH(713), ScaleW(32), ScaleH(32))
				surface.DrawTexturedRect(ScaleX(92), ScaleH(713), ScaleW(32), ScaleH(32))
			elseif hp < 0 then
				surface.SetMaterial(Material("gearsyfox/CA HUD/HUD_BULLET_BIG_0.png", "noclamp"))
				surface.DrawTexturedRect(ScaleX(60), ScaleH(713), ScaleW(32), ScaleH(32))
				surface.DrawTexturedRect(ScaleX(76), ScaleH(713), ScaleW(32), ScaleH(32))
				surface.DrawTexturedRect(ScaleX(92), ScaleH(713), ScaleW(32), ScaleH(32))
			else
				surface.SetMaterial(Material(thirdhp, "noclamp"))
				surface.DrawTexturedRect(ScaleX(60), ScaleH(713), ScaleW(32), ScaleH(32))
				surface.SetMaterial(Material(secondhp, "noclamp"))
				surface.DrawTexturedRect(ScaleX(76), ScaleH(713), ScaleW(32), ScaleH(32))
				surface.SetMaterial(Material(firsthp, "noclamp"))
				surface.DrawTexturedRect(ScaleX(92), ScaleH(713), ScaleW(32), ScaleH(32))
			end
		
			-- draw the character on the left
		
		
			if ply:Crouching() then
				surface.SetMaterial(Material("gearsyfox/CA HUD/CROUCH_POSITION.png", "noclamp"))
				surface.DrawTexturedRect(ScaleX(3), ScaleH(669), ScaleW(64), ScaleH(64))
			else 
				surface.SetMaterial(Material("gearsyfox/CA HUD/STAND_POSITION.png", "noclamp"))
				surface.DrawTexturedRect(ScaleX(0), ScaleH(670.7), ScaleW(64), ScaleH(64))
			end
		
        
		
		-- draw the armor points
			surface.SetMaterial(Material("gearsyfox/CA HUD/AP.png", "noclamp"))
			surface.DrawTexturedRect(ScaleX(110), ScaleH(715), ScaleW(32), ScaleH(32))
		
			local APfstd = math.floor(ap % 10)
			local firstap = "gearsyfox/CA HUD/HUD_BULLET_BIG_" .. tostring(APfstd) .. ".png"
			local APsecd = math.floor((ap % 100) / 10)
			local secondap = "gearsyfox/CA HUD/HUD_BULLET_BIG_" .. tostring(APsecd) .. ".png"
			local APthrd = math.floor(ap / 100)
			local thirdap = "gearsyfox/CA HUD/HUD_BULLET_BIG_" .. tostring(APthrd) .. ".png"
		
			if ap >= 1000 then	
				surface.SetMaterial(Material("gearsyfox/CA HUD/HUD_BULLET_BIG_9.png", "noclamp"))
				surface.DrawTexturedRect(ScaleX(135), ScaleH(713), ScaleW(32), ScaleH(32))
				surface.DrawTexturedRect(ScaleX(148), ScaleH(713), ScaleW(32), ScaleH(32))
				surface.DrawTexturedRect(ScaleX(161), ScaleH(713), ScaleW(32), ScaleH(32))
			elseif ap < 0 then	
				surface.SetMaterial(Material("gearsyfox/CA HUD/HUD_BULLET_BIG_0.png", "noclamp"))
				surface.DrawTexturedRect(ScaleX(135), ScaleH(713), ScaleW(32), ScaleH(32))
				surface.DrawTexturedRect(ScaleX(148), ScaleH(713), ScaleW(32), ScaleH(32))
				surface.DrawTexturedRect(ScaleX(161), ScaleH(713), ScaleW(32), ScaleH(32))
			else
				surface.SetMaterial(Material(thirdap, "noclamp"))
				surface.DrawTexturedRect(ScaleX(135), ScaleH(713), ScaleW(32), ScaleH(32))
				surface.SetMaterial(Material(secondap, "noclamp"))
				surface.DrawTexturedRect(ScaleX(151), ScaleH(713), ScaleW(32), ScaleH(32))
				surface.SetMaterial(Material(firstap, "noclamp"))
				surface.DrawTexturedRect(ScaleX(166), ScaleH(713), ScaleW(32), ScaleH(32))
			end
		
			-- draw the Stamina points
			surface.SetMaterial(Material("gearsyfox/CA HUD/GAGE_SP_0.png", "noclamp"))
			surface.DrawTexturedRect(ScaleX(0), ScaleH(735), ScaleW(256), ScaleH(32))
		
			surface.SetMaterial(Material("gearsyfox/CA HUD/GAGE_SP_CELL.png", "noclamp"))
			surface.DrawTexturedRect(ScaleX(45), ScaleH(745.9555), ScaleW(140) * (sp/100), ScaleH(12))
		
			-- kills and deaths
			surface.SetDrawColor(255, 255, 255, 255)
			if GetConVar("ca_hud_kdr_enable"):GetBool() then
				if (ply:Deaths() < 2)then
					surface.SetMaterial(Material("gearsyfox/CA HUD/FFA_DEATH.png", "noclamp"))
				else 
					surface.SetMaterial(Material("gearsyfox/CA HUD/FFA_DEATH1.png", "noclamp"))
				end
				surface.DrawTexturedRect(ScaleX(600), ScaleH(27), ScaleW(128), ScaleH(32))
		
				local Deathfstd = math.floor(ply:Deaths() % 10)
				local firstdeaths = "gearsyfox/CA HUD/HUD_SCORE_" .. tostring(Deathfstd) .. ".png"
				local Deathsecd = math.floor((ply:Deaths() % 100) / 10)
				local seconddeaths = "gearsyfox/CA HUD/HUD_SCORE_" .. tostring(Deathsecd) .. ".png"
				local Deathsthrd = math.floor(ply:Deaths() / 100)
				local thirddeaths = "gearsyfox/CA HUD/HUD_SCORE_" .. tostring(Deathsthrd) .. ".png"
				local Deathsford = ply:Deaths() / 1000
		
				if Deathsford >= 1 then	
					surface.SetMaterial(Material("gearsyfox/CA HUD/HUD_SCORE_9.png", "noclamp"))
					surface.DrawTexturedRect(ScaleX(530), ScaleH(18), ScaleW(64), ScaleH(64))
					surface.DrawTexturedRect(ScaleX(550), ScaleH(18), ScaleW(64), ScaleH(64))
					surface.DrawTexturedRect(ScaleX(570), ScaleH(18), ScaleW(64), ScaleH(64))
				elseif ply:Deaths() < 0 then
					surface.SetMaterial(Material("gearsyfox/CA HUD/HUD_SCORE_0.png", "noclamp"))
					surface.DrawTexturedRect(ScaleX(530), ScaleH(18), ScaleW(64), ScaleH(64))
					surface.DrawTexturedRect(ScaleX(550), ScaleH(18), ScaleW(64), ScaleH(64))
					surface.DrawTexturedRect(ScaleX(570), ScaleH(18), ScaleW(64), ScaleH(64))
				else
					surface.SetMaterial(Material(thirddeaths, "noclamp"))
					surface.DrawTexturedRect(ScaleX(530), ScaleH(18), ScaleW(64), ScaleH(64))
					surface.SetMaterial(Material(seconddeaths, "noclamp"))
					surface.DrawTexturedRect(ScaleX(550), ScaleH(18), ScaleW(64), ScaleH(64))
					surface.SetMaterial(Material(firstdeaths, "noclamp"))
					surface.DrawTexturedRect(ScaleX(570), ScaleH(18), ScaleW(64), ScaleH(64))
				end
		
				
				if (plykill < 2)then
					surface.SetMaterial(Material("gearsyfox/CA HUD/FFA_KILL.png", "noclamp"))
				else 
					surface.SetMaterial(Material("gearsyfox/CA HUD/FFA_KILL1.png", "noclamp"))
				end
				surface.DrawTexturedRect(ScaleX(470), ScaleH(27), ScaleW(128), ScaleH(32))
				
				if GetConVar("ca_hud_accolades_enable"):GetBool() == false then
					plykill = ply:Frags()
				end
				
				local Killfstd = math.floor(plykill % 10)
				local firstkills = "gearsyfox/CA HUD/HUD_SCORE_" .. tostring(Killfstd) .. ".png"
				local Killsecd = math.floor((plykill % 100) / 10)
				local secondkills = "gearsyfox/CA HUD/HUD_SCORE_" .. tostring(Killsecd) .. ".png"
				local Killsthrd = math.floor(plykill / 100)
				local thirdkills = "gearsyfox/CA HUD/HUD_SCORE_" .. tostring(Killsthrd) .. ".png"
		
				if plykill >= 1000 then	
					surface.SetMaterial(Material("gearsyfox/CA HUD/HUD_SCORE_9.png", "noclamp"))
					surface.DrawTexturedRect(ScaleX(400), ScaleH(18), ScaleW(64), ScaleH(64))
					surface.DrawTexturedRect(ScaleX(420), ScaleH(18), ScaleW(64), ScaleH(64))
					surface.DrawTexturedRect(ScaleX(440), ScaleH(18), ScaleW(64), ScaleH(64))
				elseif plykill < 0 then
					surface.SetMaterial(Material("gearsyfox/CA HUD/HUD_SCORE_0.png", "noclamp"))
					surface.DrawTexturedRect(ScaleX(400), ScaleH(18), ScaleW(64), ScaleH(64))
					surface.DrawTexturedRect(ScaleX(420), ScaleH(18), ScaleW(64), ScaleH(64))
					surface.DrawTexturedRect(ScaleX(440), ScaleH(18), ScaleW(64), ScaleH(64))
				else
					surface.SetMaterial(Material(thirdkills, "noclamp"))
					surface.DrawTexturedRect(ScaleX(400), ScaleH(18), ScaleW(64), ScaleH(64))
					surface.SetMaterial(Material(secondkills, "noclamp"))
					surface.DrawTexturedRect(ScaleX(420), ScaleH(18), ScaleW(64), ScaleH(64))
					surface.SetMaterial(Material(firstkills, "noclamp"))
					surface.DrawTexturedRect(ScaleX(440), ScaleH(18), ScaleW(64), ScaleH(64))
				end
			end	
			
			-- radar 
			if IsValid(ply) and ply:Alive() and GetConVar("ca_hud_radar_enable"):GetBool() then
				surface.SetMaterial(Material("gearsyfox/CA RADAR/RADAR_MASK1.png", "noclamp"))
				surface.DrawTexturedRectRotatedPoint( ScaleX(900), ScaleH(120), 190*1.2, 190*1.2,(ply:LocalEyeAngles().y), 0, 0 )
				
				for k,v in pairs(ents.FindInSphere(ply:GetPos(), 700)) do
					if v:IsNPC() or v:IsPlayer() or IsEntity(v) and v~= ply then
						local radius=math.sqrt((ply:GetPos().x-v:GetPos().x)^2+(ply:GetPos().y-v:GetPos().y)^2)
						local dir = (v:GetPos()-ply:GetPos()):Angle().y * -1
						local x = math.Round(math.sin(math.rad(dir))*radius/7)
						local y = math.Round(math.cos(math.rad(dir))*radius/9)
						local FF = v:GetClass()
						surface.SetDrawColor(255,255,255,255)
						if math.sqrt(x^2+y^2) <= 200 then
								if IsFriendEntityName(FF) then
									surface.SetMaterial(Material("gearsyfox/CA RADAR/RADAR_TEAM.png", "noclamp"))
									surface.DrawTexturedRect(ScaleX(895)+x,ScaleH(110)-y,19,19)
								elseif GetConVar("ca_hud_radar_show_enemies"):GetBool() and IsEnemyEntityName(FF) then
									surface.SetMaterial(Material("gearsyfox/CA RADAR/RADAR_ENEMY.png", "noclamp"))
									surface.DrawTexturedRect(ScaleX(895)+x,ScaleH(110)-y,19,19)
								elseif table.HasValue( {"func_recharge", "func_healthcharger", "item_battery", "item_healthcharger", "item_healthkit", "item_healthvial", "item_item_crate", "item_suitcharger", "npc_antlion_grub" }, v:GetClass()) then
									surface.SetMaterial(Material("gearsyfox/CA RADAR/COOPRADER_LIFE.png", "noclamp"))
									surface.DrawTexturedRect(ScaleX(895)+x,ScaleH(110)-y,16,16)
								elseif table.HasValue( {"item_ammo_357", "item_ammo_357_large", "item_ammo_ar2", "item_ammo_ar2_large", "item_ammo_ar2_altfire", "item_ammo_pistol", "item_ammo_pistol_large", "item_ammo_smg1", "item_ammo_smg1_large", "item_ammo_crossbow", "item_ammo_crate", "item_ammo_smg1_grenade", "item_box_buckshot", "item_rpg_round", }, v:GetClass()) then
									surface.SetMaterial(Material("gearsyfox/CA RADAR/COOPRADER_BULLET.png", "noclamp"))
									surface.DrawTexturedRect(ScaleX(895)+x,ScaleH(110)-y,20,20)
								end
						end
					
					end
				end	
			end	
	end
	
	if IsValid(ply) and ply:Alive() and IsValid(wep) and wep:Clip1() >= 0 and ply:GetAmmoCount(wep:GetPrimaryAmmoType()) >= 0 then
		surface.SetDrawColor(255, 255, 255, 255)
		
		-- draw reserve ammo
		local Resvfstd = math.floor(ply:GetAmmoCount(wep:GetPrimaryAmmoType()) % 10)
		local firstresv = "gearsyfox/CA HUD/HUD_BULLET_SMALL_" .. tostring(Resvfstd) .. ".png"
		local ResvSecd = math.floor((ply:GetAmmoCount(wep:GetPrimaryAmmoType()) % 100) / 10)
		local secondresv = "gearsyfox/CA HUD/HUD_BULLET_SMALL_" .. tostring(ResvSecd) .. ".png"
		local ResvThrd = math.floor(ply:GetAmmoCount(wep:GetPrimaryAmmoType()) / 100)
		local thirdresv = "gearsyfox/CA HUD/HUD_BULLET_SMALL_" .. tostring(ResvThrd) .. ".png"
		
		if ply:GetAmmoCount(wep:GetPrimaryAmmoType()) >= 1000 then
			surface.SetMaterial(Material("gearsyfox/CA HUD/HUD_BULLET_SMALL_9.png", "noclamp"))
			surface.DrawTexturedRect(ScaleX(980), ScaleH(713), ScaleW(32), ScaleH(32))
			surface.DrawTexturedRect(ScaleX(990), ScaleH(713), ScaleW(32), ScaleH(32))
			surface.DrawTexturedRect(ScaleX(1000), ScaleH(713), ScaleW(32), ScaleH(32))
		else
			surface.SetMaterial(Material(thirdresv, "noclamp"))
			surface.DrawTexturedRect(ScaleX(980), ScaleH(713), ScaleW(32), ScaleH(32))
			surface.SetMaterial(Material(secondresv, "noclamp"))
			surface.DrawTexturedRect(ScaleX(990), ScaleH(713), ScaleW(32), ScaleH(32))
			surface.SetMaterial(Material(firstresv, "noclamp"))
			surface.DrawTexturedRect(ScaleX(1000), ScaleH(713), ScaleW(32), ScaleH(32))
		end
		
		-- draw that / letter
		surface.SetMaterial(Material("gearsyfox/CA HUD/HUD_BULLET_SMALL_.png", "noclamp"))
		surface.DrawTexturedRect(ScaleX(970), ScaleH(713), ScaleW(32), ScaleH(32))
		
		-- draw clip ammo
		local Clipfstd = math.floor(wep:Clip1() % 10)
		local firstclip = "gearsyfox/CA HUD/HUD_BULLET_BIG_" .. tostring(Clipfstd) .. ".png"
		local ClipSecd = math.floor((wep:Clip1() % 100) / 10)
		local secondclip = "gearsyfox/CA HUD/HUD_BULLET_BIG_" .. tostring(ClipSecd) .. ".png"
		local ClipThrd = math.floor(wep:Clip1() / 100)
		local thirdclip = "gearsyfox/CA HUD/HUD_BULLET_BIG_" .. tostring(ClipThrd) .. ".png"
		
		if wep:Clip1() >= 1000 then
			surface.SetMaterial(Material("gearsyfox/CA HUD/HUD_BULLET_BIG_9.png", "noclamp"))
			surface.DrawTexturedRect(ScaleX(958), ScaleH(713), ScaleW(32), ScaleH(32))
			surface.DrawTexturedRect(ScaleX(942), ScaleH(713), ScaleW(32), ScaleH(32))
			surface.DrawTexturedRect(ScaleX(925), ScaleH(713), ScaleW(32), ScaleH(32))
		else
			surface.SetMaterial(Material(firstclip, "noclamp"))
			surface.DrawTexturedRect(ScaleX(958), ScaleH(713), ScaleW(32), ScaleH(32))
			surface.SetMaterial(Material(secondclip, "noclamp"))
			surface.DrawTexturedRect(ScaleX(942), ScaleH(713), ScaleW(32), ScaleH(32))
			surface.SetMaterial(Material(thirdclip, "noclamp"))
			surface.DrawTexturedRect(ScaleX(925), ScaleH(713), ScaleW(32), ScaleH(32))
		end
		
		-- weapon base firemode (unfinished)
		callgunbase(wep)
		
		
		end
		
		
		
	end
end)

hook.Add( "OnNPCKilled", "ExplosionEffectOnNPCDeath", function( npc, attacker, inflictor )
	local effectData = EffectData()
	effectData:SetOrigin( npc:GetPos() )
	util.Effect( "Explosion", effectData )
end)


hook.Add("HUDShouldDraw", "Hud_Hide", function(name)
	if (GetConVar("ca_hud_enable"):GetBool()) then
		if name == "CHudHealth" or name == "CHudBattery" or name == "CHudAmmo" or name == "CHudSecondaryAmmo" or name == "CHudSuitPower" then return false end
	end
end)


CreateConVar( "ca_hud_kdr_enable", 1, FCVAR_ARCHIVE )
CreateConVar( "ca_hud_ultrawide_scale", 1, FCVAR_ARCHIVE )
CreateConVar( "ca_hud_radar_enable", 1, FCVAR_ARCHIVE )

