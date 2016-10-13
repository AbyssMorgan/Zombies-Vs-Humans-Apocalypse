/****************************************************************************************************
 *                                                                                                  *
 *                          Zombie vs Human Apoclaypse DeathMatch Gamemode                          *
 *                                                                                                  *
 * Copyright © 2016 Owen007. All rights reserved.                                                   *
 *                                                                                                  *
 * Download: https://github.com/AbyssMorgan/Zombies-Vs-Humans-Apocalypse                            *
 *                                                                                                  *
 * Plugins: Streamer, SScanf, SAOI                                                                  *
 * Modules: N/A                                                                                     *
 *                                                                                                  *
 * File Version: 1.4.0                                                                              *
 * SA:MP Version: 0.3.7                                                                             *
 * Streamer Version: 2.8.2                                                                          *
 * SScanf Version: 2.8.2                                                                            *
 * SAOI Version: 1.4.2                                                                              *
 *                                                                                                  *
 ****************************************************************************************************/

//Includes:
#include <a_samp>		// these are includes u can see these files in include folder
#include <streamer>		// u have to download streamer.dll in plugins and u have to add it in server.cfg
#include <sscanf2>
#include <y_ini>
#include <izcmd>
#include <foreach>

#include <samc>
#include <GAC>

#include <SAOI>

#include <3DTryg>
#include <Knife>

#define OBJECT_FILE 		"Zombie.saoi"

//Teams:

#define TEAM_ZOMBIE			1	//defines used to define a team.
#define TEAM_HUMAN 			2

//Colors:

#define TEAM_ZOMBIE_COLOR	0xB360FDFF	// these are the colors i used in gamemode everywhere you can add more.
#define TEAM_HUMAN_COLOR	0x21DD00FF
#define ORANGE				0xF97804FF
#define BLUE 				0x1229FAFF
#define GRAY 				0xCECECEFF
#define GREEN 				0x21DD00FF
#define red 				0xFF0000AA
#define LIGHTBLUE 			0x00C2ECFF
#define PURPLE 				0xB360FDFF
#define COLOR_RED 			0xFF0000FF
#define COLOR_YELLOW 		0xFFFF00AA
#define COLOR_ORANGE 		0xFF9900AA
#define COL_WHITE 			"{FFFFFF}"
#define COL_RED 			"{F81414}"
#define COL_GREEN 			"{00FF22}"
#define COL_LIGHTBLUE 		"{00CED1}"
#define ORANGE 				0xF97804FF
#define BLUE 				0x1229FAFF
#define COL_WHITE 			"{FFFFFF}"
#define COL_RED 			"{F81414}"
#define COL_GREEN			"{00FF22}"
#define COL_LIGHTBLUE		"{00CED1}"
#define COLOR_GRAD1 		0xB4B5B7FF
#define COLOR_GRAD2 		0xBFC0C2FF
#define COLOR_GRAD3 		0xCBCCCEFF
#define COLOR_GRAD4 		0xD8D8D8FF
#define COLOR_GRAD5 		0xE3E3E3FF
#define COLOR_GRAD6 		0xF0F0F0FF
#define COLOR_GREY 			0xAFAFAFAA
#define COLOR_GREEN 		0x33AA33AA
#define COLOR_RED 			0xFF0000FF
#define COLOR_YELLOW 		0xFFFF00AA
#define COLOR_WHITE 		0xFFFFFFAA
#define COLOR_FADE1 		0xE6E6E6E6
#define COLOR_FADE2 		0xC8C8C8C8
#define COLOR_FADE3 		0xAAAAAAAA
#define COLOR_FADE4 		0x8C8C8C8C
#define COLOR_FADE5 		0x6E6E6E6E
#define COLOR_PURPLE 		0xC2A2DAAA
#define COLOR_DARKBLUE 		0x2641FEAA
#define COLOR_ALLDEPT 		0xFF8282AA
#define COLOR_ADMIN 		0xD2CAAEFF

//ranks
#define RANK_0_SCORE 0
#define RANK_1_SCORE 150
#define RANK_2_SCORE 350
#define RANK_3_SCORE 600
#define RANK_4_SCORE 900
#define RANK_5_SCORE 1200
#define RANK_6_SCORE 1500
#define RANK_7_SCORE 2000

#define CLASS_DIALOG 0
#define DIALOG_RANKS 1

//register:

#define DIALOG_REGISTER 1
#define DIALOG_LOGIN 2
#define DIALOG_SUCCESS_1 3
#define DIALOG_SUCCESS_2 4

#define PATH "ZVH/Users/%s.ini"

#define KEY_AIM 	(128)

#define MAX_GROUPS 	20

//enums:

enum ZVHInfo {
	ZVHPass,
	ZVHCash,
	ZVHKills,
	ZVHDeaths,
	ZVHScore
};

enum ginfo {
	grname[75],
	leader,
	active
};

enum pginfo {
	gid,
	order,
	invited,
	attemptjoin
};

enum PMInfo {
	LastPM,
	NoPM,
};

//forwards:

forward StartEngine(playerid);
forward DamagedEngine(playerid);
forward GetClosestPlayer(p1);
forward GetClosestPlayers(playerid);
forward LoadUser_data(playerid,name[],value[]);
forward ResetPlayerCP(playerid);
forward SendRandomMsgToAll();
forward timer_update();
forward timer_refuel(playerid);
forward TransMission(playerid);

//new:

new gTeam[MAX_PLAYERS],
	vehEngine[MAX_VEHICLES],
	flashlight,
	lastTPTime[MAX_PLAYERS],
	PlayerInfo[MAX_PLAYERS][ZVHInfo],
	pCPEnable [MAX_PLAYERS],
	NPCVehicle,
	NPCVehicle2,
	NPCVehicle3,
	NPCVehicle4,
	Text:td_fuel[MAX_PLAYERS],
	Text:td_vhealth[MAX_PLAYERS],
	Text:td_vspeed[MAX_PLAYERS],
	Text:td_box[MAX_PLAYERS],
	isrefuelling[MAX_PLAYERS] = 0,
	fuel[MAX_VEHICLES],
	Float:max_vhealth[MAX_VEHICLES],
	Engine[MAX_PLAYERS],
	group[MAX_PLAYERS][pginfo],
	groupinfo[MAX_GROUPS][ginfo],
	COUNTER,
	pInfo[MAX_PLAYERS][PMInfo];

stock PrintSAOIErrorName(SAOI:index){
	switch(index){
		case SAOI_ERROR_UNEXEC: 				printf("Error function unexecutable");
		case SAOI_ERROR_SUCCESS:				printf("Success");
		case SAOI_ERROR_INPUT_NOT_EXIST: 		printf("Error input file not exist");
		case SAOI_ERROR_OUTPUT_NOT_EXIST: 		printf("Error output file not exist");
		case SAOI_ERROR_INPUT_EXIST: 			printf("Error input file exist");
		case SAOI_ERROR_OUTPUT_EXIST:		 	printf("Error output file exist");
		case SAOI_ERROR_INPUT_NOT_OPEN: 		printf("Error open input file");
		case SAOI_ERROR_OUTPUT_NOT_OPEN: 		printf("Error open output file");
		case SAOI_ERROR_FILE_SIZE: 				printf("Error invalid file size");
		case SAOI_ERROR_INVALID_OBJECTID:	 	printf("Error invalid objectid");
		case SAOI_ERROR_AUTHOR_SIZE: 			printf("Error invalid author size");
		case SAOI_ERROR_VERSION_SIZE: 			printf("Error invalid version size");
		case SAOI_ERROR_DESCRIPTION_SIZE:	 	printf("Error invalid description size");
		case SAOI_ERROR_INVALID_HEADER: 		printf("Error invalid header");
		case SAOI_ERROR_INPUT_EXTENSION: 		printf("Error invalid input extension");
		case SAOI_ERROR_OUTPUT_EXTENSION: 		printf("Error invalid output extension");
		case SAOI_ERROR_NOT_ENOUGH_CAPACITY: 	printf("Error not enough capacity, to load new file");
		case SAOI_ERROR_INVALID_ARG_COUNT: 		printf("Error number of arguments exceeds the specified arguments");
	}
}

// this is printed on console of samp
main(){
	print("\n------------------------------------------");
	print("                                            ");
	print(" Zombie vs Humans Apoclaypse v1.3 by Owen007");
	print("                                            ");
	print("------------------------------------------\n");
}

public OnGameModeInit(){
	ToggleKnifeShootForAll(false);
	ToggleUseTeamKnifeShoot(true);
	
	SetGameModeText("Zombies Vs Humans Apocalypse v1.3"); // this is gamemode text when some connect to your sever
	
	for(new i = 0; i < MAX_VEHICLES; i++){
		GetVehicleHealth(i,max_vhealth[i]); //getting max health
		fuel[i] = 250 + random(150);  //setting fuel for vehicles
	}
	
	for(new i = 0; i < MAX_PLAYERS; i++){ //setting up all textdraws
		group[i][gid] = -1;
		group[i][order] = -1;
		group[i][invited] = -1;
		group[i][attemptjoin] = -1;
		
		td_fuel[i] = TextDrawCreate(476,355,"Fuel:");
		td_vhealth[i] = TextDrawCreate(478,376,"Health:");
		td_vspeed[i] = TextDrawCreate(478,397,"Speed:");
		td_box[i] = TextDrawCreate(478.000000,328.000000,"Vehicle Stats: ~n~~n~~n~~n~");
		TextDrawUseBox(td_box[i],1);
		TextDrawBoxColor(td_box[i],0x00000066);
		TextDrawTextSize(td_box[i],626.000000,21.000000);
		TextDrawAlignment(td_fuel[i],0);
		TextDrawAlignment(td_vhealth[i],0);
		TextDrawAlignment(td_vspeed[i],0);
		TextDrawAlignment(td_box[i],0);
		TextDrawBackgroundColor(td_fuel[i],0x000000ff);
		TextDrawBackgroundColor(td_vhealth[i],0x000000ff);
		TextDrawBackgroundColor(td_vspeed[i],0x000000ff);
		TextDrawBackgroundColor(td_box[i],0x000000cc);
		TextDrawFont(td_fuel[i],1);
		TextDrawLetterSize(td_fuel[i],0.699999,2.699999);
		TextDrawFont(td_vhealth[i],1);
		TextDrawLetterSize(td_vhealth[i],0.699999,2.699999);
		TextDrawFont(td_vspeed[i],1);
		TextDrawLetterSize(td_vspeed[i],0.699999,2.699999);
		TextDrawFont(td_box[i],0);
		TextDrawLetterSize(td_box[i],0.699999,2.899999);
		TextDrawColor(td_fuel[i],0xffffffff);
		TextDrawColor(td_vhealth[i],0xffffffff);
		TextDrawColor(td_vspeed[i],0xffffffff);
		TextDrawColor(td_box[i],0xffffffff);
		TextDrawSetOutline(td_fuel[i],1);
		TextDrawSetOutline(td_vhealth[i],1);
		TextDrawSetOutline(td_vspeed[i],1);
		TextDrawSetOutline(td_box[i],1);
		TextDrawSetProportional(td_fuel[i],1);
		TextDrawSetProportional(td_vhealth[i],1);
		TextDrawSetProportional(td_vspeed[i],1);
		TextDrawSetProportional(td_box[i],1);
		TextDrawSetShadow(td_fuel[i],1);
		TextDrawSetShadow(td_vhealth[i],1);
		TextDrawSetShadow(td_vspeed[i],1);
		TextDrawSetShadow(td_box[i],10);
	}
	
	SetTimer("TransMission", 300 * 1000, 1);
	SetTimer("timer_update",1000,true);
	
  	ConnectNPC("Owen007","owen");
	ConnectNPC("AbyssMorgan","npc2");
	ConnectNPC("Sreyas","npc3");
	ConnectNPC("FahadKing","npc4");
	
	NPCVehicle = CreateVehicle(425, 0.0, 0.0, 5.0, 0.0, 3, 3, 5000);
	NPCVehicle2 = CreateVehicle(548, 0.0, 0.0, 5.0, 0.0, 3, 3, 5000);
  	NPCVehicle3 = CreateVehicle(596, 0.0, 0.0, 5.0, 0.0, 3, 3, 5000);
  	NPCVehicle4 = CreateVehicle(415, 0.0, 0.0, 5.0, 0.0, 3, 3, 5000);
	
 	for(new i = 0, j = GetMaxPlayers(); i < j; i++){
  		SetPVarInt(i, "laser", 0);
		SetPVarInt(i, "color", 18643);
  	}
  	SetTimer("SendRandomMsgToAll", 60 * 1000, 1);
	
	// skins of zombies and humans u can check more skins on samp wiki
	AddPlayerClass(75,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(77,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(78,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(79,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(135,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(137,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(160,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(162,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(168,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(181,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(200,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);

	//----------------------Zombies till here---------------------------//
	AddPlayerClass(19,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(21,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(23,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(29,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(33,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(34,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(41,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(280,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(281,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(282,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(283,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(284,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(285,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(286,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(287,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(288,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(36,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(37,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(38,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(39,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(40,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(41,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(43,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(44,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(45,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(46,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(47,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(48,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(49,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(50,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(51,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(52,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(54,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(55,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(56,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(57,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(58,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(59,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(61,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(62,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(30,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(64,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(68,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(69,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(66,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(70,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(72,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(73,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(120,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(76,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(80,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(81,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(82,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(83,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(84,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(1,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(2,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(3,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(4,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(5,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(6,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(7,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(9,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(11,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(12,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(15,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	AddPlayerClass(16,1285.8182,-1349.8336,13.5676,95.4816,0,0,0,0,-1,-1);
	//--------------Humans till here---------------------------------------------//

	//--these are maps--//
	new SAOI:edi = LoadObjectImage(OBJECT_FILE);
	if(SAOIToInt(edi) <= 0){
		printf("Cannot load file: %s",OBJECT_FILE);
		PrintSAOIErrorName(edi);
	}
	
	//--these are vehicles--//

	AddStaticVehicleEx(411,2716.7959,-1483.2106,30.1314,251.6073,-1,-1,900000000);
	AddStaticVehicleEx(404,1629.8917,-1743.1121,13.2878,141.1261,-1,-1,900000000);
	AddStaticVehicleEx(421,1565.4016,-1713.8560,5.7113,236.5188,-1,-1,900000000);
	AddStaticVehicleEx(474,1587.3004,-1683.4016,5.8953,38.5644,-1,-1,900000000);
	AddStaticVehicleEx(482,1532.8781,-1665.2383,5.8065,17.1373,-1,-1,900000000);
	AddStaticVehicleEx(596,1366.6138,-1343.1136,13.2736,321.9597,-1,-1,900000000);
	AddStaticVehicleEx(596,1862.9048,-1624.7119,13.1859,221.4377,-1,-1,900000000);
	AddStaticVehicleEx(596,1905.9236,-1794.8483,13.2436,129.5648,-1,-1,900000000);
	AddStaticVehicleEx(492,2511.9375,-1675.5464,13.2550,265.3749,-1,-1,900000000);
	AddStaticVehicleEx(605,2265.0649,-1177.3547,25.4320,61.6267,-1,-1,900000000);
	AddStaticVehicleEx(554,2140.2673,-1478.6140,24.4900,269.1666,-1,-1,900000000);
	AddStaticVehicleEx(478,1131.4677,-1563.6698,13.2778,117.3689,-1,-1,900000000);
	AddStaticVehicleEx(470,767.0110,-1374.6483,13.5780,332.4633,-1,-1,900000000);
	AddStaticVehicleEx(470,770.9357,-1313.1030,13.5438,236.8060,-1,-1,900000000);
	AddStaticVehicleEx(470,1201.9641,-1304.3855,13.3799,89.8941,-1,-1,900000000);
	AddStaticVehicleEx(416,1185.8658,-1319.9949,13.7402,217.6576,-1,-1,900000000);
	AddStaticVehicleEx(596,1520.4373,-1638.3848,13.1572,48.9988,-1,-1,900000000);
	AddStaticVehicleEx(433,2498.4272,-1656.7836,13.7996,102.8038,-1,-1,900000000);
	AddStaticVehicleEx(475,2341.4219,-1198.0060,27.7636,42.9352,-1,-1,900000000);
	AddStaticVehicleEx(543,1784.0070,-1929.7269,13.2090,96.5996,-1,-1,900000000);
	AddStaticVehicleEx(442,1010.9857,-1359.9019,13.1928,300.7962,-1,-1,900000000);
	AddStaticVehicleEx(475,974.1854,-1290.4635,13.3441,110.1271,-1,-1,900000000);
	AddStaticVehicleEx(400,819.5186,-1647.7156,13.5952,201.6994,-1,-1,900000000);
	AddStaticVehicleEx(426,620.8862,-1512.0173,14.7400,181.2187,-1,-1,900000000);
	AddStaticVehicleEx(410,1044.5110,-1812.9313,13.2567,270.3563,-1,-1,900000000);
	AddStaticVehicleEx(408,844.5776,-1415.0176,14.0509,106.8727,-1,-1,900000000);
	AddStaticVehicleEx(475,1707.2213,-1558.1350,13.3840,91.6726,-1,-1,900000000);
	AddStaticVehicleEx(420,1348.6992,-1756.9594,13.2632,139.1747,6,1,900000000);
	AddStaticVehicleEx(475,1707.2213,-1558.1350,13.3840,91.6726,-1,-1,900000000);
	AddStaticVehicleEx(574,1905.3167,-1388.3359,10.0697,69.5486,-1,-1,900000000);
	AddStaticVehicleEx(463,2086.8296,-1183.1477,25.2465,311.9219,-1,-1,900000000);
	AddStaticVehicleEx(400,1694.5714,-1275.1576,14.8934,113.7021,-1,-1,900000000);
	AddStaticVehicleEx(433,2734.5894,-1082.5614,69.7857,57.4097,-1,-1,900000000);
	AddStaticVehicleEx(409,2716.7913,-1065.5796,69.2382,87.7282,-1,-1,900000000);
	AddStaticVehicleEx(420,1775.3574,-1898.3773,13.2047,328.8666,6,1,900000000);
	AddStaticVehicleEx(405,744.2248,-1660.6022,4.2649,160.7608,-1,-1,900000000);
	AddStaticVehicleEx(540,2110.4136,-1342.1595,23.8444,238.4238,-1,-1,900000000);
	AddStaticVehicleEx(596,2662.4844,-1853.6599,10.6366,271.5253,-1,-1,900000000);
	AddStaticVehicleEx(470,367.8412,-2044.0714,7.6711,0.9245,-1,-1,900000000);
	AddStaticVehicleEx(470,372.8668,-2044.7147,7.6677,357.7654,-1,-1,900000000);
	AddStaticVehicleEx(470,2715.3845,-1117.0339,69.5732,111.3182,-1,-1,900000000);
	AddStaticVehicleEx(507,748.4423,-1340.9810,13.3288,154.5402,-1,-1,900000000);
	AddStaticVehicleEx(411,1889.9000000,-2583.1001000,13.3000000,0.0000000,164,167,15);
	AddStaticVehicleEx(411,1889.9004000,-2583.0996000,13.3000000,0.0000000,164,167,15);
	AddStaticVehicleEx(411,1890.1000000,-2580.2000000,16.7000000,0.0000000,93,126,15);
	AddStaticVehicleEx(522,1871.2000000,-2580.2000000,16.5000000,0.0000000,48,79,15);
	AddStaticVehicleEx(522,1874.2000000,-2581.5000000,16.5000000,0.0000000,48,79,15);
	AddStaticVehicleEx(522,1876.2000000,-2580.7000000,16.5000000,0.0000000,189,190,15);
	AddStaticVehicleEx(416,2058.6001000,-2455.3999000,13.8000000,0.0000000,245,245,15);
	AddStaticVehicleEx(427,1695.8000000,-2584.6001000,13.8000000,0.0000000,-1,-1,15);

	return 1;
}

public LoadUser_data(playerid,name[],value[]){
	INI_Int("Password",PlayerInfo[playerid][ZVHPass]);
	INI_Int("Cash",PlayerInfo[playerid][ZVHCash]);
	INI_Int("Kills",PlayerInfo[playerid][ZVHKills]);
	INI_Int("Deaths",PlayerInfo[playerid][ZVHDeaths]);
	INI_Int("Score",PlayerInfo[playerid][ZVHScore]);
	return 1;
}

stock UserPath(playerid){
	new string[128],playername[MAX_PLAYER_NAME];
	GetPlayerName(playerid,playername,sizeof(playername));
	format(string,sizeof(string),PATH,playername);
	return string;
}

stock udb_hash(buf[]){
	new s1 = 1, s2 = 0;
	for(new i = 0, j = strlen(buf); i < j; i++){
		s1 = (s1 + buf[i]) % 65521;
		s2 = (s2 + s1)	 % 65521;
	}
	return (s2 << 16) + s1;
}

public OnGameModeExit(){
	// u can add here wut to do when gamemode is exiting
	for(new i = 0; i < MAX_PLAYERS; i++){
		TextDrawDestroy(td_fuel[i]);
		TextDrawDestroy(td_vhealth[i]);
		TextDrawDestroy(td_vspeed[i]);
		TextDrawDestroy(td_box[i]);
	}
	
  	for(new i = 0, j = GetMaxPlayers(); i < j; i++){
		SetPVarInt(i, "laser", 0);
	 	RemovePlayerAttachedObject(i, 0);
	}
 	return 1;
}

public OnPlayerConnect(playerid){
	//this is on player connect u can do add any things like on player connect send him welcome message or more.
	group[playerid][gid] = -1;
	group[playerid][invited] = -1;
	group[playerid][attemptjoin] = -1;
	if(IsPlayerNPC(playerid)){
		SpawnPlayer(playerid);
	}
	
	pCPEnable[playerid] = true;
	PlayerInfo[playerid][ZVHScore] = 0;
	
	if(fexist(UserPath(playerid))){
		INI_ParseFile(UserPath(playerid), "LoadUser_%s", .bExtra = true, .extra = playerid);
		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,""COL_WHITE"Login",""COL_WHITE"Account already registered enter your password to signin.","Login","Quit");
	} else {
		ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD,""COL_WHITE"Registering...",""COL_WHITE"Register your account at Zombies VS Humans","Register","Quit");
	}
	
 	new pname[MAX_PLAYER_NAME], string[22 + MAX_PLAYER_NAME];
	GetPlayerName(playerid, pname, sizeof(pname));
	format(string, sizeof(string), "%s has joined the server", pname);
	SendClientMessageToAll(GREEN, string);
	lastTPTime[playerid] = 0;
	return 1;
}

public OnPlayerDisconnect(playerid, reason){
	//-- on player disconnect bla bla
	LeaveGroup(playerid, 2);
 	SetPVarInt(playerid, "laser", 0);
  	RemovePlayerAttachedObject(playerid, 0);
	new INI:File = INI_Open(UserPath(playerid));
	INI_SetTag(File,"data");
	INI_WriteInt(File,"Cash",GetPlayerMoney(playerid));
	INI_WriteInt(File,"Kills",PlayerInfo[playerid][ZVHKills]);
	INI_WriteInt(File,"Deaths",PlayerInfo[playerid][ZVHDeaths]);
	INI_WriteInt(File,"Score",GetPlayerScore(playerid));
	INI_Close(File);
	new pName[MAX_PLAYER_NAME], string[56];
	GetPlayerName(playerid, pName, sizeof(pName));
	switch(reason){
		case 0: format(string, sizeof(string), "%s has left the server. (Lost Connection)", pName);
		case 1: format(string, sizeof(string), "%s has left the server. (Leaving)", pName);
		case 2: format(string, sizeof(string), "%s has left the server. (Kicked)", pName);
	}
	SendClientMessageToAll(BLUE, string);
	return 1;
}

CMD:ranks(playerid,params[]){
	ShowPlayerDialog(playerid,1,DIALOG_STYLE_MSGBOX,"Ranks",""COL_WHITE"0 - Freshmeat ("#RANK_0_SCORE" score)\n1 - Bandit ("#RANK_1_SCORE" score)\n2 - Survivor ("#RANK_2_SCORE" score)\n3 - Manhunt ("#RANK_3_SCORE" score)\n4 - Zombie Hunter ("#RANK_4_SCORE" score)\n5 - Specialist ("#RANK_5_SCORE" score)\n6 - Mastermind ("#RANK_6_SCORE" score)\n7 - Terminator ("#RANK_7_SCORE" score)","OK","");
	return 1;
}

CMD:myrank(playerid,params[]){
	if(GetPlayerScore(playerid) >= RANK_0_SCORE && GetPlayerScore(playerid) < RANK_1_SCORE){
		SendClientMessage(playerid,COLOR_WHITE,"Your current rank is 'Freshmeat' (Rank 0)");
		SendClientMessage(playerid,COLOR_WHITE,"Type /ranks to find out more information about ranks");
	}
	if(GetPlayerScore(playerid) >= RANK_1_SCORE && GetPlayerScore(playerid) < RANK_2_SCORE){
		SendClientMessage(playerid,COLOR_WHITE,"Your current rank is 'Bandit' (Rank 1)");
		SendClientMessage(playerid,COLOR_WHITE,"Type /ranks to find out more information about ranks");
	}
	if(GetPlayerScore(playerid) >= RANK_2_SCORE && GetPlayerScore(playerid) < RANK_3_SCORE){
		SendClientMessage(playerid,COLOR_WHITE,"Your current rank is 'Survivor' (Rank 2)");
		SendClientMessage(playerid,COLOR_WHITE,"Type /ranks to find out more information about ranks");
	}
	if(GetPlayerScore(playerid) >= RANK_3_SCORE && GetPlayerScore(playerid) < RANK_4_SCORE){
		SendClientMessage(playerid,COLOR_WHITE,"Your current rank is 'Manhunt' (Rank 3)");
		SendClientMessage(playerid,COLOR_WHITE,"Type /ranks to find out more information about ranks");
	}
	if(GetPlayerScore(playerid) >= RANK_4_SCORE && GetPlayerScore(playerid) < RANK_5_SCORE){
		SendClientMessage(playerid,COLOR_WHITE,"Your current rank is 'Zombie Hunter' (Rank 4)");
		SendClientMessage(playerid,COLOR_WHITE,"Type /ranks to find out more information about ranks");
	}
	if(GetPlayerScore(playerid) >= RANK_5_SCORE && GetPlayerScore(playerid) < RANK_6_SCORE){
		SendClientMessage(playerid,COLOR_WHITE,"Your current rank is 'Specialist' (Rank 5)");
		SendClientMessage(playerid,COLOR_WHITE,"Type /ranks to find out more information about ranks");
	}
	if(GetPlayerScore(playerid) >= RANK_6_SCORE && GetPlayerScore(playerid) < RANK_7_SCORE){
		SendClientMessage(playerid,COLOR_WHITE,"Your current rank is 'Terminator' (Rank 6)");
		SendClientMessage(playerid,COLOR_WHITE,"Type /ranks to find out more information about ranks");
	}
	if(GetPlayerScore(playerid) >= RANK_7_SCORE){
		SendClientMessage(playerid,COLOR_WHITE,"Your current rank is 'Leon Kennedy' (Rank 7)");
		SendClientMessage(playerid,COLOR_WHITE,"Type /ranks to find out more information about ranks");
	}
 	return 1;
}

CMD:pm(playerid,params[]){
	new pName[MAX_PLAYER_NAME], string[250], String[250], target, tName[MAX_PLAYER_NAME];
	if(sscanf(params, "us[50]",target,params)) return SendClientMessage(playerid, -1, "{FF0000}USAGE : {FF0000}/pm [ID][MESSAGE]");
	if(target == INVALID_PLAYER_ID) return SendClientMessage(playerid, -1, "ERROR : {FF0000}Invalid Player Id");
	if(target == playerid) return SendClientMessage(playerid, 0, "ERROR : {FF0000}You Cannot PM Your Self!");
	if(pInfo[target][NoPM]) return SendClientMessage(playerid, -1, "ERROR : {FF0000}This Player Has NoPM On!");
	GetPlayerName(playerid, pName, sizeof(pName));
	GetPlayerName(target, tName, sizeof(tName));
	format(string ,sizeof(string), "{C0C0C0}|- PM From %s : %s -|", pName, params);
	SendClientMessage(target,0, string);
	format(String, sizeof(String), "{C0C0C0}|- PM Sent To %s -|", tName);
	SendClientMessage(playerid, 0, String);
	return 1;
}

CMD:pms(playerid,params[]){
	if(pInfo[playerid][NoPM] == 0){
		pInfo[playerid][NoPM] = 1;
		SendClientMessage(playerid, -1, "{FF0000}INFO : {FFFFFF}You Have Disabled PMS No One Will Be Able To PM You!");
	} else {
		pInfo[playerid][NoPM] = 0;
		SendClientMessage(playerid, -1, "{FF0000}INFO : {FFFFFF}You Have Enabled PMS EveryOne Will Be Able To PM You!");
	}
	return 1;
}

CMD:reply(playerid,params[]){
	new pName[MAX_PLAYER_NAME], string[128],target, tName[MAX_PLAYER_NAME];
	/*if(sscanf(params, "s", params))*/if(isnull(params)) return SendClientMessage(playerid, COLOR_RED, "USAGE: /reply [MESSAGE]");
	new pID = pInfo[playerid][LastPM];
	if(!IsPlayerConnected(pID)) return SendClientMessage(playerid, COLOR_RED, "ERROR : Player is not connected.");
	if(pID == playerid) return SendClientMessage(playerid, COLOR_RED, "ERROR : You cannot PM yourself.");
	if(pInfo[pID][NoPM] == 1) return SendClientMessage(playerid, COLOR_RED, "ERROR : This player has NoPM on you cannot PM his or reply him back!");
	GetPlayerName(playerid, pName, sizeof(pName));
	GetPlayerName(target, tName, sizeof(tName));
	format(string, sizeof(string), "{C0C0C0}|- PM Sent To %s -|", tName, params);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	format(string, sizeof(string), "{C0C0C0}|- PM From %s : %s -|", pName, params);
	SendClientMessage(pID, COLOR_YELLOW, string);
	pInfo[pID][LastPM] = playerid;
	return 1;
}

CMD:r(playerid,params[]){
	new pName[MAX_PLAYER_NAME], string[128],target, tName[MAX_PLAYER_NAME];
	/*if(sscanf(params, "s", params))*/if(isnull(params)) return SendClientMessage(playerid, COLOR_RED, "USAGE: /reply [MESSAGE]");
	new pID = pInfo[playerid][LastPM];
	if(!IsPlayerConnected(pID)) return SendClientMessage(playerid, COLOR_RED, "ERROR : Player is not connected.");
	if(pID == playerid) return SendClientMessage(playerid, COLOR_RED, "ERROR : You cannot PM yourself.");
	if(pInfo[pID][NoPM] == 1) return SendClientMessage(playerid, COLOR_RED, "ERROR : This player has NoPM on you cannot PM his or reply him back!");
	GetPlayerName(playerid, pName, sizeof(pName));
	GetPlayerName(target, tName, sizeof(tName));
	format(string, sizeof(string), "{C0C0C0}|- PM Sent To %s -|", tName, params);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	format(string, sizeof(string), "{C0C0C0}|- PM From %s : %s -|", pName, params);
	SendClientMessage(pID, COLOR_YELLOW, string);
	pInfo[pID][LastPM] = playerid;
	return 1;
}

CMD:inv(playerid,params[]){
	if(gTeam[playerid] == TEAM_HUMAN){
		ShowPlayerDialog(playerid,4042,DIALOG_STYLE_LIST,"Human Inventory","Flashlight On\nFlashlight Off\nLaser On\nLaser Off\nLaser Colors","Use","Cancel");
	} else if(gTeam[playerid] == TEAM_ZOMBIE){
		ShowPlayerDialog(playerid,4062,DIALOG_STYLE_LIST," Zombies Inventory","Digger","Use","Cancel");
	}
	return 1;
}

CMD:bezombie(playerid,params[]){
	if(gTeam[playerid] == TEAM_HUMAN){
 		SetPlayerHealth(playerid,0);
	} else if(gTeam[playerid] == TEAM_ZOMBIE){
 		SendClientMessage(playerid,COLOR_YELLOW," You are already a zombie");
	}
	return 1;
}

CMD:shelp(playerid,params[]){
	ShowPlayerDialog(playerid,4048,DIALOG_STYLE_MSGBOX,"Server Help"," This is Zombie VS Survivours Gamemode Created by Owen007. \n The whole Los Santos have been destroyed because a virus name (T) has been spread all over the LSA. \n There are a few survivours left now you have to survive.","Ok","Yea ofc");
	return 1;
}

CMD:zhelp(playerid,params[]){
	ShowPlayerDialog(playerid,4060,DIALOG_STYLE_MSGBOX,"Zombies Help"," Hello Zombies, \n You have to kill those bloddy survivours. \n You have some awesome powers like use your /inv. \n You can also bite them using your jump key. \n Use your knife in your hand just Aim and fire to shoot a knife. \n When no weapon in hand Press fire key to bite survivours. \n Want to fuck off survivours use Screamer press your walk key to use screamer mainy ALT.","Ok","Yea ofc");
	return 1;
}

CMD:hhelp(playerid,params[]){
	ShowPlayerDialog(playerid,4061,DIALOG_STYLE_MSGBOX,"Humans Help"," Hello Survivours, \n You have to survive the apocalypse the bloddy zombies are after you. \n Umbrella Corp has given you some awesome gadgets use /inv. \n You have clear all Checkpoints to win the round. \n Beware of zombies they can chase you whereever you go you can't hide. \n You get some money if u kill a zombie and scores. \n You can't run from zombies so try to kill them.","Ok","Yea ofc");
	return 1;
}

CMD:gcmds(playerid,params[]){
	ShowPlayerDialog(playerid,4048,DIALOG_STYLE_MSGBOX,"Group Commands"," /groupcreate,  /groupleave,  /groupinvite,  /groupleader,  /groupjoin,  /groupkick, /groupmessage  , /grouplist,  /groups ","Ok","Yea ofc");
	return 1;
}

CMD:sengine(playerid,params[]){
	new vehicleid = GetPlayerVehicleID(playerid);

	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, LIGHTBLUE, "You need to be in a vehicle to use this command");

	if(vehEngine[vehicleid] == 0){
		vehEngine[vehicleid] = 2;
		SetTimerEx("StartEngine", 3000, 0, "i", playerid);
		SendClientMessage(playerid, GREEN, "Vehicle engine starting");
	} else if(vehEngine[vehicleid] == 1){
		vehEngine[vehicleid] = 0;
		TogglePlayerControllable(playerid, 0);
		SendClientMessage(playerid, GREEN, "Vehicle engine stopped successfully");
		SendClientMessage(playerid, LIGHTBLUE, "Press LMB or /sengine to start the Vehicle again");
	}
	return 1;
}

CMD:cmds(playerid,params[]){
	ShowPlayerDialog(playerid,4047,DIALOG_STYLE_MSGBOX,"Server Commands","/shelp , /zhelp  ,/hhelp,  /rules , /buyweap , /cmds, /stats, /sengine, /bezombie, /pm, /pms, /reply, /r, /gcmds, /inv, /rcon login passwordhere, /rconinfo.","Ok","Yea ofc");
	return 1;
}

CMD:stats(playerid,params[]){
	new password = PlayerInfo[playerid][ZVHPass],
		money = PlayerInfo[playerid][ZVHCash],
		deaths = PlayerInfo[playerid][ZVHDeaths],
		kills = PlayerInfo[playerid][ZVHKills],
		score = PlayerInfo[playerid][ZVHScore],
		string[500];
		
	format(string,sizeof(string),"Password: %d | Money: %d | Deaths: %d | Kills: %d | Score: %d",password,money,deaths,kills,score);
	SendClientMessage(playerid,GREEN,string);
	return 1;
}

CMD:rconinfo(playerid,params[]){
	ShowPlayerDialog(playerid,4046,DIALOG_STYLE_MSGBOX,"RCON Info","If you are using the rcon filescript I provided then do /uracmds to check commands of rcon admin.","Ok","Yea ofc");
	return 1;
}

CMD:rules(playerid,params[]){
	ShowPlayerDialog(playerid,4045,DIALOG_STYLE_MSGBOX,"Server Rules"," Donot Bunny Hop to gain speed or you will be punished.\n Dont use hacks.\n Dont abuse each other.\n Only English in the main chat.\n No account sharing allowed.\n Scores farming leads to perm ban.","Ok","Yea ofc");
	return 1;
}

CMD:buyweap(playerid,params[]){
	if(gTeam[playerid] == TEAM_HUMAN){
		ShowPlayerDialog(playerid,4041,DIALOG_STYLE_TABLIST_HEADERS,"Weapons Shop","Weapon\tPrice\tAmmo\nSawnOffs\t$30000\t500\nDesert Eagle\t$6000\t500\nM4-Carbine\t$20000\t500\nMP5\t$7000\t500\nUzi\t$6500\t500\nKatana\t$8000\tN/A\nTec-9\t$4000\t500","Buy","Cancel");
	} else if(gTeam[playerid] == TEAM_ZOMBIE){
		SendClientMessage(playerid,ORANGE,"Weapons are made for Survivours..");
	}
	return 1;
}


CMD:groupcreate(playerid,params[]){
  	if(group[playerid][gid] != -1) return SendClientMessage(playerid, 0xFF0000, "Leave your group with {FFFFFF}/groupleave{FF0000} before creating a new one!");
  	if(strlen(params) > 49 || strlen(params) < 3) return SendClientMessage(playerid, 0xFF0000, "Usage: {FFFFFF}/groupcreate{FF0000} (Group name 3-50 characters)!");
	if(IsGroupTaken(params)) return SendClientMessage(playerid, 0xFF0000, "Group name is already in use!");
	CreateGroup(params, playerid);
  	return 1;
}

CMD:groupleave(playerid,params[]){
	if(group[playerid][gid] == -1) return SendClientMessage(playerid, 0xFF0000, "You are not in a group to leave one!");
 	LeaveGroup(playerid, 0);
 	return 1;
}

CMD:groupinvite(playerid,params[]){
	if(group[playerid][order] != 1) return SendClientMessage(playerid, 0xFF0000, "You are not the leader of the group, you cannot invite people!");
	new cid;
	if(isnull(params)) return SendClientMessage(playerid, 0xFF0000, "Usage: {FFFFFF}/Groupinvite{FF0000} (playerid)");
	cid = strval(params);
	if(!IsPlayerConnected(cid)) return SendClientMessage(playerid, 0xFF0000, "Player Is not connected!");
	if(group[cid][gid] == group[playerid][gid]) return SendClientMessage(playerid, 0xFF0000, "Player Is already in your group!");
 	if(group[cid][invited] == group[playerid][gid]) return SendClientMessage(playerid, 0xFF0000, "Player has already been invited to your group!");
	if(group[cid][attemptjoin] == group[playerid][gid]) return GroupJoin(cid, group[playerid][gid]);
	group[cid][invited] = group[playerid][gid];
 	new string[125], pname[24];
 	GetPlayerName(playerid, pname, 24);
 	format(string, sizeof(string), "You have been invited to join group {FFFFFF}%s(%d){FFCC66} by {FFFFFF}%s(%d). /groupjoin %d", groupinfo[group[playerid][gid]][grname], group[playerid][gid], pname, playerid, group[playerid][gid]);
	SendClientMessage(cid, 0xFFCC66, string);
 	GetPlayerName(cid, pname, 24);
	format(string, sizeof(string), "You have invited {FFFFFF}%s(%d){FFCC66} to join your group!", pname, cid);
	SendClientMessage(playerid, 0xFFCC66, string);
 	return 1;
}

CMD:groupleader(playerid,params[]){
	if(group[playerid][order] != 1) return SendClientMessage(playerid, 0xFF0000, "You are not the leader of the group, you cannot change the leader!");
	new cid;
	if(isnull(params)) return SendClientMessage(playerid, 0xFF0000, "Usage: {FFFFFF}/Groupleader{FF0000} (playerid)");
	cid = strval(params);
	if(!IsPlayerConnected(cid)) return SendClientMessage(playerid, 0xFF0000, "Player Is not connected!");
	if(cid == playerid)  return SendClientMessage(playerid, 0xFF0000, "You are already group leader, silly.");
	if(group[playerid][gid] != group[cid][gid]) return SendClientMessage(playerid, 0xFF0000, "Player Is not in your group!");
	ChangeMemberOrder(group[playerid][gid], 1);
	group[playerid][order] = GroupMembers(group[playerid][gid]);
	return 1;
}

CMD:groupjoin(playerid,params[]){
	if(group[playerid][gid] != -1) return SendClientMessage(playerid, 0xFF0000, "You are already in a group! Leave your current one before joining another one!");
	new grid;
	if( (isnull(params) && group[playerid][invited] != -1 ) || ( strval(params) == group[playerid][invited] && group[playerid][invited] != -1) ) return GroupJoin(playerid, group[playerid][invited]);
	if(isnull(params)) return SendClientMessage(playerid, 0xFF0000, "Usage: {FFFFFF}/groupjoin{FF0000} (groupid)");
	grid = strval(params);
	if(!groupinfo[grid][active]) return SendClientMessage(playerid, 0xFF0000, "The group you have tried to join doesn't exist!");
	group[playerid][attemptjoin] = grid;
	new string[125], pname[24];
	GetPlayerName(playerid, pname, 24);
	format(string, sizeof(string), "You have requested to join group %s(ID:%d)", groupinfo[grid][grname], grid);
	SendClientMessage(playerid, 0xFFCC66, string);
	format(string, sizeof(string), "{FFFFFF}%s(%d){FFCC66}has requested to join your group. Type /groupinvite %d to accept", pname, playerid, playerid);
	SendMessageToLeader(grid, string);
	return 1;
}

CMD:groupkick(playerid,params[]){
	if(group[playerid][order] != 1) return SendClientMessage(playerid, 0xFF0000, "You are not the leader of a group, you cannot kick!");
	new cid;
	if(isnull(params)) return SendClientMessage(playerid, 0xFF0000, "Usage: {FFFFFF}/Groupkick{FF0000} (playerid)");
	cid = strval(params);
	if(!IsPlayerConnected(cid)) return SendClientMessage(playerid, 0xFF0000, "Player Is not connected!");
	if(cid == playerid)  return SendClientMessage(playerid, 0xFF0000, "You cannot kick yourself, silly.");
	if(group[playerid][gid] != group[cid][gid]) return SendClientMessage(playerid, 0xFF0000, "Player Is not in your group!");
	LeaveGroup(cid, 1);
	return 1;
}

CMD:groupmessage(playerid,params[]){
	if(group[playerid][gid] == -1) return SendClientMessage(playerid, 0xFF0000, "You are not in a group, you cannot group message!");
	if(isnull(params)) return SendClientMessage(playerid, 0xFF0000, "Usage: {FFFFFF}/gm{FF0000} (message)");
	new pname[24], string[140+24];
	GetPlayerName(playerid, pname, 24);
	format(string, sizeof(string), "%s(%d): %s", pname, playerid, params);
	SendMessageToAllGroupMembers(group[playerid][gid], string);
	return 1;
}

CMD:grouplist(playerid,params[]){
	if(isnull(params) && group[playerid][gid] == -1) return SendClientMessage(playerid, 0xFF0000, "Usage: {FFFFFF}/grouplist{FF0000} (group)");
	if(isnull(params)){
 		DisplayGroupMembers(group[playerid][gid], playerid);
		return 1;
	}
 	new grid = strval(params);
  	if(!groupinfo[grid][active]) return SendClientMessage(playerid, 0xFF0000, "The group ID you have entered is not active!");
	DisplayGroupMembers(grid, playerid);
	return 1;
}

CMD:groups(playerid,params[]){
	ListGroups(playerid);
	return 1;
}

CMD:grl(playerid,params[]) return cmd_groupleave(playerid, params);
CMD:grc(playerid,params[]) return cmd_groupcreate(playerid, params);
CMD:gri(playerid,params[]) return cmd_groupinvite(playerid, params);
CMD:grlead(playerid,params[]) return cmd_groupleader(playerid, params);
CMD:grj(playerid,params[]) return cmd_groupjoin(playerid, params);
CMD:grk(playerid,params[]) return cmd_groupkick(playerid, params);
CMD:gm(playerid,params[]) return cmd_groupmessage(playerid, params);
CMD:grlist(playerid,params[]) return cmd_grouplist(playerid, params);

public OnPlayerCommandPerformed(playerid, cmdtext[], success){
	if(!success) return GameTextForPlayer(playerid, "~w~Unknown command~n~Use ~r~/cmds ~w~for commands list", 5000, 5);
	return 1;
}

//--- OnPlayerSpawn --// read this u will easily understand it.
public OnPlayerSpawn(playerid){
	if(IsPlayerNPC(playerid)){ //Checks if the player that just spawned is an NPC.
		new npcname[MAX_PLAYER_NAME];
		GetPlayerName(playerid, npcname, sizeof(npcname)); //Getting the NPC's name.
		if(!strcmp(npcname, "Owen007", true)){ //Checking if the NPC's name is Owen007.
			new Text3D:label = Create3DTextLabel("Owen007", GREEN, 30.0, 40.0, 50.0, 40.0, 0);
			Attach3DTextLabelToPlayer(label, playerid, 0.0, 0.0, 1.5);
			PutPlayerInVehicle(playerid, NPCVehicle, 0); //Putting the NPC into the vehicle we created for
			return 1;
		}
		if(!strcmp(npcname, "AbyssMorgan", true)){ //Checking if the NPC's name is AbyssMorgan.
			new Text3D:label = Create3DTextLabel("AbyssMorgan", GREEN, 30.0, 40.0, 50.0, 40.0, 0);
			Attach3DTextLabelToPlayer(label, playerid, 0.0, 0.0, 1.5);
			PutPlayerInVehicle(playerid, NPCVehicle2, 0); //Putting the NPC into the vehicle we created for
			return 1;
		}
		if(!strcmp(npcname, "Sreyas", true)){ //Checking if the NPC's name is Sreyas.
			new Text3D:label = Create3DTextLabel("Sreyas", GREEN, 30.0, 40.0, 50.0, 40.0, 0);
			Attach3DTextLabelToPlayer(label, playerid, 0.0, 0.0, 1.5);
			PutPlayerInVehicle(playerid, NPCVehicle3, 0); //Putting the NPC into the vehicle we created for
			return 1;
		}
		if(!strcmp(npcname, "FahadKing", true)){ //Checking if the NPC's name is FahadKing.
			new Text3D:label = Create3DTextLabel("FahadKing", GREEN, 30.0, 40.0, 50.0, 40.0, 0);
			Attach3DTextLabelToPlayer(label, playerid, 0.0, 0.0, 1.5);
			PutPlayerInVehicle(playerid, NPCVehicle4, 0); //Putting the NPC into the vehicle we created for
			return 1;
		}
		return 1;
	}
	
	SetPlayerScore(playerid, PlayerInfo[playerid][ZVHScore]);
	if(!GetPVarInt(playerid, "color")) SetPVarInt(playerid, "color", 18643);
	SetPlayerWorldBounds(playerid, 2907.791, 175.1681, -910.8743, -2791.012);
	
	if(gTeam[playerid] == TEAM_HUMAN){
		SetPlayerPos(playerid,1537.90,-1682.58,13.55);
		SetPlayerTime(playerid, 13,0);
		SetPlayerColor(playerid,TEAM_HUMAN_COLOR);
		SendClientMessage(playerid,ORANGE,"Tip: Kill all Zombies and Survive till the end.");
		EnableStuntBonusForAll(0);
		SetPlayerTeam(playerid,TEAM_HUMAN);
		ToggleKnifeShootForPlayer(playerid,false);
		ShowPlayerDialog(playerid,0,DIALOG_STYLE_LIST,"Select Class","Newibe (Rank 0)\nFreshmeat(Rank 0)\nSurvivor (Rank 1)\nManhunt (Rank 1)\nZombie Hunter (Rank 2)\nSpecialist (Rank 3)\nMastermind (Rank 4)\nTerminator (Rank 5)\n","Select","");
		
		if(GetPlayerScore(playerid) >= RANK_0_SCORE && GetPlayerScore(playerid) < RANK_1_SCORE){
			SendClientMessage(playerid,COLOR_WHITE,"Your current rank is 'Freshmeat aka Newibe' (Rank 0)");
			SendClientMessage(playerid,COLOR_WHITE,"Rank bonus: None");
			SendClientMessage(playerid,COLOR_WHITE,"Type /ranks to find out more information about ranks");
		}
		if(GetPlayerScore(playerid) >= RANK_1_SCORE && GetPlayerScore(playerid) < RANK_2_SCORE){
			SendClientMessage(playerid,COLOR_WHITE,"Your current rank is 'Bandit' (Rank 1)");
			SendClientMessage(playerid,COLOR_WHITE,"Rank bonus: +5 Armour");
			SetPlayerArmour(playerid, 5);
			SendClientMessage(playerid,COLOR_WHITE,"Type /ranks to find out more information about ranks");
		}
		if(GetPlayerScore(playerid) >= RANK_2_SCORE && GetPlayerScore(playerid) < RANK_3_SCORE){
			SendClientMessage(playerid,COLOR_WHITE,"Your current rank is 'Survivor' (Rank 2)");
			SendClientMessage(playerid,COLOR_WHITE,"Rank bonus: +10 Armour");
			SetPlayerArmour(playerid, 10);
			SendClientMessage(playerid,COLOR_WHITE,"Type /ranks to find out more information about ranks");
		}
		if(GetPlayerScore(playerid) >= RANK_3_SCORE && GetPlayerScore(playerid) < RANK_4_SCORE){
			SendClientMessage(playerid,COLOR_WHITE,"Your current rank is 'Manhunt' (Rank 3)");
			SendClientMessage(playerid,COLOR_WHITE,"Rank bonus: +10 Armour");
			SetPlayerArmour(playerid, 10);
			SendClientMessage(playerid,COLOR_WHITE,"Type /ranks to find out more information about ranks");
		}
		if(GetPlayerScore(playerid) >= RANK_4_SCORE && GetPlayerScore(playerid) < RANK_5_SCORE){
			SendClientMessage(playerid,COLOR_WHITE,"Your current rank is 'Zombie Hunter' (Rank 4)");
			SendClientMessage(playerid,COLOR_WHITE,"Rank bonus: +15 Armour");
			SetPlayerArmour(playerid, 15);
			SendClientMessage(playerid,COLOR_WHITE,"Type /ranks to find out more information about ranks");
		}
		if(GetPlayerScore(playerid) >= RANK_5_SCORE && GetPlayerScore(playerid) < RANK_6_SCORE){
			SendClientMessage(playerid,COLOR_WHITE,"Your current rank is 'Specialist' (Rank 5)");
			SendClientMessage(playerid,COLOR_WHITE,"Rank bonus: +20 Armour");
			SetPlayerArmour(playerid, 20);
			SendClientMessage(playerid,COLOR_WHITE,"Type /ranks to find out more information about ranks");
		}
		if(GetPlayerScore(playerid) >= RANK_6_SCORE && GetPlayerScore(playerid) < RANK_7_SCORE){
			SendClientMessage(playerid,COLOR_WHITE,"Your current rank is 'Terminator' (Rank 6)");
			SendClientMessage(playerid,COLOR_WHITE,"Rank bonus: +20 Armour");
			SetPlayerArmour(playerid, 20);
			SendClientMessage(playerid,COLOR_WHITE,"Type /ranks to find out more information about ranks");
		}
		if(GetPlayerScore(playerid) >= RANK_7_SCORE){
			SendClientMessage(playerid,COLOR_WHITE,"Your current rank is 'Leon Kennedy' (Rank 7)");
			SendClientMessage(playerid,COLOR_WHITE,"Rank bonus: +25 Armour");
			SetPlayerArmour(playerid, 25);
			SendClientMessage(playerid,COLOR_WHITE,"Type /ranks to find out more information about ranks");
		}
		return 1;
	}
	if(gTeam[playerid] == TEAM_ZOMBIE){
		SetPlayerPos(playerid,1807.0757,-1690.0712,13.5457);
		SetPlayerColor(playerid,TEAM_ZOMBIE_COLOR);
		SetPlayerTime(playerid, 6,0 );
		GivePlayerWeapon(playerid,4,0);
		SendClientMessage(playerid,ORANGE,"Tip: Kill all Survivours and eat their brains.");
		EnableStuntBonusForAll(0);
		SetPlayerTeam(playerid,TEAM_ZOMBIE);
		ToggleKnifeShootForPlayer(playerid,true);
	}
	return 1;
}

//--- this is the screen which appears when u select between team zombie and human.
public OnPlayerRequestClass(playerid, classid){
	if(IsPlayerNPC(playerid)) return 1;
	SetPlayerPos(playerid, 2121.7322, -1623.2563, 26.8368);
	SetPlayerFacingAngle(playerid, 60.2360);
	SetPlayerCameraPos(playerid, 2111.9089 ,-1623.7340, 24.2307);
	SetPlayerCameraLookAt(playerid, 2121.7322, -1623.2563, 26.8368);
	SetPlayerWeather(playerid,700);
	if(classid >= 12 && classid <= 78){
		GameTextForPlayer(playerid,"~b~Humans",5000,6);
		gTeam[playerid] = TEAM_HUMAN;
	} else { ///(classid >= 0 && classid <= 11)
		gTeam[playerid] = TEAM_ZOMBIE;
		GameTextForPlayer(playerid,"~p~Zombies",5000,6);
	}
	return 1;
}

//--- on player death waht will happen these are wriiten in these. u can also give him some weapons when he get died. ;)
public OnPlayerDeath(playerid, killerid, reason){
	if(gTeam[playerid] == TEAM_HUMAN){
		gTeam[playerid] = TEAM_ZOMBIE;
		SetPlayerColor(playerid,TEAM_ZOMBIE_COLOR);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid,4,0);
		SendClientMessage(playerid,ORANGE,"You been infected now you eat others brain");
		return 1;
	}
	SendDeathMessage(killerid,playerid,reason);
	GivePlayerMoney(killerid,1000);
	GameTextForPlayer(killerid,"~g~+$1000",6000,4);
	SetPlayerScore(killerid, GetPlayerScore(killerid) + 1);
	PlayerInfo[killerid][ZVHKills]++;
	PlayerInfo[playerid][ZVHDeaths]++;
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger){
	if(gTeam[playerid] == TEAM_ZOMBIE){
		SendClientMessage(playerid,ORANGE,"Zombies are bad drivers.");
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]){
	switch(dialogid){
		case 4041: {
			if(response){
				switch(listitem){
					case 0: {
						if(GetPlayerMoney(playerid) < 30000) return SendClientMessage(playerid, GRAY, "You don't have enough Cash!");
						GivePlayerWeapon(playerid,26,500);
						GivePlayerMoney(playerid,-30000);
						SendClientMessage(playerid,GREEN,"You Have Purchased Sawnoffs for $30000.");
					}
					case 1: {
						if(GetPlayerMoney(playerid) < 6000) return SendClientMessage(playerid, GRAY, "You don't have enough Cash!");
						GivePlayerWeapon(playerid,24,500);
						GivePlayerMoney(playerid,-6000);
						SendClientMessage(playerid,GREEN,"You Have Purchased Desert Eagle for $6000.");
					}
					case 2: {
						if(GetPlayerMoney(playerid) < 20000) return SendClientMessage(playerid, GRAY, "You don't have enough Cash!");
						GivePlayerWeapon(playerid,31,500);
						GivePlayerMoney(playerid,-20000);
						SendClientMessage(playerid,GREEN,"You Have Purchased M4-Carbine for $20000.");
					}
					case 3: {
						if(GetPlayerMoney(playerid) < 7000) return SendClientMessage(playerid, GRAY, "You don't have enough Cash!");
						GivePlayerWeapon(playerid,29,500);
						GivePlayerMoney(playerid,-7000);
						SendClientMessage(playerid,GREEN,"You Have Purchased MP5 for $7000.");
					}
					case 4: {
						if(GetPlayerMoney(playerid) < 6500) return SendClientMessage(playerid, GRAY, "You don't have enough Cash!");
						GivePlayerWeapon(playerid,28,500);
						GivePlayerMoney(playerid,-6500);
						SendClientMessage(playerid,GREEN,"You Have Purchased Uzi for $6500.");
					}
					case 5: {
						if(GetPlayerMoney(playerid) < 8000) return SendClientMessage(playerid, GRAY, "You don't have enough Cash!");
						GivePlayerWeapon(playerid,8,500);
						GivePlayerMoney(playerid,-8000);
						SendClientMessage(playerid,GREEN,"You Have Purchased Katana for $8000.");
					}
					case 6: {
						if(GetPlayerMoney(playerid) < 4000) return SendClientMessage(playerid, GRAY, "You don't have enough Cash!");
						GivePlayerWeapon(playerid,32,500);
						GivePlayerMoney(playerid,-4000);
						SendClientMessage(playerid,GREEN,"You Have Purchased Tec Nine for $4000.");
					}
				}
			}
		}
		
		case 4042: {
			if(response){
				switch(listitem){
					case 0: {
						if(flashlight == 0){
							SetPlayerAttachedObject(playerid, 1,18656, 5, 0.1, 0.038, -0.1, -90, 180, 0, 0.03, 0.03, 0.03);
							SetPlayerAttachedObject(playerid, 2,18641, 5, 0.1, 0.02, -0.05, 0, 0, 0, 1, 1, 1);
							flashlight = 1;
						}
					}
					case 1: {
						if(flashlight == 1){
							RemovePlayerAttachedObject(playerid,1);
							RemovePlayerAttachedObject(playerid,2);
							flashlight = 0;
						}
					}
					case 2: {
						SendClientMessage(playerid, 0x00E800FF, "Laser Activated");
						SetPVarInt(playerid, "laser", 1);
						SetPVarInt(playerid, "color", GetPVarInt(playerid, "color"));
					}
					case 3: {
						SendClientMessage(playerid, 0x00E800FF, "Laser Deactivated");
						SetPVarInt(playerid, "laser", 0);
						RemovePlayerAttachedObject(playerid, 0);
					}
					case 4: {
						ShowPlayerDialog(playerid, 04044, DIALOG_STYLE_LIST, "{FFFFFF}Laser Color", "Blue\nPink\nOrange\nGreen\nYellow", "Select", "Cancel");
					}
				}
			}
		}
		
		case 4044: {
			if(response){
				switch(listitem){
					case 0: SetPVarInt(playerid, "color", 19080);
					case 1: SetPVarInt(playerid, "color", 19081);
					case 2: SetPVarInt(playerid, "color", 19082);
					case 3: SetPVarInt(playerid, "color", 19083);
					case 4: SetPVarInt(playerid, "color", 19084);
				}
			}
		}
		
		case 4062: {
			if(response){
				if(listitem == 0){
					ShowPlayerDialog(playerid, 04063, DIALOG_STYLE_LIST, "Zombies Digger","Zombies Underground Hive 1\nZombies Underground Hive 2\nZombies Underground Hive 3\nZombies Underground Hive 4\nZombies Underground Hive 5\nZombies Underground Hive 6\nZombies Underground Hive 7\nZombies Underground Hive 8", "Select", "Cancel");
				}
			}
		}
		
		case 4063: {
			if(response){
				if(gettime() < lastTPTime[playerid])return SendClientMessage(playerid, -1, "You can't dig right now wait 3 min to dig again..");
				switch(listitem){
					case 0: {
						SetPlayerPos(playerid, 1547.29,-1168.56,24.08);
						lastTPTime[playerid] = (gettime() + 180);
					}
					case 1: {
						SetPlayerPos(playerid, 395.57,-1643.37,31.16);
						lastTPTime[playerid] = (gettime() + 180);
					}
					case 2: {
						SetPlayerPos(playerid, 1820.14,-1758.75,13.38);
						lastTPTime[playerid] = (gettime() + 180);
					}
					case 3: {
						SetPlayerPos(playerid, 2496.49,-1590.69,23.03);
						lastTPTime[playerid] = (gettime() + 180);
					}
					case 4: {
						SetPlayerPos(playerid, 873.06,-1358.05,13.55);
						lastTPTime[playerid] = (gettime() + 180);
					}
					case 5: {
						SetPlayerPos(playerid, 448.95,-1587.97,25.30);
						lastTPTime[playerid] = (gettime() + 180);
					}
					case 6: {
						SetPlayerPos(playerid, 1278.66,-1266.55,13.53);
						lastTPTime[playerid] = (gettime() + 180);
					}
					case 7: {
						SetPlayerPos(playerid, 2586.94,-992.30,79.03);
						lastTPTime[playerid] = (gettime() + 180);
					}
				}
			}
		}
		
		case 0: {
			if(response){
				switch(listitem){
					case 0: {
						ResetPlayerWeapons(playerid);
						SendClientMessage(playerid,COLOR_WHITE,"You selected '"COL_GREEN"Freshmeat"COL_WHITE"' class.");
						GivePlayerWeapon(playerid, 22, 200);//Pistol
						GivePlayerWeapon(playerid, 2, 0);//Pistol
					}
					case 1: {
						ResetPlayerWeapons(playerid);
						SendClientMessage(playerid,COLOR_WHITE,"You selected '"COL_GREEN"Bandit"COL_WHITE"' class.");
						GivePlayerWeapon(playerid, 23, 200);//Silenced Pistol
						GivePlayerWeapon(playerid, 3, 0);//Pistol
					}
					case 2: {
						if(GetPlayerScore(playerid) < RANK_1_SCORE){
							SendClientMessage(playerid,COLOR_RED,"ERROR: You need "#RANK_1_SCORE" score (Rank 1) to select this rank");
							ShowPlayerDialog(playerid,0,DIALOG_STYLE_LIST,"Select Class","Freshmeat (Rank 0)\nBandit(Rank 0)\nSurvivor (Rank 1)\nManhunt (Rank 1)\nZombie Hunter (Rank 2)\nSpecialist (Rank 3)\nMastermind (Rank 4)\nTerminator (Rank 5)\n","Select","");
						} else {
							ResetPlayerWeapons(playerid);
							SendClientMessage(playerid,COLOR_WHITE,"You selected '"COL_GREEN"Survivor"COL_WHITE"' class.");
							GivePlayerWeapon(playerid, 23, 100);//Silenced Pistol
							GivePlayerWeapon(playerid, 25, 200);//Shotgun
						}
					}
					case 3: {
						if(GetPlayerScore(playerid) < RANK_1_SCORE){
							SendClientMessage(playerid,COLOR_RED,"ERROR: You need "#RANK_1_SCORE" score (Rank 1) to select this rank");
							ShowPlayerDialog(playerid,0,DIALOG_STYLE_LIST,"Select Class","Freshmeat (Rank 0)\nBandit(Rank 0)\nSurvivor (Rank 1)\nManhunt (Rank 1)\nZombie Hunter (Rank 2)\nSpecialist (Rank 3)\nMastermind (Rank 4)\nTerminator (Rank 5)\n","Select","");
						} else {
							ResetPlayerWeapons(playerid);
							SendClientMessage(playerid,COLOR_WHITE,"You selected '"COL_GREEN"Gangster"COL_WHITE"' class.");
							GivePlayerWeapon(playerid, 23, 100); //Silenced Pistol
							GivePlayerWeapon(playerid, 29, 200); //MP5
						}
					}
					case 4: {
						if(GetPlayerScore(playerid) < RANK_2_SCORE){
							SendClientMessage(playerid,COLOR_RED,"ERROR: You need "#RANK_2_SCORE" score (Rank 2) to select this rank");
							ShowPlayerDialog(playerid,0,DIALOG_STYLE_LIST,"Select Class","Freshmeat (Rank 0)\nBandit(Rank 0)\nSurvivor (Rank 1)\nManhunt (Rank 1)\nZombie Hunter (Rank 2)\nSpecialist (Rank 3)\nMastermind (Rank 4)\nTerminator (Rank 5)\n","Select","");
						} else {
							ResetPlayerWeapons(playerid);
							SendClientMessage(playerid,COLOR_WHITE,"You selected '"COL_GREEN"Double Gangster"COL_WHITE"' class.");
							GivePlayerWeapon(playerid, 16, 4);//Grenade
							GivePlayerWeapon(playerid, 24, 100);//Desert Eagle
							GivePlayerWeapon(playerid, 31, 300);//M4
						}
					}
					case 5: {
						if(GetPlayerScore(playerid) < RANK_3_SCORE){
							SendClientMessage(playerid,COLOR_RED,"ERROR: You need "#RANK_3_SCORE" score (Rank 3) to select this rank");
							ShowPlayerDialog(playerid,0,DIALOG_STYLE_LIST,"Select Class","Freshmeat (Rank 0)\nBandit(Rank 0)\nSurvivor (Rank 1)\nManhunt (Rank 1)\nZombie Hunter (Rank 2)\nSpecialist (Rank 3)\nMastermind (Rank 4)\nTerminator (Rank 5)\n","Select","");
						} else {
							ResetPlayerWeapons(playerid);
							SendClientMessage(playerid,COLOR_WHITE,"You selected '"COL_GREEN"Scout"COL_WHITE"' class.");
							GivePlayerWeapon(playerid, 16, 4);//Grenade
							GivePlayerWeapon(playerid, 24, 125);//Desert Eagle
							GivePlayerWeapon(playerid, 29, 275);//MP5
							GivePlayerWeapon(playerid, 31, 325);//M4
						}
					}
					case 6: {
						if(GetPlayerScore(playerid) < RANK_4_SCORE){
							SendClientMessage(playerid,COLOR_RED,"ERROR: You need "#RANK_4_SCORE" score (Rank 4) to select this rank");
							ShowPlayerDialog(playerid,0,DIALOG_STYLE_LIST,"Select Class","Freshmeat (Rank 0)\nBandit(Rank 0)\nSurvivor (Rank 1)\nManhunt (Rank 1)\nZombie Hunter (Rank 2)\nSpecialist (Rank 3)\nMastermind (Rank 4)\nTerminator (Rank 5)\n","Select","");
						} else {
							ResetPlayerWeapons(playerid);
							SendClientMessage(playerid,COLOR_WHITE,"You selected '"COL_GREEN"Mastermind"COL_WHITE"' class.");
							GivePlayerWeapon(playerid, 16, 5);//Grenade
							GivePlayerWeapon(playerid, 24, 150);//Desert Eagle
							GivePlayerWeapon(playerid, 28, 150);//Uzi
							GivePlayerWeapon(playerid, 31, 350);//M4
						}
					}
					case 7: {
						if(GetPlayerScore(playerid) < RANK_5_SCORE){
							SendClientMessage(playerid,COLOR_RED,"ERROR: You need "#RANK_5_SCORE" score (Rank 5) to select this rank");
							ShowPlayerDialog(playerid,0,DIALOG_STYLE_LIST,"Select Class","Freshmeat (Rank 0)\nBandit(Rank 0)\nSurvivor (Rank 1)\nManhunt (Rank 1)\nZombie Hunter (Rank 2)\nSpecialist (Rank 3)\nMastermind (Rank 4)\nTerminator (Rank 5)\n","Select","");
						} else {
							ResetPlayerWeapons(playerid);
							SendClientMessage(playerid,COLOR_WHITE,"You selected '"COL_GREEN"Specialist"COL_WHITE"' class.");
							GivePlayerWeapon(playerid, 16, 5);//Grenade
							GivePlayerWeapon(playerid, 24, 200);//Desert Eagle
							GivePlayerWeapon(playerid, 26, 50);//Swan off
							GivePlayerWeapon(playerid, 28, 200);//Uzi
						}
					}
				}
			}
		}
		
		case DIALOG_REGISTER: {
			if(!response) return Kick(playerid);
			if(response){
				if(!strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, ""COL_WHITE"Registering...",""COL_RED"You have entered an invalid password.\n"COL_WHITE"Type your password below to register a new account.","Register","Quit");
				new INI:File = INI_Open(UserPath(playerid));
				INI_SetTag(File,"data");
				INI_WriteInt(File,"Password",udb_hash(inputtext));
				INI_WriteInt(File,"Cash",0);
				INI_WriteInt(File,"Kills",0);
				INI_WriteInt(File,"Deaths",0);
				INI_WriteInt(File,"Score",0);
				INI_Close(File);

				ShowPlayerDialog(playerid, DIALOG_SUCCESS_1, DIALOG_STYLE_MSGBOX,""COL_WHITE"Success!",""COL_GREEN"Thanks! You are registered at,"COL_LIGHTBLUE"Zombie VS Humans Apocalypse v1.3","Ok","");
			}
		}

		case DIALOG_LOGIN: {
			if(!response) return Kick(playerid);
			if(response){
				if(udb_hash(inputtext) == PlayerInfo[playerid][ZVHPass]){
					INI_ParseFile(UserPath(playerid), "LoadUser_%s", .bExtra = true, .extra = playerid);
					GivePlayerMoney(playerid, PlayerInfo[playerid][ZVHCash]);
					SetPlayerScore(playerid,PlayerInfo[playerid][ZVHScore]);
					ShowPlayerDialog(playerid, DIALOG_SUCCESS_2, DIALOG_STYLE_MSGBOX,""COL_WHITE"Success!",""COL_GREEN"You have successfully logged in!","Ok","");
				} else {
					ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,""COL_WHITE"Login",""COL_RED"You have entered an incorrect password.\n"COL_WHITE"Type your password below to login.","Login","Quit");
				}
				return 1;
			}
		}
	}
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate){
	if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER){
		if(IsPlayerNPC(playerid)) return 1;

		TextDrawSetString(td_fuel[playerid],"Fuel:");
		TextDrawSetString(td_vhealth[playerid],"Health:");
		TextDrawSetString(td_vspeed[playerid],"Speed:");

		TextDrawShowForPlayer(playerid,td_fuel[playerid]);
		TextDrawShowForPlayer(playerid,td_vspeed[playerid]);
		TextDrawShowForPlayer(playerid,td_vhealth[playerid]);
		TextDrawShowForPlayer(playerid,td_box[playerid]);
	} else {
		TextDrawHideForPlayer(playerid,td_fuel[playerid]);
		TextDrawHideForPlayer(playerid,td_vspeed[playerid]);
		TextDrawHideForPlayer(playerid,td_vhealth[playerid]);
		TextDrawHideForPlayer(playerid,td_box[playerid]);
	}

	new vehicleid = GetPlayerVehicleID(playerid);

	if(newstate == PLAYER_STATE_DRIVER){
		if(vehEngine[vehicleid] == 0){
			TogglePlayerControllable(playerid,0);
			SendClientMessage(playerid, LIGHTBLUE, "Press LMB and /sengine to start the vehicle");
			SendClientMessage(playerid, red, "Vehicle engine is jammed.");
		} else if(vehEngine[vehicleid] == 1){
			TogglePlayerControllable(playerid,1);
			SendClientMessage(playerid, GREEN, "Vehicle engine running");
		}
	}
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys){
	if(newkeys & KEY_WALK){
		if(gTeam[playerid] == TEAM_ZOMBIE){
			if(GetPlayerWeapon(playerid) == 0){
				ApplyAnimation(playerid,"ON_LOOKERS","shout_01",3.9,0,1,1,1,1,1);
				new victimid = GetClosestPlayers(playerid);
				if(IsPlayerConnected(victimid)){
					if(GetDistanceBetweenPlayers(playerid,victimid) < 2.0){
						new Float:health;
						GetPlayerHealth(victimid, health);
						SetPlayerHealth(victimid, health - 10.0);
						ApplyAnimation (playerid,"ped","BIKE_fall_off",4.1,0,1,1,1,1,1);
						return 1;
					}
				}
			}
		}
	}
	if(newkeys & KEY_FIRE){
		if(gTeam[playerid] == TEAM_ZOMBIE){
			if(GetPlayerWeapon(playerid) == 0){
				ApplyAnimation (playerid,"food","EAT_Burger",3.9,0,1,1,1,1,1);
				new victimid = GetClosestPlayers(playerid);
				if(IsPlayerConnected(victimid)){
					if(GetDistanceBetweenPlayers(playerid,victimid) < 2.0){
						new Float:health;
						GetPlayerHealth(victimid, health);
						SetPlayerHealth(victimid, health - 12.0);
						return 1;
					}
				}
			}
		}
	}
	new vehicleid = GetPlayerVehicleID(playerid);
	if(IsPlayerInAnyVehicle(playerid)){
		if(vehEngine[vehicleid] == 0){
			if(newkeys == KEY_FIRE){
				PlayAudioStreamForPlayer(playerid, "http://www.sounddogs.com/previews/44/mp3/493673_SOUNDDOGS__au.mp3");
				vehEngine[vehicleid] = 2;
				SetTimerEx("StartEngine", 3000, 0, "i", playerid);
				SendClientMessage(playerid, GREEN, "Vehicle engine starting");
			}
		}
		if(newkeys == KEY_SECONDARY_ATTACK){
			RemovePlayerFromVehicle(playerid);
			TogglePlayerControllable(playerid, 1);

		}
	}
	return 1;
}

public OnPlayerUpdate(playerid){
	new player[MAX_PLAYER_NAME], str[128];
	//Anti-Jetpack Hack
	if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK){
		GetPlayerName(playerid,player,sizeof(player));
		format(str,sizeof(str),"[Anti-Jetpack] %s: Jetpack Hack Detected!",player);
		SendClientMessageToAll(0xFF4500AA,str);
		format(str,sizeof(str),"Player ''%s'' has been Kicked from the server. (Reason: Jetpack Hack Detected!)",player);
		SendClientMessageToAll(0xFF0000FF,str);
		ShowPlayerDialog(playerid,3,DIALOG_STYLE_MSGBOX, "You Have Been Kicked!", "{FFFFFF}You've been {FF0000}kicked{FFFFFF}!\nReason: Jetpack Hack Detected!", "OK", "OK");
		Kick(playerid);
	}
	new Float:armour;
	GetPlayerArmour(playerid,armour);
	if(armour == 100.0){
		new string[64], pName[MAX_PLAYER_NAME];
		GetPlayerName(playerid,pName,MAX_PLAYER_NAME);
		format(string,sizeof string,"* %s was Kicked (Armour Hack)",pName);
		SendClientMessageToAll(0xFF0000FF,string);
		BanEx(playerid, "Armour Hack");
	}
	new iCurWeap = GetPlayerWeapon(playerid);
	if(iCurWeap != GetPVarInt(playerid, "iCurrentWeapon")){
		OnPlayerChangeWeapon(playerid, GetPVarInt(playerid, "iCurrentWeapon"), iCurWeap);
		SetPVarInt(playerid, "iCurrentWeapon", iCurWeap);
	}
	if(GetPVarInt(playerid, "laser")){
		RemovePlayerAttachedObject(playerid, 0);
		if((IsPlayerInAnyVehicle(playerid)) || (IsPlayerInWater(playerid))) return 1;
		
		switch(GetPlayerWeapon(playerid)){
			case 23: {
				if(IsPlayerAiming(playerid)){
					if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK){
						SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,0.108249, 0.030232, 0.118051, 1.468254, 350.512573, 364.284240);
					} else {
						SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,0.108249, 0.030232, 0.118051, 1.468254, 349.862579, 364.784240);
					}
				} else {
					if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK){
						SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,0.078248, 0.027239, 0.113051, -11.131746, 350.602722, 362.384216);
					} else {
						SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,0.078248, 0.027239, 0.113051, -11.131746, 350.602722, 362.384216);
					}
				}
			}
			
			case 27: {
				if(IsPlayerAiming(playerid)){
					if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK){
						SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,0.588246, -0.022766, 0.138052, -11.531745, 347.712585, 352.784271);
					} else {
						SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,0.588246, -0.022766, 0.138052, 1.468254, 350.712585, 352.784271);
					}
				} else {
					if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK){
						SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,0.563249, -0.01976, 0.134051, -11.131746, 351.602722, 351.384216);
					} else {
						SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,0.563249, -0.01976, 0.134051, -11.131746, 351.602722, 351.384216);
					}
				}
			}
			
			case 30: {
				if(IsPlayerAiming(playerid)){
					if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK){
						SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,0.628249, -0.027766, 0.078052, -6.621746, 352.552642, 355.084289);
					} else {
						SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,0.628249, -0.027766, 0.078052, -1.621746, 356.202667, 355.084289);
					}
				} else {
					if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK){
						SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,0.663249, -0.02976, 0.080051, -11.131746, 358.302734, 353.384216);
					} else {
						SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,0.663249, -0.02976, 0.080051, -11.131746, 358.302734, 353.384216);
					}
				}
			}
			
			case 31: {
				if(IsPlayerAiming(playerid)){
					if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK){
						SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,0.528249, -0.020266, 0.068052, -6.621746, 352.552642, 355.084289);
					} else {
						SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,0.528249, -0.020266, 0.068052, -1.621746, 356.202667, 355.084289);
					}
				} else {
					if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK){
						SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,0.503249, -0.02376, 0.065051, -11.131746, 357.302734, 354.484222);
					} else {
						SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,0.503249, -0.02376, 0.065051, -11.131746, 357.302734, 354.484222);
					}
				}
			}
			
			case 34: {
				if(IsPlayerAiming(playerid)){
					if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK){
						SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,0.528249, -0.020266, 0.068052, -6.621746, 352.552642, 355.084289);
					} else {
						SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,0.528249, -0.020266, 0.068052, -1.621746, 356.202667, 355.084289);
					}
					return 1;
				} else {
					if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK){
						SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,0.658248, -0.03276, 0.133051, -11.631746, 355.302673, 353.584259);
					} else {
						SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,0.658248, -0.03276, 0.133051, -11.631746, 355.302673, 353.584259);
					}
				}
			}
			
			case 29: {
				if(IsPlayerAiming(playerid)){
					if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK){
						SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,0.298249, -0.02776, 0.158052, -11.631746, 359.302673, 357.584259);
					} else {
						SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,0.298249, -0.02776, 0.158052, 8.368253, 358.302673, 352.584259);
					}
				} else {
					if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK){
						SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,0.293249, -0.027759, 0.195051, -12.131746, 354.302734, 352.484222);
					} else {
						SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,0.293249, -0.027759, 0.195051, -12.131746, 354.302734, 352.484222);
					}
				}
			}
			
		}
	}
	return 1;
}

stock OnPlayerChangeWeapon(playerid, oldweapon, newweapon){
	new oWeapon[24],
		nWeapon[24];

	GetWeaponName(oldweapon, oWeapon, sizeof(oWeapon));
	GetWeaponName(newweapon, nWeapon, sizeof(nWeapon));
 	if(newweapon==WEAPON_DEAGLE || newweapon==WEAPON_M4 || newweapon==WEAPON_SHOTGUN){
		if(flashlight == 1){
			SetPlayerAttachedObject(playerid, 1,18656, 6, 0.25, -0.0155, 0.16, 86.5, -185, 86.5, 0.03, 0.03, 0.03);
			SetPlayerAttachedObject(playerid, 2,18641, 6, 0.2, 0.01, 0.16, 90, -95, 90, 1, 1, 1);
			flashlight=1;
			return 1;
		}
	}
	return 1;
}

public StartEngine(playerid){
	new vehicleid = GetPlayerVehicleID(playerid);
	new Float:health;
	new rand = random(2);

	GetVehicleHealth(vehicleid, health);

	if(IsPlayerInAnyVehicle(playerid)){
		if(vehEngine[vehicleid] == 2){
			if(health > 300){
				if(rand == 0){
					vehEngine[vehicleid] = 1;
  					TogglePlayerControllable(playerid, 1);
  					SetTimerEx("DamagedEngine", 1000, 1, "i", playerid);
					SendClientMessage(playerid, LIGHTBLUE, "Vehicle engine started sucessfully");
				} else if(rand == 1){
					vehEngine[vehicleid] = 0;
					TogglePlayerControllable(playerid, 0);
					SendClientMessage(playerid, red, "Vehicle engine failed to start");
				}
			} else {
				vehEngine[vehicleid] = 0;
				TogglePlayerControllable(playerid, 0);
				SendClientMessage(playerid, red, "Vehicle engine failed to start due to damage");
			}
		}
	}
	return 1;
}

public DamagedEngine(playerid){
	new vehicleid = GetPlayerVehicleID(playerid);
	new Float:health;

	GetVehicleHealth(vehicleid, health);

	if(IsPlayerInAnyVehicle(playerid)){
		if(vehEngine[vehicleid] == 1){
			if(health < 300){
				vehEngine[vehicleid] = 0;
				TogglePlayerControllable(playerid, 0);
				SendClientMessage(playerid, red, "Vehicle engine stopped due to damage");
			}
		}
	}
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid){
	TogglePlayerControllable(playerid, 1);
	return 1;
}

public OnPlayerEnterCheckpoint(playerid){
	if(IsPlayerNPC(playerid)) return 0;
	
	if(gTeam[playerid] == TEAM_HUMAN && pCPEnable[playerid]){  //<--- look
		GameTextForPlayer(playerid,"~g~ Stay in the Checkpoint to Clear it..", 6000, 4);
		SendClientMessageToAll(PURPLE,"You have been given 7000$");
		SendClientMessageToAll(PURPLE,"You have been given Medical Attention.");
		SetPlayerScore(playerid, GetPlayerScore(playerid) + 1);
		SetPlayerHealth(playerid, 100);
		GivePlayerMoney(playerid, 7000);
		pCPEnable[playerid] = false;
		SetTimerEx("ResetPlayerCP",30*1000,false,"d",playerid);
	}
	if(gTeam[playerid] == TEAM_ZOMBIE){
		GameTextForPlayer(playerid,"~p~ Fuck those survivors.", 6000, 4);
	}
	return 1;
}

public GetClosestPlayers(playerid){
	new Float:dis,Float:dis2,player;
	player = -1;
	dis = 99999.99;
	foreach(Player,i){
		if(i != playerid){
			dis2 = GetDistanceBetweenPlayers(i,playerid);
			if(dis2 < dis){
				dis = dis2;
				player = i;
			}
		}
	}
	return player;
}

stock IsPlayerInWater(playerid){
	new anim = GetPlayerAnimationIndex(playerid);
	if(((anim >=  1538) && (anim <= 1542)) || (anim == 1544) || (anim == 1250) || (anim == 1062)) return 1;
	return 0;
}

public ResetPlayerCP(playerid){
	pCPEnable[playerid] = true;
	return 1;
}

public SendRandomMsgToAll(){
	switch(random(11)){
		case 0: SendClientMessageToAll(COLOR_YELLOW, "[SERVER]{FFFFFF} You're playing on Zombies vs Humans Apocalypse v1.3 FINAL Release!");
		case 1: SendClientMessageToAll(GREEN, "[SERVER]{FFFFFF} Please read all /rules, /shelp and /cmds before start playing.");
		case 2: SendClientMessageToAll(red, "[SERVER]{FFFFFF} Cheating in the server will give you permanent ban.");
		case 3: SendClientMessageToAll(ORANGE, "[SERVER]{FFFFFF} We are recuriting admins. You can also join us.");
		case 4: SendClientMessageToAll(BLUE, "[SERVER]{FFFFFF} Please Donate us to keep alive.");
		case 5: SendClientMessageToAll(GREEN, "[SERVER]{FFFFFF} You can also visit us at unique-hosting.com");
		case 6: SendClientMessageToAll(BLUE, "[SERVER]{FFFFFF} If you need any help type /help or ask an admin");
		case 7: SendClientMessageToAll(ORANGE, "[SERVER]{FFFFFF} Be sure to register on our forums at unique-hosting.com");
		case 8: SendClientMessageToAll(red, "[SERVER]{FFFFFF} Please ensure that you abide by all of the rules");
		case 9: SendClientMessageToAll(COLOR_YELLOW, "[SERVER]{FFFFFF} Did you know Zombies have brains?");
		case 10: SendClientMessageToAll(GRAY, "[SERVER]{FFFFFF} Please do not spam the game chat: doing so may result in a temporary ban, kick or mute!");
	}
}

public timer_update(){
	foreach(Player,i){
		if(isrefuelling[i]) return 0;
		new vid = GetPlayerVehicleID(i);
		if(GetPlayerVehicleSeat(i) == 0){
			fuel[vid] = fuel[vid] - 1;
			if(fuel[vid] < 1){
				fuel[vid] = 0;
				new veh = GetPlayerVehicleID(i);
				new engine,lights,alarm,doors,bonnet,boot,objective;
				GetVehicleParamsEx(veh,engine,lights,alarm,doors,bonnet,boot,objective);
				SetVehicleParamsEx(veh,VEHICLE_PARAMS_OFF,lights,alarm,doors,bonnet,boot,objective);
				Engine[i]=0;
				GameTextForPlayer(i,"~r~You are out of ~w~fuel~r~!",5000,4);
			}
		}
		new string[128];format(string,sizeof string,"Fuel:	%i",fuel[vid] /3);
		TextDrawSetString(td_fuel[i],string);

		new Float:speed_x,Float:speed_y,Float:speed_z,Float:temp_speed,final_speed,Float:health;

		GetVehicleVelocity(vid,speed_x,speed_y,speed_z);
		temp_speed = floatsqroot(((speed_x*speed_x)+(speed_y*speed_y))+(speed_z*speed_z))*136.666667;
		final_speed = floatround(temp_speed,floatround_round);
		format(string,sizeof string,"Speed:  %i",final_speed);
		TextDrawSetString(td_vspeed[i],string);

		GetVehicleHealth(vid,health);
		if(max_vhealth[vid] == 0){
			fuel[vid] = 300;
			GetVehicleHealth(vid,max_vhealth[vid]);
		}
		health = (((health - max_vhealth[vid]) /max_vhealth[vid]) *100)+ 100;
		format(string,sizeof string,"Health: %i",floatround(health,floatround_round));
		TextDrawSetString(td_vhealth[i],string);
	}
	return 1;
}

public timer_refuel(playerid){
	new vid = GetPlayerVehicleID(playerid);
	if(Engine[playerid]==0){
		new veh = GetPlayerVehicleID(playerid);
		new engine,lights,alarm,doors,bonnet,boot,objective;
		GetVehicleParamsEx(veh,engine,lights,alarm,doors,bonnet,boot,objective);
		SetVehicleParamsEx(veh,VEHICLE_PARAMS_ON,lights,alarm,doors,bonnet,boot,objective);
		Engine[playerid]=1;
	}
	fuel[vid] = fuel[vid] = 300;
	isrefuelling[playerid] = 0;
	TextDrawSetString(td_fuel[playerid],"Fuel:100");
}

stock DisplayGroupMembers(groupid, playerid){
	new amount[2], string[200], shortstr[55], pname[24];
	format(string, sizeof(string), "Group Members for %s(ID:%d)", groupinfo[groupid][grname], groupid);
	SendClientMessage(playerid, 0xFFFFFF, string);
	string = "";
	foreach(Player,i){
		if(group[i][gid] == groupid){
			amount[0]++;
			amount[1]++;
			GetPlayerName(i, pname, 24);
			if(groupinfo[groupid][leader] != i) format(shortstr, sizeof(shortstr), "%s(%d),", pname, i);
			if(groupinfo[groupid][leader] == i) format(shortstr, sizeof(shortstr), "[LEADER]%s(%d),", pname, i);
			if(amount[1] == 1) format(string, sizeof(string), "%s", shortstr);
			if(amount[1] != 1) format(string, sizeof(string), "%s %s", string, shortstr);
			if(amount[0] == 6){
				strdel(string, strlen(string)-1, strlen(string));
				SendClientMessage(playerid, 0xFFCC66, string);
				string = "";
				amount[0] = 0;
			}
		}
	}
	strdel(string, strlen(string)-1, strlen(string));
	if(amount[0] != 0) SendClientMessage(playerid, 0xFFCC66, string);
	return 1;
}

stock ListGroups(playerid){
	new amount[2], string[200], shortstr[55];
	SendClientMessage(playerid, 0xFFFFFF, "Current groups:");
	for(new x = 0; x < MAX_GROUPS; x++){
		if(groupinfo[x][active]){
	 		amount[0]++;
	 		amount[1]++;
	 		format(shortstr, sizeof(shortstr), "%s(ID:%d)", groupinfo[x][grname], x);
			if(amount[1] == 1) format(string, sizeof(string), "%s", shortstr);
			if(amount[1] != 1) format(string, sizeof(string), "%s %s", string, shortstr);
			if(amount[0] == 4){
				SendClientMessage(playerid, 0xFFCC66, string);
				string = "";
				amount[0] = 0;
			}
		}
	}
	if(amount[1] == 0) SendClientMessage(playerid, 0xFFFF00, "There are currently no active groups!");
	if(amount[1] != 0) SendClientMessage(playerid, 0xFFCC66, string);
	return 1;
}



stock SendMessageToLeader(groupi, message[])
	return SendClientMessage(groupinfo[groupi][leader], 0xFFCC66, message);

stock GroupJoin(playerid, groupi){
	group[playerid][gid] = groupi;
	group[playerid][order] = GroupMembers(groupi);
	group[playerid][attemptjoin] = -1;
	group[playerid][invited] = -1;
	new pname[24], string[130];
	GetPlayerName(playerid, pname, 24);
	format(string, sizeof(string), "%s has joined your group!", pname);
	SendMessageToAllGroupMembers(groupi, string);
	format(string, sizeof(string), "You have joined group %s(ID:%d)", groupinfo[groupi][grname] ,groupi);
	SendClientMessage(playerid, 0xFFCC66, string);
	return 1;
}

stock FindNextSlot(){
	new id;
	while(groupinfo[id][active]) id++;
	return id;
}

stock IsGroupTaken(grpname[]){
	for(new x = 0; x < MAX_GROUPS; x++){
		if(groupinfo[x][active] == 1){
			if(!strcmp(grpname, groupinfo[x][grname], true) && strlen(groupinfo[x][grname]) != 0) return 1;
		}
	}
	return 0;
}

stock GroupInvite(playerid, groupid)
	return group[playerid][invited] = groupid;

stock CreateGroup(grpname[], owner){
	new slotid = FindNextSlot();
	groupinfo[slotid][leader] = owner;
	format(groupinfo[slotid][grname], 75, "%s", grpname);
	groupinfo[slotid][active] = 1;
	group[owner][gid] = slotid;
	group[owner][order] = 1;
	new string[120];
	format(string, sizeof(string), "You have created the group %s(ID:%d)", grpname, slotid);
	SendClientMessage(owner, 0xFFCC66, string);
	return slotid;
}

stock LeaveGroup(playerid, reason){
	new groupid = group[playerid][gid], orderid = group[playerid][order], string[100], pname[24];
	group[playerid][gid] = -1;
	group[playerid][order] = -1;
	GroupCheck(groupid, orderid);
	GetPlayerName(playerid, pname, 24);
	if(reason == 0){
 		format(string, sizeof(string), "{FFFFFF}%s(%d){FFCC66} has left your group!", pname, playerid);
 		SendClientMessage(playerid, 0xFFCC66, "You have left your group");
 	} else if(reason == 1){
		format(string, sizeof(string), "{FFFFFF}%s(%d){FFCC66} has left your group (Kicked by the leader)!", pname, playerid);
		SendClientMessage(playerid, 0xFFCC66, "You have been kicked from your group!");
	} else if(reason == 2){
		format(string, sizeof(string), "{FFFFFF}%s(%d){FFCC66} has left your group (Disconnected)!", pname, playerid);
	}
	SendMessageToAllGroupMembers(groupid, string);
	return 1;
}

stock GroupCheck(groupid, orderid){
	new gmems = GroupMembers(groupid);
	if(!gmems) groupinfo[groupid][active] = 0;
	if(gmems != 0) ChangeMemberOrder(groupid, orderid);
	return 1;
}

stock GroupMembers(groupid){
	if(!groupinfo[groupid][active]) return 0;
	new groupmembers;
	for(new i = 0; i < MAX_PLAYERS; i++) if(group[i][gid] == groupid) groupmembers++;
	return groupmembers;
}

stock ChangeMemberOrder(groupid, orderid){
	for(new i = 0; i < MAX_PLAYERS; i++){
		if(group[i][gid] != groupid || group[i][order] < orderid) continue;
		group[i][order]--;
		if(group[i][order] == 1){
			groupinfo[groupid][leader] = i;
			new string[128], pname[24];
			GetPlayerName(i, pname, 24);
			format(string, sizeof(string), "{FFFFFF}%s(%d){FFCC66} has been promoted to the new group leader!", pname, i);
			SendMessageToAllGroupMembers(groupid, string);
		}
	}
	return 1;
}

stock SendMessageToAllGroupMembers(groupid, message[]){
	if(!groupinfo[groupid][active]) return 0;
	for(new x; x<MAX_PLAYERS; x++) if(group[x][gid] == groupid) SendClientMessage(x, 0xFFCC66, message);
	return 1;
}

public TransMission(){
	COUNTER++;
	switch(COUNTER){
		case 1:	{
			SendClientMessageToAll(red,"~Radio TRANSMISSION~");
			SendClientMessageToAll(GREEN,"If any Survivours is hearing this message");
			SendClientMessageToAll(GREEN,"Please go to ____Glen Park___ for further assisstance");
			SendClientMessageToAll(GREEN,"Umbrella Corp had setup their for survivors");
			SendClientMessageToAll(GREEN,"We have Food and Medical Service");
			SendClientMessageToAll(GREEN,"Please be safe while arriving here or zombies will hunt you down.");
			foreach(Player,i){
				PlayAudioStreamForPlayer(i,"http://k003.kiwi6.com/hotlink/blb3aqymb1/Glen_park.mp3"),
				SetPlayerCheckpoint(i, 1969.99, -1199.42, 25.64, 35.0); //CheckPoint 1
			}
		}
		case 2: {
			SendClientMessageToAll(red,"~Radio TRANSMISSION~");
			SendClientMessageToAll(GREEN,"If any Survivours is hearing this message");
			SendClientMessageToAll(GREEN,"Please go to ___Santa Maria Beach___ for further assisstance");
			SendClientMessageToAll(GREEN,"Umbrella Corp had setup their for survivors");
			SendClientMessageToAll(GREEN,"We have Food and Medical Service");
			SendClientMessageToAll(GREEN,"Please be safe while arriving here or zombies will hunt you down.");
			foreach(Player,i){
				PlayAudioStreamForPlayer(i,"http://k003.kiwi6.com/hotlink/346l57lq9m/Santa_beacg.mp3"),
				SetPlayerCheckpoint(i, 369.48, -2030.19, 7.67, 35.0); //CheckPoint 2
			}
		}
		case 3: {
			SendClientMessageToAll(red,"~Radio TRANSMISSION~");
			SendClientMessageToAll(GREEN,"If any Survivours is hearing this message");
			SendClientMessageToAll(GREEN,"Please go to ____Unity Station____ for further assisstance");
			SendClientMessageToAll(GREEN,"Umbrella Corp had setup their for survivors");
			SendClientMessageToAll(GREEN,"We have Food and Medical Service");
			SendClientMessageToAll(GREEN,"Please be safe while arriving here or zombies will hunt you down.");
			foreach(Player,i){
				PlayAudioStreamForPlayer(i,"http://k003.kiwi6.com/hotlink/nqc1mpl4qe/Unity.mp3"),
				SetPlayerCheckpoint(i, 1774.26, -1939.52, 13.56, 35.0); //CheckPoint 3
			}
		}
		case 4: {
			SendClientMessageToAll(red,"~Radio TRANSMISSION~");
			SendClientMessageToAll(GREEN,"If any Survivours is hearing this message");
			SendClientMessageToAll(GREEN,"Please go to ___Market___ for further assisstance");
			SendClientMessageToAll(GREEN,"Umbrella Corp had setup their for survivors");
			SendClientMessageToAll(GREEN,"We have Food and Medical Service");
			SendClientMessageToAll(GREEN,"Please be safe while arriving here or zombies will hunt you down.");
			foreach(Player,i){
				PlayAudioStreamForPlayer(i,"http://k003.kiwi6.com/hotlink/kirjuuvsky/Marker.mp3"),
				SetPlayerCheckpoint(i, 776.31, -1353.71, 13.54, 35.0); //CheckPoint 4
			}
		}
		case 5:	{
			SendClientMessageToAll(red,"~Radio TRANSMISSION~");
			SendClientMessageToAll(GREEN,"If any Survivours is hearing this message");
			SendClientMessageToAll(GREEN,"Please go to ___Grove Street___ for further assisstance");
			SendClientMessageToAll(GREEN,"Umbrella Corp had setup their for survivors");
			SendClientMessageToAll(GREEN,"We have Food and Medical Service");
			SendClientMessageToAll(GREEN,"Please be safe while arriving here or zombies will hunt you down.");
			foreach(Player,i){
				PlayAudioStreamForPlayer(i,"http://k003.kiwi6.com/hotlink/2fxrypdl9j/Grove.mp3"),
				SetPlayerCheckpoint(i, 2501.05, -1666.91, 13.36, 35.0); //CheckPoint 5
			}
		}
		case 6: {
			SendClientMessageToAll(red,"~Radio TRANSMISSION~");
			SendClientMessageToAll(GREEN,"If any Survivours is hearing this message");
			SendClientMessageToAll(GREEN,"Please go to ___Rodeo___ for further assisstance");
			SendClientMessageToAll(GREEN,"Umbrella Corp had setup their for survivors");
			SendClientMessageToAll(GREEN,"We have Food and Medical Service");
			SendClientMessageToAll(GREEN,"Please be safe while arriving here or zombies will hunt you down.");
			foreach(Player,i){
				PlayAudioStreamForPlayer(i,"http://k003.kiwi6.com/hotlink/0f4psm4ncu/Rodeo.mp3"),
				SetPlayerCheckpoint(i, 535.44, -1477.09, 14.54, 35.0); //CheckPoint 7
			}
		}
		case 7: {
			SendClientMessageToAll(red,"~Radio TRANSMISSION~");
			SendClientMessageToAll(GREEN,"If any Survivours is hearing this message");
			SendClientMessageToAll(GREEN,"Please go to ___Military Secret base___ for further assisstance");
			SendClientMessageToAll(GREEN,"Umbrella Corp had setup their for survivors");
			SendClientMessageToAll(GREEN,"We have Food and Medical Service");
			SendClientMessageToAll(GREEN,"Please be safe while arriving here or zombies will hunt you down.");
			foreach(Player,i){
				PlayAudioStreamForPlayer(i,"http://k003.kiwi6.com/hotlink/urrtvuftnd/Secret_base.mp3"),
				SetPlayerCheckpoint(i, 2709.97, -1065.97, 75.37, 35.0); //CheckPoint 6
			}
		}
		case 8: {
			SendClientMessageToAll(red,"~Radio TRANSMISSION~");
			SendClientMessageToAll(GREEN,"If any Survivours is hearing this message");
			SendClientMessageToAll(GREEN,"Please go to ___Vinewood___ for further assisstance");
			SendClientMessageToAll(GREEN,"Umbrella Corp had setup their for survivors");
			SendClientMessageToAll(GREEN,"We have Food and Medical Service");
			SendClientMessageToAll(GREEN,"Please be safe while arriving here or zombies will hunt you down.");
			foreach(Player,i){
				PlayAudioStreamForPlayer(i,"http://k003.kiwi6.com/hotlink/55fy49xlr5/Vinewood.mp3"),
				SetPlayerCheckpoint(i, 1005.63, -940.09, 42.18, 35.0); //CheckPoint 8
			}
		}
		case 9: {
			SendClientMessageToAll(red,"~Radio TRANSMISSION~");
			SendClientMessageToAll(GREEN,"If any Survivours is hearing this message");
			SendClientMessageToAll(GREEN,"Please go to ___Gate C___ for further assisstance");
			SendClientMessageToAll(GREEN,"Umbrella Corp had setup their for survivors");
			SendClientMessageToAll(GREEN,"We have Food and Medical Service");
			SendClientMessageToAll(GREEN,"Please be safe while arriving here or zombies will hunt you down.");
			foreach(Player,i){
				PlayAudioStreamForPlayer(i,"http://k003.kiwi6.com/hotlink/ppm8ehtlwu/Gate_c.mp3"),
				SetPlayerCheckpoint(i, 1628.96, -1010.14, 23.90, 35.0); //CheckPoint 9
			}
		}
		case 10: {
			SendClientMessageToAll(red,"~Radio TRANSMISSION~");
			SendClientMessageToAll(GREEN,"If any Survivours is hearing this message");
			SendClientMessageToAll(GREEN,"Please go to ___D12 Crash Site___ for further assisstance");
			SendClientMessageToAll(GREEN,"Umbrella Corp had setup their for survivors");
			SendClientMessageToAll(GREEN,"We have Food and Medical Service");
			SendClientMessageToAll(GREEN,"Please be safe while arriving here or zombies will hunt you down.");
			foreach(Player,i){
				PlayAudioStreamForPlayer(i,"http://k003.kiwi6.com/hotlink/wpk02p7f3f/D12.mp3"),
				SetPlayerCheckpoint(i, 2434.31, -1502.13, 23.83, 35.0); //CheckPoint 10
			}
			COUNTER = 0;
		}
	}
	return 1;
}

//EOF
