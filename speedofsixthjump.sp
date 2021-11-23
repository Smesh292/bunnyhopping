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
#include <clientprefs>

bool gB_ssj[MAXPLAYERS + 1]
int gI_jumpCount[MAXPLAYERS + 1]
int gI_tickcount[MAXPLAYERS + 1]
Handle gH_cookie

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
	HookEvent("player_jump", OnJump)
	gH_cookie = RegClientCookie("ssj", "speed of sixth jump", CookieAccess_Protected)
}

public void OnClientCookiesCached(int client)
{
	char sValue[16]
	GetClientCookie(client, gH_cookie, sValue, 16)
	gB_ssj[client] = view_as<bool>(StringToInt(sValue))
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
	gB_ssj[client] = !gB_ssj[client]
	char sValue[16]
	IntToString(gB_ssj[client], sValue, 16)
	SetClientCookie(client, gH_cookie, sValue)
	PrintToChat(client, gB_ssj[client] ? "Speed of sixth jump is on." : "Speed of sixth jump is off.")
}

public Action OnPlayerRunCmd(int client, int& buttons, int& impulse, float vel[3], float angles[3], int& weapon, int& subtype, int& cmdnum, int& tickcount, int& seed, int mouse[2])
{
	if(gB_ssj[client])
	{
		if(GetEntityFlags(client) & FL_ONGROUND)
		{
			if(gI_tickcount[client] == 30)
				gI_jumpCount[client] = 0
			gI_tickcount[client]++
		}
	}
}

Action OnJump(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"))
	gI_jumpCount[client]++
	gI_tickcount[client] = 0
	if(gI_jumpCount[client] == 7)
	{
		float vel[3]
		GetEntPropVector(client, Prop_Data, "m_vecAbsVelocity", vel)
		float velXY = SquareRoot(Pow(vel[0], 2.0) + Pow(vel[1], 2.0))
		if(gB_ssj[client])
			PrintToChat(client, "Speed of sixth jump: %.0f", velXY)
		for(int i = 1; i <= MaxClients; i++)
		{
			if(IsClientInGame(i) && IsClientObserver(i))
			{
				int observerTarget = GetEntPropEnt(i, Prop_Data, "m_hObserverTarget")
				int observerMode = GetEntProp(i, Prop_Data, "m_iObserverMode")
				if(observerMode < 7 && observerTarget == client && gB_ssj[i])
					PrintToChat(i, "Speed of sixth jump: %.0f", velXY)
			}
		}
	}
}
