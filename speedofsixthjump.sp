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
#include <clientprefs>

bool g_ssj[MAXPLAYERS + 1]
int g_jumpCount[MAXPLAYERS + 1]
int g_tickcount[MAXPLAYERS + 1]
Handle g_cookie
float g_origin[MAXPLAYERS + 1][7][3]
int g_strafeCount[MAXPLAYERS + 1]
int g_syncTick[MAXPLAYERS + 1]
int g_tickAir[MAXPLAYERS + 1]
float g_dot[MAXPLAYERS + 1]
bool g_strafeBlockD[MAXPLAYERS + 1]
bool g_strafeBlockA[MAXPLAYERS + 1]
bool g_strafeBlockS[MAXPLAYERS + 1]
bool g_strafeBlockW[MAXPLAYERS + 1]
float g_dotTime[MAXPLAYERS + 1]
float g_gain[MAXPLAYERS + 1]

public Plugin myinfo =
{
	name = "Speed of sixth jump",
	author = "Smesh(Nick Jurevich)",
	description = "Gap speed from sixth jump.",
	version = "0.1",
	url = "http://www.sourcemod.net/"
}

public void OnPluginStart()
{
	RegConsoleCmd("sm_ssj", cmd_ssj)
	HookEvent("player_jump", OnJump, EventHookMode_PostNoCopy)
	g_cookie = RegClientCookie("ssj", "speed of sixth jump", CookieAccess_Protected)
}

public void OnClientCookiesCached(int client)
{
	char value[16]
	GetClientCookie(client, g_cookie, value, 16)
	g_ssj[client] = view_as<bool>(StringToInt(value))
}

Action cmd_ssj(int client, int args)
{
	SSJ(client)
	return Plugin_Handled
}

public Action OnClientSayCommand(int client, const char[] command, const char[] sArgs)
{
	if(!IsChatTrigger())
		if(StrEqual(sArgs, "ssj"))
			SSJ(client)
}

void SSJ(int client)
{
	g_ssj[client] = !g_ssj[client]
	char sValue[16]
	IntToString(g_ssj[client], sValue, 16)
	SetClientCookie(client, g_cookie, sValue)
	PrintToChat(client, g_ssj[client] ? "Speed of sixth jump is on." : "Speed of sixth jump is off.")
}

public Action OnPlayerRunCmd(int client, int& buttons, int& impulse, float vel[3], float angles[3], int& weapon, int& subtype, int& cmdnum, int& tickcount, int& seed, int mouse[2])
{
	if(g_ssj[client])
	{
		if(GetEntityFlags(client) & FL_ONGROUND)
		{
			if(g_tickcount[client] == 30)
			{
				g_jumpCount[client] = 0
				g_strafeCount[client] = 0
				g_tickAir[client] = 0
				g_syncTick[client] = 0
				g_strafeBlockD[client] = false
				g_strafeBlockA[client] = false
				g_strafeBlockS[client] = false
				g_strafeBlockW[client] = false
				g_gain[client] = 0.0
			}
			g_tickcount[client]++
		}
		else
		{
			if(GetEngineTime() - g_dotTime[client] < 0.4)
			{
				float eye[3]
				GetClientEyeAngles(client, eye)
				eye[0] = Cosine(DegToRad(eye[1]))
				eye[1] = Sine(DegToRad(eye[1]))
				//eye[2] = 0.0
				float velAbs[3]
				GetEntPropVector(client, Prop_Data, "m_vecAbsVelocity", velAbs)
				float length = SquareRoot(Pow(velAbs[0], 2.0) + Pow(velAbs[1], 2.0))
				velAbs[0] /= length
				velAbs[1] /= length
				//velNew[2] = 0.0
				g_dot[client] = GetVectorDotProduct(eye, velAbs) //https://onedrive.live.com/?authkey=%21ACwrZlLqDTC92n0&cid=879961B2A0BE0AAE&id=879961B2A0BE0AAE%2116116&parId=879961B2A0BE0AAE%2126502&o=OneUp
				//PrintToServer("%f", g_dot[client])
			}
			g_tickAir[client]++
			if(g_dot[client] < -0.9) //backward
			{
				if(mouse[0] > 0)
				{
					if(buttons & IN_MOVELEFT)
					{
						if(!g_strafeBlockA[client])
						{
							g_strafeCount[client]++
							g_strafeBlockD[client] = false
							g_strafeBlockA[client] = true
						}
						g_syncTick[client]++
					}
				}
				else
				{
					if(buttons & IN_MOVERIGHT)
					{
						if(!g_strafeBlockD[client])
						{
							g_strafeCount[client]++
							g_strafeBlockD[client] = true
							g_strafeBlockA[client] = false
						}
						g_syncTick[client]++
					}
				}
				//if(!StrEqual(gS_style[client], "Backward"))
				//	Format(gS_style[client], 32, "Backward")
			}
			else if(g_dot[client] > 0.9) //forward
			{
				if(mouse[0] > 0)
				{
					if(buttons & IN_MOVERIGHT)
					{
						if(!g_strafeBlockD[client])
						{
							g_strafeCount[client]++
							g_strafeBlockD[client] = true
							g_strafeBlockA[client] = false
						}
						g_syncTick[client]++
					}
				}
				else
				{
					if(buttons & IN_MOVELEFT)
					{
						if(!g_strafeBlockA[client])
						{
							g_strafeCount[client]++
							g_strafeBlockD[client] = false
							g_strafeBlockA[client] = true
						}
						g_syncTick[client]++
					}
				}
				//if(!StrEqual(gS_style[client], "Forward"))
				//	Format(gS_style[client], 32, "Forward")
			}
			else //sideways
			{
				if(mouse[0] > 0)
				{
					if(buttons & IN_BACK)
					{
						if(!g_strafeBlockS[client])
						{
							g_strafeCount[client]++
							g_strafeBlockS[client] = true
							g_strafeBlockW[client] = false
						}
						g_syncTick[client]++
					}
				}
				else
				{
					if(buttons & IN_FORWARD)
					{
						if(!g_strafeBlockW[client])
						{
							g_strafeCount[client]++
							g_strafeBlockS[client] = false
							g_strafeBlockW[client] = true
						}
						g_syncTick[client]++
					}
				}
				//if(!StrEqual(gS_style[client], "Sideways"))
				//	Format(gS_style[client], 32, "Sideways")
			}
		}
		//https://forums.alliedmods.net/showthread.php?t=287039 gain calculations
		float velocity[3]
		GetEntPropVector(client, Prop_Data, "m_vecAbsVelocity", velocity)
		velocity[2] = 0.0
		float gaincoeff
		float fore[3], side[3], wishvel[3], wishdir[3]
		float wishspeed, wishspd, currentgain
		GetAngleVectors(angles, fore, side, NULL_VECTOR)
		fore[2] = 0.0
		side[2] = 0.0
		NormalizeVector(fore, fore)
		NormalizeVector(side, side)
		for(int i = 0; i < 2; i++)
			wishvel[i] = fore[i] * vel[0] + side[i] * vel[1]
		wishspeed = NormalizeVector(wishvel, wishdir)
		if(wishspeed > GetEntPropFloat(client, Prop_Send, "m_flMaxspeed") && GetEntPropFloat(client, Prop_Send, "m_flMaxspeed") != 0.0)
			wishspeed = GetEntPropFloat(client, Prop_Send, "m_flMaxspeed")
		if(wishspeed)
		{
			wishspd = (wishspeed > 30.0) ? 30.0 : wishspeed
			currentgain = GetVectorDotProduct(velocity, wishdir)
			if(currentgain < 30.0)
				gaincoeff = (wishspd - FloatAbs(currentgain)) / wishspd
			g_gain[client] += gaincoeff
		}
	}
}

void OnJump(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"))
	g_jumpCount[client]++
	g_tickcount[client] = 0
	g_dotTime[client] = GetEngineTime()
	if(g_jumpCount[client] <= 6)
		GetClientAbsOrigin(client, g_origin[client][g_jumpCount[client]])
	if(g_jumpCount[client] == 6)
	{
		float vel[3]
		GetEntPropVector(client, Prop_Data, "m_vecAbsVelocity", vel)
		float velXY = SquareRoot(Pow(vel[0], 2.0) + Pow(vel[1], 2.0))
		bool flat
		float result = g_origin[client][1][2] - g_origin[client][0][2] + g_origin[client][2][2] - g_origin[client][0][2] + g_origin[client][3][2] - g_origin[client][0][2] + g_origin[client][4][2] - g_origin[client][0][2] + g_origin[client][5][2] - g_origin[client][0][2] + g_origin[client][6][2] - g_origin[client][0][2]
		if(RoundFloat(result) - 6 == 0)
			flat = true
		float sync = -1.0
		sync += float(g_syncTick[client])
		if(sync == -1.0)
			sync = 0.0
		sync /= float(g_tickAir[client])
		sync *= 100.0
		float gain = g_gain[client]
		gain /= g_tickAir[client]
		gain *= 100.0
		gain = RoundToFloor(gain * 100.0 + 0.5) / 100.0
		if(g_ssj[client] && velXY >= 300.0)
			PrintToChat(client, "Speed of sixth jump: %.0f, Strafes: %i, Sync: %.0f%%, Gain: %.0f%%, Flat: %s", velXY, g_strafeCount[client], sync, gain, flat ? "Yes" : "No")
		for(int i = 1; i <= MaxClients; i++)
		{
			if(IsClientInGame(i) && IsClientObserver(i))
			{
				int observerTarget = GetEntPropEnt(i, Prop_Data, "m_hObserverTarget")
				int observerMode = GetEntProp(i, Prop_Data, "m_iObserverMode")
				if(observerMode < 7 && observerTarget == client && g_ssj[i] && velXY >= 300.0)
					PrintToChat(i, "Speed of sixth jump: %.0f, Strafes: %i, Sync: %.0f%%, Gain: %.0f%%, Flat: %s", velXY, g_strafeCount[client], sync, gain, flat ? "Yes" : "No")
			}
		}
	}
}
