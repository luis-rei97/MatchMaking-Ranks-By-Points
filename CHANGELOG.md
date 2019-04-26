# [CS:GO] Fake Ranks (By Player Points) - Changelog

Just to note every change that was made since the plugin's release.
If you want to see every function that the plugin has, read the [README.md](https://github.com/hallucinogenic/MatchMaking-Ranks-By-Points/blob/master/README.md)  file;

## Version 1.0

- Plugin Release

## Version 1.1

- Removed the possibility to change the rank icon (not possible anymore with the Panorama UI, unless you play on wingman mode);
- Fixed a few bugs related to flags;

## Version 1.2

- Resolved a bug related to RankMe Points;

## Version 1.3 and 1.4

- Now it will check player's points when he dies, kills or assists;
- Added a new CVAR: **ranks_matchmaking_hudoverlay** (Default: 1) -> Chooses between a HUD Text Message (0) or an Overlay (1). Overlays are made by RoadSide Romeo;
- Added a new CVAR: **ranks_matchmaking_soundenable** (Default: 1) -> Enable sounds when a player ranks up or deranks;
- Added a new CVAR: **ranks_matchmaking_soundrankup** (Default: "levels_ranks/levelup.mp3") -> Path to the sound which will play on Rank Up (needs **ranks_matchmaking_soundenable** set to 1);
- Added a new CVAR: **ranks_matchmaking_soundrankdown** (Default: "levels_ranks/leveldown.mp3") -> Path to the sound which will play on Derank (needs **ranks_matchmaking_soundenable** set to 1);
- Disable counter for Bots (since it doesn't make any sense);
- Added the Overlay Files made by RoadSide Romeo;
- Added the Sound Files made by RoadSide Romeo; 