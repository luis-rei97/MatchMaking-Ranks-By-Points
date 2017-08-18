#include <sourcemod>
#include <sdkhooks>
#include <sdktools>
#include <cstrike>
#include <clientprefs>
#include <kento_rankme/rankme>

#pragma newdecls required

int rank[MAXPLAYERS+1];

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
	RegConsoleCmd("sm_mmhelp", Menu_MM);
}


public void OnMapStart()
{
	int iIndex = FindEntityByClassname(MaxClients+1, "cs_player_manager");
	if (iIndex == -1) {
		SetFailState("Unable to find cs_player_manager entity");
	}
	
	SDKHook(iIndex, SDKHook_ThinkPost, Hook_OnThinkPost);
}

public void CheckRanks(int client)
{
	int points = RankMe_GetPoints(client);
	
	// Unranked
	if(points < 100)
	{
		rank[client] = 0;
	}
	// Silver I
	else if(points >= 100 && points < 150)
	{
		rank[client] = 1;
	}
	// Silver II
	else if(points >= 150 && points < 200)
	{
		rank[client] = 2;
	}
	// Silver III
	else if(points >= 200 && points < 300)
	{
		rank[client] = 3;
	}
	// Silver IV
	else if(points >= 300 && points < 400)
	{
		rank[client] = 4;
	}
	// Silver Elite
	else if(points >= 400 && points < 500)
	{
		rank[client] = 5;
	}
	// Silver Elite Master
	else if(points >= 500 && points < 600)
	{
		rank[client] = 6;
	}
	// Gold Nova I
	else if(points >= 600 && points < 750)
	{
		rank[client] = 7;
	}
	// Gold Nova II
	else if(points >= 750 && points < 900)
	{
		rank[client] = 8;
	}
	// Gold Nova III
	else if(points >= 900 && points < 1050)
	{
		rank[client] = 9;
	}
	// Gold Nova IV
	else if(points >= 1050 && points < 1200)
	{
		rank[client] = 10;
	}
	// Master Guardian I
	else if(points >= 1200 && points < 1400)
	{
		rank[client] = 11;
	}
	// Master Guardian II
	else if(points >= 1400 && points < 1600)
	{
		rank[client] = 12;
	}
	// Master Guardian Elite
	else if(points >= 1600 && points < 1800)
	{
		rank[client] = 13;
	}
	// Distinguished Master Guardian
	else if(points >= 1800 && points < 2000)
	{
		rank[client] = 14;
	}
	// Legendary Eagle
	else if(points >= 2000 && points < 2200)
	{
		rank[client] = 15;
	}
	// Legendary Eagle Master
	else if(points >= 2200 && points < 2400)
	{
		rank[client] = 16;
	}
	// Supreme Master First Class
	else if(points >= 2400 && points < 2700)
	{
		rank[client] = 17;
	}
	// Global Elite
	else if(points >= 2700)
	{
		rank[client] = 18;
	}
	
}

stock bool IsValidClient(int client)
{
	if(client >= 1 && client <= MaxClients && IsClientConnected(client) && IsClientInGame(client) && (GetUserFlagBits(client) && ADMFLAG_CUSTOM1))
	{
		return true;
	}
	
	return false;
}

public void Hook_OnThinkPost(int iEnt)
{
	static int iRankOffset = -1;
	if (iRankOffset == -1)
	{
		iRankOffset = FindSendPropInfo("CCSPlayerResource", "m_iCompetitiveRanking");
	}
	int iRank[65];
	GetEntDataArray(iEnt, iRankOffset, iRank, MaxClients+1);
	for (int i = 1; i <= MaxClients; i++) 
	{
		if(IsValidClient(i))
		{
			CheckRanks(i);
			iRank[i] = rank[i];
			SetEntDataArray(iEnt, iRankOffset, iRank, MaxClients+1);
		}
	}
}



public int MM_Menu_Handler(Menu menu_facas, MenuAction action, int param1, int param2)
{
	if(action == MenuAction_Select)
	{
	}
	else if (action == MenuAction_End)
	{
		delete menu_facas;
	}
}

public Action Menu_MM(int client, int args)
{
	Menu menu_facas = new Menu(MM_Menu_Handler)
	menu_facas.SetTitle("Menu de Ajuda dos Ranks de Matchmaking\nCriado pela comunidade PT'Fun");
	menu_facas.AddItem("0", "Unranked - Menos do que 99 pontos;", ITEMDRAW_DISABLED);
	menu_facas.AddItem("1", "Silver I - Entre 100 a 149 pontos;", ITEMDRAW_DISABLED);
	menu_facas.AddItem("2", "Silver II - Entre 150 a 199 pontos;", ITEMDRAW_DISABLED);
	menu_facas.AddItem("3", "Silver III - Entre 200 a 299 pontos;", ITEMDRAW_DISABLED);
	menu_facas.AddItem("4", "Silver IV - Entre 300 a 399 pontos;", ITEMDRAW_DISABLED);
	menu_facas.AddItem("5", "Silver Elite - Entre 400 a 499 pontos;", ITEMDRAW_DISABLED);
	menu_facas.AddItem("6", "Silver Elite Master - Entre 500 a 599 pontos;", ITEMDRAW_DISABLED);
	menu_facas.AddItem("7", "Gold Nova I - Entre 600 a 749 pontos;", ITEMDRAW_DISABLED);
	menu_facas.AddItem("8", "Gold Nova II - Entre 750 a 899 pontos;", ITEMDRAW_DISABLED);
	menu_facas.AddItem("9", "Gold Nova III - Entre 900 a 1049 pontos;", ITEMDRAW_DISABLED);
	menu_facas.AddItem("10", "Gold Nova IV - Entre 1050 a 1199 pontos;", ITEMDRAW_DISABLED);
	menu_facas.AddItem("11", "Master Guardian I - Entre 1200 a 1399 pontos;", ITEMDRAW_DISABLED);
	menu_facas.AddItem("12", "Master Guardian II - Entre 1400 a 1599 pontos;", ITEMDRAW_DISABLED);
	menu_facas.AddItem("13", "Master Guardian Elite - Entre 1600 a 1799 pontos;", ITEMDRAW_DISABLED);
	menu_facas.AddItem("14", "Distinguished Master Guardian - Entre 1800 a 1999 pontos;", ITEMDRAW_DISABLED);
	menu_facas.AddItem("15", "Legendary Eagle - Entre 2000 a 2199 pontos;", ITEMDRAW_DISABLED);
	menu_facas.AddItem("16", "Legendary Eagle Master - Entre 2200 a 2399 pontos;", ITEMDRAW_DISABLED);
	menu_facas.AddItem("17", "Supreme Master First Class - Entre 2400 a 2699 pontos;", ITEMDRAW_DISABLED);
	menu_facas.AddItem("18", "Global Elite - Mais do que 2700 pontos;", ITEMDRAW_DISABLED);
	menu_facas.ExitButton = true;
	menu_facas.Display(client, 20);
}