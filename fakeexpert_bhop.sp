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

//int gI_partner[MAXPLAYERS + 1]
float gF_originStartZone[2][3]
float gF_originEndZone[2][3]
Database gD_mysql
float gF_TimeStart[MAXPLAYERS + 1]
float gF_Time[MAXPLAYERS + 1]
bool gB_state[MAXPLAYERS + 1]
char gS_map[192]
//bool gB_mapFinished[MAXPLAYERS + 1]
bool gB_passDB
float gF_originStart[3]
//float gF_boostTime[MAXPLAYERS + 1]
//float gF_skyVel[MAXPLAYERS + 1][3]
bool gB_readyToStart[MAXPLAYERS + 1]

float gF_originCP[2][11][3]
bool gB_cp[11][MAXPLAYERS + 1]
bool gB_cpLock[11][MAXPLAYERS + 1]
float gF_TimeCP[11][MAXPLAYERS + 1]
float gF_timeDiffCP[11][MAXPLAYERS + 1]
float gF_srCPTime[11]

float gF_haveRecord[MAXPLAYERS + 1]
float gF_ServerRecord

ConVar gCV_steamid //https://wiki.alliedmods.net/ConVars_(SourceMod_Scripting)
ConVar gCV_topURL

bool gB_MenuIsOpen[MAXPLAYERS + 1]

//int gI_boost[MAXPLAYERS + 1]
//int gI_skyBoost[MAXPLAYERS + 1]
//bool gB_bouncedOff[2048 + 1]
//bool gB_groundBoost[MAXPLAYERS + 1]
//int gI_flash[MAXPLAYERS + 1]
//int gI_entityFlags[MAXPLAYERS + 1]
float gF_devmap[2]
bool gB_isDevmap
float gF_devmapTime

float gF_origin[MAXPLAYERS + 1][2][3]
float gF_eyeAngles[MAXPLAYERS + 1][2][3]
float gF_velocity[MAXPLAYERS + 1][2][3]
bool gB_toggledCheckpoint[MAXPLAYERS + 1][2]

bool gB_haveZone[3]

bool gB_isServerRecord
char gS_date[64]
char gS_time[64]

//bool gB_silentKnife
//float gF_mateRecord[MAXPLAYERS + 1]
bool gB_isTurnedOnSourceTV
//bool gB_block[MAXPLAYERS + 1]
//int gI_wModelThrown
//int gI_class[MAXPLAYERS + 1]
//bool gB_color[MAXPLAYERS + 1]
//int gI_wModelPlayer[5]
//int gI_wModelPlayerDef[5]
//int gI_pingModel[MAXPLAYERS + 1]
//int gI_pingModelOwner[2048 + 1]
//Handle gH_timerPing[MAXPLAYERS + 1]

bool gB_zoneFirst[3]

//char gS_color[][] = {"255,255,255", "255,0,0", "255,165,0", "255,255,0", "0,255,0", "0,255,255", "0,191,255", "0,0,255", "255,0,255"} //white, red, orange, yellow, lime, aqua, deep sky blue, blue, magenta //https://flaviocopes.com/rgb-color-codes/#:~:text=A%20table%20summarizing%20the%20RGB%20color%20codes%2C%20which,%20%20%28178%2C34%2C34%29%20%2053%20more%20rows%20
//int gI_color[MAXPLAYERS + 1][3]
//int gI_colorCount[MAXPLAYERS + 1]

int gI_zoneModel[3]
//int gI_laserBeam
bool gB_isSourceTVchangedFileName = true
//float gF_velEntity[MAXPLAYERS + 1][3]
//float gF_velClient[MAXPLAYERS + 1][3]
int gI_cpCount
//ConVar gCV_turboPhysics
float gF_afkTime
bool gB_afk[MAXPLAYERS + 1]
float gF_center[12][3]
bool gB_DrawZone[MAXPLAYERS + 1]
float gF_engineTime
//float gF_pingTime[MAXPLAYERS + 1]
//bool gB_pingLock[MAXPLAYERS + 1]
bool gB_msg[MAXPLAYERS + 1]
int gI_voters
int gI_afkClient
bool gB_hudVel[MAXPLAYERS + 1]
float gF_hudTime[MAXPLAYERS + 1]
char gS_clanTag[MAXPLAYERS + 1][2][256]
Handle gH_timerClanTag[MAXPLAYERS + 1]
//float gF_mlsVel[MAXPLAYERS + 1][2][2]
//int gI_mlsCount[MAXPLAYERS + 1]
//char gS_mlsPrint[MAXPLAYERS + 1][100][256]
//int gI_mlsBooster[MAXPLAYERS + 1]
//bool gB_mlstats[MAXPLAYERS + 1]
//float gF_mlsDistance[MAXPLAYERS + 1][2][3]
//bool gB_button[MAXPLAYERS + 1]
//bool gB_pbutton[MAXPLAYERS + 1]
//float gF_skyOrigin[MAXPLAYERS + 1][3]
//int gI_entityButtons[MAXPLAYERS + 1]
//bool gB_teleported[MAXPLAYERS + 1]
int gI_points[MAXPLAYERS + 1]
Handle gH_start
Handle gH_record
int gI_pointsMaxs = 1
int gI_lastQuery
Handle gH_cookie
//float gF_skyAble[MAXPLAYERS + 1]
//native bool Trikz_GetEntityFilter(int client, int entity)

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
	gCV_steamid = CreateConVar("steamid", "", "Set steamid for control the plugin ex. 120192594. Use status to check your uniqueid, without 'U:1:'.")
	gCV_topURL = CreateConVar("topurl", "", "Set url for top for ex (http://www.fakeexpert.rf.gd/?start=0&map=). To open page, type in game chat !top")
	AutoExecConfig(true) //https://sm.alliedmods.net/new-api/sourcemod/AutoExecConfig
	RegConsoleCmd("sm_bh", cmd_bhop)
	RegConsoleCmd("sm_bhop", cmd_bhop)
	//RegConsoleCmd("sm_bl", cmd_block)
	//RegConsoleCmd("sm_block", cmd_block)
	//RegConsoleCmd("sm_p", cmd_partner)
	//RegConsoleCmd("sm_partner", cmd_partner)
	//RegConsoleCmd("sm_c", cmd_color)
	//RegConsoleCmd("sm_color", cmd_color)
	RegConsoleCmd("sm_r", cmd_restart)
	RegConsoleCmd("sm_restart", cmd_restart)
	//RegConsoleCmd("sm_time", cmd_time)
	RegConsoleCmd("sm_cp", cmd_checkpoint)
	RegConsoleCmd("sm_devmap", cmd_devmap)
	RegConsoleCmd("sm_top", cmd_top)
	RegConsoleCmd("sm_afk", cmd_afk)
	RegConsoleCmd("sm_nc", cmd_noclip)
	RegConsoleCmd("sm_noclip", cmd_noclip)
	RegConsoleCmd("sm_sp", cmd_spec)
	RegConsoleCmd("sm_spec", cmd_spec)
	RegConsoleCmd("sm_hud", cmd_hud)
	//RegConsoleCmd("sm_mls", cmd_mlstats)
	//RegConsoleCmd("sm_button", cmd_button)
	//RegConsoleCmd("sm_pbutton", cmd_pbutton)
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
	//AddNormalSoundHook(SoundHook)
	HookUserMessage(GetUserMessageId("SayText2"), OnUserMessage, true) //thanks to VerMon idea. https://github.com/shavitush/bhoptimer/blob/master/addons/sourcemod/scripting/shavit-chat.sp#L416
	HookEvent("player_spawn", OnSpawn)
	//HookEntityOutput("func_button", "OnPressed", event_button)
	//HookEvent("player_jump", event_playerjump)
	HookEvent("player_death", OnDeath)
	/*char sOutputs[][] = {"OnStartTouch", "OnEndTouchAll", "OnTouching", "OnStartTouch", "OnTrigger"}
	for(int i = 0; i < sizeof(sOutputs); i++)
	{
		HookEntityOutput("trigger_teleport", sOutputs[i], output_teleport) //https://developer.valvesoftware.com/wiki/Trigger_teleport
		HookEntityOutput("trigger_teleport_relative", sOutputs[i], output_teleport) //https://developer.valvesoftware.com/wiki/Trigger_teleport_relative
	}*/
	LoadTranslations("test.phrases") //https://wiki.alliedmods.net/Translations_(SourceMod_Scripting)
	gH_start = CreateGlobalForward("Bhop_Start", ET_Hook, Param_Cell)
	gH_record = CreateGlobalForward("Bhop_Record", ET_Hook, Param_Cell, Param_Float)
	RegPluginLibrary("fakeexpert_bhop")
	gH_cookie = RegClientCookie("vel", "velocity in hint", CookieAccess_Protected)
	//gH_cookie[1] = RegClientCookie("mls", "mega long stats", CookieAccess_Protected)
	//gH_cookie[2] = RegClientCookie("button", "button", CookieAccess_Protected)
	//gH_cookie[3] = RegClientCookie("pbutton", "partner button", CookieAccess_Protected)
	CreateTimer(60.0, timer_clearlag)
}

public void OnMapStart()
{
	GetCurrentMap(gS_map, 192)
	Database.Connect(SQLConnect, "fakeexpert_bhop")
	for(int i = 0; i <= 2; i++)
	{
		gB_haveZone[i] = false
		if(gB_isDevmap)
			gB_zoneFirst[i] = false
	}
	ConVar CV_sourcetv = FindConVar("tv_enable")
	bool isSourceTV = CV_sourcetv.BoolValue //https://github.com/alliedmodders/sourcemod/blob/master/plugins/funvotes.sp#L280
	if(isSourceTV)
	{
		if(!gB_isSourceTVchangedFileName)
		{
			char sOldFileName[256]
			Format(sOldFileName, 256, "%s-%s-%s.dem", gS_date, gS_time, gS_map)
			char sNewFileName[256]
			Format(sNewFileName, 256, "%s-%s-%s-ServerRecord.dem", gS_date, gS_time, gS_map)
			RenameFile(sNewFileName, sOldFileName)
			gB_isSourceTVchangedFileName = true
		}
		if(!gB_isDevmap)
		{
			PrintToServer("SourceTV start recording.")
			FormatTime(gS_date, 64, "%Y-%m-%d", GetTime())
			FormatTime(gS_time, 64, "%H-%M-%S", GetTime())
			ServerCommand("tv_record %s-%s-%s", gS_date, gS_time, gS_map) //https://www.youtube.com/watch?v=GeGd4KOXNb8 https://forums.alliedmods.net/showthread.php?t=59474 https://www.php.net/strftime
		}
	}
	if(!gB_isTurnedOnSourceTV && !isSourceTV)
	{
		gB_isTurnedOnSourceTV = true
		ForceChangeLevel(gS_map, "Turn on SourceTV")
	}
	/*gI_wModelThrown = PrecacheModel("models/fakeexpert/models/weapons/w_eq_flashbang_thrown.mdl", true)
	gI_wModelPlayerDef[1] = PrecacheModel("models/player/ct_urban.mdl", true)
	gI_wModelPlayerDef[2] = PrecacheModel("models/player/ct_gsg9.mdl", true)
	gI_wModelPlayerDef[3] = PrecacheModel("models/player/ct_sas.mdl", true)
	gI_wModelPlayerDef[4] = PrecacheModel("models/player/ct_gign.mdl", true)
	gI_wModelPlayer[1] = PrecacheModel("models/fakeexpert/player/ct_urban.mdl", true)
	gI_wModelPlayer[2] = PrecacheModel("models/fakeexpert/player/ct_gsg9.mdl", true)
	gI_wModelPlayer[3] = PrecacheModel("models/fakeexpert/player/ct_sas.mdl", true)
	gI_wModelPlayer[4] = PrecacheModel("models/fakeexpert/player/ct_gign.mdl", true)
	PrecacheModel("models/fakeexpert/pingtool/pingtool.mdl", true)
	PrecacheSound("fakeexpert/pingtool/click.wav", true) //https://forums.alliedmods.net/showthread.php?t=333211*/
	gI_zoneModel[0] = PrecacheModel("materials/fakeexpert/zones/start.vmt", true)
	gI_zoneModel[1] = PrecacheModel("materials/fakeexpert/zones/finish.vmt", true)
	gI_zoneModel[2] = PrecacheModel("materials/fakeexpert/zones/check_point.vmt", true)
	/*gI_laserBeam = PrecacheModel("materials/sprites/laser.vmt", true)
	AddFileToDownloadsTable("models/fakeexpert/models/weapons/w_eq_flashbang_thrown.dx80.vtx")
	AddFileToDownloadsTable("models/fakeexpert/models/weapons/w_eq_flashbang_thrown.dx90.vtx")
	AddFileToDownloadsTable("models/fakeexpert/models/weapons/w_eq_flashbang_thrown.mdl")
	AddFileToDownloadsTable("models/fakeexpert/models/weapons/w_eq_flashbang_thrown.phy")
	AddFileToDownloadsTable("models/fakeexpert/models/weapons/w_eq_flashbang_thrown.sw.vtx")
	AddFileToDownloadsTable("models/fakeexpert/models/weapons/w_eq_flashbang_thrown.vvd")
	
	AddFileToDownloadsTable("models/fakeexpert/pingtool/pingtool.dx80.vtx")
	AddFileToDownloadsTable("models/fakeexpert/pingtool/pingtool.dx90.vtx")
	AddFileToDownloadsTable("models/fakeexpert/pingtool/pingtool.mdl")
	AddFileToDownloadsTable("models/fakeexpert/pingtool/pingtool.sw.vtx")
	AddFileToDownloadsTable("models/fakeexpert/pingtool/pingtool.vvd")
	
	AddFileToDownloadsTable("models/fakeexpert/player/ct_gign.dx80.vtx")
	AddFileToDownloadsTable("models/fakeexpert/player/ct_gign.dx90.vtx")
	AddFileToDownloadsTable("models/fakeexpert/player/ct_gign.mdl")
	AddFileToDownloadsTable("models/fakeexpert/player/ct_gign.phy")
	AddFileToDownloadsTable("models/fakeexpert/player/ct_gign.sw.vtx")
	AddFileToDownloadsTable("models/fakeexpert/player/ct_gign.vvd")
	AddFileToDownloadsTable("models/fakeexpert/player/ct_gsg9.dx90.vtx")
	AddFileToDownloadsTable("models/fakeexpert/player/ct_gsg9.dx90.vtx")
	AddFileToDownloadsTable("models/fakeexpert/player/ct_gsg9.mdl")
	AddFileToDownloadsTable("models/fakeexpert/player/ct_gsg9.phy")
	AddFileToDownloadsTable("models/fakeexpert/player/ct_gsg9.sw.vtx")
	AddFileToDownloadsTable("models/fakeexpert/player/ct_gsg9.vvd")
	AddFileToDownloadsTable("models/fakeexpert/player/ct_sas.dx80.vtx")
	AddFileToDownloadsTable("models/fakeexpert/player/ct_sas.dx90.vtx")
	AddFileToDownloadsTable("models/fakeexpert/player/ct_sas.mdl")
	AddFileToDownloadsTable("models/fakeexpert/player/ct_sas.phy")
	AddFileToDownloadsTable("models/fakeexpert/player/ct_sas.sw.vtx")
	AddFileToDownloadsTable("models/fakeexpert/player/ct_sas.vvd")
	AddFileToDownloadsTable("models/fakeexpert/player/ct_urban.dx80.vtx")
	AddFileToDownloadsTable("models/fakeexpert/player/ct_urban.dx90.vtx")
	AddFileToDownloadsTable("models/fakeexpert/player/ct_urban.mdl")
	AddFileToDownloadsTable("models/fakeexpert/player/ct_urban.phy")
	AddFileToDownloadsTable("models/fakeexpert/player/ct_urban.sw.vtx")
	AddFileToDownloadsTable("models/fakeexpert/player/ct_urban.vvd")
	
	AddFileToDownloadsTable("materials/fakeexpert/materials/models/weapons/w_models/w_eq_flashbang/noshadow.vmt")
	AddFileToDownloadsTable("materials/fakeexpert/materials/models/weapons/w_models/w_eq_flashbang/shadow.vmt")
	AddFileToDownloadsTable("materials/fakeexpert/materials/models/weapons/w_models/w_eq_flashbang/w_eq_flashbang.vmt")
	AddFileToDownloadsTable("materials/fakeexpert/materials/models/weapons/w_models/w_eq_flashbang/wireframe.vmt")
	
	AddFileToDownloadsTable("materials/fakeexpert/pingtool/circle_arrow.vmt")
	AddFileToDownloadsTable("materials/fakeexpert/pingtool/circle_arrow.vtf")
	AddFileToDownloadsTable("materials/fakeexpert/pingtool/circle_point.vmt")
	AddFileToDownloadsTable("materials/fakeexpert/pingtool/circle_point.vtf")
	AddFileToDownloadsTable("materials/fakeexpert/pingtool/grad.vmt")
	AddFileToDownloadsTable("materials/fakeexpert/pingtool/grad.vtf")
	AddFileToDownloadsTable("sound/fakeexpert/pingtool/click.wav")
	
	AddFileToDownloadsTable("materials/fakeexpert/player/ct_gign/skin1.vmt")
	AddFileToDownloadsTable("materials/fakeexpert/player/ct_gign/skin2.vmt")
	AddFileToDownloadsTable("materials/fakeexpert/player/ct_gign/unlit_base.vtf")
	AddFileToDownloadsTable("materials/fakeexpert/player/ct_gign/unlit_detail.vtf")
	AddFileToDownloadsTable("materials/fakeexpert/player/ct_gign/vertex.vtf")
	
	AddFileToDownloadsTable("materials/fakeexpert/player/ct_gsg9/skin1.vmt")
	AddFileToDownloadsTable("materials/fakeexpert/player/ct_gsg9/skin2.vmt")
	AddFileToDownloadsTable("materials/fakeexpert/player/ct_gsg9/unlit_base.vtf")
	AddFileToDownloadsTable("materials/fakeexpert/player/ct_gsg9/unlit_detail.vtf")
	AddFileToDownloadsTable("materials/fakeexpert/player/ct_gsg9/vertex.vtf")
	
	AddFileToDownloadsTable("materials/fakeexpert/player/ct_sas/skin1.vmt")
	AddFileToDownloadsTable("materials/fakeexpert/player/ct_sas/skin2.vmt")
	AddFileToDownloadsTable("materials/fakeexpert/player/ct_sas/unlit_base.vtf")
	AddFileToDownloadsTable("materials/fakeexpert/player/ct_sas/unlit_detail.vtf")
	AddFileToDownloadsTable("materials/fakeexpert/player/ct_sas/vertex.vtf")
	
	AddFileToDownloadsTable("materials/fakeexpert/player/ct_urban/skin1.vmt")
	AddFileToDownloadsTable("materials/fakeexpert/player/ct_urban/skin2.vmt")
	AddFileToDownloadsTable("materials/fakeexpert/player/ct_urban/unlit_base.vtf")
	AddFileToDownloadsTable("materials/fakeexpert/player/ct_urban/unlit_detail.vtf")
	AddFileToDownloadsTable("materials/fakeexpert/player/ct_urban/vertex.vtf")
	
	AddFileToDownloadsTable("materials/fakeexpert/player/unlit_default.vmt")
	AddFileToDownloadsTable("materials/fakeexpert/player/vertex_default.vmt")*/
	
	AddFileToDownloadsTable("materials/fakeexpert/zones/start.vmt")
	AddFileToDownloadsTable("materials/fakeexpert/zones/start.vtf")
	AddFileToDownloadsTable("materials/fakeexpert/zones/finish.vmt")
	AddFileToDownloadsTable("materials/fakeexpert/zones/finish.vtf")
	AddFileToDownloadsTable("materials/fakeexpert/zones/check_point.vmt")
	AddFileToDownloadsTable("materials/fakeexpert/zones/check_point.vtf")
	
	//gCV_turboPhysics = FindConVar("sv_turbophysics") //thnaks to maru.
	
	RecalculatePoints()
}

void RecalculatePoints()
{
	if(gB_passDB)
		gD_mysql.Query(SQLRecalculatePoints_GetMap, "SELECT map FROM tier")
}

void SQLRecalculatePoints_GetMap(Database db, DBResultSet results, const char[] error, any data)
{
	while(results.FetchRow())
	{
		char sMap[192]
		results.FetchString(0, sMap, 192)
		char sQuery[512]
		Format(sQuery, 512, "SELECT (SELECT COUNT(*) FROM records WHERE map = '%s'), (SELECT tier FROM tier WHERE map = '%s'), id FROM records WHERE map = '%s' ORDER BY time", sMap, sMap, sMap) //https://stackoverflow.com/questions/38104018/select-and-count-rows-in-the-same-query
		gD_mysql.Query(SQLRecalculatePoints, sQuery)
	}
}

void SQLRecalculatePoints(Database db, DBResultSet results, const char[] error, any data)
{
	char sQuery[512]
	int place
	while(results.FetchRow())
	{
		int points = results.FetchInt(1) * results.FetchInt(0) / ++place //thanks to DeadSurfer
		Format(sQuery, 512, "UPDATE records SET points = %i WHERE id = %i LIMIT 1", points, results.FetchInt(2))
		gI_lastQuery++
		gD_mysql.Query(SQLRecalculatePoints2, sQuery)
	}
}

void SQLRecalculatePoints2(Database db, DBResultSet results, const char[] error, any data)
{
	if(gI_lastQuery-- && !gI_lastQuery)
		gD_mysql.Query(SQLRecalculatePoints3, "SELECT steamid FROM users")
}

void SQLRecalculatePoints3(Database db, DBResultSet results, const char[] error, any data)
{
	while(results.FetchRow())
	{
		char sQuery[512]
		Format(sQuery, 512, "SELECT MAX(points) FROM records WHERE playerid = %i GROUP BY map", results.FetchInt(0))
		gD_mysql.Query(SQLRecalculateUserPoints, sQuery, results.FetchInt(0))
	}
}

void SQLRecalculateUserPoints(Database db, DBResultSet results, const char[] error, any data)
{
	int points
	while(results.FetchRow())
		points += results.FetchInt(0)
	char sQuery[512]
	Format(sQuery, 512, "UPDATE users SET points = %i WHERE steamid = %i LIMIT 1", points, data)
	gI_lastQuery++
	gD_mysql.Query(SQLUpdateUserPoints, sQuery)
}

void SQLUpdateUserPoints(Database db, DBResultSet results, const char[] error, any data)
{
	if(results.HasResults == false)
		if(gI_lastQuery-- && !gI_lastQuery)
			gD_mysql.Query(SQLGetPointsMaxs, "SELECT points FROM users ORDER BY points DESC LIMIT 1")
}

void SQLGetPointsMaxs(Database db, DBResultSet results, const char[] error, any data)
{
	if(results.FetchRow())
		gI_pointsMaxs = results.FetchInt(0)
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	//CreateNative("Trikz_GetClientButtons", Native_GetClientButtons)
	//CreateNative("Trikz_GetClientPartner", Native_GetClientPartner)
	CreateNative("Trikz_GetTimerState", Native_GetTimerState)
	MarkNativeAsOptional("Trikz_GetEntityFilter")
	return APLRes_Success
}

public void OnMapEnd()
{
	ConVar CV_sourcetv = FindConVar("tv_enable")
	bool isSourceTV = CV_sourcetv.BoolValue
	if(isSourceTV)
	{
		ServerCommand("tv_stoprecord")
		char sOldFileName[256]
		Format(sOldFileName, 256, "%s-%s-%s.dem", gS_date, gS_time, gS_map)
		if(gB_isServerRecord)
		{
			char sNewFileName[256]
			Format(sNewFileName, 256, "%s-%s-%s-ServerRecord.dem", gS_date, gS_time, gS_map)
			RenameFile(sNewFileName, sOldFileName)
			gB_isServerRecord = false
		}
		else
			DeleteFile(sOldFileName)
	}
}

Action OnUserMessage(UserMsg msg_id, BfRead msg, const int[] players, int playersNum, bool reliable, bool init)
{
	int client = msg.ReadByte()
	msg.ReadByte()
	char sMsg[32]
	msg.ReadString(sMsg, 32)
	char sName[MAX_NAME_LENGTH]
	msg.ReadString(sName, MAX_NAME_LENGTH)
	char sText[256]
	msg.ReadString(sText, 256)
	if(!gB_msg[client])
		return Plugin_Handled
	gB_msg[client] = false
	char sMsgFormated[32]
	Format(sMsgFormated, 32, "%s", sMsg)
	char sPoints[32]
	//https://www.skillsyouneed.com/num/percent-change.html
	/*int increase = RoundToFloor((float(gI_points[client]) - float(gI_pointsMaxs)) / float(gI_pointsMaxs) * 255.0)
	if(!increase)
		increase = 255
	else if(increase < 0)
		increase = 255 - (increase * -1)
	int decrease = RoundToFloor((float(gI_pointsMaxs) - float(gI_points[client])) / float(gI_pointsMaxs) * 255.0)
	int color
	color |= increase << 24 //5 red
	color |= decrease << 16 // 200 green
	color |= 0 << 8 // 255 blue
	color |= 255 << 0 // 50 alpha
	if(gI_points[client] < 1000)
		Format(sPoints, 32, "\x08%08X%i\x01", color, gI_points[client])
	else if(gI_points[client] > 999)
		Format(sPoints, 32, "\x08%08X%.0fK\x01", color, float(gI_points[client]) / 1000.0)
	else if(gI_points[client] > 999999)
		Format(sPoints, 32, "\x08%08X%.0fM\x01", color, float(gI_points[client]) / 1000000.0)*/
	int precentage = RoundToFloor(float(gI_points[client]) / float(gI_pointsMaxs) * 100.0)
	char sColor[8]
	if(precentage >= 90)
		Format(sColor, 8, "FF8000")
	else if(precentage >= 70)
		Format(sColor, 8, "A335EE")
	else if(precentage >= 55)
		Format(sColor, 8, "0070DD")
	else if(precentage >= 40)
		Format(sColor, 8, "1EFF00")
	else if(precentage >= 15)
		Format(sColor, 8, "FFFFFF")
	else if(precentage >= 0)
		Format(sColor, 8, "9D9D9D") //https://wowpedia.fandom.com/wiki/Quality
	if(gI_points[client] < 1000)
		Format(sPoints, 32, "\x07%s%i\x01", sColor, gI_points[client])
	else if(gI_points[client] > 999)
		Format(sPoints, 32, "\x07%s%.0fK\x01", sColor, float(gI_points[client]) / 1000.0)
	else if(gI_points[client] > 999999)
		Format(sPoints, 32, "\x07%s%.0fM\x01", sColor, float(gI_points[client]) / 1000000.0)
	if(StrEqual(sMsg, "Cstrike_Chat_AllSpec"))
		Format(sText, 256, "\x01*SPEC* [%s] \x07CCCCCC%s \x01:  %s", sPoints, sName, sText) //https://github.com/DoctorMcKay/sourcemod-plugins/blob/master/scripting/include/morecolors.inc#L566
	else if(StrEqual(sMsg, "Cstrike_Chat_Spec"))
		Format(sText, 256, "\x01(Spectator) [%s] \x07CCCCCC%s \x01:  %s", sPoints, sName, sText)
	else if(StrEqual(sMsg, "Cstrike_Chat_All"))
	{
		if(GetClientTeam(client) == 2)
			Format(sText, 256, "\x01[%s] \x07FF4040%s \x01:  %s", sPoints, sName, sText) //https://github.com/DoctorMcKay/sourcemod-plugins/blob/master/scripting/include/morecolors.inc#L638
		else if(GetClientTeam(client) == 3)
			Format(sText, 256, "\x01[%s] \x0799CCFF%s \x01:  %s", sPoints, sName, sText) //https://github.com/DoctorMcKay/sourcemod-plugins/blob/master/scripting/include/morecolors.inc#L513
	}
	else if(StrEqual(sMsg, "Cstrike_Chat_AllDead"))
	{
		if(GetClientTeam(client) == 2)
			Format(sText, 256, "\x01*DEAD* [%s] \x07FF4040%s \x01:  %s", sPoints, sName, sText)
		else if(GetClientTeam(client) == 3)
			Format(sText, 256, "\x01*DEAD* [%s] \x0799CCFF%s \x01:  %s", sPoints, sName, sText)
	}
	else if(StrEqual(sMsg, "Cstrike_Chat_CT"))
		Format(sText, 256, "\x01(Counter-Terrorist) [%s] \x0799CCFF%s \x01:  %s", sPoints, sName, sText)
	else if(StrEqual(sMsg, "Cstrike_Chat_CT_Dead"))
		Format(sText, 256, "\x01*DEAD*(Counter-Terrorist) [%s] \x0799CCFF%s \x01:  %s", sPoints, sName, sText)
	else if(StrEqual(sMsg, "Cstrike_Chat_T"))
		Format(sText, 256, "\x01(Terrorist) [%s] \x07FF4040%s \x01:  %s", sPoints, sName, sText) //https://forums.alliedmods.net/showthread.php?t=185016
	else if(StrEqual(sMsg, "Cstrike_Chat_T_Dead"))
		Format(sText, 256, "\x01*DEAD*(Terrorist) [%s] \x07FF4040%s \x01:  %s", sPoints, sName, sText)
	DataPack dp = new DataPack()
	dp.WriteCell(GetClientSerial(client))
	dp.WriteCell(StrContains(sMsg, "_All") != -1)
	dp.WriteString(sText)
	RequestFrame(frame_SayText2, dp)
	return Plugin_Handled
}

void frame_SayText2(DataPack dp)
{
	dp.Reset()
	int client = GetClientFromSerial(dp.ReadCell())
	bool allchat = dp.ReadCell()
	char sText[256]
	dp.ReadString(sText, 256)
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
		bfmsg.WriteString(sText)
		EndMessage()
		gB_msg[client] = true
	}
}

Action OnSpawn(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"))
	/*char sModel[PLATFORM_MAX_PATH]
	GetClientModel(client, sModel, PLATFORM_MAX_PATH)
	if(StrEqual(sModel, "models/player/ct_urban.mdl"))
		gI_class[client] = 1
	else if(StrEqual(sModel, "models/player/ct_gsg9.mdl"))
		gI_class[client] = 2
	else if(StrEqual(sModel, "models/player/ct_sas.mdl"))
		gI_class[client] = 3
	else if(StrEqual(sModel, "models/player/ct_gign.mdl"))
		gI_class[client] = 4
	if(gB_color[client])
	{
		SetEntProp(client, Prop_Data, "m_nModelIndex", gI_wModelPlayer[gI_class[client]])
		DispatchKeyValue(client, "skin", "2")
		SetEntityRenderColor(client, gI_color[client][0], gI_color[client][1], gI_color[client][2], 255)
	}
	else
		SetEntityRenderColor(client, 255, 255, 255, 255)
	SetEntityRenderMode(client, RENDER_TRANSALPHA) //maru is genius person who fix this bug. thanks maru for idea.*/
	if(GetClientTeam(client) == CS_TEAM_T || GetClientTeam(client) == CS_TEAM_CT)
		SetEntProp(client, Prop_Data, "m_CollisionGroup", 2)
	if(!gB_isDevmap)
		CS_GetClientClanTag(client, gS_clanTag[client][0], 256)
}

/*void event_button(const char[] output, int caller, int activator, float delay)
{
	if(0 < activator <= MaxClients && IsClientInGame(activator) && GetClientButtons(activator) & IN_USE)
	{
		if(gB_button[activator])
			PrintToChat(activator, "You have pressed a button.")
		if(gB_pbutton[gI_partner[activator]])
			PrintToChat(gI_partner[activator], "Your partner have pressed a button.")
	}
}

Action event_playerjump(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"))
	GetClientAbsOrigin(client, gF_skyOrigin[client])
	gF_skyAble[client] = GetGameTime()
}*/

Action OnDeath(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"))
	int ragdoll = GetEntPropEnt(client, Prop_Send, "m_hRagdoll")
	RemoveEntity(ragdoll)
}

/*void output_teleport(const char[] output, int caller, int activator, float delay)
{
	if(0 < activator <= MaxClients)
		gB_teleported[activator] = true
}*/

Action cmd_checkpoint(int client, int args)
{
	Checkpoint(client)
	return Plugin_Handled
}

void Checkpoint(int client)
{
	if(gB_isDevmap)
	{
		Menu menu = new Menu(checkpoint_handler)
		menu.SetTitle("Checkpoint")
		menu.AddItem("Save", "Save")
		menu.AddItem("Teleport", "Teleport", gB_toggledCheckpoint[client][0] ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED)
		menu.AddItem("Save second", "Save second")
		menu.AddItem("Teleport second", "Teleport second", gB_toggledCheckpoint[client][1] ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED)
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
					GetClientAbsOrigin(param1, gF_origin[param1][0])
					GetClientEyeAngles(param1, gF_eyeAngles[param1][0]) //https://github.com/Smesh292/trikz/blob/main/checkpoint.sp#L101
					GetEntPropVector(param1, Prop_Data, "m_vecAbsVelocity", gF_velocity[param1][0])
					if(!gB_toggledCheckpoint[param1][0])
						gB_toggledCheckpoint[param1][0] = true
				}
				case 1:
					TeleportEntity(param1, gF_origin[param1][0], gF_eyeAngles[param1][0], gF_velocity[param1][0])
				case 2:
				{
					GetClientAbsOrigin(param1, gF_origin[param1][1])
					GetClientEyeAngles(param1, gF_eyeAngles[param1][1])
					GetEntPropVector(param1, Prop_Data, "m_vecAbsVelocity", gF_velocity[param1][1])
					if(!gB_toggledCheckpoint[param1][1])
						gB_toggledCheckpoint[param1][1] = true
				}
				case 3:
					TeleportEntity(param1, gF_origin[param1][1], gF_eyeAngles[param1][1], gF_velocity[param1][1])
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
	//SDKHook(client, SDKHook_StartTouch, SDKSkyFix)
	//SDKHook(client, SDKHook_PostThinkPost, SDKBoostFix) //idea by tengulawl/scripting/blob/master/boost-fix tengulawl github.com
	//SDKHook(client, SDKHook_WeaponEquipPost, SDKWeaponEquipPost)
	SDKHook(client, SDKHook_WeaponDrop, SDKWeaponDrop)
	if(IsClientInGame(client) && gB_passDB)
	{
		gD_mysql.Query(SQLAddUser, "SELECT id FROM users LIMIT 1", GetClientSerial(client), DBPrio_High)
		char sQuery[512]
		int steamid = GetSteamAccountID(client)
		Format(sQuery, 512, "SELECT time FROM records WHERE playerid = %i AND map = '%s' ORDER BY time LIMIT 1", steamid, gS_map)
		gD_mysql.Query(SQLGetPersonalRecord, sQuery, GetClientSerial(client))
	}
	gB_MenuIsOpen[client] = false
	for(int i = 0; i <= 1; i++)
	{
		gB_toggledCheckpoint[client][i] = false
		for(int j = 0; j <= 2; j++)
		{
			gF_origin[client][i][j] = 0.0
			gF_eyeAngles[client][i][j] = 0.0
			gF_velocity[client][i][j] = 0.0
		}
	}
	//gB_block[client] = true
	//gF_Time[client] = 0.0
	if(!gB_isDevmap)
		DrawZone(client, 0.0)
	gB_msg[client] = true
	if(!AreClientCookiesCached(client))
	{
		gB_hudVel[client] = false
		//gB_mlstats[client] = false
		//gB_button[client] = false
		//gB_pbutton[client] = false
	}
	ResetFactory(client)
	gI_points[client] = 0
	if(!gB_haveZone[2])
		CancelClientMenu(client)
}

public void OnClientCookiesCached(int client)
{
	char sValue[16]
	GetClientCookie(client, gH_cookie, sValue, 16)
	gB_hudVel[client] = view_as<bool>(StringToInt(sValue))
	/*GetClientCookie(client, gH_cookie[1], sValue, 16)
	gB_mlstats[client] = view_as<bool>(StringToInt(sValue))
	GetClientCookie(client, gH_cookie[2], sValue, 16)
	gB_button[client] = view_as<bool>(StringToInt(sValue))
	GetClientCookie(client, gH_cookie[3], sValue, 16)
	gB_pbutton[client] = view_as<bool>(StringToInt(sValue))*/
}

public void OnClientDisconnect(int client)
{
	//Color(client, false)
	//gB_color[client] = false
	//int partner = gI_partner[client]
	//gI_partner[gI_partner[client]] = 0
	//if(partner && gB_MenuIsOpen[partner])
	//	Bhop(partner)
	//gI_partner[client] = 0
	CancelClientMenu(client)
	int entity
	while((entity = FindEntityByClassname(entity, "weapon_*")) > 0) //https://github.com/shavitush/bhoptimer/blob/de1fa353ff10eb08c9c9239897fdc398d5ac73cc/addons/sourcemod/scripting/shavit-misc.sp#L1104-L1106
		if(GetEntPropEnt(entity, Prop_Data, "m_hOwnerEntity") == client)
			RemoveEntity(entity)
	/*if(partner && !gB_isDevmap)
	{
		ResetFactory(partner)
		CS_SetClientClanTag(partner, gS_clanTag[partner][0])
	}*/
}

void SQLAddUser(Database db, DBResultSet results, const char[] error, any data)
{
	int client = GetClientFromSerial(data)
	if(!client)
		return
	if(IsClientInGame(client))
	{
		char sQuery[512] //https://forums.alliedmods.net/showthread.php?t=261378
		char sName[MAX_NAME_LENGTH]
		GetClientName(client, sName, MAX_NAME_LENGTH)
		int steamid = GetSteamAccountID(client)
		if(results.FetchRow())
		{
			Format(sQuery, 512, "SELECT steamid FROM users WHERE steamid = %i LIMIT 1", steamid)
			gD_mysql.Query(SQLUpdateUsername, sQuery, GetClientSerial(client), DBPrio_High)
		}
		else
		{
			Format(sQuery, 512, "INSERT INTO users (username, steamid, firstjoin, lastjoin) VALUES ('%s', %i, %i, %i)", sName, steamid, GetTime(), GetTime())
			gD_mysql.Query(SQLUserAdded, sQuery)
		}
	}
}

void SQLUserAdded(Database db, DBResultSet results, const char[] error, any data)
{
}

void SQLUpdateUsername(Database db, DBResultSet results, const char[] error, any data)
{
	int client = GetClientFromSerial(data)
	if(!client)
		return
	if(IsClientInGame(client))
	{
		char sQuery[512]
		char sName[MAX_NAME_LENGTH]
		GetClientName(client, sName, MAX_NAME_LENGTH)
		int steamid = GetSteamAccountID(client)
		if(results.FetchRow())
			Format(sQuery, 512, "UPDATE users SET username = '%s', lastjoin = %i WHERE steamid = %i LIMIT 1", sName, GetTime(), steamid)
		else
			Format(sQuery, 512, "INSERT INTO users (username, steamid, firstjoin, lastjoin) VALUES ('%s', %i, %i, %i)", sName, steamid, GetTime(), GetTime())
		gD_mysql.Query(SQLUpdateUsernameSuccess, sQuery, GetClientSerial(client), DBPrio_High)
	}
}

void SQLUpdateUsernameSuccess(Database db, DBResultSet results, const char[] error, any data)
{
	int client = GetClientFromSerial(data)
	if(!client)
		return
	if(IsClientInGame(client))
	{
		if(results.HasResults == false)
		{
			char sQuery[512]
			int steamid = GetSteamAccountID(client)
			Format(sQuery, 512, "SELECT points FROM users WHERE steamid = %i LIMIT 1", steamid)
			gD_mysql.Query(SQLGetPoints, sQuery, GetClientSerial(client), DBPrio_High)
		}
	}
}

void SQLGetPoints(Database db, DBResultSet results, const char[] error, any data)
{
	int client = GetClientFromSerial(data)
	if(!client)
		return
	if(results.FetchRow())
		gI_points[client] = results.FetchInt(0)
}

void SQLGetServerRecord(Database db, DBResultSet results, const char[] error, any data)
{
	if(results.FetchRow())
		gF_ServerRecord = results.FetchFloat(0)
	else
		gF_ServerRecord = 0.0
}

void SQLGetPersonalRecord(Database db, DBResultSet results, const char[] error, any data)
{
	int client = GetClientFromSerial(data)
	if(results.FetchRow())
		gF_haveRecord[client] = results.FetchFloat(0)
	else
		gF_haveRecord[client] = 0.0
}

/*void SDKSkyFix(int client, int other) //client = booster; other = flyer
{
	if(0 < client <= MaxClients && 0 < other <= MaxClients && !(GetClientButtons(other) & IN_DUCK) && gI_entityButtons[other] & IN_JUMP && GetEngineTime() - gF_boostTime[client] > 0.15 && !gI_skyBoost[other])
	{
		PrintToServer("1")
		float originBooster[3]
		GetClientAbsOrigin(client, originBooster)
		float originFlyer[3]
		GetClientAbsOrigin(other, originFlyer)
		float maxs[3]
		GetEntPropVector(client, Prop_Data, "m_vecMaxs", maxs) //https://github.com/tengulawl/scripting/blob/master/boost-fix.sp#L71
		float delta = originFlyer[2] - originBooster[2] - maxs[2]
		if(0.0 < delta < 2.0) //https://github.com/tengulawl/scripting/blob/master/boost-fix.sp#L75
		{
			float velBooster[3]
			GetEntPropVector(client, Prop_Data, "m_vecAbsVelocity", velBooster)
			if(velBooster[2] > 0.0)
			{
				float velFlyer[3]
				GetEntPropVector(other, Prop_Data, "m_vecAbsVelocity", velFlyer)
				gF_skyVel[other][0] = velFlyer[0]
				gF_skyVel[other][1] = velFlyer[1]				
				velBooster[2] *= 3.0
				gF_skyVel[other][2] = velBooster[2]
				if(velFlyer[2] > -700.0)
				{
					if(velBooster[2] > 750.0)
						gF_skyVel[other][2] = 750.0
				}
				else
					if(velBooster[2] > 800.0)
						gF_skyVel[other][2] = 800.0
				if(FloatAbs(gF_skyOrigin[client][2] - gF_skyOrigin[other][2]) > 1.5 || GetGameTime() - gF_skyAble[other] > 0.5)
					gI_skyBoost[other] = 1
			}
		}
	}
}

void SDKBoostFix(int client)
{
	if(gI_boost[client] == 1)
	{
		int entity = EntRefToEntIndex(gI_flash[client])
		if(entity != INVALID_ENT_REFERENCE)
		{
			float velEntity[3]
			GetEntPropVector(entity, Prop_Data, "m_vecAbsVelocity", velEntity)
			if(velEntity[2] > 0.0)
			{
				velEntity[0] *= 0.135
				velEntity[1] *= 0.135
				velEntity[2] *= -0.135
				TeleportEntity(entity, NULL_VECTOR, NULL_VECTOR, velEntity)
			}
			gI_boost[client] = 2
		}
	}
}*/

Action cmd_bhop(int client, int args)
{
	Bhop(client)
	return Plugin_Handled
}

void Bhop(int client)
{
	gB_MenuIsOpen[client] = true
	Menu menu = new Menu(trikz_handler, MenuAction_Start | MenuAction_Select | MenuAction_Display | MenuAction_Cancel) //https://wiki.alliedmods.net/Menus_Step_By_Step_(SourceMod_Scripting)
	menu.SetTitle("Bhop")
	//menu.AddItem("block", gB_block[client] ? "Block [v]" : "Block [x]")
	//menu.AddItem("partner", gI_partner[client] ? "Breakup" : "Partner", gB_isDevmap ? ITEMDRAW_DISABLED : ITEMDRAW_DEFAULT)
	//if(gB_isDevmap)
	//	menu.AddItem("color", "Color")
	//else
	//	menu.AddItem("color", "Color", gI_partner[client] ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED)
	menu.AddItem("restart", "Restart", gB_isDevmap ? ITEMDRAW_DISABLED : ITEMDRAW_DEFAULT) //shavit trikz githgub alliedmods net https://forums.alliedmods.net/showthread.php?p=2051806
	if(gB_isDevmap)
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
			gB_MenuIsOpen[param1] = true
		case MenuAction_Select:
		{
			switch(param2)
			{
				//case 0:
				//	Block(param1)
				//case 1:
				//{
				//	gB_MenuIsOpen[param1] = false
				//	Partner(param1)
				//}
				//case 2:
				//{
				//	Color(param1, true)
				//	Bhop(param1)
				//}
				case 0:
				{
					Restart(param1)
					//Restart(gI_partner[param1])
				}
				case 1:
				{
					gB_MenuIsOpen[param1] = false
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
			gB_MenuIsOpen[param1] = false //idea from expert zone.
		case MenuAction_Display:
			gB_MenuIsOpen[param1] = true
	}
}

/*Action cmd_block(int client, int args)
{
	Block(client)
	return Plugin_Handled
}

Action Block(int client) //thanks maru for optimization.
{
	gB_block[client] = !gB_block[client]
	SetEntProp(client, Prop_Data, "m_CollisionGroup", gB_block[client] ? 5 : 2)
	if(gB_color[client])
		SetEntityRenderColor(client, gI_color[client][0], gI_color[client][1], gI_color[client][2], gB_block[client] ? 255 : 125)
	else
		SetEntityRenderColor(client, 255, 255, 255, gB_block[client] ? 255 : 125)
	if(gB_MenuIsOpen[client])
		Bhop(client)
	PrintToChat(client, gB_block[client] ? "Block enabled." : "Block disabled.")
	return Plugin_Handled
}

Action cmd_partner(int client, int args)
{
	Partner(client)
	return Plugin_Handled
}

void Partner(int client)
{
	if(gB_isDevmap)
		PrintToChat(client, "Turn off devmap.")
	else
	{
		if(IsPlayerAlive(client))
		{
			if(!gI_partner[client])
			{
				Menu menu = new Menu(partner_handler)
				menu.SetTitle("Choose partner")
				char sName[MAX_NAME_LENGTH]
				bool noPlayers = true
				for(int i = 1; i <= MaxClients; i++)
				{
					if(IsClientInGame(i) && !IsFakeClient(i)) //https://github.com/Figawe2/trikz-plugin/blob/master/scripting/trikz.sp#L635
					{
						if(IsPlayerAlive(i))
						{
							if(client != i && !gI_partner[i])
							{
								GetClientName(i, sName, MAX_NAME_LENGTH)
								char sNameID[32]
								IntToString(i, sNameID, 32)
								menu.AddItem(sNameID, sName)
								noPlayers = false
							}
						}
					}
				}
				switch(noPlayers)
				{
					case true:
						PrintToChat(client, "No free player.")
				}
				menu.Display(client, 20)
			}
			else
			{
				Menu menu = new Menu(cancelpartner_handler)
				menu.SetTitle("Cancel partnership with %N", gI_partner[client])
				char sPartner[32]
				IntToString(gI_partner[client], sPartner, 32)
				menu.AddItem(sPartner, "Yes")
				menu.AddItem("", "No")
				menu.Display(client, 20)
			}
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
				t = true
				break
			}
			if(ct && t)
			{
				PrintToChat(client, "Join to Counter-Terrorist or Terrorist team.")
				return
			}
			else if(ct)
				PrintToChat(client, "Join to Counter-Terrorist team.")
			else if(t)
				PrintToChat(client, "Join to Terrorist team.")
		}
	}
}

int partner_handler(Menu menu, MenuAction action, int param1, int param2) //param1 = client; param2 = server -> partner
{
	switch(action)
	{
		case MenuAction_Select:
		{
			char sItem[32]
			menu.GetItem(param2, sItem, 32)
			int partner = StringToInt(sItem)
			Menu menu2 = new Menu(askpartner_handle)
			menu2.SetTitle("Agree partner with %N?", param1)
			char sParam1[32]
			IntToString(param1, sParam1, 32)
			menu2.AddItem(sParam1, "Yes")
			menu2.AddItem(sItem, "No")
			menu2.Display(partner, 20)
		}
	}
}

int askpartner_handle(Menu menu, MenuAction action, int param1, int param2) //param1 = client; param2 = server -> partner
{
	switch(action)
	{
		case MenuAction_Select:
		{
			char sItem[32]
			menu.GetItem(param2, sItem, 32)
			int partner = StringToInt(sItem)
			switch(param2)
			{
				case 0:
				{
					if(!gI_partner[partner])
					{
						gI_partner[param1] = partner
						gI_partner[partner] = param1
						PrintToChat(param1, "Partnersheep agreed with %N.", partner) //reciever
						PrintToChat(partner, "You have %N as partner.", param1) //sender
						Restart(param1)
						Restart(partner) //Expert-Zone idea.
						if(gB_MenuIsOpen[partner])
							Bhop(partner)
						char sQuery[512]
						Format(sQuery, 512, "SELECT time FROM records WHERE ((playerid = %i AND partnerid = %i) OR (playerid = %i AND partnerid = %i)) AND map = '%s' LIMIT 1", GetSteamAccountID(param1), GetSteamAccountID(partner), GetSteamAccountID(partner), GetSteamAccountID(param1), gS_map)
						gD_mysql.Query(SQLGetPartnerRecord, sQuery, GetClientSerial(param1))
					}
					else
						PrintToChat(param1, "A player already have a partner.")
				}
				case 1:
					PrintToChat(param1, "Partnersheep declined with %N.", partner)
			}
		}
	}
}

int cancelpartner_handler(Menu menu, MenuAction action, int param1, int param2)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			char sItem[32]
			menu.GetItem(param2, sItem, 32)
			int partner = StringToInt(sItem)
			switch(param2)
			{
				case 0:
				{
					Color(param1, false)
					gI_partner[param1] = 0
					gI_partner[partner] = 0
					ResetFactory(param1)
					ResetFactory(partner)
					PrintToChat(param1, "Partnership is canceled with %N", partner)
					PrintToChat(partner, "Partnership is canceled by %N", param1)
				}
			}
		}
	}
}

Action cmd_color(int client, int args)
{
	char sArgString[512]
	GetCmdArgString(sArgString, 512) //https://www.sourcemod.net/new-api/console/GetCmdArgString
	int color = StringToInt(sArgString)
	if(StrEqual(sArgString, "white"))
		color = 0
	else if(StrEqual(sArgString, "red"))
		color = 1
	else if(StrEqual(sArgString, "orange"))
		color = 2
	else if(StrEqual(sArgString, "yellow"))
		color = 3
	else if(StrEqual(sArgString, "lime"))
		color = 4
	else if(StrEqual(sArgString, "aqua"))
		color = 5
	else if(StrEqual(sArgString, "deep sky blue"))
		color = 6
	else if(StrEqual(sArgString, "blue"))
		color = 7
	else if(StrEqual(sArgString, "magenta"))
		color = 8
	if(strlen(sArgString) && 0 <= color <= 8)
		Color(client, true, color)
	else if(!color)
		Color(client, true)
	return Plugin_Handled
}

void Color(int client, bool customSkin, int color = -1)
{
	if(IsClientInGame(client))
	{
		if(!gB_isDevmap && !gI_partner[client])
		{
			PrintToChat(client, "You must have a partner.")
			return
		}
		if(customSkin)
		{
			gB_color[client] = true
			gB_color[gI_partner[client]] = true
			SetEntProp(client, Prop_Data, "m_nModelIndex", gI_wModelPlayer[gI_class[client]])
			SetEntProp(gI_partner[client], Prop_Data, "m_nModelIndex", gI_wModelPlayer[gI_class[client]])
			DispatchKeyValue(client, "skin", "2")
			DispatchKeyValue(gI_partner[client], "skin", "2")
			char gS_colorExploded[3][16]
			if(gI_colorCount[client] == 9)
			{
				gI_colorCount[client] = 0
				gI_colorCount[gI_partner[client]] = 0
			}
			else if(0 <= color <= 8)
			{
				gI_colorCount[client] = color
				gI_colorCount[gI_partner[client]] = color
			}
			ExplodeString(gS_color[gI_colorCount[client]], ",", gS_colorExploded, 3, 16)
			for(int i = 0; i <= 2; i++)
			{
				gI_color[client][i] = StringToInt(gS_colorExploded[i])
				gI_color[gI_partner[client]][i] = StringToInt(gS_colorExploded[i])
			}
			SetEntityRenderColor(client, gI_color[client][0], gI_color[client][1], gI_color[client][2], gB_block[client] ? 255 : 125)
			SetEntityRenderColor(gI_partner[client], gI_color[client][0], gI_color[client][1], gI_color[client][2], gB_block[gI_partner[client]] ? 255 : 125)
			gI_colorCount[client]++
			gI_colorCount[gI_partner[client]]++
		}
		else
		{
			gB_color[client] = false
			gB_color[gI_partner[client]] = false
			gI_colorCount[client] = 0
			gI_colorCount[gI_partner[client]] = 0
			SetEntityRenderColor(client, 255, 255, 255, gB_block[client] ? 255 : 125)
			SetEntityRenderColor(gI_partner[client], 255, 255, 255, gB_block[gI_partner[client]] ? 255 : 125)
		}
	}
}

void SQLGetPartnerRecord(Database db, DBResultSet results, const char[] error, any data)
{
	int client = GetClientFromSerial(data)
	if(!client)
		return
	if(results.FetchRow())
	{
		gF_mateRecord[client] = results.FetchFloat(0)
		gF_mateRecord[gI_partner[client]] = results.FetchFloat(0)
	}
	else
	{
		gF_mateRecord[client] = 0.0
		gF_mateRecord[gI_partner[client]] = 0.0
	}
}*/

Action cmd_restart(int client, int args)
{
	Restart(client)
	//if(gI_partner[client])
	//	Restart(gI_partner[client])
	return Plugin_Handled
}

void Restart(int client)
{
	if(gB_isDevmap)
		PrintToChat(client, "Turn off devmap.")
	else
	{
		if(gB_haveZone[0] && gB_haveZone[1])
		{
			//if(gI_partner[client])
			//{
			if(IsPlayerAlive(client))
			{
				CreateTimer(0.1, timer_resetfactory, client, TIMER_FLAG_NO_MAPCHANGE)
				Call_StartForward(gH_start)
				Call_PushCell(client)
				Call_Finish()
				float angles[3]
				GetClientEyeAngles(client, angles)
				CS_RespawnPlayer(client)
				float velNull[3]
				TeleportEntity(client, gF_originStart, angles, velNull)
				//SetEntProp(client, Prop_Data, "m_CollisionGroup", 2)
				//if(gB_color[client])
				//	SetEntityRenderColor(client, gI_color[client][0], gI_color[client][1], gI_color[client][2], 125)
				//else
				//	SetEntityRenderColor(client, 255, 255, 255, 125)
				//gB_block[client] = false
				if(gB_MenuIsOpen[client])
					Bhop(client)
				//CreateTimer(3.0, Timer_BlockToggle, client, TIMER_FLAG_NO_MAPCHANGE) 
				//int pistol = GetPlayerWeaponSlot(client, 1) //https://forums.alliedmods.net/showthread.php?p=2458524 https://www.bing.com/search?q=CS_SLOT_KNIFE&cvid=52182d12e2ce40ddb948446cae8cfd71&aqs=edge..69i57.383j0j1&pglt=299&FORM=ANNTA1&PC=U531
				//if(IsValidEntity(pistol))
				//	RemoveEntity(pistol) //RemovePlayerItem need extra frame.
				//GivePlayerItem(client, "weapon_usp")
			}
			//}
			//else if(IsPlayerAlive(client) && !gI_partner[client])
			//	PrintToChat(client, "You must have a partner.")
		}
	}
}

Action timer_resetfactory(Handle timer, int client)
{
	if(IsClientInGame(client))
		ResetFactory(client)
}

/*Action Timer_BlockToggle(Handle timer, int client)
{
	if(IsValidEntity(client) && IsValidEntity(gI_partner[client]))
	{
		SetEntProp(client, Prop_Data, "m_CollisionGroup", 5)
		if(gB_color[client])
			SetEntityRenderColor(client, gI_color[client][0], gI_color[client][1], gI_color[client][2], 255)
		else
			SetEntityRenderColor(client, 255, 255, 255, 255)
		gB_block[client] = true
		if(gB_MenuIsOpen[client])
			Bhop(client)
	}
}*/

void createstart()
{
	int entity = CreateEntityByName("trigger_multiple")
	DispatchKeyValue(entity, "spawnflags", "1") //https://github.com/shavitush/bhoptimer
	DispatchKeyValue(entity, "wait", "0")
	DispatchKeyValue(entity, "targetname", "fakeexpert_startzone")
	DispatchSpawn(entity)
	SetEntityModel(entity, "models/player/t_arctic.mdl")
	//https://stackoverflow.com/questions/4355894/how-to-get-center-of-set-of-points-using-python
	gF_center[0][0] = (gF_originStartZone[0][0] + gF_originStartZone[1][0]) / 2.0
	gF_center[0][1] = (gF_originStartZone[0][1] + gF_originStartZone[1][1]) / 2.0
	gF_center[0][2] = (gF_originStartZone[0][2] + gF_originStartZone[1][2]) / 2.0
	TeleportEntity(entity, gF_center[0], NULL_VECTOR, NULL_VECTOR) //Thanks to https://amx-x.ru/viewtopic.php?f=14&t=15098 http://world-source.ru/forum/102-3743-1
	gF_originStart[0] = gF_center[0][0]
	gF_originStart[1] = gF_center[0][1]
	gF_originStart[2] = gF_center[0][2] + 1.0
	float mins[3]
	float maxs[3]
	for(int i = 0; i <= 1; i++)
	{
		mins[i] = (gF_originStartZone[0][i] - gF_originStartZone[1][i]) / 2.0
		if(mins[i] > 0.0)
			mins[i] *= -1.0
		maxs[i] = (gF_originStartZone[0][i] - gF_originStartZone[1][i]) / 2.0
		if(maxs[i] < 0.0)
			maxs[i] *= -1.0
	}
	maxs[2] = 124.0
	SetEntPropVector(entity, Prop_Send, "m_vecMins", mins)
	SetEntPropVector(entity, Prop_Send, "m_vecMaxs", maxs)
	SetEntProp(entity, Prop_Send, "m_nSolidType", 2)
	SDKHook(entity, SDKHook_StartTouch, SDKStartTouch)
	SDKHook(entity, SDKHook_EndTouch, SDKEndTouch)
	PrintToServer("Start zone is successfuly setup.")
	gB_haveZone[0] = true
}

void createend()
{
	int entity = CreateEntityByName("trigger_multiple")
	DispatchKeyValue(entity, "spawnflags", "1") //https://github.com/shavitush/bhoptimer
	DispatchKeyValue(entity, "wait", "0")
	DispatchKeyValue(entity, "targetname", "fakeexpert_endzone")
	DispatchSpawn(entity)
	SetEntityModel(entity, "models/player/t_arctic.mdl")
	//https://stackoverflow.com/questions/4355894/how-to-get-center-of-set-of-points-using-python
	gF_center[1][0] = (gF_originEndZone[0][0] + gF_originEndZone[1][0]) / 2.0
	gF_center[1][1] = (gF_originEndZone[0][1] + gF_originEndZone[1][1]) / 2.0
	gF_center[1][2] = (gF_originEndZone[0][2] + gF_originEndZone[1][2]) / 2.0
	TeleportEntity(entity, gF_center[1], NULL_VECTOR, NULL_VECTOR) //Thanks to https://amx-x.ru/viewtopic.php?f=14&t=15098 http://world-source.ru/forum/102-3743-1
	float mins[3]
	float maxs[3]
	for(int i = 0; i <= 1; i++)
	{
		mins[i] = (gF_originEndZone[0][i] - gF_originEndZone[1][i]) / 2.0
		if(mins[i] > 0.0)
			mins[i] *= -1.0
		maxs[i] = (gF_originEndZone[0][i] - gF_originEndZone[1][i]) / 2.0
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
	gB_haveZone[1] = true
}

Action cmd_startmins(int client, int args)
{
	int steamid = GetSteamAccountID(client)
	char sCurrentSteamID[64]
	IntToString(steamid, sCurrentSteamID, 64)
	char sSteamID[64]
	GetConVarString(gCV_steamid, sSteamID, 64)
	if(StrEqual(sSteamID, sCurrentSteamID))
	{
		if(gB_isDevmap)
		{
			GetClientAbsOrigin(client, gF_originStartZone[0])
			gB_zoneFirst[0] = true
		}
		else
			PrintToChat(client, "Turn on devmap.")
	}
	return Plugin_Handled
}

void SQLDeleteStartZone(Database db, DBResultSet results, const char[] error, any data)
{
	char sQuery[512]
	Format(sQuery, 512, "INSERT INTO zones (map, type, possition_x, possition_y, possition_z, possition_x2, possition_y2, possition_z2) VALUES ('%s', 0, %i, %i, %i, %i, %i, %i)", gS_map, RoundFloat(gF_originStartZone[0][0]), RoundFloat(gF_originStartZone[0][1]), RoundFloat(gF_originStartZone[0][2]), RoundFloat(gF_originStartZone[1][0]), RoundFloat(gF_originStartZone[1][1]), RoundFloat(gF_originStartZone[1][2]))
	gD_mysql.Query(SQLSetStartZones, sQuery)
}

Action cmd_deleteallcp(int client, int args)
{
	int steamid = GetSteamAccountID(client)
	char sCurrentSteamID[64]
	IntToString(steamid, sCurrentSteamID, 64)
	char sSteamID[64]
	GetConVarString(gCV_steamid, sSteamID, 64)
	if(StrEqual(sSteamID, sCurrentSteamID)) //https://sm.alliedmods.net/new-api/
	{
		if(gB_isDevmap)
		{
			char sQuery[512]
			Format(sQuery, 512, "DELETE FROM cp WHERE map = '%s'", gS_map) //https://www.w3schools.com/sql/sql_delete.asp
			gD_mysql.Query(SQLDeleteAllCP, sQuery)
		}
		else
			PrintToChat(client, "Turn on devmap.")
	}
}

void SQLDeleteAllCP(Database db, DBResultSet results, const char[] error, any data)
{
	if(results.HasResults == false)
		PrintToServer("All checkpoints are deleted on current map.")
	else
		PrintToServer("No checkpoints to delete on current map.")
}

public Action OnClientCommandKeyValues(int client, KeyValues kv)
{
	if(!gB_isDevmap)
	{
		char sCmd[64] //https://forums.alliedmods.net/showthread.php?t=270684
		kv.GetSectionName(sCmd, 64)
		if(StrEqual(sCmd, "ClanTagChanged"))
			CS_GetClientClanTag(client, gS_clanTag[client][0], 256)
	}
}

Action cmd_test(int client, int args)
{
	int steamid = GetSteamAccountID(client)
	char sCurrentSteamID[64]
	IntToString(steamid, sCurrentSteamID, 64)
	char sSteamID[64]
	GetConVarString(gCV_steamid, sSteamID, 64)
	if(StrEqual(sSteamID, sCurrentSteamID)) //https://sm.alliedmods.net/new-api/
	{
		PrintToServer("TickCount: %i", GetGameTickCount())
		PrintToServer("GetTime: %i", GetTime())
		PrintToServer("GetGameTime: %f", GetGameTime())
		PrintToServer("GetEngineTime: %f", GetEngineTime())
		PrintToServer("GetTickInterval: %f, tickrate: %f (1.0 / GetTickInterval())", GetTickInterval(), 1.0 / GetTickInterval()) //https://github.com/shavitush/bhoptimer/blob/master/addons/sourcemod/scripting/shavit-replay.sp#L386
		float round = 123.123
		PrintToServer("RoundFloat: %i", RoundFloat(round))
		PrintToServer("RoundToCeil: %i", RoundToCeil(round))
		PrintToServer("RoundToFloor: %i", RoundToFloor(round))
		PrintToServer("RoundToNearest: %i", RoundToNearest(round))
		PrintToServer("RoundToZero: %i", RoundToZero(round))
		/*RoundFloat: 123
		RoundToCeil: 124
		RoundToFloor: 123
		RoundToNearest: 123
		RoundToZero: 123*/
		round = 123.912
		PrintToServer("RoundFloat: %i", RoundFloat(round))
		PrintToServer("RoundToCeil: %i", RoundToCeil(round))
		PrintToServer("RoundToFloor: %i", RoundToFloor(round))
		PrintToServer("RoundToNearest: %i", RoundToNearest(round))
		PrintToServer("RoundToZero: %i", RoundToZero(round))
		/*
		RoundFloat: 124
		RoundToCeil: 124
		RoundToFloor: 123
		RoundToNearest: 124
		RoundToZero: 123
		*/
		float x = 0.0
		if(x)
			PrintToServer("%f == 0.0 | true", x)
		else
			PrintToServer("%f == 0.0 | false", x)
		x = 1.0
		if(x)
			PrintToServer("%f == 1.0 | true", x)
		else
			PrintToServer("%f == 1.0 | false", x)
		x = -1.0
		if(x)
			PrintToServer("%f == -1.0 | true", x)
		else
			PrintToServer("%f == -1.0 | false", x)
		x = 0.1
		if(x)
			PrintToServer("%f == 0.1 | true", x)
		else
			PrintToServer("%f == 0.1 | false", x)
		/*
		0.000000 == 0.0 | false
		1.000000 == 1.0 | true
		-1.000000 == -1.0 | true
		0.100000 == 0.1 | true
		*/
		char sText[256]
		char sName[MAX_NAME_LENGTH]
		GetClientName(client, sName, MAX_NAME_LENGTH)
		int team = GetClientTeam(client)
		char sTeam[32]
		char sTeamColor[32]
		switch(team)
		{
			case 1:
			{
				Format(sTeam, 32, "Spectator")
				Format(sTeamColor, 32, "\x07CCCCCC")
			}
			case 2:
			{
				Format(sTeam, 32, "Terrorist")
				Format(sTeamColor, 32, "\x07FF4040")
			}
			case 3:
			{
				Format(sTeam, 32, "Counter-Terrorist")
				Format(sTeamColor, 32, "\x0799CCFF")
			}
		}
		Format(sText, 256, "\x01%T", "Hello", client, "FakeExpert", sName, sTeam)
		ReplaceString(sText, 256, ";#", "\x07")
		ReplaceString(sText, 256, "{default}", "\x01")
		ReplaceString(sText, 256, "{teamcolor}", sTeamColor)
		PrintToChat(client, "%s", sText)
		//char sArgString[256]
		//GetCmdArgString(sArgString, 256)
		//int partner = StringToInt(sArgString)
		//if(partner <= MaxClients && !gI_partner[client])
		//{
			//gI_partner[client] = partner
		Call_StartForward(gH_start)
		Call_PushCell(client)
		Call_Finish()
		Restart(client)
		//}
		/*for(int i = 1; i <= MaxClients; i++)
		{
			if(IsClientInGame(i))
			{
				PrintToServer("(%i %N)", i, i)
				PrintToServer("CollisionGroup: %i %N", GetEntProp(i, Prop_Data, "m_CollisionGroup"), i)
			}
		}*/
		//PrintToServer("LibraryExists (fakeexpert-entityfilter): %i", LibraryExists("fakeexpert-entityfilter"))
		//https://forums.alliedmods.net/showthread.php?t=187746
		int color
		color |= (5 & 255) << 24 //5 red
		color |= (200 & 255) << 16 // 200 green
		color |= (255 & 255) << 8 // 255 blue
		color |= (50 & 255) << 0 // 50 alpha
		PrintToChat(client, "\x08%08XCOLOR", color)
		char sAuth64[64]
		GetClientAuthId(client, AuthId_SteamID64, sAuth64, 64)
		PrintToChat(client, "Your SteamID64 is: %s = 76561197960265728 + %i (SteamID3)", sAuth64, steamid) //https://forums.alliedmods.net/showthread.php?t=324112 120192594
	}
	return Plugin_Handled
}

Action cmd_endmins(int client, int args)
{
	int steamid = GetSteamAccountID(client)
	char sCurrentSteamID[64]
	IntToString(steamid, sCurrentSteamID, 64)
	char sSteamID[64]
	GetConVarString(gCV_steamid, sSteamID, 64)
	if(StrEqual(sSteamID, sCurrentSteamID))
	{
		if(gB_isDevmap)
		{
			GetClientAbsOrigin(client, gF_originEndZone[0])
			gB_zoneFirst[1] = true
		}
		else
			PrintToChat(client, "Turn on devmap.")
	}
	return Plugin_Handled
}

void SQLDeleteEndZone(Database db, DBResultSet results, const char[] error, any data)
{
	char sQuery[512]
	Format(sQuery, 512, "INSERT INTO zones (map, type, possition_x, possition_y, possition_z, possition_x2, possition_y2, possition_z2) VALUES ('%s', 1, %i, %i, %i, %i, %i, %i)", gS_map, RoundFloat(gF_originEndZone[0][0]), RoundFloat(gF_originEndZone[0][1]), RoundFloat(gF_originEndZone[0][2]), RoundFloat(gF_originEndZone[1][0]), RoundFloat(gF_originEndZone[1][1]), RoundFloat(gF_originEndZone[1][2]))
	gD_mysql.Query(SQLSetEndZones, sQuery)
}

Action cmd_maptier(int client, int args)
{
	int steamid = GetSteamAccountID(client)
	char sCurrentSteamID[64]
	IntToString(steamid, sCurrentSteamID, 64)
	char sSteamID[64]
	GetConVarString(gCV_steamid, sSteamID, 64)
	if(StrEqual(sSteamID, sCurrentSteamID))
	{
		if(gB_isDevmap)
		{
			char sArgString[512]
			GetCmdArgString(sArgString, 512) //https://www.sourcemod.net/new-api/console/GetCmdArgString
			int tier = StringToInt(sArgString)
			if(tier > 0)
			{
				PrintToServer("[Args] Tier: %i", tier)
				char sQuery[512]
				Format(sQuery, 512, "DELETE FROM tier WHERE map = '%s' LIMIT 1", gS_map)
				gD_mysql.Query(SQLTierRemove, sQuery, tier)
			}
		}
		else
			PrintToChat(client, "Turn on devmap.")
	}
	return Plugin_Handled
}

void SQLTierRemove(Database db, DBResultSet results, const char[] error, any data)
{
	char sQuery[512]
	Format(sQuery, 512, "INSERT INTO tier (tier, map) VALUES (%i, '%s')", data, gS_map)
	gD_mysql.Query(SQLTierInsert, sQuery, data)
}

void SQLTierInsert(Database db, DBResultSet results, const char[] error, any data)
{
	if(results.HasResults == false)
		PrintToServer("Tier %i is set for %s.", data, gS_map)
}

void SQLSetStartZones(Database db, DBResultSet results, const char[] error, any data)
{
	if(results.HasResults == false)
		PrintToServer("Start zone successfuly created.")
}

void SQLSetEndZones(Database db, DBResultSet results, const char[] error, any data)
{
	if(results.HasResults == false)
		PrintToServer("End zone successfuly created.")
}

Action cmd_startmaxs(int client, int args)
{
	int steamid = GetSteamAccountID(client)
	char sCurrentSteamID[64]
	IntToString(steamid, sCurrentSteamID, 64)
	char sSteamID[64]
	GetConVarString(gCV_steamid, sSteamID, 64)
	if(StrEqual(sSteamID, sCurrentSteamID) && gB_zoneFirst[0])
	{
		GetClientAbsOrigin(client, gF_originStartZone[1])
		char sQuery[512]
		Format(sQuery, 512, "DELETE FROM zones WHERE map = '%s' AND type = 0 LIMIT 1", gS_map)
		gD_mysql.Query(SQLDeleteStartZone, sQuery)
		gB_zoneFirst[0] = false
	}
	return Plugin_Handled
}

Action cmd_endmaxs(int client, int args)
{
	int steamid = GetSteamAccountID(client)
	char sCurrentSteamID[64]
	IntToString(steamid, sCurrentSteamID, 64)
	char sSteamID[64]
	GetConVarString(gCV_steamid, sSteamID, 64)
	if(StrEqual(sSteamID, sCurrentSteamID) && gB_zoneFirst[1])
	{
		GetClientAbsOrigin(client, gF_originEndZone[1])
		char sQuery[512]
		Format(sQuery, 512, "DELETE FROM zones WHERE map = '%s' AND type = 1 LIMIT 1", gS_map)
		gD_mysql.Query(SQLDeleteEndZone, sQuery)
		gB_zoneFirst[1] = false
	}
	return Plugin_Handled
}

Action cmd_cpmins(int client, int args)
{
	int steamid = GetSteamAccountID(client)
	char sCurrentSteamID[64]
	IntToString(steamid, sCurrentSteamID, 64)
	char sSteamID[64]
	GetConVarString(gCV_steamid, sSteamID, 64)
	if(StrEqual(sSteamID, sCurrentSteamID))
	{
		if(gB_isDevmap)
		{
			char sCmd[512]
			GetCmdArg(args, sCmd, 512)
			int cpnum = StringToInt(sCmd)
			if(cpnum > 0)
			{
				PrintToChat(client, "CP: No.%i", cpnum)
				GetClientAbsOrigin(client, gF_originCP[0][cpnum])
				gB_zoneFirst[2] = true
			}
		}
		else
			PrintToChat(client, "Turn on devmap.")
	}
	return Plugin_Handled
}

void SQLCPRemoved(Database db, DBResultSet results, const char[] error, any data)
{
	if(results.HasResults == false)
		PrintToServer("Checkpoint zone no. %i successfuly deleted.", data)
	char sQuery[512]
	Format(sQuery, 512, "INSERT INTO cp (cpnum, cpx, cpy, cpz, cpx2, cpy2, cpz2, map) VALUES (%i, %i, %i, %i, %i, %i, %i, '%s')", data, RoundFloat(gF_originCP[0][data][0]), RoundFloat(gF_originCP[0][data][1]), RoundFloat(gF_originCP[0][data][2]), RoundFloat(gF_originCP[1][data][0]), RoundFloat(gF_originCP[1][data][1]), RoundFloat(gF_originCP[1][data][2]), gS_map)
	gD_mysql.Query(SQLCPInserted, sQuery, data)
}

Action cmd_cpmaxs(int client, int args)
{
	int steamid = GetSteamAccountID(client)
	char sCurrentSteamID[64]
	IntToString(steamid, sCurrentSteamID, 64)
	char sSteamID[64]
	GetConVarString(gCV_steamid, sSteamID, 64)
	if(StrEqual(sSteamID, sCurrentSteamID) && gB_zoneFirst[2])
	{
		char sCmd[512]
		GetCmdArg(args, sCmd, 512)
		int cpnum = StringToInt(sCmd)
		if(cpnum > 0)
		{
			GetClientAbsOrigin(client, gF_originCP[1][cpnum])
			char sQuery[512]
			Format(sQuery, 512, "DELETE FROM cp WHERE cpnum = %i AND map = '%s'", cpnum, gS_map)
			gD_mysql.Query(SQLCPRemoved, sQuery, cpnum)
			gB_zoneFirst[2] = false
		}
	}
	return Plugin_Handled
}

void SQLCPInserted(Database db, DBResultSet results, const char[] error, any data)
{
	if(results.HasResults == false)
		PrintToServer("Checkpoint zone no. %i successfuly created.", data)
}

Action cmd_zones(int client, int args)
{
	int steamid = GetSteamAccountID(client)
	char sCurrentSteamID[64]
	IntToString(steamid, sCurrentSteamID, 64)
	char sSteamID[64]
	GetConVarString(gCV_steamid, sSteamID, 64)
	if(StrEqual(sSteamID, sCurrentSteamID))
	{
		if(gB_isDevmap)
			ZoneEditor(client)
		else
			PrintToChat(client, "Turn on devmap.")
	}
}

void ZoneEditor(int client)
{
	CPSetup(client)
}

void ZoneEditor2(int client)
{
	Menu menu = new Menu(zones_handler)
	menu.SetTitle("Zone editor")
	if(gB_haveZone[0])
		menu.AddItem("start", "Start zone")
	if(gB_haveZone[1])
		menu.AddItem("end", "End zone")
	char sFormat[32]
	if(gI_cpCount)
	{
		for(int i = 1; i <= gI_cpCount; i++)
		{
			Format(sFormat, 32, "CP nr. %i zone", i)
			char sCP[16]
			Format(sCP, 16, "%i", i)
			menu.AddItem(sCP, sFormat)
		}
	}
	else if(!gB_haveZone[0] && !gB_haveZone[1] && !gI_cpCount)
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
			for(int i = 1; i <= gI_cpCount; i++)
			{
				char sCP[16]
				IntToString(i, sCP, 16)
				Format(sCP, 16, "%i", i)
				if(StrEqual(sItem, sCP))
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
			gB_DrawZone[param1] = true
		case MenuAction_Select:
		{
			char sItem[16]
			menu.GetItem(param2, sItem, 16)
			if(StrEqual(sItem, "starttp"))
				TeleportEntity(param1, gF_center[0], NULL_VECTOR, NULL_VECTOR)
			else if(StrEqual(sItem, "start+xmins"))
				gF_originStartZone[0][0] += 16.0
			else if(StrEqual(sItem, "start-xmins"))
				gF_originStartZone[0][0] -= 16.0
			else if(StrEqual(sItem, "start+ymins"))
				gF_originStartZone[0][1] += 16.0
			else if(StrEqual(sItem, "start-ymins"))
				gF_originStartZone[0][1] -= 16.0
			else if(StrEqual(sItem, "start+xmaxs"))
				gF_originStartZone[1][0] += 16.0
			else if(StrEqual(sItem, "start-xmaxs"))
				gF_originStartZone[1][0] -= 16.0
			else if(StrEqual(sItem, "start+ymaxs"))
				gF_originStartZone[1][1] += 16.0
			else if(StrEqual(sItem, "start-ymaxs"))
				gF_originStartZone[1][1] -= 16.0
			else if(StrEqual(sItem, "endtp"))
				TeleportEntity(param1, gF_center[1], NULL_VECTOR, NULL_VECTOR)
			else if(StrEqual(sItem, "end+xmins"))
				gF_originEndZone[0][0] += 16.0
			else if(StrEqual(sItem, "end-xmins"))
				gF_originEndZone[0][0] -= 16.0
			else if(StrEqual(sItem, "end+ymins"))
				gF_originEndZone[0][1] += 16.0
			else if(StrEqual(sItem, "end-ymins"))
				gF_originEndZone[0][1] -= 16.0
			else if(StrEqual(sItem, "end+xmaxs"))
				gF_originEndZone[1][0] += 16.0
			else if(StrEqual(sItem, "end-xmaxs"))
				gF_originEndZone[1][0] -= 16.0
			else if(StrEqual(sItem, "end+ymaxs"))
				gF_originEndZone[1][1] += 16.0
			else if(StrEqual(sItem, "end-ymaxs"))
				gF_originEndZone[1][1] -= 16.0
			char sExploded[16][16]
			ExplodeString(sItem, ";", sExploded, 16, 16)
			int cpnum = StringToInt(sExploded[0])
			char sFormatCP[16]
			Format(sFormatCP, 16, "%i;tp", cpnum)
			if(StrEqual(sItem, sFormatCP))
				TeleportEntity(param1, gF_center[cpnum + 1], NULL_VECTOR, NULL_VECTOR)
			Format(sFormatCP, 16, "%i;1", cpnum)
			if(StrEqual(sItem, sFormatCP))
				gF_originCP[0][cpnum][0] += 16.0
			Format(sFormatCP, 16, "%i;2", cpnum)
			if(StrEqual(sItem, sFormatCP))
				gF_originCP[0][cpnum][0] -= 16.0
			Format(sFormatCP, 16, "%i;3", cpnum)
			if(StrEqual(sItem, sFormatCP))
				gF_originCP[0][cpnum][1] += 16.0
			Format(sFormatCP, 16, "%i;4", cpnum)
			if(StrEqual(sItem, sFormatCP))
				gF_originCP[0][cpnum][1] -= 16.0
			Format(sFormatCP, 16, "%i;5", cpnum)
			if(StrEqual(sItem, sFormatCP))
				gF_originCP[1][cpnum][0] += 16.0
			Format(sFormatCP, 16, "%i;6", cpnum)
			if(StrEqual(sItem, sFormatCP))
				gF_originCP[1][cpnum][0] -= 16.0
			Format(sFormatCP, 16, "%i;7", cpnum)
			if(StrEqual(sItem, sFormatCP))
				gF_originCP[1][cpnum][1] += 16.0
			Format(sFormatCP, 16, "%i;8", cpnum)
			if(StrEqual(sItem, sFormatCP))
				gF_originCP[1][cpnum][1] -= 16.0
			char sQuery[512]
			if(StrEqual(sItem, "startupdate"))
			{
				Format(sQuery, 512, "UPDATE zones SET possition_x = %i, possition_y = %i, possition_z = %i, possition_x2 = %i, possition_y2 = %i, possition_z2 = %i WHERE type = 0 AND map = '%s'", RoundFloat(gF_originStartZone[0][0]), RoundFloat(gF_originStartZone[0][1]), RoundFloat(gF_originStartZone[0][2]), RoundFloat(gF_originStartZone[1][0]), RoundFloat(gF_originStartZone[1][1]), RoundFloat(gF_originStartZone[1][2]), gS_map)
				gD_mysql.Query(SQLUpdateZone, sQuery, 0)
			}
			else if(StrEqual(sItem, "endupdate"))
			{
				Format(sQuery, 512, "UPDATE zones SET possition_x = %i, possition_y = %i, possition_z = %i, possition_x2 = %i, possition_y2 = %i, possition_z2 = %i WHERE type = 1 AND map = '%s'", RoundFloat(gF_originEndZone[0][0]), RoundFloat(gF_originEndZone[0][1]), RoundFloat(gF_originEndZone[0][2]), RoundFloat(gF_originEndZone[1][0]), RoundFloat(gF_originEndZone[1][1]), RoundFloat(gF_originEndZone[1][2]), gS_map)
				gD_mysql.Query(SQLUpdateZone, sQuery, 1)
			}
			else if(StrEqual(sItem, "cpupdate"))
			{
				Format(sQuery, 512, "UPDATE cp SET cpx = %i, cpy = %i, cpz = %i, cpx2 = %i, cpy2 = %i, cpz2 = %i WHERE cpnum = %i AND map = '%s'", RoundFloat(gF_originCP[0][cpnum][0]), RoundFloat(gF_originCP[0][cpnum][1]), RoundFloat(gF_originCP[0][cpnum][2]), RoundFloat(gF_originCP[1][cpnum][0]), RoundFloat(gF_originCP[1][cpnum][1]), RoundFloat(gF_originCP[1][cpnum][2]), cpnum, gS_map)
				gD_mysql.Query(SQLUpdateZone, sQuery, cpnum + 1)
			}
			menu.DisplayAt(param1, GetMenuSelectionPosition(), MENU_TIME_FOREVER) //https://forums.alliedmods.net/showthread.php?p=2091775
		}
		case MenuAction_Cancel: // trikz redux menuaction end
		{
			gB_DrawZone[param1] = false //idea from expert zone.
			switch(param2)
			{
				case MenuCancel_ExitBack: //https://cc.bingj.com/cache.aspx?q=ExitBackButton+sourcemod&d=4737211702971338&mkt=en-WW&setlang=en-US&w=wg9m5FNl3EpqPBL0vTge58piA8n5NsLz#L125
					ZoneEditor(param1)
			}
		}
		case MenuAction_Display:
			gB_DrawZone[param1] = true
	}
}

void SQLUpdateZone(Database db, DBResultSet results, const char[] error, any data)
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

//https://forums.alliedmods.net/showthread.php?t=261378

Action cmd_createcp(int args)
{
	gD_mysql.Query(SQLCreateCPTable, "CREATE TABLE IF NOT EXISTS cp (id INT AUTO_INCREMENT, cpnum INT, cpx INT, cpy INT, cpz INT, cpx2 INT, cpy2 INT, cpz2 INT, map VARCHAR(192), PRIMARY KEY(id))")
}

void SQLCreateCPTable(Database db, DBResultSet results, const char[] error, any data)
{
	PrintToServer("CP table successfuly created.")
}

Action cmd_createtier(int args)
{
	gD_mysql.Query(SQLCreateTierTable, "CREATE TABLE IF NOT EXISTS tier (id INT AUTO_INCREMENT, tier INT, map VARCHAR(192), PRIMARY KEY(id))")
}

void SQLCreateTierTable(Database db, DBResultSet results, const char[] error, any data)
{
	PrintToServer("Tier table successfuly created.")
}

void CPSetup(int client)
{
	gI_cpCount = 0
	char sQuery[512]
	for(int i = 1; i <= 10; i++)
	{
		Format(sQuery, 512, "SELECT cpx, cpy, cpz, cpx2, cpy2, cpz2 FROM cp WHERE cpnum = %i AND map = '%s' LIMIT 1", i, gS_map)
		DataPack dp = new DataPack()
		dp.WriteCell(client ? GetClientSerial(client) : 0)
		dp.WriteCell(i)
		gD_mysql.Query(SQLCPSetup, sQuery, dp)
	}
}

void SQLCPSetup(Database db, DBResultSet results, const char[] error, DataPack dp)
{
	dp.Reset()
	int client = GetClientFromSerial(dp.ReadCell())
	int cp = dp.ReadCell()
	if(results.FetchRow())
	{
		gF_originCP[0][cp][0] = results.FetchFloat(0)
		gF_originCP[0][cp][1] = results.FetchFloat(1)
		gF_originCP[0][cp][2] = results.FetchFloat(2)
		gF_originCP[1][cp][0] = results.FetchFloat(3)
		gF_originCP[1][cp][1] = results.FetchFloat(4)
		gF_originCP[1][cp][2] = results.FetchFloat(5)
		if(!gB_isDevmap)
			createcp(cp)
		gI_cpCount++
	}
	if(cp == 10)
	{
		if(client)
			ZoneEditor2(client)
		if(!gB_haveZone[2])
			gB_haveZone[2] = true
		if(!gB_isDevmap)
			for(int i = 1; i <= MaxClients; i++)
				if(IsClientInGame(i))
					OnClientPutInServer(i)
	}
}

void createcp(int cpnum)
{
	char sTriggerName[64]
	Format(sTriggerName, 64, "fakeexpert_cp%i", cpnum)
	int entity = CreateEntityByName("trigger_multiple")
	DispatchKeyValue(entity, "spawnflags", "1") //https://github.com/shavitush/bhoptimer
	DispatchKeyValue(entity, "wait", "0")
	DispatchKeyValue(entity, "targetname", sTriggerName)
	DispatchSpawn(entity)
	SetEntityModel(entity, "models/player/t_arctic.mdl")
	//https://stackoverflow.com/questions/4355894/how-to-get-center-of-set-of-points-using-python
	gF_center[cpnum + 1][0] = (gF_originCP[1][cpnum][0] + gF_originCP[0][cpnum][0]) / 2.0
	gF_center[cpnum + 1][1] = (gF_originCP[1][cpnum][1] + gF_originCP[0][cpnum][1]) / 2.0
	gF_center[cpnum + 1][2] = (gF_originCP[1][cpnum][2] + gF_originCP[0][cpnum][2]) / 2.0
	TeleportEntity(entity, gF_center[cpnum + 1], NULL_VECTOR, NULL_VECTOR) //Thanks to https://amx-x.ru/viewtopic.php?f=14&t=15098 http://world-source.ru/forum/102-3743-1
	float mins[3]
	float maxs[3]
	for(int i = 0; i <= 1; i++)
	{
		mins[i] = (gF_originCP[0][cpnum][i] - gF_originCP[1][cpnum][i]) / 2.0
		if(mins[i] > 0.0)
			mins[i] *= -1.0
		maxs[i] = (gF_originCP[0][cpnum][i] - gF_originCP[1][cpnum][i]) / 2.0
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
	gD_mysql.Query(SQLCreateUserTable, "CREATE TABLE IF NOT EXISTS users (id INT AUTO_INCREMENT, username VARCHAR(64), steamid INT, firstjoin INT, lastjoin INT, points INT, PRIMARY KEY(id))")
}

void SQLCreateUserTable(Database db, DBResultSet results, const char[] error, any data)
{
	PrintToServer("Successfuly created user table.")
}

Action cmd_createrecords(int args)
{
	gD_mysql.Query(SQLRecordsTable, "CREATE TABLE IF NOT EXISTS records (id INT AUTO_INCREMENT, playerid INT, time FLOAT, finishes INT, tries INT, cp1 FLOAT, cp2 FLOAT, cp3 FLOAT, cp4 FLOAT, cp5 FLOAT, cp6 FLOAT, cp7 FLOAT, cp8 FLOAT, cp9 FLOAT, cp10 FLOAT, points INT, map VARCHAR(192), date INT, PRIMARY KEY(id))")
}

void SQLRecordsTable(Database db, DBResultSet results, const char[] error, any data)
{
	PrintToServer("Successfuly created records table.")
}

Action SDKEndTouch(int entity, int other)
{
	if(0 < other <= MaxClients && gB_readyToStart[other] && !IsFakeClient(other))
	{
		gB_state[other] = true
		//gB_state[gI_partner[other]] = true
		//gB_mapFinished[other] = false
		//gB_mapFinished[gI_partner[other]] = false
		gF_TimeStart[other] = GetEngineTime()
		//gF_TimeStart[gI_partner[other]] = GetEngineTime()
		gB_readyToStart[other] = false
		//gB_readyToStart[gI_partner[other]] = false
		gH_timerClanTag[other] = CreateTimer(0.1, timer_clantag, other, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE)
		//gH_timerClanTag[gI_partner[other]] = CreateTimer(0.1, timer_clantag, gI_partner[other], TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE)
		for(int i = 1; i <= gI_cpCount; i++)
		{
			gB_cp[i][other] = false
			//gB_cp[i][gI_partner[other]] = false
			gB_cpLock[i][other] = false
			//gB_cpLock[i][gI_partner[other]] = false
		}
	}
}

Action SDKStartTouch(int entity, int other)
{
	if(0 < other <= MaxClients && !gB_isDevmap && !IsFakeClient(other))
	{
		char sTrigger[32]
		GetEntPropString(entity, Prop_Data, "m_iName", sTrigger, 32)
		if(StrEqual(sTrigger, "fakeexpert_startzone"))
		{
			Restart(other) //expert zone idea.
			//Restart(gI_partner[other])
		}
		if(StrEqual(sTrigger, "fakeexpert_endzone"))
		{
			//gB_mapFinished[other] = true
			if(gB_state[other])
			{
				char sQuery[512]
				int playerid = GetSteamAccountID(other)
				//int partnerid = GetSteamAccountID(gI_partner[other])
				int personalHour = (RoundToFloor(gF_Time[other]) / 3600) % 24 //https://forums.alliedmods.net/archive/index.php/t-187536.html
				int personalMinute = (RoundToFloor(gF_Time[other]) / 60) % 60
				int personalSecond = RoundToFloor(gF_Time[other]) % 60
				if(gF_ServerRecord)
				{
					//if(gF_mateRecord[other])
					//{
					if(gF_ServerRecord > gF_Time[other])
					{
						float timeDiff = gF_ServerRecord - gF_Time[other]
						int srHour = (RoundToFloor(timeDiff) / 3600) % 24
						int srMinute = (RoundToFloor(timeDiff) / 60) % 60
						int srSecond = RoundToFloor(timeDiff) % 60
						PrintToChatAll("\x077CFC00New server record!")
						PrintToChatAll("\x01%N finished map in \x077CFC00%02.i:%02.i:%02.i \x01(SR \x077CFC00-%02.i:%02.i:%02.i\x01)", other, personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
						FinishMSG(other, false, true, false, false, false, 0, personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
						//FinishMSG(gI_partner[other], false, true, false, false, false, 0, personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
						Format(sQuery, 512, "UPDATE records SET time = %f, finishes = finishes + 1, cp1 = %f, cp2 = %f, cp3 = %f, cp4 = %f, cp5 = %f, cp6 = %f, cp7 = %f, cp8 = %f, cp9 = %f, cp10 = %f, date = %i WHERE playerid = %i AND map = '%s' ORDER BY time LIMIT 1", gF_Time[other], gF_TimeCP[1][other], gF_TimeCP[2][other], gF_TimeCP[3][other], gF_TimeCP[4][other], gF_TimeCP[5][other], gF_TimeCP[6][other], gF_TimeCP[7][other], gF_TimeCP[8][other], gF_TimeCP[9][other], gF_TimeCP[10][other], GetTime(), playerid, gS_map)
						gD_mysql.Query(SQLUpdateRecord, sQuery)
						gF_haveRecord[other] = gF_Time[other]
						//gF_haveRecord[gI_partner[other]] = gF_Time[other]
						//gF_mateRecord[other] = gF_Time[other]
						//gF_mateRecord[gI_partner[other]] = gF_Time[other]
						gB_isServerRecord = true
						gF_ServerRecord = gF_Time[other]
						CreateTimer(60.0, timer_sourcetv, _, TIMER_FLAG_NO_MAPCHANGE)
						Call_StartForward(gH_record)
						Call_PushCell(other)
						Call_PushFloat(gF_Time[other])
						Call_Finish()
					}
					else if((gF_ServerRecord < gF_Time[other] > gF_haveRecord[other]) && gF_haveRecord[other])
					{
						float timeDiff = gF_Time[other] - gF_ServerRecord
						int srHour = (RoundToFloor(timeDiff) / 3600) % 24
						int srMinute = (RoundToFloor(timeDiff) / 60) % 60
						int srSecond = RoundToFloor(timeDiff) % 60
						PrintToChatAll("\x01%N finished map in \x077CFC00%02.i:%02.i:%02.i \x01(SR \x07FF0000+%02.i:%02.i:%02.i\x01)", other, personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
						FinishMSG(other, false, false, false, false, false, 0, personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
						//FinishMSG(gI_partner[other], false, false, false, false, false, 0, personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
						Format(sQuery, 512, "UPDATE records SET finishes = finishes + 1 WHERE playerid = %i AND map = '%s' LIMIT 1", playerid, gS_map)
						gD_mysql.Query(SQLUpdateRecord, sQuery)
					}
					else if(gF_ServerRecord < gF_Time[other] < gF_haveRecord[other])
					{
						float timeDiff = gF_Time[other] - gF_ServerRecord
						int srHour = (RoundToFloor(timeDiff) / 3600) % 24
						int srMinute = (RoundToFloor(timeDiff) / 60) % 60
						int srSecond = RoundToFloor(timeDiff) % 60
						PrintToChatAll("\x01%N finished map in \x077CFC00%02.i:%02.i:%02.i \x01(SR \x07FF0000+%02.i:%02.i:%02.i\x01)", other, personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
						FinishMSG(other, false, false, false, false, false, 0, personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
						//FinishMSG(gI_partner[other], false, false, false, false, false, 0, personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
						Format(sQuery, 512, "UPDATE records SET time = %f, finishes = finishes + 1, cp1 = %f, cp2 = %f, cp3 = %f, cp4 = %f, cp5 = %f, cp6 = %f, cp7 = %f, cp8 = %f, cp9 = %f, cp10 = %f, date = %i WHERE playerid = %i AND map = '%s' LIMIT 1", gF_Time[other], gF_TimeCP[1][other], gF_TimeCP[2][other], gF_TimeCP[3][other], gF_TimeCP[4][other], gF_TimeCP[5][other], gF_TimeCP[6][other], gF_TimeCP[7][other], gF_TimeCP[8][other], gF_TimeCP[9][other], gF_TimeCP[10][other], GetTime(), playerid, gS_map)
						gD_mysql.Query(SQLUpdateRecord, sQuery)
						if(gF_haveRecord[other] > gF_Time[other])
							gF_haveRecord[other] = gF_Time[other]
						//if(gF_haveRecord[gI_partner[other]] > gF_Time[other])
						//	gF_haveRecord[gI_partner[other]] = gF_Time[other]
						//if(gF_mateRecord[other] > gF_Time[other])
						//{
							//gF_mateRecord[other] = gF_Time[other]
							//gF_mateRecord[gI_partner[other]] = gF_Time[other]
						//}					
					}
					//}
					/*else
					{
						if(gF_ServerRecord > gF_Time[other])
						{
							float timeDiff = gF_ServerRecord - gF_Time[other]
							int srHour = (RoundToFloor(timeDiff) / 3600) % 24
							int srMinute = (RoundToFloor(timeDiff) / 60) % 60
							int srSecond = RoundToFloor(timeDiff) % 60
							PrintToChatAll("\x077CFC00New server record!")
							PrintToChatAll("\x01%N finished map in \x077CFC00%02.i:%02.i:%02.i \x01(SR \x077CFC00-%02.i:%02.i:%02.i\x01)", other, personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
							FinishMSG(other, false, true, false, false, false, 0, personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
							//FinishMSG(gI_partner[other], false, true, false, false, false, 0, personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
							Format(sQuery, 512, "INSERT INTO records (playerid, time, finishes, tries, cp1, cp2, cp3, cp4, cp5, cp6, cp7, cp8, cp9, cp10, map, date) VALUES (%i, %f, 1, 1, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, '%s', %i)", playerid, gF_Time[other], gF_TimeCP[1][other], gF_TimeCP[2][other], gF_TimeCP[3][other], gF_TimeCP[4][other], gF_TimeCP[5][other], gF_TimeCP[6][other], gF_TimeCP[7][other], gF_TimeCP[8][other], gF_TimeCP[9][other], gF_TimeCP[10][other], gS_map, GetTime())
							gD_mysql.Query(SQLInsertRecord, sQuery)
							gF_haveRecord[other] = gF_Time[other]
							//gF_haveRecord[gI_partner[other]] = gF_Time[other]
							//gF_mateRecord[other] = gF_Time[other]
							//gF_mateRecord[gI_partner[other]] = gF_Time[other]
							gB_isServerRecord = true
							gF_ServerRecord = gF_Time[other]
							CreateTimer(60.0, timer_sourcetv, _, TIMER_FLAG_NO_MAPCHANGE)
						}
						else
						{
							float timeDiff = gF_Time[other] - gF_ServerRecord
							int srHour = (RoundToFloor(timeDiff) / 3600) % 24
							int srMinute = (RoundToFloor(timeDiff) / 60) % 60
							int srSecond = RoundToFloor(timeDiff) % 60
							PrintToChatAll("\x01%N finished map in \x077CFC00%02.i:%02.i:%02.i \x01(SR \x07FF0000+%02.i:%02.i:%02.i\x01)", other, personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
							FinishMSG(other, false, false, false, false, false, 0, personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
							//FinishMSG(gI_partner[other], false, false, false, false, false, 0, personalHour, personalMinute, personalSecond, srHour, srMinute, srSecond)
							Format(sQuery, 512, "INSERT INTO records (playerid, time, finishes, tries, cp1, cp2, cp3, cp4, cp5, cp6, cp7, cp8, cp9, cp10, map, date) VALUES (%i, %f, 1, 1, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, '%s', %i)", playerid, gF_Time[other], gF_TimeCP[1][other], gF_TimeCP[2][other], gF_TimeCP[3][other], gF_TimeCP[4][other], gF_TimeCP[5][other], gF_TimeCP[6][other], gF_TimeCP[7][other], gF_TimeCP[8][other], gF_TimeCP[9][other], gF_TimeCP[10][other], gS_map, GetTime())
							gD_mysql.Query(SQLInsertRecord, sQuery)
							if(!gF_haveRecord[other])
								gF_haveRecord[other] = gF_Time[other]
							//if(!gF_haveRecord[gI_partner[other]])
							//	gF_haveRecord[gI_partner[other]] = gF_Time[other]
							//gF_mateRecord[other] = gF_Time[other]
							//gF_mateRecord[gI_partner[other]] = gF_Time[other]
						}
					}*/
					for(int i = 1; i <= gI_cpCount; i++)
					{
						if(gB_cp[i][other])
						{
							int srCPHour = (RoundToFloor(gF_timeDiffCP[i][other]) / 3600) % 24
							int srCPMinute = (RoundToFloor(gF_timeDiffCP[i][other]) / 60) % 60
							int srCPSecond = RoundToFloor(gF_timeDiffCP[i][other]) % 60
							if(gF_TimeCP[i][other] < gF_srCPTime[i])
								PrintToChatAll("\x01%i. Checkpoint: \x077CFC00-%02.i:%02.i:%02.i", i, srCPHour, srCPMinute, srCPSecond)
							else
								PrintToChatAll("\x01%i. Checkpoint: \x07FF0000+%02.i:%02.i:%02.i", i, srCPHour, srCPMinute, srCPSecond)
						}
					}
				}
				else
				{
					gF_ServerRecord = gF_Time[other]
					gF_haveRecord[other] = gF_Time[other]
					//gF_haveRecord[gI_partner[other]] = gF_Time[other]
					//gF_mateRecord[other] = gF_Time[other]
					//gF_mateRecord[gI_partner[other]] = gF_Time[other]
					PrintToChatAll("\x077CFC00New server record!")
					PrintToChatAll("\x01%N finished map in \x077CFC00%02.i:%02.i:%02.i \x01(SR \x07FF0000+00:00:00\x01)", other, personalHour, personalMinute, personalSecond)
					FinishMSG(other, true, false, false, false, false, 0, personalHour, personalMinute, personalSecond)
					//FinishMSG(gI_partner[other], true, false, false, false, false, 0, personalHour, personalMinute, personalSecond)
					for(int i = 1; i <= gI_cpCount; i++)
						if(gB_cp[i][other])
							PrintToChatAll("\x01%i. Checkpoint: \x07FF0000+00:00:00", i)
					gB_isServerRecord = true
					CreateTimer(60.0, timer_sourcetv, _, TIMER_FLAG_NO_MAPCHANGE) //https://forums.alliedmods.net/showthread.php?t=191615
					Format(sQuery, 512, "INSERT INTO records (playerid, time, finishes, tries, cp1, cp2, cp3, cp4, cp5, cp6, cp7, cp8, cp9, cp10, map, date) VALUES (%i, %f, 1, 1, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, '%s', %i)", playerid, gF_Time[other], gF_TimeCP[1][other], gF_TimeCP[2][other], gF_TimeCP[3][other], gF_TimeCP[4][other], gF_TimeCP[5][other], gF_TimeCP[6][other], gF_TimeCP[7][other], gF_TimeCP[8][other], gF_TimeCP[9][other], gF_TimeCP[10][other], gS_map, GetTime())
					gD_mysql.Query(SQLInsertRecord, sQuery)
					Call_StartForward(gH_record)
					Call_PushCell(other)
					Call_PushFloat(gF_Time[other])
					Call_Finish()
				}
				gB_state[other] = false
				//gB_state[gI_partner[other]] = false
			}
		}
		for(int i = 1; i <= gI_cpCount; i++)
		{
			char sTrigger2[64]
			Format(sTrigger2, 64, "fakeexpert_cp%i", i)
			if(StrEqual(sTrigger, sTrigger2))
			{
				gB_cp[i][other] = true
				if(gB_cp[i][other] && !gB_cpLock[i][other])
				{
					char sQuery[512] //https://stackoverflow.com/questions/9617453 https://www.w3schools.com/sql/sql_ref_order_by.asp#:~:text=%20SQL%20ORDER%20BY%20Keyword%20%201%20ORDER,data%20returned%20in%20descending%20order.%20%20More%20
					int playerid = GetSteamAccountID(other)
					//int partnerid = GetSteamAccountID(gI_partner[other])
					if(!gB_cpLock[1][other] && gF_haveRecord[other])
					{
						Format(sQuery, 512, "UPDATE records SET tries = tries + 1 WHERE playerid = %i AND map = '%s' LIMIT 1", playerid, gS_map)
						gD_mysql.Query(SQLSetTries, sQuery)
					}
					gB_cpLock[i][other] = true
					//gB_cpLock[i][gI_partner[other]] = true
					gF_TimeCP[i][other] = gF_Time[other]
					//gF_TimeCP[i][gI_partner[other]] = gF_Time[other]
					Format(sQuery, 512, "SELECT cp%i FROM records LIMIT 1", i)
					DataPack dp = new DataPack()
					dp.WriteCell(GetClientSerial(other))
					dp.WriteCell(i)
					gD_mysql.Query(SQLCPSelect, sQuery, dp)
				}
			}
		}
	}
}

void FinishMSG(int client, bool firstServerRecord, bool serverRecord, bool onlyCP, bool firstCPRecord, bool cpRecord, int cpnum, int personalHour, int personalMinute, personalSecond, int srHour = 0, int srMinute = 0, int srSecond = 0)
{
	if(onlyCP)
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
				ShowHudText(client, 1, "%i. CHECKPOINT RECORD!", cpnum) //https://steamuserimages-a.akamaihd.net/ugc/1788470716362427548/185302157B3F4CBF4557D0C47842C6BBD705380A/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false
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
				ShowHudText(client, 1, "CHECKPOINT: %02.i:%02.i:%02.i", personalHour, personalMinute, personalSecond) //https://steamuserimages-a.akamaihd.net/ugc/1788470716362384940/4DD466582BD1CF04366BBE6D383DD55A079936DC/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false
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
}

void SQLInsertRecord(Database db, DBResultSet results, const char[] error, any data)
{
}

Action timer_sourcetv(Handle timer)
{
	ConVar CV_sourcetv = FindConVar("tv_enable")
	bool isSourceTV = CV_sourcetv.BoolValue //https://sm.alliedmods.net/new-api/convars/__raw
	if(isSourceTV)
	{
		ServerCommand("tv_stoprecord")
		gB_isSourceTVchangedFileName = false
		CreateTimer(5.0, timer_runSourceTV, _, TIMER_FLAG_NO_MAPCHANGE)
		gB_isServerRecord = false
	}
}

Action timer_runSourceTV(Handle timer)
{
	char sOldFileName[256]
	Format(sOldFileName, 256, "%s-%s-%s.dem", gS_date, gS_time, gS_map)
	char sNewFileName[256]
	Format(sNewFileName, 256, "%s-%s-%s-ServerRecord.dem", gS_date, gS_time, gS_map)
	RenameFile(sNewFileName, sOldFileName)
	ConVar CV_sourcetv = FindConVar("tv_enable")
	bool isSourceTV = CV_sourcetv.BoolValue //https://sm.alliedmods.net/new-api/convars/__raw
	if(isSourceTV)
	{
		PrintToServer("SourceTV start recording.")
		FormatTime(gS_date, 64, "%Y-%m-%d", GetTime())
		FormatTime(gS_time, 64, "%H-%M-%S", GetTime())
		ServerCommand("tv_record %s-%s-%s", gS_date, gS_time, gS_map)
		gB_isSourceTVchangedFileName = true
	}
}

void SQLCPSelect(Database db, DBResultSet results, const char[] error, DataPack data)
{
	data.Reset()
	int other = GetClientFromSerial(data.ReadCell())
	int cpnum = data.ReadCell()
	char sQuery[512]
	if(results.FetchRow())
	{
		Format(sQuery, 512, "SELECT cp%i FROM records WHERE map = '%s' ORDER BY time LIMIT 1", cpnum, gS_map) //log help me alot with this stuff
		DataPack dp = new DataPack()
		dp.WriteCell(GetClientSerial(other))
		dp.WriteCell(cpnum)
		gD_mysql.Query(SQLCPSelect2, sQuery, dp)
	}
	else
	{
		int personalHour = (RoundToFloor(gF_Time[other]) / 3600) % 24
		int personalMinute = (RoundToFloor(gF_Time[other]) / 60) % 60
		int personalSecond = RoundToFloor(gF_Time[other]) % 60
		FinishMSG(other, false, false, true, true, false, cpnum, personalHour, personalMinute, personalSecond)
		//FinishMSG(gI_partner[other], false, false, true, true, false, cpnum, personalHour, personalMinute, personalSecond)
	}
}

void SQLCPSelect2(Database db, DBResultSet results, const char[] error, DataPack data)
{
	data.Reset()
	int other = GetClientFromSerial(data.ReadCell())
	int cpnum = data.ReadCell()
	int personalHour = (RoundToFloor(gF_Time[other]) / 3600) % 24
	int personalMinute = (RoundToFloor(gF_Time[other]) / 60) % 60
	int personalSecond = RoundToFloor(gF_Time[other]) % 60
	if(results.FetchRow())
	{
		gF_srCPTime[cpnum] = results.FetchFloat(0)
		if(gF_TimeCP[cpnum][other] < gF_srCPTime[cpnum])
		{
			gF_timeDiffCP[cpnum][other] = gF_srCPTime[cpnum] - gF_TimeCP[cpnum][other]
			//gF_timeDiffCP[cpnum][gI_partner[other]] = gF_srCPTime[cpnum] - gF_TimeCP[cpnum][other]
			int srCPHour = (RoundToFloor(gF_timeDiffCP[cpnum][other]) / 3600) % 24
			int srCPMinute = (RoundToFloor(gF_timeDiffCP[cpnum][other]) / 60) % 60
			int srCPSecond = RoundToFloor(gF_timeDiffCP[cpnum][other]) % 60
			FinishMSG(other, false, false, true, false, true, cpnum, personalHour, personalMinute, personalSecond, srCPHour, srCPMinute, srCPSecond)
			//FinishMSG(gI_partner[other], false, false, true, false, true, cpnum, personalHour, personalMinute, personalSecond, srCPHour, srCPMinute, srCPSecond)
		}
		else
		{
			gF_timeDiffCP[cpnum][other] = gF_TimeCP[cpnum][other] - gF_srCPTime[cpnum]
			//gF_timeDiffCP[cpnum][gI_partner[other]] = gF_TimeCP[cpnum][other] - gF_srCPTime[cpnum]
			int srCPHour = (RoundToFloor(gF_timeDiffCP[cpnum][other]) / 3600) % 24
			int srCPMinute = (RoundToFloor(gF_timeDiffCP[cpnum][other]) / 60) % 60
			int srCPSecond = RoundToFloor(gF_timeDiffCP[cpnum][other]) % 60
			FinishMSG(other, false, false, true, false, false, cpnum, personalHour, personalMinute, personalSecond, srCPHour, srCPMinute, srCPSecond)
			//FinishMSG(gI_partner[other], false, false, true, false, false, cpnum, personalHour, personalMinute, personalSecond, srCPHour, srCPMinute, srCPSecond)
		}
	}
	else
	{
		FinishMSG(other, false, false, true, true, false, cpnum, personalHour, personalMinute, personalSecond)
		//FinishMSG(gI_partner[other], false, false, true, true, false, cpnum, personalHour, personalMinute, personalSecond)
	}
}

void SQLSetTries(Database db, DBResultSet results, const char[] error, any data)
{
}

Action cmd_createzones(int args)
{
	gD_mysql.Query(SQLCreateZonesTable, "CREATE TABLE IF NOT EXISTS zones (id INT AUTO_INCREMENT, map VARCHAR(128), type INT, possition_x INT, possition_y INT, possition_z INT, possition_x2 INT, possition_y2 INT, possition_z2 INT, PRIMARY KEY (id))") //https://stackoverflow.com/questions/8114535/mysql-1075-incorrect-table-definition-autoincrement-vs-another-key
}

void SQLConnect(Database db, const char[] error, any data)
{
	if(!db)
	{
		PrintToServer("Failed to connect to database")
		return
	}
	PrintToServer("Successfuly connected to database.") //https://hlmod.ru/threads/sourcepawn-urok-13-rabota-s-bazami-dannyx-mysql-sqlite.40011/
	gD_mysql = db
	gD_mysql.SetCharset("utf8") //https://github.com/shavitush/bhoptimer/blob/master/addons/sourcemod/scripting/shavit-core.sp#L2883
	ForceZonesSetup() //https://sm.alliedmods.net/new-api/dbi/__raw
	gB_passDB = true //https://github.com/shavitush/bhoptimer/blob/master/addons/sourcemod/scripting/shavit-stats.sp#L199
	char sQuery[512]
	Format(sQuery, 512, "SELECT time FROM records WHERE map = '%s' ORDER BY time LIMIT 1", gS_map)
	gD_mysql.Query(SQLGetServerRecord, sQuery)
	RecalculatePoints()
}

void ForceZonesSetup()
{
	char sQuery[512]
	Format(sQuery, 512, "SELECT possition_x, possition_y, possition_z, possition_x2, possition_y2, possition_z2 FROM zones WHERE map = '%s' AND type = 0 LIMIT 1", gS_map)
	gD_mysql.Query(SQLSetZoneStart, sQuery)
}

void SQLSetZoneStart(Database db, DBResultSet results, const char[] error, any data)
{
	if(results.FetchRow())
	{
		gF_originStartZone[0][0] = results.FetchFloat(0)
		gF_originStartZone[0][1] = results.FetchFloat(1)
		gF_originStartZone[0][2] = results.FetchFloat(2)
		gF_originStartZone[1][0] = results.FetchFloat(3)
		gF_originStartZone[1][1] = results.FetchFloat(4)
		gF_originStartZone[1][2] = results.FetchFloat(5)
		createstart()
		char sQuery[512]
		Format(sQuery, 512, "SELECT possition_x, possition_y, possition_z, possition_x2, possition_y2, possition_z2 FROM zones WHERE map = '%s' AND type = 1 LIMIT 1", gS_map)
		gD_mysql.Query(SQLSetZoneEnd, sQuery)
	}
}

void SQLSetZoneEnd(Database db, DBResultSet results, const char[] error, any data)
{
	if(results.FetchRow())
	{
		gF_originEndZone[0][0] = results.FetchFloat(0)
		gF_originEndZone[0][1] = results.FetchFloat(1)
		gF_originEndZone[0][2] = results.FetchFloat(2)
		gF_originEndZone[1][0] = results.FetchFloat(3)
		gF_originEndZone[1][1] = results.FetchFloat(4)
		gF_originEndZone[1][2] = results.FetchFloat(5)
		createend()
	}
}

void SQLCreateZonesTable(Database db, DBResultSet results, const char[] error, any data)
{
	PrintToServer("Zones table is successfuly created.")
}

void DrawZone(int client, float life)
{
	float start[12][3]
	float end[12][3]
	start[0][0] = (gF_originStartZone[0][0] < gF_originStartZone[1][0]) ? gF_originStartZone[0][0] : gF_originStartZone[1][0]
	start[0][1] = (gF_originStartZone[0][1] < gF_originStartZone[1][1]) ? gF_originStartZone[0][1] : gF_originStartZone[1][1]
	start[0][2] = (gF_originStartZone[0][2] < gF_originStartZone[1][2]) ? gF_originStartZone[0][2] : gF_originStartZone[1][2]
	start[0][2] += 3.0
	end[0][0] = (gF_originStartZone[0][0] > gF_originStartZone[1][0]) ? gF_originStartZone[0][0] : gF_originStartZone[1][0]
	end[0][1] = (gF_originStartZone[0][1] > gF_originStartZone[1][1]) ? gF_originStartZone[0][1] : gF_originStartZone[1][1]
	end[0][2] = (gF_originStartZone[0][2] > gF_originStartZone[1][2]) ? gF_originStartZone[0][2] : gF_originStartZone[1][2]
	end[0][2] += 3.0
	start[1][0] = (gF_originEndZone[0][0] < gF_originEndZone[1][0]) ? gF_originEndZone[0][0] : gF_originEndZone[1][0]
	start[1][1] = (gF_originEndZone[0][1] < gF_originEndZone[1][1]) ? gF_originEndZone[0][1] : gF_originEndZone[1][1]
	start[1][2] = (gF_originEndZone[0][2] < gF_originEndZone[1][2]) ? gF_originEndZone[0][2] : gF_originEndZone[1][2]
	start[1][2] += 3.0
	end[1][0] = (gF_originEndZone[0][0] > gF_originEndZone[1][0]) ? gF_originEndZone[0][0] : gF_originEndZone[1][0]
	end[1][1] = (gF_originEndZone[0][1] > gF_originEndZone[1][1]) ? gF_originEndZone[0][1] : gF_originEndZone[1][1]
	end[1][2] = (gF_originEndZone[0][2] > gF_originEndZone[1][2]) ? gF_originEndZone[0][2] : gF_originEndZone[1][2]
	end[1][2] += 3.0
	int zones = 1
	if(gI_cpCount)
	{
		zones += gI_cpCount
		for(int i = 2; i <= zones; i++)
		{
			int cpnum = i - 1
			start[i][0] = (gF_originCP[0][cpnum][0] < gF_originCP[1][cpnum][0]) ? gF_originCP[0][cpnum][0] : gF_originCP[1][cpnum][0]
			start[i][1] = (gF_originCP[0][cpnum][1] < gF_originCP[1][cpnum][1]) ? gF_originCP[0][cpnum][1] : gF_originCP[1][cpnum][1]
			start[i][2] = (gF_originCP[0][cpnum][2] < gF_originCP[1][cpnum][2]) ? gF_originCP[0][cpnum][2] : gF_originCP[1][cpnum][2]
			start[i][2] += 3.0
			end[i][0] = (gF_originCP[0][cpnum][0] > gF_originCP[1][cpnum][0]) ? gF_originCP[0][cpnum][0] : gF_originCP[1][cpnum][0]
			end[i][1] = (gF_originCP[0][cpnum][1] > gF_originCP[1][cpnum][1]) ? gF_originCP[0][cpnum][1] : gF_originCP[1][cpnum][1]
			end[i][2] = (gF_originCP[0][cpnum][2] > gF_originCP[1][cpnum][2]) ? gF_originCP[0][cpnum][2] : gF_originCP[1][cpnum][2]
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
			TE_SetupBeamPoints(corners[i][j], corners[i][k], gI_zoneModel[modelType], 0, 0, 0, life, 3.0, 3.0, 0, 0.0, {0, 0, 0, 0}, 10) //https://github.com/shavitush/bhoptimer/blob/master/addons/sourcemod/scripting/shavit-zones.sp#L3050
			TE_SendToClient(client)
		}
	}
}

void ResetFactory(int client)
{
	gB_readyToStart[client] = true
	//gF_Time[client] = 0.0
	gB_state[client] = false
}

public Action OnPlayerRunCmd(int client, int& buttons, int& impulse, float vel[3], float angles[3], int& weapon, int& subtype, int& cmdnum, int& tickcount, int& seed, int mouse[2])
{
	//gI_entityFlags[client] = GetEntityFlags(client)
	//gI_entityButtons[client] = buttons
	if(!IsFakeClient(client))
	{
		if(buttons & IN_JUMP && IsPlayerAlive(client) && !(GetEntityFlags(client) & FL_ONGROUND) && GetEntProp(client, Prop_Data, "m_nWaterLevel") <= 1 && !(GetEntityMoveType(client) & MOVETYPE_LADDER)) //https://sm.alliedmods.net/new-api/entity_prop_stocks/GetEntityFlags https://forums.alliedmods.net/showthread.php?t=127948
			buttons &= ~IN_JUMP //https://stackoverflow.com/questions/47981/how-do-you-set-clear-and-toggle-a-single-bit https://forums.alliedmods.net/showthread.php?t=192163
		//Timer
		if(gB_state[client])
		{
			gF_Time[client] = GetEngineTime() - gF_TimeStart[client]
			//https://forums.alliedmods.net/archive/index.php/t-23912.html ShAyA format OneEyed format second
			int hour = (RoundToFloor(gF_Time[client]) / 3600) % 24 //https://forums.alliedmods.net/archive/index.php/t-187536.html
			int minute = (RoundToFloor(gF_Time[client]) / 60) % 60
			int second = RoundToFloor(gF_Time[client]) % 60
			Format(gS_clanTag[client][1], 256, "%02.i:%02.i:%02.i", hour, minute, second)
			if(!IsPlayerAlive(client))
			{
				ResetFactory(client)
				//ResetFactory(gI_partner[client])
			}
		}
		/*if(gI_skyBoost[client])
		{
			if(gI_skyBoost[client] == 2)
			{
				TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, gF_skyVel[client])
				gI_skyBoost[client] = 0
			}
			else
				gI_skyBoost[client] = 2
		}
		if(gI_boost[client])
		{
			float velocity[3]
			if(gI_boost[client] == 2)
			{
				velocity[0] = gF_velClient[client][0] - gF_velEntity[client][0]
				velocity[1] = gF_velClient[client][1] - gF_velEntity[client][1]
				velocity[2] = gF_velEntity[client][2]
				TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, velocity)
				gI_boost[client] = 3
			}
			else if(gI_boost[client] == 3) // let make loop finish and come back to here.
			{
				GetEntPropVector(client, Prop_Data, "m_vecAbsVelocity", velocity)
				if(gB_groundBoost[client])
				{
					velocity[0] += gF_velEntity[client][0]
					velocity[1] += gF_velEntity[client][1]
					velocity[2] += gF_velEntity[client][2]
				}
				else
				{
					velocity[0] += gF_velEntity[client][0] * 0.135
					velocity[1] += gF_velEntity[client][1] * 0.135
				}
				TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, velocity) //https://github.com/tengulawl/scripting/blob/master/boost-fix.sp#L171-L192
				gI_boost[client] = 0
				gF_mlsVel[client][1][0] = velocity[0]
				gF_mlsVel[client][1][1] = velocity[1]
				MLStats(client)
			}
		}
		if(IsPlayerAlive(client) && (gI_partner[client] || gB_isDevmap))
		{
			if(buttons & IN_USE)
			{
				if(GetEntProp(client, Prop_Data, "m_afButtonPressed") & IN_USE)
				{
					gF_pingTime[client] = GetEngineTime()
					gB_pingLock[client] = false
				}
			}
			else
				if(!gB_pingLock[client])
					gB_pingLock[client] = true
			if(!gB_pingLock[client] && GetEngineTime() - gF_pingTime[client] > 0.7)
			{
				gB_pingLock[client] = true
				if(gI_pingModel[client])
				{
					if(IsValidEntity(gI_pingModel[client]))
						RemoveEntity(gI_pingModel[client])
					gI_pingModel[client] = 0
					KillTimer(gH_timerPing[client])
				}
				gI_pingModel[client] = CreateEntityByName("prop_dynamic_override") //https://www.bing.com/search?q=prop_dynamic_override&cvid=0babe0a3c6cd43aa9340fa9c3c2e0f78&aqs=edge..69i57.409j0j1&pglt=299&FORM=ANNTA1&PC=U531
				SetEntityModel(gI_pingModel[client], "models/fakeexpert/pingtool/pingtool.mdl")
				DispatchSpawn(gI_pingModel[client])
				SetEntProp(gI_pingModel[client], Prop_Data, "m_fEffects", 16) //https://pastebin.com/SdNC88Ma https://developer.valvesoftware.com/wiki/Effect_flags
				float start[3]
				float angle[3]
				float end[3]
				GetClientEyePosition(client, start)
				GetClientEyeAngles(client, angle)
				GetAngleVectors(angle, angle, NULL_VECTOR, NULL_VECTOR)
				for(int i = 0; i <= 2; i++)
				{
					angle[i] *= 8192.0
					end[i] = start[i] + angle[i] //thanks to rumour for pingtool original code.
				}
				TR_TraceRayFilter(start, end, MASK_SOLID, RayType_EndPoint, TraceEntityFilterPlayer, client)
				if(TR_DidHit())
				{
					TR_GetEndPosition(end)
					float normal[3]
					TR_GetPlaneNormal(null, normal) //https://github.com/alliedmodders/sourcemod/commit/1328984e0b4cb2ca0ee85eaf9326ab97df910483
					GetVectorAngles(normal, normal)
					GetAngleVectors(normal, angle, NULL_VECTOR, NULL_VECTOR)
					for(int i = 0; i <= 2; i++)
						end[i] += angle[i]
					normal[0] -= 270.0
					SetEntPropVector(gI_pingModel[client], Prop_Data, "m_angRotation", normal)
				}
				if(gB_color[client])
					SetEntityRenderColor(gI_pingModel[client], gI_color[client][0], gI_color[client][1], gI_color[client][2], 255)
				TeleportEntity(gI_pingModel[client], end, NULL_VECTOR, NULL_VECTOR)
				//https://forums.alliedmods.net/showthread.php?p=1080444
				if(gB_color[client])
				{
					int color[4]
					for(int i = 0; i <= 2; i++)
						color[i] = gI_color[client][i]
					color[3] = 255
					TE_SetupBeamPoints(start, end, gI_laserBeam, 0, 0, 0, 0.5, 1.0, 1.0, 0, 0.0, color, 0)
				}
				else
					TE_SetupBeamPoints(start, end, gI_laserBeam, 0, 0, 0, 0.5, 1.0, 1.0, 0, 0.0, {255, 255, 255, 255}, 0)
				if(LibraryExists("fakeexpert-entityfilter"))
				{
					SDKHook(gI_pingModel[client], SDKHook_SetTransmit, SDKSetTransmitPing)
					gI_pingModelOwner[gI_pingModel[client]] = client
					int clients[MAXPLAYERS + 1]
					int count
					for(int i = 1; i <= MaxClients; i++)
						if(IsClientInGame(i))
							if(gI_partner[client] == gI_partner[gI_partner[i]] || i == client)
								clients[count++] = i
					TE_Send(clients, count)
					EmitSound(clients, count, "fakeexpert/pingtool/click.wav", client)
				}
				else
				{
					TE_SendToAll()
					EmitSoundToAll("fakeexpert/pingtool/click.wav", client)
				}
				gH_timerPing[client] = CreateTimer(3.0, timer_removePing, client, TIMER_FLAG_NO_MAPCHANGE)
			}
		}
		if(!gCV_turboPhysics.BoolValue)
		{
			if(IsPlayerAlive(client))
			{
				if(gB_block[client] && GetEntProp(client, Prop_Data, "m_CollisionGroup") != 5)
					SetEntProp(client, Prop_Data, "m_CollisionGroup", 5)
				else if(!gB_block[client] && GetEntProp(client, Prop_Data, "m_CollisionGroup") != 2)
					SetEntProp(client, Prop_Data, "m_CollisionGroup", 2)
			}
		}*/
		if(gB_DrawZone[client])
		{
			if(GetEngineTime() - gF_engineTime >= 0.1)
			{
				gF_engineTime = GetEngineTime()
				for(int i = 1; i <= MaxClients; i++)
					if(IsClientInGame(i))
						DrawZone(i, 0.1)
			}
		}
		/*if(IsClientObserver(client) && GetEntProp(client, Prop_Data, "m_afButtonPressed") & IN_USE) //make able to swtich wtih E to the partner via spectate.
		{
			int observerTarget = GetEntPropEnt(client, Prop_Data, "m_hObserverTarget")
			int observerMode = GetEntProp(client, Prop_Data, "m_iObserverMode")
			if(0 < observerTarget <= MaxClients && gI_partner[observerTarget] && IsPlayerAlive(gI_partner[observerTarget]) && observerMode < 7)
				SetEntPropEnt(client, Prop_Data, "m_hObserverTarget", gI_partner[observerTarget])
		}*/
		if(GetEngineTime() - gF_hudTime[client] >= 0.1)
		{
			gF_hudTime[client] = GetEngineTime()
			Hud(client)
		}
	}
	/*if(GetEntityFlags(client) & FL_ONGROUND)
	{
		if(gI_mlsCount[client])
		{
			int groundEntity = GetEntPropEnt(client, Prop_Data, "m_hGroundEntity")
			char sClass[32]
			if(IsValidEntity(groundEntity))
				GetEntityClassname(groundEntity, sClass, 32)
			if(!(StrEqual(sClass, "flashbang_projectile")))
			{
				GetClientAbsOrigin(client, gF_mlsDistance[client][1])
				MLStats(client, true)
				gI_mlsCount[client] = 0
			}
		}
	}
	int other = Stuck(client)
	if(0 < other <= MaxClients && IsPlayerAlive(client) && gB_block[other])
	{
		if(GetEntProp(other, Prop_Data, "m_CollisionGroup") == 5)
		{
			SetEntProp(other, Prop_Data, "m_CollisionGroup", 2)
			if(gB_color[other])
				SetEntityRenderColor(other, gI_color[other][0], gI_color[other][1], gI_color[other][2], 125)
			else
				SetEntityRenderColor(other, 255, 255, 255, 125)
		}
	}
	else if(IsPlayerAlive(client) && other == -1 && gB_block[client])
	{
		if(GetEntProp(client, Prop_Data, "m_CollisionGroup") == 2)
		{
			SetEntProp(client, Prop_Data, "m_CollisionGroup", 5)
			if(gB_color[client])
				SetEntityRenderColor(client, gI_color[client][0], gI_color[client][1], gI_color[client][2], 255)
			else
				SetEntityRenderColor(client, 255, 255, 255, 255)
		}
	}*/
}

/*bool TraceEntityFilterPlayer(int entity, int contentMask, int client)
{
	if(LibraryExists("fakeexpert-entityfilter"))
		return entity > MaxClients && !Trikz_GetEntityFilter(client, entity)
	else
		return entity > MaxClients
}

Action timer_removePing(Handle timer, int client)
{
	if(gI_pingModel[client])
	{
		RemoveEntity(gI_pingModel[client])
		gI_pingModel[client] = 0
	}
}

Action ProjectileBoostFix(int entity, int other)
{
	if(0 < other <= MaxClients && IsClientInGame(other) && !gI_boost[other] && !(gI_entityFlags[other] & FL_ONGROUND))
	{
		float originOther[3]
		GetClientAbsOrigin(other, originOther)
		float originEntity[3]
		GetEntPropVector(entity, Prop_Send, "m_vecOrigin", originEntity)
		float maxsEntity[3]
		GetEntPropVector(entity, Prop_Send, "m_vecMaxs", maxsEntity)
		float delta = originOther[2] - originEntity[2] - maxsEntity[2]
		//Thanks to extremix/hornet for idea from 2019 year summer. Extremix version (if(!(clientOrigin[2] - 5 <= entityOrigin[2] <= clientOrigin[2])) //Calculate for Client/Flash - Thanks to extrem)/tengu code from github https://github.com/tengulawl/scripting/blob/master/boost-fix.sp#L231 //https://forums.alliedmods.net/showthread.php?t=146241
		if(0.0 < delta < 2.0) //tengu code from github https://github.com/tengulawl/scripting/blob/master/boost-fix.sp#L231
		{
			GetEntPropVector(entity, Prop_Data, "m_vecAbsVelocity", gF_velEntity[other])
			GetEntPropVector(other, Prop_Data, "m_vecAbsVelocity", gF_velClient[other])
			gF_boostTime[other] = GetEngineTime()
			gB_groundBoost[other] = gB_bouncedOff[entity]
			SetEntProp(entity, Prop_Send, "m_nSolidType", 0) //https://forums.alliedmods.net/showthread.php?t=286568 non model no solid model Gray83 author of solid model types.
			gI_flash[other] = EntIndexToEntRef(entity) //check this for postthink post to correct set first telelportentity speed. starttouch have some outputs only one of them is coorect wich gives correct other(player) id.
			gI_boost[other] = 1
			float vel[3]
			GetEntPropVector(other, Prop_Data, "m_vecAbsVelocity", vel)
			gF_mlsVel[other][0][0] = vel[0]
			gF_mlsVel[other][0][1] = vel[1]
			gI_mlsCount[other]++
			if(gI_mlsCount[other] == 1)
				GetClientAbsOrigin(other, gF_mlsDistance[other][0])
			gI_mlsBooster[other] = GetEntPropEnt(entity, Prop_Data, "m_hOwnerEntity")
		}
	}
}*/

Action cmd_devmap(int client, int args)
{
	if(GetEngineTime() - gF_devmapTime > 35.0 && GetEngineTime() - gF_afkTime > 30.0)
	{
		gI_voters = 0
		for(int i = 1; i <= MaxClients; i++)
		{
			if(IsClientInGame(i) && !IsClientSourceTV(i))
			{
				gI_voters++
				if(gB_isDevmap)
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
		gF_devmapTime = GetEngineTime()
		CreateTimer(20.0, timer_devmap, TIMER_FLAG_NO_MAPCHANGE)
		PrintToChatAll("Devmap vote started by %N", client)
	}
	else if(GetEngineTime() - gF_devmapTime <= 35.0 || GetEngineTime() - gF_afkTime <= 30.0)
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
					gF_devmap[1]++
					gI_voters--
					devmap()
				}
				case 1:
				{
					gF_devmap[0]++
					gI_voters--
					devmap()
				}
			}
		}
	}
}

Action timer_devmap(Handle timer)
{
	//devmap idea by expert zone. thanks to ed and maru. thanks to lon to give tp idea for server i could made it like that "profesional style".
	devmap(true)
}

void devmap(bool force = false)
{
	if(force || !gI_voters)
	{
		if((gF_devmap[1] || gF_devmap[0]) && gF_devmap[1] >= gF_devmap[0])
		{
			if(gB_isDevmap)
				PrintToChatAll("Devmap will be disabled. \"Yes\" chose %.0f%%% or %.0f of %.0f players.", (gF_devmap[1] / (gF_devmap[0] + gF_devmap[1])) * 100.0, gF_devmap[1], gF_devmap[0] + gF_devmap[1])
			else
				PrintToChatAll("Devmap will be enabled. \"Yes\" chose %.0f%%% or %.0f of %.0f players.", (gF_devmap[1] / (gF_devmap[0] + gF_devmap[1])) * 100.0, gF_devmap[1], gF_devmap[0] + gF_devmap[1])
			CreateTimer(5.0, timer_changelevel, gB_isDevmap ? false : true)
		}
		else if((gF_devmap[1] || gF_devmap[0]) && gF_devmap[1] <= gF_devmap[0])
		{
			if(gB_isDevmap)
				PrintToChatAll("Devmap will be continue. \"No\" chose %.0f%%% or %.0f of %.0f players.", (gF_devmap[0] / (gF_devmap[0] + gF_devmap[1])) * 100.0, gF_devmap[0], gF_devmap[0] + gF_devmap[1]) //google translate russian to english.
			else
				PrintToChatAll("Devmap will not be enabled. \"No\" chose %.0f%%% or %.0f of %.0f players.", (gF_devmap[0] / (gF_devmap[0] + gF_devmap[1])) * 100.0, gF_devmap[0], gF_devmap[0] + gF_devmap[1])
		}
		for(int i = 0; i <= 1; i++)
			gF_devmap[i] = 0.0
	}
}

Action timer_changelevel(Handle timer, bool value)
{
	gB_isDevmap = value
	ForceChangeLevel(gS_map, "Reason: Devmap")
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
		char sTopURL[192]
		gCV_topURL.GetString(sTopURL, 192)
		char sTopURLwMap[256]
		Format(sTopURLwMap, 256, "%s%s", sTopURL, gS_map)
		ShowMOTDPanel(client, "Trikz Timer", sTopURLwMap, MOTDPANEL_TYPE_URL) //https://forums.alliedmods.net/showthread.php?t=232476
	}
}

Action cmd_afk(int client, int args)
{
	if(GetEngineTime() - gF_afkTime > 30.0 && GetEngineTime() - gF_devmapTime > 35.0)
	{
		gI_voters = 0
		gI_afkClient = client
		for(int i = 1; i <= MaxClients; i++)
		{
			if(IsClientInGame(i) && !IsClientSourceTV(i) && !IsPlayerAlive(i) && client != i)
			{
				gB_afk[i] = false
				gI_voters++
				Menu menu = new Menu(afk_handler)
				menu.SetTitle("Are you here?")
				menu.AddItem("yes", "Yes")
				menu.AddItem("no", "No")
				menu.Display(i, 20)
			}
		}
		gF_afkTime = GetEngineTime()
		CreateTimer(20.0, timer_afk, client, TIMER_FLAG_NO_MAPCHANGE)
		PrintToChatAll("Afk check - vote started by %N", client)
	}
	else if(GetEngineTime() - gF_afkTime <= 30.0 || GetEngineTime() - gF_devmapTime <= 35.0)
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
					gB_afk[param1] = true
					gI_voters--
					afk(gI_afkClient)
				}
				case 1:
				{
					gI_voters--
					afk(gI_afkClient)
				}
			}
		}
	}
}

Action timer_afk(Handle timer, int client)
{
	//afk idea by expert zone. thanks to ed and maru. thanks to lon to give tp idea for server i could made it like that "profesional style".
	afk(client, true)
}

void afk(int client, bool force = false)
{
	if(force || !gI_voters)
		for(int i = 1; i <= MaxClients; i++)
			if(IsClientInGame(i) && !IsPlayerAlive(i) && !IsClientSourceTV(i) && !gB_afk[i] && client != i)
				KickClient(i, "Away from keyboard")
}

Action cmd_noclip(int client, int args)
{
	Noclip(client)
	return Plugin_Handled
}

void Noclip(int client)
{
	if(gB_isDevmap)
	{
		SetEntityMoveType(client, GetEntityMoveType(client) & MOVETYPE_NOCLIP ? MOVETYPE_WALK : MOVETYPE_NOCLIP)
		PrintToChat(client, GetEntityMoveType(client) & MOVETYPE_NOCLIP ? "Noclip enabled." : "Noclip disabled.")
	}
	else
		PrintToChat(client, "Turn on devmap.")
}

Action cmd_spec(int client, int args)
{
	ChangeClientTeam(client, 1)
	return Plugin_Handled
}

Action cmd_hud(int client, int args)
{
	Menu menu = new Menu(hud_handler, MenuAction_Start | MenuAction_Select | MenuAction_Display | MenuAction_Cancel)
	menu.SetTitle("Hud")
	menu.AddItem("vel", gB_hudVel[client] ? "Velocity [v]" : "Velocity [x]")
	//menu.AddItem("mls", gB_mlstats[client] ? "ML stats [v]" : "ML stats [x]")
	menu.Display(client, 20)
	return Plugin_Handled
}

int hud_handler(Menu menu, MenuAction action, int param1, int param2)
{
	switch(action)
	{
		case MenuAction_Start: //expert-zone idea. thank to ed, maru.
			gB_MenuIsOpen[param1] = true
		case MenuAction_Select:
		{
			char sValue[16]
			switch(param2)
			{
				case 0:
				{
					gB_hudVel[param1] = !gB_hudVel[param1]
					IntToString(gB_hudVel[param1], sValue, 16)
					SetClientCookie(param1, gH_cookie, sValue)
				}
				/*case 1:
				{
					gB_mlstats[param1] = !gB_mlstats[param1]
					IntToString(gB_mlstats[param1], sValue, 16)
					SetClientCookie(param1, gH_cookie[1], sValue)
				}*/
			}
			cmd_hud(param1, 0)
		}
		case MenuAction_Cancel:
			gB_MenuIsOpen[param1] = false //idea from expert zone.
		case MenuAction_Display:
			gB_MenuIsOpen[param1] = true
	}
}

void Hud(int client)
{
	float vel[3]
	GetEntPropVector(client, Prop_Data, "m_vecAbsVelocity", vel)
	float velXY = SquareRoot(Pow(vel[0], 2.0) + Pow(vel[1], 2.0))
	if(gB_hudVel[client])
		PrintHintText(client, "%.0f", velXY)
	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i) && !IsPlayerAlive(i))
		{
			int observerTarget = GetEntPropEnt(i, Prop_Data, "m_hObserverTarget")
			int observerMode = GetEntProp(i, Prop_Data, "m_iObserverMode")
			if(observerMode < 7 && observerTarget == client && gB_hudVel[i])
				PrintHintText(i, "%.0f", velXY)
		}
	}
}

/*Action cmd_mlstats(int client, int args)
{
	gB_mlstats[client] = !gB_mlstats[client]
	char sValue[16]
	IntToString(gB_mlstats[client], sValue, 16)
	SetClientCookie(client, gH_cookie[1], sValue)
	PrintToChat(client, gB_mlstats[client] ? "ML stats is on." : "ML stats is off.")
	return Plugin_Handled
}

Action cmd_button(int client, int args)
{
	gB_button[client] = !gB_button[client]
	char sValue[16]
	IntToString(gB_button[client], sValue, 16)
	SetClientCookie(client, gH_cookie[2], sValue)
	PrintToChat(client, gB_button[client] ? "Button announcer is on." : "Button announcer is off.")
	return Plugin_Handled
}

Action cmd_pbutton(int client, int args)
{
	gB_pbutton[client] = !gB_pbutton[client]
	char sValue[16]
	IntToString(gB_pbutton[client], sValue, 16)
	SetClientCookie(client, gH_cookie[3], sValue)
	PrintToChat(client, gB_pbutton[client] ? "Partner button announcer is on." : "Partner button announcer is off.")
	return Plugin_Handled
}*/

public Action OnClientSayCommand(int client, const char[] command, const char[] sArgs)
{
	if(!IsChatTrigger())
	{
		if(StrEqual(sArgs, "bh") || StrEqual(sArgs, "bhop"))
			Bhop(client)
		/*else if(StrEqual(sArgs, "bl") || StrEqual(sArgs, "block"))
			Block(client)
		else if(StrEqual(sArgs, "p") || StrEqual(sArgs, "partner"))
			Partner(client)
		else if(StrEqual(sArgs, "c") || StrEqual(sArgs, "color")) //white, red, orange, yellow, lime, aqua, deep sky blue, blue, magenta
			Color(client, true)
		else if(StrEqual(sArgs, "c 0") || StrEqual(sArgs, "c white") || StrEqual(sArgs, "color 0") || StrEqual(sArgs, "color white"))
			Color(client, true, 0)
		else if(StrEqual(sArgs, "c 1") || StrEqual(sArgs, "c red") || StrEqual(sArgs, "color 1") || StrEqual(sArgs, "color red"))
			Color(client, true, 1)
		else if(StrEqual(sArgs, "c 2") || StrEqual(sArgs, "c orange") || StrEqual(sArgs, "color 2") || StrEqual(sArgs, "color orange"))
			Color(client, true, 2)
		else if(StrEqual(sArgs, "c 3") || StrEqual(sArgs, "c yellow") || StrEqual(sArgs, "color 3") || StrEqual(sArgs, "color yellow"))
			Color(client, true, 3)
		else if(StrEqual(sArgs, "c 4") || StrEqual(sArgs, "c lime") || StrEqual(sArgs, "color 4") || StrEqual(sArgs, "color lime"))
			Color(client, true, 4)
		else if(StrEqual(sArgs, "c 5") || StrEqual(sArgs, "c aqua") || StrEqual(sArgs, "color 5") || StrEqual(sArgs, "color aqua"))
			Color(client, true, 5)
		else if(StrEqual(sArgs, "c 6") || StrEqual(sArgs, "c deep sky blue") || StrEqual(sArgs, "color 6") || StrEqual(sArgs, "color deep sky blue"))
			Color(client, true, 6)
		else if(StrEqual(sArgs, "c 7") || StrEqual(sArgs, "c blue") || StrEqual(sArgs, "color 7") || StrEqual(sArgs, "color blue"))
			Color(client, true, 7)
		else if(StrEqual(sArgs, "c 8") || StrEqual(sArgs, "c magenta") || StrEqual(sArgs, "color 8") || StrEqual(sArgs, "color magenta"))
			Color(client, true, 8)*/
		else if(StrEqual(sArgs, "r") || StrEqual(sArgs, "restart"))
		{
			Restart(client)
			//if(gI_partner[client])
			//	Restart(gI_partner[client])
		}
		//else if(StrEqual(sArgs, "time"))
		//	cmd_time(client, 0)
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
		/*else if(StrEqual(sArgs, "mls"))
			cmd_mlstats(client, 0)
		else if(StrEqual(sArgs, "button"))
			cmd_button(client, 0)
		else if(StrEqual(sArgs, "pbutton"))
			cmd_pbutton(client, 0)*/
	}
}

/*Action ProjectileBoostFixEndTouch(int entity, int other)
{
	if(!other)
		gB_bouncedOff[entity] = true //get from tengu github tengulawl scriptig boost-fix.sp
}*/

/*Action cmd_time(int client, int args)
{
	if(IsPlayerAlive(client))
	{
		//https://forums.alliedmods.net/archive/index.php/t-23912.html //ShAyA format OneEyed format second
		int hour = (RoundToFloor(gF_Time[client]) / 3600) % 24 //https://forums.alliedmods.net/archive/index.php/t-187536.html
		int minute = (RoundToFloor(gF_Time[client]) / 60) % 60
		int second = RoundToFloor(gF_Time[client]) % 60
		PrintToChat(client, "Time: %02.i:%02.i:%02.i", hour, minute, second)
		if(gI_partner[client])
			PrintToChat(gI_partner[client], "Time: %02.i:%02.i:%02.i", hour, minute, second)
	}
	else
	{
		int observerTarget = GetEntPropEnt(client, Prop_Data, "m_hObserverTarget")
		int observerMode = GetEntProp(client, Prop_Data, "m_iObserverMode")
		if(observerMode < 7)
		{
			//https://forums.alliedmods.net/archive/index.php/t-23912.html //ShAyA format OneEyed format second
			int hour = (RoundToFloor(gF_Time[observerTarget]) / 3600) % 24 //https://forums.alliedmods.net/archive/index.php/t-187536.html
			int minute = (RoundToFloor(gF_Time[observerTarget]) / 60) % 60
			int second = RoundToFloor(gF_Time[observerTarget]) % 60
			PrintToChat(client, "Time: %02.i:%02.i:%02.i", hour, minute, second)
		}
	}
	return Plugin_Handled
}*/

public void OnEntityCreated(int entity, const char[] classname)
{
	/*if(StrEqual(classname, "flashbang_projectile"))
	{
		gB_bouncedOff[entity] = false //tengu lawl boost fix .sp
		SDKHook(entity, SDKHook_Spawn, SDKProjectile)
		SDKHook(entity, SDKHook_StartTouch, ProjectileBoostFix)
		SDKHook(entity, SDKHook_EndTouch, ProjectileBoostFixEndTouch)
		SDKHook(entity, SDKHook_SpawnPost, SDKProjectilePost)
	}*/
}

/*Action SDKProjectile(int entity)
{
	int client = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity")
	if(IsValidEntity(entity) && IsValidEntity(client))
	{
		SetEntData(client, FindDataMapInfo(client, "m_iAmmo") + 12 * 4, 2) //https://forums.alliedmods.net/showthread.php?t=114527 https://forums.alliedmods.net/archive/index.php/t-81546.html
		gB_silentKnife = true
		FakeClientCommand(client, "use weapon_knife")
		SetEntProp(client, Prop_Data, "m_bDrawViewmodel", false) //thanks to alliedmodders. 2019 https://forums.alliedmods.net/archive/index.php/t-287052.html
		ClientCommand(client, "lastinv") //hornet, log idea, main idea Nick Yurevich since 2019, hornet found ClientCommand - lastinv
		RequestFrame(frame_blockExplosion, entity)
		CreateTimer(GetClientAvgLatency(client, NetFlow_Both), timer_hideSwtich, client, TIMER_FLAG_NO_MAPCHANGE)
		CreateTimer(1.5, timer_deleteProjectile, entity, TIMER_FLAG_NO_MAPCHANGE)
	}
}

void frame_blockExplosion(int entity)
{
	if(IsValidEntity(entity))
		SetEntProp(entity, Prop_Data, "m_nNextThinkTick", 0) //https://forums.alliedmods.net/showthread.php?t=301667 avoid random blinds.
}

Action timer_hideSwtich(Handle timer, int client)
{
	if(IsClientInGame(client))
		SetEntProp(client, Prop_Data, "m_bDrawViewmodel", true)
}

Action timer_deleteProjectile(Handle timer, int entity)
{
	if(IsValidEntity(entity))
		RemoveEntity(entity)
}

void SDKProjectilePost(int entity)
{
	int client = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity")
	if(IsValidEntity(client))
	{
		if(gB_color[client])
		{
			SetEntProp(entity, Prop_Data, "m_nModelIndex", gI_wModelThrown)
			SetEntProp(entity, Prop_Data, "m_nSkin", 1)
			SetEntityRenderColor(entity, gI_color[client][0], gI_color[client][1], gI_color[client][2], 255)
		}
	}
}*/

Action SDKOnTakeDamage(int victim, int& attacker, int& inflictor, float& damage, int& damagetype)
{
	SetEntPropVector(victim, Prop_Send, "m_vecPunchAngle", NULL_VECTOR) //https://forums.alliedmods.net/showthread.php?p=1687371
	SetEntPropVector(victim, Prop_Send, "m_vecPunchAngleVel", NULL_VECTOR)
	return Plugin_Handled //full god-mode
}

/*void SDKWeaponEquipPost(int client, int weapon) //https://sm.alliedmods.net/new-api/sdkhooks/__raw thanks to lon to give this idea. aka trikz_failtime
{
	if(!GetEntData(client, FindDataMapInfo(client, "m_iAmmo") + 12 * 4))
	{
		GivePlayerItem(client, "weapon_flashbang")
		GivePlayerItem(client, "weapon_flashbang")
	}
}*/

Action SDKWeaponDrop(int client, int weapon)
{
	if(IsValidEntity(weapon))
		RemoveEntity(weapon)
}

/*Action SDKSetTransmitPing(int entity, int client)
{
	if(IsPlayerAlive(client) && gI_pingModelOwner[entity] != client && gI_partner[gI_pingModelOwner[entity]] != gI_partner[gI_partner[client]])
		return Plugin_Handled
	return Plugin_Continue
}*/

/*Action SoundHook(int clients[MAXPLAYERS], int& numClients, char sample[PLATFORM_MAX_PATH], int& entity, int& channel, float& volume, int& level, int& pitch, int& flags, char soundEntry[PLATFORM_MAX_PATH], int& seed) //https://github.com/alliedmodders/sourcepawn/issues/476
{
	if(StrEqual(sample, "weapons/knife/knife_deploy1.wav") && gB_silentKnife)
	{
		gB_silentKnife = false
		return Plugin_Handled
	}
	return Plugin_Continue
}*/

Action timer_clantag(Handle timer, int client)
{
	if(0 < client <= MaxClients && IsClientInGame(client))
	{
		if(gB_state[client])
		{
			CS_SetClientClanTag(client, gS_clanTag[client][1])
			return Plugin_Continue
		}
		else
			CS_SetClientClanTag(client, gS_clanTag[client][0])
	}
	return Plugin_Stop
}

/*void MLStats(int client, bool ground = false)
{
	float velPre = SquareRoot(Pow(gF_mlsVel[client][0][0], 2.0) + Pow(gF_mlsVel[client][0][1], 2.0))
	float velPost = SquareRoot(Pow(gF_mlsVel[client][1][0], 2.0) + Pow(gF_mlsVel[client][1][1], 2.0))
	Format(gS_mlsPrint[client][gI_mlsCount[client]], 256, "%i. %.1f - %.1f\n", gI_mlsCount[client], velPre, velPost)
	char sFullPrint[256]
	for(int i = 1; i <= gI_mlsCount[client] <= 10; i++)
		Format(sFullPrint, 256, "%s%s", sFullPrint, gS_mlsPrint[client][i])
	if(gI_mlsCount[client] > 10)
		Format(sFullPrint, 256, "%s...\n%s", sFullPrint, gS_mlsPrint[client][gI_mlsCount[client]])
	if(ground)
	{
		float x = gF_mlsDistance[client][1][0] - gF_mlsDistance[client][0][0]
		float y = gF_mlsDistance[client][1][1] - gF_mlsDistance[client][0][1]
		Format(sFullPrint, 256, "%s\nDistance: %.1f units%s", sFullPrint, SquareRoot(Pow(x, 2.0) + Pow(y, 2.0)) + 32.0, gB_teleported[client] ? " [TP]" : "")
		gB_teleported[client] = false
	}
	if(gB_mlstats[gI_mlsBooster[client]])
	{
		Handle hKeyHintText = StartMessageOne("KeyHintText", gI_mlsBooster[client])
		BfWrite bfmsg = UserMessageToBfWrite(hKeyHintText)
		bfmsg.WriteByte(true)
		bfmsg.WriteString(sFullPrint)
		EndMessage()
	}
	if(gB_mlstats[client])
	{
		Handle hKeyHintText = StartMessageOne("KeyHintText", client)
		BfWrite bfmsg = UserMessageToBfWrite(hKeyHintText)
		bfmsg.WriteByte(true)
		bfmsg.WriteString(sFullPrint)
		EndMessage()
	}
	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i) && IsClientObserver(i))
		{
			int observerTarget = GetEntPropEnt(i, Prop_Data, "m_hObserverTarget")
			int observerMode = GetEntProp(i, Prop_Data, "m_iObserverMode")
			if(observerMode < 7 && observerTarget == client && gB_mlstats[i])
			{
				Handle hKeyHintText = StartMessageOne("KeyHintText", i)
				BfWrite bfmsg = UserMessageToBfWrite(hKeyHintText)
				bfmsg.WriteByte(true)
				bfmsg.WriteString(sFullPrint)
				EndMessage()
			}
		}
	}
}

int Stuck(int client)
{
	float mins[3]
	float maxs[3]
	float origin[3]
	GetClientMins(client, mins)
	GetClientMaxs(client, maxs)
	GetClientAbsOrigin(client, origin)
	TR_TraceHullFilter(origin, origin, mins, maxs, MASK_PLAYERSOLID, TR_donthitself, client) //skiper, gurman idea, plugin 2020
	return TR_GetEntityIndex()
}

bool TR_donthitself(int entity, int mask, int client)
{
	if(LibraryExists("fakeexpert-entityfilter"))
		return entity != client && 0 < entity <= MaxClients && gI_partner[entity] == gI_partner[gI_partner[client]]
	else
		return entity != client && 0 < entity <= MaxClients
}

int Native_GetClientButtons(Handle plugin, int numParams)
{
	int client = GetNativeCell(1)
	return gI_entityButtons[client]
}

int Native_GetClientPartner(Handle plugin, int numParams)
{
	int client = GetNativeCell(1)
	return gI_partner[client]
}*/

int Native_GetTimerState(Handle plugin, int numParams)
{
	int client = GetNativeCell(1)
	if(!IsFakeClient(client))
		return gB_state[client]
	else
		return false
}

Action timer_clearlag(Handle timer)
{
	ServerCommand("mat_texture_list_txlod_sync reset")
}
