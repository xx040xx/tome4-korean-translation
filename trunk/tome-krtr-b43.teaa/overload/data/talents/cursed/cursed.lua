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

-- Cursed
newTalentType{ allow_random=true, type="cursed/slaughter", name = "slaughter", description = "당신의 무기는 다음 희상자를 갈망한다." }
newTalentType{ allow_random=true, type="cursed/endless-hunt", name = "endless hunt", description = "매일 지친 육체를 이끌고 끝나지 않는 사냥을 시작한다." }
newTalentType{ allow_random=true, type="cursed/strife", name = "strife", description = "죽음과 혼돈이 있는 전장을 집처럼 편한하게 느낀다." }
newTalentType{ allow_random=true, type="cursed/gloom", name = "gloom", description = "시야의 모든 존재가 당신의 절망을 공유한다." }
newTalentType{ allow_random=true, type="cursed/rampage", name = "rampage", description = "내부에서 자라난 증오심을 풀어놓는다." }
newTalentType{ allow_random=true, type="cursed/predator", name = "predator", description = "한가지 집중된 마음으로 사냥감을 쫒아가 죽인다." }

-- Doomed
newTalentType{ allow_random=true, type="cursed/dark-sustenance", name = "dark sustenance", generic = true, description = "의지력으로부터 강력한 힘을 얻는다." }
newTalentType{ allow_random=true, type="cursed/force-of-will", name = "force of will", description = "의지력으로부터 강력한 힘을 얻는다." }
newTalentType{ allow_random=true, type="cursed/darkness", name = "darkness", description = "어둠의 힘으로 적들을 감싸 그들을 괴롭힌다." }
newTalentType{ allow_random=true, type="cursed/shadows", name = "shadows", description = "어둠속에서 그림자를 소환하여 당신을 돕게 만든다." }
newTalentType{ allow_random=true, type="cursed/punishments", name = "punishments", description = "당신의 증오심은 적들의 정신에게 족쇄가 된다." }

-- Generic
newTalentType{ allow_random=true, type="cursed/gestures", name = "gestures", generic = true, description = "몸짓으로 정신의 힘을 높인다." }
newTalentType{ allow_random=true, type="cursed/cursed-form", name = "cursed form", generic = true, description = "저주받은 어둠의 힘으로 당신은 파멸했다." }
newTalentType{ allow_random=true, type="cursed/cursed-aura", name = "cursed aura", generic = true, description = "당신을 둘러싼 것들이 시들어버린다." }
newTalentType{ allow_random=false, type="cursed/curses", name = "curses", hide = true, description = "저주받은 물건들의 효과." }
newTalentType{ allow_random=true, type="cursed/fears", name = "fears", description = "저주받은 심장에서 나오는 공포를 사용하여 적들의 정신을 공격한다." }

cursed_wil_req1 = {
	stat = { wil=function(level) return 12 + (level-1) * 2 end },
	level = function(level) return 0 + (level-1)  end,
}
cursed_wil_req2 = {
	stat = { wil=function(level) return 20 + (level-1) * 2 end },
	level = function(level) return 4 + (level-1)  end,
}
cursed_wil_req3 = {
	stat = { wil=function(level) return 28 + (level-1) * 2 end },
	level = function(level) return 8 + (level-1)  end,
}
cursed_wil_req4 = {
	stat = { wil=function(level) return 36 + (level-1) * 2 end },
	level = function(level) return 12 + (level-1)  end,
}
cursed_wil_req5 = {
	stat = { wil=function(level) return 44 + (level-1) * 2 end },
	level = function(level) return 16 + (level-1)  end,
}

cursed_str_req1 = {
	stat = { str=function(level) return 12 + (level-1) * 2 end },
	level = function(level) return 0 + (level-1)  end,
}
cursed_str_req2 = {
	stat = { str=function(level) return 20 + (level-1) * 2 end },
	level = function(level) return 4 + (level-1)  end,
}
cursed_str_req3 = {
	stat = { str=function(level) return 28 + (level-1) * 2 end },
	level = function(level) return 8 + (level-1)  end,
}
cursed_str_req4 = {
	stat = { str=function(level) return 36 + (level-1) * 2 end },
	level = function(level) return 12 + (level-1)  end,
}
cursed_str_req5 = {
	stat = { str=function(level) return 44 + (level-1) * 2 end },
	level = function(level) return 16 + (level-1)  end,
}

cursed_cun_req1 = {
	stat = { cun=function(level) return 12 + (level-1) * 2 end },
	level = function(level) return 0 + (level-1)  end,
}
cursed_cun_req2 = {
	stat = { cun=function(level) return 20 + (level-1) * 2 end },
	level = function(level) return 4 + (level-1)  end,
}
cursed_cun_req3 = {
	stat = { cun=function(level) return 28 + (level-1) * 2 end },
	level = function(level) return 8 + (level-1)  end,
}
cursed_cun_req4 = {
	stat = { cun=function(level) return 36 + (level-1) * 2 end },
	level = function(level) return 12 + (level-1)  end,
}
cursed_cun_req5 = {
	stat = { cun=function(level) return 44 + (level-1) * 2 end },
	level = function(level) return 16 + (level-1)  end,
}

cursed_lev_req1 = {
	level = function(level) return 0 + (level-1)  end,
}
cursed_lev_req2 = {
	level = function(level) return 4 + (level-1)  end,
}
cursed_lev_req3 = {
	level = function(level) return 8 + (level-1)  end,
}
cursed_lev_req4 = {
	level = function(level) return 12 + (level-1)  end,
}
cursed_lev_req5 = {
	level = function(level) return 16 + (level-1)  end,
}

-- utility functions
function getHateMultiplier(self, min, max, cursedWeaponBonus, hate)
	local fraction = (hate or self.hate) / 100
	if cursedWeaponBonus then
		if self:hasDualWeapon() then
			if self:hasCursedWeapon() then fraction = fraction + 0.13 end
			if self:hasCursedOffhandWeapon() then fraction = fraction + 0.07 end
		else
			if self:hasCursedWeapon() then fraction = fraction + 0.2 end
		end
	end
	fraction = math.min(fraction, 1)
	return (min + ((max - min) * fraction))
end

load("/data/talents/cursed/slaughter.lua")
load("/data/talents/cursed/endless-hunt.lua")
load("/data/talents/cursed/strife.lua")
load("/data/talents/cursed/gloom.lua")
load("/data/talents/cursed/rampage.lua")
load("/data/talents/cursed/predator.lua")

load("/data/talents/cursed/force-of-will.lua")
load("/data/talents/cursed/dark-sustenance.lua")
load("/data/talents/cursed/shadows.lua")
load("/data/talents/cursed/darkness.lua")
load("/data/talents/cursed/punishments.lua")
load("/data/talents/cursed/gestures.lua")

load("/data/talents/cursed/cursed-form.lua")
load("/data/talents/cursed/cursed-aura.lua")
load("/data/talents/cursed/fears.lua")
