# [CS:GO] Matchmaking Ranks by Points

Prints the Matchmaking Ranks on scoreboard, based on points stats by a certain rank.

## Requirements: 

- [Sourcemod](https://www.sourcemod.net/);

 The Following Plugins can be optional, you just need to have one of them enabled:

- [[ZR/ZP] Rank](https://github.com/hallucinogenic/-ZR-Zombie-Rank)
- [Kento RankMe](https://forums.alliedmods.net/showthread.php?t=290063)
- [Game Me](https://www.gameme.com/)

The following is just for those who want to compile the plugin:
- [Overlays](https://forums.alliedmods.net/showthread.php?p=2526683); 

### Commands

- **sm_mm** - It opens the Ranks Menu, with the option to check the rank points;

### ConVars

- **ranks_matchmaking_typeofrank** (Default: 0) - Type of Rank that you want to use for this plugin (0 for Kento Rankme, 1 for GameMe, 2 for ZR Rank)
- **ranks_matchmaking_prefix** (Default: "[{purple}Fake Ranks{default}]") - Chat Prefix
- **ranks_matchmaking_flag** (Default: 0) - Flag to restrict the ranks to certain players (0 enable the ranks for everyone)
- **ranks_matchmaking_point_s1** (Default: 100) - Number of Points to reach Silver I
- **ranks_matchmaking_point_s2** (Default: 150) - Number of Points to reach Silver II
- **ranks_matchmaking_point_s3** (Default: 200) - Number of Points to reach Silver III
- **ranks_matchmaking_point_s4** (Default: 300) - Number of Points to reach Silver IV
- **ranks_matchmaking_point_se** (Default: 400) - Number of Points to reach Silver Elite
- **ranks_matchmaking_point_sem** (Default: 500) - Number of Points to reach Silver Elite Master
- **ranks_matchmaking_point_g1** (Default: 600) - Number of Points to reach Gold Nova I
- **ranks_matchmaking_point_g2** (Default: 750) - Number of Points to reach Gold Nova II
- **ranks_matchmaking_point_g3** (Default: 900) - Number of Points to reach Gold Nova III
- **ranks_matchmaking_point_g4** (Default: 1050) - Number of Points to reach Gold Nova IV
- **ranks_matchmaking_point_mg1** (Default: 1200) - Number of Points to reach Master Guardian I
- **ranks_matchmaking_point_mg2** (Default: 1400) - Number of Points to reach Master Guardian II
- **ranks_matchmaking_point_mge** (Default: 1600) - Number of Points to reach Master Guardian Elite
- **ranks_matchmaking_point_dmg** (Default: 1800) - Number of Points to reach Distinguished Master Guardian
- **ranks_matchmaking_point_le** (Default: 2000) - Number of Points to reach Legendary Eagle
- **ranks_matchmaking_point_lem** (Default: 2200) - Number of Points to reach Legendary Eagle Master
- **ranks_matchmaking_point_smfc** (Default: 2400) - Number of Points to reach Supreme Master First Class
- **ranks_matchmaking_point_ge** (Default: 2700) - Number of Points to reach Global Elite
- **ranks_matchmaking_hudoverlay** (Default: 1) -> Chooses between a HUD Text Message (0) or an Overlay (1). Overlays are made by RoadSide Romeo;
- **ranks_matchmaking_soundenable** (Default: 1) -> Enable sounds when a player ranks up or deranks;
- **ranks_matchmaking_soundrankup** (Default: "levels_ranks/levelup.mp3") -> Path to the sound which will play on Rank Up (needs **ranks_matchmaking_soundenable** set to 1);
- **ranks_matchmaking_soundrankdown** (Default: "levels_ranks/leveldown.mp3") -> Path to the sound which will play on Derank (needs **ranks_matchmaking_soundenable** set to 1);


I hope you enjoyed, and I'll keep this repository updated as soon as I update the plugin!

My Steam Profile if you have any questions -> http://steamcommunity.com/id/HallucinogenicTroll/

My Website -> http://HallucinogenicTrollConfigs.com/
