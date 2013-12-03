﻿-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009, 2010, 2011, 2012, 2013 Nicolas Casalini
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

newChat{ id="berethh",
	text = [[#VIOLET#*당신 앞에 베레쓰가 서있습니다. 그의 얼굴에는 감정이 드러나있지 않지만, 그의 자세는 공포에 질린 것 같습니다.#LAST#
]],
	answers = {
		{"킬레스는 죽었습니다.", jump="response"}
	}
}

newChat{ id="response",
	text = [[네 운명을 받아들였는지 모르겠군. 하지만 나는 도저히 너를 살려둘 수 없다.]],
	answers = {
		{
			"그렇다면 당신도 킬레스처럼 죽게 되겠죠. #LIGHT_GREEN#[공격한다]#LAST#",
			action=function(npc, player)
				player:hasQuest("keepsake"):on_evil_choice(player)
			end
		},
		{
			"당신의 도움이 필요합니다. 제 저주를 이겨내고 싶습니다.",
			action=function(npc, player)
				player:hasQuest("keepsake"):on_good_choice(player)
			end,
			jump="attack"
		},
		{
			"저는 당신을 죽이고 싶지 않습니다.",
			jump="attack"
		}
	}
}

newChat{ id="attack",
	text = [[#VIOLET#*베레쓰는 당신의 말을 무시한 채, 그의 활을 들어 공격할 준비를 합니다.*#LAST#]],
	answers = {
		{"#LIGHT_GREEN#[공격한다]"},
	}
}

return "berethh"
