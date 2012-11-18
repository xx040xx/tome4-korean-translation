﻿-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009, 2010, 2011, 2012 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org

--local Object = require "engine.Object"

newTalent{
	name = "Twilight",
	display_name = "황혼",
	type = {"celestial/twilight", 1},
	require = divi_req1,
	points = 5,
	cooldown = 6,
	positive = 15,
	tactical = { BUFF = 1 },
	range = 10,
	getNegativeGain = function(self, t) return 20 + self:getTalentLevel(t) * self:getCun(40, true) end,
	action = function(self, t)
		if self:isTalentActive(self.T_DARKEST_LIGHT) then
			game.logPlayer(self, "가장 어두운 빛이 활성화된 상태에서는 황혼 주문을 사용할 수 없습니다.")
			return
		end
		self:incNegative(t.getNegativeGain(self, t))
		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local neggain = t.getNegativeGain(self, t)
		return ([[어둠과 빛의 가운데에 선 자의 권능으로, 15의 양기를 %d 의 음기로 전환합니다.
		이 효과는 교활함 능력치의 영향을 받아 증가됩니다.]]):
		format(neggain)
	end,
}

newTalent{
	name = "Jumpgate: Teleport To", short_name = "JUMPGATE_TELEPORT",
	display_name = "도약문: 이동",
	type = {"celestial/other", 1},
	points = 1,
	cooldown = 7,
	negative = 14,
	type_no_req = true,
	tactical = { ESCAPE = 2 },
	no_npc_use = true,
	getRange = function(self, t) return math.floor(10 + 3 * self:getTalentLevel(t)) end,
	-- Check distance in preUseTalent to grey out the talent
	on_pre_use = function(self, t)
		local eff = self.sustain_talents[self.T_JUMPGATE]
		return eff and core.fov.distance(self.x, self.y, eff.jumpgate_x, eff.jumpgate_y) < t.getRange(self, t)
	end,
	is_teleport = true,
	action = function(self, t)
		local eff = self.sustain_talents[self.T_JUMPGATE]
		if not eff then
			game.logPlayer(self, "순간이동을 하려면 도약문 주문이 유지된 상태여야 합니다.")
			return
		end
		game.level.map:particleEmitter(self.x, self.y, 1, "teleport")
		self:teleportRandom(eff.jumpgate_x, eff.jumpgate_y, 1)
		game.level.map:particleEmitter(eff.jumpgate_x, eff.jumpgate_y, 1, "teleport")
		game:playSoundNear(self, "talents/teleport")
		return true
	end,
	info = function(self, t)
		return ([[%d 타일 내에 있는 도약문으로 즉시 이동합니다.]]):format(t.getRange(self, t))
 	end,
}

newTalent{
	name = "Jumpgate",
	display_name = "도약문",
	type = {"celestial/twilight", 2},
	require = divi_req2,
	mode = "sustained", no_sustain_autoreset = true,
	points = 5,
	cooldown = function(self, t) return 24 - 4 * self:getTalentLevelRaw(t) end,
	sustain_negative = 20,
	no_npc_use = true,
	tactical = { ESCAPE = 2 },
 	on_learn = function(self, t)
		if self:getTalentLevel(t) >= 4 and not self:knowTalent(self.T_JUMPGATE_TWO) then
			self:learnTalent(self.T_JUMPGATE_TWO, nil, nil, {no_unlearn=true})
 		end
			self:learnTalent(self.T_JUMPGATE_TELEPORT, nil, nil, {no_unlearn=true})
	end,
 	on_unlearn = function(self, t)
		if self:getTalentLevel(t) < 4 and self:knowTalent(self.T_JUMPGATE_TWO) then
 			self:unlearnTalent(self.T_JUMPGATE_TWO)
 		end
			self:unlearnTalent(self.T_JUMPGATE_TELEPORT)
 	end,
	activate = function(self, t)
		local oe = game.level.map(self.x, self.y, engine.Map.TERRAIN)
		if not oe or oe:attr("temporary") then return false end
		local e = mod.class.Object.new{
			old_feat = oe, type = oe.type, subtype = oe.subtype,
			name = "jumpgate", image = oe.image, add_mos = {{image = "terrain/wormhole.png"}},
			display = '&', color=colors.PURPLE,
			temporary = 1, -- This prevents overlapping of terrain changing effects; as this talent is a sustain it does nothing else
		}
		game.level.map(game.player.x, game.player.y, engine.Map.TERRAIN, e)
		
		local ret = {
			jumpgate = e, jumpgate_x = game.player.x, jumpgate_y = game.player.y,
			jumpgate_level = game.zone.short_name .. "-" .. game.level.level,
			particle = self:addParticles(Particles.new("time_shield", 1))
		}
		return ret
	end,
	deactivate = function(self, t, p)
		-- Reset the terrain tile
		game.level.map(p.jumpgate_x, p.jumpgate_y, engine.Map.TERRAIN, p.jumpgate.old_feat)
		self:removeParticles(p.particle)
		return true
	end,
	info = function(self, t)
		local jumpgate_teleport = self:getTalentFromId(self.T_JUMPGATE_TELEPORT)
		local range = jumpgate_teleport.getRange(self, jumpgate_teleport)
		return ([[위치한 장소에 그림자 도약문을 생성합니다. 이 주문이 유지되는 동안에는 '도약문: 이동' 주문을 사용하여 %d 타일 내에 있는 도약문으로 즉시 이동할 수 있습니다.
		도약문이 생성된 위치에 있는 계단은 사용할 수 없으므로, 계단을 이용하려면 도약문 주문의 유지를 해제해야 합니다.
		기술 레벨이 4 이상이면 두번째 도약문을 생성할 수 있습니다.]]):format(range)
 	end,
 }


newTalent{
	name = "Mind Blast",
	display_name = "정신 붕괴",
	type = {"celestial/twilight",3},
	require = divi_req3,
	points = 5,
	random_ego = "attack",
	cooldown = 15,
	negative = 15,
	tactical = { DISABLE = 3 },
	radius = 3,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t, selffire=false}
	end,
	getConfuseDuration = function(self, t) return math.floor(self:getTalentLevel(t) + self:getCun(5)) + 2 end,
	getConfuseEfficency = function(self, t) return 50 + self:getTalentLevelRaw(t)*10 end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		self:project(tg, self.x, self.y, DamageType.CONFUSION, {
			dur = t.getConfuseDuration(self, t),
			dam = t.getConfuseEfficency(self, t)
		})
		game:playSoundNear(self, "talents/flame")
		return true
	end,
	info = function(self, t)
		local duration = t.getConfuseDuration(self, t)
		return ([[마음의 절규를 내질러서, 3 타일 반경 내 모든 대상의 의지를 꺽어 %d 턴 동안 혼란 상태로 만듭니다.
		지속 시간은 교활함 능력치에 영향을 받아 증가됩니다.]]):
		format(duration)
	end,
}

newTalent{
	name = "Shadow Simulacrum",
	display_name = "그림자 투영",
	type = {"celestial/twilight", 4},
	require = divi_req4,
	random_ego = "attack",
	points = 5,
	cooldown = 30,
	negative = 10,
	tactical = { DISABLE = 2 },
	requires_target = true,
	range = 5,
	no_npc_use = true,
	getDuration = function(self, t) return math.ceil(self:getTalentLevel(t)+self:getCun(10)) + 3 end,
	action = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t), talent=t}
		local tx, ty, target = self:getTarget(tg)
		if not tx or not ty then return nil end
		local _ _, tx, ty = self:canProject(tg, tx, ty)
		local target = game.level.map(tx, ty, Map.ACTOR)
		if not target or self:reactionToward(target) >= 0 then return end

		-- Find space
		local x, y = util.findFreeGrid(tx, ty, 1, true, {[Map.ACTOR]=true})
		if not x then
			game.logPlayer(self, "소활할 공간이 부족합니다!")
			return
		end

		allowed = 2 + math.ceil(self:getTalentLevelRaw(t) / 2 )

		if target.rank >= 3.5 or -- No boss
			target:reactionToward(self) >= 0 or -- No friends
			target.size_category > allowed
			then
			game.logPlayer(self, "%s 가 저항합니다!", target.name:capitalize())
			return true
		end

		modifier = self:getCun(10, true) * self:getTalentLevel(t)

		local m = target:clone{
			shader = "shadow_simulacrum",
			no_drops = true,
			faction = self.faction,
			summoner = self, summoner_gain_exp=true,
			summon_time = t.getDuration(self, t),
			ai_target = {actor=target},
			ai = "summoned", ai_real = target.ai,
			resists = { all = modifier, [DamageType.DARKNESS] = 50, [DamageType.LIGHT] = - 50, },
			desc = [[A dark shadowy shape who's form resembles the creature it was taken from.]],
		}
		m:removeAllMOs()
		m.make_escort = nil
		m.on_added_to_level = nil

		m.energy.value = 0
		m.life = m.life / (2 - math.min(modifier / 50, 1.9))
		m.forceLevelup = function() end
		-- Handle special things
		m.on_die = nil
		m.puuid = nil
		m.on_acquire_target = nil
		m.seen_by = nil
		m.can_talk = nil
		m.exp_worth = 0
		m.clone_on_hit = nil
		if m.talents.T_SUMMON then m.talents.T_SUMMON = nil end
		if m.talents.T_MULTIPLY then m.talents.T_MULTIPLY = nil end

		game.zone:addEntity(game.level, m, "actor", x, y)
		game.level.map:particleEmitter(x, y, 1, "shadow")

		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local allowed = 2 + math.ceil(self:getTalentLevelRaw(t) / 2 )
		if allowed < 4 then
			size = "medium"
		elseif allowed < 5 then
			size = "big"
		else
			size = "huge"
		end
		return ([[%s 크기 이하의 대상에게서 그림자를 본뜹니다. 복제된 대상은 즉시 자신의 본체를 공격합니다.
		%d 턴 동안 유지되며, 복제된 대상의 지속시간과 생명력, 저항은 교활함 능력치에 영향을 받습니다.]]):
		format(size, duration)
	end,
}

-- Extra Jumpgates

newTalent{
	name = "Jumpgate Two",
	display_name = "두번째 도약문",
	type = {"celestial/other", 1},
	mode = "sustained", no_sustain_autoreset = true,
	points = 1,
	cooldown = 20,
	sustain_negative = 20,
	no_npc_use = true,
	type_no_req = true,
	tactical = { ESCAPE = 2 },
	on_learn = function(self, t)
		if not self:knowTalent(self.T_JUMPGATE_TELEPORT_TWO) then
			self:learnTalent(self.T_JUMPGATE_TELEPORT_TWO, nil, nil, {no_unlearn=true})
		end
	end,
	on_unlearn = function(self, t)
		if not self:knowTalent(t) then
			self:unlearnTalent(self.T_JUMPGATE_TELEPORT_TWO)
		end
	end,
	activate = function(self, t)
		local oe = game.level.map(self.x, self.y, engine.Map.TERRAIN)
		if not oe or oe:attr("temporary") then return false end
		local e = mod.class.Object.new{
			old_feat = oe, type = oe.type, subtype = oe.subtype,
			name = "jumpgate", image = oe.image, add_mos = {{image = "terrain/wormhole.png"}},
			display = '&', color=colors.PURPLE,
			temporary = 1, -- This prevents overlapping of terrain changing effects; as this talent is a sustain it does nothing else
		}
		
		game.level.map(game.player.x, game.player.y, engine.Map.TERRAIN, e)
		local ret = {
			jumpgate2 = e, jumpgate2_x = game.player.x,	jumpgate2_y = game.player.y,
			jumpgate2_level = game.zone.short_name .. "-" .. game.level.level,
			particle = self:addParticles(Particles.new("time_shield", 1))
		}
		return ret
	end,
	deactivate = function(self, t, p)
		-- Reset the terrain tile
		game.level.map(p.jumpgate2_x, p.jumpgate2_y, engine.Map.TERRAIN, p.jumpgate2.old_feat)
		self:removeParticles(p.particle)
		return true
	end,
	info = function(self, t)
		local jumpgate_teleport = self:getTalentFromId(self.T_JUMPGATE_TELEPORT_TWO)
		local range = jumpgate_teleport.getRange(self, jumpgate_teleport)
		return ([[위치한 장소에 그림자 도약문을 생성합니다. 이 주문이 유지되는 동안에는 '도약문: 이동' 주문을 사용하여 %d 타일 내에 있는 도약문으로 즉시 이동할 수 있습니다.]]):format(range)
	end,
}

newTalent{
	name = "Jumpgate Two: Teleport To", short_name = "JUMPGATE_TELEPORT_TWO",
	display_name = "두번째 도약문: 이동",
	type = {"celestial/other", 1},
	points = 1,
	cooldown = 7,
	negative = 14,
	type_no_req = true,
	tactical = { ESCAPE = 2 },
	no_npc_use = true,
	getRange = function(self, t) return math.floor(10 + 3 * self:getTalentLevel(t)) end,
	-- Check distance in preUseTalent to grey out the talent
	is_teleport = true,
	on_pre_use = function(self, t)
		local eff = self.sustain_talents[self.T_JUMPGATE_TWO]
		return eff and core.fov.distance(self.x, self.y, eff.jumpgate2_x, eff.jumpgate2_y) < t.getRange(self, t)
	end,
	action = function(self, t)
		local eff = self.sustain_talents[self.T_JUMPGATE_TWO]
		if not eff then
			game.logPlayer(self, "순간이동을 하려면 두번째 도약문 주문이 유지된 상태여야 합니다.")
			return
		end
		game.level.map:particleEmitter(self.x, self.y, 1, "teleport")
		self:teleportRandom(eff.jumpgate2_x, eff.jumpgate2_y, 1)
		game.level.map:particleEmitter(eff.jumpgate2_x, eff.jumpgate2_y, 1, "teleport")
		game:playSoundNear(self, "talents/teleport")
		return true
	end,
	info = function(self, t)
		return ([[%d 타일 내에 있는 두번째 도약문으로 즉시 이동합니다.]]):format(t.getRange(self, t))
	end,
}
