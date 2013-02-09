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
load("/data/general/npcs/horror.lua")

local Talents = require("engine.interface.ActorTalents")

newEntity{ base = "BASE_NPC_HORROR", define_as="WEIRDLING_BEAST",
	name = "Weirdling Beast", color=colors.VIOLET,
	kr_display_name = "불가사의한 짐승",
	desc = "대략 인류같은 생물체이지만, 촉수같은 부속품이 팔과 다리가 있어야 할 자리에 달려 있습니다. 당신은 그것의 머리가 없음을 알아차리고 두려움에 숨이 막합니다. 부패한 사마귀의 모습이 빠르게 그 피부에 생겼다가 빠르게 터집니다.",
	killer_message = "and slowly consumed",
	level_range = {19, nil}, exp_worth = 3,
	rank = 3.5,
	autolevel = "warriormage",
	max_life = 300, life_rating = 16,
	combat_armor = 10, combat_def = 0,

	ai = "tactical", ai_state = { talent_in=2, ai_move="move_astar", },

	body = { INVEN = 10, MAINHAND=1, OFFHAND=1, BODY=1, QUIVER=1 },

	resists = {[DamageType.ARCANE] = -10, [DamageType.BLIGHT] = 10, [DamageType.PHYSICAL] = 10},

	disease_immune = 1,
	blind_immune = 1,
	fear_immune = 1,
	see_invisible = 100,
	vim_regen = 20,
	negative_regen = 15,

	resolvers.equip{
		{type="weapon", subtype="staff", autoreq=true, force_drop=true, forbid_power_source={antimagic=true}, tome_drops="boss"},
		{type="armor", subtype="light", autoreq=true, force_drop=true, forbid_power_source={antimagic=true}, tome_drops="boss"}
	},
	resolvers.drops{chance=100, nb=3, {tome_drops="boss"} },

	resolvers.talents{
		[Talents.T_ACID_BLOOD]=4,
		[Talents.T_BONE_GRAB]=4,
		[Talents.T_BONE_SHIELD]=3,
		[Talents.T_MIND_SEAR]=4,
		[Talents.T_TELEKINETIC_BLAST]=4,
		[Talents.T_GLOOM]=5,
		[Talents.T_SOUL_ROT]=3,
		[Talents.T_CORRUPTED_NEGATION]=4,
		[Talents.T_TIME_PRISON]=1,
		[Talents.T_STARFALL]=3,
		[Talents.T_MANATHRUST]=4,
		[Talents.T_FREEZE]=2,
	},
	max_inscriptions = 6,
	resolvers.inscription("INFUSION:_HEALING", {cooldown=6, dur=5, heal=400}),
	resolvers.inscription("INFUSION:_REGENERATION", {cooldown=10, dur=5, heal=400}),
	resolvers.inscription("INFUSION:_WILD", {cooldown=8, what={physical=true}, dur=4, power=45}),
	resolvers.inscription("RUNE:_SHIELDING", {cooldown=10, dur=5, power=500}),
	resolvers.inscription("TAINT:_DEVOURER", {cooldown=10, effects=4, heal=75}),
	resolvers.inscriptions(1, {"manasurge rune"}),

	resolvers.sustains_at_birth(),

	on_die = function()
		-- Open the door, destroy the stairs
		local g = game.zone:makeEntityByName(game.level, "terrain", "OLD_FLOOR")
		local spot = game.level:pickSpot{type="door", subtype="weirdling"}
		if spot then
			game.zone:addEntity(game.level, g, "terrain", spot.x, spot.y)
			game.log("#LIGHT_RED#불가사의한 짐승이 마지막 비명과 함께 무너지자, 그 뒤에 있던 문이 부서지면서 폭발했고, 뒷쪽의 방이 나타납니다. 올라가는 계단이 무너졌습니다!")
		end
		local spot = game.level:pickSpot{type="stair", subtype="up"}
		if spot then
			game.zone:addEntity(game.level, g, "terrain", spot.x, spot.y)
		end

		-- Change the in/out spots for later
		local spot = game.level:pickSpot{type="portal", subtype="back"}
		if spot then game.level.default_up.x, game.level.default_up.y = spot.x, spot.y end
		local spot = game.level:pickSpot{type="portal", subtype="back"}
		if spot then game.level.default_down.x, game.level.default_down.y = spot.x, spot.y end

		-- Update the worldmap with a shortcut to here
		game:onLevelLoad("wilderness-1", function(zone, level)
			local g = mod.class.Grid.new{
				show_tooltip=true, always_remember = true,
				name="Teleportation portal to the Sher'Tul Fortress",
				kr_display_name = "쉐르'툴 요새의 순간이동 관문",
				display='>', color=colors.ANTIQUE_WHITE, image = "terrain/grass.png", add_mos = {{image = "terrain/maze_teleport.png"}},
				notice = true,
				change_level=1, change_zone="shertul-fortress",
			}
			g:resolve() g:resolve(nil, true)
			local spot = level:pickSpot{type="zone-pop", subtype="shertul-fortress"}
			game.zone:addEntity(level, g, "terrain", spot.x, spot.y)
			game.nicer_tiles:updateAround(game.level, spot.x, spot.y)
			game.player.wild_x = spot.x
			game.player.wild_y = spot.y
		end)

		-- Update quest
		game.player:setQuestStatus("shertul-fortress", engine.Quest.COMPLETED, "weirdling")
	end,
}

newEntity{ base = "BASE_NPC_HORROR", define_as="BUTLER",
	subtype = "Sher'Tul",
	name = "Fortress Shadow", color=colors.GREY,
	kr_display_name = "요새의 그림자",
	desc = "요새가 만든 그림자로, 이전에 봤던 공포를 좀 닮게 생겼지만 같은 존재는 아닙니다.",
	level_range = {19, nil}, exp_worth = 3,
	rank = 3,
	max_life = 300, life_rating = 16,
	invulnerable = 1, never_move = 1,
	faction = "neutral",
	never_anger = 1,
	can_talk = "shertul-fortress-butler",
}
