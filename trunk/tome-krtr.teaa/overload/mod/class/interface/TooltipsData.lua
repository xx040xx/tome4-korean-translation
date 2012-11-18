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

require "engine.class"

module(..., package.seeall, class.make)


-------------------------------------------------------------
-- Resources
-------------------------------------------------------------
TOOLTIP_GOLD = [[#GOLD#금화#LAST#
돈입니다!
금화로 마을의 여러 상점에서 물건을 구입할 수 있습니다.
적을 쓰러뜨리고 전리품으로 얻거나, 물건을 팔거나, 퀘스트를 수행해서도 얻을 수 있습니다.
]]

TOOLTIP_LIVES = [[#GOLD#생명#LAST#
남은 생명과 읽어버린 생명의 횟수를 나타냅니다.
생명의 숫자는 영구사망 설정에서 선택한 모드에 따라 다릅니다.
다른 방법으로 부활할 수도 있으나, 그 방법은 추가 생명으로 간주되지 않습니다.
]]

TOOLTIP_LIFE = [[#GOLD#생명력#LAST#
당신의 생명력을 나타내는 수치이며, 피해를 입을 때마다 감소합니다.
생명력이 0 밑으로 떨어지면 사망하게 됩니다.
죽음은 보통 되돌릴 수 없으니 조심하세요!
체격 능력치로 상승시킬 수 있습니다.
]]

TOOLTIP_DAMAGE_SHIELD = [[#GOLD#피해 보호막#LAST#
기술이나 장비, 혹은 능력으로 일시적인 피해 보호막을 사용할 수 있습니다.
각각 다른 방식으로 작용하긴 하지만, 부서지기 전까지 피해를 흡수해준다는 점은 같습니다.
]]

TOOLTIP_UNNATURAL_BODY = [[#GOLD#비정상적인 신체 재생#LAST#
당신이 쓰러뜨린 적 시체의 잔여 생명력을 '비정상적인 신체' 기술로 흡수합니다.
적을 죽일 때마다 턴 당 생명력 재생량이 증가하며, 매 턴마다 당신의 생명력으로 전환됩니다.
]]

TOOLTIP_LIFE_REGEN = [[#GOLD#생명력 재생#LAST#
매 턴마다 재생되는 생명력을 나타내는 수치입니다.
이 수치는 주문이나 기술, 각인, 장비를 통해서 향상시킬 수 있습니다.
]]

TOOLTIP_HEALING_MOD = [[#GOLD#치유 증가량#LAST#
당신이 받는 치유 효과의 효율을 나타냅니다.
모든 치유량은 이 수치에 따라 증폭됩니다(재생 효과도 포함).
]]

TOOLTIP_AIR = [[#GOLD#공기#LAST#
숨을 쉴수 없는 상황 일때만 공기 수치가 나타납니다.
수치가 0에 도달하면 당신은 질식사하게 됩니다. 벽에 매몰되거나, 수중 등의 여러 상황에서 공기 수치가 감소됩니다.
다시 호흡이 가능한 상황이 되면 천천히 수치가 재생됩니다.
]]

TOOLTIP_STAMINA = [[#GOLD#체력#LAST#
체력은 신체적인 능력을 사용할 때 발생하는 피로나 부하를 감당할 수 있는 정도를 나타냅니다.
시간이 지나면 천천히 재생되나, 휴식을 취해서 빠르게 회복할 수도 있습니다.
의지 능력치로 상승시킬 수 있습니다.
]]

TOOLTIP_MANA = [[#GOLD#마나#LAST#
마나는 마법 에너지의 축적량을 나타냅니다. 사용형 주문을 시전하면 마나가 감소되고, 유지형 주문을 시전하면 마나의 최대치가 감소됩니다.
의지 능력치로 상승시킬 수 있습니다.
]]

TOOLTIP_POSITIVE = [[#GOLD#양기#LAST#
양기는 태양의 마법에 사용되는 에너지의 축적량을 나타냅니다.
시간이 지날수록 천천히 감소되며, 특정 기술로 충전할 수 있습니다.
]]

TOOLTIP_NEGATIVE = [[#GOLD#음기#LAST#
음기는 별과 달의 마법에 사용되는 에너지의 축적량을 나타냅니다.
시간이 지날수록 천천히 감소되며, 특정 기술로 충전할 수 있습니다.
]]

TOOLTIP_VIM = [[#GOLD#정력#LAST#
정력은 타락의 기술에 사용되는 생명의 정기를 나타냅니다.
자연적으로 재생되지 않으며, 당신의 희생양에게서 쥐어짜내거나 자신의 생명력을 짜내서도 사용할 수도 있습니다.
적을 죽일 때마다 당신의 의지 능력치의 10% 만큼 정력을 갈취할 수 있습니다.
또한 정력을 소모하는 타락의 주문으로 적을 살해하면, 소모된 정력을 되돌려받을 수 있습니다.
]]

TOOLTIP_EQUILIBRIUM = [[#GOLD#평정#LAST#
평정은 위대한 자연의 조화를 따르는 정도를 나타냅니다.
0에 가까울수록 조화 속에서 평정을 유지하며, 평정에서 벗어날수록 자연의 권능을 제대로 쓸 수 없게 됩니다.
]]

TOOLTIP_HATE = [[#GOLD#증오#LAST#
증오는 당신에게 맞서는 모든 존재에 대한 내면의 분노를 나타냅니다.
적을 살해하여 채울 수 있습니다.
고통받는 자가 사용하는 기술은, 증오심이 높을수록 더욱 강력해집니다.
]]

TOOLTIP_PARADOX = [[#GOLD#괴리#LAST#
괴리는 당신이 시공 연속체에 입힌 손상정도를 나타냅니다.
괴리가 심해질수록 주문은 강력해지지만, 동시에 이상현상이 발생하지 않도록 제어하기도 힘들어집니다.
시공 제어 마법은 의지 능력치를 상승시키면 더 능숙하게 다룰 수 있습니다.
]]

TOOLTIP_PSI = [[#GOLD#염력#LAST#
염력은 당신의 정신이 다룰 수 있는 에너지의 양을 나타냅니다.
주변의 운동 에너지나 열 에너지로 부터 소량을 빨아들여서 천천히 재생시킬 수 있습니다..
전투 상황에서 필요한 만큼의 염력을 얻으려면 보호막으로 흡수하거나 다른 기술을 써야합니다.
의지 능력치로 염력 축적량을 상승시킬 수 있습니다.
]]

TOOLTIP_FEEDBACK = [[#GOLD#반작용#LAST#
반작용은 사용자가 받는 고통을 정신력으로 활용하는 것을 나타냅니다.
외부로부터 받는 피해량의 절반을 반작용으로 쓸 수 있습니다.
반작용은 턴 당 10%씩 감소됩니다.
]]

TOOLTIP_NECROTIC_AURA = [[#GOLD#사령의 영기#LAST#
언데드를 불러 일으키는데 사용되는 영혼을 모아둔 수량을 나타냅니다.
사령의 영기 범위 내에서 당신이나 부하가 적을 살해하면 증가됩니다..
]]

TOOLTIP_LEVEL = [[#GOLD#레벨과 경험치#LAST#
당신의 레벨보다 5레벨 낮은 적들까지는 경험치를 획득할 수 있습니다.
충분한 경험치를 얻었다면 다음 레벨로 승급할 수 있으며, 최대 레벨은 50레벨입니다..
레벨이 오를 때 받는 능력치와 기술 점수로 당신의 케릭터를 강화할 수 있습니다.
]]

TOOLTIP_ENCUMBERED = [[#GOLD#무게#LAST#
당신이 지니고 다니는 물건에는 무게가 있으며, 힘이 쎄지면 운반가능한 무게도 높아집니다.
과적 상태에서는 움직일 수가 없으니, 물건을 버려서 무게를 줄여야 합니다.
]]

TOOLTIP_INSCRIPTIONS = [[#GOLD#각인#LAST#
에이알 사람들은 피부에 룬을 새기거나 약초로 만든 약재로 문신하는 방법을 알아냈습니다.
각인을 새긴 사람은 영구적으로 사용할 수 있는 능력을 부여받습니다. 대부분의 사람들은 간단한 재생 각인을 새겨서 쓰지만, 다른 종류의 각인도 많습니다.
]]

-------------------------------------------------------------
-- Speeds
-------------------------------------------------------------
TOOLTIP_SPEED_GLOBAL = [[#GOLD#전체 속도#LAST#
전체 속도는 모든 행동에 영향을 줍니다.
당신이 게임 턴마다 얻는 행동력을 나타내며, 행동력이 일정 수치에 달하면 행동할 수 있습니다.
예) 전체 속도가 200% 일 때는 두 배의 행동력을 게임 턴마다 얻게 되어, 다른 생물이 한번 움직일 때 당신은 두 번 움직일 수 있게 됩니다.
]]
TOOLTIP_SPEED_MOVEMENT = [[#GOLD#이동 속도#LAST#
같은 시간 동안 얼마나 더 이동할 수 있는지를 나타냅니다.
예) 100% 일 때는 0% 일 때보다 두 배 더 많이 이동할 수 있습니다.
]]
TOOLTIP_SPEED_SPELL = [[#GOLD#시전 속도#LAST#
같은 시간 동안 주문을 얼마나 더 많이 시전할 수 있는지를 나타냅니다.
예) 100% 일 때는 0% 일 때보다 두 배 더 많이 주문을 시전할 수 있습니다.
]]
TOOLTIP_SPEED_ATTACK = [[#GOLD#공격 속도#LAST#
같은 시간 동안 얼마나 더 많은 공격을 가할 수 있는지를 나타냅니다.
예) 100% 일 때는 0% 일 때보다 두 배 더 많이 공격할 수 있습니다.
]]
TOOLTIP_SPEED_MENTAL = [[#GOLD#사고 속도#LAST#
같은 시간 동안 얼마나 더 많은 정신 능력을 사용할 수 있는지를 나타냅니다.
예) 100% 일 때는 0% 일 때보다 두 배 더 많이 정신 능력을 사용할 수 있습니다.
]]
-------------------------------------------------------------
-- Stats
-------------------------------------------------------------
TOOLTIP_STR = [[#GOLD#힘#LAST#
힘은 케릭터의 물리력을 의미합니다. 운반 가능한 무게와, 근력을 사용하는 무기(장검, 철퇴, 도끼 등)의 피해량, 그리고 물리 내성을 상승시킵니다.
]]
TOOLTIP_DEX = [[#GOLD#민첩#LAST#
민첩은 케릭터가 얼마나 재빠르고 반사신경이 좋은지를 나타냅니다. 공격이 성공할 확률과, 적의 공격을 회피할 확률, 그리고 단검이나 채찍같은 가벼운 무기의 피해량을 상승시킵니다.
]]
TOOLTIP_CON = [[#GOLD#체격#LAST#
체격은 케릭터가 얼마나 적의 공격에 잘 버티는지를 나타냅니다. 최대 생명력과 물리 내성을 상승시킵니다.
]]
TOOLTIP_MAG = [[#GOLD#마법#LAST#
마법은 케릭터가 마력을 얼마나 잘 제어하는지를 나타냅니다. 주문력과 주문 내성, 그리고 다른 마법 아이템의 효과를 상승시킵니다.
]]
TOOLTIP_WIL = [[#GOLD#의지#LAST#
의지는 케릭터의 집중력을 나타냅니다. 마나와 체력, 그리고 염력 수치를 늘려주며, 정신력과 주문, 정신 내성을 상승시킵니다.
]]
TOOLTIP_CUN = [[#GOLD#교활함#LAST#
교활함은 치명적인 공격을 가할 기회와, 정신력, 그리고 정신 내성을 상승시킵니다.
]]
TOOLTIP_STRDEXCON = "#AQUAMARINE#Physical stats#LAST#\n---\n"..TOOLTIP_STR.."\n---\n"..TOOLTIP_DEX.."\n---\n"..TOOLTIP_CON
TOOLTIP_MAGWILCUN = "#AQUAMARINE#Mental stats#LAST#\n---\n"..TOOLTIP_MAG.."\n---\n"..TOOLTIP_WIL.."\n---\n"..TOOLTIP_CUN

-------------------------------------------------------------
-- Melee
-------------------------------------------------------------
TOOLTIP_COMBAT_ATTACK = [[#GOLD#정확도#LAST#
상대의 회피도와 비교하여 공격 성공확률을 결정하고, 정확도가 월등히 높을 때는 상대의 자세를 무너뜨려 비틀거림 상태로 만듭니다.
상태이상을 유발할 때, 상대의 내성이 공격자의 정확도보다 높다면 차이나는 수치 1당 5%씩 지속시간이 감소됩니다.
]]
TOOLTIP_COMBAT_PHYSICAL_POWER = [[#GOLD#물리력#LAST#
물리적인 피해를 가하는 능력의 척도입니다.
상태이상을 유발할 때, 상대의 내성이 공격자의 물리력보다 높다면 차이나는 수치 1당 5%씩 지속시간이 감소됩니다.
]]
TOOLTIP_COMBAT_DAMAGE = [[#GOLD#피해량#LAST#
적을 공격했을 때 입히는 피해량입니다.
상대의 방어도나 피해 저항에 감소될 수 있습니다.
힘과 민첩 능력치로 향상시킬 수 있으며, 특정 기술로 피해량에 관여하는 능력치를 바꿀 수도 있습니다.
]]
TOOLTIP_COMBAT_APR = [[#GOLD#관통력#LAST#
관통력은 상대의 방어도를 일정량 무시하게 해줍니다(방어도에만 해당되며, 피해 저항에는 적용되지 않습니다).
관통력이 방어도를 0 밑으로 떨어뜨린다고 해도 피해량이 그만큼 증폭되는 것은 아니기에, 갑옷으로 무장한 적에게만 효과적입니다.
]]
TOOLTIP_COMBAT_CRIT = [[#GOLD#치명타율#LAST#
적에게 일반적인 피해량의 150%에 해당하는 치명적인 타격을 입힐 확률입니다.
특정 기술로 이 확률을 증가시킬 수 있습니다.
교활함 능력치로도 상승시킬 수 있습니다.
]]
TOOLTIP_COMBAT_SPEED = [[#GOLD#공격 속도#LAST#
적을 공격하는데 소모되는 턴을 나타냅니다.
낮을 수록 더 공격을 빠르게, 자주 할 수 있습니다.
예) 공격 속도가 50% 라면, 100% 인 적이 한 번 공격할 때 두 번 공격할 수 있습니다.
]]
TOOLTIP_COMBAT_RANGE = [[#GOLD#사정 거리#LAST#
무기의 최대 사정거리입니다.
]]
TOOLTIP_COMBAT_AMMO = [[#GOLD#발사체 잔여량#LAST#
화살이나 투석구용 탄환의 잔여량입니다.
잔여량이 0이 되면 재장전을 해야합니다.
연금술사가 던지는 폭탄에 쓰이는 보석은 발사체 칸에 장착해야합니다.
]]

-------------------------------------------------------------
-- Defense
-------------------------------------------------------------
TOOLTIP_FATIGUE = [[#GOLD#피로도#LAST#
피로도는 무거운 장비를 착용해서 생기는 육체적 부담을 나타냅니다.
피로도가 높으면 기술과 주문을 사용할 때 드는 체력이나 마나 등이 증가됩니다.
하지만 자연의 권능같이 피로도에 영향을 받지 않는 기술 계열들도 있습니다.
]]
TOOLTIP_ARMOR = [[#GOLD#방어도#LAST#
방어도는 근접과 원거리 물리 공격의 피해를 경감시켜줍니다.
피해량이 치명타와 기술의 영향을 받아 증폭되기 전에 방어 판정이 이루어지기에, 작은 수치로도 굉장한 효과를 볼 수 있습니다.
(방어 효율)%의 물리 피해를, 최대 (방어도) 까지만 감소시킵니다.
예)피해량:100, 효율:90%, 방어도:20 -> 받은 피해량:80(20 감소)
]]
TOOLTIP_ARMOR_HARDINESS = [[#GOLD#방어 효율#LAST#
피해량에 대해 방어도가 적용되는 정도를 나타냅니다.
(방어 효율)%의 물리 피해를, 최대 (방어도) 까지만 감소시킵니다.
예)피해량:100, 효율:30%, 방어도:50 -> 받은 피해량:70(30 감소)
]]
TOOLTIP_CRIT_REDUCTION = [[#GOLD#치명타 억제#LAST#
적에게 근접과 원거리 공격으로 치명적인 피해를 입게 될 확률을 감소시킵니다.
]]
TOOLTIP_DEFENSE = [[#GOLD#회피도#LAST#
상대의 정확도와 비교하여 회피 확률을 결정하고, 적의 공격에 자세가 무너져 비틀거림 상태가 될 확률을 줄입니다.
]]
TOOLTIP_RDEFENSE = [[#GOLD#사격 회피#LAST#
상대의 정확도와 비교하여 회피 확률을 결정하고, 적의 공격에 자세가 무너져 비틀거림 상태가 될 확률을 줄입니다.
]]
TOOLTIP_PHYS_SAVE = [[#GOLD#물리 내성#LAST#
물리 상태이상 효과에 걸리지 않을 확률을 증가시킵니다. 또한, 상대가 사용한 기술에 요구되는 물리력, 주문력, 정신력보다 내성이 높다면, 차이나는 수치 1당 물리 상태이상 효과의 지속시간을 5%씩 감소시킵니다.
]]
TOOLTIP_SPELL_SAVE = [[#GOLD#주문 내성#LAST#
주문 상태이상 효과에 걸리지 않을 확률을 증가시킵니다. 또한, 상대가 사용한 기술에 요구되는 물리력, 주문력, 정신력보다 내성이 높다면, 차이나는 수치 1당 주문 상태이상 효과의 지속시간을 5%씩 감소시킵니다.
]]
TOOLTIP_MENTAL_SAVE = [[#GOLD#정신 내성#LAST#
정신 상태이상 효과에 걸리지 않을 확률을 증가시킵니다. 또한, 상대가 사용한 기술에 요구되는 물리력, 주문력, 정신력보다 내성이 높다면, 차이나는 수치 1당 정신 상태이상 효과의 지속시간을 5%씩 감소시킵니다.
]]

-------------------------------------------------------------
-- Spells
-------------------------------------------------------------
TOOLTIP_SPELL_POWER = [[#GOLD#주문력#LAST#
주문력은 당신이 사용하는 주문의 위력을 나타냅니다.
게다가, 주문이 상태이상 효과를 발생시킨다면, 상대의 내성과 비교했을 때 주문력이 낮다면 차이나는 수치 1당 주문 상태이상 효과의 지속시간이 5%씩 감소됩니다.
]]
TOOLTIP_SPELL_CRIT = [[#GOLD#주문 치명타율#LAST#
적에게 일반적인 피해량의 150%에 해당하는 치명적인 타격을 입힐 확률입니다.
특정 기술로 이 확률을 증가시킬 수 있습니다.
교활함 능력치로도 상승시킬 수 있습니다.
]]
TOOLTIP_SPELL_SPEED = [[#GOLD#시전속도#LAST#
주문을 시전하는데 소모되는 턴을 나타냅니다.
낮을 수록 더 시전을 빠르게, 자주 할 수 있습니다.
]]
TOOLTIP_SPELL_COOLDOWN = [[#GOLD#재사용 시간#LAST#
재사용 시간은 주문을 다시 사용할 수 있게 될 때까지 걸리는 시간을 의미합니다.
수치가 낮을수록 주문과 룬을 더 자주 쓸 수 있습니다.
]]
-------------------------------------------------------------
-- Mental
-------------------------------------------------------------
TOOLTIP_MINDPOWER = [[#GOLD#정신력#LAST#
정신력은 당신이 사용하는 정신 능력의 위력을 나타냅니다.
게다가, 정신 능력이 상태이상 효과를 발생시킨다면, 상대의 내성과 비교했을 때 주문력이 낮다면 차이나는 수치 1당 정신 상태이상 효과의 지속시간이 5%씩 감소됩니다.
]]
TOOLTIP_MIND_CRIT = [[#GOLD#정신 치명타율#LAST#
적에게 일반적인 피해량의 150%에 해당하는 치명적인 타격을 입힐 확률입니다.
특정 기술로 이 확률을 증가시킬 수 있습니다.
교활함 능력치로도 상승시킬 수 있습니다.
]]
TOOLTIP_MIND_SPEED = [[#GOLD#사고속도#LAST#
정신 능력을 사용하는데 소모되는 턴을 나타냅니다.
낮을 수록 더 빠르게, 자주 쓸 수 있습니다.
]]
-------------------------------------------------------------
-- Damage and resists
-------------------------------------------------------------
TOOLTIP_INC_DAMAGE_ALL = [[#GOLD#피해량 증가: 모든 속성#LAST#
당신이 가하는 모든 피해는 이 수치에 의해 증폭됩니다.
특정 피해량 증가와 중첩될 수 있습니다.
]]
TOOLTIP_INC_DAMAGE = [[#GOLD#피해량 증가: 특정 속성#LAST#
당신이 가하는 어떠한 형태의 피해든, 이 속성에 해당한다면 증폭됩니다.
]]
TOOLTIP_INC_CRIT_POWER = [[#GOLD#치명타 배수#LAST#
모든 형태의 치명타 피해량을 증가시킵니다.
]]
TOOLTIP_RESIST_ALL = [[#GOLD#피해 저항: 모든 속성#LAST#
당신이 받는 모든 피해는 이 수치에 의해 감소됩니다.
특정 피해 저항과 중첩될 수 있습니다.
]]
TOOLTIP_RESIST = [[#GOLD#피해 저항: 특정 속성#LAST#
당신이 받는 피해가 이 속성에 해당된다면 감소됩니다.
]]
TOOLTIP_SPECIFIC_IMMUNE = [[#GOLD#상태이상 저항#LAST#
이 효과에 걸리지 않을 확률을 나타냅니다.
]]
TOOLTIP_ON_HIT_DAMAGE = [[#GOLD#피해 반사#LAST#
당신에게 근접 공격을 가하는 적에게 피해를 입힙니다.
]]
TOOLTIP_RESISTS_PEN_ALL = [[#GOLD#저항 관통: 모든 속성#LAST#
상대의 저항을 감소시키고 피해를 입힙니다.
만약 50%의 저항 관통으로 50%의 저항을 가진 적을 공격한다면, 상대는 피해량의 25%만을 저항하게 됩니다.
특정 저항 관통과 중첩될 수 있습니다.
]]
TOOLTIP_RESISTS_PEN = [[#GOLD#저항 관통: 특정 속성#LAST#
적의 특정한 속성 저항을 감소시키고 피해를 입힙니다..
만약 어떤 속성에 50% 저항하는 적을 해당 속성의 50% 저항 관통으로 공격한다면, 상대는 피해량의 25%만을 저항하게 됩니다.
]]

-------------------------------------------------------------
-- Misc
-------------------------------------------------------------
TOOLTIP_ESP = [[#GOLD#투시#LAST#
시야가 장애물로 가로막혀 있더라도 해당 부류의 대상을 감지할 수 있습니다.
]]
TOOLTIP_ESP_RANGE = [[#GOLD#투시 거리#LAST#
투시로 감지할 수 있는 거리를 나타냅니다.
]]
TOOLTIP_ESP_ALL = [[#GOLD#투시#LAST#
시야가 장애물로 가로막혀 있더라도 모든 대상을 감지할 수 있습니다.
]]
TOOLTIP_VISION_LITE = [[#GOLD#광원 반경#LAST#
당신이 소유한 광원이 비출 수 있는 최대 거리이며, 다른 광원이 있는 곳이 아니라면 광원 반경 너머로는 볼 수가 없습니다.
]]
TOOLTIP_VISION_SIGHT = [[#GOLD#시야 거리#LAST#
육안으로 볼 수 있는 최대 거리이며, 밝은 곳에서만 적용됩니다.
]]
TOOLTIP_VISION_INFRA = [[#GOLD#야간 투시력#LAST#
어둠 속에서도 볼 수 있는 능력이지만, 이 시야로는 사물은 분간할 수 없고 생물만 감지할 수 있습니다.
]]
TOOLTIP_VISION_STEALTH = [[#GOLD#은신#LAST#
몸을 숨기고 다니려면 '은신' 기술을 배워야합니다.
은신을 하면 적의 시야 내에서도 숨어 다닐 수 있습니다.
눈치챘다 하더라도 당신에게 공격을 적중시키기 어려워집니다.
어떤 생물은 은신을 감지할 수 있습니다.
]]
TOOLTIP_VISION_SEE_STEALTH = [[#GOLD#은신 감지#LAST#
은신한 생물을 감지하는 능력이며, 상대의 은신 능력과 비교하여 감지력이 높을수록 더 쉽게 발견할 수 있습니다.
]]
TOOLTIP_VISION_INVISIBLE = [[#GOLD#투명화#LAST#
투명화된 생물은 다른 모든 대상의 시야에서 사라집니다. 투명화 감지력이 있는 대상만 볼 수 있습니다.
]]
TOOLTIP_VISION_SEE_INVISIBLE = [[#GOLD#투명화 감지#LAST#
투명화된 생물을 감지하는 능력이며, 상대의 투명화 정도와 비교하여 감지력이 높을수록 더 쉽게 발견할 수 있습니다.
투명화 감지력이 없다면 절대로 투명화된 대상을 발견할 수 없습니다.
]]
