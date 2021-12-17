/*
	GNU GENERAL PUBLIC LICENSE

	VERSION 2, JUNE 1991

	Copyright (C) 1989, 1991 Free Software Foundation, Inc.
	51 Franklin Street, Fith Floor, Boston, MA 02110-1301, USA

	Everyone is permitted to copy and distribute verbatim copies
	of this license document, but changing it is not allowed.

	GNU GENERAL PUBLIC LICENSE VERSION 3, 29 June 2007
	Copyright (C) 2007 Free Software Foundation, Inc. {http://fsf.org/}
	Everyone is permitted to copy and distribute verbatim copies
	of this license document, but changing it is not allowed.

							Preamble

	The GNU General Public License is a free, copyleft license for
	software and other kinds of works.

	The licenses for most software and other practical works are designed
	to take away your freedom to share and change the works. By contrast,
	the GNU General Public license is intended to guarantee your freedom to 
	share and change all versions of a progrm--to make sure it remins free
	software for all its users. We, the Free Software Foundation, use the
	GNU General Public license for most of our software; it applies also to
	any other work released this way by its authors. You can apply it to
	your programs, too.
*/
#include <sdktools>
#include <sdkhooks>
#include <cstrike>
#include <clientprefs>

float g_zoneStartOrigin[2][3]
float g_zoneEndOrigin[2][3]
Database g_mysql
float g_timerTimeStart[MAXPLAYERS + 1]
float g_timerTime[MAXPLAYERS + 1]
bool g_state[MAXPLAYERS + 1]
char g_map[192]
bool g_dbPassed
float g_cpOriginStart[3]

float g_cpPos[2][11][3]
bool g_cp[11][MAXPLAYERS + 1]
bool g_cpLock[11][MAXPLAYERS + 1]
float g_cpTimeClient[11][MAXPLAYERS + 1]
float g_cpDiff[11][MAXPLAYERS + 1]
float g_cpTime[11]

float g_recordHave[MAXPLAYERS + 1]
float g_ServerRecordTime

ConVar g_steamid //https://wiki.alliedmods.net/ConVars_(SourceMod_Scripting)
ConVar g_urlTop

bool g_menuOpened[MAXPLAYERS + 1]

int g_devmapCount[2]
bool g_devmap
float g_devmapTime

float g_cpOrigin[MAXPLAYERS + 1][2][3]
float g_cpAng[MAXPLAYERS + 1][2][3]
float g_cpVel[MAXPLAYERS + 1][2][3]
bool g_cpToggled[MAXPLAYERS + 1][2]

bool g_zoneHave[3]

bool g_ServerRecord
char g_date[64]
char g_time[64]

bool g_sourceTV

bool g_zoneFirst[3]

int g_zoneModel[3]
bool g_sourceTVchangedFilename = true
int g_cpCount
float g_afkTime
bool g_afk[MAXPLAYERS + 1]
float g_center[12][3]
bool g_zoneDraw[MAXPLAYERS + 1]
float g_engineTime
bool g_msg[MAXPLAYERS + 1]
int g_voters
int g_afkClient
bool g_hudVel[MAXPLAYERS + 1]
float g_hudTime[MAXPLAYERS + 1]
char g_clantag[MAXPLAYERS + 1][2][256]
//Handle g_clantagTimer[MAXPLAYERS + 1]
int g_points[MAXPLAYERS + 1]
Handle g_start
Handle g_record
int g_pointsMaxs = 1
int g_queryLast
Handle g_cookie
bool g_clantagOnce[MAXPLAYERS + 1]
bool g_jumped[MAXPLAYERS + 1]
float g_velJump[MAXPLAYERS + 1]

public Plugin myinfo =
{
	name = "bhop + timer",
	author = "Smesh(Nick Yurevich)",
	description = "Allows to able make bhop more comfortable",
	version = "3.1",
	url = "http://www.sourcemod.net/"
}

public void OnPluginStart()
{
	g_steamid = CreateConVar("steamid", "", "Set steamid for control the plugin ex. 120192594. Use status to check your uniqueid, without 'U:1:'.")
	g_urlTop = CreateConVar("topurl", "", "Set url for top for ex (http://www.fakeexpert-bhop.rf.gd/?start=0&map=). To open page, type in game chat !top")
	AutoExecConfig(true) //https://sm.alliedmods.net/new-api/sourcemod/AutoExecConfig
	RegConsoleCmd("sm_bh", cmd_bhop)
	RegConsoleCmd("sm_bhop", cmd_bhop)
	RegConsoleCmd("sm_r", cmd_restart)
	RegConsoleCmd("sm_restart", cmd_restart)
	RegConsoleCmd("sm_cp", cmd_checkpoint)
	RegConsoleCmd("sm_devmap", cmd_devmap)
	RegConsoleCmd("sm_top", cmd_top)
	RegConsoleCmd("sm_afk", cmd_afk)
	RegConsoleCmd("sm_nc", cmd_noclip)
	RegConsoleCmd("sm_noclip", cmd_noclip)
	RegConsoleCmd("sm_sp", cmd_spec)
	RegConsoleCmd("sm_spec", cmd_spec)
	RegConsoleCmd("sm_hud", cmd_hud)
	RegServerCmd("sm_createzones", cmd_createzones)
	RegServerCmd("sm_createusers", cmd_createusers)
	RegServerCmd("sm_createrecords", cmd_createrecords)
	RegServerCmd("sm_createcp", cmd_createcp)
	RegServerCmd("sm_createtier", cmd_createtier)
	RegConsoleCmd("sm_startmins", cmd_startmins)
	RegConsoleCmd("sm_startmaxs", cmd_startmaxs)
	RegConsoleCmd("sm_endmins", cmd_endmins)
	RegConsoleCmd("sm_endmaxs", cmd_endmaxs)
	RegConsoleCmd("sm_cpmins", cmd_cpmins)
	RegConsoleCmd("sm_cpmaxs", cmd_cpmaxs)
	RegConsoleCmd("sm_zones", cmd_zones)
	RegConsoleCmd("sm_maptier", cmd_maptier)
	RegConsoleCmd("sm_deleteallcp", cmd_deleteallcp)
	RegConsoleCmd("sm_test", cmd_test)
	HookUserMessage(GetUserMessageId("SayText2"), OnMessage, true) //thanks to VerMon idea. https://github.com/shavitush/bhoptimer/blob/master/addons/sourcemod/scripting/shavit-chat.sp#L416
	HookEvent("player_spawn", OnSpawn)
	HookEvent("player_death", OnDeath)
	HookEvent("player_jump", OnJump)
	AddCommandListener(joinclass, "joinclass")
	AddCommandListener(showbriefing, "showbriefing")
	AddCommandListener(headtrack_reset_home_pos, "headtrack_reset_home_pos")
	LoadTranslations("test.phrases") //https://wiki.alliedmods.net/Translations_(SourceMod_Scripting)
	g_start = CreateGlobalForward("Bhop_Start", ET_Hook, Param_Cell)
	g_record = CreateGlobalForward("Bhop_Record", ET_Hook, Param_Cell, Param_Float)
	RegPluginLibrary("fakeexpert_bhop")
	g_cookie = RegClientCookie("vel", "velocity in hint", CookieAccess_Protected)
	CreateTimer(60.0, timer_clearlag)
}

public void OnMapStart()
{
	GetCurrentMap(g_map, 192)
	Database.Connect(SQLConnect, "fakeexpert_bhop")
	for(int i = 0; i <= 2; i++)
	{
		g_zoneHave[i] = false
		if(g_devmap)
			g_zoneFirst[i] = false
	}
	ConVar sourceTVConVar = FindConVar("tv_enable")
	bool sourceTV = sourceTVConVar.BoolValue //https://github.com/alliedmodders/sourcemod/blob/master/plugins/funvotes.sp#L280
	if(sourceTV)
	{
		if(!g_sourceTVchangedFilename)
		{
			char filenameOld[256]
			Format(filenameOld, 256, "%s-%s-%s.dem", g_date, g_time, g_map)
			char filenameNew[256]
			Format(filenameNew, 256, "%s-%s-%s-ServerRecord.dem", g_date, g_time, g_map)
			RenameFile(filenameNew, filenameOld)
			g_sourceTVchangedFilename = true
		}
		if(!g_devmap)
		{
			PrintToServer("SourceTV start recording.")
			FormatTime(g_date, 64, "%Y-%m-%d", GetTime())
			FormatTime(g_time, 64, "%H-%M-%S", GetTime())
			ServerCommand("tv_record %s-%s-%s", g_date, g_time, g_map) //https://www.youtube.com/watch?v=GeGd4KOXNb8 https://forums.alliedmods.net/showthread.php?t=59474 https://www.php.net/strftime
		}
	}
	if(!g_sourceTV && !sourceTV)
	{
		g_sourceTV = true
		ForceChangeLevel(g_map, "Turn on SourceTV")
	}
	g_zoneModel[0] = PrecacheModel("materials/fakeexpert/zones/start.vmt", true)
	g_zoneModel[1] = PrecacheModel("materials/fakeexpert/zones/finish.vmt", true)
	g_zoneModel[2] = PrecacheModel("materials/fakeexpert/zones/check_point.vmt", true)
	AddFileToDownloadsTable("materials/fakeexpert/zones/start.vmt")
	AddFileToDownloadsTable("materials/fakeexpert/zones/start.vtf")
	AddFileToDownloadsTable("materials/fakeexpert/zones/finish.vmt")
	AddFileToDownloadsTable("materials/fakeexpert/zones/finish.vtf")
	AddFileToDownloadsTable("materials/fakeexpert/zones/check_point.vmt")
	AddFileToDownloadsTable("materials/fakeexpert/zones/check_point.vtf")
	RecalculatePoints()
}

void RecalculatePoints()
{
	if(g_dbPassed)
		g_mysql.Query(SQLRecalculatePoints_GetMap, "SELECT map FROM tier")
}

void SQLRecalculatePoints_GetMap(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error))
		PrintToServer("SQLRecalculatePoints_GetMap: %s", error)
	else
	{
		while(results.FetchRow())
		{
			char map[192]
			results.FetchString(0, map, 192)
			char query[512]
			Format(query, 512, "SELECT (SELECT COUNT(*) FROM records WHERE map = '%s'), (SELECT tier FROM tier WHERE map = '%s'), id FROM records WHERE map = '%s' ORDER BY time", map, map, map) //https://stackoverflow.com/questions/38104018/select-and-count-rows-in-the-same-query
			g_mysql.Query(SQLRecalculatePoints, query)
		}
	}
}

void SQLRecalculatePoints(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error))
		PrintToServer("SQLRecalculatePoints: %s", error)
	else
	{
		int place
		char query[512]
		while(results.FetchRow())
		{
			int points = results.FetchInt(1) * results.FetchInt(0) / ++place //thanks to DeadSurfer
			Format(query, 512, "UPDATE records SET points = %i WHERE id = %i LIMIT 1", points, results.FetchInt(2))
			g_queryLast++
			g_mysql.Query(SQLRecalculatePoints2, query)
		}
	}
}

void SQLRecalculatePoints2(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error))
		PrintToServer("SQLRecalculatePoints2: %s", error)
	else
	{
		if(g_queryLast-- && !g_queryLast)
			g_mysql.Query(SQLRecalculatePoints3, "SELECT steamid FROM users")
	}
}

void SQLRecalculatePoints3(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error))
		PrintToServer("SQLRecalculatePoints3: %s", error)
	else
	{
		while(results.FetchRow())
		{
			char query[512]
			Format(query, 512, "SELECT MAX(points) FROM records WHERE playerid = %i GROUP BY map", results.FetchInt(0)) //https://1drv.ms/u/s!Aq4KvqCyYZmHgpFWHdgkvSKx0wAi0w?e=7eShgc
			g_mysql.Query(SQLRecalculateUserPoints, query, results.FetchInt(0))
		}
	}
}

void SQLRecalculateUserPoints(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error))
		PrintToServer("SQLRecalculateUserPoints: %s", error)
	else
	{
		int points
		while(results.FetchRow())
			points += results.FetchInt(0)
		char query[512]
		Format(query, 512, "UPDATE users SET points = %i WHERE steamid = %i LIMIT 1", points, data)
		g_queryLast++
		g_mysql.Query(SQLUpdateUserPoints, query)
	}
}

void SQLUpdateUserPoints(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error))
		PrintToServer("SQLUpdateUserPoints: %s", error)
	else
	{
		if(results.HasResults == false)
			if(g_queryLast-- && !g_queryLast)
				g_mysql.Query(SQLGetPointsMaxs, "SELECT points FROM users ORDER BY points DESC LIMIT 1")
	}
}

void SQLGetPointsMaxs(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error))
		PrintToServer("SQLGetPointsMaxs: %s", error)
	else
	{
		if(results.FetchRow())
		{
			g_pointsMaxs = results.FetchInt(0)
			char query[512]
			for(int i = 1; i <= MaxClients; i++)
			{
				if(IsClientInGame(i) && !IsFakeClient(i))
				{
					int steamid = GetSteamAccountID(i)
					Format(query, 512, "SELECT points FROM users WHERE steamid = %i LIMIT 1", steamid)
					g_mysql.Query(SQLGetPoints, query, GetClientSerial(i))
				}
			}
		}
	}
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	CreateNative("Trikz_GetTimerState", Native_GetTimerState)
	MarkNativeAsOptional("Trikz_GetEntityFilter")
	return APLRes_Success
}

public void OnMapEnd()
{
	ConVar sourceTVConVar = FindConVar("tv_enable")
	bool sourceTV = sourceTVConVar.BoolValue
	if(sourceTV)
	{
		ServerCommand("tv_stoprecord")
		char filenameOld[256]
		Format(filenameOld, 256, "%s-%s-%s.dem", g_date, g_time, g_map)
		if(g_ServerRecord)
		{
			char filenameNew[256]
			Format(filenameNew, 256, "%s-%s-%s-ServerRecord.dem", g_date, g_time, g_map)
			RenameFile(filenameNew, filenameOld)
			g_ServerRecord = false
		}
		else
			DeleteFile(filenameOld)
	}
}

Action OnMessage(UserMsg msg_id, BfRead msg, const int[] players, int playersNum, bool reliable, bool init)
{
	int client = msg.ReadByte()
	msg.ReadByte()
	char msgBuffer[32]
	msg.ReadString(msgBuffer, 32)
	char name[MAX_NAME_LENGTH]
	msg.ReadString(name, MAX_NAME_LENGTH)
	char text[256]
	msg.ReadString(text, 256)
	if(!g_msg[client])
		return Plugin_Handled
	g_msg[client] = false
	char msgFormated[32]
	Format(msgFormated, 32, "%s", msgBuffer)
	char points[32]
	int precentage = g_points[client] / g_pointsMaxs * 100
	char color[8]
	if(precentage >= 90)
		Format(color, 8, "FF8000")
	else if(precentage >= 70)
		Format(color, 8, "A335EE")
	else if(precentage >= 55)
		Format(color, 8, "0070DD")
	else if(precentage >= 40)
		Format(color, 8, "1EFF00")
	else if(precentage >= 15)
		Format(color, 8, "FFFFFF")
	else if(precentage >= 0)
		Format(color, 8, "9D9D9D") //https://wowpedia.fandom.com/wiki/Quality
	if(g_points[client] < 1000)
		Format(points, 32, "\x07%s%i\x01", color, g_points[client])
	else if(g_points[client] > 999)
		Format(points, 32, "\x07%s%iK\x01", color, g_points[client] / 1000)
	else if(g_points[client] > 999999)
		Format(points, 32, "\x07%s%iM\x01", color, g_points[client] / 1000000)
	if(StrEqual(msgBuffer, "Cstrike_Chat_AllSpec"))
		Format(text, 256, "\x01*SPEC* [%s] \x07CCCCCC%s \x01:  %s", points, name, text) //https://github.com/DoctorMcKay/sourcemod-plugins/blob/master/scripting/include/morecolors.inc#L566
	else if(StrEqual(msgBuffer, "Cstrike_Chat_Spec"))
		Format(text, 256, "\x01(Spectator) [%s] \x07CCCCCC%s \x01:  %s", points, name, text)
	else if(StrEqual(msgBuffer, "Cstrike_Chat_All"))
	{
		if(GetClientTeam(client) == 2)
			Format(text, 256, "\x01[%s] \x07FF4040%s \x01:  %s", points, name, text) //https://github.com/DoctorMcKay/sourcemod-plugins/blob/master/scripting/include/morecolors.inc#L638
		else if(GetClientTeam(client) == 3)
			Format(text, 256, "\x01[%s] \x0799CCFF%s \x01:  %s", points, name, text) //https://github.com/DoctorMcKay/sourcemod-plugins/blob/master/scripting/include/morecolors.inc#L513
	}
	else if(StrEqual(msgBuffer, "Cstrike_Chat_AllDead"))
	{
		if(GetClientTeam(client) == 2)
			Format(text, 256, "\x01*DEAD* [%s] \x07FF4040%s \x01:  %s", points, name, text)
		else if(GetClientTeam(client) == 3)
			Format(text, 256, "\x01*DEAD* [%s] \x0799CCFF%s \x01:  %s", points, name, text)
	}
	else if(StrEqual(msgBuffer, "Cstrike_Chat_CT"))
		Format(text, 256, "\x01(Counter-Terrorist) [%s] \x0799CCFF%s \x01:  %s", points, name, text)
	else if(StrEqual(msgBuffer, "Cstrike_Chat_CT_Dead"))
		Format(text, 256, "\x01*DEAD*(Counter-Terrorist) [%s] \x0799CCFF%s \x01:  %s", points, name, text)
	else if(StrEqual(msgBuffer, "Cstrike_Chat_T"))
		Format(text, 256, "\x01(Terrorist) [%s] \x07FF4040%s \x01:  %s", points, name, text) //https://forums.alliedmods.net/showthread.php?t=185016
	else if(StrEqual(msgBuffer, "Cstrike_Chat_T_Dead"))
		Format(text, 256, "\x01*DEAD*(Terrorist) [%s] \x07FF4040%s \x01:  %s", points, name, text)
	DataPack dp = new DataPack()
	dp.WriteCell(GetClientSerial(client))
	dp.WriteCell(StrContains(msgBuffer, "_All") != -1)
	dp.WriteString(text)
	RequestFrame(frame_SayText2, dp)
	return Plugin_Handled
}

void frame_SayText2(DataPack dp)
{
	dp.Reset()
	int client = GetClientFromSerial(dp.ReadCell())
	bool allchat = dp.ReadCell()
	char text[256]
	dp.ReadString(text, 256)
	if(IsClientInGame(client))
	{
		int clients[MAXPLAYERS + 1]
		int count
		int team = GetClientTeam(client)
		for(int i = 1; i <= MaxClients; i++)
			if(IsClientInGame(i) && (allchat || GetClientTeam(i) == team))
				clients[count++] = i
		Handle hSayText2 = StartMessage("SayText2", clients, count, USERMSG_RELIABLE | USERMSG_BLOCKHOOKS)
		BfWrite bfmsg = UserMessageToBfWrite(hSayText2)
		bfmsg.WriteByte(client)
		bfmsg.WriteByte(true)
		bfmsg.WriteString(text)
		EndMessage()
		g_msg[client] = true
	}
}

Action OnSpawn(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"))
	if(GetClientTeam(client) == CS_TEAM_T || GetClientTeam(client) == CS_TEAM_CT)
	{
		SetEntProp(client, Prop_Data, "m_CollisionGroup", 2)
		if(!g_devmap && !g_clantagOnce[client])
		{
			CS_GetClientClanTag(client, g_clantag[client][0], 256)
			g_clantagOnce[client] = true
		}
	}
}

Action OnDeath(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"))
	int ragdoll = GetEntPropEnt(client, Prop_Send, "m_hRagdoll")
	RemoveEntity(ragdoll)
}

Action OnJump(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"))
	g_jumped[client] = true
	float vel[3]
	GetEntPropVector(client, Prop_Data, "m_vecAbsVelocity", vel)
	g_velJump[client] = SquareRoot(Pow(vel[0], 2.0) + Pow(vel[1], 2.0))
}

Action joinclass(int client, const char[] command, int argc)
{
	CreateTimer(1.0, timer_respawn, client, TIMER_FLAG_NO_MAPCHANGE)
}

Action timer_respawn(Handle timer, int client)
{
	if(IsClientInGame(client) && !IsPlayerAlive(client))
		CS_RespawnPlayer(client)
}

Action showbriefing(int client, const char[] command, int argc)
{
	Menu menu = new Menu(menu_info_handler)
	menu.SetTitle("Control")
	menu.AddItem("top", "!top")
	menu.AddItem("js", "!js")
	menu.AddItem("ssj", "!ssj")
	menu.AddItem("hud", "!hud")
	menu.AddItem("spec", "!spec")
	menu.Display(client, 20)
}

int menu_info_handler(Menu menu, MenuAction action, int param1, int param2)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			switch(param2)
			{
				case 0:
					cmd_top(param1, 0)
				case 1:
					FakeClientCommand(param1, "sm_js")
				case 2:
					FakeClientCommand(param1, "sm_ssj")
				case 3:
					cmd_hud(param1, 0)
				case 4:
					cmd_spec(param1, 0)
			}
		}
	}
}

Action headtrack_reset_home_pos(int client, const char[] command, int argc)
{
	if(!g_menuOpened[client])
		Bhop(client)
}

Action cmd_checkpoint(int client, int args)
{
	Checkpoint(client)
	return Plugin_Handled
}

void Checkpoint(int client)
{
	if(g_devmap)
	{
		Menu menu = new Menu(checkpoint_handler)
		menu.SetTitle("Checkpoint")
		menu.AddItem("Save", "Save")
		menu.AddItem("Teleport", "Teleport", g_cpToggled[client][0] ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED)
		menu.AddItem("Save second", "Save second")
		menu.AddItem("Teleport second", "Teleport second", g_cpToggled[client][1] ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED)
		menu.ExitBackButton = true //https://cc.bingj.com/cache.aspx?q=ExitBackButton+sourcemod&d=4737211702971338&mkt=en-WW&setlang=en-US&w=wg9m5FNl3EpqPBL0vTge58piA8n5NsLz#L49
		menu.Display(client, MENU_TIME_FOREVER)
	}
	else
		PrintToChat(client, "Turn on devmap.")
}

int checkpoint_handler(Menu menu, MenuAction action, int param1, int param2)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			switch(param2)
			{
				case 0:
				{
					GetClientAbsOrigin(param1, g_cpOrigin[param1][0])
					GetClientEyeAngles(param1, g_cpAng[param1][0]) //https://github.com/Smesh292/trikz/blob/main/checkpoint.sp#L101
					GetEntPropVector(param1, Prop_Data, "m_vecAbsVelocity", g_cpVel[param1][0])
					if(!g_cpToggled[param1][0])
						g_cpToggled[param1][0] = true
				}
				case 1:
					TeleportEntity(param1, g_cpOrigin[param1][0], g_cpAng[param1][0], g_cpVel[param1][0])
				case 2:
				{
					GetClientAbsOrigin(param1, g_cpOrigin[param1][1])
					GetClientEyeAngles(param1, g_cpAng[param1][1])
					GetEntPropVector(param1, Prop_Data, "m_vecAbsVelocity", g_cpVel[param1][1])
					if(!g_cpToggled[param1][1])
						g_cpToggled[param1][1] = true
				}
				case 3:
					TeleportEntity(param1, g_cpOrigin[param1][1], g_cpAng[param1][1], g_cpVel[param1][1])
			}
			Checkpoint(param1)
		}
		case MenuAction_Cancel: // trikz redux menuaction end
		{
			switch(param2)
			{
				case MenuCancel_ExitBack: //https://cc.bingj.com/cache.aspx?q=ExitBackButton+sourcemod&d=4737211702971338&mkt=en-WW&setlang=en-US&w=wg9m5FNl3EpqPBL0vTge58piA8n5NsLz#L125
					Bhop(param1)
			}
		}
	}
}

public void OnClientPutInServer(int client)
{
	SDKHook(client, SDKHook_OnTakeDamage, SDKOnTakeDamage)
	SDKHook(client, SDKHook_WeaponDrop, SDKWeaponDrop)
	SDKHook(client, SDKHook_SetTransmit, TransmitPlayer)
	if(IsClientInGame(client) && g_dbPassed)
	{
		g_mysql.Query(SQLAddUser, "SELECT id FROM users LIMIT 1", GetClientSerial(client), DBPrio_High)
		char query[512]
		int steamid = GetSteamAccountID(client)
		Format(query, 512, "SELECT time FROM records WHERE playerid = %i AND map = '%s' ORDER BY time LIMIT 1", steamid, g_map)
		g_mysql.Query(SQLGetPersonalRecord, query, GetClientSerial(client))
	}
	g_menuOpened[client] = false
	for(int i = 0; i <= 1; i++)
	{
		g_cpToggled[client][i] = false
		for(int j = 0; j <= 2; j++)
		{
			g_cpOrigin[client][i][j] = 0.0
			g_cpAng[client][i][j] = 0.0
			g_cpVel[client][i][j] = 0.0
		}
	}
	//g_timerTime[client] = 0.0
	if(!g_devmap && g_zoneHave[2])
		DrawZone(client, 0.0)
	g_msg[client] = true
	if(!AreClientCookiesCached(client))
		g_hudVel[client] = false
	ResetFactory(client)
	g_points[client] = 0
	if(!g_zoneHave[2])
		CancelClientMenu(client)
	g_clantagOnce[client] = false
}

public void OnClientCookiesCached(int client)
{
	char value[16]
	GetClientCookie(client, g_cookie, value, 16)
	g_hudVel[client] = view_as<bool>(StringToInt(value))
}

public void OnClientDisconnect(int client)
{
	CancelClientMenu(client)
	int entity
	while((entity = FindEntityByClassname(entity, "weapon_*")) > 0) //https://github.com/shavitush/bhoptimer/blob/de1fa353ff10eb08c9c9239897fdc398d5ac73cc/addons/sourcemod/scripting/shavit-misc.sp#L1104-L1106
		if(GetEntPropEnt(entity, Prop_Data, "m_hOwnerEntity") == client)
			RemoveEntity(entity)
}

void SQLAddUser(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error))
		PrintToServer("SQLAddUser: %s", error)
	else
	{
		int client = GetClientFromSerial(data)
		if(!client)
			return
		if(IsClientInGame(client))
		{
			char query[512] //https://forums.alliedmods.net/showthread.php?t=261378
			int steamid = GetSteamAccountID(client)
			if(results.FetchRow())
			{
				Format(query, 512, "SELECT steamid FROM users WHERE steamid = %i LIMIT 1", steamid)
				g_mysql.Query(SQLUpdateUsername, query, GetClientSerial(client), DBPrio_High)
			}
			else
			{
				Format(query, 512, "INSERT INTO users (username, steamid, firstjoin, lastjoin) VALUES (\"%N\", %i, %i, %i)", client, steamid, GetTime(), GetTime())
				g_mysql.Query(SQLUserAdded, query)
			}
		}
	}
}

void SQLUserAdded(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error))
		PrintToServer("SQLUserAdded: %s", error)
}

void SQLUpdateUsername(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error))
		PrintToServer("SQLUpdateUsername: %s", error)
	else
	{
		int client = GetClientFromSerial(data)
		if(!client)
			return
		if(IsClientInGame(client))
		{
			char query[512]
			int steamid = GetSteamAccountID(client)
			if(results.FetchRow())
				Format(query, 512, "UPDATE users SET username = \"%N\", lastjoin = %i WHERE steamid = %i LIMIT 1", client, GetTime(), steamid)
			else
				Format(query, 512, "INSERT INTO users (username, steamid, firstjoin, lastjoin) VALUES (\"%N\", %i, %i, %i)", client, steamid, GetTime(), GetTime())
			g_mysql.Query(SQLUpdateUsernameSuccess, query, GetClientSerial(client), DBPrio_High)
		}
	}
}

void SQLUpdateUsernameSuccess(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error))
		PrintToServer("SQLUpdateUsernameSuccess: %s", error)
	else
	{
		int client = GetClientFromSerial(data)
		if(!client)
			return
		if(IsClientInGame(client))
		{
			if(results.HasResults == false)
			{
				char query[512]
				int steamid = GetSteamAccountID(client)
				Format(query, 512, "SELECT points FROM users WHERE steamid = %i LIMIT 1", steamid)
				g_mysql.Query(SQLGetPoints, query, GetClientSerial(client), DBPrio_High)
			}
		}
	}
}

void SQLGetPoints(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error))
		PrintToServer("SQLGetPoints: %s", error)
	else
	{
		int client = GetClientFromSerial(data)
		if(!client)
			return
		if(results.FetchRow())
			g_points[client] = results.FetchInt(0)
	}
}

void SQLGetServerRecord(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error))
		PrintToServer("SQLGetServerRecord: %s", error)
	else
	{
		if(results.FetchRow())
			g_ServerRecordTime = results.FetchFloat(0)
		else
			g_ServerRecordTime = 0.0
	}
}

void SQLGetPersonalRecord(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error))
		PrintToServer("SQLGetPersonalRecord: %s", error)
	else
	{
		int client = GetClientFromSerial(data)
		if(results.FetchRow())
			g_recordHave[client] = results.FetchFloat(0)
		else
			g_recordHave[client] = 0.0
	}
}

Action cmd_bhop(int client, int args)
{
	Bhop(client)
	return Plugin_Handled
}

void Bhop(int client)
{
	g_menuOpened[client] = true
	Menu menu = new Menu(trikz_handler, MenuAction_Start | MenuAction_Select | MenuAction_Display | MenuAction_Cancel) //https://wiki.alliedmods.net/Menus_Step_By_Step_(SourceMod_Scripting)
	menu.SetTitle("Bhop")
	menu.AddItem("restart", "Restart", g_devmap ? ITEMDRAW_DISABLED : ITEMDRAW_DEFAULT) //shavit trikz githgub alliedmods net https://forums.alliedmods.net/showthread.php?p=2051806
	if(g_devmap)
	{
		menu.AddItem("checkpoint", "Checkpoint")
		menu.AddItem("noclip", GetEntityMoveType(client) & MOVETYPE_NOCLIP ? "Noclip [v]" : "Noclip [x]")
	}
	menu.Display(client, MENU_TIME_FOREVER)
}

int trikz_handler(Menu menu, MenuAction action, int param1, int param2)
{
	switch(action)
	{
		case MenuAction_Start: //expert-zone idea. thank to ed, maru.
			g_menuOpened[param1] = true
		case MenuAction_Select:
		{
			switch(param2)
			{
				case 0:
					Restart(param1)
				case 1:
				{
					g_menuOpened[param1] = false
					Checkpoint(param1)
				}
				case 2:
				{
					Noclip(param1)
					Bhop(param1)
				}
			}
		}
		case MenuAction_Cancel:
			g_menuOpened[param1] = false //idea from expert zone.
		case MenuAction_Display:
			g_menuOpened[param1] = true
	}
}

Action cmd_restart(int client, int args)
{
	Restart(client)
	return Plugin_Handled
}

void Restart(int client, bool posKeep = false)
{
	if(g_devmap)
		PrintToChat(client, "Turn off devmap.")
	else
	{
		if(g_zoneHave[0] && g_zoneHave[1])
		{
			if(IsPlayerAlive(client))
			{
				CreateTimer(0.1, timer_resetfactory, client, TIMER_FLAG_NO_MAPCHANGE)
				Call_StartForward(g_start)
				Call_PushCell(client)
				Call_Finish()
				int entity
				bool equimpmented
				while((entity = FindEntityByClassname(entity, "game_player_equip")) > 0)
				{
					AcceptEntityInput(entity, "StartTouch") //https://github.com/lua9520/source-engine-2018-hl2_src/blob/3bf9df6b2785fa6d951086978a3e66f49427166a/game/shared/cstrike/cs_gamerules.cpp#L849
					equimpmented = true
				}
				char classname[32]
				int weapon = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY)
				if(IsValidEntity(weapon))
					GetEntityClassname(weapon, classname, 32)
				bool defaultpistol
				if(StrEqual(classname, "weapon_glock") || StrEqual(classname, "weapon_usp"))
					defaultpistol = true
				if(!equimpmented)
				{
					if(defaultpistol)
					{
						for(int i = 0; i <= 4; i++)
						{
							if(i != 2)
							{
								if(i != 3)
								{
									if(i != 1)
										if(IsValidEntity(GetPlayerWeaponSlot(client, i)))
											CS_DropWeapon(client, GetPlayerWeaponSlot(client, i), false)
								}
								else
									for(int j = 0; j <= 3; j++)
										if(IsValidEntity(GetPlayerWeaponSlot(client, i)))
											CS_DropWeapon(client, GetPlayerWeaponSlot(client, i), false)
							}
						}
						
						
						int ammotype = GetEntProp(weapon, Prop_Send, "m_iPrimaryAmmoType")
						int start = FindSendPropInfo("CBasePlayer", "m_iAmmo")
						if(StrEqual(classname, "weapon_glock"))
						{
							SetEntProp(weapon, Prop_Send, "m_iClip1", 20)
							SetEntData(client, (start + (ammotype * 4)), 120) //https://forums.alliedmods.net/showpost.php?p=1460194&postcount=3
						}
						else if(StrEqual(classname, "weapon_usp"))
						{
							SetEntProp(weapon, Prop_Send, "m_iClip1", 12)
							SetEntData(client, (start + (ammotype * 4)), 100) //https://forums.alliedmods.net/showpost.php?p=1460194&postcount=3
						}
					}
					else
					{
						for(int i = 0; i <= 4; i++)
						{
							if(i != 3)
							{
								if(i != 1)
									if(IsValidEntity(GetPlayerWeaponSlot(client, i)))
										CS_DropWeapon(client, GetPlayerWeaponSlot(client, i), false)
							}
							else
								for(int j = 0; j <= 3; j++)
									if(IsValidEntity(GetPlayerWeaponSlot(client, i)))
										CS_DropWeapon(client, GetPlayerWeaponSlot(client, i), false)
						}
						if(GetClientTeam(client) == CS_TEAM_T) //https://github.com/lua9520/source-engine-2018-hl2_src/blob/3bf9df6b2785fa6d951086978a3e66f49427166a/game/server/cstrike/cs_player.cpp#L972
							GivePlayerItem(client, "weapon_glock")
						else if(GetClientTeam(client) == CS_TEAM_CT)
							GivePlayerItem(client, "weapon_usp")
					}
				}
				float velNull[3]
				TeleportEntity(client, posKeep ? NULL_VECTOR : g_cpOriginStart, NULL_VECTOR, g_velJump[client] > 278.0 + 10.0 ? velNull : NULL_VECTOR)
				if(g_menuOpened[client])
					Bhop(client)
			}
			else
			{
				int entity
				bool ct
				bool t
				while((entity = FindEntityByClassname(entity, "info_player_counterterrorist")) > 0)
				{
					ct = true
					break
				}
				while((entity = FindEntityByClassname(entity, "info_player_terrorist")) > 0)
				{
					if(!ct)
						t = true
					break
				}
				if(ct)
				{
					CS_SwitchTeam(client, CS_TEAM_CT) //https://github.com/shavitush/bhoptimer/blob/master/addons/sourcemod/scripting/shavit-misc.sp#L2066
					CS_RespawnPlayer(client)
					Restart(client)
				}
				if(t)
				{
					CS_SwitchTeam(client, CS_TEAM_T)
					CS_RespawnPlayer(client)
					Restart(client)
				}
			}
		}
	}
}

Action timer_resetfactory(Handle timer, int client)
{
	if(IsClientInGame(client))
		ResetFactory(client)
}

void CreateStart()
{
	int entity = CreateEntityByName("trigger_multiple")
	DispatchKeyValue(entity, "spawnflags", "1") //https://github.com/shavitush/bhoptimer
	DispatchKeyValue(entity, "wait", "0")
	DispatchKeyValue(entity, "targetname", "fakeexpert_startzone")
	DispatchSpawn(entity)
	SetEntityModel(entity, "models/player/t_arctic.mdl")
	//https://stackoverflow.com/questions/4355894/how-to-get-center-of-set-of-points-using-python
	g_center[0][0] = (g_zoneStartOrigin[0][0] + g_zoneStartOrigin[1][0]) / 2.0
	g_center[0][1] = (g_zoneStartOrigin[0][1] + g_zoneStartOrigin[1][1]) / 2.0
	g_center[0][2] = (g_zoneStartOrigin[0][2] + g_zoneStartOrigin[1][2]) / 2.0
	TeleportEntity(entity, g_center[0], NULL_VECTOR, NULL_VECTOR) //Thanks to https://amx-x.ru/viewtopic.php?f=14&t=15098 http://world-source.ru/forum/102-3743-1
	g_cpOriginStart[0] = g_center[0][0]
	g_cpOriginStart[1] = g_center[0][1]
	g_cpOriginStart[2] = g_center[0][2] + 1.0
	float mins[3]
	float maxs[3]
	for(int i = 0; i <= 1; i++)
	{
		mins[i] = (g_zoneStartOrigin[0][i] - g_zoneStartOrigin[1][i]) / 2.0
		if(mins[i] > 0.0)
			mins[i] *= -1.0
		maxs[i] = (g_zoneStartOrigin[0][i] - g_zoneStartOrigin[1][i]) / 2.0
		if(maxs[i] < 0.0)
			maxs[i] *= -1.0
	}
	maxs[2] = 124.0
	SetEntPropVector(entity, Prop_Send, "m_vecMins", mins)
	SetEntPropVector(entity, Prop_Send, "m_vecMaxs", maxs)
	SetEntProp(entity, Prop_Send, "m_nSolidType", 2)
	SDKHook(entity, SDKHook_StartTouch, SDKStartTouch)
	SDKHook(entity, SDKHook_EndTouch, SDKEndTouch)
	SDKHook(entity, SDKHook_Touch, SDKTouch)
	PrintToServer("Start zone is successfuly setup.")
	g_zoneHave[0] = true
}

void CreateEnd()
{
	int entity = CreateEntityByName("trigger_multiple")
	DispatchKeyValue(entity, "spawnflags", "1") //https://github.com/shavitush/bhoptimer
	DispatchKeyValue(entity, "wait", "0")
	DispatchKeyValue(entity, "targetname", "fakeexpert_endzone")
	DispatchSpawn(entity)
	SetEntityModel(entity, "models/player/t_arctic.mdl")
	//https://stackoverflow.com/questions/4355894/how-to-get-center-of-set-of-points-using-python
	g_center[1][0] = (g_zoneEndOrigin[0][0] + g_zoneEndOrigin[1][0]) / 2.0
	g_center[1][1] = (g_zoneEndOrigin[0][1] + g_zoneEndOrigin[1][1]) / 2.0
	g_center[1][2] = (g_zoneEndOrigin[0][2] + g_zoneEndOrigin[1][2]) / 2.0
	TeleportEntity(entity, g_center[1], NULL_VECTOR, NULL_VECTOR) //Thanks to https://amx-x.ru/viewtopic.php?f=14&t=15098 http://world-source.ru/forum/102-3743-1
	float mins[3]
	float maxs[3]
	for(int i = 0; i <= 1; i++)
	{
		mins[i] = (g_zoneEndOrigin[0][i] - g_zoneEndOrigin[1][i]) / 2.0
		if(mins[i] > 0.0)
			mins[i] *= -1.0
		maxs[i] = (g_zoneEndOrigin[0][i] - g_zoneEndOrigin[1][i]) / 2.0
		if(maxs[i] < 0.0)
			maxs[i] *= -1.0
	}
	maxs[2] = 124.0
	SetEntPropVector(entity, Prop_Send, "m_vecMins", mins) //https://forums.alliedmods.net/archive/index.php/t-301101.html
	SetEntPropVector(entity, Prop_Send, "m_vecMaxs", maxs)
	SetEntProp(entity, Prop_Send, "m_nSolidType", 2)
	SDKHook(entity, SDKHook_StartTouch, SDKStartTouch)
	PrintToServer("End zone is successfuly setup.")
	CPSetup(0)
	g_zoneHave[1] = true
}

Action cmd_startmins(int client, int args)
{
	char steamIDcurrent[64]
	IntToString(GetSteamAccountID(client), steamIDcurrent, 64)
	char steamid[64]
	GetConVarString(g_steamid, steamid, 64)
	if(StrEqual(steamid, steamIDcurrent))
	{
		if(g_devmap)
		{
			GetClientAbsOrigin(client, g_zoneStartOrigin[0])
			g_zoneFirst[0] = true
		}
		else
			PrintToChat(client, "Turn on devmap.")
		return Plugin_Handled
	}
	return Plugin_Continue
}

void SQLDeleteStartZone(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error))
		PrintToServer("SQLDeleteStartZone: %s", error)
	else
	{
		char query[512]
		Format(query, 512, "INSERT INTO zones (map, type, possition_x, possition_y, possition_z, possition_x2, possition_y2, possition_z2) VALUES ('%s', 0, %i, %i, %i, %i, %i, %i)", g_map, RoundFloat(g_zoneStartOrigin[0][0]), RoundFloat(g_zoneStartOrigin[0][1]), RoundFloat(g_zoneStartOrigin[0][2]), RoundFloat(g_zoneStartOrigin[1][0]), RoundFloat(g_zoneStartOrigin[1][1]), RoundFloat(g_zoneStartOrigin[1][2]))
		g_mysql.Query(SQLSetStartZones, query)
	}
}

Action cmd_deleteallcp(int client, int args)
{
	char steamIDcurrent[64]
	IntToString(GetSteamAccountID(client), steamIDcurrent, 64)
	char steamid[64]
	GetConVarString(g_steamid, steamid, 64)
	if(StrEqual(steamid, steamIDcurrent)) //https://sm.alliedmods.net/new-api/
	{
		if(g_devmap)
		{
			char query[512]
			Format(query, 512, "DELETE FROM cp WHERE map = '%s'", g_map) //https://www.w3schools.com/sql/sql_delete.asp
			g_mysql.Query(SQLDeleteAllCP, query)
		}
		else
			PrintToChat(client, "Turn on devmap.")
		return Plugin_Handled
	}
	return Plugin_Continue
}

void SQLDeleteAllCP(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error))
		PrintToServer("SQLDeleteAllCP: %s", error)
	else
	{
		if(results.HasResults == false)
			PrintToServer("All checkpoints are deleted on current map.")
		else
			PrintToServer("No checkpoints to delete on current map.")
	}
}

public Action OnClientCommandKeyValues(int client, KeyValues kv)
{
	if(!g_devmap)
	{
		char name[64] //https://forums.alliedmods.net/showthread.php?t=270684
		kv.GetSectionName(name, 64)
		if(StrEqual(name, "ClanTagChanged"))
			CS_GetClientClanTag(client, g_clantag[client][0], 256)
	}
}

Action cmd_test(int client, int args)
{
	char steamIDcurrent[64]
	IntToString(GetSteamAccountID(client), steamIDcurrent, 64)
	char steamid[64]
	GetConVarString(g_steamid, steamid, 64)
	if(StrEqual(steamid, steamIDcurrent)) //https://sm.alliedmods.net/new-api/
	{
		char text[256]
		char name[MAX_NAME_LENGTH]
		GetClientName(client, name, MAX_NAME_LENGTH)
		int team = GetClientTeam(client)
		char teamName[32]
		char teamColor[32]
		switch(team)
		{
			case 1:
			{
				Format(teamName, 32, "Spectator")
				Format(teamColor, 32, "\x07CCCCCC")
			}
			case 2:
			{
				Format(teamName, 32, "Terrorist")
				Format(teamColor, 32, "\x07FF4040")
			}
			case 3:
			{
				Format(teamName, 32, "Counter-Terrorist")
				Format(teamColor, 32, "\x0799CCFF")
			}
		}
		Format(text, 256, "\x01%T", "Hello", client, "FakeExpert", name, teamName)
		ReplaceString(text, 256, ";#", "\x07")
		ReplaceString(text, 256, "{default}", "\x01")
		ReplaceString(text, 256, "{teamcolor}", teamColor)
		PrintToChat(client, "%s", text)
		Call_StartForward(g_start)
		Call_PushCell(client)
		Call_Finish()
		Restart(client)
		//https://forums.alliedmods.net/showthread.php?t=187746
		int color
		color |= (5 & 255) << 24 //5 red
		color |= (200 & 255) << 16 // 200 green
		color |= (255 & 255) << 8 // 255 blue
		color |= (50 & 255) << 0 // 50 alpha
		PrintToChat(client, "\x08%08XCOLOR", color)
		char steamID64[64]
		GetClientAuthId(client, AuthId_SteamID64, steamID64, 64)
		PrintToChat(client, "Your steamid64 is: %s = 76561197960265728 + %i (steamid3)", steamID64, steamid) //https://forums.alliedmods.net/showthread.php?t=324112 120192594
		PrintToServer("%d %i %f", 63 / 4, 63 / 4, 63.0 / 4.0)
		return Plugin_Handled
	}
	return Plugin_Continue
}

Action cmd_endmins(int client, int args)
{
	char steamIDcurrent[64]
	IntToString(GetSteamAccountID(client), steamIDcurrent, 64)
	char steamid[64]
	GetConVarString(g_steamid, steamid, 64)
	if(StrEqual(steamid, steamIDcurrent))
	{
		if(g_devmap)
		{
			GetClientAbsOrigin(client, g_zoneEndOrigin[0])
			g_zoneFirst[1] = true
		}
		else
			PrintToChat(client, "Turn on devmap.")
		return Plugin_Handled
	}
	return Plugin_Continue
}

void SQLDeleteEndZone(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error))
		PrintToServer("SQLDeleteEndZone: %s", error)
	else
	{
		char query[512]
		Format(query, 512, "INSERT INTO zones (map, type, possition_x, possition_y, possition_z, possition_x2, possition_y2, possition_z2) VALUES ('%s', 1, %i, %i, %i, %i, %i, %i)", g_map, RoundFloat(g_zoneEndOrigin[0][0]), RoundFloat(g_zoneEndOrigin[0][1]), RoundFloat(g_zoneEndOrigin[0][2]), RoundFloat(g_zoneEndOrigin[1][0]), RoundFloat(g_zoneEndOrigin[1][1]), RoundFloat(g_zoneEndOrigin[1][2]))
		g_mysql.Query(SQLSetEndZones, query)
	}
}

Action cmd_maptier(int client, int args)
{
	char steamIDcurrent[64]
	IntToString(GetSteamAccountID(client), steamIDcurrent, 64)
	char steamid[64]
	GetConVarString(g_steamid, steamid, 64)
	if(StrEqual(steamid, steamIDcurrent))
	{
		if(g_devmap)
		{
			char argString[512]
			GetCmdArgString(argString, 512) //https://www.sourcemod.net/new-api/console/GetCmdArgString
			int tier = StringToInt(argString)
			if(tier > 0)
			{
				PrintToServer("[Args] Tier: %i", tier)
				char query[512]
				Format(query, 512, "DELETE FROM tier WHERE map = '%s' LIMIT 1", g_map)
				g_mysql.Query(SQLTierRemove, query, tier)
			}
		}
		else
			PrintToChat(client, "Turn on devmap.")
		return Plugin_Handled
	}
	return Plugin_Continue
}

void SQLTierRemove(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error))
		PrintToServer("SQLTierRemove: %s", error)
	else
	{
		char query[512]
		Format(query, 512, "INSERT INTO tier (tier, map) VALUES (%i, '%s')", data, g_map)
		g_mysql.Query(SQLTierInsert, query, data)
	}
}

void SQLTierInsert(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error))
		PrintToServer("SQLTierInsert: %s", error)
	else
	{
		if(results.HasResults == false)
			PrintToServer("Tier %i is set for %s.", data, g_map)
	}
}

void SQLSetStartZones(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error))
		PrintToServer("SQLSetStartZones: %s", error)
	else
	{
		if(results.HasResults == false)
			PrintToServer("Start zone successfuly created.")
	}
}

void SQLSetEndZones(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error))
		PrintToServer("SQLSetEndZones: %s", error)
	else
	{
		if(results.HasResults == false)
			PrintToServer("End zone successfuly created.")
	}
}

Action cmd_startmaxs(int client, int args)
{
	char steamIDcurrent[64]
	IntToString(GetSteamAccountID(client), steamIDcurrent, 64)
	char steamid[64]
	GetConVarString(g_steamid, steamid, 64)
	if(StrEqual(steamid, steamIDcurrent) && g_zoneFirst[0])
	{
		GetClientAbsOrigin(client, g_zoneStartOrigin[1])
		char query[512]
		Format(query, 512, "DELETE FROM zones WHERE map = '%s' AND type = 0 LIMIT 1", g_map)
		g_mysql.Query(SQLDeleteStartZone, query)
		g_zoneFirst[0] = false
		return Plugin_Handled
	}
	return Plugin_Continue
}

Action cmd_endmaxs(int client, int args)
{
	char steamIDcurrent[64]
	IntToString(GetSteamAccountID(client), steamIDcurrent, 64)
	char steamid[64]
	GetConVarString(g_steamid, steamid, 64)
	if(StrEqual(steamid, steamIDcurrent) && g_zoneFirst[1])
	{
		GetClientAbsOrigin(client, g_zoneEndOrigin[1])
		char query[512]
		Format(query, 512, "DELETE FROM zones WHERE map = '%s' AND type = 1 LIMIT 1", g_map)
		g_mysql.Query(SQLDeleteEndZone, query)
		g_zoneFirst[1] = false
		return Plugin_Handled
	}
	return Plugin_Continue
}

Action cmd_cpmins(int client, int args)
{
	char steamIDcurrent[64]
	IntToString(GetSteamAccountID(client), steamIDcurrent, 64)
	char steamid[64]
	GetConVarString(g_steamid, steamid, 64)
	if(StrEqual(steamid, steamIDcurrent))
	{
		if(g_devmap)
		{
			char cmd[512]
			GetCmdArg(args, cmd, 512)
			int cpnum = StringToInt(cmd)
			if(cpnum > 0)
			{
				PrintToChat(client, "CP: No.%i", cpnum)
				GetClientAbsOrigin(client, g_cpPos[0][cpnum])
				g_zoneFirst[2] = true
			}
		}
		else
			PrintToChat(client, "Turn on devmap.")
		return Plugin_Handled
	}
	return Plugin_Continue
}

void SQLCPRemoved(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error))
		PrintToServer("SQLCPRemoved: %s", error)
	else
	{
		if(results.HasResults == false)
			PrintToServer("Checkpoint zone no. %i successfuly deleted.", data)
		char query[512]
		Format(query, 512, "INSERT INTO cp (cpnum, cpx, cpy, cpz, cpx2, cpy2, cpz2, map) VALUES (%i, %i, %i, %i, %i, %i, %i, '%s')", data, RoundFloat(g_cpPos[0][data][0]), RoundFloat(g_cpPos[0][data][1]), RoundFloat(g_cpPos[0][data][2]), RoundFloat(g_cpPos[1][data][0]), RoundFloat(g_cpPos[1][data][1]), RoundFloat(g_cpPos[1][data][2]), g_map)
		g_mysql.Query(SQLCPInserted, query, data)
	}
}

Action cmd_cpmaxs(int client, int args)
{
	char steamIDcurrent[64]
	IntToString(GetSteamAccountID(client), steamIDcurrent, 64)
	char steamid[64]
	GetConVarString(g_steamid, steamid, 64)
	if(StrEqual(steamid, steamIDcurrent) && g_zoneFirst[2])
	{
		char cmd[512]
		GetCmdArg(args, cmd, 512)
		int cpnum = StringToInt(cmd)
		if(cpnum > 0)
		{
			GetClientAbsOrigin(client, g_cpPos[1][cpnum])
			char query[512]
			Format(query, 512, "DELETE FROM cp WHERE cpnum = %i AND map = '%s'", cpnum, g_map)
			g_mysql.Query(SQLCPRemoved, query, cpnum)
			g_zoneFirst[2] = false
		}
		return Plugin_Handled
	}
	return Plugin_Continue
}

void SQLCPInserted(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error))
		PrintToServer("SQLCPInserted: %s", error)
	else
	{
		if(results.HasResults == false)
			PrintToServer("Checkpoint zone no. %i successfuly created.", data)
	}
}

Action cmd_zones(int client, int args)
{
	char steamIDcurrent[64]
	IntToString(GetSteamAccountID(client), steamIDcurrent, 64)
	char steamid[64]
	GetConVarString(g_steamid, steamid, 64)
	if(StrEqual(steamid, steamIDcurrent))
	{
		if(g_devmap)
			ZoneEditor(client)
		else
			PrintToChat(client, "Turn on devmap.")
		return Plugin_Handled
	}
	return Plugin_Continue
}

void ZoneEditor(int client)
{
	CPSetup(client)
}

void ZoneEditor2(int client)
{
	Menu menu = new Menu(zones_handler)
	menu.SetTitle("Zone editor")
	if(g_zoneHave[0])
		menu.AddItem("start", "Start zone")
	if(g_zoneHave[1])
		menu.AddItem("end", "End zone")
	char format[32]
	if(g_cpCount)
	{
		for(int i = 1; i <= g_cpCount; i++)
		{
			Format(format, 32, "CP nr. %i zone", i)
			char cp[16]
			Format(cp, 16, "%i", i)
			menu.AddItem(cp, format)
		}
	}
	else if(!g_zoneHave[0] && !g_zoneHave[1] && !g_cpCount)
		menu.AddItem("-1", "No zones are setup.", ITEMDRAW_DISABLED)
	menu.Display(client, MENU_TIME_FOREVER)
}

int zones_handler(Menu menu, MenuAction action, int param1, int param2)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			char sItem[16]
			menu.GetItem(param2, sItem, 16)
			Menu menu2 = new Menu(zones2_handler, MenuAction_Start | MenuAction_Select | MenuAction_Display | MenuAction_Cancel)
			if(StrEqual(sItem, "start"))
			{
				menu2.SetTitle("Zone editor - Start zone")
				menu2.AddItem("starttp", "Teleport to start zone")
				menu2.AddItem("start+xmins", "+x/mins")
				menu2.AddItem("start-xmins", "-x/mins")
				menu2.AddItem("start+ymins", "+y/mins")
				menu2.AddItem("start-ymins", "-y/mins")
				menu2.AddItem("start+xmaxs", "+x/maxs")
				menu2.AddItem("start-xmaxs", "-x/maxs")
				menu2.AddItem("start+ymaxs", "+y/maxs")
				menu2.AddItem("start-ymaxs", "-y/maxs")
				menu2.AddItem("startupdate", "Update start zone")
			}
			else if(StrEqual(sItem, "end"))
			{
				menu2.SetTitle("Zone editor - End zone")
				menu2.AddItem("endtp", "Teleport to end zone")
				menu2.AddItem("end+xmins", "+x/mins")
				menu2.AddItem("end-xmins", "-x/mins")
				menu2.AddItem("end+ymins", "+y/mins")
				menu2.AddItem("end-ymins", "-y/mins")
				menu2.AddItem("end+xmaxs", "+x/maxs")
				menu2.AddItem("end-xmaxs", "-x/maxs")
				menu2.AddItem("end+ymaxs", "+y/maxs")
				menu2.AddItem("end-ymaxs", "-y/maxs")
				menu2.AddItem("endupdate", "Update start zone")
			}
			for(int i = 1; i <= g_cpCount; i++)
			{
				char cp[16]
				IntToString(i, cp, 16)
				Format(cp, 16, "%i", i)
				if(StrEqual(sItem, cp))
				{
					menu2.SetTitle("Zone editor - CP nr. %i zone", i)
					char sButton[32]
					Format(sButton, 32, "Teleport to CP nr. %i zone", i)
					char sItemCP[16]
					Format(sItemCP, 16, "%i;tp", i)
					menu2.AddItem(sItemCP, sButton)
					Format(sItemCP, 16, "%i;1", i)
					menu2.AddItem(sItemCP, "+x/mins")
					Format(sItemCP, 16, "%i;2", i)
					menu2.AddItem(sItemCP, "-x/mins")
					Format(sItemCP, 16, "%i;3", i)
					menu2.AddItem(sItemCP, "+y/mins")
					Format(sItemCP, 16, "%i;4", i)
					menu2.AddItem(sItemCP, "-y/mins")
					Format(sItemCP, 16, "%i;5", i)
					menu2.AddItem(sItemCP, "+x/maxs")
					Format(sItemCP, 16, "%i;6", i)
					menu2.AddItem(sItemCP, "-x/maxs")
					Format(sItemCP, 16, "%i;7", i)
					menu2.AddItem(sItemCP, "+y/maxs")
					Format(sItemCP, 16, "%i;8", i)
					menu2.AddItem(sItemCP, "-y/maxs")
					Format(sButton, 32, "Update CP nr. %i zone", i)
					menu2.AddItem("cpupdate", sButton)
				}
			}
			menu2.ExitBackButton = true //https://cc.bingj.com/cache.aspx?q=ExitBackButton+sourcemod&d=4737211702971338&mkt=en-WW&setlang=en-US&w=wg9m5FNl3EpqPBL0vTge58piA8n5NsLz#L49
			menu2.Display(param1, MENU_TIME_FOREVER)
		}
	}
}

int zones2_handler(Menu menu, MenuAction action, int param1, int param2)
{
	switch(action)
	{
		case MenuAction_Start: //expert-zone idea. thank to ed, maru.
			g_zoneDraw[param1] = true
		case MenuAction_Select:
		{
			char sItem[16]
			menu.GetItem(param2, sItem, 16)
			if(StrEqual(sItem, "starttp"))
				TeleportEntity(param1, g_center[0], NULL_VECTOR, NULL_VECTOR)
			else if(StrEqual(sItem, "start+xmins"))
				g_zoneStartOrigin[0][0] += 16.0
			else if(StrEqual(sItem, "start-xmins"))
				g_zoneStartOrigin[0][0] -= 16.0
			else if(StrEqual(sItem, "start+ymins"))
				g_zoneStartOrigin[0][1] += 16.0
			else if(StrEqual(sItem, "start-ymins"))
				g_zoneStartOrigin[0][1] -= 16.0
			else if(StrEqual(sItem, "start+xmaxs"))
				g_zoneStartOrigin[1][0] += 16.0
			else if(StrEqual(sItem, "start-xmaxs"))
				g_zoneStartOrigin[1][0] -= 16.0
			else if(StrEqual(sItem, "start+ymaxs"))
				g_zoneStartOrigin[1][1] += 16.0
			else if(StrEqual(sItem, "start-ymaxs"))
				g_zoneStartOrigin[1][1] -= 16.0
			else if(StrEqual(sItem, "endtp"))
				TeleportEntity(param1, g_center[1], NULL_VECTOR, NULL_VECTOR)
			else if(StrEqual(sItem, "end+xmins"))
				g_zoneEndOrigin[0][0] += 16.0
			else if(StrEqual(sItem, "end-xmins"))
				g_zoneEndOrigin[0][0] -= 16.0
			else if(StrEqual(sItem, "end+ymins"))
				g_zoneEndOrigin[0][1] += 16.0
			else if(StrEqual(sItem, "end-ymins"))
				g_zoneEndOrigin[0][1] -= 16.0
			else if(StrEqual(sItem, "end+xmaxs"))
				g_zoneEndOrigin[1][0] += 16.0
			else if(StrEqual(sItem, "end-xmaxs"))
				g_zoneEndOrigin[1][0] -= 16.0
			else if(StrEqual(sItem, "end+ymaxs"))
				g_zoneEndOrigin[1][1] += 16.0
			else if(StrEqual(sItem, "end-ymaxs"))
				g_zoneEndOrigin[1][1] -= 16.0
			char sExploded[16][16]
			ExplodeString(sItem, ";", sExploded, 16, 16)
			int cpnum = StringToInt(sExploded[0])
			char formatCP[16]
			Format(formatCP, 16, "%i;tp", cpnum)
			if(StrEqual(sItem, formatCP))
				TeleportEntity(param1, g_center[cpnum + 1], NULL_VECTOR, NULL_VECTOR)
			Format(formatCP, 16, "%i;1", cpnum)
			if(StrEqual(sItem, formatCP))
				g_cpPos[0][cpnum][0] += 16.0
			Format(formatCP, 16, "%i;2", cpnum)
			if(StrEqual(sItem, formatCP))
				g_cpPos[0][cpnum][0] -= 16.0
			Format(formatCP, 16, "%i;3", cpnum)
			if(StrEqual(sItem, formatCP))
				g_cpPos[0][cpnum][1] += 16.0
			Format(formatCP, 16, "%i;4", cpnum)
			if(StrEqual(sItem, formatCP))
				g_cpPos[0][cpnum][1] -= 16.0
			Format(formatCP, 16, "%i;5", cpnum)
			if(StrEqual(sItem, formatCP))
				g_cpPos[1][cpnum][0] += 16.0
			Format(formatCP, 16, "%i;6", cpnum)
			if(StrEqual(sItem, formatCP))
				g_cpPos[1][cpnum][0] -= 16.0
			Format(formatCP, 16, "%i;7", cpnum)
			if(StrEqual(sItem, formatCP))
				g_cpPos[1][cpnum][1] += 16.0
			Format(formatCP, 16, "%i;8", cpnum)
			if(StrEqual(sItem, formatCP))
				g_cpPos[1][cpnum][1] -= 16.0
			char query[512]
			if(StrEqual(sItem, "startupdate"))
			{
				Format(query, 512, "UPDATE zones SET possition_x = %i, possition_y = %i, possition_z = %i, possition_x2 = %i, possition_y2 = %i, possition_z2 = %i WHERE type = 0 AND map = '%s'", RoundFloat(g_zoneStartOrigin[0][0]), RoundFloat(g_zoneStartOrigin[0][1]), RoundFloat(g_zoneStartOrigin[0][2]), RoundFloat(g_zoneStartOrigin[1][0]), RoundFloat(g_zoneStartOrigin[1][1]), RoundFloat(g_zoneStartOrigin[1][2]), g_map)
				g_mysql.Query(SQLUpdateZone, query, 0)
			}
			else if(StrEqual(sItem, "endupdate"))
			{
				Format(query, 512, "UPDATE zones SET possition_x = %i, possition_y = %i, possition_z = %i, possition_x2 = %i, possition_y2 = %i, possition_z2 = %i WHERE type = 1 AND map = '%s'", RoundFloat(g_zoneEndOrigin[0][0]), RoundFloat(g_zoneEndOrigin[0][1]), RoundFloat(g_zoneEndOrigin[0][2]), RoundFloat(g_zoneEndOrigin[1][0]), RoundFloat(g_zoneEndOrigin[1][1]), RoundFloat(g_zoneEndOrigin[1][2]), g_map)
				g_mysql.Query(SQLUpdateZone, query, 1)
			}
			else if(StrEqual(sItem, "cpupdate"))
			{
				Format(query, 512, "UPDATE cp SET cpx = %i, cpy = %i, cpz = %i, cpx2 = %i, cpy2 = %i, cpz2 = %i WHERE cpnum = %i AND map = '%s'", RoundFloat(g_cpPos[0][cpnum][0]), RoundFloat(g_cpPos[0][cpnum][1]), RoundFloat(g_cpPos[0][cpnum][2]), RoundFloat(g_cpPos[1][cpnum][0]), RoundFloat(g_cpPos[1][cpnum][1]), RoundFloat(g_cpPos[1][cpnum][2]), cpnum, g_map)
				g_mysql.Query(SQLUpdateZone, query, cpnum + 1)
			}
			menu.DisplayAt(param1, GetMenuSelectionPosition(), MENU_TIME_FOREVER) //https://forums.alliedmods.net/showthread.php?p=2091775
		}
		case MenuAction_Cancel: // trikz redux menuaction end
		{
			g_zoneDraw[param1] = false //idea from expert zone.
			switch(param2)
			{
				case MenuCancel_ExitBack: //https://cc.bingj.com/cache.aspx?q=ExitBackButton+sourcemod&d=4737211702971338&mkt=en-WW&setlang=en-US&w=wg9m5FNl3EpqPBL0vTge58piA8n5NsLz#L125
					ZoneEditor(param1)
			}
		}
		case MenuAction_Display:
			g_zoneDraw[param1] = true
	}
}

void SQLUpdateZone(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error))
		PrintToServer("SQLUpdateZone: %s", error)
	else
	{
		if(results.HasResults == false)
		{
			if(data == 1)
				PrintToServer("End zone successfuly updated.")
			else if(!data)
				PrintToServer("Start zone successfuly updated.")
			else if(data > 1)
				PrintToServer("CP zone nr. %i successfuly updated.", data - 1)
		}
	}
}

//https://forums.alliedmods.net/showthread.php?t=261378

Action cmd_createcp(int args)
{
	g_mysql.Query(SQLCreateCPTable, "CREATE TABLE IF NOT EXISTS cp (id INT AUTO_INCREMENT, cpnum INT, cpx INT, cpy INT, cpz INT, cpx2 INT, cpy2 INT, cpz2 INT, map VARCHAR(192), PRIMARY KEY(id))")
}

void SQLCreateCPTable(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error))
		PrintToServer("SQLCreateCPTable: %s", error)
	else
	{
		PrintToServer("CP table successfuly created.")
	}
}

Action cmd_createtier(int args)
{
	g_mysql.Query(SQLCreateTierTable, "CREATE TABLE IF NOT EXISTS tier (id INT AUTO_INCREMENT, tier INT, map VARCHAR(192), PRIMARY KEY(id))")
}

void SQLCreateTierTable(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error))
		PrintToServer("SQLCreateTierTable: %s", error)
	else
	{
		PrintToServer("Tier table successfuly created.")
	}
}

void CPSetup(int client)
{
	g_cpCount = 0
	char query[512]
	for(int i = 1; i <= 10; i++)
	{
		Format(query, 512, "SELECT cpx, cpy, cpz, cpx2, cpy2, cpz2 FROM cp WHERE cpnum = %i AND map = '%s' LIMIT 1", i, g_map)
		DataPack dp = new DataPack()
		dp.WriteCell(client ? GetClientSerial(client) : 0)
		dp.WriteCell(i)
		g_mysql.Query(SQLCPSetup, query, dp)
	}
}

void SQLCPSetup(Database db, DBResultSet results, const char[] error, DataPack dp)
{
	if(strlen(error))
		PrintToServer("SQLCPSetup: %s", error)
	else
	{
		dp.Reset()
		int client = GetClientFromSerial(dp.ReadCell())
		int cp = dp.ReadCell()
		if(results.FetchRow())
		{
			g_cpPos[0][cp][0] = results.FetchFloat(0)
			g_cpPos[0][cp][1] = results.FetchFloat(1)
			g_cpPos[0][cp][2] = results.FetchFloat(2)
			g_cpPos[1][cp][0] = results.FetchFloat(3)
			g_cpPos[1][cp][1] = results.FetchFloat(4)
			g_cpPos[1][cp][2] = results.FetchFloat(5)
			if(!g_devmap)
				createcp(cp)
			g_cpCount++
		}
		if(cp == 10)
		{
			if(client)
				ZoneEditor2(client)
			if(!g_zoneHave[2])
				g_zoneHave[2] = true
			if(!g_devmap)
				for(int i = 1; i <= MaxClients; i++)
					if(IsClientInGame(i))
						OnClientPutInServer(i)
		}
	}
}

void createcp(int cpnum)
{
	char triggerName[64]
	Format(triggerName, 64, "fakeexpert_cp%i", cpnum)
	int entity = CreateEntityByName("trigger_multiple")
	DispatchKeyValue(entity, "spawnflags", "1") //https://github.com/shavitush/bhoptimer
	DispatchKeyValue(entity, "wait", "0")
	DispatchKeyValue(entity, "targetname", triggerName)
	DispatchSpawn(entity)
	SetEntityModel(entity, "models/player/t_arctic.mdl")
	//https://stackoverflow.com/questions/4355894/how-to-get-center-of-set-of-points-using-python
	g_center[cpnum + 1][0] = (g_cpPos[1][cpnum][0] + g_cpPos[0][cpnum][0]) / 2.0
	g_center[cpnum + 1][1] = (g_cpPos[1][cpnum][1] + g_cpPos[0][cpnum][1]) / 2.0
	g_center[cpnum + 1][2] = (g_cpPos[1][cpnum][2] + g_cpPos[0][cpnum][2]) / 2.0
	TeleportEntity(entity, g_center[cpnum + 1], NULL_VECTOR, NULL_VECTOR) //Thanks to https://amx-x.ru/viewtopic.php?f=14&t=15098 http://world-source.ru/forum/102-3743-1
	float mins[3]
	float maxs[3]
	for(int i = 0; i <= 1; i++)
	{
		mins[i] = (g_cpPos[0][cpnum][i] - g_cpPos[1][cpnum][i]) / 2.0
		if(mins[i] > 0.0)
			mins[i] *= -1.0
		maxs[i] = (g_cpPos[0][cpnum][i] - g_cpPos[1][cpnum][i]) / 2.0
		if(maxs[i] < 0.0)
			maxs[i] *= -1.0
	}
	maxs[2] = 124.0
	SetEntPropVector(entity, Prop_Send, "m_vecMins", mins) //https://forums.alliedmods.net/archive/index.php/t-301101.html
	SetEntPropVector(entity, Prop_Send, "m_vecMaxs", maxs)
	SetEntProp(entity, Prop_Send, "m_nSolidType", 2)
	SDKHook(entity, SDKHook_StartTouch, SDKStartTouch)
	PrintToServer("Checkpoint number %i is successfuly setup.", cpnum)
}

Action cmd_createusers(int args)
{
	g_mysql.Query(SQLCreateUserTable, "CREATE TABLE IF NOT EXISTS users (id INT AUTO_INCREMENT, username VARCHAR(64), steamid INT, firstjoin INT, lastjoin INT, points INT, PRIMARY KEY(id))")
}

void SQLCreateUserTable(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error))
		PrintToServer("SQLCreateUserTable: %s", error)
	else
	{
		PrintToServer("Successfuly created user table.")
	}
}

Action cmd_createrecords(int args)
{
	g_mysql.Query(SQLRecordsTable, "CREATE TABLE IF NOT EXISTS records (id INT AUTO_INCREMENT, playerid INT, time FLOAT, finishes INT, tries INT, cp1 FLOAT, cp2 FLOAT, cp3 FLOAT, cp4 FLOAT, cp5 FLOAT, cp6 FLOAT, cp7 FLOAT, cp8 FLOAT, cp9 FLOAT, cp10 FLOAT, points INT, map VARCHAR(192), date INT, PRIMARY KEY(id))")
}

void SQLRecordsTable(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error))
		PrintToServer("SQLRecordsTable: %s", error)
	else
	{
		PrintToServer("Successfuly created records table.")
	}
}

Action SDKEndTouch(int entity, int other)
{
	if(0 < other <= MaxClients && !IsFakeClient(other) && !g_devmap && !g_state[other])
	{
		g_state[other] = true
		g_timerTimeStart[other] = GetEngineTime()
		//g_clantagTimer[other] = CreateTimer(0.1, timer_clantag, other, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE)
		CreateTimer(0.1, timer_clantag, other, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE)
		for(int i = 1; i <= g_cpCount; i++)
		{
			g_cp[i][other] = false
			g_cpLock[i][other] = false
		}
	}
}

Action SDKTouch(int entity, int other)
{
	if(0 < other <= MaxClients && !IsFakeClient(other) && !g_devmap)
	{
		if(g_velJump[other] > 278.0 + 10.0)
		{
			if(GetEntityFlags(other) & FL_ONGROUND)
			{
				if(g_jumped[other])
				{
					TeleportEntity(other, NULL_VECTOR, NULL_VECTOR, view_as<float>({0.0, 0.0, 0.0}))
					g_jumped[other] = false
				}
			}
			else
			{
				float vel[3]
				GetEntPropVector(other, Prop_Data, "m_vecAbsVelocity", vel)
				float velXY = SquareRoot(Pow(vel[0], 2.0) + Pow(vel[1], 2.0))
				if(velXY > 278.0 + 10.0)
					TeleportEntity(other, NULL_VECTOR, NULL_VECTOR, view_as<float>({0.0, 0.0, 0.0}))
			}
		}
		if(GetEntityFlags(other) & FL_ONGROUND) //Idea from shavit-timer.
		{
			if(g_state[other])
				Restart(other, true) //expert zone idea.
		}
		else
		{
			if(!g_state[other])
			{
				g_state[other] = true
				g_timerTimeStart[other] = GetEngineTime()
				//g_clantagTimer[other] = CreateTimer(0.1, timer_clantag, other, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE)
				CreateTimer(0.1, timer_clantag, other, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE)
				for(int i = 1; i <= g_cpCount; i++)
				{
					g_cp[i][other] = false
					g_cpLock[i][other] = false
				}
			}
		}
	}
}

Action SDKStartTouch(int entity, int other)
{
	if(0 < other <= MaxClients && !g_devmap && !IsFakeClient(other))
	{
		char trigger[32]
		GetEntPropString(entity, Prop_Data, "m_iName", trigger, 32)
		if(StrEqual(trigger, "fakeexpert_startzone"))
			Restart(other, true) //expert zone idea.
		if(StrEqual(trigger, "fakeexpert_endzone"))
		{
			if(g_state[other])
			{
				char query[512]
				int playerid = GetSteamAccountID(other)
				int personalHour = (RoundToFloor(g_timerTime[other]) / 3600) % 24 //https://forums.alliedmods.net/archive/index.php/t-187536.html
				int personalMinute = (RoundToFloor(g_timerTime[other]) / 60) % 60
				int personalSecond = RoundToFloor(g_timerTime[other]) % 60
				if(g_ServerRecordTime)
				{
					if(g_recordHave[other])
					{
						if(g_ServerRecordTime > g_timerTime[other])
						{
							float timeDiff = g_ServerRecordTime - g_timerTime[other]
							int srHour = (RoundToFloor(timeDiff) / 3600) % 24
							int srMinute = (RoundToFloor(timeDiff) / 60) % 60
							int srSecond = RoundToFloor(timeDiff) % 60
							PrintToChatAll("\x077CFC00New server record!")
							PrintToChatAll("\x01%N finished map in \x077CFC00%02.i:%02.i:%02.i \x01(SR \x077CFC00-%02.i:%02.i:%02.i\x01)", other, personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
							FinishMSG(other, false, true, false, false, false, 0, personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
							Format(query, 512, "UPDATE records SET time = %f, finishes = finishes + 1, cp1 = %f, cp2 = %f, cp3 = %f, cp4 = %f, cp5 = %f, cp6 = %f, cp7 = %f, cp8 = %f, cp9 = %f, cp10 = %f, date = %i WHERE playerid = %i AND map = '%s' ORDER BY time LIMIT 1", g_timerTime[other], g_cpTimeClient[1][other], g_cpTimeClient[2][other], g_cpTimeClient[3][other], g_cpTimeClient[4][other], g_cpTimeClient[5][other], g_cpTimeClient[6][other], g_cpTimeClient[7][other], g_cpTimeClient[8][other], g_cpTimeClient[9][other], g_cpTimeClient[10][other], GetTime(), playerid, g_map)
							g_mysql.Query(SQLUpdateRecord, query)
							g_recordHave[other] = g_timerTime[other]
							g_ServerRecord = true
							g_ServerRecordTime = g_timerTime[other]
							CreateTimer(60.0, timer_sourcetv, _, TIMER_FLAG_NO_MAPCHANGE)
							Call_StartForward(g_record)
							Call_PushCell(other)
							Call_PushFloat(g_timerTime[other])
							Call_Finish()
						}
						else if((g_ServerRecordTime < g_timerTime[other] > g_recordHave[other]) && g_recordHave[other])
						{
							float timeDiff = g_timerTime[other] - g_ServerRecordTime
							int srHour = (RoundToFloor(timeDiff) / 3600) % 24
							int srMinute = (RoundToFloor(timeDiff) / 60) % 60
							int srSecond = RoundToFloor(timeDiff) % 60
							PrintToChatAll("\x01%N finished map in \x077CFC00%02.i:%02.i:%02.i \x01(SR \x07FF0000+%02.i:%02.i:%02.i\x01)", other, personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
							FinishMSG(other, false, false, false, false, false, 0, personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
							Format(query, 512, "UPDATE records SET finishes = finishes + 1 WHERE playerid = %i AND map = '%s' LIMIT 1", playerid, g_map)
							g_mysql.Query(SQLUpdateRecord, query)
						}
						else if(g_ServerRecordTime < g_timerTime[other] < g_recordHave[other])
						{
							float timeDiff = g_timerTime[other] - g_ServerRecordTime
							int srHour = (RoundToFloor(timeDiff) / 3600) % 24
							int srMinute = (RoundToFloor(timeDiff) / 60) % 60
							int srSecond = RoundToFloor(timeDiff) % 60
							PrintToChatAll("\x01%N finished map in \x077CFC00%02.i:%02.i:%02.i \x01(SR \x07FF0000+%02.i:%02.i:%02.i\x01)", other, personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
							FinishMSG(other, false, false, false, false, false, 0, personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
							Format(query, 512, "UPDATE records SET time = %f, finishes = finishes + 1, cp1 = %f, cp2 = %f, cp3 = %f, cp4 = %f, cp5 = %f, cp6 = %f, cp7 = %f, cp8 = %f, cp9 = %f, cp10 = %f, date = %i WHERE playerid = %i AND map = '%s' LIMIT 1", g_timerTime[other], g_cpTimeClient[1][other], g_cpTimeClient[2][other], g_cpTimeClient[3][other], g_cpTimeClient[4][other], g_cpTimeClient[5][other], g_cpTimeClient[6][other], g_cpTimeClient[7][other], g_cpTimeClient[8][other], g_cpTimeClient[9][other], g_cpTimeClient[10][other], GetTime(), playerid, g_map)
							g_mysql.Query(SQLUpdateRecord, query)
							if(g_recordHave[other] > g_timerTime[other])
								g_recordHave[other] = g_timerTime[other]			
						}
					}
					else
					{
						if(g_ServerRecordTime > g_timerTime[other])
						{
							float timeDiff = g_ServerRecordTime - g_timerTime[other]
							int srHour = (RoundToFloor(timeDiff) / 3600) % 24
							int srMinute = (RoundToFloor(timeDiff) / 60) % 60
							int srSecond = RoundToFloor(timeDiff) % 60
							PrintToChatAll("\x077CFC00New server record!")
							PrintToChatAll("\x01%N finished map in \x077CFC00%02.i:%02.i:%02.i \x01(SR \x077CFC00-%02.i:%02.i:%02.i\x01)", other, personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
							FinishMSG(other, false, true, false, false, false, 0, personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
							Format(query, 512, "INSERT INTO records (playerid, time, finishes, tries, cp1, cp2, cp3, cp4, cp5, cp6, cp7, cp8, cp9, cp10, map, date) VALUES (%i, %f, 1, 1, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, '%s', %i)", playerid, g_timerTime[other], g_cpTimeClient[1][other], g_cpTimeClient[2][other], g_cpTimeClient[3][other], g_cpTimeClient[4][other], g_cpTimeClient[5][other], g_cpTimeClient[6][other], g_cpTimeClient[7][other], g_cpTimeClient[8][other], g_cpTimeClient[9][other], g_cpTimeClient[10][other], g_map, GetTime())
							g_mysql.Query(SQLInsertRecord, query)
							g_recordHave[other] = g_timerTime[other]
							g_ServerRecord = true
							g_ServerRecordTime = g_timerTime[other]
							CreateTimer(60.0, timer_sourcetv, _, TIMER_FLAG_NO_MAPCHANGE)
							Call_StartForward(g_record)
							Call_PushCell(other)
							Call_PushFloat(g_timerTime[other])
							Call_Finish()
						}
						else
						{
							float timeDiff = g_timerTime[other] - g_ServerRecordTime
							int srHour = (RoundToFloor(timeDiff) / 3600) % 24
							int srMinute = (RoundToFloor(timeDiff) / 60) % 60
							int srSecond = RoundToFloor(timeDiff) % 60
							PrintToChatAll("\x01%N finished map in \x077CFC00%02.i:%02.i:%02.i \x01(SR \x07FF0000+%02.i:%02.i:%02.i\x01)", other, personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
							FinishMSG(other, false, false, false, false, false, 0, personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
							Format(query, 512, "INSERT INTO records (playerid, time, finishes, tries, cp1, cp2, cp3, cp4, cp5, cp6, cp7, cp8, cp9, cp10, map, date) VALUES (%i, %f, 1, 1, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, '%s', %i)", playerid, g_timerTime[other], g_cpTimeClient[1][other], g_cpTimeClient[2][other], g_cpTimeClient[3][other], g_cpTimeClient[4][other], g_cpTimeClient[5][other], g_cpTimeClient[6][other], g_cpTimeClient[7][other], g_cpTimeClient[8][other], g_cpTimeClient[9][other], g_cpTimeClient[10][other], g_map, GetTime())
							g_mysql.Query(SQLInsertRecord, query)
							if(!g_recordHave[other])
								g_recordHave[other] = g_timerTime[other]
						}
					}
					for(int i = 1; i <= g_cpCount; i++)
					{
						if(g_cp[i][other])
						{
							int srCPHour = (RoundToFloor(g_cpDiff[i][other]) / 3600) % 24
							int srCPMinute = (RoundToFloor(g_cpDiff[i][other]) / 60) % 60
							int srCPSecond = RoundToFloor(g_cpDiff[i][other]) % 60
							if(g_cpTimeClient[i][other] < g_cpTime[i])
								PrintToChatAll("\x01%i. Checkpoint: \x077CFC00-%02.i:%02.i:%02.i", i, srCPHour, srCPMinute, srCPSecond)
							else
								PrintToChatAll("\x01%i. Checkpoint: \x07FF0000+%02.i:%02.i:%02.i", i, srCPHour, srCPMinute, srCPSecond)
						}
					}
				}
				else
				{
					g_ServerRecordTime = g_timerTime[other]
					g_recordHave[other] = g_timerTime[other]
					PrintToChatAll("\x077CFC00New server record!")
					PrintToChatAll("\x01%N finished map in \x077CFC00%02.i:%02.i:%02.i \x01(SR \x07FF0000+00:00:00\x01)", other, personalHour, personalMinute, personalSecond)
					FinishMSG(other, true, false, false, false, false, 0, personalHour, personalMinute, personalSecond)
					for(int i = 1; i <= g_cpCount; i++)
						if(g_cp[i][other])
							PrintToChatAll("\x01%i. Checkpoint: \x07FF0000+00:00:00", i)
					g_ServerRecord = true
					CreateTimer(60.0, timer_sourcetv, _, TIMER_FLAG_NO_MAPCHANGE) //https://forums.alliedmods.net/showthread.php?t=191615
					Format(query, 512, "INSERT INTO records (playerid, time, finishes, tries, cp1, cp2, cp3, cp4, cp5, cp6, cp7, cp8, cp9, cp10, map, date) VALUES (%i, %f, 1, 1, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, '%s', %i)", playerid, g_timerTime[other], g_cpTimeClient[1][other], g_cpTimeClient[2][other], g_cpTimeClient[3][other], g_cpTimeClient[4][other], g_cpTimeClient[5][other], g_cpTimeClient[6][other], g_cpTimeClient[7][other], g_cpTimeClient[8][other], g_cpTimeClient[9][other], g_cpTimeClient[10][other], g_map, GetTime())
					g_mysql.Query(SQLInsertRecord, query)
					Call_StartForward(g_record)
					Call_PushCell(other)
					Call_PushFloat(g_timerTime[other])
					Call_Finish()
				}
				g_state[other] = false
			}
		}
		for(int i = 1; i <= g_cpCount; i++)
		{
			char triggerCP[64]
			Format(triggerCP, 64, "fakeexpert_cp%i", i)
			if(StrEqual(trigger, triggerCP))
			{
				g_cp[i][other] = true
				if(g_cp[i][other] && !g_cpLock[i][other])
				{
					char query[512] //https://stackoverflow.com/questions/9617453 https://www.w3schools.com/sql/sql_ref_order_by.asp#:~:text=%20SQL%20ORDER%20BY%20Keyword%20%201%20ORDER,data%20returned%20in%20descending%20order.%20%20More%20
					int playerid = GetSteamAccountID(other)
					if(!g_cpLock[1][other] && g_recordHave[other])
					{
						Format(query, 512, "UPDATE records SET tries = tries + 1 WHERE playerid = %i AND map = '%s' LIMIT 1", playerid, g_map)
						g_mysql.Query(SQLSetTries, query)
					}
					g_cpLock[i][other] = true
					g_cpTimeClient[i][other] = g_timerTime[other]
					Format(query, 512, "SELECT cp%i FROM records LIMIT 1", i)
					DataPack dp = new DataPack()
					dp.WriteCell(GetClientSerial(other))
					dp.WriteCell(i)
					g_mysql.Query(SQLCPSelect, query, dp)
				}
			}
		}
	}
}

void FinishMSG(int client, bool firstServerRecord, bool serverRecord, bool cpOnly, bool firstCPRecord, bool cpRecord, int cpnum, int personalHour, int personalMinute, personalSecond, int srHour = 0, int srMinute = 0, int srSecond = 0)
{
	if(cpOnly)
	{
		if(firstCPRecord)
		{
			SetHudTextParams(-1.0, -0.75, 3.0, 0, 255, 0, 255) //https://sm.alliedmods.net/new-api/halflife/SetHudTextParams
			ShowHudText(client, 1, "%i. CHECKPOINT RECORD!", cpnum) //https://sm.alliedmods.net/new-api/halflife/ShowHudText
			SetHudTextParams(-1.0, -0.63, 3.0, 255, 255, 255, 255)
			ShowHudText(client, 2, "CHECKPOINT: %02.i:%02.i:%02.i", personalHour, personalMinute, personalSecond)
			SetHudTextParams(-1.0, -0.6, 3.0, 255, 0, 0, 255)
			ShowHudText(client, 3, "+00:00:00")
			for(int i = 1; i <= MaxClients; i++)
			{
				if(IsClientInGame(i) && IsClientObserver(i))
				{
					int observerTarget = GetEntPropEnt(i, Prop_Data, "m_hObserverTarget")
					int observerMode = GetEntProp(i, Prop_Data, "m_iObserverMode")
					if(observerMode < 7 && observerTarget == client)
					{
						SetHudTextParams(-1.0, -0.75, 3.0, 0, 255, 0, 255)
						ShowHudText(i, 1, "%i. CHECKPOINT RECORD!", cpnum)
						SetHudTextParams(-1.0, -0.63, 3.0, 255, 255, 255, 255)
						ShowHudText(i, 2, "CHECKPOINT: %02.i:%02.i:%02.i", personalHour, personalMinute, personalSecond)
						SetHudTextParams(-1.0, -0.6, 3.0, 255, 0, 0, 255)
						ShowHudText(i, 3, "+00:00:00")
					}
				}
			}
		}
		else
		{
			if(cpRecord)
			{
				SetHudTextParams(-1.0, -0.75, 3.0, 0, 255, 0, 255)
				ShowHudText(client, 1, "%i. CHECKPOINT RECORD!", cpnum) //https://teamuserimages-a.akamaihd.net/ugc/1788470716362427548/185302157B3F4CBF4557D0C47842C6BBD705380A/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false
				SetHudTextParams(-1.0, -0.63, 3.0, 255, 255, 255, 255)
				ShowHudText(client, 2, "CHECKPOINT: %02.i:%02.i:%02.i", personalHour, personalMinute, personalSecond)
				SetHudTextParams(-1.0, -0.6, 3.0, 0, 255, 0, 255)
				ShowHudText(client, 3, "-%02.i:%02.i:%02.i", srHour, srMinute, srSecond)
				for(int i = 1; i <= MaxClients; i++)
				{
					if(IsClientInGame(i) && IsClientObserver(i))
					{
						int observerTarget = GetEntPropEnt(i, Prop_Data, "m_hObserverTarget")
						int observerMode = GetEntProp(i, Prop_Data, "m_iObserverMode")
						if(observerMode < 7 && observerTarget == client)
						{
							SetHudTextParams(-1.0, -0.75, 3.0, 0, 255, 0, 255)
							ShowHudText(i, 1, "%i. CHECKPOINT RECORD!", cpnum)
							SetHudTextParams(-1.0, -0.63, 3.0, 255, 255, 255, 255)
							ShowHudText(i, 2, "CHECKPOINT: %02.i:%02.i:%02.i", personalHour, personalMinute, personalSecond)
							SetHudTextParams(-1.0, -0.6, 3.0, 0, 255, 0, 255)
							ShowHudText(i, 3, "-%02.i:%02.i:%02.i", srHour, srMinute, srSecond)
						}
					}
				}
			}
			else
			{
				SetHudTextParams(-1.0, -0.63, 3.0, 255, 255, 255, 255)
				ShowHudText(client, 1, "CHECKPOINT: %02.i:%02.i:%02.i", personalHour, personalMinute, personalSecond) //https://teamuserimages-a.akamaihd.net/ugc/1788470716362384940/4DD466582BD1CF04366BBE6D383DD55A079936DC/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false
				SetHudTextParams(-1.0, -0.6, 3.0, 255, 0, 0, 255)
				ShowHudText(client, 2, "+%02.i:%02.i:%02.i", srHour, srMinute, srSecond)
				for(int i = 1; i <= MaxClients; i++)
				{
					if(IsClientInGame(i) && IsClientObserver(i))
					{
						int observerTarget = GetEntPropEnt(i, Prop_Data, "m_hObserverTarget")
						int observerMode = GetEntProp(i, Prop_Data, "m_iObserverMode")
						if(observerMode < 7 && observerTarget == client)
						{
							SetHudTextParams(-1.0, -0.63, 3.0, 255, 255, 255, 255)
							ShowHudText(i, 1, "CHECKPOINT: %02.i:%02.i:%02.i", personalHour, personalMinute, personalSecond)
							SetHudTextParams(-1.0, -0.6, 3.0, 255, 0, 0, 255)
							ShowHudText(i, 2, "+%02.i:%02.i:%02.i", srHour, srMinute, srSecond)
						}
					}
				}
			}
		}
	}
	else
	{
		if(firstServerRecord)
		{
			SetHudTextParams(-1.0, -0.8, 3.0, 0, 255, 255, 255) //https://sm.alliedmods.net/new-api/halflife/SetHudTextParams
			ShowHudText(client, 1, "MAP FINISHED!") //https://sm.alliedmods.net/new-api/halflife/ShowHudText
			SetHudTextParams(-1.0, -0.75, 3.0, 0, 255, 0, 255)
			ShowHudText(client, 2, "NEW SERVER RECORD!")
			SetHudTextParams(-1.0, -0.63, 3.0, 255, 255, 255, 255)
			ShowHudText(client, 3, "TIME: %02.i:%02.i:%02.i", personalHour, personalMinute, personalSecond)
			SetHudTextParams(-1.0, -0.6, 3.0, 255, 0, 0, 255)
			ShowHudText(client, 4, "+00:00:00")
			for(int i = 1; i <= MaxClients; i++)
			{
				if(IsClientInGame(i) && IsClientObserver(i))
				{
					int observerTarget = GetEntPropEnt(i, Prop_Data, "m_hObserverTarget")
					int observerMode = GetEntProp(i, Prop_Data, "m_iObserverMode")
					if(IsClientSourceTV(i) || (observerMode < 7 && observerTarget == client))
					{
						SetHudTextParams(-1.0, -0.8, 3.0, 0, 255, 255, 255)
						ShowHudText(i, 1, "MAP FINISHED!")
						SetHudTextParams(-1.0, -0.75, 3.0, 0, 255, 0, 255)
						ShowHudText(i, 2, "NEW SERVER RECORD!")
						SetHudTextParams(-1.0, -0.63, 3.0, 255, 255, 255, 255)
						ShowHudText(i, 3, "TIME: %02.i:%02.i:%02.i", personalHour, personalMinute, personalSecond)
						SetHudTextParams(-1.0, -0.6, 3.0, 255, 0, 0, 255)
						ShowHudText(i, 4, "+00:00:00")
					}
				}
			}
		}
		else
		{
			if(serverRecord)
			{
				SetHudTextParams(-1.0, -0.8, 3.0, 0, 255, 255, 255)
				ShowHudText(client, 1, "MAP FINISHED!")
				SetHudTextParams(-1.0, -0.75, 3.0, 0, 255, 0, 255)
				ShowHudText(client, 2, "NEW SERVER RECORD!")
				SetHudTextParams(-1.0, -0.63, 3.0, 255, 255, 255, 255)
				ShowHudText(client, 3, "TIME: %02.i:%02.i:%02.i", personalHour, personalMinute, personalSecond)
				SetHudTextParams(-1.0, -0.6, 3.0, 0, 255, 0, 255)
				ShowHudText(client, 4, "-%02.i:%02.i:%02.i", srHour, srMinute, srSecond) //https://youtu.be/j4L3YvHowv8?t=45
				for(int i = 1; i <= MaxClients; i++)
				{
					if(IsClientInGame(i) && IsClientObserver(i))
					{
						int observerTarget = GetEntPropEnt(i, Prop_Data, "m_hObserverTarget")
						int observerMode = GetEntProp(i, Prop_Data, "m_iObserverMode")
						if(IsClientSourceTV(i) || (observerMode < 7 && observerTarget == client))
						{
							SetHudTextParams(-1.0, -0.8, 3.0, 0, 255, 255, 255)
							ShowHudText(i, 1, "MAP FINISHED!")
							SetHudTextParams(-1.0, -0.75, 3.0, 0, 255, 0, 255)
							ShowHudText(i, 2, "NEW SERVER RECORD!")
							SetHudTextParams(-1.0, -0.63, 3.0, 255, 255, 255, 255)
							ShowHudText(i, 3, "TIME: %02.i:%02.i:%02.i", personalHour, personalMinute, personalSecond)
							SetHudTextParams(-1.0, -0.6, 3.0, 0, 255, 0, 255)
							ShowHudText(i, 4, "-%02.i:%02.i:%02.i", srHour, srMinute, srSecond)
						}
					}
				}
			}
			else
			{
				SetHudTextParams(-1.0, -0.8, 3.0, 0, 255, 255, 255)
				ShowHudText(client, 1, "MAP FINISHED!")
				SetHudTextParams(-1.0, -0.63, 3.0, 255, 255, 255, 255)
				ShowHudText(client, 2, "TIME: %02.i:%02.i:%02.i", personalHour, personalMinute, personalSecond)
				SetHudTextParams(-1.0, -0.6, 3.0, 255, 0, 0, 255)
				ShowHudText(client, 3, "+%02.i:%02.i:%02.i", srHour, srMinute, srSecond)
				for(int i = 1; i <= MaxClients; i++)
				{
					if(IsClientInGame(i) && IsClientObserver(i))
					{
						int observerTarget = GetEntPropEnt(i, Prop_Data, "m_hObserverTarget")
						int observerMode = GetEntProp(i, Prop_Data, "m_iObserverMode")
						if(observerMode < 7 && observerTarget == client)
						{
							SetHudTextParams(-1.0, -0.8, 3.0, 0, 255, 255, 255)
							ShowHudText(i, 1, "MAP FINISHED!")
							SetHudTextParams(-1.0, -0.63, 3.0, 255, 255, 255, 255)
							ShowHudText(i, 2, "TIME: %02.i:%02.i:%02.i", personalHour, personalMinute, personalSecond)
							SetHudTextParams(-1.0, -0.6, 3.0, 255, 0, 0, 255)
							ShowHudText(i, 3, "+%02.i:%02.i:%02.i", srHour, srMinute, srSecond)
						}
					}
				}
			}
		}
	}
}

void SQLUpdateRecord(Database db, DBResultSet results, const char[] error, DataPack dp)
{
	if(strlen(error))
		PrintToServer("SQLUpdateRecord: %s", error)
}

void SQLInsertRecord(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error))
		PrintToServer("SQLInsertRecord: %s", error)
}

Action timer_sourcetv(Handle timer)
{
	ConVar sourceTVConVar = FindConVar("tv_enable")
	bool sourceTV = sourceTVConVar.BoolValue //https://sm.alliedmods.net/new-api/convars/__raw
	if(sourceTV)
	{
		ServerCommand("tv_stoprecord")
		g_sourceTVchangedFilename = false
		CreateTimer(5.0, timer_runSourceTV, _, TIMER_FLAG_NO_MAPCHANGE)
		g_ServerRecord = false
	}
}

Action timer_runSourceTV(Handle timer)
{
	char filenameOld[256]
	Format(filenameOld, 256, "%s-%s-%s.dem", g_date, g_time, g_map)
	char filenameNew[256]
	Format(filenameNew, 256, "%s-%s-%s-ServerRecord.dem", g_date, g_time, g_map)
	RenameFile(filenameNew, filenameOld)
	ConVar sourceTVConVar = FindConVar("tv_enable")
	bool sourceTV = sourceTVConVar.BoolValue //https://sm.alliedmods.net/new-api/convars/__raw
	if(sourceTV)
	{
		PrintToServer("SourceTV start recording.")
		FormatTime(g_date, 64, "%Y-%m-%d", GetTime())
		FormatTime(g_time, 64, "%H-%M-%S", GetTime())
		ServerCommand("tv_record %s-%s-%s", g_date, g_time, g_map)
		g_sourceTVchangedFilename = true
	}
}

void SQLCPSelect(Database db, DBResultSet results, const char[] error, DataPack data)
{
	if(strlen(error))
		PrintToServer("SQLCPSelect: %s", error)
	else
	{
		data.Reset()
		int other = GetClientFromSerial(data.ReadCell())
		int cpnum = data.ReadCell()
		char query[512]
		if(results.FetchRow())
		{
			Format(query, 512, "SELECT cp%i FROM records WHERE map = '%s' ORDER BY time LIMIT 1", cpnum, g_map) //log help me alot with this stuff
			DataPack dp = new DataPack()
			dp.WriteCell(GetClientSerial(other))
			dp.WriteCell(cpnum)
			g_mysql.Query(SQLCPSelect2, query, dp)
		}
		else
		{
			int personalHour = (RoundToFloor(g_timerTime[other]) / 3600) % 24
			int personalMinute = (RoundToFloor(g_timerTime[other]) / 60) % 60
			int personalSecond = RoundToFloor(g_timerTime[other]) % 60
			FinishMSG(other, false, false, true, true, false, cpnum, personalHour, personalMinute, personalSecond)
		}
	}
}

void SQLCPSelect2(Database db, DBResultSet results, const char[] error, DataPack data)
{
	if(strlen(error))
		PrintToServer("SQLCPSelect2: %s", error)
	else
	{
		data.Reset()
		int other = GetClientFromSerial(data.ReadCell())
		int cpnum = data.ReadCell()
		int personalHour = (RoundToFloor(g_timerTime[other]) / 3600) % 24
		int personalMinute = (RoundToFloor(g_timerTime[other]) / 60) % 60
		int personalSecond = RoundToFloor(g_timerTime[other]) % 60
		if(results.FetchRow())
		{
			g_cpTime[cpnum] = results.FetchFloat(0)
			if(g_cpTimeClient[cpnum][other] < g_cpTime[cpnum])
			{
				g_cpDiff[cpnum][other] = g_cpTime[cpnum] - g_cpTimeClient[cpnum][other]
				int srCPHour = (RoundToFloor(g_cpDiff[cpnum][other]) / 3600) % 24
				int srCPMinute = (RoundToFloor(g_cpDiff[cpnum][other]) / 60) % 60
				int srCPSecond = RoundToFloor(g_cpDiff[cpnum][other]) % 60
				FinishMSG(other, false, false, true, false, true, cpnum, personalHour, personalMinute, personalSecond, srCPHour, srCPMinute, srCPSecond)
			}
			else
			{
				g_cpDiff[cpnum][other] = g_cpTimeClient[cpnum][other] - g_cpTime[cpnum]
				int srCPHour = (RoundToFloor(g_cpDiff[cpnum][other]) / 3600) % 24
				int srCPMinute = (RoundToFloor(g_cpDiff[cpnum][other]) / 60) % 60
				int srCPSecond = RoundToFloor(g_cpDiff[cpnum][other]) % 60
				FinishMSG(other, false, false, true, false, false, cpnum, personalHour, personalMinute, personalSecond, srCPHour, srCPMinute, srCPSecond)
			}
		}
		else
			FinishMSG(other, false, false, true, true, false, cpnum, personalHour, personalMinute, personalSecond)
	}
}

void SQLSetTries(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error))
		PrintToServer("SQLSetTries: %s", error)
}

Action cmd_createzones(int args)
{
	g_mysql.Query(SQLCreateZonesTable, "CREATE TABLE IF NOT EXISTS zones (id INT AUTO_INCREMENT, map VARCHAR(128), type INT, possition_x INT, possition_y INT, possition_z INT, possition_x2 INT, possition_y2 INT, possition_z2 INT, PRIMARY KEY (id))") //https://stackoverflow.com/questions/8114535/mysql-1075-incorrect-table-definition-autoincrement-vs-another-key
}

void SQLConnect(Database db, const char[] error, any data)
{
	if(db)
	{
		PrintToServer("Successfuly connected to database.") //https://hlmod.ru/threads/sourcepawn-urok-13-rabota-s-bazami-dannyx-mysql-sqlite.40011/
		g_mysql = db
		g_mysql.SetCharset("utf8") //https://github.com/shavitush/bhoptimer/blob/master/addons/sourcemod/scripting/shavit-core.sp#L2883
		ForceZonesSetup() //https://sm.alliedmods.net/new-api/dbi/__raw
		g_dbPassed = true //https://github.com/shavitush/bhoptimer/blob/master/addons/sourcemod/scripting/shavit-stats.sp#L199
		char query[512]
		Format(query, 512, "SELECT time FROM records WHERE map = '%s' ORDER BY time LIMIT 1", g_map)
		g_mysql.Query(SQLGetServerRecord, query)
		RecalculatePoints()
	}
	else
		PrintToServer("Failed to connect to database. (%s)", error)
}

void ForceZonesSetup()
{
	char query[512]
	Format(query, 512, "SELECT possition_x, possition_y, possition_z, possition_x2, possition_y2, possition_z2 FROM zones WHERE map = '%s' AND type = 0 LIMIT 1", g_map)
	g_mysql.Query(SQLSetZoneStart, query)
}

void SQLSetZoneStart(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error))
		PrintToServer("SQLSetZoneStart: %s", error)
	else
	{
		if(results.FetchRow())
		{
			g_zoneStartOrigin[0][0] = results.FetchFloat(0)
			g_zoneStartOrigin[0][1] = results.FetchFloat(1)
			g_zoneStartOrigin[0][2] = results.FetchFloat(2)
			g_zoneStartOrigin[1][0] = results.FetchFloat(3)
			g_zoneStartOrigin[1][1] = results.FetchFloat(4)
			g_zoneStartOrigin[1][2] = results.FetchFloat(5)
			CreateStart()
			char query[512]
			Format(query, 512, "SELECT possition_x, possition_y, possition_z, possition_x2, possition_y2, possition_z2 FROM zones WHERE map = '%s' AND type = 1 LIMIT 1", g_map)
			g_mysql.Query(SQLSetZoneEnd, query)
		}
	}
}

void SQLSetZoneEnd(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error))
		PrintToServer("SQLSetZoneEnd: %s", error)
	else
	{
		if(results.FetchRow())
		{
			g_zoneEndOrigin[0][0] = results.FetchFloat(0)
			g_zoneEndOrigin[0][1] = results.FetchFloat(1)
			g_zoneEndOrigin[0][2] = results.FetchFloat(2)
			g_zoneEndOrigin[1][0] = results.FetchFloat(3)
			g_zoneEndOrigin[1][1] = results.FetchFloat(4)
			g_zoneEndOrigin[1][2] = results.FetchFloat(5)
			CreateEnd()
		}
	}
}

void SQLCreateZonesTable(Database db, DBResultSet results, const char[] error, any data)
{
	if(strlen(error))
		PrintToServer("SQLCreateZonesTable: %s", error)
	else
	{
		PrintToServer("Zones table is successfuly created.")
	}
}

void DrawZone(int client, float life)
{
	float start[12][3]
	float end[12][3]
	start[0][0] = (g_zoneStartOrigin[0][0] < g_zoneStartOrigin[1][0]) ? g_zoneStartOrigin[0][0] : g_zoneStartOrigin[1][0]
	start[0][1] = (g_zoneStartOrigin[0][1] < g_zoneStartOrigin[1][1]) ? g_zoneStartOrigin[0][1] : g_zoneStartOrigin[1][1]
	start[0][2] = (g_zoneStartOrigin[0][2] < g_zoneStartOrigin[1][2]) ? g_zoneStartOrigin[0][2] : g_zoneStartOrigin[1][2]
	start[0][2] += 3.0
	end[0][0] = (g_zoneStartOrigin[0][0] > g_zoneStartOrigin[1][0]) ? g_zoneStartOrigin[0][0] : g_zoneStartOrigin[1][0]
	end[0][1] = (g_zoneStartOrigin[0][1] > g_zoneStartOrigin[1][1]) ? g_zoneStartOrigin[0][1] : g_zoneStartOrigin[1][1]
	end[0][2] = (g_zoneStartOrigin[0][2] > g_zoneStartOrigin[1][2]) ? g_zoneStartOrigin[0][2] : g_zoneStartOrigin[1][2]
	end[0][2] += 3.0
	start[1][0] = (g_zoneEndOrigin[0][0] < g_zoneEndOrigin[1][0]) ? g_zoneEndOrigin[0][0] : g_zoneEndOrigin[1][0]
	start[1][1] = (g_zoneEndOrigin[0][1] < g_zoneEndOrigin[1][1]) ? g_zoneEndOrigin[0][1] : g_zoneEndOrigin[1][1]
	start[1][2] = (g_zoneEndOrigin[0][2] < g_zoneEndOrigin[1][2]) ? g_zoneEndOrigin[0][2] : g_zoneEndOrigin[1][2]
	start[1][2] += 3.0
	end[1][0] = (g_zoneEndOrigin[0][0] > g_zoneEndOrigin[1][0]) ? g_zoneEndOrigin[0][0] : g_zoneEndOrigin[1][0]
	end[1][1] = (g_zoneEndOrigin[0][1] > g_zoneEndOrigin[1][1]) ? g_zoneEndOrigin[0][1] : g_zoneEndOrigin[1][1]
	end[1][2] = (g_zoneEndOrigin[0][2] > g_zoneEndOrigin[1][2]) ? g_zoneEndOrigin[0][2] : g_zoneEndOrigin[1][2]
	end[1][2] += 3.0
	int zones = 1
	if(g_cpCount)
	{
		zones += g_cpCount
		for(int i = 2; i <= zones; i++)
		{
			int cpnum = i - 1
			start[i][0] = (g_cpPos[0][cpnum][0] < g_cpPos[1][cpnum][0]) ? g_cpPos[0][cpnum][0] : g_cpPos[1][cpnum][0]
			start[i][1] = (g_cpPos[0][cpnum][1] < g_cpPos[1][cpnum][1]) ? g_cpPos[0][cpnum][1] : g_cpPos[1][cpnum][1]
			start[i][2] = (g_cpPos[0][cpnum][2] < g_cpPos[1][cpnum][2]) ? g_cpPos[0][cpnum][2] : g_cpPos[1][cpnum][2]
			start[i][2] += 3.0
			end[i][0] = (g_cpPos[0][cpnum][0] > g_cpPos[1][cpnum][0]) ? g_cpPos[0][cpnum][0] : g_cpPos[1][cpnum][0]
			end[i][1] = (g_cpPos[0][cpnum][1] > g_cpPos[1][cpnum][1]) ? g_cpPos[0][cpnum][1] : g_cpPos[1][cpnum][1]
			end[i][2] = (g_cpPos[0][cpnum][2] > g_cpPos[1][cpnum][2]) ? g_cpPos[0][cpnum][2] : g_cpPos[1][cpnum][2]
			end[i][2] += 3.0
		}
	}
	float corners[12][8][3] //https://github.com/tengulawl/scripting/blob/master/include/tengu_stocks.inc
	for(int i = 0; i <= zones; i++)
	{
		//bottom left front
		corners[i][0][0] = start[i][0]
		corners[i][0][1] = start[i][1]
		corners[i][0][2] = start[i][2]
		//bottom right front
		corners[i][1][0] = end[i][0]
		corners[i][1][1] = start[i][1]
		corners[i][1][2] = start[i][2]
		//bottom right back
		corners[i][2][0] = end[i][0]
		corners[i][2][1] = end[i][1]
		corners[i][2][2] = start[i][2]
		//bottom left back
		corners[i][3][0] = start[i][0]
		corners[i][3][1] = end[i][1]
		corners[i][3][2] = start[i][2]
		int modelType
		if(i == 1)
			modelType = 1
		else if(i > 1)
			modelType = 2
		for(int j = 0; j <= 3; j++)
		{
			int k = j + 1
			if(j == 3)
				k = 0
			TE_SetupBeamPoints(corners[i][j], corners[i][k], g_zoneModel[modelType], 0, 0, 0, life, 3.0, 3.0, 0, 0.0, {0, 0, 0, 0}, 10) //https://github.com/shavitush/bhoptimer/blob/master/addons/sourcemod/scripting/shavit-zones.sp#L3050
			TE_SendToClient(client)
		}
	}
}

void ResetFactory(int client)
{
	//g_timerTime[client] = 0.0
	g_state[client] = false
}

public Action OnPlayerRunCmd(int client, int& buttons, int& impulse, float vel[3], float angles[3], int& weapon, int& subtype, int& cmdnum, int& tickcount, int& seed, int mouse[2])
{
	if(!IsFakeClient(client))
	{
		if(buttons & IN_JUMP && IsPlayerAlive(client) && !(GetEntityFlags(client) & FL_ONGROUND) && GetEntProp(client, Prop_Data, "m_nWaterLevel") <= 1 && !(GetEntityMoveType(client) & MOVETYPE_LADDER)) //https://sm.alliedmods.net/new-api/entity_prop_stocks/GetEntityFlags https://forums.alliedmods.net/showthread.php?t=127948
			buttons &= ~IN_JUMP //https://stackoverflow.com/questions/47981/how-do-you-set-clear-and-toggle-a-single-bit https://forums.alliedmods.net/showthread.php?t=192163
		//Timer
		if(g_state[client])
		{
			g_timerTime[client] = GetEngineTime() - g_timerTimeStart[client]
			//https://forums.alliedmods.net/archive/index.php/t-23912.html ShAyA format OneEyed format second
			int hour = (RoundToFloor(g_timerTime[client]) / 3600) % 24 //https://forums.alliedmods.net/archive/index.php/t-187536.html
			int minute = (RoundToFloor(g_timerTime[client]) / 60) % 60
			int second = RoundToFloor(g_timerTime[client]) % 60
			Format(g_clantag[client][1], 256, "%02.i:%02.i:%02.i", hour, minute, second)
			if(!IsPlayerAlive(client))
				ResetFactory(client)
		}
		if(g_zoneDraw[client])
		{
			if(GetEngineTime() - g_engineTime >= 0.1)
			{
				g_engineTime = GetEngineTime()
				for(int i = 1; i <= MaxClients; i++)
					if(IsClientInGame(i))
						DrawZone(i, 0.1)
			}
		}
		if(GetEngineTime() - g_hudTime[client] >= 0.1)
		{
			g_hudTime[client] = GetEngineTime()
			Hud(client)
		}
		if(GetEntityFlags(client) & FL_ONGROUND && g_velJump[client])
			g_velJump[client] = 0.0
	}
}

Action cmd_devmap(int client, int args)
{
	if(GetEngineTime() - g_devmapTime > 35.0 && GetEngineTime() - g_afkTime > 30.0)
	{
		g_voters = 0
		for(int i = 1; i <= MaxClients; i++)
		{
			if(IsClientInGame(i) && !IsClientSourceTV(i) && !IsFakeClient(i))
			{
				g_voters++
				if(g_devmap)
				{
					Menu menu = new Menu(devmap_handler)
					menu.SetTitle("Turn off dev map?")
					menu.AddItem("yes", "Yes")
					menu.AddItem("no", "No")
					menu.Display(i, 20)
				}
				else
				{
					Menu menu = new Menu(devmap_handler)
					menu.SetTitle("Turn on dev map?")
					menu.AddItem("yes", "Yes")
					menu.AddItem("no", "No")
					menu.Display(i, 20)
				}
			}
		}
		g_devmapTime = GetEngineTime()
		CreateTimer(20.0, timer_devmap, TIMER_FLAG_NO_MAPCHANGE)
		PrintToChatAll("Devmap vote started by %N", client)
	}
	else if(GetEngineTime() - g_devmapTime <= 35.0 || GetEngineTime() - g_afkTime <= 30.0)
		PrintToChat(client, "Devmap vote is not allowed yet.")
	return Plugin_Handled
}

int devmap_handler(Menu menu, MenuAction action, int param1, int param2)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			switch(param2)
			{
				case 0:
				{
					g_devmapCount[1]++
					g_voters--
					Devmap()
				}
				case 1:
				{
					g_devmapCount[0]++
					g_voters--
					Devmap()
				}
			}
		}
	}
}

Action timer_devmap(Handle timer)
{
	//devmap idea by expert zone. thanks to ed and maru. thanks to lon to give tp idea for server i could made it like that "profesional style".
	Devmap(true)
}

void Devmap(bool force = false)
{
	if(force || !g_voters)
	{
		if((g_devmapCount[1] || g_devmapCount[0]) && g_devmapCount[1] >= g_devmapCount[0])
		{
			if(g_devmap)
				PrintToChatAll("Devmap will be disabled. \"Yes\" %i%%% or %i of %i players.", (g_devmapCount[1] / (g_devmapCount[0] + g_devmapCount[1])) * 100, g_devmapCount[1], g_devmapCount[0] + g_devmapCount[1])
			else
				PrintToChatAll("Devmap will be enabled. \"Yes\" %i%%% or %i of %i players.", (g_devmapCount[1] / (g_devmapCount[0] + g_devmapCount[1])) * 100, g_devmapCount[1], g_devmapCount[0] + g_devmapCount[1])
			CreateTimer(5.0, timer_changelevel, g_devmap ? false : true)
		}
		else if((g_devmapCount[1] || g_devmapCount[0]) && g_devmapCount[1] <= g_devmapCount[0])
		{
			if(g_devmap)
				PrintToChatAll("Devmap will be continue. \"No\" chose %i%%% or %i of %i players.", (g_devmapCount[0] / (g_devmapCount[0] + g_devmapCount[1])) * 100, g_devmapCount[0], g_devmapCount[0] + g_devmapCount[1]) //google translate russian to english.
			else
				PrintToChatAll("Devmap will not be enabled. \"No\" chose %i%%% or %i of %i players.", (g_devmapCount[0] / (g_devmapCount[0] + g_devmapCount[1])) * 100, g_devmapCount[0], g_devmapCount[0] + g_devmapCount[1])
		}
		for(int i = 0; i <= 1; i++)
			g_devmapCount[i] = 0
	}
}

Action timer_changelevel(Handle timer, bool value)
{
	g_devmap = value
	ForceChangeLevel(g_map, "Reason: Devmap")
}

Action cmd_top(int client, int args)
{
	CreateTimer(0.1, timer_motd, client, TIMER_FLAG_NO_MAPCHANGE) //OnMapStart() is not work from first try.
	return Plugin_Handled
}

Action timer_motd(Handle timer, int client)
{
	if(IsClientInGame(client))
	{
		ConVar hostname = FindConVar("hostname")
		char hostnameBuffer[256]
		hostname.GetString(hostnameBuffer, 256)
		char url[192]
		g_urlTop.GetString(url, 192)
		Format(url, 256, "%s%s", url, g_map)
		ShowMOTDPanel(client, hostnameBuffer, url, MOTDPANEL_TYPE_URL) //https://forums.alliedmods.net/showthread.php?t=232476
	}
}

Action cmd_afk(int client, int args)
{
	if(GetEngineTime() - g_afkTime > 30.0 && GetEngineTime() - g_devmapTime > 35.0)
	{
		g_voters = 0
		g_afkClient = client
		for(int i = 1; i <= MaxClients; i++)
		{
			if(IsClientInGame(i) && !IsClientSourceTV(i) && !IsFakeClient(i) && !IsPlayerAlive(i) && client != i)
			{
				g_afk[i] = false
				g_voters++
				Menu menu = new Menu(afk_handler)
				menu.SetTitle("Are you here?")
				menu.AddItem("yes", "Yes")
				menu.AddItem("no", "No")
				menu.Display(i, 20)
			}
		}
		g_afkTime = GetEngineTime()
		CreateTimer(20.0, timer_afk, client, TIMER_FLAG_NO_MAPCHANGE)
		PrintToChatAll("Afk check - vote started by %N", client)
	}
	else if(GetEngineTime() - g_afkTime <= 30.0 || GetEngineTime() - g_devmapTime <= 35.0)
		PrintToChat(client, "Afk vote is not allowed yet.")
	return Plugin_Handled
}

int afk_handler(Menu menu, MenuAction action, int param1, int param2)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			switch(param2)
			{
				case 0:
				{
					g_afk[param1] = true
					g_voters--
					AFK(g_afkClient)
				}
				case 1:
				{
					g_voters--
					AFK(g_afkClient)
				}
			}
		}
	}
}

Action timer_afk(Handle timer, int client)
{
	//afk idea by expert zone. thanks to ed and maru. thanks to lon to give tp idea for server i could made it like that "profesional style".
	AFK(client, true)
}

void AFK(int client, bool force = false)
{
	if(force || !g_voters)
		for(int i = 1; i <= MaxClients; i++)
			if(IsClientInGame(i) && !IsPlayerAlive(i) && !IsClientSourceTV(i) && !g_afk[i] && client != i)
				KickClient(i, "Away from keyboard")
}

Action cmd_noclip(int client, int args)
{
	Noclip(client)
	return Plugin_Handled
}

void Noclip(int client)
{
	if(g_devmap)
	{
		SetEntityMoveType(client, GetEntityMoveType(client) & MOVETYPE_NOCLIP ? MOVETYPE_WALK : MOVETYPE_NOCLIP)
		PrintToChat(client, GetEntityMoveType(client) & MOVETYPE_NOCLIP ? "Noclip enabled." : "Noclip disabled.")
	}
	else
		PrintToChat(client, "Turn on devmap.")
}

Action cmd_spec(int client, int args)
{
	ChangeClientTeam(client, CS_TEAM_SPECTATOR)
	return Plugin_Handled
}

Action cmd_hud(int client, int args)
{
	Menu menu = new Menu(hud_handler, MenuAction_Start | MenuAction_Select | MenuAction_Display | MenuAction_Cancel)
	menu.SetTitle("Hud")
	menu.AddItem("vel", g_hudVel[client] ? "Velocity [v]" : "Velocity [x]")
	menu.Display(client, 20)
	return Plugin_Handled
}

int hud_handler(Menu menu, MenuAction action, int param1, int param2)
{
	switch(action)
	{
		case MenuAction_Start: //expert-zone idea. thank to ed, maru.
			g_menuOpened[param1] = true
		case MenuAction_Select:
		{
			char value[16]
			switch(param2)
			{
				case 0:
				{
					g_hudVel[param1] = !g_hudVel[param1]
					IntToString(g_hudVel[param1], value, 16)
					SetClientCookie(param1, g_cookie, value)
				}
			}
			cmd_hud(param1, 0)
		}
		case MenuAction_Cancel:
			g_menuOpened[param1] = false //idea from expert zone.
		case MenuAction_Display:
			g_menuOpened[param1] = true
	}
}

void Hud(int client)
{
	float vel[3]
	GetEntPropVector(client, Prop_Data, "m_vecAbsVelocity", vel)
	float velXY = SquareRoot(Pow(vel[0], 2.0) + Pow(vel[1], 2.0))
	if(g_hudVel[client])
		PrintHintText(client, "%.0f", velXY)
	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i) && !IsPlayerAlive(i))
		{
			int observerTarget = GetEntPropEnt(i, Prop_Data, "m_hObserverTarget")
			int observerMode = GetEntProp(i, Prop_Data, "m_iObserverMode")
			if(observerMode < 7 && observerTarget == client && g_hudVel[i])
				PrintHintText(i, "%.0f", velXY)
		}
	}
}

public Action OnClientSayCommand(int client, const char[] command, const char[] sArgs)
{
	if(!IsChatTrigger())
	{
		if(StrEqual(sArgs, "bh") || StrEqual(sArgs, "bhop"))
			Bhop(client)
		else if(StrEqual(sArgs, "r") || StrEqual(sArgs, "restart"))
			Restart(client)
		else if(StrEqual(sArgs, "devmap"))
			cmd_devmap(client, 0)
		else if(StrEqual(sArgs, "top"))
			cmd_top(client, 0)
		else if(StrEqual(sArgs, "cp"))
			Checkpoint(client)
		else if(StrEqual(sArgs, "afk"))
			cmd_afk(client, 0)
		else if(StrEqual(sArgs, "nc") || StrEqual(sArgs, "noclip"))
			Noclip(client)
		else if(StrEqual(sArgs, "sp") || StrEqual(sArgs, "spec"))
			cmd_spec(client, 0)
		else if(StrEqual(sArgs, "hud"))
			cmd_hud(client, 0)
	}
}

Action SDKOnTakeDamage(int victim, int& attacker, int& inflictor, float& damage, int& damagetype)
{
	SetEntPropVector(victim, Prop_Send, "m_vecPunchAngle", NULL_VECTOR) //https://forums.alliedmods.net/showthread.php?p=1687371
	SetEntPropVector(victim, Prop_Send, "m_vecPunchAngleVel", NULL_VECTOR)
	return Plugin_Handled //full god-mode
}

Action SDKWeaponDrop(int client, int weapon)
{
	if(IsValidEntity(weapon))
		RemoveEntity(weapon)
}

Action timer_clantag(Handle timer, int client)
{
	if(0 < client <= MaxClients && IsClientInGame(client))
	{
		if(g_state[client])
		{
			CS_SetClientClanTag(client, g_clantag[client][1])
			return Plugin_Continue
		}
		else
			CS_SetClientClanTag(client, g_clantag[client][0])
	}
	return Plugin_Stop
}

int Native_GetTimerState(Handle plugin, int numParams)
{
	int client = GetNativeCell(1)
	if(!IsFakeClient(client))
		return g_state[client]
	else
		return false
}

Action timer_clearlag(Handle timer)
{
	ServerCommand("mat_texture_list_txlod_sync reset")
}

Action TransmitPlayer(int entity, int client) //entity - me, client - loop all clients
{
	//hide all players
	if(client != entity && 0 < entity <= MaxClients && IsPlayerAlive(client))
		return Plugin_Handled
	return Plugin_Continue
}
