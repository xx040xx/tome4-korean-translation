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

isOnMucus = function(map, x, y)
	for i, e in ipairs(map.effects) do
		if e.damtype == DamageType.MUCUS and e.grids[x] and e.grids[x][y] then return true end
	end
end

newTalent{
	name = "Mucus",
	kr_display_name = "점액",
	type = {"wild-gift/mucus", 1},
	require = gifts_req1,
	points = 5,
	equilibrium = 0,
	cooldown = 20,
	no_energy = true,
	tactical = { BUFF = 2 },
	getDur = function(self, t) return math.max(8,  math.floor(self:getTalentLevel(t) * 1.3)) end,
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 5, 90) end,
	getEqui = function(self, t) return self:combatTalentMindDamage(t, 5, 20) end,
	trigger = function(self, t, x, y, rad) 
		game.level.map:addEffect(self,
			x, y, t.getDur(self, t),
			DamageType.MUCUS, {dam=t.getDamage(self, t), equi=t.getEqui(self, t)},
			rad,
			5, nil,
			{type="mucus"},
			nil, true
		)
	end,
	action = function(self, t)
		local dur = t.getDur(self, t)
		self:setEffect(self.EFF_MUCUS, dur, {})
		return true
	end,
	info = function(self, t)
		local dur = t.getDur(self, t)
		local dam = t.getDamage(self, t)
		local equi = t.getEqui(self, t)
		return ([[서있거나 지나간 자리에 %d 턴 동안 점액을 만들어냅니다.
		점액을 밟은 적은 독에 걸려, 5 턴 동안 매 턴마다 %0.2f 자연 피해를 입게 됩니다. (이 피해는 중첩됩니다)
		동료가 점액을 밟을 경우 매 턴마다 평정을 %d 회복하게 됩니다.
		점액은 %d 턴 동안 유지됩니다.
		기술 레벨이 4 이상이면, 점액이 주변 1 칸 반경까지 퍼지게 됩니다.
		피해량과 평정 회복량은 정신력의 영향을 받아 증가합니다.]]):
		format(dur, damDesc(self, DamageType.NATURE, dam), equi, dur)
	end,
}

newTalent{
	name = "Acid Splash",
	kr_display_name = "산성 튀기기",
	type = {"wild-gift/mucus", 2},
	require = gifts_req2,
	points = 5,
	equilibrium = 10,
	cooldown = 10,
	range = 7,
	radius = function(self, t) return 3 + (self:getTalentLevel(t) >= 5 and 1 or 0) end,
	target = function(self, t) return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), friendlyfire=false} end,
	tactical = { ATTACKAREA = { ACID = 2, NATURE = 1 } },
	requires_target = true,
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 20, 220) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end

		local grids, px, py = self:project(tg, x, y, DamageType.ACID, self:mindCrit(t.getDamage(self, t)))
		if self:knowTalent(self.T_MUCUS) then self:callTalent(self.T_MUCUS, nil, px, py, tg.radius) end
		game.level.map:particleEmitter(px, py, tg.radius, "acidflash", {radius=tg.radius, tx=px, ty=py})

		local tgts = {}
		for x, ys in pairs(grids) do for y, _ in pairs(ys) do
			local target = game.level.map(x, y, Map.ACTOR)
			if target and self:reactionToward(target) < 0 then tgts[#tgts+1] = target end
		end end

		if #tgts > 0 then
			if game.party:hasMember(self) then
				for act, def in pairs(game.party.members) do
					local target = rng.table(tgts)
					if act.summoner and act.summoner == self and act.is_mucus_ooze then
						act.inc_damage.all = (act.inc_damage.all or 0) - 50
						act:forceUseTalent(act.T_MUCUS_OOZE_SPIT, {force_target=target, ignore_energy=true})
						act.inc_damage.all = (act.inc_damage.all or 0) + 50
					end
				end
			else
				for _, act in pairs(game.level.entities) do
					local target = rng.table(tgts)
					if act.summoner and act.summoner == self and act.is_mucus_ooze then
						act.inc_damage.all = (act.inc_damage.all or 0) - 50
						act:forceUseTalent(act.T_MUCUS_OOZE_SPIT, {force_target=target, ignore_energy=true})
						act.inc_damage.all = (act.inc_damage.all or 0) + 50
					end
				end
			end
		end


		game:playSoundNear(self, "talents/cloud")
		return true
	end,
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[자연의 힘을 빌어, 주변 %d 칸 반경의 지면에 산성 폭발을 일으킵니다. 폭발에 휩쓸린 적은 %0.2f 산성 피해를 입으며, 폭발한 곳에 점액이 남게 됩니다.
		또 당신이 진흙 점액을 데리고 있고 그것이 직선상에 있다면, 산성 폭발에 닿은 대상 중 하나에게 즉시 (감소된 위력으로) 슬라임을 뱉습니다.
		피해량은 정신력의 영향을 받아 증가합니다.]]):
		format(self:getTalentRadius(t), damDesc(self, DamageType.ACID, dam))
	end,
}

newTalent{ short_name = "MUCUS_OOZE_SPIT", 
	name = "Slime Spit", image = "talents/slime_spit.png",
	kr_display_name = "슬라임 뱉기",
	type = {"wild-gift/other",1},
	points = 5,
	equilibrium = 2,
	mesage = "@Source1@ 슬라임을 뱉습니다!",
	range = 6,
	reflectable = true,
	requires_target = true,
	tactical = { ATTACK = { NATURE = 2 } },
	action = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.SLIME, self:mindCrit(self:combatTalentMindDamage(t, 8, 80)), {type="slime"})
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[%0.2f 슬라임 피해를 주는 슬라임 화살을 뱉습니다.
		피해량은 정신력의 영향을 받아 증가합니다.]]):format(damDesc(self, DamageType.SLIME, self:combatTalentMindDamage(t, 8, 80)))
	end,
}

newTalent{
	name = "Living Mucus",
	kr_display_name = "살아있는 점액",
	type = {"wild-gift/mucus", 3},
	require = gifts_req3,
	points = 5,
	mode = "passive",
	getMax = function(self, t) return math.floor(self:getCun() / 10) end,
	getChance = function(self, t) return 10 + self:combatTalentMindDamage(t, 5, 300) / 10 end,
	spawn = function(self, t)
		if checkMaxSummon(self, true) or not self:canBe("summon") then return end

		local ps = {}
		for i, e in ipairs(game.level.map.effects) do
			if e.damtype == DamageType.MUCUS then
				for x, ys in pairs(e.grids) do for y, _ in pairs(ys) do
					if self:canMove(x, y) then ps[#ps+1] = {x=x, y=y} end
				end end
			end
		end
		if #ps == 0 then return end
		local p = rng.table(ps)

		local m = mod.class.NPC.new{
			type = "vermin", subtype = "oozes",
			display = "j", color=colors.GREEN, image = "npc/vermin_oozes_green_ooze.png",
			name = "mucus ooze",
			kr_display_name = "진흙 점액",
			desc = "It's made from mucus and it's oozing.",
			sound_moam = {"creatures/jelly/jelly_%d", 1, 3},
			sound_die = {"creatures/jelly/jelly_die_%d", 1, 2},
			sound_random = {"creatures/jelly/jelly_%d", 1, 3},
			body = { INVEN = 10 },
			autolevel = "wildcaster",
			ai = "summoned", ai_real = "dumb_talented_simple", ai_state = { talent_in=1, },
			stats = { str=10, dex=10, mag=3, con=self:getTalentLevel(t) / 5 * 4, wil=self:getWil(), cun=self:getCun() },
			global_speed_base = 0.7,
			combat = {sound="creatures/jelly/jelly_hit"},
			combat_armor = 1, combat_def = 1,
			rank = 1,
			size_category = 3,
			infravision = 10,
			cut_immune = 1,
			blind_immune = 1,

			resists = { [DamageType.LIGHT] = -50, [DamageType.COLD] = -50 },
			fear_immune = 1,

			blood_color = colors.GREEN,
			level_range = {self.level, self.level}, exp_worth = 0,
			max_life = 30,

			combat = { dam=5, atk=0, apr=5, damtype=DamageType.POISON },

			summoner = self, summoner_gain_exp=true, wild_gift_summon=true, is_mucus_ooze = true,
			summon_time = math.ceil(self:getTalentLevel(t)) + 5,
			max_summon_time = math.ceil(self:getTalentLevel(t)) + 5,
		}
		m:learnTalent(m.T_MUCUS_OOZE_SPIT, true, self:getTalentLevelRaw(t))
		if self:knowTalent(self.T_BLIGHTED_SUMMONING) then m:learnTalent(m.T_VIRULENT_DISEASE, true, 3) end

		setupSummon(self, m, p.x, p.y)
		return true
	end,
	on_crit = function(self, t)
		if game.party:hasMember(self) then
			for act, def in pairs(game.party.members) do
				if act.summoner and act.summoner == self and act.is_mucus_ooze then
					act.summon_time = util.bound(act.summon_time + 2, 1, act.max_summon_time)
				end
			end
		else
			for _, act in pairs(game.level.entities) do
				if act.summoner and act.summoner == self and act.is_mucus_ooze then
					act.summon_time = util.bound(act.summon_time + 2, 1, act.max_summon_time)
				end
			end
		end

	end,
	info = function(self, t)
		return ([[당신의 점액은 감지력과 비슷한 능력을 가지고 있습니다. 매 턴마다 %d%% 의 확률로 당신의 점액은 임의의 장소에 진흙 점액을 낳습니다.
		진흙 점액은 당신의 적에게 슬라임을 뱉는 공격을 합니다.
		(당신의 교활함에 따라) 당신은 최대 %d 마리의 진흙 점액을 가질 수 있습니다.
		당신이 정신적 치명타 공격을 성공시킬때 마다, 모든 진흙 점액의 유지 시간이 2 턴 증가합니다.
		이 효과는 정신력의 영향을 받아 증가합니다.]]):
		format(t.getChance(self, t), t.getMax(self, t))
	end,
}

newTalent{
	name = "Oozewalk",
	kr_display_name = "진흙 덩어리의 길",
	type = {"wild-gift/mucus", 4},
	require = gifts_req4,
	points = 5,
	cooldown = 7,
	equilibrium = 10,
	range = 10,
	getNb = function(self, t) return 1 + math.ceil(self:getTalentLevel(t) / 3, 0, 3) end,
	getEnergy = function(self, t)
		local l = self:getTalentLevel(t)
		if l <= 1 then return 1
		elseif l <= 2 then return 0.9
		elseif l <= 3 then return 0.7
		elseif l <= 4 then return 0.5
		elseif l <= 5 then return 0.4
		elseif l <= 6 then return 0.3
		elseif l <= 7 then return 0.2
		elseif l <= 8 then return 0.1
		end
	end,
	on_pre_use = function(self, t)
		return game.level and game.level.map and isOnMucus(game.level.map, self.x, self.y)
	end,
	action = function(self, t)
		local tg = {type="hit", nolock=true, pass_terrain=true, nowarning=true, range=self:getTalentRange(t), requires_knowledge=false}
		x, y = self:getTarget(tg)
		if not x then return nil end
		-- Target code does not restrict the target coordinates to the range, it lets the project function do it
		-- but we cant ...
		local _ _, x, y = self:canProject(tg, x, y)
		if not x then return nil end
		if not isOnMucus(game.level.map, x, y) then return nil end
		if not self:canMove(x, y) then return nil end

		local energy = 1 - t.getEnergy(self, t)
		self.energy.value = self.energy.value + game.energy_to_act * self.energy.mod * energy

		self:removeEffectsFilter(function(t) return t.type == "physical" or t.type == "magical" end, t.getNb(self, t))

		game.level.map:particleEmitter(self.x, self.y, 1, "slime")
		self:move(x, y, true)
		game.level.map:particleEmitter(self.x, self.y, 1, "slime")

		return true
	end,
	info = function(self, t)
		local nb = t.getNb(self, t)
		local energy = t.getEnergy(self, t)
		return ([[당신은 일시적으로 당신의 점액과 결합하여, %d 가지의 물리 효과나 주문 효과를 제거합니다.
		당신은 시야내의 점액으로 뒤덮힌 장소 중 임의의 위치에 다시 나타날 수 있습니다.
		이 과정은 한 턴의 %d%% 만큼 시간이 걸립니다.
		이 기술은 점액 위에 서 있을때에만 사용할 수 있습니다.]]):
		format(nb, (energy) * 100)
	end,
}
