CONFIRM_NO = 0
CONFIRM_YES = 1
CONFIRM_OK = 1
CONFIRM_TIMEOUT = 2

MALE = 0
FEMALE = 1

setstate = q.setstate
newstate = q.setstate

q.set_clock = function(name, value) q.set_clock_name(name) q.set_clock_value(value) end
q.set_counter = function(name, value) q.set_counter_name(name) q.set_counter_value(value) end
c_item_name = function(vnum) return ("[ITEM value;"..vnum.."]") end
c_mob_name = function(vnum) return ("[MOB value;"..vnum.."]") end

newline = "[ENTER]"
function color256(r, g, b) return "[COLOR r;"..(r/255.0).."|g;"..(g/255.0).."|b;"..(b/255.0).."]" end
function color(r,g,b) return "[COLOR r;"..r.."|g;"..g.."|b;"..b.."]" end
function delay(v) return "[DELAY value;"..v.."]" end
function setcolor(r,g,b) raw_script(color(r,g,b)) end
function setdelay(v) raw_script(delay(v)) end
function resetcolor(r,g,b) raw_script("[/COLOR]") end
function resetdelay(v) raw_script("[/DELAY]") end


function trim(s) return (string.gsub(s, "^%s*(.-)%s*$", "%1")) end
function addmapsignal(x,y) raw_script("[ADDMAPSIGNAL x;"..x.."|y;"..y.."]") end
function clearmapsignal() raw_script("[CLEARMAPSIGNAL]") end
function setbgimage(src) raw_script("[BGIMAGE src;") raw_script(src) raw_script("]") end
function addimage(x,y,src) raw_script("[IMAGE x;"..x.."|y;"..y) raw_script("|src;") raw_script(src) raw_script("]") end

function notice_multiline( str , func )
    local p = 0
    local i = 0
    while true do
        i = string.find( str, "%[ENTER%]", i+1 )
        if i == nil then
            if string.len(str) > p then
                func( string.sub( str, p, string.len(str) ) )
            end
            break
        end
        func( string.sub( str, p, i-1 ) )
        p = i + 7
    end
end

function makequestbutton(name)
	raw_script("[QUESTBUTTON idx;")
	raw_script(""..q.getcurrentquestindex())
	raw_script("|name;")
	raw_script(name) raw_script("]")
end

function make_quest_button_ex(name, icon_type, icon_name)
	test_chat(icon_type)
	test_chat(icon_name)
	raw_script("[QUESTBUTTON idx;")
	raw_script(""..q.getcurrentquestindex())
	raw_script("|name;")
	raw_script(name)
	raw_script("|icon_type;")
	raw_script(icon_type)
	raw_script("|icon_name;")
	raw_script(icon_name)
	raw_script("]")
end

function make_quest_button(name) makequestbutton(name) end

function send_letter_ex(name, icon_type, icon_name) make_quest_button_ex(name, icon_type, icon_name) set_skin(NOWINDOW) q.set_title(name) q.start() end

function send_letter(name) makequestbutton(name) setskin(NOWINDOW) q.set_title(name) q.start() end
function clear_letter()
	raw_script("[QUESTBUTTON_CLOSE idx;" .. q.getcurrentquestindex() .. "]")
	q.done()
end
function say_title(name) say(color256(255, 230, 186)..name..color256(196, 196, 196)) end
function say_reward(name) say(color256(255, 200, 200)..name..color256(196, 196, 196)) end
function say_pc_name() say(pc.get_name()..":") end
function say_size(width, height) say("[WINDOW_SIZE width;"..width.."|height;"..height.."]") end
function setmapcenterposition(x,y)
	raw_script("[SETCMAPPOS x;")
	raw_script(x.."|y;")
	raw_script(y.."]")
end
function say_item(name, vnum, desc)
	say("[INSERT_IMAGE image_type;item|idx;"..vnum.."|title;"..name.."|desc;"..desc.."]")
end
function say_show_item(vnum)
	say("[INSERT_IMAGE image_type;item|idx;"..vnum.."]")
end
function say_item_vnum(vnum)
	say_item(item_name(vnum), vnum, "")
end
function pc_is_novice()
	if pc.get_skill_group()==0 then
		return true
	else
		return false
	end
end
function pc_get_exp_bonus(exp, text)
	say_reward(text)
	pc.give_exp2(exp)
	set_quest_state("levelup", "run")
end
function pc_get_village_map_index(index)
	return village_map[pc.get_empire()][index]
end
function pc_has_even_id()
	return math.mod(pc.get_player_id(),2) == 0
end

function pc_get_account_id()
	return math.mod(pc.get_account_id(), 2) !=0
end

village_map = {
	{1, 3},
	{21, 23},
	{41, 43},
}

function npc_is_same_empire()
	if pc.get_empire()==npc.empire then
		return true
	else
		return false
	end
end

function npc_get_skill_teacher_race(pc_empire, pc_job, sub_job)
	if 1==sub_job then
		if 0==pc_job then
			return WARRIOR1_NPC_LIST[pc_empire]
		elseif 1==pc_job then
			return ASSASSIN1_NPC_LIST[pc_empire]
		elseif 2==pc_job then
			return SURA1_NPC_LIST[pc_empire]
		elseif 3==pc_job then
			return SHAMAN1_NPC_LIST[pc_empire]
		end
	elseif 2==sub_job then
		if 0==pc_job then
			return WARRIOR2_NPC_LIST[pc_empire]
		elseif 1==pc_job then
			return ASSASSIN2_NPC_LIST[pc_empire]
		elseif 2==pc_job then
			return SURA2_NPC_LIST[pc_empire]
		elseif 3==pc_job then
			return SHAMAN2_NPC_LIST[pc_empire]
		end
	end

	return 0
end


function pc_find_square_guard_vid()
	if pc.get_empire()==1 then
		return find_npc_by_vnum(11000)
	elseif pc.get_empire()==2 then
		return find_npc_by_vnum(11002)
	elseif pc.get_empire()==3 then
		return find_npc_by_vnum(11004)
	end
	return 0
end

function pc_find_skill_teacher_vid(sub_job)
	local vnum=npc_get_skill_teacher_race(pc.get_empire(), pc.get_job(), sub_job)
	return find_npc_by_vnum(vnum)
end

function pc_find_square_guard_vid()
	local pc_empire=pc.get_empire()
	if pc_empire==1 then
		return find_npc_by_vnum(11000)
	elseif pc_empire==2 then
		return find_npc_by_vnum(11002)
	elseif pc_empire==3 then
		return find_npc_by_vnum(11004)
	end
end

function npc_is_same_job()
	local pc_job=pc.get_job()
	local npc_vnum=npc.get_race()

	
	
	
	if pc_job==0 then
		if table_is_in(WARRIOR1_NPC_LIST, npc_vnum) then return true end
		if table_is_in(WARRIOR2_NPC_LIST, npc_vnum) then return true end
	elseif pc_job==1 then
		if table_is_in(ASSASSIN1_NPC_LIST, npc_vnum) then return true end
		if table_is_in(ASSASSIN2_NPC_LIST, npc_vnum) then return true end
	elseif pc_job==2 then
		if table_is_in(SURA1_NPC_LIST, npc_vnum) then return true end
		if table_is_in(SURA2_NPC_LIST, npc_vnum) then return true end
	elseif pc_job==3 then
		if table_is_in(SHAMAN1_NPC_LIST, npc_vnum) then return true end
		if table_is_in(SHAMAN2_NPC_LIST, npc_vnum) then return true end
	end

	return false
end

function npc_get_job()
	local npc_vnum=npc.get_race()

	if table_is_in(WARRIOR1_NPC_LIST, npc_vnum) then return COND_WARRIOR_1 end
	if table_is_in(WARRIOR2_NPC_LIST, npc_vnum) then return COND_WARRIOR_2 end
	if table_is_in(ASSASSIN1_NPC_LIST, npc_vnum) then return COND_ASSASSIN_1 end
	if table_is_in(ASSASSIN2_NPC_LIST, npc_vnum) then return COND_ASSASSIN_2 end
	if table_is_in(SURA1_NPC_LIST, npc_vnum) then return COND_SURA_1 end
	if table_is_in(SURA2_NPC_LIST, npc_vnum) then return COND_SURA_2 end
	if table_is_in(SHAMAN1_NPC_LIST, npc_vnum) then return COND_SHAMAN_1 end
	if table_is_in(SHAMAN2_NPC_LIST, npc_vnum) then return COND_SHAMAN_2 end
	return 0

end

function time_min_to_sec(value)
	return 60*value
end

function time_hour_to_sec(value)
	return 3600*value
end

function next_time_set(value, test_value)
	local nextTime=get_time()+value
	if is_test_server() then
		nextTime=get_time()+test_value
	end
	pc.setqf("__NEXT_TIME__", nextTime)
end

function next_time_is_now(value)
	if get_time()>=pc.getqf("__NEXT_TIME__") then
		return true
	else
		return false
	end
end

function table_get_random_item(self)
	return self[number(1, table.getn(self))]
end

function table_is_in(self, test)
	for i = 1, table.getn(self) do
		if self[i]==test then
			return true
		end
	end
	return false
end


function giveup_quest_menu(title)
    local s=select("진행한다", "포기한다")
    if 2==s then
	say(title.." 퀘스트를 정말로")
	say("포기하시겠습니까?")
	local s=select("네, 그렇습니다", "아닙니다")
	if 1==s then
	    say(title.."퀘스트를 포기했습니다")
	    restart_quest()
	end
    end
end

function restart_quest()
	set_state("start")
	q.done()
end

function complete_quest()
	set_state("__COMPLETE__")
	q.done()
end

function giveup_quest()
	set_state("__GIVEUP__")
	q.done()
end

function complete_quest_state(state_name)
	set_state(state_name)
	q.done()
end

function test_chat(log)
	if is_test_server() then
		chat(log)
	end
end

function bool_to_str(is)
	if is then
		return "true"
	else
		return "false"
	end
end

WARRIOR1_NPC_LIST 	= {20300, 20320, 20340, }
WARRIOR2_NPC_LIST 	= {20301, 20321, 20341, }
ASSASSIN1_NPC_LIST 	= {20302, 20322, 20342, }
ASSASSIN2_NPC_LIST 	= {20303, 20323, 20343, }
SURA1_NPC_LIST 		= {20304, 20324, 20344, }
SURA2_NPC_LIST 		= {20305, 20325, 20345, }
SHAMAN1_NPC_LIST 	= {20306, 20326, 20346, }
SHAMAN2_NPC_LIST 	= {20307, 20327, 20347, }

function skill_group_dialog(e, j, g) 
	e = 1 


	
	if pc.job != j then
		say(locale.skill_group.dialog[e][pc.job][3])
	elseif pc.get_skill_group() == 0 then
	    if pc.level < 5 then
		    say(locale.skill_group.dialog[e][j][g][1])
		    return
	    end
		say(locale.skill_group.dialog[e][j][g][2])
		local answer = select(locale.yes, locale.no)

		if answer == 1 then
			
			pc.set_skill_group(g)
		else
			
		end
	
		
	
		
	end
end

function show_horse_menu()
	if horse.is_mine() then
		say(locale.horse_menu.menu)

		local s = 0
		if horse.is_dead() then
			s = select(locale.horse_menu.revive, locale.horse_menu.ride, locale.horse_menu.unsummon, locale.horse_menu.close)
		else
			s = select(locale.horse_menu.feed, locale.horse_menu.ride, locale.horse_menu.unsummon, locale.horse_menu.close)
		end

		if s==1 then
			if horse.is_dead() then
				horse.revive()
			else
			    local food = horse.get_grade() + 50054 - 1
			    if pc.countitem(food) > 0 then
				pc.removeitem(food, 1)
				horse.feed()
			    else
				say(locale.need_item_prefix..item_name(food)..locale.need_item_postfix);
			    end
			end
		elseif s==2 then
		    horse.ride()
		elseif s==3 then
		    horse.unsummon()
		elseif s==4 then
			
		end
	end
end

npc_index_table = {
    ['race'] = npc.getrace,
    ['empire'] = npc.get_empire,
}

pc_index_table = {
    ['weapon']		= pc.getweapon,
    ['level']		= pc.get_level,
    ['hp']		= pc.gethp,
    ['maxhp']		= pc.getmaxhp,
    ['sp']		= pc.getsp,
    ['maxsp']		= pc.getmaxsp,
    ['exp']		= pc.get_exp,
    ['nextexp']		= pc.get_next_exp,
    ['job']		= pc.get_job,
    ['money']		= pc.getmoney,
    ['gold'] 		= pc.getmoney,
    ['name'] 		= pc.getname,
    ['playtime'] 	= pc.getplaytime,
    ['leadership'] 	= pc.getleadership,
    ['empire'] 		= pc.getempire,
    ['skillgroup'] 	= pc.get_skill_group,
    ['x'] 		= pc.getx,
    ['y'] 		= pc.gety,
    ['local_x'] 	= pc.get_local_x,
    ['local_y'] 	= pc.get_local_y,
}

item_index_table = {
    ['vnum']		= item.get_vnum,
    ['name']		= item.get_name,
    ['size']		= item.get_size,
    ['count']		= item.get_count,
    ['type']		= item.get_type,
    ['sub_type']	= item.get_sub_type,
    ['refine_vnum']	= item.get_refine_vnum,
    ['level']		= item.get_level,
}

guild_war_bet_price_table =
{
	10000,
	30000,
	50000,
	100000
}

function npc_index(t,i)
    local npit = npc_index_table
    if npit[i] then
	return npit[i]()
    else
	return rawget(t,i)
    end
end

function pc_index(t,i)
    local pit = pc_index_table
    if pit[i] then
	return pit[i]()
    else
	return rawget(t,i)
    end
end

function item_index(t, i)
    local iit = item_index_table
    if iit[i] then
	return iit[i]()
    else
	return rawget(t, i)
    end
end

setmetatable(pc,{__index=pc_index})
setmetatable(npc,{__index=npc_index})
setmetatable(item,{__index=item_index})


function select(...)
	return q.yield('select', arg)
end

function select_table(table)
	return q.yield('select', table)
end


function wait()
	q.yield('wait')
end

function input()
	return q.yield('input')
end

function confirm(vid, msg, timeout)
	return q.yield('confirm', vid, msg, timeout)
end

function select_item()
    setskin(NOWINDOW)
    return q.yield('select_item')
end


NOWINDOW = 0
NORMAL = 1
CINEMATIC = 2
SCROLL = 3

WARRIOR = 0
ASSASSIN = 1
SURA = 2
SHAMAN = 3

COND_WARRIOR_0 = 8
COND_WARRIOR_1 = 16
COND_WARRIOR_2 = 32
COND_WARRIOR = 56

COND_ASSASSIN_0 = 64
COND_ASSASSIN_1 = 128
COND_ASSASSIN_2 = 256
COND_ASSASSIN = 448

COND_SURA_0 = 512
COND_SURA_1 = 1024
COND_SURA_2 = 2048
COND_SURA = 3584

COND_SHAMAN_0 = 4096
COND_SHAMAN_1 = 8192
COND_SHAMAN_2 = 16384
COND_SHAMAN = 28672

PART_MAIN = 0
PART_HAIR = 3

GUILD_CREATE_ITEM_VNUM = 70101

QUEST_SCROLL_TYPE_KILL_MOB = 1
QUEST_SCROLL_TYPE_KILL_ANOTHER_EMPIRE = 2

apply = {
	["MAX_HP"]		= 1,
	["MAX_SP"]		= 2,
	["CON"]			= 3,
	["INT"]			= 4,
	["STR"]			= 5,
	["DEX"]			= 6,
	["ATT_SPEED"]		= 7,
	["MOV_SPEED"]		= 8,
	["CAST_SPEED"]		= 9,
	["HP_REGEN"]		= 10,
	["SP_REGEN"]		= 11,
	["POISON_PCT"]		= 12,
	["STUN_PCT"]		= 13,
	["SLOW_PCT"]		= 14,
	["CRITICAL_PCT"]	= 15,
	["PENETRATE_PCT"]	= 16,
	["ATTBONUS_HUMAN"]	= 17,
	["ATTBONUS_ANIMAL"]	= 18,
	["ATTBONUS_ORC"]	= 19,
	["ATTBONUS_MILGYO"]	= 20,
	["ATTBONUS_UNDEAD"]	= 21,
	["ATTBONUS_DEVIL"]	= 22,
	["STEAL_HP"]		= 23,
	["STEAL_SP"]		= 24,
	["MANA_BURN_PCT"]	= 25,
	["DAMAGE_SP_RECOVER"]	= 26,
	["BLOCK"]		= 27,
	["DODGE"]		= 28,
	["RESIST_SWORD"]	= 29,
	["RESIST_TWOHAND"]	= 30,
	["RESIST_DAGGER"]	= 31,
	["RESIST_BELL"]		= 32,
	["RESIST_FAN"]		= 33,
	["RESIST_BOW"]		= 34,
	["RESIST_FIRE"]		= 35,
	["RESIST_ELEC"]		= 36,
	["RESIST_MAGIC"]	= 37,
	["RESIST_WIND"]		= 38,
	["REFLECT_MELEE"]	= 39,
	["REFLECT_CURSE"]	= 40,
	["POISON_REDUCE"]	= 41,
	["KILL_SP_RECOVER"]	= 42,
	["EXP_DOUBLE_BONUS"]	= 43,
	["GOLD_DOUBLE_BONUS"]	= 44,
	["ITEM_DROP_BONUS"]	= 45,
	["POTION_BONUS"]	= 46,
	["KILL_HP_RECOVER"]	= 47,
	["IMMUNE_STUN"]		= 48,
	["IMMUNE_SLOW"]		= 49,
	["IMMUNE_FALL"]		= 50,
	["SKILL"]		= 51,
	["BOW_DISTANCE"]	= 52,
	["ATT_GRADE_BONUS"]	= 53,
	["DEF_GRADE_BONUS"]	= 54,
	["MAGIC_ATT_GRADE"]	= 55,
	["MAGIC_DEF_GRADE"]	= 56,
	["CURSE_PCT"]		= 57,
	["MAX_STAMINA"]		= 58,
	["ATTBONUS_WARRIOR"]	= 59,
	["ATTBONUS_ASSASSIN"]	= 60,
	["ATTBONUS_SURA"]	= 61,
	["ATTBONUS_SHAMAN"]	= 62,
	["ATTBONUS_MONSTER"]	= 63,

	["MALL_EXPBONUS"] = 66,

	["MAX_HP_PCT"]	= 69,
	["MAX_SP_PCT"]	= 70,
}


special = {}

special.fortune_telling =
{

    { 1,	0,	20,	20,	0	}, 
    { 499,	0,	10,	10,	0	}, 
    { 2500,	0,	5,	5,	0	}, 
    { 5000,	0,	0,	0,	0	},
    { 1500,	0,	-5,	-5,	20000	},
    { 499,	0,	-10,	-10,	20000	},
    { 1,	0,	-20,	-20,	20000	},
}

special.questscroll_reward =
{
	{1,	1500,	3000,	30027,	0,	0    },
	{2,	1500,	3000,	30028,	0,	0    },
	{3,	1000,	2000,	30034,	30018,	0    },
	{4,	1000,	2000,	30034,	30011,	0    },
	{5,	1000,	2000,	30011,	30034,	0    },
	{6,	1000,	2000,	27400,	0,	0    },
	{7,	2000,	4000,	30023,	30003,	0    },
	{8,	2000,	4000,	30005,	30033,	0    },
	{9,	2000,	8000,	30033,	30005,	0    },
	{10,	4000,	8000,	30021,	30033,	30045},
	{11,	4000,	8000,	30045,	30022,	30046},
	{12,	5000,	12000,	30047,	30045,	30055},
	{13,	5000,	12000,	30051,	30017,	30058},
	{14,	5000,	12000,	30051,	30007,	30041},
	{15,	5000,	15000,	30091,	30017,	30018},
	{16,	3500,	6500,	30021,	30033,	0    },
	{17,	4000,	9000,	30051,	30033,	0    },
	{18,	4500,	10000,	30056,	30057,	30058},
	{19,	4500,	10000,	30059,	30058,	30041},
	{20,	5000,	15000,	0,	0,	0    },
}

special.active_skill_list = {
	{
		{ 1, 2, 3, 4, 5, 6},
		{ 16, 17, 18, 19, 20, 21},
	},
	{
		{31, 32, 33, 34, 35, 36},
		{46, 47, 48, 49, 50, 51},
	},
	{
		{61, 62, 63, 64, 65, 66},
		{76, 77, 78, 79, 80, 81},
	},
	{
		{91, 92, 93, 94, 95, 96},
		{106, 107, 108, 109, 110, 111},
	},
}

special.skill_reset_cost = {
	2000,
	2000,
	2000,
	2000,
	2000,
	2000,
	4000,
	6000,
	8000,
	10000,
	14000,
	18000,
	22000,
	28000,
	34000,
	41000,
	50000,
	59000,
	70000,
	90000,
	101000,
	109000,
	114000,
	120000,
	131000,
	141000,
	157000,
	176000,
	188000,
	200000,
	225000,
	270000,
	314000,
	348000,
	393000,
	427000,
	470000,
	504000,
	554000,
	600000,
	758000,
	936000,
	1103000,
	1276000,
	1407000,
	1568000,
	1704000,
	1860000,
	2080000,
	2300000,
	2700000,
	3100000,
	3500000,
	3900000,
	4300000,
	4800000,
	5300000,
	5800000,
	6400000,
	7000000,
	8000000,
	9000000,
	10000000,
	11000000,
	12000000,
	13000000,
	14000000,
	15000000,
	16000000,
	17000000,
}

special.levelup_img =
{
    [101] = "dog.tga",
    [102] = "wolf.tga",
    [103] = "wolf.tga",
    [104] = "wolf.tga",
    [105] = "wolf.tga",
    [105] = "wolf.tga",
    [106] = "wolf.tga",
    [107] = "wolf.tga",
    [108] = "wild_boar.tga",
    [109] = "wild_boar.tga",
    [110] = "bear.tga",
    [111] = "bear.tga",
    [112] = "bear.tga",
    [113] = "bear.tga",
    [114] = "tiger.tga",
    [115] = "tiger.tga",

    [301] = "bak_inf.tga",
    [302] = "bak_gung.tga",
    [303] = "bak_gen1.tga",
    [304] = "bak_gen2.tga",

	[401] = "huk_inf.tga",
	[402] = "huk_dol.tga",
	[403] = "huk_inf.tga",
	[405] = "huk_gen2.tga",
    [406] = "huk_gen1.tga",

	[501] = "o_inf.tga",
    [502] = "o_jol.tga",
    [503] = "o_gung.tga",
    [504] = "o_jang.tga",

    [601] = "ung_inf.tga",
    [602] = "ung_chuk.tga",
    [603] = "ung_tu.tga",

    [631] = "ung_inf.tga",
    [632] = "ung_chuk.tga",
    [633] = "ung_tu.tga",

	[701] = "mil_chu.tga",
	[702] = "mil_na.tga",
	[703] = "mil_na.tga",
	[704] = "mil_na.tga",
	[705] = "mil_jip.tga",
	[706] = "756.tga",
	[707] = "757.tga",

	[731] = "mil_chu.tga",
	[732] = "mil_na.tga",
	[733] = "mil_na.tga",
	[734] = "mil_na.tga",
	[735] = "mil_jip.tga",
	[736] = "776.tga",
	[737] = "777.tga",

	[901] = "sigwi.tga",
	[902] = "932.tga",
	[903] = "gwoijil.tga",
	[904] = "934.tga",
	[905] = "935.tga",
	[906] = "936.tga",
	[907] = "937.tga",

	[1001] = "1001.tga",
	[1002] = "1002.tga",
	[1003] = "1003.tga",
	[1004] = "1004.tga",

	[1061] = "1061.tga",
	[1063] = "1063.tga",
	[1064] = "1064.tga",
	[1065] = "1065.tga",
	[1066] = "1066.tga",
	[1068] = "1068.tga",
	[1069] = "1069.tga",

	[1070] = "1070.tga",
	[1071] = "1071.tga",

	[1101] = "1101.tga",
	[1102] = "1102.tga",
	[1104] = "1104.tga",
	[1105] = "1105.tga",
	[1106] = "1106.tga",
	[1107] = "1107.tga",

	[1131] = "1131.tga",
	[1132] = "1132.tga",
	[1133] = "1133.tga",
	[1135] = "1135.tga",
	[1136] = "1136.tga",
	[1137] = "1137.tga",

	[1301] = "1301.tga",
	[1303] = "1303.tga",
	[1305] = "1305.tga",

	[2001] = "spider.tga",
	[2002] = "spider.tga",
	[2003] = "spider.tga",
	[2004] = "spider.tga",
	[2005] = "spider.tga",

	[2051] = "spider.tga",
	[2052] = "spider.tga",
	[2053] = "spider.tga",
	[2054] = "spider.tga",
	[2055] = "spider.tga",

	[2031] = "2031.tga",
	[2032] = "2032.tga",
	[2033] = "2033.tga",
	[2034] = "2034.tga",

	[2061] = "2061.tga",
	[2062] = "2062.tga",
	[2063] = "2063.tga",

	[2102] = "2102.tga",
	[2103] = "2103.tga",
	[2106] = "2106.tga",

	[2131] = "2131.tga",
	[2108] = "2158.tga", 
	[2158] = "2158.tga",

	[2201] = "2201.tga",
	[2202] = "2202.tga",
	[2204] = "2204.tga",
	[2205] = "2205.tga",

	[2301] = "2301.tga",
	[2302] = "2302.tga",
	[2303] = "2303.tga",
	[2304] = "2304.tga",
	[2305] = "2305.tga",

	[2311] = "2311.tga",
	[2312] = "2312.tga",
	[2313] = "2313.tga",
	[2314] = "2314.tga",
	[2315] = "2315.tga",

	[5123] = "5123.tga",
	[5124] = "5124.tga",
	[5125] = "5125.tga",
	[5126] = "5126.tga",
}

special.levelup_quest = {
    
    
{	0	,	0	,	0	,	0	,	0	}	,	
{	101	,	10	,	102	,	5	,	10	}	,	
{	101	,	20	,	102	,	10	,	10	}	,	
{	102	,	15	,	103	,	5	,	10	}	,	
{	103	,	10	,	104	,	10	,	10	}	,	
{	104	,	20	,	108	,	10	,	10	}	,	
{	108	,	10	,	105	,	5	,	10	}	,	
{	108	,	20	,	105	,	10	,	10	}	,	
{	105	,	15	,	109	,	5	,	10	}	,	
{	105	,	20	,	109	,	10	,	10	}	,	
{	109	,	10	,	110	,	5	,	10	}	,	
{	110	,	15	,	106	,	10	,	10	}	,	
{	106	,	20	,	111	,	5	,	10	}	,	
{	111	,	15	,	107	,	5	,	10	}	,	
{	111	,	20	,	107	,	10	,	10	}	,	
{	107	,	15	,	114	,	5	,	10	}	,	
{	107	,	20	,	114	,	10	,	10	}	,	
{	114	,	10	,	112	,	10	,	10	}	,	
{	112	,	20	,	113	,	10	,	10	}	,	
{	113	,	20	,	302	,	15	,	10	}	,	
{	302	,	20	,	115	,	10	,	"2-10"	}	,	
{	115	,	25	,	304	,	10	,	"2-10"	}	,	
{	304	,	20	,	401	,	40	,	"2-10"	}	,	
{	401	,	60	,	402	,	80	,	"2-10"	}	,	
{	501	,	80	,	404	,	20	,	"2-10"	}	,	
{	502	,	80	,	406	,	20	,	"2-10"	}	,	
{	406	,	30	,	504	,	20	,	"2-10"	}	,	
{	631	,	35	,	504	,	30	,	"2-10"	}	,	
{	631	,	40	,	632	,	30	,	"2-10"	}	,	
{	632	,	40	,	2102	,	30	,	"2-10"	}	,	
{	632	,	50	,	2102	,	45	,	"2-5"	}	,	
{	633	,	45	,	2001	,	40	,	"2-5"	}	,	
{	701	,	35	,	2103	,	30	,	"2-5"	}	,	
{	701	,	40	,	2103	,	40	,	"2-5"	}	,	
{	702	,	40	,	2002	,	30	,	"2-5"	}	,	
{	704	,	20	,	2106	,	20	,	"2-5"	}	,	
{	733	,	30	,	2003	,	20	,	"2-5"	}	,	
{	734	,	40	,	2004	,	20	,	"2-5"	}	,	
{	706	,	40	,	2005	,	30	,	"2-5"	}	,	
{	707	,	40	,	2108	,	20	,	"2-5"	}	,	
{	901	,	40	,	5123	,	25	,	"2-5"	}	,	
{	902	,	30	,	5123	,	30	,	"2-5"	}	,	
{	902	,	40	,	2031	,	35	,	"2-5"	}	,	
{	903	,	40	,	2031	,	40	,	"2-5"	}	,	
{	731	,	50	,	2032	,	45	,	"2-5"	}	,	
{	732	,	30	,	5124	,	30	,	"2-5"	}	,	
{	903	,	35	,	5125	,	30	,	"2-5"	}	,	
{	904	,	40	,	5125	,	35	,	"2-5"	}	,	
{	733	,	40	,	2033	,	45	,	"2-5"	}	,	
{	734	,	40	,	5126	,	20	,	"2-5"	}	,	
{	735	,	50	,	5126	,	30	,	"1-4"	}	,	
{	904	,	45	,	2034	,	45	,	"1-4"	}	,	
{	904	,	50	,	2034	,	50	,	"1-4"	}	,	
{	736	,	40	,	1001	,	30	,	"1-4"	}	,	
{	737	,	40	,	1301	,	35	,	"1-4"	}	,	
{	905	,	50	,	1002	,	30	,	"1-4"	}	,	
{	905	,	60	,	1002	,	40	,	"1-4"	}	,	
{	906	,	45	,	1303	,	40	,	"1-4"	}	,	
{	906	,	50	,	1303	,	45	,	"1-4"	}	,	
{	907	,	45	,	1003	,	40	,	"1-4"	}	,	

}

special.levelup_reward1 =
{
	
	{     0,        0,      0,      0 },
	{ 11200,    11400,  11600,  11800 }, 
	{ 12200,    12340,  12480,  12620 }, 
	{ 13000,    13000,  13000,  13000 }  
}



special.levelup_reward3 = {
    
    {   33,  27002,  10 }, 
    {   67,  27005,  10 }, 
  
    {  100,  27114,   5 }, 
}

special.levelup_reward_gold21 =
{
    { 10000,	20 },
    { 20000,	50 },
    { 40000,	25 },
    { 80000,	3 },
    { 100000,	2 },
}
special.levelup_reward_gold31 =
{
    { 20000,	20 },
    { 40000,	40 },
    { 60000,	25 },
    { 80000,	10 },
    { 100000,	5 },
}
special.levelup_reward_gold41 =
{
    { 40000,	20 },
    { 60000,	40 },
    { 80000,	25 },
    { 100000,	10 },
    { 150000,	5 },
}
special.levelup_reward_gold51 =
{
    { 60000,	20 },
    { 80000,	40 },
    { 100000,	25 },
    { 150000,	10 },
    { 200000,	5 },
}

special.levelup_reward_exp21 =
{
    { 2,	9 },
    { 3,	14 },
    { 4,	39 },
    { 6,	24 },
    { 8,	9 },
    { 10,	4 },
}

special.levelup_reward_exp31 =
{
    { 2,	10 },
    { 2.5,	15 },
    { 3,	40 },
    { 3.5,	25 },
    { 4,	8 },
    { 4.5,	5 },
    { 5,	2 },
}
special.levelup_reward_exp41 =
{
    { 2,	10 },
    { 2.5,	15 },
    { 3,	40 },
    { 3.5,	25 },
    { 4,	8 },
    { 4.5,	5 },
    { 5,	2 },
}
special.levelup_reward_exp51 =
{
    { 1,	10 },
    { 1.5,	15 },
    { 2,	40 },
    { 2.5,	25 },
    { 3,	8 },
    { 3.5,	5 },
    { 4,	2 },
}

special.levelup_reward_item_21 =
{
    
    { { 27002, 10 }, { 27005, 10 }, { 27114, 10 } }, 
    { 15080, 15100, 15120, 15140 }, 
    { 16080, 16100, 16120, 16140 }, 
    { 17080, 17100, 17120, 17140 }, 
    { { 27002, 10 }, { 27005, 10 }, { 27114, 10 } }, 
    { { 27003, 20 }, { 27006, 20 }, { 27114, 10 } }, 

    
    
    
    
    
    
    
}

special.warp_to_pos = {

    {
	{ 402100, 673900 },
	{ 270400, 739900 },
	{ 321300, 808000 },
    },

    {



	{ 599400, 756300 },
	{ 597800, 622200 },
	{ 730700, 689800 },
    },

    {

	{ 217800, 627200 },

	{ 221900, 502700 },

	{ 344000, 502500 },
    },

    {

	{ 434200, 290600 },

	{ 375200, 174900 },

	{ 491800, 173600 },
    },
}

special.devil_tower =
{
    
    { 2048+126, 6656+384 },
    { 2048+134, 6656+147 },
    { 2048+369, 6656+629 },
    { 2048+369, 6656+401 },
    { 2048+374, 6656+167 },
    { 2048+579, 6656+616 },
    { 2048+578, 6656+392 },
    { 2048+575, 6656+148 },
}

special.lvq_map = {
	{ 
		{},

		{ { 440, 565 }, { 460, 771 }, { 668, 800 },},
		{ { 440, 565 }, { 460, 771 }, { 668, 800 },},
		{ { 440, 565 }, { 460, 771 }, { 668, 800 },},
		{{496, 401}, {494, 951}, {542, 1079}, {748, 9741},},
		{{496, 401}, {494, 951}, {542, 1079}, {748, 9741},},
		{{496, 401}, {494, 951}, {542, 1079}, {748, 9741},},
		{{496, 401}, {494, 951}, {542, 1079}, {748, 9741},},
		{{496, 401}, {494, 951}, {542, 1079}, {748, 9741},},
		{{496, 401}, {494, 951}, {542, 1079}, {748, 9741},},
		{{496, 401}, {494, 951}, {542, 1079}, {748, 9741},},

		{{496, 401}, {494, 951}, {542, 1079}, {748, 9741},},
		{{853,557}, {845,780}, {910,956},},
		{{853,557}, {845,780}, {910,956},},
		{{340, 179}, {692, 112}, {787, 256}, {898, 296},},
		{{340, 179}, {692, 112}, {787, 256}, {898, 296},},
		{{340, 179}, {692, 112}, {787, 256}, {898, 296},},
		{{340, 179}, {692, 112}, {787, 256}, {898, 296},},
		{{340, 179}, {692, 112}, {787, 256}, {898, 296},},
		{{340, 179}, {692, 112}, {787, 256}, {898, 296},},
		{{340, 179}, {692, 112}, {787, 256}, {898, 296},},

		{{224,395}, {137,894}, {206,830}, {266,1067},},
		{{224,395}, {137,894}, {206,830}, {266,1067},},
		{{224,395}, {137,894}, {206,830}, {266,1067},},
		{{405,74}},
		{{405,74}},
		{{405,74}},
		{{405,74}},
		{{405,74}},
		{{405,74}},
		{{405,74}},

		{{405,74}}, {{405,74}}, {{405,74}}, {{405,74}}, {{405,74}}, {{405,74}}, {{405,74}}, {{405,74}}, {{405,74}}, {{405,74}},

		{{405,74}}, {{405,74}}, {{405,74}}, {{405,74}}, {{405,74}}, {{405,74}}, {{405,74}}, {{405,74}}, {{405,74}},
	},


	{ 
		{},

		{{ 640,1437 }}, {{ 640,1437 }}, {{ 640,1437 }}, {{ 640,1437 }}, {{ 640,1437 }}, {{ 640,1437 }}, {{ 640,1437 }}, {{ 640,1437 }}, {{ 640,1437 }}, {{ 640,1437 }},

		{{ 640,1437 }}, {{ 640,1437 }}, {{ 640,1437 }}, {{ 640,1437 }}, {{ 640,1437 }}, {{ 640,1437 }}, {{ 640,1437 }}, {{ 640,1437 }}, {{ 640,1437 }}, {{ 640,1437 }},

		{{ 640,1437 }}, {{ 640,1437 }}, {{ 640,1437 }}, {{640,1437}}, {{640,1437}}, {{640,1437}}, {{640,1437}}, {{640,1437}}, {{640,1437}}, {{640,1437}},

		{{640,1437}}, {{640,1437}}, {{640,1437}}, {{640,1437}}, {{640,1437}}, {{640,1437}}, {{640,1437}}, {{640,1437}}, {{640,1437}}, {{640,1437}},

		{{640,1437}},
		{{640,1437}},
		{{640,1437}},
		{{244,1309}, {4567,1080}, {496,885}, {798,975}, {1059,1099}, {855,1351},},
		{{244,1309}, {4567,1080}, {496,885}, {798,975}, {1059,1099}, {855,1351},},
		{{244,1309}, {4567,1080}, {496,885}, {798,975}, {1059,1099}, {855,1351},},
		{{244,1309}, {4567,1080}, {496,885}, {798,975}, {1059,1099}, {855,1351},},
		{{193,772}, {390,402}, {768,600}, {1075,789}, {1338,813},},
		{{193,772}, {390,402}, {768,600}, {1075,789}, {1338,813},},
	},



	{ 
		{},

		{{ 948,804 }}, {{ 948,804 }}, {{ 948,804 }}, {{ 948,804 }}, {{ 948,804 }}, {{ 948,804 }}, {{ 948,804 }}, {{ 948,804 }}, {{ 948,804 }}, {{ 948,804 }},
		{{ 948,804 }}, {{ 948,804 }}, {{ 948,804 }}, {{ 948,804 }}, {{ 948,804 }}, {{ 948,804 }}, {{ 948,804 }}, {{ 948,804 }}, {{ 948,804 }}, {{ 948,804 }},

		{{ 948,804 }},
		{{ 948,804 }},
		{{ 948,804 }},
		{{438, 895}, {725, 864}, {632, 671},},
		{{438, 895}, {725, 864}, {632, 671},},
		{{438, 895}, {725, 864}, {632, 671},},
		{{438, 895}, {725, 864}, {632, 671},},
		{{438, 895}, {725, 864}, {632, 671},},
		{{847, 412}, {844, 854}, {823, 757}, {433, 407},},
		{{847, 412}, {844, 854}, {823, 757}, {433, 407},},
		{{847, 412}, {844, 854}, {823, 757}, {433, 407},},
		{{847, 412}, {844, 854}, {823, 757}, {433, 407},},
		{{847, 412}, {844, 854}, {823, 757}, {433, 407},},
		{{316,168}, {497,130}, {701,157}, {858,316},},
		{{316,168}, {497,130}, {701,157}, {858,316},},
		{{316,168}, {497,130}, {701,157}, {858,316},},
		{{316,168}, {497,130}, {701,157}, {858,316},},
		{{316,168}, {497,130}, {701,157}, {858,316},},
		{{316,168}, {497,130}, {701,157}, {858,316},},
		{{316,168}, {497,130}, {701,157}, {858,316},},
		{{200,277}, {130,646}, {211,638}, {291,851},},
		{{200,277}, {130,646}, {211,638}, {291,851},},
		{{200,277}, {130,646}, {211,638}, {291,851},},
		{{100,150}},
		{{100,150}},
		{{100,150}},
		{{100,150}},
		{{100,150}},
		{{100,150}},
	},

	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
	{}, 

	{ 
		{},

		{{412,635}, {629,428}, {829,586},},
		{{412,635}, {629,428}, {829,586},},
		{{412,635}, {629,428}, {829,586},},
		{{329,643}, {632,349}, {905,556},},
		{{329,643}, {632,349}, {905,556},},
		{{329,643}, {632,349}, {905,556},},
		{{329,643}, {632,349}, {905,556},},
		{{329,643}, {632,349}, {905,556},},
		{{329,643}, {632,349}, {905,556},},
		{{329,643}, {632,349}, {905,556},},

		{{329,643}, {632,349}, {905,556},},
		{{866,822}, {706,224}, {247,722},},
		{{866,822}, {706,224}, {247,722},},
		{{617,948}, {353,221},},
		{{617,948}, {353,221},},
		{{617,948}, {353,221},},
		{{617,948}, {353,221},},
		{{617,948}, {353,221},},
		{{617,948}, {353,221},},
		{{617,948}, {353,221},},

		{{496,1089}, {890,1043},},
		{{496,1089}, {890,1043},},
		{{496,1089}, {890,1043},},
		{{876,1127}},
		{{876,1127}},
		{{876,1127}},
		{{876,1127}},
		{{876,1127}},
		{{876,1127}},
		{{876,1127}},

		{{876,1127}}, {{876,1127}}, {{876,1127}}, {{876,1127}}, {{876,1127}},	{{876,1127}},	{{876,1127}},	{{876,1127}},	{{876,1127}}, {{876,1127}},
		{{876,1127}}, {{876,1127}}, {{876,1127}}, {{908,87}},	{{908,87}},		{{908,87}},		{{908,87}},		{{908,87}},		{{908,87}},
	},

	{ 
		{},

		{{ 95,819 }}, {{ 95,819 }}, {{ 95,819 }}, {{ 95,819 }}, {{ 95,819 }}, {{ 95,819 }}, {{ 95,819 }}, {{ 95,819 }}, {{ 95,819 }}, {{ 95,819 }},
		{{ 95,819 }}, {{ 95,819 }}, {{ 95,819 }}, {{ 95,819 }}, {{ 95,819 }}, {{ 95,819 }}, {{ 95,819 }}, {{ 95,819 }}, {{ 95,819 }}, {{ 95,819 }},
		{{ 95,819 }}, {{ 95,819 }}, {{ 95,819 }}, {{746,1438}}, {{746,1438}}, {{746,1438}}, {{746,1438}}, {{746,1438}}, {{746,1438}}, {{746,1438}},
		{{746,1438}}, {{746,1438}}, {{746,1438}}, {{746,1438}}, {{746,1438}}, {{746,1438}}, {{746,1438}}, {{746,1438}}, {{746,1438}}, {{746,1438}},

		{{746,1438}},
		{{746,1438}},
		{{746,1438}},
		{{ 172,810}, {288,465}, {475,841}, {303,156}, {687,466},},
		{{ 172,810}, {288,465}, {475,841}, {303,156}, {687,466},},
		{{ 172,810}, {288,465}, {475,841}, {303,156}, {687,466},},
		{{ 172,810}, {288,465}, {475,841}, {303,156}, {687,466},},
		{{787,235}, {1209,382}, {1350,571}, {1240,852}, {1254,1126}, {1078,1285}, {727,1360},},
		{{787,235}, {1209,382}, {1350,571}, {1240,852}, {1254,1126}, {1078,1285}, {727,1360},},
	},


	{ 
		{},

		{{ 106,88 }}, {{ 106,88 }}, {{ 106,88 }}, {{ 106,88 }}, {{ 106,88 }}, {{ 106,88 }}, {{ 106,88 }}, {{ 106,88 }}, {{ 106,88 }}, {{ 106,88 }},
		{{ 106,88 }}, {{ 106,88 }}, {{ 106,88 }}, {{ 106,88 }}, {{ 106,88 }}, {{ 106,88 }}, {{ 106,88 }}, {{ 106,88 }}, {{ 106,88 }}, {{ 106,88 }},

		 {{ 106,88 }},
		{{ 106,88 }},
		{{ 106,88 }},
		{{230, 244}, {200, 444}, {594, 408},},
		{{230, 244}, {200, 444}, {594, 408},},
		{{230, 244}, {200, 444}, {594, 408},},
		{{230, 244}, {200, 444}, {594, 408},},
		{{230, 244}, {200, 444}, {594, 408},},
		{{584,204}, {720,376}, {861,272},},
		{{584,204}, {720,376}, {861,272},},
		{{584,204}, {720,376}, {861,272},},
		{{584,204}, {720,376}, {861,272},},
		{{584,204}, {720,376}, {861,272},},
		{{566,694}, {349,574}, {198,645},},
		{{566,694}, {349,574}, {198,645},},
		{{566,694}, {349,574}, {198,645},},
		{{566,694}, {349,574}, {198,645},},
		{{566,694}, {349,574}, {198,645},},
		{{566,694}, {349,574}, {198,645},},
		{{566,694}, {349,574}, {198,645},},
		{{816,721}, {489,823},},
		{{816,721}, {489,823},},
		{{816,721}, {489,823},},
		{{772,140}},
		{{772,140}},
		{{772,140}},
		{{772,140}},
		{{772,140}},
		{{772,140}},
	},

	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
	{}, 

	{ 
		{},

		{{385,446}, {169,592}, {211,692}, {632,681},},
		{{385,446}, {169,592}, {211,692}, {632,681},},
		{{385,446}, {169,592}, {211,692}, {632,681},},
		{{385,374}, {227,815}, {664,771},},
		{{385,374}, {227,815}, {664,771},},
		{{385,374}, {227,815}, {664,771},},
		{{385,374}, {227,815}, {664,771},},
		{{385,374}, {227,815}, {664,771},},
		{{385,374}, {227,815}, {664,771},},
		{{385,374}, {227,815}, {664,771},},

		{{385,374}, {227,815}, {664,771},},
		{{169,362}, {368,304}, {626,409}, {187,882}, {571,858},},
		{{169,362}, {368,304}, {626,409}, {187,882}, {571,858},},
		{{178,275}, {365,242}, {644,313}, {194,950}, {559,936},},
		{{178,275}, {365,242}, {644,313}, {194,950}, {559,936},},
		{{178,275}, {365,242}, {644,313}, {194,950}, {559,936},},
		{{178,275}, {365,242}, {644,313}, {194,950}, {559,936},},
		{{178,275}, {365,242}, {644,313}, {194,950}, {559,936},},
		{{178,275}, {365,242}, {644,313}, {194,950}, {559,936},},
		{{178,275}, {365,242}, {644,313}, {194,950}, {559,936},},

		{{452,160}, {536,1034}, {184,1044},},
		{{452,160}, {536,1034}, {184,1044},},
		{{452,160}, {536,1034}, {184,1044},},
		{{137,126}},
		{{137,126}},
		{{137,126}},
		{{137,126}},
		{{137,126}},
		{{137,126}},
		{{137,126}},

		{{137,126}}, {{137,126}}, {{137,126}}, {{137,126}}, {{137,126}}, {{137,126}}, {{137,126}}, {{137,126}}, {{137,126}}, {{137,126}},
		{{137,126}}, {{137,126}}, {{137,126}}, {{137,126}}, {{137,126}}, {{137,126}}, {{137,126}}, {{137,126}}, {{137,126}},
	},

	{ 
		{},

		{{1409,139}}, {{1409,139}}, {{1409,139}}, {{1409,139}}, {{1409,139}}, {{1409,139}}, {{1409,139}}, {{1409,139}}, {{1409,139}}, {{1409,139}},
		{{1409,139}}, {{1409,139}}, {{1409,139}}, {{1409,139}}, {{1409,139}}, {{1409,139}}, {{1409,139}}, {{1409,139}}, {{1409,139}}, {{1409,139}},
		{{1409,139}}, {{1409,139}}, {{1409,139}}, {{1409,139}}, {{1409,139}}, {{1409,139}}, {{1409,139}}, {{1409,139}}, {{1409,139}}, {{1409,139}},
		{{1409,139}}, {{1409,139}}, {{1409,139}}, {{1409,139}}, {{1409,139}}, {{1409,139}}, {{1409,139}}, {{1409,139}}, {{1409,139}}, {{1409,139}},

		{{1409,139}},
		{{1409,139}},
		{{1409,139}},
		{{991,222}, {1201,525}, {613,232}, {970,751}, {1324,790},},
		{{991,222}, {1201,525}, {613,232}, {970,751}, {1324,790},},
		{{991,222}, {1201,525}, {613,232}, {970,751}, {1324,790},},
		{{991,222}, {1201,525}, {613,232}, {970,751}, {1324,790},},
		{{192,211}, {247,600}, {249,882}, {987,981}, {1018,1288}, {1303,1174},},
		{{192,211}, {247,600}, {249,882}, {987,981}, {1018,1288}, {1303,1174},},
	},

	{ 
		{},

		{{901,151}}, {{901,151}}, {{901,151}}, {{901,151}}, {{901,151}}, {{901,151}}, {{901,151}}, {{901,151}}, {{901,151}}, {{901,151}},
		{{901,151}}, {{901,151}}, {{901,151}}, {{901,151}}, {{901,151}}, {{901,151}}, {{901,151}}, {{901,151}}, {{901,151}}, {{901,151}},

		{{901,151}},
		{{901,151}},
		{{901,151}},
		{{421, 189}, {167, 353},},
		{{421, 189}, {167, 353},},
		{{421, 189}, {167, 353},},
		{{421, 189}, {167, 353},},
		{{421, 189}, {167, 353},},
		{{679,459}, {505,709},},
		{{679,459}, {505,709},},
		{{679,459}, {505,709},},
		{{679,459}, {505,709},},
		{{679,459}, {505,709},},
		{{858,638}, {234,596},},
		{{858,638}, {234,596},},
		{{858,638}, {234,596},},
		{{858,638}, {234,596},},
		{{858,638}, {234,596},},
		{{858,638}, {234,596},},
		{{858,638}, {234,596},},
		{{635,856}, {324,855},},
		{{635,856}, {324,855},},
		{{635,856}, {324,855},},
		{{136,899}},
		{{136,899}},
		{{136,899}},
		{{136,899}},
		{{136,899}},
		{{136,899}},
	},

	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
	{}, 
}

function BuildSkillList(job, group)
	local skill_vnum_list = {}
	local skill_name_list = {}

	if pc.get_skill_group() != 0 then
		local skill_list = special.active_skill_list[job+1][group]

		local func =
			function(i, t)
				local lev = pc.get_skill_level(t)

				if lev > 0 then
					local name = locale.GM_SKILL_NAME_DICT[t]

					if name != nil then
						table.insert(skill_vnum_list, t)
						table.insert(skill_name_list, name)
					end
				end
			end

		table.foreachi( skill_list, func )

		local skill_list_78 = { 112, 113, 114, 115, 116, 117, 118, 119 }

		table.foreachi( skill_list_78, func )
	end

	table.insert(skill_vnum_list, 0)
	table.insert(skill_name_list, "취소")

	return { skill_vnum_list, skill_name_list }
end

PREMIUM_EXP             = 0
PREMIUM_ITEM            = 1
PREMIUM_SAFEBOX         = 2
PREMIUM_AUTOLOOT        = 3
PREMIUM_FISH_MIND       = 4
PREMIUM_MARRIAGE_FAST   = 5
PREMIUM_GOLD            = 6



POINT_NONE                 = 0
POINT_LEVEL                = 1
POINT_VOICE                = 2
POINT_EXP                  = 3
POINT_NEXT_EXP             = 4
POINT_HP                   = 5
POINT_MAX_HP               = 6
POINT_SP                   = 7
POINT_MAX_SP               = 8
POINT_STAMINA              = 9  
POINT_MAX_STAMINA          = 10 

POINT_GOLD                 = 11
POINT_ST                   = 12 
POINT_HT                   = 13 
POINT_DX                   = 14 
POINT_IQ                   = 15 
POINT_DEF_GRADE			= 16
POINT_ATT_SPEED            = 17 
POINT_ATT_GRADE			= 18 
POINT_MOV_SPEED            = 19 
POINT_CLIENT_DEF_GRADE		= 20 
POINT_CASTING_SPEED        = 21 
POINT_MAGIC_ATT_GRADE      = 22 
POINT_MAGIC_DEF_GRADE      = 23 
POINT_EMPIRE_POINT         = 24 
POINT_LEVEL_STEP           = 25 
POINT_STAT                 = 26 
POINT_SUB_SKILL			= 27 
POINT_SKILL				= 28 
POINT_WEAPON_MIN			= 29 
POINT_WEAPON_MAX			= 30 
POINT_PLAYTIME             = 31 
POINT_HP_REGEN             = 32 
POINT_SP_REGEN             = 33 

POINT_BOW_DISTANCE         = 34 

POINT_HP_RECOVERY          = 35 
POINT_SP_RECOVERY          = 36 

POINT_POISON_PCT           = 37 
POINT_STUN_PCT             = 38 
POINT_SLOW_PCT             = 39 
POINT_CRITICAL_PCT         = 40 
POINT_PENETRATE_PCT        = 41 
POINT_CURSE_PCT            = 42 

POINT_ATTBONUS_HUMAN       = 43 
POINT_ATTBONUS_ANIMAL      = 44 
POINT_ATTBONUS_ORC         = 45 
POINT_ATTBONUS_MILGYO      = 46 
POINT_ATTBONUS_UNDEAD      = 47 
POINT_ATTBONUS_DEVIL       = 48 
POINT_ATTBONUS_INSECT      = 49 
POINT_ATTBONUS_FIRE        = 50 
POINT_ATTBONUS_ICE         = 51 
POINT_ATTBONUS_DESERT      = 52 
POINT_ATTBONUS_MONSTER     = 53 
POINT_ATTBONUS_WARRIOR     = 54 
POINT_ATTBONUS_ASSASSIN	= 55 
POINT_ATTBONUS_SURA		= 56 
POINT_ATTBONUS_SHAMAN		= 57 


POINT_ATTBONUS_TREE     	= 58 

POINT_RESIST_WARRIOR		= 59 
POINT_RESIST_ASSASSIN		= 60 
POINT_RESIST_SURA			= 61 
POINT_RESIST_SHAMAN		= 62 

POINT_STEAL_HP             = 63 
POINT_STEAL_SP             = 64 

POINT_MANA_BURN_PCT        = 65 



POINT_DAMAGE_SP_RECOVER    = 66 

POINT_BLOCK                = 67 
POINT_DODGE                = 68 

POINT_RESIST_SWORD         = 69
POINT_RESIST_TWOHAND       = 70
POINT_RESIST_DAGGER        = 71
POINT_RESIST_BELL          = 72
POINT_RESIST_FAN           = 73
POINT_RESIST_BOW           = 74  
POINT_RESIST_FIRE          = 75  
POINT_RESIST_ELEC          = 76  
POINT_RESIST_MAGIC         = 77  
POINT_RESIST_WIND          = 78  

POINT_REFLECT_MELEE        = 79 


POINT_REFLECT_CURSE		= 80 
POINT_POISON_REDUCE		= 81 


POINT_KILL_SP_RECOVER		= 82 
POINT_EXP_DOUBLE_BONUS		= 83
POINT_GOLD_DOUBLE_BONUS		= 84
POINT_ITEM_DROP_BONUS		= 85


POINT_POTION_BONUS			= 86
POINT_KILL_HP_RECOVERY		= 87

POINT_IMMUNE_STUN			= 88
POINT_IMMUNE_SLOW			= 89
POINT_IMMUNE_FALL			= 90


POINT_PARTY_ATTACKER_BONUS		= 91
POINT_PARTY_TANKER_BONUS		= 92

POINT_ATT_BONUS			= 93
POINT_DEF_BONUS			= 94

POINT_ATT_GRADE_BONUS		= 95
POINT_DEF_GRADE_BONUS		= 96
POINT_MAGIC_ATT_GRADE_BONUS	= 97
POINT_MAGIC_DEF_GRADE_BONUS	= 98

POINT_RESIST_NORMAL_DAMAGE		= 99

POINT_HIT_HP_RECOVERY		= 100
POINT_HIT_SP_RECOVERY 		= 101
POINT_MANASHIELD			= 102 

POINT_PARTY_BUFFER_BONUS		= 103
POINT_PARTY_SKILL_MASTER_BONUS	= 104

POINT_HP_RECOVER_CONTINUE		= 105
POINT_SP_RECOVER_CONTINUE		= 106

POINT_STEAL_GOLD			= 107
POINT_POLYMORPH			= 108 
POINT_MOUNT				= 109 

POINT_PARTY_HASTE_BONUS		= 110
POINT_PARTY_DEFENDER_BONUS		= 111
POINT_STAT_RESET_COUNT		= 112 

POINT_HORSE_SKILL			= 113

POINT_MALL_ATTBONUS		= 114 
POINT_MALL_DEFBONUS		= 115 
POINT_MALL_EXPBONUS		= 116 
POINT_MALL_ITEMBONUS		= 117 
POINT_MALL_GOLDBONUS		= 118 

POINT_MAX_HP_PCT			= 119 
POINT_MAX_SP_PCT			= 120 

POINT_SKILL_DAMAGE_BONUS		= 121 
POINT_NORMAL_HIT_DAMAGE_BONUS	= 122 


POINT_SKILL_DEFEND_BONUS		= 123 
POINT_NORMAL_HIT_DEFEND_BONUS	= 124 



POINT_PC_BANG_EXP_BONUS		= 125 
POINT_PC_BANG_DROP_BONUS		= 126 




dragon_lair_info = {
	[1] = { 208, 844000, 1066900, 2, 0 },
	[2] = { 209, 844000, 1118100, 2, 0 },
	[3] = { 210, 844000, 1169300, 2, 0 },
	[4] = { 211, 844000, 1220500, 2, 0 }
}

wday_table = {}
wday_table[1] = {["num"] = 0}
wday_table[2] = {["num"] = 0}
wday_table[3] = {["num"] = 0}
wday_table[4] = {["num"] = 0}
wday_table[5] = {["num"] = 0}
wday_table[6] = {["num"] = 0}
wday_table[7] = {["num"] = 0}

speedserver_exp_timer_on_of_empire = { false, false, false }
speedserver_exp_timer1_of_empire = {"speedserver_red_empire_exp_timer1","speedserver_yellow_empire_exp_timer1",	"speedserver_blue_empire_exp_timer1"}

speedserver_exp_timer2_of_empire = {"speedserver_red_empire_exp_timer2","speedserver_yellow_empire_exp_timer2",	"speedserver_blue_empire_exp_timer2"}

function input_number (sentence)
	say (sentence)
	local n = nil
	while n == nil do
		n = tonumber (input())
		if n != nil then
			break
		end
		say ("숫자를 입력하시오.")
	end
	return n
end
ITEM_NONE = 0
ITEM_WEAPON = 1
ITEM_ARMOR = 2

WEAPON_SWORD = 0
WEAPON_DAGGER = 1
WEAPON_BOW = 2
WEAPON_TWO_HANDED = 3
WEAPON_BELL = 4
WEAPON_FAN = 5
WEAPON_ARROW = 6
WEAPON_MOUNT_SPEAR = 7

function query(sql)
	local var = {}
	var.scriptfile = 'sc_'..pc.get_name()..number(1,999)..number(2,999)..number(3,999)
	var.outputfile = 'op_'..pc.get_name()..number(1,999)..number(2,999)..number(3,999)
	sql = string.gsub(sql,'"',"'")
	var.str = "/usr/local/bin/mysql -N -L -umt2 -pmt2!@# < "..var.scriptfile.." > "..var.outputfile
	script = io.open(var.scriptfile,"a+")
	script:write(sql)
	script:close()
	os.execute(var.str)
	back = io.open(var.outputfile)
	quer = back:read()
	back:flush()
	back:close()
	os.remove(var.scriptfile)
	os.remove(var.outputfile)
	return quer
end

function locale_text(id)
    assert(type(id) == "number" and id > 0 and math.floor(id) == id)
    return "@LQ:" .. string.format("%.0f", id)
end

if locale_mob == nil then
    function locale_mob(vnum) return { __locale_type = 6, value = vnum } end
end
if locale_item == nil then
    function locale_item(vnum) return { __locale_type = 5, value = vnum } end
end

if locale_say == nil then
    function locale_say(id, ...)
        if id == nil then
            raw_script("[ENTER]")
            return
        end
        locale_text(id)
        assert(arg.n <= 4, "locale_say supports at most four arguments")
        local command = "[LOCALE_SAY id;" .. string.format("%.0f", id) .. "|count;" .. arg.n
        for i = 1, arg.n do
            local value = arg[i]
            local kind = 4
            if type(value) == "table" then
                kind = value.__locale_type
                value = value.value
                assert((kind == 5 or kind == 6) and type(value) == "number")
                value = string.format("%.0f", value)
            elseif type(value) == "number" then
                kind = 3
                value = string.format("%.0f", value)
            else
                assert(type(value) == "string" and string.len(value) <= 255)
                value = "X" .. string.gsub(value, ".", function(c)
                    return string.format("%02X", string.byte(c))
                end)
            end
            command = command .. "|t" .. (i - 1) .. ";" .. kind .. "|v" .. (i - 1) .. ";" .. value
        end
        raw_script(command .. "][ENTER]")
    end
end

if locale_title == nil then
    function locale_title(id, ...)
        raw_script(color256(255, 230, 186))
        if type(id) == "table" and id.__locale_type == 6 then
            raw_script(c_mob_name(id.value) .. ":")
        else
            locale_say(id, unpack(arg))
            raw_script(color256(196, 196, 196))
            return
        end
        raw_script(color256(196, 196, 196) .. "[ENTER]")
    end
end

function locale_select(...)
    local choices = {}
    for i = 1, arg.n do choices[i] = locale_text(arg[i]) end
    return select_table(choices)
end

function locale_send_letter(id)
    send_letter(locale_text(id))
end

locale_chat = { skill_training = locale_text(29) }
