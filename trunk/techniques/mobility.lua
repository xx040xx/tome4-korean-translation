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

local Map = require "engine.Map"

newTalent{
	name = "Hack'n'Back",
	kr_display_name = "치고 빠지기",
	type = {"technique/mobility", 1},
	points = 5,
	cooldown = 14,
	stamina = 30,
	tactical = { ESCAPE = 1, ATTACK = { weapon = 0.5 } },
	require = techs_dex_req1,
	requires_target = true,
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.4, 1) end,
	getDist = function(self, t) return 1 + math.ceil(self:getTalentLevel(t) / 2) end,
	on_pre_use = function(self, t)
		if self:attr("never_move") then return false end
		return true
	end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		local hitted = self:attackTarget(target, nil, t.getDamage(self, t), true)

		if hitted then
			self:knockback(target.x, target.y, t.getDist(self, t))
		end

		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local dist = t.getDist(self, t)
		return ([[대상을 공격하여 %d%% 의 피해를 입히고, %d 칸 뒤로 빠집니다.]]):
		format(100 * damage, dist)
	end,
}

newTalent{
	name = "Mobile Defence",
	kr_display_name = "가볍지만 단단하게",
	type = {"technique/mobility", 2},
	mode = "passive",
	points = 5,
	require = techs_dex_req2,
	getDef = function(self, t) return self:getTalentLevel(t) * 0.08 end,
	getHardiness = function(self, t) return self:getTalentLevel(t) * 0.06 end,
	info = function(self, t)
		return ([[경갑이나 가죽 갑옷을 입으면 회피도가 %d%%, 방어 효율이 %d%% 증가합니다.]]):
		format(t.getDef(self, t) * 100, t.getHardiness(self, t) * 100)
	end,
}

newTalent{
	name = "Light of Foot",
	kr_display_name = "가벼운 발놀림",
	type = {"technique/mobility", 3},
	mode = "passive",
	points = 5,
	require = techs_dex_req3,
	on_learn = function(self, t)
		self.fatigue = (self.fatigue or 0) - 1.5
		if self:getTalentLevelRaw(t) == 3 then self:attr("avoid_pressure_traps", 1) end
	end,
	on_unlearn = function(self, t)
		self.fatigue = (self.fatigue or 0) + 1.5
		if self:getTalentLevelRaw(t) == 2 then self:attr("avoid_pressure_traps", -1) end
	end,
	info = function(self, t)
		return ([[발놀림이 가벼워져, 갑옷의 무게를 덜 느끼게 됩니다. 발걸음을 옮길 때마다 체력이 %0.2f 만큼 추가로 재생되며, 영구적으로 피로도가 %d%% 감소합니다.
		기술 레벨이 3 이상이 되면 발놀림이 극도로 가벼워져, 밟으면 작동되는 함정 위에 올라서도 함정이 발동하지 않습니다.]]):
		format(self:getTalentLevelRaw(t) * 0.2, self:getTalentLevelRaw(t) * 1.5)
	end,
}

newTalent{
	name = "Strider",
	kr_display_name = "전장의 춤꾼",
	type = {"technique/mobility", 4},
	mode = "passive",
	points = 5,
	require = techs_dex_req4,
	on_learn = function(self, t)
		self.movement_speed = self.movement_speed + 0.02
		self.talent_cd_reduction[Talents.T_RUSH] = (self.talent_cd_reduction[Talents.T_RUSH] or 0) + 1
		self.talent_cd_reduction[Talents.T_HACK_N_BACK] = (self.talent_cd_reduction[Talents.T_HACK_N_BACK] or 0) + 1
		self.talent_cd_reduction[Talents.T_DISENGAGE] = (self.talent_cd_reduction[Talents.T_DISENGAGE] or 0) + 1
		self.talent_cd_reduction[Talents.T_EVASION] = (self.talent_cd_reduction[Talents.T_EVASION] or 0) + 1
	end,
	on_unlearn = function(self, t)
		self.movement_speed = self.movement_speed - 0.02
		self.talent_cd_reduction[Talents.T_RUSH] = (self.talent_cd_reduction[Talents.T_RUSH] or 0) - 1
		self.talent_cd_reduction[Talents.T_HACK_N_BACK] = (self.talent_cd_reduction[Talents.T_HACK_N_BACK] or 0) - 1
		self.talent_cd_reduction[Talents.T_DISENGAGE] = (self.talent_cd_reduction[Talents.T_DISENGAGE] or 0) - 1
		self.talent_cd_reduction[Talents.T_EVASION] = (self.talent_cd_reduction[Talents.T_EVASION] or 0) - 1
	end,
	info = function(self, t)
		return ([[적들의 사이에서 춤을 추듯 부드럽게 움직일 수 있게 됩니다. 이동 속도가 %d%% 빨라지며, '치고 빠지기', '돌진', '작전상 후퇴', '회피술' 의 지연 시간을 %d 턴 줄여줍니다.]]):
		format(self:getTalentLevelRaw(t) * 2, self:getTalentLevelRaw(t))
	end,
}

