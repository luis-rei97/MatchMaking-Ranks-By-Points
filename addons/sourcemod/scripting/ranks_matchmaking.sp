#include <sourcemod>
#include <sdkhooks>
#include <sdktools>
#include <cstrike>
#include <clientprefs>
#include <colorvariables>
#undef REQUIRE_PLUGIN
#include <kento_rankme/rankme>
#include <gameme>
#include <zr_rank>
#define REQUIRE_PLUGIN

#pragma newdecls required
#pragma semicolon 1

Handle cookie_mm_type = INVALID_HANDLE;

int rank[MAXPLAYERS+1] = {0, ...};
int rankType[MAXPLAYERS+1] = {0, ...};
int oldrank[MAXPLAYERS+1] = {0, ...};

// ConVar Variables
ConVar g_CVAR_RanksPoints[18] = {null, ...};
ConVar g_CVAR_RankPoints_Type = null;
ConVar g_CVAR_RankPoints_Flag;
ConVar g_CVAR_RankPoints_Prefix;

// Variables to store ConVar values;
int g_RankPoints_Type;
int g_RankPoints_Flag;
char g_RankPoints_Prefix[40];
int RankPoints[18];


char RankStrings[256][18];

public Plugin myinfo = 
{
	name = "RankMe Scoreboard Ranks",
	author = "Hallucinogenic Troll",
	description = "Prints the Matchmaking Ranks on scoreboard, based on Rankme Stats",
	version = "1.0",
	url = "http://PTFun.net/newsite/"
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_mm", Menu_MM);
	HookEvent("announce_phase_end", Event_AnnouncePhaseEnd);
	HookEvent("player_disconnect", Event_Disconnect, EventHookMode_Pre);
	cookie_mm_type = RegClientCookie("cookie_mm_type", "Matchmaking Icon Type", CookieAccess_Public);
	
	// ConVar to check which rank you want
	
	g_CVAR_RankPoints_Type = CreateConVar("sm_ranks_matchmaking_typeofrank", "0", "Type of Rank that you want to use for this plugin (0 for Kento Rankme, 1 for GameMe, 2 for ZR Rank)", _, true, 0.0, true, 2.0);
	g_CVAR_RankPoints_Prefix = CreateConVar("sm_ranks_matchmaking_prefix", "[{purple}Fake Ranks{default}]", "Chat Prefix");
	g_CVAR_RankPoints_Flag = CreateConVar("sm_ranks_matchmaking_flag", "0", "Flag to restrict the ranks to certain players (0 enable the ranks for everyone)");
	
	// Rank Points ConVars;
	g_CVAR_RanksPoints[0] = CreateConVar("sm_ranks_matchmaking_point_s1", "100", "Number of Points to reach Silver I", _, true, 0.0, false);
	g_CVAR_RanksPoints[1] = CreateConVar("sm_ranks_matchmaking_point_s2", "150", "Number of Points to reach Silver II", _, true, 0.0, false);
	g_CVAR_RanksPoints[2] = CreateConVar("sm_ranks_matchmaking_point_s3", "200", "Number of Points to reach Silver III", _, true, 0.0, false);
	g_CVAR_RanksPoints[3] = CreateConVar("sm_ranks_matchmaking_point_s4", "300", "Number of Points to reach Silver IV", _, true, 0.0, false);
	g_CVAR_RanksPoints[4] = CreateConVar("sm_ranks_matchmaking_point_se", "400", "Number of Points to reach Silver Elite", _, true, 0.0, false);
	g_CVAR_RanksPoints[5] = CreateConVar("sm_ranks_matchmaking_point_sem", "500", "Number of Points to reach Silver Elite Master", _, true, 0.0, false);
	g_CVAR_RanksPoints[6] = CreateConVar("sm_ranks_matchmaking_point_g1", "600", "Number of Points to reach Gold Nova I", _, true, 0.0, false);
	g_CVAR_RanksPoints[7] = CreateConVar("sm_ranks_matchmaking_point_g2", "750", "Number of Points to reach Gold Nova II", _, true, 0.0, false);
	g_CVAR_RanksPoints[8] = CreateConVar("sm_ranks_matchmaking_point_g3", "900", "Number of Points to reach Gold Nova III", _, true, 0.0, false);
	g_CVAR_RanksPoints[9] = CreateConVar("sm_ranks_matchmaking_point_g4", "1050", "Number of Points to reach Gold Nova IV", _, true, 0.0, false);
	g_CVAR_RanksPoints[10] = CreateConVar("sm_ranks_matchmaking_point_mg1", "1200", "Number of Points to reach Master Guardian I", _, true, 0.0, false);
	g_CVAR_RanksPoints[11] = CreateConVar("sm_ranks_matchmaking_point_mg2", "1400", "Number of Points to reach Master Guardian II", _, true, 0.0, false);
	g_CVAR_RanksPoints[12] = CreateConVar("sm_ranks_matchmaking_point_mge", "1600", "Number of Points to reach Master Guardian Elite", _, true, 0.0, false);
	g_CVAR_RanksPoints[13] = CreateConVar("sm_ranks_matchmaking_point_dmg", "1800", "Number of Points to reach Distinguished Master Guardian", _, true, 0.0, false);
	g_CVAR_RanksPoints[14] = CreateConVar("sm_ranks_matchmaking_point_le", "2000", "Number of Points to reach Legendary Eagle", _, true, 0.0, false);
	g_CVAR_RanksPoints[15] = CreateConVar("sm_ranks_matchmaking_point_lem", "2200", "Number of Points to reach Legendary Eagle Master", _, true, 0.0, false);
	g_CVAR_RanksPoints[16] = CreateConVar("sm_ranks_matchmaking_point_smfc", "2400", "Number of Points to reach Supreme Master First Class", _, true, 0.0, false);
	g_CVAR_RanksPoints[17] = CreateConVar("sm_ranks_matchmaking_point_ge", "2700", "Number of Points to reach Global Elite", _, true, 0.0, false);
	
	LoadTranslations("ranks_matchmaking.phrases");
	AutoExecConfig(true, "ranks_matchmaking");
}

public void OnConfigsExecuted()
{
	for (int i = 0; i < 18; i++)
	{
		RankPoints[i] = g_CVAR_RanksPoints[i].IntValue;
	}
	
	g_CVAR_RankPoints_Prefix.GetString(g_RankPoints_Prefix, sizeof(g_RankPoints_Prefix));
	
	char buffer[10];
	g_CVAR_RankPoints_Flag.GetString(buffer, sizeof(buffer));
	
	if(StrEqual(buffer, "0"))
	{
		g_RankPoints_Flag = -1;
	}
	else
	{
		g_RankPoints_Flag = ReadFlagString(buffer);
	}
	
	
	g_RankPoints_Type = g_CVAR_RankPoints_Type.IntValue;
	
	GetRanksNames();
}

public void GetRanksNames()
{
	FormatEx(RankStrings[0], sizeof(RankStrings[]), "%t", "Unranked");
	FormatEx(RankStrings[1], sizeof(RankStrings[]), "%t", "Silver I");
	FormatEx(RankStrings[2], sizeof(RankStrings[]), "%t", "Silver II");
	FormatEx(RankStrings[3], sizeof(RankStrings[]), "%t", "Silver III");
	FormatEx(RankStrings[4], sizeof(RankStrings[]), "%t", "Silver IV");
	FormatEx(RankStrings[5], sizeof(RankStrings[]), "%t", "Silver Elite");
	FormatEx(RankStrings[6], sizeof(RankStrings[]), "%t", "Silver Elite Master");
	FormatEx(RankStrings[7], sizeof(RankStrings[]), "%t", "Gold Nova I");
	FormatEx(RankStrings[8], sizeof(RankStrings[]), "%t", "Gold Nova II");
	FormatEx(RankStrings[9], sizeof(RankStrings[]), "%t", "Gold Nova III");
	FormatEx(RankStrings[10], sizeof(RankStrings[]), "%t", "Gold Nova Master");
	FormatEx(RankStrings[11], sizeof(RankStrings[]), "%t", "Master Guardian I");
	FormatEx(RankStrings[12], sizeof(RankStrings[]), "%t", "Master Guardian II");
	FormatEx(RankStrings[13], sizeof(RankStrings[]), "%t", "Master Guardian Elite");
	FormatEx(RankStrings[14], sizeof(RankStrings[]), "%t", "Distinguished Master Guardian");
	FormatEx(RankStrings[15], sizeof(RankStrings[]), "%t", "Legendary Eagle");
	FormatEx(RankStrings[16], sizeof(RankStrings[]), "%t", "Legendary Eagle Master");
	FormatEx(RankStrings[17], sizeof(RankStrings[]), "%t", "Supreme First Master Class");
	FormatEx(RankStrings[18], sizeof(RankStrings[]), "%t", "Global Elite");
}

public void OnMapStart()
{
	int iIndex = FindEntityByClassname(MaxClients+1, "cs_player_manager");
	if (iIndex == -1) {
		SetFailState("Unable to find cs_player_manager entity");
	}
	
	SDKHook(iIndex, SDKHook_ThinkPost, Hook_OnThinkPost);
}

public void OnClientPostAdminCheck(int client)
{
	if(IsValidClient(client))
	{
		if(AreClientCookiesCached(client))
		{
			char cookie_buffer[52];
			GetClientCookie(client, cookie_mm_type, cookie_buffer, sizeof(cookie_buffer));	
			rankType[client] = StringToInt(cookie_buffer);
		}
		else
		{
			SetClientCookie(client, cookie_mm_type, "0");
		}
		
		/* 
			Checks if it is a GameMe Rank that you want to use;
			If not, it will use Kento's RankMe instead;
		*/
		
		switch(g_RankPoints_Type)
		{
			case 0:
			{
				CheckRanks(client, RankMe_GetPoints(client));
			}
			case 1:
			{
				QueryGameMEStats("playerinfo", client, QuerygameMEStatsCallback, 0);	
			}
			case 2:
			{
				CheckRanks(client, ZR_Rank_GetPoints(client));
			}
		}
	}
}

public int QuerygameMEStatsCallback(int command, int payload, int client, Handle &datapack)
{
	if ((client > 0) && (command == RAW_MESSAGE_CALLBACK_PLAYER)) {

		Handle data2 = CloneHandle(datapack);
		ResetPack(data2);
		
		// total values
		
		int points;
		
		points = ReadPackCell(data2);
		points = ReadPackCell(data2);
		points = ReadPackCell(data2);

		CloseHandle(data2);
		
		CheckRanks(client, points);	
	}
}

public Action Event_Disconnect(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if(client)
	{
		rank[client] = 0;
	}
}

public void CheckRanks(int client, int points)
{	
	if(g_RankPoints_Flag != -1)
	{
		if(!CheckCommandAccess(client, "", g_RankPoints_Flag, true))
		{
			rank[client] = 0;
			return;
		}		
	}
	
	// Unranked
	if(points < RankPoints[0])
	{
		rank[client] = 0;
	}
	// Silver I
	else if(points >= RankPoints[0] && points < RankPoints[1])
	{
		rank[client] = 1;
	}
	// Silver II
	else if(points >= RankPoints[1] && points < RankPoints[2])
	{
		rank[client] = 2;
	}
	// Silver III
	else if(points >= RankPoints[2] && points < RankPoints[3])
	{
		rank[client] = 3;
	}
	// Silver IV
	else if(points >= RankPoints[3] && points < RankPoints[4])
	{
		rank[client] = 4;
	}
	// Silver Elite
	else if(points >= RankPoints[4] && points < RankPoints[5])
	{
		rank[client] = 5;
	}
	// Silver Elite Master
	else if(points >= RankPoints[5] && points < RankPoints[6])
	{
		rank[client] = 6;
	}
	// Gold Nova I
	else if(points >= RankPoints[6] && points < RankPoints[7])
	{
		rank[client] = 7;
	}
	// Gold Nova II
	else if(points >= RankPoints[7] && points < RankPoints[8])
	{
		rank[client] = 8;
	}
	// Gold Nova III
	else if(points >= RankPoints[8] && points < RankPoints[9])
	{
		rank[client] = 9;
	}
	// Gold Nova IV
	else if(points >= RankPoints[9] && points < RankPoints[10])
	{
		rank[client] = 10;
	}
	// Master Guardian I
	else if(points >= RankPoints[10] && points < RankPoints[11])
	{
		rank[client] = 11;
	}
	// Master Guardian II
	else if(points >= RankPoints[11] && points < RankPoints[12])
	{
		rank[client] = 12;
	}
	// Master Guardian Elite
	else if(points >= RankPoints[12] && points < RankPoints[13])
	{
		rank[client] = 13;
	}
	// Distinguished Master Guardian
	else if(points >= RankPoints[13] && points < RankPoints[14])
	{
		rank[client] = 14;
	}
	// Legendary Eagle
	else if(points >= RankPoints[14] && points < RankPoints[15])
	{
		rank[client] = 15;
	}
	// Legendary Eagle Master
	else if(points >= RankPoints[15] && points < RankPoints[16])
	{
		rank[client] = 16;
	}
	// Supreme Master First Class
	else if(points >= RankPoints[16] && points < RankPoints[17])
	{
		rank[client] = 17;
	}
	// Global Elite
	else if(points >= RankPoints[17])
	{
		rank[client] = 18;
	}
	
	if(rank[client] > oldrank[client])
	{
		SetHudTextParams(-1.0, 0.125, 5.0, 255, 255, 255, 255, 0, 0.25, 1.5, 0.5);
		ShowHudText(client, 5, "%t", "Rank Up", RankStrings[rank[client]]);
	}
	
	if(rank[client] < oldrank[client])
	{
		SetHudTextParams(-1.0, 0.125, 5.0, 255, 255, 255, 255, 0, 0.25, 1.5, 0.5);
		ShowHudText(client, 5, "%t", "Rank Down", RankStrings[rank[client]]);
	}
	
	oldrank[client] = rank[client];
	
}

public void Hook_OnThinkPost(int iEnt)
{
	static int iRankOffset = -1;
	static int iRankOffsetType = -1;
	if (iRankOffset == -1)
	{
		iRankOffset = FindSendPropInfo("CCSPlayerResource", "m_iCompetitiveRanking");
	}
	if(iRankOffsetType == -1)
	{
		iRankOffsetType = FindSendPropInfo("CCSPlayerResource", "m_iCompetitiveRankType");
	}
	
	int iRank[MAXPLAYERS+1];
	int iRankType[MAXPLAYERS + 1];
	GetEntDataArray(iEnt, iRankOffset, iRank, MaxClients+1);
	for (int i = 1; i <= MaxClients; i++)
	{
		if(IsValidClient(i))
		{
			//CheckRanks(i);
			iRank[i] = rank[i];
			iRankType[i] = rankType[i];
			SetEntDataArray(iEnt, iRankOffset, iRank, MaxClients+1);
			SetEntDataArray(iEnt, iRankOffsetType, iRankType, MAXPLAYERS+1, 1);
		}
	}
}

public Action Menu_MM(int client, int args)
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}
	
	if((g_RankPoints_Flag != -1) && (CheckCommandAccess(client, "", g_RankPoints_Flag, true)))
	{
		CPrintToChat(client, "%s %t", g_RankPoints_Prefix, "No Access");
		return Plugin_Continue;
	}
	
	char buffer[256];
	Menu menu = new Menu(Menu_Handler);
	FormatEx(buffer, sizeof(buffer), "%t", "Rank Menu Title");
	
	menu.SetTitle(buffer);
	
	FormatEx(buffer, sizeof(buffer), "%t", "Change Rank Icon");
	menu.AddItem("1", buffer);
	FormatEx(buffer, sizeof(buffer), "%t", "Check Rank Points");
	menu.AddItem("2", buffer);
	menu.ExitButton = true;
	menu.Display(client, 20);
	
	return Plugin_Handled;
}

public int Menu_Handler(Menu menu, MenuAction action, int client, int choice)
{
	if(action == MenuAction_Select)
	{
		switch(choice)
		{
			case 0: Menu_Choice(client, choice);
			case 1: Menu_Points(client, choice);
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}
}

public Action Menu_Choice(int client, int args)
{
	if(!IsValidClient(client))
	{
		return Plugin_Continue;
	}
	
	char buffer[256];
	Menu menu = new Menu(Menu_Choice_Handler);
	FormatEx(buffer, sizeof(buffer), "%t", "Select Rank Icon");
	menu.SetTitle(buffer);
	
	FormatEx(buffer, sizeof(buffer), "%t", "Matchmaking Rank");
	menu.AddItem(buffer, buffer);
	
	FormatEx(buffer, sizeof(buffer), "%t", "WingMan Rank");
	menu.AddItem(buffer, buffer);
	menu.ExitButton = true;
	menu.Display(client, 20);
	
	return Plugin_Handled;
}

public int Menu_Choice_Handler(Menu menu, MenuAction action, int client, int choice)
{
	if(action == MenuAction_Select)
	{
		char info[64];
		menu.GetItem(choice, info, sizeof(info));
		switch(choice)
		{
			case 0: 
			{
				rankType[client] = 0;
				SetClientCookie(client, cookie_mm_type, "0");
			}
			case 1:
			{
				rankType[client] = 7;
				SetClientCookie(client, cookie_mm_type, "7");
			}
		}
		CPrintToChat(client, "%s %t", g_RankPoints_Prefix, "Changed Rank", info);
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}
}


public Action Menu_Points(int client, int args)
{
	Menu menu = new Menu(Panel_Handler);
	
	char buffer[256];
	
	FormatEx(buffer, sizeof(buffer), "%t", "Rank Menu Title");
	menu.SetTitle(buffer);
	
	FormatEx(buffer, sizeof(buffer), "%t", "Less Than X Points", RankStrings[0], (RankPoints[0] - 1));
	menu.AddItem("1", buffer);
	
	char S_i[2];
	for(int i = 1; i < 18; i++)
	{
		IntToString(i, S_i, sizeof(S_i));
		FormatEx(buffer, sizeof(buffer), "%t", "Between X and Y", RankStrings[i], RankPoints[i], (RankPoints[i + 1] - 1));
		menu.AddItem(S_i, buffer);
	}
	
	menu.ExitButton = true;
	menu.Display(client, 20);
}

public int Panel_Handler(Menu menu, MenuAction action, int client, int choice)
{
	if(action == MenuAction_Select)
	{
		
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}
}

public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon)
{
	if (buttons & IN_SCORE && !(GetEntProp(client, Prop_Data, "m_nOldButtons") & IN_SCORE)) {
		Handle hBuffer = StartMessageOne("ServerRankRevealAll", client);
		if (hBuffer == INVALID_HANDLE)
		{
			PrintToChat(client, "INVALID_HANDLE");
		}
		else
		{
			EndMessage();
		}
	}
	return Plugin_Continue;
}

public Action Event_AnnouncePhaseEnd(Handle event, const char[] name, bool dontBroadcast)
{
	Handle hBuffer = StartMessageAll("ServerRankRevealAll");
	if (hBuffer == INVALID_HANDLE)
	{
		PrintToServer("ServerRankRevealAll = INVALID_HANDLE");
	}
	else
	{
		EndMessage();
	}
	return Plugin_Continue;
}

stock bool IsValidClient(int client)
{
	if(client >= 1 && client <= MaxClients && IsClientConnected(client) && IsClientInGame(client))
	{
		return true;
	}
	
	return false;
}