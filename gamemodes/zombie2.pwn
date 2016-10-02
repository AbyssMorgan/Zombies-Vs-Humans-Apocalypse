// Gamemode-- Zombie vs Human Apoclaypse v1.3 deathmatch Gamemode.
// Credits: Owen007 and all map credits are given to their respected owners.

// *New Feautres: v1.3:
//  1.Anti wrong RCON Login kick removed.
//  2.cmds updated to zcmds.
//  3.Group system by hic killer.
//  4.merged fs to gamemode for easy upload to ftp or for downloading easily.
//  5.Some new maps added.
//  6.Ranks sytem added.


//Includes:

#include <a_samp>     // these are includes u can see these files in include folder
#include <streamer>   // u have to download streamer.dll in plugins and u have to add it in server.cfg
#include <sscanf2>
#include <y_ini>
#include <gl_common>
#include <zcmd>
#include <foreach>

#include <samc>
#include <GAC>

#include <3DTryg>
#include <Knife>

//Teams:

#define TEAM_ZOMBIE 1    //defines used to define a team.
#define TEAM_HUMAN 2

//Colors:

#define TEAM_ZOMBIE_COLOR 0xB360FDFF   // these are the colors i used in gamemode everywhere you can add more.
#define TEAM_HUMAN_COLOR 0x21DD00FF
#define ORANGE 0xF97804FF
#define BLUE 0x1229FAFF
#define GRAY 0xCECECEFF
#define GREEN 0x21DD00FF
#define red 0xFF0000AA
#define LIGHTBLUE 0x00C2ECFF
#define PURPLE 0xB360FDFF
#define COLOR_RED 0xFF0000FF
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_ORANGE 0xFF9900AA
#define COL_WHITE "{FFFFFF}"
#define COL_RED "{F81414}"
#define COL_GREEN "{00FF22}"
#define COL_LIGHTBLUE "{00CED1}"
#define ORANGE 0xF97804FF
#define BLUE 0x1229FAFF
#define COL_WHITE "{FFFFFF}"
#define COL_RED "{F81414}"
#define COL_GREEN "{00FF22}"
#define COL_LIGHTBLUE "{00CED1}"
#define COLOR_GRAD1 0xB4B5B7FF
#define COLOR_GRAD2 0xBFC0C2FF
#define COLOR_GRAD3 0xCBCCCEFF
#define COLOR_GRAD4 0xD8D8D8FF
#define COLOR_GRAD5 0xE3E3E3FF
#define COLOR_GRAD6 0xF0F0F0FF
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GREEN 0x33AA33AA
#define COLOR_RED 0xFF0000FF
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_FADE1 0xE6E6E6E6
#define COLOR_FADE2 0xC8C8C8C8
#define COLOR_FADE3 0xAAAAAAAA
#define COLOR_FADE4 0x8C8C8C8C
#define COLOR_FADE5 0x6E6E6E6E
#define COLOR_PURPLE 0xC2A2DAAA
#define COLOR_DARKBLUE 0x2641FEAA
#define COLOR_ALLDEPT 0xFF8282AA
#define COLOR_ADMIN 0xD2CAAEFF

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

//ignore this:

#pragma tabsize 0

//register:

#define DIALOG_REGISTER 1
#define DIALOG_LOGIN 2
#define DIALOG_SUCCESS_1 3
#define DIALOG_SUCCESS_2 4

#define PATH "ZVH/Users/%s.ini"

#define KEY_AIM (128)

#define MAX_GROUPS 20

//enums:

enum ZVHInfo
{
    ZVHPass,
    ZVHCash,
    ZVHKills,
    ZVHDeaths,
    ZVHScore
}

enum ginfo
{
	grname[75],
	leader,
	active
};

enum pginfo
{
	gid,
	order,
	invited,
	attemptjoin
};

enum PMInfo
{
		LastPM,
        NoPM,
};

//forwards:

forward StartEngine(playerid);
forward DamagedEngine(playerid);
forward GetClosestPlayer(p1);
forward GetClosestPlayers(p1);
forward LoadUser_data(playerid,name[],value[]);
forward ResetPlayerCP(playerid);
forward SendRandomMsgToAll();
forward timer_update();
forward timer_refuel(playerid);
forward TransMission(playerid);

//new:

new gTeam[MAX_PLAYERS];
new vehEngine[MAX_VEHICLES];
new flashlight;
new lastTPTime[MAX_PLAYERS];
new PlayerInfo[MAX_PLAYERS][ZVHInfo];
new pCPEnable [MAX_PLAYERS];
new NPCVehicle;
new NPCVehicle2;
new NPCVehicle3;
new NPCVehicle4;
new Text:td_fuel[MAX_PLAYERS];
new Text:td_vhealth[MAX_PLAYERS];
new Text:td_vspeed[MAX_PLAYERS];
new Text:td_box[MAX_PLAYERS];
new isrefuelling[MAX_PLAYERS] = 0;
new fuel[MAX_VEHICLES];
new Float:max_vhealth[MAX_VEHICLES];
new Engine[MAX_PLAYERS];
new group[MAX_PLAYERS][pginfo];
new groupinfo[MAX_GROUPS][ginfo];
new COUNTER;
new pInfo[MAX_PLAYERS][PMInfo];


main()    // this is printed on console of samp
{
	print("\n------------------------------------------");
	print("                                            ");
	print(" Zombie vs Humans Apoclaypse v1.3 by Owen007");
	print("                                            ");
	print("------------------------------------------\n");
}

public OnGameModeInit()
{
	ToggleKnifeShootForAll(false);
	ToggleUseTeamKnifeShoot(true);
	SetGameModeText("Zombies Vs Humans Apocalypse v1.3");
	for(new x; x<MAX_PLAYERS; x++)
	{
		group[x][gid] = -1;
		group[x][order] = -1;
		group[x][invited] = -1;
		group[x][attemptjoin] = -1;
	}
    for(new i=0;i<MAX_VEHICLES;i++) {
        GetVehicleHealth(i,max_vhealth[i]); //getting max health
        fuel[i] = 250 + random(150);  //setting fuel for vehicles
    }
    for(new i=0;i<MAX_PLAYERS;i++) { //setting up all textdraws
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
	new p = GetMaxPlayers();
 	for (new i=0; i < p; i++) {
  		SetPVarInt(i, "laser", 0);
    	SetPVarInt(i, "color", 18643);
  	}
  	SetTimer("SendRandomMsgToAll", 60 * 1000, 1);

 	SetGameModeText("Zombies vs Humans Apocalypse v1.3");  // this is gamemode text when some connect to your sever

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


	//CJ House por GROVE4L
    CreateDynamicObject(960, 2497.5651855469, -1703.3581542969, 1014.1239624023, 0, 0, 0);
    CreateDynamicObject(960, 2497.9196777344, -1698.6461181641, 1014.1239624023, 0, 0, 271.99951171875);
    CreateDynamicObject(911, 2490.5725097656, -1707.5363769531, 1017.9103393555, 0, 0, 90);
    CreateDynamicObject(912, 2498.4462890625, -1706.5772705078, 1017.9103393555, 0, 0, 0);
    CreateDynamicObject(3092, 2495.16796875, -1702.0899658203, 1018.0767822266, 90, 179.59649658203, 268.40350341797);
    CreateDynamicObject(2908, 2494.7565917969, -1693.9163818359, 1013.8195800781, 0, 0, 58);
    CreateDynamicObject(2908, 2494.1159667969, -1704.4520263672, 1013.8195800781, 0, 0, 82);
    CreateDynamicObject(2907, 2496.7180175781, -1708.4578857422, 1017.4968261719, 0, 0, 54);
    CreateDynamicObject(2906, 2491.2858886719, -1696.7751464844, 1013.8217163086, 0, 0, 340);
    CreateDynamicObject(2905, 2494.2041015625, -1696.7418212891, 1013.8336181641, 0, 0, 0);
    CreateDynamicObject(922, 2494.6999511719, -1707.0377197266, 1014.627746582, 0, 0, 0);
    CreateDynamicObject(923, 2492.6303710938, -1710.49609375, 1014.621887207, 0, 0, 90);
    CreateDynamicObject(2671, 2498.5864257813, -1708.1081542969, 1013.7421875, 0, 0, 0);
    CreateDynamicObject(2672, 2497.0607910156, -1709.5727539063, 1014.0216674805, 0, 0, 0);
    CreateDynamicObject(2676, 2496.5141601563, -1694.4079589844, 1013.8455200195, 0, 0, 88);
    CreateDynamicObject(2677, 2492.783203125, -1701.4130859375, 1014.0360107422, 0, 0, 0);
    CreateDynamicObject(2674, 2492.2932128906, -1706.8405761719, 1017.3585205078, 0, 0, 0);
    CreateDynamicObject(2675, 2495.0131835938, -1703.8405761719, 1017.4080200195, 0, 0, 0);
    CreateDynamicObject(2676, 2491.9724121094, -1703.3272705078, 1017.4470825195, 0, 0, 86);
    CreateDynamicObject(3111, 2493.1711425781, -1708.2673339844, 1014.6315917969, 0, 0, 90);
    CreateDynamicObject(3017, 2493.4714355469, -1708.7810058594, 1014.7283935547, 0, 0, 0);
    CreateDynamicObject(6964, 2503.8366699219, -1713.0550537109, 1012.9389038086, 0, 0, 0);
    CreateDynamicObject(1531, 2498.4296875, -1695.0815429688, 1015.8082885742, 0, 0, 0);
    CreateDynamicObject(3515, 2500.8764648438, -1708.8765869141, 1010.5141601563, 0, 0, 0);
    CreateDynamicObject(2136, 2497.2155761719, -1712.1766357422, 1013.7421875, 0, 0, 180);
    CreateDynamicObject(1431, 2494.8293457031, -1705.5357666016, 1017.8913574219, 0, 0, 0);
    CreateDynamicObject(911, 2492.126953125, -1700.5924072266, 1017.9103393555, 0, 0, 0);
    CreateDynamicObject(924, 2490.8383789063, -1702.3218994141, 1017.5244750977, 0, 0, 90);
    CreateDynamicObject(913, 2490.8447265625, -1705.0670166016, 1018.1754760742, 0, 0, 90);

        //Refugio Aezir
    CreateDynamicObject(10845, 2756.2521972656, -2437.2885742188, 15.57940864563, 0, 0, 181.83508300781);
    CreateDynamicObject(9131, 2773.6352539063, -2430.5085449219, 13.766035079956, 0, 0, 63.039733886719);
    CreateDynamicObject(9131, 2773.6145019531, -2430.4965820313, 16.039030075073, 0, 0, 332.37158203125);
    CreateDynamicObject(3940, 2761.0419921875, -2391.6740722656, 15.802520751953, 0, 0, 219.25036621094);
    CreateDynamicObject(16310, 2773.6828613281, -2402.02734375, 12.627555847168, 0, 0, 87.224395751953);
    CreateDynamicObject(16310, 2746.4482421875, -2449.0256347656, 12.6484375, 0, 0, 270.27319335938);

	//24/7 unity de Theking
    CreateDynamicObject(2906, -32.058460235596, -89.546401977539, 1002.6209106445, 0, 0, 0);
    CreateDynamicObject(2907, -36.369140625, -90.3349609375, 1002.7069091797, 0, 0, 0);
    CreateDynamicObject(2908, -32.845706939697, -83.988632202148, 1002.6242675781, 0, 0, 0);
    CreateDynamicObject(2908, -26.523246765137, -89.021453857422, 1002.6242675781, 0, 0, 0);
    CreateDynamicObject(2905, -27.640796661377, -90.683891296387, 1003.5977172852, 0, 0, 0);
    CreateDynamicObject(2908, -30.12572479248, -88.960906982422, 1002.6242675781, 0, 0, 0);
    CreateDynamicObject(2908, -17.217897415161, -84.995269775391, 1002.6242675781, 0, 0, 0);
    CreateDynamicObject(2908, -22.349849700928, -75.388397216797, 1002.6242675781, 0, 0, 0);
    CreateDynamicObject(2908, -27.683710098267, -91.477081298828, 1002.6242675781, 0, 0, 0);
    CreateDynamicObject(2905, -27.219190597534, -87.451370239258, 1003.5977172852, 0, 0, 0);
    CreateDynamicObject(2906, -28.981985092163, -87.932518005371, 1002.6209106445, 0, 0, 0);
    CreateDynamicObject(2906, -37.06579208374, -84.064308166504, 1002.6209106445, 0, 0, 0);
    CreateDynamicObject(2906, -32.524887084961, -79.04386138916, 1002.6209106445, 0, 0, 0);
    CreateDynamicObject(2906, -28.905456542969, -75.592803955078, 1002.6209106445, 0, 0, 0);
    CreateDynamicObject(2906, -28.9052734375, -75.5927734375, 1002.6209106445, 0, 0, 0);
    CreateDynamicObject(2906, -24.099481582642, -83.239051818848, 1002.6209106445, 0, 0, 0);
    CreateDynamicObject(2906, -19.638854980469, -84.555511474609, 1002.6209106445, 0, 0, 0);
    CreateDynamicObject(2906, -15.311996459961, -88.172950744629, 1002.6209106445, 0, 0, 0);
    CreateDynamicObject(3007, -29.770414352417, -80.524078369141, 1003.1519775391, 0, 0, 0);
    CreateDynamicObject(3009, -29.748804092407, -80.558837890625, 1003.1262817383, 0, 0, 0);
    CreateDynamicObject(3012, -29.773687362671, -80.488540649414, 1003.1063232422, 0, 0, 0);
    CreateDynamicObject(3097, -16.891565322876, -73.297019958496, 1006.4598999023, 0, 316, 14);
    CreateDynamicObject(3099, -36.28080368042, -75.116233825684, 1002.546875, 0, 0, 0);
    CreateDynamicObject(12957, -15.577854156494, -80.518440246582, 1003.4251098633, 0, 156, 244);
    CreateDynamicObject(2671, -16.413497924805, -83.617012023926, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -16.889503479004, -87.33576965332, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -16.94607925415, -85.815376281738, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -16.9453125, -85.814453125, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -17.807685852051, -89.429496765137, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -16.287523269653, -88.926918029785, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -20.082473754883, -90.631904602051, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -21.002849578857, -88.838905334473, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -24.660898208618, -90.334518432617, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -24.187559127808, -89.150085449219, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -21.775810241699, -87.73656463623, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -21.941032409668, -85.241836547852, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -21.76989364624, -81.772315979004, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -22.290832519531, -78.448738098145, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -30.260803222656, -85.191009521484, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -28.911184310913, -88.157531738281, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -26.699201583862, -87.509284973145, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -30.77618598938, -88.731597900391, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -34.098148345947, -89.25269317627, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -29.571483612061, -91.005973815918, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -34.725509643555, -86.683258056641, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -35.073768615723, -84.207107543945, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -37.548751831055, -84.55615234375, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -38.014316558838, -88.408576965332, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -38.956401824951, -81.724327087402, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -37.610412597656, -80.523956298828, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -35.20467376709, -79.679214477539, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -35.51834487915, -77.450752258301, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -35.866737365723, -74.974685668945, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -38.836822509766, -75.3935546875, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -32.942188262939, -81.379188537598, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -33.338039398193, -85.726921081543, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -29.58659362793, -83.682662963867, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -33.191295623779, -83.181182861328, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -30.429327011108, -81.276412963867, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -30.739816665649, -77.280639648438, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -33.351280212402, -74.871421813965, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -28.647144317627, -74.207763671875, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -27.179378509521, -76.053703308105, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -25.589729309082, -79.799453735352, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -28.545120239258, -81.402862548828, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -26.872371673584, -84.913444519043, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -25.063735961914, -81.310333251953, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -24.416969299316, -84.72200012207, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -26.612018585205, -87.921669006348, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -26.026348114014, -86.27156829834, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -26.177440643311, -85.952293395996, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -21.131290435791, -78.457649230957, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -20.29517364502, -76.100845336914, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -25.645668029785, -74.73323059082, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -25.896213531494, -75.439277648926, 1002.546875, 0, 0, 0);
    CreateDynamicObject(2671, -25.8955078125, -75.4384765625, 1002.546875, 0, 0, 0);
    CreateDynamicObject(4206, -29.596082687378, -86.60782623291, 1003.0520019531, 0, 0, 0);
    CreateDynamicObject(2780, -16.469972610474, -77.307685852051, 1002.5541992188, 0, 0, 0);
    CreateDynamicObject(2059, -25.140895843506, -81.259780883789, 1002.5598144531, 0, 0, 0);
    CreateDynamicObject(17971, -32.327075958252, -81.277946472168, 1011.7172241211, 0, 0, 0);
    CreateDynamicObject(1362, -33.572425842285, -88.683486938477, 1003.158203125, 0, 93.999938964844, 0);
    CreateDynamicObject(1362, -27.927791595459, -82.210807800293, 1003.158203125, 0, 93.9990234375, 0);
    CreateDynamicObject(1362, -16.959934234619, -88.70671081543, 1003.158203125, 0, 93.9990234375, 0);
    CreateDynamicObject(3110, -26.959787368774, -71.797103881836, 1004.7400512695, 0, 230, 10);
    CreateDynamicObject(1447, -30.828561782837, -92.318290710449, 1003.8392333984, 0, 0, 0);
    CreateDynamicObject(2063, -37.593181610107, -91.839385986328, 1003.4558105469, 0, 50, 109.99993896484);
    CreateDynamicObject(3067, -34.381549835205, -91.748054504395, 1003.2081298828, 0, 0, 178);
    CreateDynamicObject(1584, -22.622623443604, -92.054763793945, 1002.5541992188, 0, 64, 353.99993896484);
    CreateDynamicObject(11245, -37.566585540771, -90.528953552246, 1005.1039428711, 0, 0, 0);
    CreateDynamicObject(1842, -36.423896789551, -76.94100189209, 1003.0192871094, 0, 333.99993896484, 104);
    CreateDynamicObject(1843, -14.73101234436, -91.579643249512, 1002.5520019531, 0, 48, 220);
    CreateDynamicObject(1889, -21.840225219727, -77.95743560791, 1002.6396484375, 0, 52, 356);
    CreateDynamicObject(2907, -24.531736373901, -91.441352844238, 1002.7069091797, 0, 0, 0);
    CreateDynamicObject(2907, -21.839698791504, -86.264694213867, 1002.7069091797, 0, 0, 0);
    CreateDynamicObject(2907, -20.858240127563, -80.80101776123, 1002.7069091797, 0, 0, 0);
    CreateDynamicObject(2907, -24.454137802124, -76.717193603516, 1002.7069091797, 0, 0, 0);
//LSPD Interior de Ner0x
    CreateDynamicObject(952, 246.86671447754, 85.091728210449, 1003.9821166992, 0, 0, 334);
    CreateDynamicObject(960, 257.30773925781, 70.673141479492, 1003.0223999023, 0, 0, 0);
    CreateDynamicObject(926, 257.404296875, 69.741905212402, 1002.8899536133, 0, 0, 0);
    CreateDynamicObject(928, 256.80902099609, 69.710884094238, 1002.8992919922, 0, 0, 0);
    CreateDynamicObject(924, 254.7261505127, 68.882804870605, 1003.5866699219, 0, 0, 0);
    CreateDynamicObject(917, 254.27627563477, 69.473747253418, 1003.0883178711, 0, 0, 0);
    CreateDynamicObject(913, 243.30351257324, 71.947242736816, 1003.4723510742, 0, 0, 0);
    CreateDynamicObject(911, 244.29054260254, 71.184211730957, 1003.2072143555, 338.01409912109, 357.84307861328, 39.192138671875);
    CreateDynamicObject(3119, 253.33992004395, 69.42268371582, 1002.9444580078, 0, 0, 0);
    CreateDynamicObject(3098, 243.01245117188, 75.918937683105, 1004.6819458008, 0, 0, 80);
    CreateDynamicObject(3092, 255.31712341309, 80.512878417969, 1003.3810424805, 80, 0, 80);
    CreateDynamicObject(2971, 261.50967407227, 71.206787109375, 1002.2421875, 0, 0, 0);
    CreateDynamicObject(2907, 256.22125244141, 74.210762023926, 1002.8006591797, 0, 0, 310);
    CreateDynamicObject(2908, 264.18643188477, 74.382133483887, 1002.3195800781, 0, 0, 0);
    CreateDynamicObject(2906, 248.00268554688, 76.307029724121, 1002.7146606445, 0, 0, 32);
    CreateDynamicObject(2905, 249.05804443359, 71.21117401123, 1002.7320556641, 0, 0, 40);
    CreateDynamicObject(1462, 245.6130065918, 72.714141845703, 1002.640625, 9.9938354492188, 357.96917724609, 0.35256958007813);
    CreateDynamicObject(1450, 242.89660644531, 62.956817626953, 1003.2409057617, 0, 0, 92.75);
    CreateDynamicObject(1442, 255.21913146973, 62.762550354004, 1003.2391357422, 0, 0, 0);
    CreateDynamicObject(2670, 255.98371887207, 64.142875671387, 1002.7326660156, 0, 0, 0);
    CreateDynamicObject(2670, 256.25152587891, 65.522834777832, 1002.7326660156, 0, 0, 251.99998474121);
    CreateDynamicObject(2670, 253.95491027832, 66.288055419922, 1002.7326660156, 0, 0, 251.99890136719);
    CreateDynamicObject(2670, 252.51164245605, 67.878799438477, 1002.7326660156, 0, 0, 181.99890136719);
    CreateDynamicObject(2670, 253.05247497559, 64.333702087402, 1002.7326660156, 0, 0, 31.994018554688);
    CreateDynamicObject(2671, 252.8111114502, 66.167068481445, 1002.640625, 0, 0, 0);
    CreateDynamicObject(2671, 257.58605957031, 68.480323791504, 1002.640625, 0, 0, 0);
    CreateDynamicObject(2671, 248.58375549316, 64.373321533203, 1002.640625, 0, 0, 0);
    CreateDynamicObject(2671, 248.93730163574, 65.599044799805, 1002.640625, 0, 0, 60);
    CreateDynamicObject(2672, 246.89431762695, 71.887283325195, 1002.9201049805, 0, 0, 0);
    CreateDynamicObject(2673, 248.53239440918, 71.551475524902, 1002.7284545898, 0, 0, 0);
    CreateDynamicObject(2673, 242.748046875, 70.731628417969, 1002.7284545898, 0, 0, 0);
    CreateDynamicObject(2673, 243.77049255371, 63.313499450684, 1002.7284545898, 0, 0, 0);
    CreateDynamicObject(2673, 243.38885498047, 64.270248413086, 1002.7284545898, 0, 0, 320);
    CreateDynamicObject(2674, 243.90184020996, 63.538410186768, 1002.6623535156, 0, 0, 0);
    CreateDynamicObject(2674, 248.73286437988, 63.358055114746, 1002.6623535156, 0, 0, 230);
    CreateDynamicObject(2675, 244.10597229004, 68.953674316406, 1002.7048950195, 0, 0, 0);
    CreateDynamicObject(2675, 246.69569396973, 68.175903320313, 1002.7048950195, 0, 0, 310);
    CreateDynamicObject(2677, 245.40028381348, 65.491798400879, 1002.9126586914, 0, 0, 0);
    CreateDynamicObject(2677, 246.03860473633, 69.24275970459, 1002.9126586914, 0, 0, 0);
    CreateDynamicObject(2677, 249.37591552734, 69.846374511719, 1002.9126586914, 0, 0, 0);
    CreateDynamicObject(2677, 246.83329772949, 81.644561767578, 1002.9126586914, 0, 0, 0);
    CreateDynamicObject(2677, 245.74459838867, 73.607368469238, 1002.9126586914, 0, 0, 0);
    CreateDynamicObject(2677, 251.4052734375, 76.268028259277, 1002.9126586914, 0, 0, 0);
    CreateDynamicObject(2677, 253.27914428711, 79.788192749023, 1002.9126586914, 0, 0, 0);
    CreateDynamicObject(2677, 258.18017578125, 73.52660369873, 1002.9126586914, 0, 0, 0);
    CreateDynamicObject(2676, 250.09782409668, 74.311683654785, 1002.7439575195, 0, 0, 0);
    CreateDynamicObject(2676, 254.52018737793, 76.679748535156, 1002.7439575195, 0, 0, 280);
    CreateDynamicObject(2676, 257.86779785156, 78.056518554688, 1002.7439575195, 0, 0, 279.99755859375);
    CreateDynamicObject(2676, 246.38700866699, 78.119834899902, 1002.7439575195, 0, 0, 279.99755859375);
    CreateDynamicObject(2676, 238.73059082031, 78.267364501953, 1004.1423950195, 0, 0, 279.99755859375);
    CreateDynamicObject(2676, 239.24493408203, 73.909889221191, 1004.1423950195, 0, 0, 279.99755859375);
    CreateDynamicObject(2675, 237.20372009277, 74.189750671387, 1004.1033325195, 0, 0, 0);
    CreateDynamicObject(2672, 236.42276000977, 78.444107055664, 1004.3185424805, 0, 0, 0);
    CreateDynamicObject(2672, 247.28709411621, 75.802177429199, 1002.9201049805, 0, 0, 0);
    CreateDynamicObject(2672, 245.06637573242, 80.773506164551, 1002.9201049805, 0, 0, 0);
    CreateDynamicObject(2672, 245.84741210938, 87.010459899902, 1002.9201049805, 0, 0, 0);
    CreateDynamicObject(2907, 245.49444580078, 81.623291015625, 1002.8006591797, 0, 0, 309.99572753906);
    CreateDynamicObject(2907, 250.3920135498, 63.194828033447, 1002.8006591797, 0, 0, 309.99572753906);
    CreateDynamicObject(2908, 247.67718505859, 77.316802978516, 1002.7180175781, 0, 0, 0);
    CreateDynamicObject(2908, 248.43106079102, 71.12255859375, 1002.7180175781, 0, 0, 0);
    CreateDynamicObject(2905, 245.36401367188, 75.264251708984, 1002.7320556641, 0, 0, 39.995727539063);

    	//Refugio Noria
    CreateDynamicObject(3578, 377.66195678711, -1931.734375, 7.6081228256226, 0, 0, 0);
    CreateDynamicObject(3578, 365.72064208984, -1939.3741455078, 7.4499082565308, 0, 0, 0);
    CreateDynamicObject(3578, 369.82861328125, -1951.341796875, 7.4499082565308, 0, 0, 0);
    CreateDynamicObject(2671, 367.7053527832, -1972.0676269531, 6.6718759536743, 0, 0, 0);
    CreateDynamicObject(2672, 373.12677001953, -1985.0545654297, 6.9513368606567, 0, 0, 0);
    CreateDynamicObject(2672, 371.81042480469, -1958.8907470703, 6.9513368606567, 0, 0, 0);
    CreateDynamicObject(2672, 377.34420776367, -1941.2006835938, 7.1153993606567, 0, 0, 0);
    CreateDynamicObject(2675, 367.95596313477, -1984.3831787109, 6.7361364364624, 0, 0, 0);
    CreateDynamicObject(2677, 368.1181640625, -1966.1979980469, 6.9438924789429, 0, 0, 0);
    CreateDynamicObject(2675, 363.24044799805, -1956.5578613281, 6.9001989364624, 0, 0, 0);
    CreateDynamicObject(2676, 362.71356201172, -1974.7077636719, 6.9392614364624, 0, 0, 0);
    CreateDynamicObject(2676, 374.13461303711, -1970.8231201172, 6.7751989364624, 0, 0, 0);
    CreateDynamicObject(2673, 371.56378173828, -2024.5197753906, 6.7597031593323, 0, 0, 0);
    CreateDynamicObject(3594, 369.65951538086, -2037.6872558594, 7.3030519485474, 0, 0, 24);
    CreateDynamicObject(3593, 370.72650146484, -1947.1121826172, 7.1320433616638, 0, 0, 10);
    CreateDynamicObject(13591, 372.9055480957, -1979.6710205078, 6.8341464996338, 0, 0, 0);
    CreateDynamicObject(942, 362.013671875, -2042.6063232422, 9.2791633605957, 0, 0, 90);
    CreateDynamicObject(923, 377.82186889648, -2019.3841552734, 7.7097764015198, 0, 0, 348);
    CreateDynamicObject(923, 377.31591796875, -2022.6799316406, 7.7097764015198, 0, 0, 34);
    CreateDynamicObject(922, 377.10046386719, -2014.8935546875, 7.7156295776367, 0, 0, 2);
    CreateDynamicObject(1224, 368.11120605469, -2026.5426025391, 7.2867889404297, 0, 0, 350);
    CreateDynamicObject(1224, 372.1203918457, -2033.6177978516, 7.2867889404297, 0, 0, 24);
    CreateDynamicObject(7586, 383.61123657227, -2068.826171875, 13.274959564209, 0, 0, 0);
    CreateDynamicObject(3932, 380.07299804688, -2035.8393554688, 8.594765663147, 0, 0, 178);
    CreateDynamicObject(3932, 379.83895874023, -2026.5462646484, 8.6006135940552, 0, 0, 196);
    CreateDynamicObject(3763, 364.90509033203, -2061.4343261719, 40.085304260254, 0, 0, 0);
    CreateDynamicObject(3030, 371.36260986328, -2043.7764892578, 6.671875, 0, 0, 0);
    CreateDynamicObject(1218, 363.5100402832, -2023.8142089844, 7.3276300430298, 0, 0, 0);
    CreateDynamicObject(1222, 362.21469116211, -2023.8889160156, 7.3120050430298, 0, 0, 0);
    CreateDynamicObject(1217, 364.43707275391, -2023.1628417969, 7.2573175430298, 0, 0, 0);
    CreateDynamicObject(3267, 380.36050415039, -2066.572265625, 19.728084564209, 0, 0, 33.997192382813);
    CreateDynamicObject(3267, 386.619140625, -2067.4775390625, 19.300737380981, 0, 0, 329.99633789063);
    CreateDynamicObject(3864, 382.42834472656, -2016.1280517578, 12.932963371277, 0, 0, 26);
    CreateDynamicObject(3864, 362.07525634766, -2033.1103515625, 12.927115440369, 0, 0, 180);
    CreateDynamicObject(1812, 379.97863769531, -2038.0666503906, 6.8300905227661, 0, 0, 270);
    CreateDynamicObject(1812, 380.00988769531, -2035.8271484375, 6.8300895690918, 0, 0, 270);
    CreateDynamicObject(1812, 379.20223999023, -2024.7698974609, 6.8300895690918, 0, 0, 290);
    CreateDynamicObject(1812, 379.95559692383, -2033.7116699219, 6.8300905227661, 0, 0, 270);
    CreateDynamicObject(2985, 383.4287109375, -2061.28125, 18.311645507813, 0, 0, 103.99658203125);
    CreateDynamicObject(3386, 381.04260253906, -2027.3524169922, 6.8359375, 0, 0, 286);
    CreateDynamicObject(3389, 381.48556518555, -2025.7242431641, 6.8359375, 0, 0, 18);
    CreateDynamicObject(960, 363.44708251953, -2027.8238525391, 7.2177276611328, 0, 0, 28);
    CreateDynamicObject(960, 364.29495239258, -2025.4857177734, 7.2177276611328, 0, 0, 332);
    CreateDynamicObject(960, 362.81558227539, -2026.3763427734, 7.2177276611328, 0, 0, 316);
    CreateDynamicObject(3092, 381.23208618164, -2038.1898193359, 7.3643932342529, 85.999969482422, 89.999633789063, 358.00033569336);
    CreateDynamicObject(3092, 381.33459472656, -2035.8295898438, 7.4397001266479, 89.623596191406, 180.00019836426, 272.10778808594);
    CreateDynamicObject(2971, 381.63018798828, -2031.1119384766, 6.8359375, 0, 0, 0);
    CreateDynamicObject(2907, 380.59979248047, -2024.1958007813, 7.2874155044556, 0, 0, 113.12127685547);
    CreateDynamicObject(1218, 362.71606445313, -2022.3321533203, 7.3276300430298, 0, 0, 15.837677001953);
    CreateDynamicObject(1218, 361.33807373047, -2022.5986328125, 7.3217821121216, 0, 0, 15.837677001953);
    CreateDynamicObject(1217, 361.04086303711, -2024.3647460938, 7.2514696121216, 0, 0, 0);

	// Refugio Estacionamiento
    CreateDynamicObject(987,1614.118,-1016.112,22.898,0.0,0.0,-78.750);
    CreateDynamicObject(987,1612.055,-1004.392,23.053,0.0,0.0,-78.750);
    CreateDynamicObject(987,1609.787,-992.782,23.078,0.0,0.0,-78.750);
    CreateDynamicObject(987,1617.042,-1030.655,22.914,0.0,0.0,-45.000);
    CreateDynamicObject(987,1625.476,-1039.036,22.898,0.0,0.0,0.0);
    CreateDynamicObject(987,1628.738,-1039.212,22.898,0.0,0.0,0.0);
    CreateDynamicObject(987,1669.580,-1014.141,22.898,0.0,0.0,101.250);
    CreateDynamicObject(987,1667.271,-1002.437,22.934,0.0,0.0,112.500);
    CreateDynamicObject(987,1672.473,-1028.074,22.898,0.0,0.0,101.250);
    CreateDynamicObject(987,1649.282,-1039.237,22.898,0.0,0.0,0.0);
    CreateDynamicObject(987,1661.291,-1039.174,22.898,0.0,0.0,0.0);
    CreateDynamicObject(3578,1675.259,-1033.308,23.676,0.0,0.0,90.000);
    CreateDynamicObject(852,1636.436,-1032.639,22.862,0.0,0.0,0.0);
    CreateDynamicObject(853,1668.167,-1032.948,23.299,0.0,0.0,0.0);
    CreateDynamicObject(853,1639.568,-1017.556,23.299,0.0,0.0,-33.750);
    CreateDynamicObject(923,1623.724,-1003.616,23.950,0.0,0.0,0.0);
    CreateDynamicObject(923,1620.044,-993.212,23.948,0.0,0.0,-67.500);
    CreateDynamicObject(923,1631.177,-998.589,23.947,0.0,0.0,-22.500);
    CreateDynamicObject(923,1629.431,-998.922,23.947,0.0,0.0,-123.750);
    CreateDynamicObject(923,1658.045,-1004.195,23.936,0.0,0.0,-123.750);
    CreateDynamicObject(939,1651.112,-1006.881,25.504,0.0,0.0,33.750);
    CreateDynamicObject(960,1623.216,-998.542,23.448,0.0,0.0,0.0);
    CreateDynamicObject(960,1622.579,-999.574,23.447,0.0,0.0,-56.250);
    CreateDynamicObject(2675,1615.964,-994.538,23.130,0.0,0.0,0.0);
    CreateDynamicObject(2675,1625.693,-1016.721,22.963,0.0,0.0,33.750);
    CreateDynamicObject(2675,1632.386,-1025.381,22.963,0.0,0.0,-22.500);
    CreateDynamicObject(2675,1656.640,-1036.731,22.963,0.0,0.0,33.750);
    CreateDynamicObject(2675,1636.859,-1002.035,23.133,0.0,0.0,22.500);
    CreateDynamicObject(2676,1665.796,-1028.114,23.002,0.0,0.0,0.0);
    CreateDynamicObject(2676,1662.244,-1016.993,23.002,0.0,0.0,-33.750);
    CreateDynamicObject(2676,1659.099,-1007.002,23.174,0.0,0.0,0.0);
    CreateDynamicObject(2676,1655.104,-1008.108,23.174,0.0,0.0,-22.500);
    CreateDynamicObject(2677,1663.324,-1006.221,23.332,0.0,0.0,0.0);
    CreateDynamicObject(2677,1663.284,-1000.189,23.323,0.0,0.0,-56.250);
    CreateDynamicObject(2677,1653.777,-1021.369,23.170,0.0,0.0,-33.750);
    CreateDynamicObject(2677,1651.933,-1018.678,23.170,0.0,0.0,-90.000);
    CreateDynamicObject(2677,1661.803,-1020.297,23.170,0.0,0.0,-45.000);
    CreateDynamicObject(2674,1645.883,-1034.369,22.920,0.0,0.0,0.0);
    CreateDynamicObject(2674,1633.635,-1033.519,22.920,0.0,0.0,-45.000);
    CreateDynamicObject(2672,1655.093,-1027.417,23.178,0.0,0.0,0.0);
    CreateDynamicObject(2672,1642.911,-1027.383,23.178,0.0,0.0,-45.000);
    CreateDynamicObject(2671,1647.650,-1027.904,22.901,0.0,0.0,0.0);
    CreateDynamicObject(3594,1645.006,-1017.415,23.530,0.0,0.0,-11.250);
    CreateDynamicObject(3594,1636.881,-1012.657,23.530,0.0,0.0,33.750);
    CreateDynamicObject(3593,1617.841,-1009.567,23.309,0.0,0.0,0.0);
    CreateDynamicObject(3593,1623.643,-1011.018,23.309,0.0,0.0,-22.500);
    CreateDynamicObject(3594,1671.144,-1123.165,23.537,0.0,0.0,33.750);
    CreateDynamicObject(3594,1648.501,-1135.817,23.537,0.0,0.0,-67.500);
    CreateDynamicObject(3594,1631.064,-1123.852,23.537,0.0,0.0,11.250);
    CreateDynamicObject(3594,1617.288,-1104.270,23.537,0.0,0.0,-67.500);
    CreateDynamicObject(3594,1614.264,-1085.137,23.537,0.0,0.0,11.250);
    CreateDynamicObject(3594,1605.819,-1060.244,23.545,0.0,0.0,-56.250);
    CreateDynamicObject(3594,1588.114,-1033.913,23.537,0.0,0.0,45.000);
    CreateDynamicObject(3594,1599.813,-1032.252,23.545,0.0,0.0,90.000);
    CreateDynamicObject(3594,1626.633,-1066.659,23.530,0.0,0.0,157.500);
    CreateDynamicObject(3594,1650.026,-1048.534,23.530,0.0,0.0,258.750);
    CreateDynamicObject(3594,1667.078,-1079.841,23.537,0.0,0.0,315.000);
    CreateDynamicObject(3594,1724.134,-1071.042,23.557,0.0,0.0,56.250);
    CreateDynamicObject(3594,1758.188,-1070.802,23.592,0.0,0.0,78.750);
    CreateDynamicObject(3594,1681.700,-1083.990,23.537,0.0,0.0,157.500);
    CreateDynamicObject(3594,1712.790,-1062.161,23.537,0.0,0.0,236.250);
    CreateDynamicObject(3594,1682.816,-1056.900,23.530,0.0,0.0,303.750);
    CreateDynamicObject(3594,1667.243,-1065.266,23.530,0.0,0.0,348.750);
    CreateDynamicObject(3594,1640.179,-1081.444,23.537,0.0,0.0,78.750);
    CreateDynamicObject(3594,1652.268,-1096.349,23.537,0.0,0.0,157.500);
    CreateDynamicObject(3594,1643.962,-1108.380,23.545,0.0,0.0,247.500);
    CreateDynamicObject(3594,1663.750,-1091.823,23.537,0.0,0.0,337.500);
    CreateDynamicObject(3594,1677.069,-1104.848,23.537,0.0,0.0,101.250);
    CreateDynamicObject(3594,1700.472,-1080.731,23.537,0.0,0.0,33.750);
    CreateDynamicObject(3594,1686.227,-1020.112,23.537,0.0,0.0,78.750);
    CreateDynamicObject(3594,1703.925,-1017.402,23.537,0.0,0.0,146.250);
    CreateDynamicObject(3594,1707.597,-1040.082,23.537,0.0,0.0,202.500);
    CreateDynamicObject(3594,1689.119,-1043.478,23.537,0.0,0.0,258.750);
    CreateDynamicObject(3594,1719.343,-1022.761,23.537,0.0,0.0,22.500);
    CreateDynamicObject(3594,1750.978,-1034.552,23.592,0.0,0.0,67.500);
    CreateDynamicObject(3594,1754.201,-1047.549,23.592,0.0,0.0,146.250);
    CreateDynamicObject(3594,1780.867,-1053.027,23.592,0.0,0.0,213.750);
    CreateDynamicObject(3594,1790.439,-1084.525,23.600,0.0,0.0,281.250);
    CreateDynamicObject(3594,1760.264,-1080.986,23.592,0.0,0.0,0.0);
    CreateDynamicObject(3594,1737.738,-1083.247,23.592,0.0,0.0,180.000);
    CreateDynamicObject(3594,1732.186,-1049.717,23.584,0.0,0.0,236.250);
    CreateDynamicObject(3594,1767.542,-1024.945,23.592,0.0,0.0,303.750);
    CreateDynamicObject(3594,1790.534,-1035.374,23.600,0.0,0.0,0.0);
    CreateDynamicObject(3594,1739.450,-1013.208,23.592,0.0,0.0,-135.000);
    CreateDynamicObject(3594,1720.556,-1010.944,23.541,0.0,0.0,-168.749);
    CreateDynamicObject(3594,1691.254,-1000.024,23.709,0.0,0.0,-101.249);
    CreateDynamicObject(3594,1586.272,-1051.926,23.537,0.0,0.0,-134.999);
    CreateDynamicObject(3594,1563.975,-1027.950,23.545,0.0,0.0,-78.749);
    CreateDynamicObject(3594,1542.971,-1023.234,23.537,0.0,0.0,-157.499);
    CreateDynamicObject(3594,1559.828,-1012.055,23.537,0.0,0.0,-78.749);
    CreateDynamicObject(3594,1581.685,-1011.011,23.537,0.0,0.0,-22.500);
    CreateDynamicObject(3594,1599.868,-1008.318,23.537,0.0,0.0,-56.250);
    CreateDynamicObject(3593,1561.845,-1021.513,23.316,0.0,0.0,11.250);
    CreateDynamicObject(12957,1661.592,-1103.620,23.784,0.0,0.0,0.0);
    CreateDynamicObject(12957,1665.013,-1107.509,23.784,0.0,0.0,90.000);
    CreateDynamicObject(12957,1652.654,-1127.272,23.784,0.0,0.0,157.500);
    CreateDynamicObject(12957,1634.852,-1115.404,23.784,0.0,0.0,236.250);
    CreateDynamicObject(12957,1629.579,-1119.021,23.846,0.0,0.0,326.250);
    CreateDynamicObject(12957,1612.506,-1104.141,23.784,0.0,0.0,67.500);
    CreateDynamicObject(12957,1547.134,-1014.477,23.784,0.0,0.0,45.000);
    CreateDynamicObject(12957,1548.216,-1018.888,23.784,0.0,0.0,123.750);
    CreateDynamicObject(12957,1571.692,-1015.431,23.792,0.0,0.0,146.250);
    CreateDynamicObject(12957,1598.060,-1018.260,23.784,0.0,0.0,213.750);
    CreateDynamicObject(12957,1578.588,-1022.384,23.784,0.0,0.0,90.000);
    CreateDynamicObject(12957,1576.329,-1033.871,23.784,0.0,0.0,191.250);
    CreateDynamicObject(12957,1603.942,-1042.799,23.784,0.0,0.0,247.500);
    CreateDynamicObject(12957,1592.385,-1043.134,23.784,0.0,0.0,326.250);
    CreateDynamicObject(12957,1618.197,-1055.505,23.784,0.0,0.0,22.500);
    CreateDynamicObject(12957,1594.356,-1061.532,23.784,0.0,0.0,101.250);
    CreateDynamicObject(12957,1606.740,-1079.578,23.784,0.0,0.0,157.500);
    CreateDynamicObject(12957,1626.364,-1072.654,23.777,0.0,0.0,225.000);
    CreateDynamicObject(12957,1654.186,-1049.436,23.777,0.0,0.0,292.500);
    CreateDynamicObject(12957,1626.381,-1046.535,23.777,0.0,0.0,11.250);
    CreateDynamicObject(12957,1638.073,-1052.250,23.777,0.0,0.0,112.500);
    CreateDynamicObject(12957,1652.356,-1065.859,23.777,0.0,0.0,168.750);
    CreateDynamicObject(12957,1638.991,-1068.549,23.777,0.0,0.0,213.750);
    CreateDynamicObject(12957,1636.433,-1088.618,23.784,0.0,0.0,281.250);
    CreateDynamicObject(12957,1665.309,-1124.575,23.784,0.0,0.0,337.500);
    CreateDynamicObject(12957,1681.198,-1114.039,23.784,0.0,0.0,11.250);
    CreateDynamicObject(12957,1688.690,-1103.301,24.097,0.0,0.0,-11.250);
    CreateDynamicObject(12957,1660.426,-1070.162,23.777,0.0,0.0,56.250);
    CreateDynamicObject(12957,1667.264,-1049.522,23.777,0.0,0.0,-22.500);
    CreateDynamicObject(12957,1678.448,-1072.186,23.777,0.0,0.0,146.250);
    CreateDynamicObject(12957,1675.237,-1062.542,23.777,0.0,0.0,236.250);
    CreateDynamicObject(12957,1689.039,-1032.496,23.784,0.0,0.0,303.750);
    CreateDynamicObject(12957,1702.313,-1049.369,23.784,0.0,0.0,33.750);
    CreateDynamicObject(12957,1676.390,-1011.850,23.777,0.0,0.0,101.250);
    CreateDynamicObject(12957,1681.108,-1029.897,23.784,0.0,0.0,191.250);
    CreateDynamicObject(12957,1691.123,-1016.628,23.784,0.0,0.0,281.250);
    CreateDynamicObject(12957,1710.194,-1007.473,23.792,0.0,0.0,337.500);
    CreateDynamicObject(12957,1701.870,-1026.728,23.792,0.0,0.0,56.250);
    CreateDynamicObject(12957,1717.842,-1027.424,23.792,0.0,0.0,157.500);
    CreateDynamicObject(12957,1751.705,-1010.776,23.839,0.0,0.0,236.251);
    CreateDynamicObject(12957,1734.185,-1020.735,23.819,0.0,0.0,281.250);
    CreateDynamicObject(12957,1736.669,-1040.755,23.847,0.0,0.0,337.500);
    CreateDynamicObject(12957,1748.953,-1055.498,23.839,0.0,0.0,11.251);
    CreateDynamicObject(12957,1717.667,-1054.637,23.784,0.0,0.0,135.001);
    CreateDynamicObject(12957,1707.786,-1069.582,23.784,0.0,0.0,213.751);
    CreateDynamicObject(12957,1686.640,-1054.620,23.792,0.0,0.0,11.251);
    CreateDynamicObject(12957,1698.914,-1084.414,23.784,0.0,0.0,123.751);
    CreateDynamicObject(12957,1800.841,-1076.929,23.847,0.0,0.0,202.501);
    CreateDynamicObject(12957,1800.678,-1055.172,23.839,0.0,0.0,292.501);
    CreateDynamicObject(12957,1791.349,-1062.517,23.839,0.0,0.0,22.501);
    CreateDynamicObject(12957,1792.993,-1039.480,23.847,0.0,0.0,78.751);
    CreateDynamicObject(12957,1768.187,-1029.327,23.839,0.0,0.0,78.751);
    CreateDynamicObject(12957,1779.737,-1044.103,23.848,0.0,0.0,258.751);
    CreateDynamicObject(12957,1770.373,-1083.424,23.839,0.0,0.0,326.251);
    CreateDynamicObject(12957,1788.053,-1077.295,23.839,0.0,0.0,67.501);
    CreateDynamicObject(12957,1740.723,-1078.205,23.839,0.0,0.0,168.751);
    CreateDynamicObject(12957,1767.944,-1068.769,23.839,0.0,0.0,258.751);
    CreateDynamicObject(12957,1775.827,-1059.413,23.839,0.0,0.0,281.251);
    CreateDynamicObject(3593,1728.256,-1083.616,23.368,0.0,0.0,56.250);
    CreateDynamicObject(3593,1753.623,-1082.537,23.271,0.0,0.0,101.250);
    CreateDynamicObject(3593,1781.906,-1075.749,23.346,0.0,0.0,180.000);
    CreateDynamicObject(3593,1794.587,-1068.455,23.371,0.0,0.0,247.500);
    CreateDynamicObject(3593,1795.253,-1042.664,23.354,0.0,0.0,292.500);
    CreateDynamicObject(3593,1754.541,-1024.986,23.271,0.0,0.0,292.500);
    CreateDynamicObject(3593,1728.047,-1022.119,23.235,0.0,0.0,337.500);
    CreateDynamicObject(3593,1722.101,-1040.281,23.317,0.0,0.0,33.750);
    CreateDynamicObject(3593,1721.196,-1046.246,23.329,0.0,0.0,90.000);
    CreateDynamicObject(3593,1694.083,-1064.453,23.291,0.0,0.0,112.500);
    CreateDynamicObject(3593,1693.074,-1055.758,23.299,0.0,0.0,202.500);
    CreateDynamicObject(3593,1690.774,-1076.591,23.291,0.0,0.0,33.750);
    CreateDynamicObject(3593,1696.998,-1095.871,23.488,0.0,0.0,78.750);
    CreateDynamicObject(3593,1675.999,-1113.075,23.291,0.0,0.0,45.000);
    CreateDynamicObject(3593,1680.359,-1130.341,23.266,0.0,0.0,101.250);
    CreateDynamicObject(3593,1658.631,-1137.207,23.316,0.0,0.0,146.250);
    CreateDynamicObject(3593,1647.327,-1131.216,23.316,0.0,0.0,-11.250);
    CreateDynamicObject(3593,1645.126,-1116.198,23.316,0.0,0.0,-78.750);
    CreateDynamicObject(3593,1621.798,-1111.872,23.341,0.0,0.0,-123.750);
    CreateDynamicObject(3593,1650.083,-1094.066,23.366,0.0,0.0,-90.000);
    CreateDynamicObject(3593,1628.010,-1102.013,23.366,0.0,0.0,-45.000);
    CreateDynamicObject(3593,1616.775,-1091.976,23.374,0.0,0.0,-101.250);
    CreateDynamicObject(3593,1645.302,-1063.027,23.259,0.0,0.0,-78.750);
    CreateDynamicObject(3593,1652.937,-1070.964,23.266,0.0,0.0,-123.750);
    CreateDynamicObject(3593,1658.850,-1056.705,23.309,0.0,0.0,-135.000);
    CreateDynamicObject(3593,1614.057,-1044.677,23.284,0.0,0.0,-90.000);
    CreateDynamicObject(3593,1610.133,-1063.806,23.341,0.0,0.0,-146.250);
    CreateDynamicObject(3593,1618.990,-1075.688,23.209,0.0,0.0,-90.000);
    CreateDynamicObject(3593,1605.570,-1070.190,23.291,0.0,0.0,-191.250);
    CreateDynamicObject(3593,1599.559,-1043.172,23.374,0.0,0.0,-146.250);
    CreateDynamicObject(3593,1619.755,-1060.594,23.316,0.0,0.0,-213.750);
    CreateDynamicObject(3593,1605.985,-1023.694,23.316,0.0,0.0,-168.750);
    CreateDynamicObject(3593,1588.094,-1010.670,23.291,0.0,0.0,-101.250);
    CreateDynamicObject(3593,1585.293,-1028.283,23.316,0.0,0.0,-180.000);
    CreateDynamicObject(3593,1572.854,-1024.395,23.316,0.0,0.0,-123.750);
    CreateDynamicObject(3593,1579.956,-1041.896,23.316,0.0,0.0,-191.250);
    CreateDynamicObject(3279,1622.912,-1027.838,22.749,0.0,0.0,123.750);
    CreateDynamicObject(3279,1640.842,-1044.260,22.799,0.0,0.0,90.000);
    CreateDynamicObject(987,1646.561,-1039.296,22.898,0.0,0.0,0.0);
    CreateDynamicObject(3387,1646.127,-1037.924,22.898,0.0,0.0,45.000);
    CreateDynamicObject(3387,1643.671,-1036.842,22.898,0.0,0.0,-11.250);
    CreateDynamicObject(3386,1642.352,-1040.540,22.898,0.0,0.0,45.000);
    CreateDynamicObject(2905,1658.478,-1028.060,22.990,0.0,0.0,33.750);
    CreateDynamicObject(2905,1628.991,-1019.007,22.990,0.0,0.0,67.500);
    CreateDynamicObject(2905,1622.862,-1018.527,22.990,0.0,0.0,-22.500);
    CreateDynamicObject(2905,1642.812,-1031.833,22.990,0.0,0.0,33.750);
    CreateDynamicObject(2905,1636.582,-1034.423,22.990,0.0,0.0,112.500);
    CreateDynamicObject(2905,1633.664,-1034.223,22.990,0.0,0.0,213.750);
    CreateDynamicObject(2905,1650.612,-1019.813,22.990,0.0,0.0,270.000);
    CreateDynamicObject(2905,1649.018,-1014.711,22.990,0.0,0.0,202.500);
    CreateDynamicObject(2905,1630.164,-1002.383,23.156,0.0,0.0,101.250);
    CreateDynamicObject(2905,1620.978,-992.553,23.160,0.0,0.0,168.750);
    CreateDynamicObject(2906,1628.712,-1010.067,22.972,0.0,0.0,33.750);
    CreateDynamicObject(2906,1619.051,-1014.672,22.972,0.0,0.0,-33.750);
    CreateDynamicObject(2906,1618.843,-1024.359,22.972,0.0,0.0,45.000);
    CreateDynamicObject(2906,1623.254,-1019.589,22.972,0.0,0.0,22.500);
    CreateDynamicObject(2906,1619.007,-1019.514,22.972,0.0,0.0,-101.250);
    CreateDynamicObject(2906,1646.547,-1033.326,22.972,0.0,0.0,-22.500);
    CreateDynamicObject(2906,1663.285,-1025.053,22.972,0.0,0.0,-45.000);
    CreateDynamicObject(2906,1657.215,-1013.203,22.972,0.0,0.0,33.750);
    CreateDynamicObject(2906,1659.887,-1014.172,22.972,0.0,0.0,-33.750);
    CreateDynamicObject(2908,1661.080,-1027.642,22.976,0.0,0.0,33.750);
    CreateDynamicObject(2908,1657.681,-1024.527,22.976,0.0,0.0,-45.000);
    CreateDynamicObject(2908,1650.548,-1027.855,22.976,0.0,0.0,-33.750);
    CreateDynamicObject(2908,1649.663,-1031.099,22.976,0.0,0.0,135.000);
    CreateDynamicObject(2908,1642.208,-1029.668,22.976,0.0,0.0,191.250);
    CreateDynamicObject(2908,1639.050,-1030.925,22.976,0.0,0.0,112.500);
    CreateDynamicObject(2907,1668.480,-1025.489,23.058,0.0,0.0,0.0);
    CreateDynamicObject(2907,1656.273,-1014.379,23.058,0.0,0.0,-67.500);
    CreateDynamicObject(2907,1652.791,-1015.034,23.058,0.0,0.0,22.500);
    CreateDynamicObject(2907,1631.124,-1020.037,23.058,0.0,0.0,-45.000);
    CreateDynamicObject(2907,1634.616,-1025.578,23.058,0.0,0.0,22.500);
    CreateDynamicObject(2907,1625.142,-1020.222,23.058,0.0,0.0,-90.000);
    CreateDynamicObject(2907,1627.397,-1010.343,23.058,0.0,0.0,-157.500);
    CreateDynamicObject(2907,1626.556,-999.171,23.226,0.0,0.0,-123.750);
    CreateDynamicObject(2907,1624.505,-993.005,23.230,0.0,0.0,-191.250);
    CreateDynamicObject(2907,1629.958,-991.903,23.232,0.0,0.0,-157.500);
    CreateDynamicObject(2907,1634.215,-999.691,23.230,0.0,0.0,-213.750);
    CreateDynamicObject(2907,1614.809,-1000.325,23.238,0.0,0.0,-281.250);
    CreateDynamicObject(2907,1651.661,-1029.484,23.058,0.0,0.0,-292.500);
    CreateDynamicObject(987,1819.618,-1116.776,23.078,0.0,0.0,0.0);
    CreateDynamicObject(987,1807.652,-1116.813,23.097,0.0,0.0,0.0);
    CreateDynamicObject(987,1773.511,-1125.108,23.086,0.0,0.0,0.0);
    CreateDynamicObject(987,1785.393,-1124.912,23.086,0.0,0.0,0.0);
    CreateDynamicObject(987,1720.149,-1126.945,23.086,0.0,0.0,0.0);
    CreateDynamicObject(987,1732.155,-1126.871,23.086,0.0,0.0,0.0);

// Hospital Jeferson por GROVE4L
    CreateDynamicObject(3594,2067.044,-1375.515,23.434,0.0,0.0,45.000);
    CreateDynamicObject(3594,2087.577,-1335.376,23.616,0.0,0.0,-45.000);
    CreateDynamicObject(3594,2066.857,-1316.545,23.451,0.0,0.0,-315.000);
    CreateDynamicObject(3594,2080.081,-1315.090,23.616,0.0,0.0,-528.750);
    CreateDynamicObject(3594,2033.680,-1344.667,23.451,0.0,0.0,-506.250);
    CreateDynamicObject(3594,2011.444,-1339.144,23.451,0.0,0.0,-258.750);
    CreateDynamicObject(3594,1984.132,-1356.209,23.420,0.0,0.0,-405.000);
    CreateDynamicObject(3594,1989.210,-1442.884,13.032,0.0,0.0,-326.250);
    CreateDynamicObject(3594,1984.865,-1406.180,18.992,6.875,-10.313,-326.250);
    CreateDynamicObject(3594,1993.117,-1424.057,15.884,6.875,-10.313,-326.250);
    CreateDynamicObject(3594,1950.898,-1337.968,20.569,6.016,-10.313,-405.000);
    CreateDynamicObject(3594,1924.483,-1344.886,16.071,6.016,-10.313,-405.000);
    CreateDynamicObject(3594,1913.446,-1334.421,13.982,9.454,5.157,-483.750);
    CreateDynamicObject(3594,1872.130,-1337.942,13.014,0.0,0.0,45.000);
    CreateDynamicObject(3594,2000.079,-1459.714,13.022,0.0,0.0,-45.000);
    CreateDynamicObject(3594,1948.482,-1458.595,13.014,0.0,0.0,-123.750);
    CreateDynamicObject(3594,1902.167,-1472.246,13.178,0.0,0.0,-56.250);
    CreateDynamicObject(3594,1853.939,-1471.719,13.026,0.0,0.0,33.750);
    CreateDynamicObject(3594,1847.634,-1438.703,13.030,0.0,0.0,-135.000);
    CreateDynamicObject(3594,1846.708,-1410.590,13.022,0.0,0.0,-90.000);
    CreateDynamicObject(3594,1869.078,-1375.598,13.147,0.0,0.0,-596.250);
    CreateDynamicObject(3594,1857.898,-1365.480,13.192,0.0,0.0,-596.250);
    CreateDynamicObject(3594,1846.830,-1334.510,13.026,0.0,0.0,-483.750);
    CreateDynamicObject(3594,1848.888,-1383.616,13.022,0.0,0.0,-607.500);
    CreateDynamicObject(3594,1894.248,-1350.963,13.170,0.0,0.0,-618.750);
    CreateDynamicObject(3594,2092.166,-1455.993,23.413,0.0,0.0,-596.250);
    CreateDynamicObject(3594,2049.402,-1461.114,18.093,-8.594,0.0,-630.000);
    CreateDynamicObject(3594,2063.793,-1467.611,21.044,-11.173,1.719,-596.250);
    CreateDynamicObject(3593,1975.357,-1468.368,12.757,0.0,0.0,-56.250);
    CreateDynamicObject(3593,1936.556,-1464.391,12.768,0.0,0.0,-236.250);
    CreateDynamicObject(3593,1869.165,-1459.743,12.818,0.0,0.0,-90.000);
    CreateDynamicObject(3593,1834.142,-1460.317,12.707,0.0,0.0,-146.250);
    CreateDynamicObject(3593,1834.918,-1398.561,12.840,0.0,0.0,-180.000);
    CreateDynamicObject(3593,1849.123,-1359.418,12.734,0.0,0.0,-146.250);
    CreateDynamicObject(3593,1890.465,-1337.883,12.768,0.0,0.0,-146.250);
    CreateDynamicObject(3593,1967.090,-1341.401,23.255,0.0,0.0,-180.000);
    CreateDynamicObject(3593,1953.498,-1346.611,21.168,-9.454,2.578,-236.250);
    CreateDynamicObject(3593,2048.906,-1333.640,23.095,0.0,179.622,-56.250);
    CreateDynamicObject(3593,2084.204,-1365.675,23.345,0.0,179.622,-180.000);
    CreateDynamicObject(3593,1992.924,-1394.282,20.967,-9.454,178.763,-202.500);
    CreateDynamicObject(3593,2030.050,-1464.083,14.778,0.0,159.855,0.0);
    CreateDynamicObject(3593,1921.317,-1474.804,13.257,0.0,159.855,-90.000);
    CreateDynamicObject(3593,1914.718,-1455.775,12.832,0.0,0.0,-112.500);
    CreateDynamicObject(3593,1847.792,-1444.717,12.762,0.0,0.0,-191.250);
    CreateDynamicObject(12957,1845.055,-1485.475,13.245,0.0,0.0,-33.750);
    CreateDynamicObject(12957,1844.393,-1507.868,13.249,0.0,0.0,33.750);
    CreateDynamicObject(12957,1892.653,-1459.616,13.261,0.0,0.0,-11.250);
    CreateDynamicObject(12957,2000.190,-1445.212,13.441,0.0,0.0,-101.250);
    CreateDynamicObject(12957,1980.326,-1431.021,14.825,-12.892,2.578,-157.500);
    CreateDynamicObject(12957,1940.176,-1340.588,18.705,-12.892,2.578,-247.500);
    CreateDynamicObject(12957,1866.326,-1347.512,13.438,0.0,0.0,-33.750);
    CreateDynamicObject(12957,1823.961,-1335.991,14.300,0.0,0.0,-90.000);
    CreateDynamicObject(12957,1844.027,-1372.412,13.269,0.0,0.0,-157.500);
    CreateDynamicObject(12957,1858.758,-1399.829,13.441,0.0,0.0,-225.000);
    CreateDynamicObject(12957,1858.173,-1437.006,13.441,0.0,0.0,-348.750);
    CreateDynamicObject(12957,1865.560,-1468.184,13.261,0.0,0.0,-281.250);
    CreateDynamicObject(12957,1922.193,-1462.267,13.261,0.0,0.0,-393.750);
    CreateDynamicObject(12957,2008.830,-1466.887,13.269,0.0,0.0,-303.750);
    CreateDynamicObject(12957,2063.804,-1456.004,21.318,-5.157,-14.610,-326.250);
    CreateDynamicObject(12957,2099.196,-1468.099,23.706,0.0,0.0,-101.250);
    CreateDynamicObject(12957,2082.834,-1473.588,23.752,0.0,0.0,-202.500);
    CreateDynamicObject(985,1806.874,-1351.954,15.854,0.0,0.0,-90.000);
    CreateDynamicObject(986,1806.895,-1343.991,15.873,0.0,0.0,-90.000);
    CreateDynamicObject(987,1732.745,-1343.163,18.066,0.0,0.0,-90.000);
    CreateDynamicObject(987,1732.496,-1355.148,19.461,0.0,0.0,-45.000);
    CreateDynamicObject(986,1725.120,-1386.393,14.258,0.0,0.0,90.000);
    CreateDynamicObject(985,1725.079,-1378.422,14.292,0.0,0.0,-270.000);
    CreateDynamicObject(985,1778.727,-1416.318,16.475,0.0,0.0,-180.000);
    CreateDynamicObject(986,1786.609,-1416.271,16.468,0.0,0.0,180.000);
    CreateDynamicObject(987,1732.726,-1335.870,18.266,0.0,0.0,-90.000);
    CreateDynamicObject(981,1716.126,-1280.241,13.184,0.0,0.0,45.000);
    CreateDynamicObject(1411,1724.534,-1328.308,14.156,0.0,0.0,90.000);
    CreateDynamicObject(1411,1727.321,-1325.566,14.195,0.0,0.0,0.0);
    CreateDynamicObject(1411,1732.459,-1325.585,14.195,0.0,0.0,0.0);
    CreateDynamicObject(1237,1724.766,-1325.803,12.550,0.0,0.0,0.0);
    CreateDynamicObject(1237,1735.093,-1325.798,12.589,0.0,0.0,0.0);
    CreateDynamicObject(1237,1739.033,-1325.768,12.589,0.0,0.0,90.000);
    CreateDynamicObject(850,1791.449,-1348.665,14.810,0.0,0.0,33.750);
    CreateDynamicObject(850,1766.021,-1345.912,14.869,0.0,0.0,-22.500);
    CreateDynamicObject(849,1778.561,-1348.492,15.052,0.0,0.0,-67.500);
    CreateDynamicObject(911,1780.839,-1360.330,15.324,0.0,0.0,-45.000);
    CreateDynamicObject(911,1797.461,-1345.414,15.073,0.0,0.0,-112.500);
    CreateDynamicObject(910,1797.828,-1350.146,15.766,0.0,0.0,-56.250);
    CreateDynamicObject(853,1797.276,-1348.157,14.917,0.0,0.0,0.0);
    CreateDynamicObject(922,1786.932,-1411.123,15.643,0.0,0.0,0.0);
    CreateDynamicObject(922,1780.273,-1411.108,15.650,0.0,0.0,0.0);
    CreateDynamicObject(922,1783.975,-1407.001,15.643,0.0,0.0,0.0);
    CreateDynamicObject(923,1784.157,-1364.263,15.637,0.0,0.0,33.750);
    CreateDynamicObject(923,1777.082,-1368.825,15.637,0.0,0.0,-78.750);
    CreateDynamicObject(922,1735.671,-1347.802,15.656,0.0,0.0,0.0);
    CreateDynamicObject(923,1733.927,-1349.418,15.651,0.0,0.0,90.000);
    CreateDynamicObject(942,1768.736,-1367.709,17.201,0.0,0.0,0.0);
    CreateDynamicObject(939,1772.116,-1344.718,17.200,0.0,0.0,0.0);
    CreateDynamicObject(912,1766.260,-1357.722,15.330,0.0,0.0,56.250);
    CreateDynamicObject(912,1766.694,-1361.008,15.324,0.0,0.0,123.750);
    CreateDynamicObject(1227,1798.264,-1352.626,15.308,0.0,0.0,67.500);
    CreateDynamicObject(1224,1797.723,-1343.467,15.110,0.0,0.0,-45.000);
    CreateDynamicObject(1224,1784.854,-1400.532,15.373,0.0,0.0,-45.000);
    CreateDynamicObject(1224,1777.958,-1387.732,15.373,0.0,0.0,-90.000);
    CreateDynamicObject(1236,1780.928,-1400.451,15.421,0.0,0.0,33.750);
    CreateDynamicObject(1327,1779.197,-1393.156,15.726,0.0,0.0,0.0);
    CreateDynamicObject(1334,1766.972,-1381.577,15.871,0.0,0.0,-33.750);
    CreateDynamicObject(1334,1766.582,-1390.266,15.871,0.0,0.0,-180.000);
    CreateDynamicObject(1331,1765.989,-1385.068,15.680,0.0,0.0,33.750);
    CreateDynamicObject(1335,1766.729,-1394.381,15.883,0.0,0.0,-78.750);
    CreateDynamicObject(987,1733.411,-1390.911,14.765,0.0,0.0,-56.250);
    CreateDynamicObject(955,1773.263,-1367.630,15.161,-18.048,0.859,90.000);
    CreateDynamicObject(918,1781.499,-1354.583,15.131,0.0,0.0,-56.250);
    CreateDynamicObject(918,1781.926,-1355.130,15.133,0.0,0.0,-123.750);
    CreateDynamicObject(918,1781.000,-1354.585,15.131,0.0,0.0,-45.000);
    CreateDynamicObject(1244,1787.561,-1372.658,15.557,15.470,0.0,-11.250);
    CreateDynamicObject(1244,1787.011,-1371.199,15.057,15.470,-83.365,-67.500);
    CreateDynamicObject(3525,1732.380,-1329.113,11.755,0.0,0.0,0.0);
    CreateDynamicObject(3525,1728.461,-1327.413,11.805,0.0,0.0,-22.500);
    CreateDynamicObject(3525,1738.250,-1333.689,11.693,0.0,0.0,-67.500);
    CreateDynamicObject(3525,1733.835,-1337.130,11.684,0.0,0.0,-123.750);
    CreateDynamicObject(3525,1734.102,-1351.034,13.966,0.0,0.0,-123.750);
    CreateDynamicObject(3525,1799.107,-1351.190,13.658,0.0,0.0,-123.750);
    CreateDynamicObject(3525,1798.264,-1349.643,13.454,0.0,0.0,-146.250);
    CreateDynamicObject(3525,1798.657,-1344.447,13.686,0.0,0.0,-168.750);
    CreateDynamicObject(3525,1777.524,-1413.322,13.959,0.0,0.0,-168.750);
    CreateDynamicObject(3525,1781.303,-1412.518,13.959,0.0,0.0,-168.750);
    CreateDynamicObject(3525,1781.690,-1409.049,14.009,0.0,0.0,-168.750);
    CreateDynamicObject(3525,1788.174,-1403.472,13.727,0.0,0.0,-168.750);
    CreateDynamicObject(3525,1785.150,-1402.315,13.977,0.0,0.0,-202.500);
    CreateDynamicObject(3525,1739.082,-1347.515,14.005,0.0,0.0,-202.500);
    CreateDynamicObject(3525,1765.527,-1382.616,14.002,0.0,0.0,-202.500);
    CreateDynamicObject(3525,1768.290,-1385.218,14.002,0.0,0.0,-202.500);
    CreateDynamicObject(3525,1766.052,-1393.076,13.977,-8.594,0.0,-90.000);
    CreateDynamicObject(3525,1769.431,-1363.334,13.977,-8.594,0.0,-90.000);
    CreateDynamicObject(3525,1770.972,-1365.386,13.477,-8.594,0.0,-146.250);
    CreateDynamicObject(3525,1781.504,-1372.640,14.002,-8.594,0.0,-90.000);
    CreateDynamicObject(3864,1727.805,-1329.937,18.458,0.0,0.0,-123.750);
    CreateDynamicObject(1215,1782.060,-1363.020,15.322,0.0,0.0,0.0);
    CreateDynamicObject(1215,1777.556,-1367.600,15.322,0.0,0.0,-22.500);
    CreateDynamicObject(1215,1768.100,-1359.739,15.322,0.0,0.0,-22.500);
    CreateDynamicObject(1308,1815.716,-1352.048,14.425,0.0,57.582,101.250);
    CreateDynamicObject(1315,1735.288,-1303.325,13.022,-0.859,-41.253,56.250);
    CreateDynamicObject(3447,1708.846,-1323.752,14.320,-66.177,26.643,123.750);
    CreateDynamicObject(1383,1856.191,-1316.389,31.178,0.0,33.518,-11.250);
    CreateDynamicObject(1384,1891.239,-1329.641,43.055,-42.972,0.0,-168.750);
    CreateDynamicObject(5126,1879.842,-1316.037,63.538,0.0,0.0,225.000);
    CreateDynamicObject(925,1779.465,-1344.147,15.815,0.0,0.0,0.0);
    CreateDynamicObject(944,1777.006,-1402.109,15.650,0.0,0.0,0.0);
    CreateDynamicObject(2669,1862.654,-1333.383,65.816,0.0,0.0,315.000);
    CreateDynamicObject(2678,1860.107,-1334.538,65.691,0.0,0.0,-45.000);
    CreateDynamicObject(2679,1861.517,-1335.972,65.683,0.0,0.0,-45.000);
    CreateDynamicObject(3569,1833.609,-1474.116,14.156,0.0,87.663,56.250);
    CreateDynamicObject(3570,1858.974,-1308.673,13.898,0.0,0.0,-33.750);
    CreateDynamicObject(3570,1851.480,-1322.646,13.742,0.0,0.0,-101.250);
    CreateDynamicObject(3577,1834.265,-1308.755,13.377,0.0,0.0,-56.250);
    CreateDynamicObject(3577,1837.711,-1320.052,13.335,0.0,0.0,45.000);
    CreateDynamicObject(3796,1777.782,-1382.427,14.763,0.0,0.0,-90.000);
    CreateDynamicObject(2905,1766.973,-1348.974,14.853,0.0,0.0,-67.500);
    CreateDynamicObject(2905,1768.207,-1364.189,14.849,0.0,0.0,0.0);
    CreateDynamicObject(2905,1780.263,-1366.232,14.849,0.0,0.0,-56.250);
    CreateDynamicObject(2905,1788.726,-1349.705,14.846,0.0,0.0,11.250);
    CreateDynamicObject(2906,1775.250,-1344.751,14.832,0.0,0.0,-11.250);
    CreateDynamicObject(2906,1765.668,-1351.174,14.834,0.0,0.0,-11.250);
    CreateDynamicObject(2906,1765.950,-1349.312,14.835,0.0,0.0,-78.750);
    CreateDynamicObject(2906,1776.751,-1362.185,14.832,0.0,0.0,-11.250);
    CreateDynamicObject(2908,1774.259,-1366.746,14.835,0.0,0.0,-33.750);
    CreateDynamicObject(2908,1774.712,-1365.884,14.835,0.0,0.0,-78.750);
    CreateDynamicObject(2908,1765.893,-1362.754,14.835,0.0,0.0,-22.500);
    CreateDynamicObject(2908,1735.625,-1342.324,14.846,0.0,0.0,11.250);
    CreateDynamicObject(2908,1734.900,-1344.244,14.847,0.0,0.0,-56.250);
    CreateDynamicObject(2908,1747.593,-1351.518,14.833,0.0,0.0,-11.250);
    CreateDynamicObject(2907,1740.309,-1344.860,14.920,0.0,0.0,45.000);
    CreateDynamicObject(2907,1783.630,-1344.274,14.897,0.0,0.0,0.0);
    CreateDynamicObject(2907,1787.786,-1344.270,14.900,0.0,0.0,90.000);
    CreateDynamicObject(2907,1777.442,-1352.789,14.917,0.0,0.0,56.250);
    CreateDynamicObject(2907,1774.678,-1349.760,14.915,0.0,0.0,112.500);
    CreateDynamicObject(2907,1771.586,-1354.813,14.920,0.0,0.0,56.250);
    CreateDynamicObject(2906,1775.240,-1356.108,14.834,0.0,0.0,67.500);
    CreateDynamicObject(2908,1778.351,-1356.364,14.838,0.0,0.0,0.0);
    CreateDynamicObject(2908,1782.342,-1355.306,14.835,0.0,0.0,-45.000);

    // Calle Estacionamiento
    CreateDynamicObject(13591,1802.149,-1179.291,22.930,0.0,0.0,-67.500);
    CreateDynamicObject(12957,1785.408,-1185.996,23.768,0.0,0.0,-33.750);
    CreateDynamicObject(12957,1835.519,-1175.720,23.515,0.0,0.0,-33.750);
    CreateDynamicObject(12957,1851.849,-1184.606,23.528,0.0,0.0,-101.250);
    CreateDynamicObject(12957,1851.050,-1174.513,23.706,0.0,0.0,-11.250);
    CreateDynamicObject(12957,1815.225,-1186.232,23.706,0.0,0.0,45.000);
    CreateDynamicObject(12957,1800.543,-1168.039,23.706,0.0,0.0,101.250);
    CreateDynamicObject(12957,1775.599,-1169.341,23.537,0.0,0.0,22.500);
    CreateDynamicObject(12957,1759.660,-1162.536,23.525,0.0,0.0,101.250);
    CreateDynamicObject(12957,1722.056,-1173.375,23.706,0.0,0.0,45.000);
    CreateDynamicObject(12957,1697.733,-1160.032,23.534,0.0,0.0,123.750);
    CreateDynamicObject(12957,1671.479,-1162.955,23.534,0.0,0.0,123.750);
    CreateDynamicObject(12957,1635.867,-1161.004,23.774,0.0,0.0,45.000);
    CreateDynamicObject(12957,1656.619,-1158.797,23.654,0.0,0.0,56.250);
    CreateDynamicObject(12957,1604.749,-1159.942,23.784,0.0,0.0,168.750);
    CreateDynamicObject(12957,1576.692,-1163.915,23.784,0.0,0.0,112.500);
    CreateDynamicObject(12957,1547.972,-1160.706,23.784,0.0,0.0,180.000);
    CreateDynamicObject(12957,1504.001,-1161.922,23.792,0.0,0.0,112.500);
    CreateDynamicObject(12957,1579.627,-1139.211,23.520,0.0,0.0,168.750);
    CreateDynamicObject(12957,1571.981,-1116.794,23.301,0.0,0.0,135.000);
    CreateDynamicObject(12957,1556.048,-1065.942,23.447,0.0,0.0,202.500);
    CreateDynamicObject(12957,1522.866,-1177.954,23.922,0.0,0.0,247.500);
    CreateDynamicObject(12957,1505.079,-1190.147,23.714,0.0,0.0,168.750);
    CreateDynamicObject(12957,1472.998,-1163.051,23.784,0.0,0.0,191.250);
    CreateDynamicObject(12957,1482.770,-1150.246,23.784,0.0,0.0,247.500);
    CreateDynamicObject(12957,1478.387,-1128.035,23.772,0.0,0.0,236.250);
    CreateDynamicObject(12957,1485.356,-1101.043,23.534,0.0,0.0,157.500);
    CreateDynamicObject(12957,1478.708,-1070.024,23.534,0.0,0.0,236.250);
    CreateDynamicObject(12957,1480.630,-1036.971,23.542,0.0,0.0,168.750);
    CreateDynamicObject(12957,1503.530,-1033.398,23.503,0.0,0.0,202.500);
    CreateDynamicObject(12957,1523.185,-1041.612,23.507,0.0,0.0,202.500);
    CreateDynamicObject(12957,1527.324,-1043.389,23.516,0.0,0.0,101.250);
    CreateDynamicObject(3594,1517.888,-1030.067,23.425,0.0,0.0,-78.750);
    CreateDynamicObject(3594,1493.238,-1028.007,23.289,0.0,0.0,-11.250);
    CreateDynamicObject(3594,1485.161,-1042.296,23.287,0.0,0.0,-90.000);
    CreateDynamicObject(3594,1489.999,-1064.845,23.460,0.0,0.0,-22.500);
    CreateDynamicObject(3594,1478.200,-1113.803,23.347,0.0,0.0,-67.500);
    CreateDynamicObject(3594,1484.535,-1160.494,23.530,0.0,0.0,-67.500);
    CreateDynamicObject(3594,1492.276,-1161.293,23.545,0.0,0.0,22.500);
    CreateDynamicObject(3594,1507.797,-1156.980,23.537,0.0,0.0,-33.750);
    CreateDynamicObject(3594,1519.780,-1171.576,23.709,0.0,0.0,-11.250);
    CreateDynamicObject(3594,1497.794,-1172.667,23.709,0.0,0.0,-45.000);
    CreateDynamicObject(3594,1534.947,-1162.108,23.537,0.0,0.0,-78.750);
    CreateDynamicObject(3594,1567.612,-1155.181,23.537,0.0,0.0,-45.000);
    CreateDynamicObject(3594,1571.550,-1144.685,23.580,0.0,0.0,-56.250);
    CreateDynamicObject(3594,1594.922,-1151.630,23.709,0.0,0.0,0.0);
    CreateDynamicObject(3594,1644.176,-1154.645,23.537,0.0,0.0,-56.250);
    CreateDynamicObject(3594,1618.488,-1160.843,23.529,0.0,0.0,33.750);
    CreateDynamicObject(3594,1578.915,-1158.065,23.545,0.0,0.0,56.250);
    CreateDynamicObject(3594,1656.559,-1168.885,23.709,0.0,0.0,-180.000);
    CreateDynamicObject(3594,1674.462,-1150.206,23.550,0.0,0.0,-225.000);
    CreateDynamicObject(3594,1685.602,-1159.626,23.287,0.0,0.0,-247.500);
    CreateDynamicObject(3594,1732.234,-1159.084,23.270,0.0,0.0,-236.250);
    CreateDynamicObject(3594,1743.959,-1166.346,23.459,0.0,0.0,-303.750);
    CreateDynamicObject(3594,1757.281,-1175.891,23.457,0.0,0.0,-236.250);
    CreateDynamicObject(3594,1789.187,-1181.429,23.525,0.0,0.0,-247.500);
    CreateDynamicObject(3594,1722.500,-1182.959,23.459,0.0,0.0,-213.750);
    CreateDynamicObject(3594,1709.810,-1176.649,23.289,0.0,0.0,-303.750);
    CreateDynamicObject(3594,1715.284,-1157.830,23.283,0.0,0.0,-236.250);
    CreateDynamicObject(3594,1854.271,-1179.751,23.273,0.0,0.0,-180.000);
    CreateDynamicObject(3594,1834.873,-1189.297,23.459,0.0,0.0,-236.250);
    CreateDynamicObject(3594,1824.911,-1182.229,23.260,0.0,0.0,-168.750);
    CreateDynamicObject(3594,1842.856,-1179.492,23.276,0.0,0.0,-225.000);
    CreateDynamicObject(3593,1809.117,-1178.922,22.948,0.0,0.0,-146.250);
    CreateDynamicObject(3593,1778.435,-1162.179,23.213,0.0,0.0,-123.750);
    CreateDynamicObject(3593,1704.714,-1168.926,23.238,0.0,0.0,-168.750);
    CreateDynamicObject(3593,1721.761,-1147.384,23.317,0.0,0.0,-67.500);
    CreateDynamicObject(3593,1729.557,-1147.246,23.301,0.0,0.0,-157.500);
    CreateDynamicObject(3593,1748.052,-1145.705,23.420,0.0,0.0,-225.000);
    CreateDynamicObject(3593,1690.324,-1161.857,23.041,0.0,0.0,-281.250);
    CreateDynamicObject(3593,1605.501,-1165.553,23.438,0.0,0.0,-281.250);
    CreateDynamicObject(3593,1625.202,-1158.466,23.281,0.0,0.0,-348.750);
    CreateDynamicObject(3593,1580.175,-1149.285,23.204,0.0,0.0,-337.500);
    CreateDynamicObject(3593,1575.713,-1125.220,22.817,0.0,0.0,-303.750);
    CreateDynamicObject(3593,1558.546,-1112.115,23.467,0.0,0.0,-348.750);
    CreateDynamicObject(3593,1571.491,-1091.287,22.889,0.0,0.0,-303.750);
    CreateDynamicObject(3593,1554.017,-1076.242,23.102,0.0,0.0,-371.250);
    CreateDynamicObject(3593,1535.470,-1043.690,23.025,0.0,0.0,-326.250);
    CreateDynamicObject(3593,1535.106,-1008.089,23.563,0.0,0.0,-360.000);
    CreateDynamicObject(3593,1529.063,-1027.821,23.414,0.0,0.0,-202.500);
    CreateDynamicObject(3593,1508.591,-1041.914,23.234,0.0,0.0,-146.250);
    CreateDynamicObject(3593,1515.301,-1059.617,24.523,0.0,0.0,-56.250);
    CreateDynamicObject(3593,1497.570,-1057.753,24.548,0.0,0.0,-213.750);
    CreateDynamicObject(3593,1481.959,-1026.650,23.221,0.0,0.0,-225.000);
    CreateDynamicObject(3593,1482.479,-1081.502,23.116,0.0,0.0,-135.000);
    CreateDynamicObject(3593,1482.035,-1052.766,23.014,0.0,0.0,-270.000);
    CreateDynamicObject(3593,1485.564,-1135.667,23.316,0.0,0.0,-202.500);
    CreateDynamicObject(3593,1466.242,-1150.682,23.365,-8.594,0.0,-202.500);
    CreateDynamicObject(18248,1554.323,-1160.694,34.248,-28.361,0.0,45.000);
    CreateDynamicObject(911,1502.403,-1180.076,23.645,0.0,0.0,22.500);
    CreateDynamicObject(922,1482.856,-1152.782,23.792,0.0,0.0,-78.750);
    CreateDynamicObject(933,1577.864,-1118.727,22.419,0.0,0.0,11.250);
    CreateDynamicObject(933,1576.154,-1118.997,22.419,0.0,0.0,11.250);
    CreateDynamicObject(952,1579.084,-1122.042,23.753,0.0,0.0,0.0);
    CreateDynamicObject(910,1576.956,-1120.108,23.690,0.0,0.0,11.250);
    CreateDynamicObject(3594,1568.000,-1097.980,23.097,0.0,0.0,-22.500);
    CreateDynamicObject(3594,1565.883,-1078.908,23.149,0.0,0.0,-90.000);
    CreateDynamicObject(3594,1578.770,-1098.446,23.263,0.0,0.0,0.0);
    CreateDynamicObject(3594,1582.482,-1081.722,23.929,0.0,0.0,-78.750);
    CreateDynamicObject(3594,1565.182,-1065.885,23.356,0.0,0.0,-11.250);
    CreateDynamicObject(12957,1562.114,-1090.547,23.542,0.0,0.0,258.750);
    CreateDynamicObject(12957,1541.305,-1058.015,23.652,0.0,0.0,157.500);
    CreateDynamicObject(3594,1549.463,-1055.611,23.237,0.0,0.0,-11.250);
    CreateDynamicObject(3594,1703.172,-1203.521,21.094,0.0,0.0,0.0);
    CreateDynamicObject(3594,1702.878,-1203.704,22.027,0.0,0.0,0.0);
    CreateDynamicObject(3594,1702.672,-1203.589,22.828,0.0,0.0,0.0);
    CreateDynamicObject(3594,1709.167,-1204.148,21.040,7.735,6.875,-22.500);
    CreateDynamicObject(3594,1716.222,-1216.244,18.860,7.735,6.875,-22.500);
    CreateDynamicObject(3594,1848.232,-1213.524,19.227,7.735,6.875,-22.500);
    CreateDynamicObject(3594,1851.203,-1194.494,22.661,7.735,6.875,-22.500);
    CreateDynamicObject(3594,1852.983,-1230.811,16.102,7.735,6.875,-33.750);
    CreateDynamicObject(12957,1845.372,-1223.870,17.569,1.719,18.908,-101.250);
    CreateDynamicObject(12957,1856.800,-1204.052,21.380,1.719,18.908,-101.250);
    CreateDynamicObject(12957,1712.576,-1221.175,18.165,-8.594,6.875,-135.000);
    CreateDynamicObject(12957,1714.870,-1242.646,14.217,-8.594,6.875,-135.000);
    CreateDynamicObject(3594,1721.612,-1231.727,16.144,12.032,0.859,11.250);
    CreateDynamicObject(3594,1707.418,-1248.940,13.145,12.032,0.859,11.250);
    CreateDynamicObject(12957,1725.277,-1255.191,13.425,0.0,0.0,-45.000);
    CreateDynamicObject(12957,1730.508,-1267.107,13.423,0.0,0.0,56.250);
    CreateDynamicObject(12957,1734.477,-1279.302,13.450,0.0,0.0,-45.000);
    CreateDynamicObject(3594,1728.674,-1276.402,13.177,0.0,0.0,0.0);
    CreateDynamicObject(3594,1711.923,-1275.157,13.014,0.0,0.0,56.250);
    CreateDynamicObject(3594,1718.769,-1283.958,13.014,0.0,0.0,-33.750);
    CreateDynamicObject(3594,1707.740,-1283.873,13.178,0.0,0.0,45.000);
    CreateDynamicObject(3594,1712.681,-1260.698,13.021,0.0,0.0,101.250);
    CreateDynamicObject(3593,1717.859,-1266.906,12.698,0.0,0.0,-33.750);
    CreateDynamicObject(3593,1698.787,-1261.832,14.127,0.0,0.0,-33.750);
    CreateDynamicObject(3593,1721.620,-1199.965,21.628,-7.735,0.0,-135.000);
    CreateDynamicObject(3593,1838.664,-1203.005,21.351,13.751,0.0,0.0);
    CreateDynamicObject(2674,1786.593,-1218.650,15.976,0.0,0.0,0.0);
    CreateDynamicObject(2672,1786.799,-1223.690,16.227,0.0,0.0,0.0);
    CreateDynamicObject(2672,1784.408,-1227.350,16.203,0.0,0.0,-56.250);
    CreateDynamicObject(1439,1788.566,-1217.085,16.070,0.0,0.0,-90.000);
    CreateDynamicObject(1440,1782.985,-1219.885,16.446,0.0,0.0,-90.000);
    CreateDynamicObject(1415,1787.941,-1225.292,16.060,0.0,0.0,-146.250);
    CreateDynamicObject(1299,1782.642,-1211.898,16.392,0.0,0.0,0.0);
    CreateDynamicObject(1299,1782.561,-1213.925,16.388,0.0,0.0,0.0);
    CreateDynamicObject(925,1788.085,-1219.545,17.025,0.0,0.0,90.000);
    CreateDynamicObject(922,1786.883,-1233.193,16.797,0.0,0.0,0.0);
    CreateDynamicObject(922,1783.919,-1230.111,16.797,0.0,0.0,0.0);
    CreateDynamicObject(2907,1787.610,-1230.297,16.085,0.0,0.0,0.0);
    CreateDynamicObject(2907,1783.075,-1216.713,16.092,0.0,0.0,45.000);
    CreateDynamicObject(2905,1786.085,-1210.587,16.032,0.0,0.0,-33.750);
    CreateDynamicObject(2906,1786.379,-1216.004,16.030,0.0,0.0,45.000);
    CreateDynamicObject(2906,1788.106,-1223.375,16.025,0.0,0.0,-11.250);
    CreateDynamicObject(2906,1784.098,-1222.741,16.002,0.0,0.0,-112.500);
    CreateDynamicObject(2908,1783.786,-1226.111,16.000,0.0,0.0,22.500);
    CreateDynamicObject(2908,1783.640,-1221.006,16.007,0.0,0.0,-33.750);
    CreateDynamicObject(2908,1785.240,-1208.313,16.016,0.0,0.0,-33.750);
    CreateDynamicObject(2908,1787.341,-1209.141,16.018,0.0,0.0,45.000);
    CreateDynamicObject(2907,1783.880,-1209.010,16.097,0.0,0.0,45.000);
    CreateDynamicObject(3594,1691.808,-1309.021,13.374,0.0,0.0,45.000);
    CreateDynamicObject(3594,1661.404,-1295.456,13.729,2.578,0.0,90.000);
    CreateDynamicObject(3594,1646.542,-1306.536,14.661,1.719,-7.735,157.500);
    CreateDynamicObject(3594,1613.490,-1322.440,16.945,0.0,0.0,112.500);
    CreateDynamicObject(3594,1597.518,-1319.269,17.107,0.0,0.0,180.000);
    CreateDynamicObject(3594,1588.432,-1328.663,16.105,0.0,0.0,146.250);
    CreateDynamicObject(3594,1575.378,-1324.229,16.116,0.0,0.0,225.000);
    CreateDynamicObject(3594,1580.374,-1299.046,16.963,0.0,0.0,258.750);
    CreateDynamicObject(3594,1515.367,-1306.350,14.124,0.0,0.0,225.000);
    CreateDynamicObject(3594,1604.007,-1295.871,16.762,0.0,0.0,213.750);
    CreateDynamicObject(3594,1474.856,-1292.569,13.297,0.0,0.0,213.750);
    CreateDynamicObject(12957,1489.802,-1293.969,13.575,0.0,0.0,-45.000);
    CreateDynamicObject(12957,1490.361,-1305.517,13.594,0.0,0.0,22.500);
    CreateDynamicObject(12957,1472.006,-1303.577,13.348,0.0,0.0,-90.000);
    CreateDynamicObject(3593,1568.973,-1288.700,16.724,0.0,0.0,-45.000);
    CreateDynamicObject(3593,1603.763,-1303.800,16.691,0.0,0.0,-90.000);
    CreateDynamicObject(12957,1604.094,-1315.937,17.170,0.0,0.0,-33.750);
    CreateDynamicObject(12957,1600.126,-1299.697,17.159,0.0,0.0,112.500);
    CreateDynamicObject(12957,1668.861,-1296.403,14.047,0.0,0.0,45.000);
    CreateDynamicObject(12957,1696.064,-1296.157,13.393,0.0,0.0,-33.750);
    CreateDynamicObject(12957,1657.625,-1280.199,14.653,0.0,0.0,-90.000);
    CreateDynamicObject(12957,1637.470,-1273.598,14.693,0.0,0.0,-33.750);
    CreateDynamicObject(12957,1647.038,-1322.490,17.316,0.0,0.0,-33.750);
    CreateDynamicObject(12957,1645.898,-1340.534,17.319,0.0,0.0,-78.750);
    CreateDynamicObject(12957,1640.453,-1350.429,17.331,0.0,0.0,-33.750);
    CreateDynamicObject(851,1641.912,-1242.125,14.136,0.0,0.0,0.0);
    CreateDynamicObject(850,1627.928,-1247.404,13.948,0.0,0.0,0.0);
    CreateDynamicObject(12954,1647.552,-1252.186,14.398,0.0,0.0,-180.000);
    CreateDynamicObject(12957,1650.534,-1253.985,14.691,0.0,0.0,-78.750);
    CreateDynamicObject(1558,1632.036,-1254.271,14.409,0.0,0.0,0.0);
    CreateDynamicObject(1558,1630.727,-1248.267,14.413,0.0,0.0,67.500);
    CreateDynamicObject(1558,1632.714,-1251.523,14.408,0.0,0.0,11.250);
    CreateDynamicObject(1224,1633.010,-1239.039,14.440,0.0,0.0,33.750);
    CreateDynamicObject(1224,1634.545,-1238.339,14.440,0.0,0.0,-33.750);
    CreateDynamicObject(939,1642.024,-1236.773,16.266,0.0,0.0,0.0);
    CreateDynamicObject(923,1636.558,-1253.081,14.707,0.0,0.0,45.000);
    CreateDynamicObject(923,1640.391,-1253.196,14.701,0.0,0.0,-11.250);
    CreateDynamicObject(923,1638.423,-1255.692,14.704,0.0,0.0,-90.000);
    CreateDynamicObject(922,1643.516,-1263.444,14.709,0.0,0.0,0.0);
    CreateDynamicObject(922,1633.956,-1260.395,14.717,0.0,0.0,-45.000);
    CreateDynamicObject(1227,1626.662,-1242.846,14.680,0.0,0.0,78.750);
    CreateDynamicObject(1236,1627.412,-1250.212,14.507,0.0,0.0,67.500);
    CreateDynamicObject(1236,1626.310,-1245.725,14.603,0.0,0.0,112.500);
    CreateDynamicObject(1333,1630.736,-1235.686,14.749,0.0,0.0,-22.500);
    CreateDynamicObject(2907,1636.334,-1224.137,13.996,0.0,0.0,0.0);
    CreateDynamicObject(2907,1640.159,-1238.272,13.983,0.0,0.0,45.000);
    CreateDynamicObject(2907,1643.490,-1245.945,13.983,0.0,0.0,-33.750);
    CreateDynamicObject(2908,1634.599,-1246.908,13.908,0.0,0.0,0.0);
    CreateDynamicObject(2908,1637.250,-1247.433,13.911,0.0,0.0,-90.000);
    CreateDynamicObject(2908,1642.609,-1254.868,13.902,0.0,0.0,-11.250);
    CreateDynamicObject(2906,1643.553,-1258.201,13.897,0.0,0.0,67.500);
    CreateDynamicObject(2906,1639.000,-1261.161,13.905,0.0,0.0,-11.250);
    CreateDynamicObject(2906,1635.278,-1256.159,13.904,0.0,0.0,56.250);
    CreateDynamicObject(2906,1630.674,-1243.803,13.903,0.0,0.0,0.0);
    CreateDynamicObject(2906,1632.230,-1229.919,13.904,0.0,0.0,67.500);
    CreateDynamicObject(2907,1630.692,-1241.388,13.986,0.0,0.0,0.0);
    CreateDynamicObject(2908,1634.693,-1244.247,13.902,0.0,0.0,45.000);
    CreateDynamicObject(2906,1631.987,-1236.110,13.898,0.0,0.0,0.0);
    CreateDynamicObject(2905,1630.430,-1239.094,13.917,0.0,0.0,45.000);
    CreateDynamicObject(2905,1632.683,-1232.138,13.917,0.0,0.0,168.750);
    CreateDynamicObject(2905,1637.060,-1225.382,13.918,0.0,0.0,135.000);
    CreateDynamicObject(2905,1642.610,-1240.089,13.914,0.0,0.0,101.250);
    CreateDynamicObject(2905,1644.865,-1245.780,13.904,0.0,0.0,146.250);
    CreateDynamicObject(2905,1641.435,-1244.924,13.918,0.0,0.0,45.000);
    CreateDynamicObject(2905,1640.958,-1255.263,13.919,0.0,0.0,112.500);
    CreateDynamicObject(2907,1637.692,-1259.252,13.993,0.0,0.0,-33.750);
    CreateDynamicObject(2907,1640.853,-1258.891,13.988,0.0,0.0,-146.250);
    CreateDynamicObject(2907,1631.134,-1256.665,13.997,0.0,0.0,-90.000);

//Otra parte por bytytus.
    CreateDynamicObject(3593, 736.45922851563, -1591.6446533203, 14.107468605042, 0, 0, 40.199981689453);
    CreateDynamicObject(3594, 724.22717285156, -1581.1768798828, 13.886218070984, 0, 0, 43.549987792969);
    CreateDynamicObject(3594, 717.90081787109, -1589.8564453125, 13.855607032776, 0, 0, 43.5498046875);
    CreateDynamicObject(3593, 702.77313232422, -1582.5997314453, 13.686238288879, 0, 0, 147.39895629883);
    CreateDynamicObject(3594, 689.74829101563, -1593.1348876953, 13.744210243225, 0, 0, 43.5498046875);
    CreateDynamicObject(3593, 657.75494384766, -1581.8527832031, 14.472993850708, 0, 0, 207.69818115234);
    CreateDynamicObject(3594, 516.1328125, -1602.037109375, 15.803086280823, 0, 0, 144.04724121094);
    CreateDynamicObject(3593, 516.69598388672, -1586.1541748047, 15.669660568237, 0, 0, 0);
    CreateDynamicObject(2673, 524.32336425781, -1590.0128173828, 15.095640182495, 0, 0, 0);
    CreateDynamicObject(1558, 525.11328125, -1584.4395751953, 15.581764221191, 0, 0, 0);
    CreateDynamicObject(12957, 505.4248046875, -1596.232421875, 15.738114356995, 0, 0, 323.14636230469);
    CreateDynamicObject(13591, 537.92578125, -1596.802734375, 15.170064926147, 0, 0, 60.298461914063);
    CreateDynamicObject(3594, 528.1357421875, -1582.9833984375, 15.638989448547, 0, 0, 0);
    CreateDynamicObject(3593, 526.4326171875, -1592.3818359375, 15.717980384827, 0, 0, 56.947631835938);
    CreateDynamicObject(3594, 523.67260742188, -1570.3420410156, 15.558110237122, 0, 0, 80.399993896484);
    CreateDynamicObject(12957, 511.55563354492, -1573.8414306641, 15.964567184448, 0, 0, 133.99597167969);
    CreateDynamicObject(3593, 493.36859130859, -1582.5354003906, 18.071622848511, 0, 16.75, 30.149932861328);
    CreateDynamicObject(3594, 490.52368164063, -1596.6358642578, 18.550870895386, 0, 343.25, 144.04724121094);
    CreateDynamicObject(3593, 478.14630126953, -1596.9333496094, 22.750839233398, 6.41455078125, 16.857299804688, 28.207611083984);
    CreateDynamicObject(3594, 481.65588378906, -1583.7047119141, 21.716800689697, 6.4143676757813, 343.13720703125, 145.98126220703);
    CreateDynamicObject(12957, 486.99774169922, -1589.703125, 19.957622528076, 6.5967407226563, 10.11767578125, 49.071594238281);
    CreateDynamicObject(3593, 539.32592773438, -1567.5659179688, 15.548525810242, 0, 0, 306.40002441406);
    CreateDynamicObject(3594, 535.46307373047, -1529.2229003906, 14.281829833984, 0, 0, 80.39794921875);
    CreateDynamicObject(12957, 528.74945068359, -1523.2423095703, 14.339033126831, 0, 0, 133.99475097656);
    CreateDynamicObject(1558, 541.36138916016, -1544.2231445313, 14.71441078186, 0, 0, 0);
    CreateDynamicObject(3593, 516.46453857422, -1556.845703125, 15.986983299255, 0, 0, 36.850006103516);
    CreateDynamicObject(3594, 550.99932861328, -1568.9309082031, 15.752121925354, 0, 0, 130.64785766602);
    CreateDynamicObject(1558, 528.07409667969, -1548.232421875, 14.825799942017, 0, 0, 0);
    CreateDynamicObject(3594, 519.23364257813, -1509.4464111328, 14.189792633057, 0, 0, 127.29797363281);
    CreateDynamicObject(12957, 543.16912841797, -1508.1157226563, 14.032767295837, 0, 0, 311.54479980469);
    CreateDynamicObject(1558, 536.18078613281, -1497.8245849609, 13.898213386536, 0, 0, 0);
    CreateDynamicObject(1558, 525.23297119141, -1481.6765136719, 14.017457962036, 0, 0, 0);
    CreateDynamicObject(3594, 527.01654052734, -1545.2525634766, 14.786618232727, 0, 0, 140.69799804688);
    CreateDynamicObject(3593, 519.80493164063, -1538.7889404297, 15.224648475647, 0, 0, 6.6980895996094);
    CreateDynamicObject(12957, 530.14154052734, -1560.8365478516, 15.515983581543, 0, 0, 77.044616699219);
    CreateDynamicObject(3594, 540.63134765625, -1547.5593261719, 14.877521514893, 0, 0, 299.69802856445);
    CreateDynamicObject(18247, 575.44006347656, -1533.1567382813, 18.900390625, 0, 0, 0);
    CreateDynamicObject(18248, 523.96557617188, -1496.1179199219, 19.978813171387, 0.01409912109375, 90.449584960938, 355.09994506836);
    CreateDynamicObject(3594, 522.21710205078, -1528.2591552734, 14.550517082214, 0, 0, 237.84301757813);
    CreateDynamicObject(3594, 533.34210205078, -1508.7552490234, 13.789163589478, 0, 0, 110.53735351563);
    CreateDynamicObject(3593, 540.73559570313, -1494.27734375, 14.015372276306, 0, 0, 306.39770507813);
    CreateDynamicObject(3593, 541.71282958984, -1522.7354736328, 14.168261528015, 0, 0, 40.196166992188);
    CreateDynamicObject(12957, 534.90155029297, -1543.3000488281, 14.978872299194, 0, 0, 319.79476928711);
    CreateDynamicObject(3593, 549.71466064453, -1460.4678955078, 14.753045082092, 0, 0, 242.74774169922);
    CreateDynamicObject(3594, 535.37658691406, -1486.9279785156, 13.804964065552, 0, 0, 110.53344726563);
    CreateDynamicObject(12957, 542.62750244141, -1476.2340087891, 14.421545028687, 0, 0, 311.53930664063);
    CreateDynamicObject(3594, 527.37371826172, -1478.4525146484, 14.142420768738, 0, 0, 289.63348388672);
    CreateDynamicObject(3593, 527.67443847656, -1463.4842529297, 14.550024032593, 0, 0, 125.49276733398);
    CreateDynamicObject(3594, 538.87463378906, -1464.8162841797, 14.427439689636, 0, 0, 329.83251953125);
    CreateDynamicObject(12957, 518.2734375, -1457.234375, 15.047981262207, 0, 0, 311.53930664063);
    CreateDynamicObject(3594, 529.2958984375, -1446.271484375, 15.013918876648, 0, 0, 256.12976074219);
    CreateDynamicObject(3593, 540.6201171875, -1445.6884765625, 15.047057151794, 0, 0, 132.1875);
    CreateDynamicObject(3593, 493.50201416016, -1558.7602539063, 17.047065734863, 0, 0, 0);
    CreateDynamicObject(12957, 491.32656860352, -1543.333984375, 18.324640274048, 0, 0, 133.99475097656);
    CreateDynamicObject(3594, 501.22079467773, -1550.1437988281, 17.035123825073, 0, 0, 80.39794921875);
    CreateDynamicObject(3593, 496.4296875, -1536.8278808594, 18.158983230591, 0, 0, 226);
    CreateDynamicObject(3594, 505.99584960938, -1564.3123779297, 16.003484725952, 0, 0, 174.19799804688);
    CreateDynamicObject(12957, 495.6125793457, -1572.7543945313, 17.173879623413, 346.6233215332, 3.4435424804688, 325.74243164063);
    CreateDynamicObject(3593, 480.86050415039, -1512.970703125, 19.714181900024, 0, 0, 225.99975585938);
    CreateDynamicObject(12957, 480.31011962891, -1527.2965087891, 19.898097991943, 0, 0, 266.19482421875);
    CreateDynamicObject(3594, 483.09155273438, -1537.0393066406, 19.030979156494, 0, 0, 80.39794921875);
    CreateDynamicObject(3594, 489.93328857422, -1522.9030761719, 19.408592224121, 0, 0, 316.44793701172);
    CreateDynamicObject(3594, 489.16613769531, -1506.3623046875, 19.959121704102, 0, 0, 306.39794921875);
    CreateDynamicObject(12957, 481.26376342773, -1501.8425292969, 20.237173080444, 0, 0, 133.99475097656);
    CreateDynamicObject(3594, 489.71826171875, -1492.7169189453, 19.628112792969, 0, 0, 125.49752807617);
    CreateDynamicObject(3593, 482.92504882813, -1485.966796875, 19.122547149658, 0, 0, 132.19958496094);
    CreateDynamicObject(3594, 484.09130859375, -1480.5041503906, 19.15064239502, 16.75, 0, 185.79678344727);
    CreateDynamicObject(3594, 492.62561035156, -1473.6945800781, 18.530740737915, 0, 0, 125.49682617188);
    CreateDynamicObject(3593, 486.49920654297, -1467.4918212891, 18.088510513306, 3.3500061035156, 0, 132.19848632813);
    CreateDynamicObject(3594, 501.84072875977, -1460.3511962891, 16.367605209351, 10.049987792969, 0, 125.49682617188);
    CreateDynamicObject(3593, 492.4401550293, -1457.6987304688, 16.948034286499, 3.3224792480469, 353.28863525391, 206.28936767578);
    CreateDynamicObject(12957, 502.03796386719, -1448.3338623047, 15.225249290466, 0, 0, 311.53930664063);
    CreateDynamicObject(12957, 521.7626953125, -1435.2197265625, 15.589081764221, 0, 0, 55.387573242188);
    CreateDynamicObject(3594, 549.06658935547, -1426.3031005859, 15.756335258484, 0, 0, 239.38160705566);
    CreateDynamicObject(3594, 515.70166015625, -1447.4869384766, 14.617370605469, 0, 0, 53.579711914063);
    CreateDynamicObject(3593, 507.11798095703, -1440.5462646484, 14.036653518677, 3.31787109375, 353.28735351563, 206.28479003906);
    CreateDynamicObject(3594, 492.75628662109, -1445.5539550781, 16.287570953369, 13.190643310547, 349.67471313477, 127.87744140625);
    CreateDynamicObject(3594, 439.5256652832, -1594.7620849609, 24.935863494873, 0, 0, 0);
    CreateDynamicObject(12957, 420.21350097656, -1578.74609375, 25.946561813354, 6.591796875, 10.112915039063, 49.070434570313);
    CreateDynamicObject(3594, 468.6403503418, -1579.6472167969, 24.742855072021, 0, 0, 212.60000610352);
    CreateDynamicObject(12957, 466.40240478516, -1594.2243652344, 24.882902145386, 6.591796875, 10.112915039063, 156.27044677734);
    CreateDynamicObject(3594, 454.12142944336, -1583.2908935547, 24.785861968994, 0, 0, 70.349975585938);
    CreateDynamicObject(3593, 439.75787353516, -1603.7734375, 25.039249420166, 0, 0, 56.947631835938);
    CreateDynamicObject(3593, 456.92129516602, -1618.8370361328, 25.776391983032, 0, 0, 56.947631835938);
    CreateDynamicObject(3594, 458.70886230469, -1606.1116943359, 25.241218566895, 0, 0, 296.34997558594);
    CreateDynamicObject(12957, 448.45135498047, -1609.4378662109, 24.826877593994, 3.3391723632813, 3.3510437011719, 50.047973632813);
    CreateDynamicObject(3594, 442.31433105469, -1617.3315429688, 25.4899559021, 0, 0, 296.34521484375);
    CreateDynamicObject(3593, 436.75415039063, -1627.349609375, 25.817079544067, 0, 0, 56.947631835938);
    CreateDynamicObject(12957, 449.4382019043, -1629.2609863281, 25.612449645996, 3.3343505859375, 3.350830078125, 316.24273681641);
    CreateDynamicObject(3594, 457.13250732422, -1642.1535644531, 25.398931503296, 0, 0, 296.34521484375);
    CreateDynamicObject(3594, 440.46884155273, -1642.0424804688, 25.228868484497, 0, 0, 212.59518432617);
    CreateDynamicObject(3593, 449.53918457031, -1647.2609863281, 25.046106338501, 0, 0, 56.947631835938);
    CreateDynamicObject(3594, 442.12750244141, -1575.5311279297, 24.935863494873, 0, 0, 329.84545898438);
    CreateDynamicObject(3593, 457.01174926758, -1592.6817626953, 25.014856338501, 0, 0, 326.49768066406);
    CreateDynamicObject(3594, 422.34558105469, -1596.1750488281, 25.578210830688, 0, 0, 73.700012207031);
    CreateDynamicObject(12957, 392.2041015625, -1579.4482421875, 28.488542556763, 6.5863037109375, 10.107421875, 49.06494140625);
    CreateDynamicObject(12957, 364.48590087891, -1598.2681884766, 31.535634994507, 6.6834411621094, 3.3682861328125, 49.850921630859);
    CreateDynamicObject(12957, 350.8642578125, -1576.966796875, 32.153137207031, 359.99450683594, 359.99450683594, 50.240478515625);
    CreateDynamicObject(12957, 313.6455078125, -1583.69140625, 32.987590789795, 359.98901367188, 359.98901367188, 50.234985351563);
    CreateDynamicObject(3594, 407.0283203125, -1594.8740234375, 26.734508514404, 0, 0, 20.093994140625);
    CreateDynamicObject(3593, 408.19232177734, -1574.8005371094, 26.647567749023, 0, 0, 150.74758911133);
    CreateDynamicObject(3594, 413.20483398438, -1586.0643310547, 26.236349105835, 0, 0, 73.6962890625);
    CreateDynamicObject(3593, 394.30209350586, -1592.9011230469, 27.825899124146, 0, 353.29992675781, 150.74340820313);
    CreateDynamicObject(3594, 388.85244750977, -1585.8249511719, 28.597230911255, 6.6885070800781, 3.3729858398438, 73.302978515625);
    CreateDynamicObject(3593, 396.84817504883, -1568.6823730469, 27.780361175537, 353.31149291992, 356.62701416016, 240.80023193359);
    CreateDynamicObject(3594, 435.10693359375, -1585.9013671875, 24.935863494873, 0, 0, 137.34625244141);
    CreateDynamicObject(3594, 379.5322265625, -1594.927734375, 29.944910049438, 6.6796875, 3.3673095703125, 213.99719238281);
    CreateDynamicObject(3593, 375.9375, -1580.3798828125, 30.260786056519, 0, 353.29284667969, 150.73791503906);
    CreateDynamicObject(3594, 368.2802734375, -1588.1376953125, 30.586187362671, 359.99450683594, 3.3453369140625, 264.64416503906);
    CreateDynamicObject(3594, 251.140625, -1566.1064453125, 32.765548706055, 0, 0, 140.69641113281);
    CreateDynamicObject(12957, 252.841796875, -1574.8076171875, 32.894981384277, 359.98901367188, 359.98901367188, 346.58569335938);
    CreateDynamicObject(3593, 262.91934204102, -1582.9639892578, 32.866161346436, 0, 0, 56.947631835938);
    CreateDynamicObject(3594, 265.41290283203, -1570.2301025391, 32.585350036621, 0, 0, 26.796417236328);
    CreateDynamicObject(3594, 271.94644165039, -1582.2885742188, 32.520866394043, 0, 0, 140.69641113281);
    CreateDynamicObject(12957, 277.73190307617, -1572.3406982422, 32.972927093506, 359.98901367188, 359.98901367188, 33.485687255859);
    CreateDynamicObject(3594, 248.1123046875, -1560.3759765625, 32.362777709961, 0, 0, 262.84240722656);
    CreateDynamicObject(3593, 236.0126953125, -1563.484375, 32.801689147949, 0, 0, 56.942138671875);
    CreateDynamicObject(12957, 294.40377807617, -1588.3399658203, 32.418663024902, 359.98352050781, 359.98352050781, 205.88090515137);
    CreateDynamicObject(3594, 294.49429321289, -1579.2436523438, 32.57498550415, 0, 0, 140.69641113281);
    CreateDynamicObject(3593, 283.97463989258, -1585.8481445313, 32.53141784668, 0, 0, 359.99768066406);
    CreateDynamicObject(3594, 305.74673461914, -1588.8408203125, 32.488735198975, 0, 0, 30.146423339844);
    CreateDynamicObject(3594, 286.04040527344, -1575.318359375, 32.483619689941, 0, 0, 328.29653930664);
    CreateDynamicObject(12957, 337.6142578125, -1596.3720703125, 32.679817199707, 359.98901367188, 359.98901367188, 50.234985351563);
    CreateDynamicObject(3594, 337.4130859375, -1588.181640625, 32.507778167725, 0, 0, 219.287109375);
    CreateDynamicObject(3593, 336.8916015625, -1577.2021484375, 32.444538116455, 0, 0, 127.29309082031);
    CreateDynamicObject(3594, 351.544921875, -1591.6064453125, 31.751407623291, 0, 0, 123.93676757813);
    CreateDynamicObject(3594, 318.0107421875, -1575.99609375, 32.740550994873, 0, 0, 247.8955078125);
    CreateDynamicObject(3593, 325.4775390625, -1587.75390625, 32.669540405273, 0, 0, 77.041625976563);
    CreateDynamicObject(3594, 328.732421875, -1598.5498046875, 32.608428955078, 0, 0, 117.24060058594);
    CreateDynamicObject(3593, 317.416015625, -1603.2724609375, 32.879508972168, 0, 0, 77.041625976563);
    CreateDynamicObject(3593, 330.79409790039, -1572.7680664063, 32.595104217529, 0, 0, 227.79327392578);
    CreateDynamicObject(3594, 323.25653076172, -1563.2692871094, 32.439296722412, 0, 0, 204.34552001953);
    CreateDynamicObject(12957, 335.86465454102, -1561.8426513672, 32.68546295166, 359.98901367188, 359.98901367188, 50.234985351563);
    CreateDynamicObject(3593, 331.56289672852, -1551.8791503906, 32.70418548584, 0, 0, 351.74047851563);
    CreateDynamicObject(3594, 348.71176147461, -1558.9090576172, 32.33475112915, 0, 0, 204.34020996094);
    CreateDynamicObject(3593, 343.66973876953, -1549.1281738281, 32.483737945557, 0, 0, 261.28820800781);
    CreateDynamicObject(3594, 328.4736328125, -1540.5437011719, 32.525848388672, 0, 0, 204.34020996094);
    CreateDynamicObject(3594, 337.81024169922, -1537.1207275391, 32.70210647583, 0, 0, 117.24008178711);
    CreateDynamicObject(3593, 348.37612915039, -1540.4305419922, 32.937957763672, 0, 0, 184.23779296875);
    CreateDynamicObject(12957, 357.79974365234, -1545.9013671875, 33.271781921387, 359.98901367188, 359.98901367188, 259.48498535156);
    CreateDynamicObject(3594, 350.42205810547, -1526.4833984375, 32.703174591064, 0, 0, 267.990234375);
    CreateDynamicObject(3593, 339.63119506836, -1527.1823730469, 32.580406188965, 0, 0, 184.23522949219);
    CreateDynamicObject(3594, 361.3489074707, -1529.9655761719, 32.464134216309, 0, 0, 180.88940429688);
    CreateDynamicObject(12957, 368.44345092773, -1535.8453369141, 32.64289855957, 359.98352050781, 359.98352050781, 259.48059082031);
    CreateDynamicObject(12957, 356.85388183594, -1507.6970214844, 32.479721069336, 359.98352050781, 359.98352050781, 202.53056335449);
    CreateDynamicObject(3593, 360.16976928711, -1517.9840087891, 32.365516662598, 0, 0, 93.78515625);
    CreateDynamicObject(3594, 374.14282226563, -1521.3735351563, 32.223587036133, 0, 0, 184.23937988281);
    CreateDynamicObject(3593, 366.12713623047, -1503.0869140625, 32.319515228271, 0, 0, 36.834838867188);
    CreateDynamicObject(3593, 383.6858215332, -1504.2678222656, 32.001712799072, 0, 0, 269.53485107422);
    CreateDynamicObject(3594, 368.5832824707, -1515.1329345703, 32.41040802002, 0, 0, 127.28512573242);
    CreateDynamicObject(12957, 384.39520263672, -1519.3610839844, 32.21639251709, 359.98352050781, 359.98352050781, 195.83056640625);
    CreateDynamicObject(12957, 402.55587768555, -1538.2855224609, 31.926651000977, 359.98352050781, 359.98352050781, 259.48059082031);
    CreateDynamicObject(3594, 392.46606445313, -1528.0422363281, 31.904613494873, 0, 0, 33.482177734375);
    CreateDynamicObject(3593, 402.1015625, -1524.9516601563, 31.608602523804, 0, 0, 93.784790039063);
    CreateDynamicObject(3593, 404.31060791016, -1482.1094970703, 30.831396102905, 0, 0, 269.53308105469);
    CreateDynamicObject(3594, 395.4235534668, -1507.3232421875, 31.757204055786, 0, 0, 33.482177734375);
    CreateDynamicObject(3593, 387.00772094727, -1491.1016845703, 31.576517105103, 0, 0, 202.53305053711);
    CreateDynamicObject(3594, 374.69415283203, -1499.5336914063, 31.790435791016, 0, 1.5502624511719, 81.931976318359);
    CreateDynamicObject(12957, 401.68423461914, -1495.1661376953, 31.382478713989, 359.97802734375, 359.97802734375, 195.82580566406);
    CreateDynamicObject(3594, 380.26943969727, -1487.28515625, 31.347276687622, 0, 1.549072265625, 11.58056640625);
    CreateDynamicObject(3594, 399.10076904297, -1474.2789306641, 30.620904922485, 0, 0, 242.73083496094);
    CreateDynamicObject(3593, 421.06695556641, -1490.3572998047, 30.370029449463, 0, 0, 199.18304443359);
    CreateDynamicObject(12957, 391.92916870117, -1499.4522705078, 31.803239822388, 359.97802734375, 359.97802734375, 95.325805664063);
    CreateDynamicObject(12957, 406.5364074707, -1470.8060302734, 30.488000869751, 359.97802734375, 359.97802734375, 78.575805664063);
    CreateDynamicObject(3593, 419.7155456543, -1466.5810546875, 29.816415786743, 0, 0, 175.73303222656);
    CreateDynamicObject(3594, 419.21908569336, -1480.1822509766, 30.233257293701, 0, 0, 66.976379394531);
    CreateDynamicObject(3593, 432.42266845703, -1473.0407714844, 29.741415023804, 0, 0, 85.281768798828);
    CreateDynamicObject(12957, 428.82278442383, -1457.5650634766, 29.834463119507, 359.97802734375, 359.97802734375, 28.324249267578);
    CreateDynamicObject(3594, 435.5344543457, -1464.2672119141, 29.737422943115, 0, 0, 319.77264404297);
    CreateDynamicObject(3594, 434.93014526367, -1448.1667480469, 29.636470794678, 0, 0, 195.81802368164);
    CreateDynamicObject(12957, 452.92779541016, -1462.9060058594, 29.135345458984, 359.97839355469, 10.028015136719, 28.326599121094);
    CreateDynamicObject(3593, 447.47338867188, -1455.2469482422, 28.408285140991, 356.67297363281, 6.7113647460938, 351.87268066406);
    CreateDynamicObject(3594, 449.81335449219, -1444.5098876953, 27.545303344727, 353.3115234375, 3.3729858398438, 320.16137695313);
    CreateDynamicObject(3594, 467.64300537109, -1451.384765625, 24.689764022827, 353.58337402344, 343.14111328125, 227.37506103516);
    CreateDynamicObject(3593, 463.89688110352, -1442.6851806641, 24.191770553589, 353.583984375, 343.13702392578, 228.93890380859);
    CreateDynamicObject(3594, 505.71234130859, -1453.9685058594, 15.420358657837, 359.99282836914, 343.24493408203, 229.3126373291);
    CreateDynamicObject(3593, 483.50772094727, -1446.4490966797, 19.51106262207, 353.57849121094, 343.13598632813, 228.93859863281);
    CreateDynamicObject(3594, 467.95553588867, -1432.3905029297, 21.768129348755, 353.47576904297, 13.48388671875, 26.525268554688);
    CreateDynamicObject(3593, 477.97491455078, -1437.3078613281, 19.449785232544, 20.092498779297, 359.99459838867, 113.63198852539);
    CreateDynamicObject(3594, 496.41879272461, -1434.1759033203, 15.315859794617, 353.47601318359, 346.50592041016, 227.75305175781);
    CreateDynamicObject(12957, 488.31231689453, -1428.1127929688, 16.145391464233, 349.99670410156, 6.7785339355469, 312.45166015625);
    CreateDynamicObject(3594, 474.22937011719, -1425.193359375, 18.901569366455, 350.21734619141, 346.39077758789, 250.40908813477);
    CreateDynamicObject(3593, 536.14190673828, -1429.9290771484, 15.671105384827, 0, 0, 311.28753662109);
    CreateDynamicObject(3594, 528.599609375, -1421.8612060547, 15.367115020752, 0, 0, 219.27972412109);
    CreateDynamicObject(3594, 539.35034179688, -1405.6706542969, 15.097165107727, 0, 0, 68.526000976563);
    CreateDynamicObject(3593, 544.58392333984, -1415.3332519531, 15.444953918457, 0, 0, 237.58660888672);
    CreateDynamicObject(3594, 516.68469238281, -1408.8822021484, 15.367115020752, 0, 0, 56.926086425781);
    CreateDynamicObject(3594, 502.84970092773, -1419.0249023438, 15.354028701782, 0, 0, 353.2760925293);
    CreateDynamicObject(3593, 519.74652099609, -1418.8725585938, 15.663409233093, 0, 0, 1.5348205566406);
    CreateDynamicObject(3593, 533.66253662109, -1410.7687988281, 15.671105384827, 0, 0, 120.3346862793);
    CreateDynamicObject(12957, 538.00024414063, -1419.9696044922, 15.839154243469, 0, 0, 55.387573242188);
    CreateDynamicObject(3593, 552.18255615234, -1399.4294433594, 14.965605735779, 0, 0, 1.5325927734375);
    CreateDynamicObject(3594, 558.23699951172, -1420.5040283203, 14.823943138123, 9.9806518554688, 353.1965637207, 119.96051025391);
    CreateDynamicObject(3593, 570.38946533203, -1410.7590332031, 14.199820518494, 0, 0, 110.28466796875);
    CreateDynamicObject(3593, 589.73779296875, -1392.2723388672, 12.992121696472, 0, 356.64999389648, 187.33473205566);
    CreateDynamicObject(3593, 601.95904541016, -1411.0358886719, 12.814577102661, 0, 0, 150.48471069336);
    CreateDynamicObject(3593, 610.09564208984, -1395.2219238281, 13.108605384827, 0, 0, 237.58483886719);
    CreateDynamicObject(3593, 617.5634765625, -1410.0225830078, 12.815246582031, 1.5499877929688, 0, 341.43475341797);
    CreateDynamicObject(3593, 633.37261962891, -1389.3839111328, 13.072305679321, 0, 0, 237.58483886719);
    CreateDynamicObject(3593, 647.96075439453, -1395.7084960938, 13.102132797241, 0, 0, 204.08480834961);
    CreateDynamicObject(3593, 661.65460205078, -1419.5812988281, 13.74191570282, 0, 0, 237.58483886719);
    CreateDynamicObject(3594, 565.07769775391, -1401.6411132813, 14.080347061157, 0, 0, 31.675994873047);
    CreateDynamicObject(3594, 556.33471679688, -1409.7745361328, 14.772414207458, 0, 0, 219.27612304688);
    CreateDynamicObject(3594, 582.21960449219, -1411.7161865234, 13.313797950745, 0, 0, 125.47595214844);
    CreateDynamicObject(3594, 579.63250732422, -1394.4836425781, 13.567221641541, 0, 0, 219.27612304688);
    CreateDynamicObject(12957, 590.77789306641, -1405.8156738281, 13.03976726532, 0, 0, 172.63763427734);
    CreateDynamicObject(12957, 574.70123291016, -1400.7434082031, 13.787942886353, 0, 3.3500061035156, 142.48760986328);
    CreateDynamicObject(12957, 607.43566894531, -1402.4691162109, 13.276654243469, 0, 0, 55.387573242188);
    CreateDynamicObject(3594, 598.66735839844, -1394.3034667969, 13.029614448547, 0, 0, 356.62609863281);
    CreateDynamicObject(3594, 628.89697265625, -1406.1170654297, 12.966081619263, 0, 0, 219.27612304688);
    CreateDynamicObject(3594, 629.40063476563, -1397.0247802734, 12.719007492065, 0, 0, 102.02597045898);
    CreateDynamicObject(3593, 644.77954101563, -1403.4650878906, 12.928092002869, 0, 0, 153.83471679688);
    CreateDynamicObject(3594, 621.59637451172, -1420.8287353516, 13.348724365234, 0, 0, 65.175994873047);
    CreateDynamicObject(12957, 641.68762207031, -1416.8275146484, 13.315466880798, 0, 0, 55.387573242188);
    CreateDynamicObject(12957, 640.60620117188, -1387.2999267578, 13.413182258606, 0, 0, 345.03759765625);
    CreateDynamicObject(12957, 243.54666137695, -1578.4526367188, 32.400085449219, 359.98901367188, 359.98901367188, 239.38568115234);
    CreateDynamicObject(3593, 236.71929931641, -1592.9250488281, 32.773597717285, 0, 0, 56.942138671875);
    CreateDynamicObject(3593, 250.07127380371, -1616.8084716797, 32.436950683594, 0, 0, 239.39221191406);
    CreateDynamicObject(3594, 234.40548706055, -1581.5579833984, 32.460803985596, 3.3500061035156, 0, 140.69641113281);
    CreateDynamicObject(3593, 226.26306152344, -1601.4959716797, 32.960063934326, 0, 0, 296.34216308594);
    CreateDynamicObject(3594, 233.9044342041, -1610.8840332031, 32.578784942627, 3.3453369140625, 0, 140.69091796875);
    CreateDynamicObject(3593, 243.22956848145, -1624.0819091797, 32.531841278076, 0, 0, 323.14215087891);
    CreateDynamicObject(12957, 243.60673522949, -1603.9674072266, 32.735538482666, 359.98352050781, 359.98352050781, 112.08108520508);
    CreateDynamicObject(12957, 224.91561889648, -1585.9846191406, 32.743507385254, 359.98352050781, 359.98352050781, 155.63104248047);
    CreateDynamicObject(3594, 250.90689086914, -1632.2729492188, 32.61209487915, 356.64538574219, 0, 308.19104003906);
    CreateDynamicObject(3594, 261.3037109375, -1626.2453613281, 32.229434967041, 3.3453369140625, 0, 207.69104003906);
    CreateDynamicObject(3593, 267.51205444336, -1639.3063964844, 32.563514709473, 0, 0, 189.14202880859);
    CreateDynamicObject(3594, 279.4255065918, -1645.7880859375, 32.643672943115, 356.64367675781, 0, 308.1884765625);
    CreateDynamicObject(3593, 281.68533325195, -1635.4743652344, 32.491401672363, 0, 0, 115.44049072266);
    CreateDynamicObject(3594, 293.48773193359, -1636.2640380859, 32.787414550781, 356.64367675781, 0, 200.98840332031);
    CreateDynamicObject(12957, 297.86572265625, -1630.2808837891, 33.081653594971, 359.97802734375, 359.97802734375, 112.07702636719);
    CreateDynamicObject(12957, 294.78402709961, -1646.9064941406, 32.890712738037, 359.97802734375, 359.97802734375, 222.62701416016);
    CreateDynamicObject(3594, 303.37048339844, -1652.4193115234, 32.797458648682, 356.64367675781, 0, 140.68377685547);
    CreateDynamicObject(3594, 309.13952636719, -1634.0610351563, 32.803829193115, 356.6494140625, 3.3557434082031, 15.380218505859);
    CreateDynamicObject(3593, 316.50067138672, -1642.7778320313, 32.850841522217, 0, 0, 24.988891601563);
    CreateDynamicObject(12957, 321.44290161133, -1653.4670410156, 33.238037109375, 359.97802734375, 359.97802734375, 358.1770324707);
    CreateDynamicObject(3594, 332.01196289063, -1650.6833496094, 32.643672943115, 356.64367675781, 0, 140.6799621582);
    CreateDynamicObject(3593, 332.77465820313, -1639.6407470703, 32.674362182617, 0, 0, 274.4384765625);
    CreateDynamicObject(3594, 321.58184814453, -1632.0018310547, 32.77038192749, 356.64916992188, 3.350830078125, 241.37539672852);
    CreateDynamicObject(12957, 335.82852172852, -1633.0440673828, 33.019390106201, 359.97802734375, 359.97802734375, 266.17706298828);
    CreateDynamicObject(3594, 351.1833190918, -1656.3503417969, 32.51876449585, 356.64367675781, 0, 140.6799621582);
    CreateDynamicObject(3593, 344.61822509766, -1647.4375, 32.478561401367, 0, 0, 200.73291015625);
    CreateDynamicObject(3594, 351.53570556641, -1640.1185302734, 32.308715820313, 356.64367675781, 0, 237.830078125);
    CreateDynamicObject(12957, 363.03973388672, -1653.1145019531, 32.5090675354, 359.97802734375, 359.97802734375, 155.62683105469);
    CreateDynamicObject(3593, 362.06301879883, -1644.3137207031, 32.439849853516, 0, 0, 9.7810974121094);
    CreateDynamicObject(12957, 384.34680175781, -1654.6763916016, 32.296501159668, 359.97802734375, 359.97802734375, 31.671417236328);
    CreateDynamicObject(3593, 373.92108154297, -1653.2800292969, 32.113544464111, 0, 0, 239.12785339355);
    CreateDynamicObject(3594, 371.51412963867, -1642.5294189453, 32.296798706055, 356.64367675781, 0, 331.62652587891);
    CreateDynamicObject(3593, 380.84912109375, -1644.6514892578, 32.201084136963, 0, 0, 316.17785644531);
    CreateDynamicObject(3594, 395.87466430664, -1656.1077880859, 30.234321594238, 356.64367675781, 0, 197.62225341797);
    CreateDynamicObject(12957, 398.21627807617, -1644.9654541016, 30.696868896484, 359.97802734375, 359.97802734375, 31.668090820313);
    CreateDynamicObject(3593, 391.6806640625, -1648.5639648438, 31.133491516113, 0, 0, 212.32556152344);
    CreateDynamicObject(3594, 402.70239257813, -1666.1242675781, 28.967714309692, 356.64367675781, 0, 257.92211914063);
    CreateDynamicObject(12957, 392.69659423828, -1662.1530761719, 30.898515701294, 359.97802734375, 359.97802734375, 31.668090820313);
    CreateDynamicObject(3594, 412.84524536133, -1667.0695800781, 27.225166320801, 356.64367675781, 0, 197.6220703125);
    CreateDynamicObject(3594, 426.13952636719, -1672.6264648438, 25.607669830322, 356.64367675781, 0, 197.6220703125);
    CreateDynamicObject(3594, 421.64822387695, -1649.7706298828, 26.21103477478, 356.64367675781, 0, 257.92053222656);
    CreateDynamicObject(3593, 407.5881652832, -1659.8186035156, 28.267822265625, 0, 0, 152.02166748047);
    CreateDynamicObject(12957, 406.29504394531, -1649.7825927734, 28.940488815308, 359.97802734375, 359.97802734375, 194.01812744141);
    CreateDynamicObject(3594, 421.8740234375, -1662.3890380859, 26.092262268066, 356.64367675781, 0, 23.421966552734);
    CreateDynamicObject(3593, 416.63192749023, -1654.7672119141, 26.607566833496, 0, 0, 28.067810058594);
    CreateDynamicObject(12957, 440.25433349609, -1671.0065917969, 25.418823242188, 359.97802734375, 359.97802734375, 194.01306152344);
    CreateDynamicObject(3594, 431.77777099609, -1661.8784179688, 24.975481033325, 356.64367675781, 0, 222.61737060547);
    CreateDynamicObject(3593, 433.79202270508, -1651.8321533203, 25.303918838501, 0, 0, 28.064575195313);
    CreateDynamicObject(3594, 446.40042114258, -1661.2329101563, 24.967113494873, 356.64367675781, 0, 257.92053222656);
    CreateDynamicObject(3593, 546.99267578125, -1591.5250244141, 15.717980384827, 0, 0, 157.44763183594);
    CreateDynamicObject(3594, 551.95971679688, -1578.6663818359, 15.638989448547, 0, 0, 319.80001831055);
    CreateDynamicObject(12957, 538.63122558594, -1579.2487792969, 15.886029243469, 0, 0, 202.54632568359);
    CreateDynamicObject(12957, 549.43176269531, -1607.8530273438, 16.17725944519, 0, 0, 266.19396972656);
    CreateDynamicObject(3593, 539.74938964844, -1614.4549560547, 16.012683868408, 0, 0, 244.54521179199);
    CreateDynamicObject(3594, 525.40368652344, -1611.6135253906, 15.623517990112, 0, 0, 150.74719238281);
    CreateDynamicObject(3594, 531.18249511719, -1621.0306396484, 15.924690246582, 0, 0, 266.20007324219);
    CreateDynamicObject(3593, 549.98022460938, -1619.3558349609, 16.36222076416, 0, 0, 157.44506835938);
    CreateDynamicObject(3594, 520.39337158203, -1622.6743164063, 16.372938156128, 0, 0, 132.44494628906);
    CreateDynamicObject(13591, 537.35845947266, -1629.7419433594, 15.787661552429, 0, 0, 219.29849243164);
    CreateDynamicObject(3594, 546.18328857422, -1633.8577880859, 16.664245605469, 0, 0, 266.19873046875);
    CreateDynamicObject(3593, 525.24053955078, -1632.8371582031, 16.686098098755, 0, 0, 113.89501953125);
    CreateDynamicObject(3594, 532.90563964844, -1640.2856445313, 17.076433181763, 0, 0, 319.79870605469);
    CreateDynamicObject(12957, 547.15765380859, -1645.884765625, 17.862968444824, 0, 0, 6.6932067871094);
    CreateDynamicObject(3594, 538.05749511719, -1649.0096435547, 17.620658874512, 0, 0, 142.24859619141);
    CreateDynamicObject(3593, 525.12231445313, -1649.6121826172, 17.734548568726, 0, 0, 247.89001464844);
    CreateDynamicObject(12957, 515.98901367188, -1633.7543945313, 17.076499938965, 0, 0, 6.690673828125);
    CreateDynamicObject(3593, 514.80895996094, -1654.5393066406, 18.221731185913, 0, 0, 190.93994140625);
    CreateDynamicObject(12957, 520.40283203125, -1671.3306884766, 18.478216171265, 0, 0, 6.690673828125);
    CreateDynamicObject(3594, 537.95367431641, -1678.4528808594, 18.08620262146, 0, 0, 28.345489501953);
    CreateDynamicObject(3593, 536.50189208984, -1664.8167724609, 18.241418838501, 0, 0, 160.78985595703);
    CreateDynamicObject(12957, 549.49090576172, -1663.9896240234, 17.959463119507, 0, 0, 346.59069824219);
    CreateDynamicObject(3594, 547.76477050781, -1674.0213623047, 18.381175994873, 0, 0, 142.24548339844);
    CreateDynamicObject(3594, 515.57391357422, -1660.1965332031, 18.085144042969, 0, 0, 108.74548339844);
    CreateDynamicObject(3594, 508.81362915039, -1668.5233154297, 18.143901824951, 0, 0, 142.24548339844);
    CreateDynamicObject(12957, 508.55804443359, -1676.8044433594, 18.668905258179, 0, 0, 202.54064941406);
    CreateDynamicObject(3594, 503.36535644531, -1653.6297607422, 18.943899154663, 0, 0, 209.2428894043);
    CreateDynamicObject(3593, 498.14303588867, -1661.4727783203, 19.009260177612, 6.7000122070313, 0, 80.386810302734);
    CreateDynamicObject(3594, 496.57431030273, -1671.1333007813, 19.47767829895, 0, 353.29992675781, 142.24548339844);
    CreateDynamicObject(3594, 488.33459472656, -1666.8930664063, 20.897727966309, 0, 3.3483276367188, 1.5455017089844);
    CreateDynamicObject(3593, 489.5094909668, -1654.9127197266, 21.038551330566, 3.2947692871094, 349.93319702148, 154.66607666016);
    CreateDynamicObject(3594, 479.453125, -1672.3586425781, 22.869174957275, 0, 3.3453369140625, 229.34375);
    CreateDynamicObject(3594, 476.28851318359, -1662.8468017578, 23.376651763916, 0, 359.99533081055, 138.88946533203);
    CreateDynamicObject(12957, 474.25903320313, -1652.1588134766, 24.389188766479, 0, 0, 202.53845214844);
    CreateDynamicObject(3594, 456.88427734375, -1656.4285888672, 24.967113494873, 356.64367675781, 0, 16.720397949219);
    CreateDynamicObject(3594, 461.45843505859, -1668.6390380859, 24.956716537476, 356.64367675781, 0, 16.715698242188);
// Puente (?) por ProTo
    CreateDynamicObject(3884, 2446.0073242188, -2056.4982910156, 22.197034835815, 356, 0, 72);
    CreateDynamicObject(3884, 2446.4174804688, -2042.2827148438, 22.214817047119, 356, 0, 104);
    CreateDynamicObject(3390, 2472.3388671875, -2041.3612060547, 23.652320861816, 0, 0, 96);
    CreateDynamicObject(3392, 2476.12890625, -2041.5225830078, 23.681621551514, 0, 0, 82);
    CreateDynamicObject(3394, 2468.6662597656, -2042.8034667969, 23.459602355957, 0, 0, 132);
    CreateDynamicObject(3397, 2474.3405761719, -2057.259765625, 23.675857543945, 0, 0, 268);
    CreateDynamicObject(3388, 2466.9104003906, -2041.1418457031, 23.485414505005, 0, 0, 270);
    CreateDynamicObject(3388, 2479.5795898438, -2041.2877197266, 23.77522277832, 0, 0, 260);
    CreateDynamicObject(3389, 2481.83203125, -2041.6683349609, 24.022802352905, 26, 0, 266);
    CreateDynamicObject(3386, 2476.6989746094, -2057.4348144531, 23.722578048706, 0, 0, 90);
    CreateDynamicObject(3387, 2483.1108398438, -2041.56640625, 23.860258102417, 332.29608154297, 9.0440368652344, 86.232147216797);
    CreateDynamicObject(2649, 2477.7854003906, -2057.9870605469, 24.305181503296, 0, 0, 0);
    CreateDynamicObject(12986, 2477.2858886719, -2049.130859375, 23.874153137207, 0, 0, 0);
    CreateDynamicObject(944, 2458.0651855469, -2056.2822265625, 23.891738891602, 0, 0, 257);
    CreateDynamicObject(944, 2458.7277832031, -2052.7416992188, 23.890130996704, 0, 358, 268);
    CreateDynamicObject(944, 2460.3813476563, -2055.0541992188, 23.906280517578, 0, 0, 294);
    CreateDynamicObject(944, 2456.0131835938, -2054.1774902344, 23.854415893555, 1.9951171875, 355.99758911133, 236.13955688477);
    CreateDynamicObject(944, 2457.8662109375, -2054.3764648438, 25.337621688843, 0, 0, 0);
    CreateDynamicObject(923, 2461.9177246094, -2057.3474121094, 24.202686309814, 0, 0, 0);
    CreateDynamicObject(3107, 2476.60546875, -2049.4379882813, 23.677331924438, 0, 0, 0);
    CreateDynamicObject(18451, 2497.2475585938, -2043.6925048828, 24.261655807495, 0, 0, 113.99996948242);
    CreateDynamicObject(1681, 2549.123046875, -2056.6630859375, 25.782987594604, 350.39111328125, 343.76611328125, 35.217498779297);
    CreateDynamicObject(1422, 2439.5869140625, -2052.8569335938, 22.589874267578, 0, 0, 272);
    CreateDynamicObject(1422, 2441.4399414063, -2050.6870117188, 22.589267730713, 0, 0, 205.99951171875);
    CreateDynamicObject(1422, 2439.7177734375, -2046.4195556641, 22.600471496582, 0, 0, 271.99951171875);
    CreateDynamicObject(1422, 2439.5490722656, -2042.8021240234, 22.736232757568, 0, 0, 261.99951171875);
    CreateDynamicObject(1422, 2439.5832519531, -2056.0493164063, 22.724306106567, 0, 0, 285.99951171875);
    CreateDynamicObject(874, 2509.0344238281, -2049.2333984375, 24.179628372192, 0, 0, 264);
    CreateDynamicObject(874, 2453.1005859375, -2049.1428222656, 22.969388961792, 1.75, 0, 268);
    CreateDynamicObject(874, 2478.5239257813, -2048.7895507813, 23.615243911743, 0, 0, 0);
    CreateDynamicObject(874, 2551.8354492188, -2052.9995117188, 24.741794586182, 0, 0, 270);
    CreateDynamicObject(746, 2549.3549804688, -2057.9675292969, 23.702007293701, 0, 0, 0);
    CreateDynamicObject(746, 2549.5051269531, -2056.0153808594, 23.190086364746, 0, 0, 0);
    CreateDynamicObject(746, 2546.3774414063, -2050.4392089844, 22.702959060669, 2, 0, 0);
    CreateDynamicObject(746, 2546.5224609375, -2052.3078613281, 22.644947052002, 0, 0, 0);
    CreateDynamicObject(746, 2551.6853027344, -2058.0246582031, 24.264326095581, 36, 0, 0);
    CreateDynamicObject(827, 2551.1430664063, -2054.8527832031, 25.649765014648, 0, 0, 0);
    CreateDynamicObject(4206, 2551.1958007813, -2046.4246826172, 24.109285354614, 0, 0, 0);
    CreateDynamicObject(1676, 2550.6645507813, -2056.63671875, 23.9504737854, 0, 105.99990844727, 133.99993896484);
    CreateDynamicObject(3461, 2549.578125, -2057.6469726563, 23.384256362915, 0, 0, 0);
    CreateDynamicObject(3461, 2548.5288085938, -2056.5891113281, 23.909208297729, 0, 0, 0);
    CreateDynamicObject(3461, 2550.3159179688, -2055.9899902344, 23.29986000061, 0, 0, 0);
    CreateDynamicObject(2985, 2496.4443359375, -2046.0559082031, 23.791984558105, 0, 0, 0);
    CreateDynamicObject(3115, 2551.0913085938, -2030.7678222656, 24.023609161377, 0.62399291992188, 0, 0);
    CreateDynamicObject(3115, 2570.7492675781, -2030.5434570313, 24.244302749634, 0.7198486328125, 358.73266601563, 1.2832336425781);
    CreateDynamicObject(854, 2557.7907714844, -2057.2485351563, 24.358867645264, 0, 0, 0);
    CreateDynamicObject(854, 2559.2377929688, -2055.8288574219, 24.313898086548, 0, 0, 0);
    CreateDynamicObject(849, 2561.2653808594, -2053.2177734375, 24.252813339233, 0, 0, 0);
    CreateDynamicObject(852, 2560.2434082031, -2054.5703125, 24.020275115967, 0, 0, 0);
    CreateDynamicObject(12957, 2564.32421875, -2045.1822509766, 24.455270767212, 0, 0, 315.23999023438);
    CreateDynamicObject(3593, 2540.0063476563, -2052.1765136719, 24.562143325806, 358.75051879883, 9.6308898925781, 51.152862548828);
    CreateDynamicObject(3594, 2578.8879394531, -2041.8349609375, 24.235681533813, 2.4845886230469, 11.4169921875, 269.26995849609);
    CreateDynamicObject(2985, 2540.4812011719, -2051.599609375, 23.880735397339, 0, 0, 27.881652832031);
    CreateDynamicObject(3268, 2559.9914550781, -2031.7746582031, 23.873687744141, 0, 358.73266601563, 90.567565917969);
    CreateDynamicObject(3578, 2574.3857421875, -2049.2646484375, 24.429302215576, 0, 0, 271.04699707031);
    CreateDynamicObject(934, 2548.2456054688, -2022.8322753906, 25.778301239014, 0, 0, 267.24487304688);
    CreateDynamicObject(943, 2546.0502929688, -2024.8359375, 25.218669891357, 0, 0, 0);
    CreateDynamicObject(958, 2552.3837890625, -2022.6437988281, 25.313316345215, 0, 0, 177.53466796875);
    CreateDynamicObject(959, 2552.4216308594, -2023.4265136719, 25.314609527588, 0, 0, 135.97534179688);
    CreateDynamicObject(1353, 2549.3674316406, -2025.5219726563, 25.115333557129, 0, 0, 0);
    CreateDynamicObject(1420, 2546.1691894531, -2026.9825439453, 24.452610015869, 0, 0, 0);
    CreateDynamicObject(1687, 2555.9670410156, -2022.6268310547, 25.240079879761, 0, 0, 0);
    CreateDynamicObject(2649, 2547.5402832031, -2025.4857177734, 24.931575775146, 0, 0, 0);
    CreateDynamicObject(3384, 2558.7436523438, -2022.5234375, 25.738265991211, 0, 0, 86.709350585938);
    CreateDynamicObject(925, 2547.9992675781, -2037.7506103516, 25.521251678467, 0, 0, 0);
    CreateDynamicObject(3761, 2545.9375, -2031.9310302734, 26.451313018799, 0, 0, 0);
    CreateDynamicObject(10576, 2547.3298339844, -2031.4752197266, 28.675699234009, 0, 0, 0);
    CreateDynamicObject(5463, 2562.2524414063, -2031.6649169922, 4.1932201385498, 0, 0, 0);
    CreateDynamicObject(3391, 2568.81640625, -2023.6154785156, 24.473754882813, 0, 358.73266601563, 91.55322265625);
    CreateDynamicObject(14600, 2570.4812011719, -2022.5986328125, 26.208274841309, 0, 0, 87.685638427734);
    CreateDynamicObject(1997, 2565.6374511719, -2024.0084228516, 24.497285842896, 0, 0, 0);
    CreateDynamicObject(1997, 2564.240234375, -2023.9578857422, 24.471925735474, 0, 0, 0);
    CreateDynamicObject(1997, 2562.6684570313, -2023.9616699219, 24.438005447388, 0, 0, 0);
    CreateDynamicObject(1715, 2569.5727539063, -2025.3394775391, 24.582317352295, 0, 0, 235.93664550781);
    CreateDynamicObject(1715, 2474.4938964844, -2056.0249023438, 23.659534454346, 0, 0, 0);
    CreateDynamicObject(1715, 2469.4689941406, -2043.7584228516, 23.557462692261, 9.1538696289063, 334.30242919922, 277.72048950195);
    CreateDynamicObject(1715, 2471.7990722656, -2042.4686279297, 23.598329544067, 0, 0, 151.68566894531);
    CreateDynamicObject(1715, 2476.0061035156, -2042.6337890625, 23.565879821777, 0, 0, 194.00201416016);
    CreateDynamicObject(874, 2468.4309082031, -2050.5122070313, 23.220506668091, 0, 1.267333984375, 261.41830444336);
    CreateDynamicObject(3594, 2489.9499511719, -2053.7917480469, 24.338855743408, 0, 0, 322.74499511719);
    CreateDynamicObject(874, 2529.576171875, -2048.3525390625, 24.538391113281, 0, 0, 85.406066894531);
    CreateDynamicObject(942, 2554.5251464844, -2055.2785644531, 25.209819793701, 77.524353027344, 293.72894287109, 68.297119140625);
    CreateDynamicObject(2672, 2549.265625, -2047.5821533203, 24.334106445313, 0, 0, 0);
    CreateDynamicObject(2675, 2542.1159667969, -2047.6981201172, 24.174774169922, 0, 0, 0);
    CreateDynamicObject(2673, 2539.9790039063, -2046.3485107422, 24.196336746216, 0, 0, 0);
    CreateDynamicObject(850, 2535.6982421875, -2052.2416992188, 24.211639404297, 0, 0, 0);
    CreateDynamicObject(854, 2519.4094238281, -2047.1257324219, 24.289152145386, 0, 0, 0);
    CreateDynamicObject(2677, 2514.43359375, -2052.4584960938, 24.341791152954, 0, 0, 0);
    CreateDynamicObject(2675, 2517.2700195313, -2050.8688964844, 24.150171279907, 0, 0, 0);
    CreateDynamicObject(2672, 2538.4692382813, -2056.2260742188, 24.556940078735, 0, 0, 0);
    CreateDynamicObject(2677, 2496.17578125, -2051.7780761719, 24.163516998291, 0, 0, 0);
    CreateDynamicObject(952, 2558.5905761719, -2053.2897949219, 25.263792037964, 0, 0, 34.46533203125);
    CreateDynamicObject(1449, 2575.0200195313, -2038.3712158203, 25.901058197021, 11.150604248047, 0.536376953125, 90.116577148438);
    CreateDynamicObject(1449, 2575.015625, -2038.3516845703, 25.056299209595, 11.528900146484, 357.94665527344, 90.628936767578);
//Gasolinera Idlewood por GROVE4L
    CreateDynamicObject(1676,1942.596,-1780.959,13.971,-25.783,0.0,45.000);
    CreateDynamicObject(1676,1941.642,-1769.242,14.221,0.0,15.470,90.000);
    CreateDynamicObject(3525,1936.721,-1767.337,11.602,0.0,0.0,0.0);
    CreateDynamicObject(3525,1939.669,-1771.413,11.602,0.0,0.0,0.0);
    CreateDynamicObject(3525,1941.191,-1775.542,11.960,0.0,0.0,56.250);
    CreateDynamicObject(3525,1937.404,-1784.341,11.635,0.0,0.0,90.000);
    CreateDynamicObject(3525,1930.154,-1778.761,11.791,0.0,0.0,146.250);
    CreateDynamicObject(3525,1932.930,-1774.617,11.577,0.0,0.0,146.250);
    CreateDynamicObject(12957,1929.056,-1783.108,13.250,0.0,0.0,-45.000);
    CreateDynamicObject(13591,1947.103,-1791.108,12.570,0.0,0.0,-33.750);
    CreateDynamicObject(3593,1948.853,-1775.510,12.907,0.0,0.0,56.250);
    CreateDynamicObject(3593,1949.193,-1763.712,12.957,0.0,0.0,146.250);
    CreateDynamicObject(3594,1944.563,-1763.625,13.014,-16.329,0.0,56.250);
    CreateDynamicObject(918,1929.859,-1786.088,12.918,0.0,0.0,56.250);
    CreateDynamicObject(918,1930.271,-1785.031,12.893,0.0,0.0,-22.500);
    CreateDynamicObject(918,1929.885,-1785.440,12.868,0.0,0.0,-101.250);
    CreateDynamicObject(918,1942.763,-1793.155,12.918,0.0,0.0,146.250);
    CreateDynamicObject(918,1942.328,-1792.578,12.918,0.0,0.0,146.250);
    CreateDynamicObject(918,1942.707,-1793.753,12.918,0.0,0.0,146.250);
    CreateDynamicObject(1244,1928.164,-1765.985,13.339,0.0,20.626,236.250);
    CreateDynamicObject(1244,1930.465,-1766.588,13.339,0.0,0.0,-45.000);
    CreateDynamicObject(3057,1929.124,-1766.761,12.933,0.0,0.0,-22.500);
    CreateDynamicObject(3525,1947.582,-1761.588,11.791,0.0,0.0,0.0);
    CreateDynamicObject(3525,1948.620,-1768.019,11.816,0.0,0.0,0.0);
    CreateDynamicObject(3525,1945.762,-1789.566,12.238,0.0,0.0,0.0);
    CreateDynamicObject(3525,1944.818,-1791.335,12.064,0.0,0.0,0.0);
    CreateDynamicObject(3525,1926.847,-1766.046,11.816,0.0,0.0,22.500);
    CreateDynamicObject(3525,1928.345,-1787.291,11.641,0.0,0.0,78.750);
    CreateDynamicObject(3525,1929.378,-1788.270,11.577,0.0,0.0,67.500);
    CreateDynamicObject(1257,1949.444,-1773.160,13.826,0.859,-67.036,101.250);
    CreateDynamicObject(850,1928.297,-1796.013,12.494,0.0,0.0,45.000);
    CreateDynamicObject(850,1924.297,-1789.238,12.494,0.0,0.0,-45.000);
    CreateDynamicObject(910,1933.715,-1795.906,13.816,0.0,0.0,0.0);
    CreateDynamicObject(852,1926.901,-1791.991,12.322,0.0,0.0,22.500);
    CreateDynamicObject(3593,1936.526,-1775.056,12.843,0.0,0.0,146.250);

// Calles alrededor del refugio L por GROVE4L
    CreateDynamicObject(12957,2552.769,-1736.655,13.061,0.0,0.0,45.000);
    CreateDynamicObject(12957,2610.652,-1730.406,11.620,-0.859,-3.438,168.750);
    CreateDynamicObject(12957,2593.053,-1720.648,9.783,71.333,-19.767,180.000);
    CreateDynamicObject(12957,2642.568,-1705.966,10.604,0.0,0.0,247.500);
    CreateDynamicObject(12957,2738.712,-1655.092,12.941,0.0,0.0,292.500);
    CreateDynamicObject(12957,2677.942,-1657.864,10.839,0.0,0.0,258.750);
    CreateDynamicObject(12957,2653.859,-1633.771,10.750,0.0,0.0,33.750);
    CreateDynamicObject(12957,2642.499,-1584.435,14.468,-10.313,-8.594,135.000);
    CreateDynamicObject(12957,2642.738,-1526.906,24.936,10.313,-8.594,22.500);
    CreateDynamicObject(12957,2650.442,-1467.911,30.360,0.0,0.0,135.000);
    CreateDynamicObject(12957,2594.933,-1436.400,33.850,0.0,0.0,348.750);
    CreateDynamicObject(12957,2509.449,-1428.276,28.238,0.0,0.0,337.500);
    CreateDynamicObject(12957,2447.589,-1449.477,23.878,0.0,0.0,56.250);
    CreateDynamicObject(12957,2446.910,-1425.646,23.706,0.0,0.0,123.750);
    CreateDynamicObject(12957,2482.085,-1447.206,25.314,-6.016,0.0,135.000);
    CreateDynamicObject(12957,2453.393,-1388.130,23.714,0.0,0.0,-11.250);
    CreateDynamicObject(12957,2453.894,-1339.169,23.714,0.0,0.0,33.750);
    CreateDynamicObject(12957,2447.771,-1277.710,23.704,0.0,0.0,-56.250);
    CreateDynamicObject(12957,2389.089,-1248.456,24.047,0.0,0.0,-135.000);
    CreateDynamicObject(12957,2417.470,-1255.075,23.703,0.0,0.0,-225.000);
    CreateDynamicObject(12957,2420.531,-1232.458,24.158,4.297,0.0,33.750);
    CreateDynamicObject(12957,2519.517,-1264.667,34.887,4.297,0.0,45.000);
    CreateDynamicObject(12957,2519.025,-1362.565,28.409,4.297,0.0,112.500);
    CreateDynamicObject(12957,2509.377,-1332.531,31.923,8.594,14.610,303.750);
    CreateDynamicObject(12957,2482.898,-1257.394,29.327,4.297,24.064,191.250);
    CreateDynamicObject(12957,2577.497,-1279.372,46.007,0.0,0.0,56.250);
    CreateDynamicObject(12957,2575.480,-1188.573,61.566,0.0,0.0,146.250);
    CreateDynamicObject(12957,2695.747,-1186.761,69.139,0.0,0.0,225.000);
    CreateDynamicObject(12957,2453.920,-1184.908,36.425,0.0,0.0,258.750);
    CreateDynamicObject(12957,2652.947,-1183.647,67.319,0.0,0.0,303.750);
    CreateDynamicObject(12957,2722.000,-1201.953,67.344,11.173,0.0,-6.093);
    CreateDynamicObject(12957,2737.146,-1240.350,60.478,11.173,0.0,27.657);
    CreateDynamicObject(12957,2681.103,-1259.811,54.034,11.173,0.0,-62.343);
    CreateDynamicObject(12957,2742.761,-1309.807,51.878,11.173,0.0,27.657);
    CreateDynamicObject(12957,2724.658,-1405.322,34.381,11.173,0.0,-354.843);
    CreateDynamicObject(12957,2724.286,-1379.740,39.153,2.578,-18.908,-276.093);
    CreateDynamicObject(12957,2735.416,-1546.871,25.299,2.578,-18.908,-276.093);
    CreateDynamicObject(12957,2722.117,-1588.679,13.446,2.578,-18.908,-298.593);
    CreateDynamicObject(12957,2697.587,-1506.732,30.323,0.0,0.0,45.000);
    CreateDynamicObject(12957,2679.622,-1406.249,30.356,0.0,0.0,112.500);
    CreateDynamicObject(12957,2674.043,-1474.719,30.276,0.0,0.0,-67.500);
    CreateDynamicObject(12957,2746.884,-1457.049,30.331,0.0,0.0,-67.500);
    CreateDynamicObject(12957,2728.337,-1477.597,30.159,0.0,0.0,-123.750);
    CreateDynamicObject(12957,2812.818,-1663.007,10.745,0.0,0.0,-157.500);
    CreateDynamicObject(12957,2801.795,-1649.459,10.744,0.0,0.0,-45.000);
    CreateDynamicObject(12957,2639.559,-1414.957,30.165,0.0,0.0,33.750);
    CreateDynamicObject(12957,2639.594,-1382.849,30.199,0.0,0.0,-112.500);
    CreateDynamicObject(12957,2642.227,-1330.599,37.695,-5.157,9.454,-135.000);
    CreateDynamicObject(12957,2640.733,-1178.191,53.767,-9.454,9.454,-135.000);
    CreateDynamicObject(12957,2642.122,-1119.648,66.355,-13.751,1.719,-168.750);
    CreateDynamicObject(12957,2648.143,-1056.511,68.957,0.0,0.0,45.000);
    CreateDynamicObject(12957,2638.164,-1077.610,69.031,0.0,0.0,-56.250);
    CreateDynamicObject(12957,2618.709,-1185.489,63.897,0.0,0.0,11.250);
    CreateDynamicObject(12957,2569.382,-1220.309,52.864,-17.189,0.859,202.500);
    CreateDynamicObject(12957,2563.542,-1252.761,45.861,0.0,0.0,11.250);
    CreateDynamicObject(12957,2571.986,-1313.819,41.757,3.438,-14.610,56.250);
    CreateDynamicObject(12957,2570.816,-1379.991,29.828,-14.610,-6.016,168.750);
    CreateDynamicObject(12957,2574.344,-1427.568,23.708,0.0,0.0,45.000);
    CreateDynamicObject(12957,2555.383,-1453.906,23.711,0.0,0.0,-11.250);
    CreateDynamicObject(12957,2534.089,-1493.448,23.903,0.0,0.0,56.250);
    CreateDynamicObject(12957,2554.365,-1508.817,23.913,0.0,0.0,-22.500);
    CreateDynamicObject(12957,2516.876,-1519.524,23.808,0.0,0.0,33.750);
    CreateDynamicObject(12957,2499.397,-1503.326,23.706,0.0,0.0,146.250);
    CreateDynamicObject(12957,2509.347,-1462.700,23.900,0.0,0.0,146.250);
    CreateDynamicObject(12957,2534.249,-1466.560,23.872,0.0,0.0,225.000);
    CreateDynamicObject(12957,2536.470,-1444.241,30.538,0.859,9.454,202.500);
    CreateDynamicObject(12957,2449.963,-1221.511,29.080,-3.438,-22.345,123.750);
    CreateDynamicObject(12957,2510.759,-1287.269,34.566,0.0,0.0,78.750);
    CreateDynamicObject(3594,2506.577,-1253.011,34.512,0.0,0.0,33.750);
    CreateDynamicObject(3594,2548.940,-1256.093,41.511,-9.454,6.875,135.000);
    CreateDynamicObject(3594,2601.003,-1256.289,46.600,0.0,0.0,33.750);
    CreateDynamicObject(3594,2567.084,-1288.670,45.342,0.0,0.0,157.500);
    CreateDynamicObject(3594,2572.705,-1341.067,36.918,-8.594,6.875,213.750);
    CreateDynamicObject(3594,2577.957,-1382.698,29.451,9.454,6.875,315.000);
    CreateDynamicObject(3594,2644.358,-1429.667,29.912,0.0,0.0,-11.250);
    CreateDynamicObject(3594,2607.989,-1450.513,32.419,0.0,0.0,56.250);
    CreateDynamicObject(3594,2573.118,-1445.663,34.361,0.0,0.0,-123.750);
    CreateDynamicObject(3594,2573.835,-1446.811,23.506,0.0,0.0,-101.250);
    CreateDynamicObject(3594,2489.277,-1462.884,23.477,0.0,0.0,-56.250);
    CreateDynamicObject(3594,2463.799,-1458.463,23.631,0.0,0.0,-56.250);
    CreateDynamicObject(3594,2443.717,-1413.261,23.631,0.0,0.0,45.000);
    CreateDynamicObject(3594,2460.853,-1413.370,23.390,0.0,0.0,90.000);
    CreateDynamicObject(3594,2441.449,-1357.960,23.631,0.0,0.0,45.000);
    CreateDynamicObject(3594,2460.270,-1309.151,23.631,0.0,0.0,-213.750);
    CreateDynamicObject(3594,2446.779,-1299.929,23.456,0.0,0.0,-157.500);
    CreateDynamicObject(3594,2407.890,-1242.537,23.444,0.0,0.0,-101.250);
    CreateDynamicObject(3594,2429.597,-1229.140,24.459,0.0,0.0,-157.500);
    CreateDynamicObject(3594,2406.709,-1227.093,23.590,0.0,0.0,-236.250);
    CreateDynamicObject(3594,2412.271,-1312.958,24.439,0.0,0.0,-315.000);
    CreateDynamicObject(3594,2410.560,-1264.580,23.737,0.0,0.0,-202.500);
    CreateDynamicObject(3594,2384.488,-1261.590,23.631,0.0,0.0,-22.500);
    CreateDynamicObject(3594,2457.050,-1436.615,23.616,0.0,0.0,292.500);
    CreateDynamicObject(3594,2522.010,-1436.255,28.149,0.0,0.0,56.250);
    CreateDynamicObject(3594,2502.456,-1451.077,28.162,0.0,0.0,-45.000);
    CreateDynamicObject(3594,2511.918,-1366.635,27.991,0.0,0.0,0.0);
    CreateDynamicObject(3594,2510.571,-1413.235,27.991,0.0,0.0,-225.000);
    CreateDynamicObject(3594,2507.001,-1325.110,32.708,-2.578,-10.313,-236.250);
    CreateDynamicObject(3594,2520.125,-1301.373,34.483,0.0,0.0,-33.750);
    CreateDynamicObject(3594,2385.258,-1178.143,27.429,0.0,0.0,-22.500);
    CreateDynamicObject(3594,2410.243,-1169.620,31.069,-10.313,0.0,67.500);
    CreateDynamicObject(3594,2500.316,-1182.918,46.380,-9.454,17.189,157.500);
    CreateDynamicObject(3594,2456.508,-1212.546,31.701,4.297,19.767,292.500);
    CreateDynamicObject(3594,2430.324,-1184.893,34.802,10.313,0.0,-56.250);
    CreateDynamicObject(3594,2534.636,-1187.844,57.868,10.313,0.0,67.500);
    CreateDynamicObject(3594,2557.513,-1190.384,61.142,0.0,0.0,45.000);
    CreateDynamicObject(3594,2617.144,-1176.515,63.611,0.0,0.0,-56.250);
    CreateDynamicObject(3594,2704.615,-1185.388,68.867,0.0,0.0,11.250);
    CreateDynamicObject(3594,2679.358,-1186.340,68.505,0.0,0.0,-67.500);
    CreateDynamicObject(3594,2575.508,-1205.306,58.442,14.610,5.157,-33.750);
    CreateDynamicObject(3594,2645.803,-1277.866,47.127,8.594,4.297,-22.500);
    CreateDynamicObject(3594,2646.800,-1362.733,31.598,1.719,-18.048,78.750);
    CreateDynamicObject(3594,2643.968,-1165.443,57.185,1.719,-18.048,78.750);
    CreateDynamicObject(3594,2647.924,-1230.181,49.649,0.0,0.0,-22.500);
    CreateDynamicObject(3594,2639.320,-1203.263,49.754,0.0,0.0,45.000);
    CreateDynamicObject(3594,2642.472,-1140.550,62.612,8.594,2.578,-45.000);
    CreateDynamicObject(3594,2643.657,-1095.467,69.080,0.0,0.0,45.000);
    CreateDynamicObject(3594,2634.785,-1059.789,69.242,0.0,0.0,135.000);
    CreateDynamicObject(3594,2745.114,-1193.034,68.776,0.0,0.0,33.750);
    CreateDynamicObject(3594,2741.470,-1206.583,66.106,4.297,-7.735,45.000);
    CreateDynamicObject(3594,2731.927,-1218.720,64.536,4.297,-7.735,-135.000);
    CreateDynamicObject(3594,2724.669,-1295.993,53.981,3.438,-5.157,67.500);
    CreateDynamicObject(3594,2723.403,-1414.474,32.806,3.438,-5.157,67.500);
    CreateDynamicObject(3594,2738.391,-1373.011,40.296,-6.016,5.157,225.000);
    CreateDynamicObject(3594,2737.536,-1339.871,46.280,-6.016,5.157,225.000);
    CreateDynamicObject(3594,2721.627,-1237.236,61.076,-6.016,5.157,225.000);
    CreateDynamicObject(3594,2738.571,-1274.568,57.782,-6.016,5.157,225.000);
    CreateDynamicObject(3594,2723.661,-1455.968,29.912,0.0,0.0,45.000);
    CreateDynamicObject(3594,2743.685,-1483.231,29.912,0.0,0.0,-56.250);
    CreateDynamicObject(3594,2707.844,-1509.764,29.958,0.0,0.0,45.000);
    CreateDynamicObject(3594,2740.460,-1513.315,29.912,0.0,0.0,-45.000);
    CreateDynamicObject(3594,2723.518,-1498.475,29.912,0.0,0.0,-168.750);
    CreateDynamicObject(3594,2679.198,-1484.763,30.044,0.0,0.0,-135.000);
    CreateDynamicObject(3594,2673.166,-1428.446,29.983,0.0,0.0,-90.000);
    CreateDynamicObject(3594,2652.389,-1398.113,29.912,0.0,0.0,-146.250);
    CreateDynamicObject(3594,2680.271,-1468.240,30.024,0.0,0.0,0.0);
    CreateDynamicObject(3594,2645.215,-1467.374,29.912,0.0,0.0,56.250);
    CreateDynamicObject(3594,2683.514,-1395.098,30.023,0.0,0.0,101.250);
    CreateDynamicObject(3594,2649.329,-1538.178,22.971,-0.859,-12.892,101.250);
    CreateDynamicObject(3594,2661.154,-1648.278,10.498,0.0,0.0,146.250);
    CreateDynamicObject(3594,2635.091,-1642.470,10.501,0.0,0.0,101.250);
    CreateDynamicObject(3594,2652.940,-1666.043,10.519,0.0,0.0,11.250);
    CreateDynamicObject(3594,2635.844,-1689.007,10.537,0.0,0.0,67.500);
    CreateDynamicObject(3594,2639.029,-1736.188,10.366,0.0,0.0,157.500);
    CreateDynamicObject(3594,2586.325,-1731.799,13.014,0.0,0.0,315.000);
    CreateDynamicObject(3594,2551.963,-1727.506,13.014,0.0,0.0,-180.000);
    CreateDynamicObject(3594,2722.102,-1652.607,12.694,0.0,0.0,-180.000);
    CreateDynamicObject(3594,2694.269,-1639.780,11.609,0.0,0.0,-112.500);
    CreateDynamicObject(3594,2789.182,-1661.507,10.481,0.0,0.0,-146.250);
    CreateDynamicObject(3594,2809.453,-1653.210,10.326,0.0,0.0,-247.500);
    CreateDynamicObject(3594,2723.747,-1615.408,12.475,0.0,0.0,-247.500);
    CreateDynamicObject(3594,2738.120,-1629.169,12.475,0.0,0.0,22.500);
    CreateDynamicObject(3594,2719.142,-1639.754,12.557,0.0,0.0,-45.000);
    CreateDynamicObject(3594,2721.055,-1564.291,20.081,-8.594,12.032,-123.750);
    CreateDynamicObject(3594,2742.005,-1560.833,21.120,12.892,12.032,-22.500);
    CreateDynamicObject(3594,2738.272,-1585.138,14.777,-8.594,12.032,-123.750);
    CreateDynamicObject(3594,2714.508,-1585.985,14.703,12.892,12.032,-56.250);
    CreateDynamicObject(3594,2742.933,-1498.220,30.084,0.0,0.0,67.500);
    CreateDynamicObject(3593,2446.019,-1250.867,23.280,0.0,0.0,56.250);
    CreateDynamicObject(3593,2451.845,-1266.694,23.458,-178.763,-0.859,146.250);
    CreateDynamicObject(3593,2579.668,-1263.228,45.860,-178.763,-0.859,236.250);
    CreateDynamicObject(3593,2564.028,-1433.996,23.710,-178.763,-0.859,326.250);
    CreateDynamicObject(3593,2514.827,-1474.555,23.720,-178.763,-0.859,315.000);
    CreateDynamicObject(3593,2565.782,-1490.417,23.732,-178.763,-0.859,225.000);
    CreateDynamicObject(3593,2528.879,-1520.734,23.623,-178.763,-0.859,270.000);
    CreateDynamicObject(3593,2490.390,-1508.999,23.538,-178.763,-0.859,213.750);
    CreateDynamicObject(3593,2505.673,-1511.096,23.410,0.0,0.0,33.750);
    CreateDynamicObject(3593,2539.373,-1502.334,23.366,0.0,0.0,-22.500);
    CreateDynamicObject(3593,2549.354,-1470.184,23.415,0.0,0.0,67.500);
    CreateDynamicObject(3593,2562.423,-1324.789,39.877,-12.032,0.859,157.500);
    CreateDynamicObject(3593,2572.512,-1233.697,48.579,12.032,-10.313,33.750);
    CreateDynamicObject(3593,2629.806,-1212.349,59.811,12.032,-10.313,33.750);
    CreateDynamicObject(3593,2646.989,-1307.311,41.817,9.454,-9.454,33.750);
    CreateDynamicObject(3593,2635.898,-1366.201,31.294,9.454,-9.454,33.750);
    CreateDynamicObject(3593,2730.260,-1564.396,20.485,9.454,-9.454,33.750);
    CreateDynamicObject(3593,2724.969,-1531.871,28.127,5.157,-6.875,33.750);
    CreateDynamicObject(3593,2737.014,-1417.618,32.069,5.157,-6.875,33.750);
    CreateDynamicObject(3593,2718.811,-1324.950,48.859,8.594,-6.875,33.750);
    CreateDynamicObject(3593,2724.723,-1221.952,63.630,8.594,-6.875,33.750);
    CreateDynamicObject(3593,2743.119,-1229.401,62.360,-5.157,-6.875,112.500);
    CreateDynamicObject(3593,2722.760,-1352.663,43.723,-5.157,-6.875,112.500);
    CreateDynamicObject(3593,2732.534,-1311.377,51.232,-5.157,-6.875,112.500);
    CreateDynamicObject(3593,2640.143,-1597.958,11.750,-5.157,-6.875,112.500);
    CreateDynamicObject(3593,2644.448,-1503.663,28.707,-5.157,-6.875,112.500);
    CreateDynamicObject(3593,2624.026,-1442.733,30.654,-3.438,-6.016,191.250);
    CreateDynamicObject(3593,2515.456,-1444.761,27.670,0.0,0.0,135.000);
    CreateDynamicObject(3593,2564.673,-1421.896,23.387,0.0,0.0,101.250);
    CreateDynamicObject(3593,2567.151,-1399.246,26.353,0.0,-10.313,101.250);
    CreateDynamicObject(3593,2578.655,-1296.870,45.053,0.0,-10.313,101.250);
    CreateDynamicObject(3593,2564.418,-1264.553,45.453,0.0,0.0,-45.000);
    CreateDynamicObject(3593,2511.364,-1266.784,34.225,0.0,0.0,-45.000);
    CreateDynamicObject(3593,2517.897,-1338.948,30.694,6.875,1.719,-33.750);
    CreateDynamicObject(3593,2518.017,-1397.326,27.941,0.0,0.0,33.750);
    CreateDynamicObject(3593,2496.624,-1386.991,28.275,0.0,0.0,-45.000);
    CreateDynamicObject(3593,2484.186,-1405.616,28.247,0.0,0.0,-123.750);
    CreateDynamicObject(3593,2480.913,-1428.190,28.204,0.0,0.0,-22.500);
    CreateDynamicObject(3593,2469.685,-1437.579,24.164,0.0,0.0,-22.500);
    CreateDynamicObject(3593,2463.569,-1424.544,23.185,0.0,0.0,-90.000);
    CreateDynamicObject(3593,2453.205,-1401.760,23.241,0.0,0.0,33.750);
    CreateDynamicObject(3593,2452.575,-1362.551,23.246,0.0,0.0,-22.500);
    CreateDynamicObject(3593,2447.304,-1324.034,23.210,0.0,0.0,-123.750);
    CreateDynamicObject(3593,2433.578,-1262.050,23.410,0.0,0.0,-157.500);
    CreateDynamicObject(3593,2399.162,-1257.905,23.214,0.0,0.0,-101.250);
    CreateDynamicObject(3593,2424.655,-1241.953,23.563,0.0,0.0,-123.750);
    CreateDynamicObject(3593,2411.222,-1235.680,23.208,0.0,0.0,-33.750);
    CreateDynamicObject(3593,2445.059,-1181.017,35.957,0.0,0.0,-33.750);
    CreateDynamicObject(3593,2569.817,-1178.695,61.244,0.0,0.0,-56.250);
    CreateDynamicObject(3593,2677.314,-1205.604,64.638,0.0,0.0,-56.250);
    CreateDynamicObject(3593,2696.677,-1210.606,65.192,19.767,-1.719,11.250);
    CreateDynamicObject(3593,2674.410,-1229.775,57.709,19.767,-1.719,22.500);
    CreateDynamicObject(3593,2650.810,-1197.377,65.750,7.735,-43.831,26.797);
    CreateDynamicObject(3593,2640.825,-1218.555,49.179,0.0,0.0,0.0);
    CreateDynamicObject(3593,2646.739,-1188.858,51.075,5.157,10.313,-33.750);
    CreateDynamicObject(3593,2635.771,-1102.274,68.417,0.0,0.0,-78.750);
    CreateDynamicObject(3593,2604.053,-1184.434,62.436,5.157,0.859,-78.750);
    CreateDynamicObject(3593,2517.910,-1192.472,53.163,11.173,0.859,-135.000);
    CreateDynamicObject(3593,2472.357,-1193.299,37.529,0.0,0.0,33.750);
    CreateDynamicObject(3593,2410.817,-1181.722,31.362,-8.594,0.0,33.750);
    CreateDynamicObject(3593,2442.776,-1206.142,33.760,-8.594,0.0,33.750);
    CreateDynamicObject(3593,2586.189,-1180.853,61.420,-178.763,-0.859,180.000);
    CreateDynamicObject(3593,2646.200,-1257.686,49.286,-178.763,-0.859,180.000);
    CreateDynamicObject(3593,2663.306,-1250.391,50.658,-8.594,-0.859,45.000);
    CreateDynamicObject(3593,2704.797,-1252.305,58.350,0.0,-0.859,315.000);
    CreateDynamicObject(3593,2673.892,-1266.506,52.928,0.0,-0.859,337.500);
    CreateDynamicObject(3593,2735.782,-1256.999,58.889,0.0,-0.859,90.000);
    CreateDynamicObject(12957,2724.229,-1275.338,57.884,11.173,0.0,-51.093);
    CreateDynamicObject(3593,2717.060,-1265.643,59.037,0.0,-0.859,123.750);
    CreateDynamicObject(11292,2517.474,-1269.232,49.572,0.0,0.0,0.0);
    CreateDynamicObject(11547,2663.177,-1259.718,52.763,11.173,-11.173,-45.000);
    CreateDynamicObject(1306,2519.506,-1358.399,33.102,-42.112,0.0,-135.000);
    CreateDynamicObject(3459,2563.097,-1370.913,37.775,-3.438,31.799,214.609);
    CreateDynamicObject(911,2534.587,-1382.224,38.596,0.0,0.0,-45.000);
    CreateDynamicObject(922,2533.789,-1379.605,38.915,0.0,0.0,-146.250);
    CreateDynamicObject(923,2532.849,-1384.067,38.910,0.0,0.0,-33.750);
    CreateDynamicObject(923,2532.892,-1384.066,39.682,0.0,0.0,-33.750);
    CreateDynamicObject(1333,2533.096,-1387.459,38.952,0.0,0.0,33.750);
    CreateDynamicObject(1332,2532.603,-1386.051,39.093,0.0,0.0,-33.750);
    CreateDynamicObject(1331,2532.703,-1387.077,40.434,-269.863,0.859,90.000);
    CreateDynamicObject(1346,2534.975,-1387.223,39.381,0.0,0.0,0.0);
    CreateDynamicObject(1346,2534.947,-1387.227,41.208,0.0,0.0,0.0);
    CreateDynamicObject(1346,2534.023,-1388.455,39.381,0.0,-29.221,-112.500);
    CreateDynamicObject(18259,2546.098,-1365.510,46.270,29.221,0.0,-22.500);
    CreateDynamicObject(1521,2520.000,-1271.573,47.339,0.0,0.0,0.0);
    CreateDynamicObject(1519,2517.326,-1271.801,47.346,0.0,0.0,0.0);
    CreateDynamicObject(1469,2514.736,-1271.752,47.387,0.0,0.0,0.0);
    CreateDynamicObject(1383,2515.323,-1268.443,15.685,0.0,0.0,0.0);
    CreateDynamicObject(1393,2514.198,-1271.499,49.116,-40.394,-3.438,-11.250);
    CreateDynamicObject(1393,2520.452,-1271.527,49.110,-40.394,-3.438,-11.250);
    CreateDynamicObject(925,2519.520,-1268.172,49.453,0.0,0.0,-56.250);
    CreateDynamicObject(944,2523.160,-1269.021,52.650,0.0,0.0,33.750);
    CreateDynamicObject(964,2514.041,-1268.293,48.366,0.0,0.0,45.000);
    CreateDynamicObject(1348,2526.332,-1269.048,52.468,0.0,0.0,90.000);
    CreateDynamicObject(2678,2750.008,-1323.706,50.220,0.0,0.0,-146.250);
    CreateDynamicObject(2669,2752.679,-1324.489,50.340,0.0,0.0,-90.000);
    CreateDynamicObject(2679,2748.686,-1326.089,49.006,-90.241,0.0,-135.000);
    CreateDynamicObject(3568,2650.237,-1328.966,38.901,-168.450,-85.944,-45.000);
    CreateDynamicObject(2675,2749.352,-1328.786,49.061,0.0,0.0,0.0);
    CreateDynamicObject(1558,2754.350,-1323.741,49.697,0.0,0.0,0.0);
    CreateDynamicObject(1440,2750.953,-1327.547,49.519,0.0,0.0,-135.000);
    CreateDynamicObject(1299,2744.815,-1318.503,50.112,0.0,0.0,33.750);
    CreateDynamicObject(960,2753.803,-1325.073,49.479,0.0,0.0,22.500);
    CreateDynamicObject(2906,2752.981,-1323.981,49.147,0.0,0.0,45.000);
    CreateDynamicObject(2906,2748.371,-1323.548,48.999,0.0,0.0,135.000);
    CreateDynamicObject(2905,2750.518,-1325.209,49.214,0.0,0.0,45.000);
    CreateDynamicObject(2905,2746.085,-1318.363,49.773,0.0,0.0,-33.750);
    CreateDynamicObject(2908,2751.238,-1327.620,49.605,0.0,0.0,-56.250);
    CreateDynamicObject(2908,2750.940,-1323.703,49.200,0.0,0.0,-56.250);
    CreateDynamicObject(2907,2748.685,-1327.328,49.057,0.0,0.0,-56.250);
    CreateDynamicObject(2907,2745.089,-1321.689,49.067,-8.594,178.763,-135.000);
    CreateDynamicObject(2909,2512.312,-1260.436,33.920,-180.482,90.241,83.288);
    CreateDynamicObject(2908,2518.352,-1269.203,48.444,0.0,0.0,0.0);
    CreateDynamicObject(2908,2520.495,-1270.292,48.444,0.0,0.0,-78.750);
    CreateDynamicObject(2908,2514.519,-1271.650,48.459,0.0,0.0,-157.500);
    CreateDynamicObject(2907,2514.914,-1269.880,48.401,0.0,0.0,56.250);

// Ruta Rodeo por bytytus
    CreateDynamicObject(3594, 155.46197509766, -1545.9204101563, 10.285360336304, 0, 0, 30);
    CreateDynamicObject(3594, 169.45794677734, -1543.8518066406, 11.908321380615, 0, 0, 29.998168945313);
    CreateDynamicObject(3594, 177.53898620605, -1529.9552001953, 12.051731109619, 0, 0, 0);
    CreateDynamicObject(3594, 164.59745788574, -1523.2145996094, 11.706060409546, 0, 0, 159.99993896484);
    CreateDynamicObject(3594, 191.95321655273, -1506.6896972656, 12.208680152893, 0, 0, 64);
    CreateDynamicObject(3594, 189.86164855957, -1489.5729980469, 12.229825973511, 0, 0, 63.995361328125);
    CreateDynamicObject(3594, 200.33547973633, -1490.0705566406, 12.375371932983, 0, 0, 63.995361328125);
    CreateDynamicObject(3594, 203.16600036621, -1470.73828125, 12.449439048767, 0, 0, 63.995361328125);
    CreateDynamicObject(3594, 212.63343811035, -1479.9837646484, 12.558218002319, 0, 0, 63.995361328125);
    CreateDynamicObject(13591, 197.2721862793, -1438.2478027344, 12.515795707703, 0, 4, 318);
    CreateDynamicObject(13591, 211.61981201172, -1423.2890625, 12.503486633301, 0, 0, 315.99975585938);
    CreateDynamicObject(3594, 218.22676086426, -1430.3077392578, 12.9028673172, 0, 0, 314);
    CreateDynamicObject(3594, 204.67337036133, -1444.5045166016, 12.725830078125, 0, 4, 321.99475097656);
    CreateDynamicObject(3594, 217.12002563477, -1458.7297363281, 12.652997970581, 0, 0, 313.99475097656);
    CreateDynamicObject(3594, 234.4094543457, -1444.6363525391, 12.865795135498, 0, 0, 263.99475097656);
    CreateDynamicObject(3594, 236.38282775879, -1446.7655029297, 12.893035888672, 0, 26, 263.99047851563);
    CreateDynamicObject(3594, 254.91217041016, -1435.9069824219, 13.105263710022, 0, 0, 0);
    CreateDynamicObject(3594, 259.43463134766, -1418.8637695313, 13.148334503174, 0, 0, 0);
    CreateDynamicObject(3594, 277.01248168945, -1407.1540527344, 13.308072090149, 0, 0, 62);
    CreateDynamicObject(3594, 272.91793823242, -1425.1585693359, 13.292201042175, 0, 0, 0);
    CreateDynamicObject(3594, 298.09732055664, -1395.9119873047, 13.495055198669, 0, 0, 292);
    CreateDynamicObject(3594, 297.95886230469, -1413.8034667969, 13.519879341125, 0, 0, 291.99462890625);
    CreateDynamicObject(3594, 312.39367675781, -1396.0031738281, 13.619483947754, 0, 0, 291.99462890625);
    CreateDynamicObject(3594, 318.87844848633, -1391.7365722656, 13.667786598206, 0, 0, 291.99462890625);
    CreateDynamicObject(3594, 325.45581054688, -1387.9760742188, 13.718020439148, 0, 0, 291.99462890625);
    CreateDynamicObject(3594, 335.75512695313, -1394.1964111328, 13.815356254578, 0, 0, 0);
    CreateDynamicObject(3594, 365.96411132813, -1375.7163085938, 13.992055892944, 0, 0, 291.99462890625);
    CreateDynamicObject(3594, 348.07565307617, -1376.904296875, 13.89551448822, 0, 0, 0);
    CreateDynamicObject(3594, 394.85537719727, -1347.9508056641, 14.243685722351, 0, 0, 291.99462890625);
    CreateDynamicObject(3594, 410.77578735352, -1351.0106201172, 14.322021484375, 0, 0, 291.99462890625);
    CreateDynamicObject(3594, 377.83963012695, -1364.2318115234, 14.12113571167, 0, 0, 205.99462890625);
    CreateDynamicObject(13591, 345.30017089844, -1357.1003417969, 13.720129013062, 358, 0, 297.99996948242);
    CreateDynamicObject(3594, 341.72845458984, -1350.6901855469, 14.138989448547, 0, 0, 300);
    CreateDynamicObject(3594, 340.25427246094, -1348.3890380859, 14.138989448547, 0, 0, 299.99816894531);
    CreateDynamicObject(3594, 338.96109008789, -1345.9965820313, 14.138989448547, 0, 0, 299.99816894531);
    CreateDynamicObject(3594, 337.65631103516, -1343.6041259766, 14.138989448547, 0, 0, 299.99816894531);
    CreateDynamicObject(3594, 336.48132324219, -1341.1333007813, 14.138989448547, 0, 0, 299.99816894531);
    CreateDynamicObject(2676, 409.19400024414, -1354.1365966797, 13.848382949829, 0, 0, 0);
    CreateDynamicObject(2676, 412.89294433594, -1349.1938476563, 13.868602752686, 0, 0, 0);
    CreateDynamicObject(2676, 397.35650634766, -1345.5158691406, 13.732325553894, 0, 0, 0);
    CreateDynamicObject(2676, 392.98574829102, -1350.4844970703, 13.702900886536, 0, 0, 0);
    CreateDynamicObject(2676, 377.58609008789, -1360.1752929688, 13.581092834473, 0, 0, 0);
    CreateDynamicObject(2676, 378.09283447266, -1368.2451171875, 13.603709220886, 0, 0, 0);
    CreateDynamicObject(2676, 367.91400146484, -1373.1986083984, 13.526317596436, 0, 0, 0);
    CreateDynamicObject(2676, 363.54846191406, -1378.3529052734, 13.498238563538, 0, 0, 0);
    CreateDynamicObject(2676, 349.64367675781, -1380.748046875, 13.382201194763, 0, 0, 0);
    CreateDynamicObject(2676, 347.09420776367, -1372.7028808594, 13.35044670105, 0, 0, 0);
    CreateDynamicObject(2676, 334.44451904297, -1396.7554931641, 14.172991752625, 0, 0, 0);
    CreateDynamicObject(2676, 337.21936035156, -1390.7185058594, 13.295972824097, 0, 0, 0);
    CreateDynamicObject(2676, 329.72979736328, -1387.8280029297, 13.228336334229, 0, 0, 0);
    CreateDynamicObject(2676, 320.39608764648, -1386.2513427734, 13.15133190155, 0, 0, 0);
    CreateDynamicObject(2676, 319.13275146484, -1393.91015625, 13.147468566895, 0, 0, 0);
    CreateDynamicObject(2676, 306.13021850586, -1397.5557861328, 13.039357185364, 0, 0, 0);
    CreateDynamicObject(2676, 294.02426147461, -1395.0845947266, 13.08752822876, 0, 0, 0);
    CreateDynamicObject(2677, 329.85192871094, -1405.7756347656, 13.585350036621, 0, 0, 0);
    CreateDynamicObject(2677, 328.35308837891, -1398.8195800781, 13.407911300659, 0, 0, 0);
    CreateDynamicObject(2677, 302.35607910156, -1414.3917236328, 13.196027755737, 0, 0, 0);
    CreateDynamicObject(2677, 293.595703125, -1413.9020996094, 13.12407875061, 0, 0, 0);
    CreateDynamicObject(2677, 295.71484375, -1398.74609375, 13.116061210632, 0, 0, 0);
    CreateDynamicObject(2677, 284.31121826172, -1399.5650634766, 13.184845924377, 0, 0, 0);
    CreateDynamicObject(2677, 300.55258178711, -1405.244140625, 13.362248420715, 0, 0, 0);
    CreateDynamicObject(2677, 357.3840637207, -1379.4643554688, 13.613541603088, 0, 0, 0);
    CreateDynamicObject(2677, 274.27032470703, -1429.0994873047, 13.118834495544, 0, 0, 0);
    CreateDynamicObject(2677, 279.31704711914, -1410.525390625, 12.974667549133, 0, 0, 0);
    CreateDynamicObject(2677, 274.4245300293, -1403.9354248047, 13.085052490234, 0, 0, 0);
    CreateDynamicObject(2677, 286.99530029297, -1424.8109130859, 13.239903450012, 0, 0, 0);
    CreateDynamicObject(2677, 274.53540039063, -1421.6618652344, 12.936135292053, 0, 0, 0);
    CreateDynamicObject(2677, 260.27774047852, -1422.9342041016, 12.795794487, 0, 0, 0);
    CreateDynamicObject(2677, 260.2255859375, -1415.0240478516, 12.793685913086, 0, 0, 0);
    CreateDynamicObject(2677, 256.11770629883, -1431.8493652344, 12.751420974731, 0, 0, 0);
    CreateDynamicObject(2677, 252.83489990234, -1439.9187011719, 12.739344596863, 0, 0, 0);
    CreateDynamicObject(2677, 263.85876464844, -1440.802734375, 13.01008605957, 0, 0, 0);
    CreateDynamicObject(2677, 239.03932189941, -1423.7886962891, 12.732516288757, 0, 0, 0);
    CreateDynamicObject(2677, 247.71063232422, -1428.2825927734, 12.660849571228, 0, 0, 0);
    CreateDynamicObject(2677, 231.20967102051, -1442.5338134766, 12.466292381287, 0, 0, 0);
    CreateDynamicObject(2677, 240.11390686035, -1447.7001953125, 12.582494735718, 0, 0, 0);
    CreateDynamicObject(2677, 208.78021240234, -1438.30078125, 12.432373046875, 0, 0, 0);
    CreateDynamicObject(2677, 223.57167053223, -1421.4465332031, 12.624871253967, 0, 0, 0);
    CreateDynamicObject(2677, 217.83750915527, -1443.5733642578, 12.478307723999, 0, 0, 0);
    CreateDynamicObject(2677, 222.20945739746, -1428.8531494141, 12.582814216614, 0, 0, 0);
    CreateDynamicObject(2677, 196.99032592773, -1449.0789794922, 12.282830238342, 0, 0, 0);
    CreateDynamicObject(2677, 196.83386230469, -1431.9063720703, 12.382329940796, 0, 0, 0);
    CreateDynamicObject(2677, 203.69372558594, -1448.72265625, 12.334029197693, 0, 0, 0);
    CreateDynamicObject(2677, 218.92709350586, -1455.396484375, 12.320801734924, 0, 0, 0);
    CreateDynamicObject(2677, 215.80931091309, -1461.3491210938, 13.333750724792, 0, 0, 0);
    CreateDynamicObject(2677, 218.38034057617, -1475.8037109375, 12.288316726685, 0, 0, 0);
    CreateDynamicObject(2677, 227.4429473877, -1469.3117675781, 12.578440666199, 0, 0, 0);
    CreateDynamicObject(2677, 203.00814819336, -1470.9515380859, 13.098973274231, 0, 0, 0);
    CreateDynamicObject(2677, 198.21928405762, -1465.2584228516, 12.196166992188, 0, 0, 0);
    CreateDynamicObject(2677, 210.07504272461, -1477.7021484375, 12.170645713806, 0, 0, 0);
    CreateDynamicObject(2677, 215.24052429199, -1483.3436279297, 12.398169517517, 0, 0, 0);
    CreateDynamicObject(2677, 197.55575561523, -1480.0159912109, 11.998342514038, 0, 0, 0);
    CreateDynamicObject(2677, 204.66772460938, -1478.1580810547, 12.291439056396, 0, 0, 0);
    CreateDynamicObject(2677, 204.48272705078, -1491.1065673828, 12.070327758789, 0, 0, 0);
    CreateDynamicObject(2677, 196.04187011719, -1489.4307861328, 12.146332740784, 0, 0, 0);
    CreateDynamicObject(2677, 186.85731506348, -1486.5240478516, 11.99526309967, 0, 0, 0);
    CreateDynamicObject(2677, 192.09747314453, -1493.203125, 11.894422531128, 0, 0, 0);
    CreateDynamicObject(2677, 186.29216003418, -1499.6535644531, 11.789800643921, 0, 0, 0);
    CreateDynamicObject(2677, 195.24536132813, -1507.0836181641, 11.895509719849, 0, 0, 0);
    CreateDynamicObject(2677, 187.90919494629, -1506.5207519531, 11.795250892639, 0, 0, 0);
    CreateDynamicObject(2677, 199.6125793457, -1525.5648193359, -39.383506774902, 0, 0, 0);
    CreateDynamicObject(2677, 200.65501403809, -1501.4111328125, 11.991675376892, 0, 0, 0);
    CreateDynamicObject(2677, 182.87408447266, -1526.4908447266, 19.873338699341, 0, 0, 0);
    CreateDynamicObject(2677, 177.01634216309, -1525.8043212891, 11.609973907471, 0, 0, 0);
    CreateDynamicObject(2677, 167.75050354004, -1522.0816650391, 11.453207969666, 0, 0, 0);
    CreateDynamicObject(2677, 160.98948669434, -1525.9332275391, 11.38787651062, 0, 0, 0);
    CreateDynamicObject(2677, 173.29544067383, -1546.7381591797, 11.975354194641, 0, 0, 0);
    CreateDynamicObject(2677, 165.86137390137, -1541.3873291016, 11.306018829346, 0, 0, 0);
    CreateDynamicObject(2677, 159.43383789063, -1548.8455810547, 10.33127784729, 0, 0, 0);
    CreateDynamicObject(2677, 150.54705810547, -1546.2783203125, 9.3657579421997, 0, 0, 0);
    CreateDynamicObject(2677, 164.89344787598, -1554.4013671875, 10.916445732117, 0, 0, 0);
    CreateDynamicObject(2677, 161.03837585449, -1530.3345947266, 19.113103866577, 0, 0, 0);
    CreateDynamicObject(2677, 170.59790039063, -1532.3039550781, 11.834932327271, 0, 0, 0);
    CreateDynamicObject(2677, 172.59063720703, -1508.5301513672, 11.723669052124, 0, 0, 0);
    CreateDynamicObject(1328, 187.19483947754, -1527.7758789063, 12.212554931641, 0, 0, 0);
    CreateDynamicObject(1328, 186.45184326172, -1529.0590820313, 12.217227935791, 0, 0, 0);
    CreateDynamicObject(1328, 186.32830810547, -1528.2277832031, 12.180094718933, 0, 0, 0);
    CreateDynamicObject(2674, 187.10646057129, -1528.7238769531, 11.771463394165, 0, 0, 0);
    CreateDynamicObject(2674, 183.86988830566, -1529.2177734375, 11.610989570618, 0, 0, 0);
    CreateDynamicObject(2674, 185.80024719238, -1525.9791259766, 11.446400642395, 0, 0, 0);
    CreateDynamicObject(2675, 179.53828430176, -1495.3559570313, 11.660404205322, 0, 0, 0);
    CreateDynamicObject(2675, 181.44609069824, -1491.3192138672, 11.699228286743, 0, 0, 0);
    CreateDynamicObject(1227, 179.68858337402, -1493.3374023438, 12.461841583252, 0, 2, 56);
    CreateDynamicObject(3461, 156.49514770508, -1548.0662841797, 8.8844127655029, 0, 0, 0);
    CreateDynamicObject(3461, 170.43051147461, -1545.8944091797, 10.275515556335, 0, 0, 0);
    CreateDynamicObject(3461, 177.3257598877, -1532.2165527344, 10.646326065063, 0, 0, 0);
    CreateDynamicObject(3461, 165.5185546875, -1521.0969238281, 10.298889160156, 0, 0, 0);
    CreateDynamicObject(3461, 194.02407836914, -1507.8175048828, 10.503197669983, 0, 0, 0);
    CreateDynamicObject(3461, 191.82606506348, -1490.8192138672, 10.905081748962, 0, 0, 0);
    CreateDynamicObject(3461, 202.27182006836, -1491.2513427734, 10.744722366333, 0, 0, 0);
    CreateDynamicObject(3461, 214.58140563965, -1481.0756835938, 11.095827102661, 0, 0, 0);
    CreateDynamicObject(3461, 205.1535949707, -1471.6956787109, 10.915470123291, 0, 0, 0);
    CreateDynamicObject(3461, 215.57121276855, -1460.1849365234, 11.086827278137, 0, 0, 0);
    CreateDynamicObject(3461, 232.14260864258, -1444.3200683594, 11.032450675964, 0, 0, 0);
    CreateDynamicObject(3461, 216.50494384766, -1431.9094238281, 11.525279998779, 0, 0, 0);
    CreateDynamicObject(3461, 203.21368408203, -1446.2690429688, 11.197423934937, 0, 0, 0);
    CreateDynamicObject(3461, 213.46592712402, -1422.0408935547, 11.154813766479, 0, 0, 0);
    CreateDynamicObject(3461, 211.81576538086, -1420.6326904297, 10.948452949524, 0, 0, 0);
    CreateDynamicObject(3461, 209.9938659668, -1419.0623779297, 10.818835258484, 0, 0, 0);
    CreateDynamicObject(3461, 192.84100341797, -1437.1873779297, 11.398719787598, 0, 0, 0);
    CreateDynamicObject(3461, 194.51455688477, -1438.4724121094, 11.165368080139, 0, 0, 0);
    CreateDynamicObject(3461, 196.62864685059, -1439.7841796875, 11.06506729126, 0, 0, 0);
    CreateDynamicObject(3461, 254.71589660645, -1438.1376953125, 11.822063446045, 0, 0, 0);
    CreateDynamicObject(3461, 259.29425048828, -1421.0823974609, 11.211100578308, 0, 0, 0);
    CreateDynamicObject(3461, 272.72094726563, -1427.3289794922, 11.955542564392, 0, 0, 0);
    CreateDynamicObject(3461, 278.79489135742, -1408.3255615234, 11.893741607666, 0, 0, 0);
    CreateDynamicObject(3461, 295.93118286133, -1396.7193603516, 12.063930511475, 0, 0, 0);
    CreateDynamicObject(3461, 310.23968505859, -1396.7734375, 12.26024723053, 0, 0, 0);
    CreateDynamicObject(3461, 316.54119873047, -1392.5075683594, 12.195529937744, 0, 0, 0);
    CreateDynamicObject(3461, 323.30078125, -1388.6756591797, 12.359272003174, 0, 0, 0);
    CreateDynamicObject(3461, 335.55178833008, -1396.2637939453, 12.32309627533, 0, 0, 0);
    CreateDynamicObject(3461, 347.85778808594, -1379.1337890625, 12.388537406921, 0, 0, 0);
    CreateDynamicObject(3461, 363.73785400391, -1376.4545898438, 12.537432670593, 0, 0, 0);
    CreateDynamicObject(3461, 339.66635131836, -1351.7762451172, 12.682584762573, 0, 0, 0);
    CreateDynamicObject(3461, 338.23162841797, -1349.423828125, 12.402539253235, 0, 0, 0);
    CreateDynamicObject(3461, 336.99835205078, -1346.9467773438, 12.725290298462, 0, 0, 0);
    CreateDynamicObject(3461, 335.74395751953, -1344.4904785156, 12.847693443298, 0, 0, 0);
    CreateDynamicObject(3461, 334.52899169922, -1342.0983886719, 12.47412109375, 0, 0, 0);
    CreateDynamicObject(3461, 342.77328491211, -1356.2583007813, 12.238723754883, 0, 0, 0);
    CreateDynamicObject(3461, 376.82366943359, -1362.0516357422, 12.622035980225, 0, 0, 0);
    CreateDynamicObject(3461, 392.63989257813, -1348.6264648438, 12.840360641479, 0, 0, 0);
    CreateDynamicObject(3461, 408.67471313477, -1351.7185058594, 12.858892440796, 0, 0, 0);
    CreateDynamicObject(3594, 412.15710449219, -1335.8933105469, 14.370320320129, 0, 0, 291.99462890625);
    CreateDynamicObject(3594, 430.361328125, -1340.3818359375, 14.547164916992, 0, 0, 291.99462890625);
    CreateDynamicObject(3594, 432.89651489258, -1321.8669433594, 14.535995483398, 0, 0, 291.99462890625);
    CreateDynamicObject(3594, 453.5537109375, -1324.1815185547, 14.752371788025, 0, 0, 291.99462890625);
    CreateDynamicObject(3594, 455.79089355469, -1305.8803710938, 14.753848075867, 0, 0, 291.99462890625);
    CreateDynamicObject(3594, 470.56015014648, -1312.7381591797, 14.918667793274, 0, 0, 291.99462890625);
    CreateDynamicObject(3461, 468.55545043945, -1313.3366699219, 13.451862335205, 0, 0, 0);
    CreateDynamicObject(3461, 453.39413452148, -1306.6597900391, 13.360837936401, 0, 0, 0);
    CreateDynamicObject(3461, 451.55407714844, -1324.916015625, 13.034469604492, 0, 0, 0);
    CreateDynamicObject(3461, 430.65655517578, -1322.5765380859, 13.208379745483, 0, 0, 0);
    CreateDynamicObject(3461, 409.99911499023, -1336.6811523438, 12.912490844727, 0, 0, 0);
    CreateDynamicObject(3461, 428.00534057617, -1341.2142333984, 13.025356292725, 0, 0, 0);
    CreateDynamicObject(2677, 466.98315429688, -1312.576171875, 14.523229598999, 0, 0, 0);
    CreateDynamicObject(2677, 474.65447998047, -1312.1999511719, 14.653635025024, 0, 0, 0);
    CreateDynamicObject(2677, 459.63470458984, -1305.9268798828, 14.446650505066, 0, 0, 0);
    CreateDynamicObject(2677, 451.42855834961, -1305.0364990234, 14.516833305359, 0, 0, 0);
    CreateDynamicObject(2677, 466.83520507813, -1305.5673828125, 14.516484260559, 0, 0, 0);
    CreateDynamicObject(2677, 463.07757568359, -1293.3863525391, 14.643592834473, 0, 0, 0);
    CreateDynamicObject(2677, 446.66046142578, -1315.5385742188, 14.313769340515, 0, 0, 0);
    CreateDynamicObject(2677, 452.30645751953, -1312.4842529297, 14.372143745422, 0, 0, 0);
    CreateDynamicObject(2677, 457.97024536133, -1323.9104003906, 14.428369522095, 0, 0, 0);
    CreateDynamicObject(2677, 449.4377746582, -1323.5172119141, 14.351818084717, 0, 0, 0);
    CreateDynamicObject(2677, 429.73992919922, -1325.0803222656, 14.152812004089, 0, 0, 0);
    CreateDynamicObject(2677, 435.7649230957, -1318.9715576172, 14.214817047119, 0, 0, 0);
    CreateDynamicObject(2677, 433.31680297852, -1337.392578125, 14.210254669189, 0, 0, 0);
    CreateDynamicObject(2677, 427.53460693359, -1344.1325683594, 14.165844917297, 0, 0, 0);
    CreateDynamicObject(2677, 410.58966064453, -1338.8208007813, 13.999961853027, 0, 0, 0);
    CreateDynamicObject(2677, 413.67620849609, -1332.9635009766, 14.021157264709, 0, 0, 0);
    CreateDynamicObject(2677, 416.48226928711, -1343.8581542969, 14.073629379272, 0, 0, 0);
    CreateDynamicObject(2677, 421.3952331543, -1332.0521240234, 14.09619140625, 0, 0, 0);
    CreateDynamicObject(2677, 440.29843139648, -1332.0432128906, 14.264170646667, 0, 0, 0);
    CreateDynamicObject(2677, 388.49285888672, -1365.2430419922, 13.857623100281, 0, 0, 0);
    CreateDynamicObject(2677, 395.5107421875, -1357.8873291016, 13.912022590637, 0, 0, 0);
    CreateDynamicObject(2677, 404.01068115234, -1357.6541748047, 13.98069858551, 0, 0, 0);
    CreateDynamicObject(2676, 383.29443359375, -1352.1142578125, 13.616902351379, 0, 0, 0);
    CreateDynamicObject(2676, 386.61874389648, -1344.0767822266, 13.808199882507, 0, 0, 0);
    CreateDynamicObject(2676, 352.99096679688, -1388.6530761719, 13.434369087219, 0, 0, 0);
    CreateDynamicObject(2676, 342.61709594727, -1384.8303222656, 13.330665588379, 0, 0, 0);
    CreateDynamicObject(2676, 337.71173095703, -1377.9801025391, 13.283917427063, 0, 0, 0);
    CreateDynamicObject(2676, 317.89657592773, -1405.3555908203, 13.160074234009, 0, 0, 0);
    CreateDynamicObject(2676, 367.34582519531, -1361.8276367188, 13.508674621582, 0, 0, 0);
    CreateDynamicObject(2676, 354.89779663086, -1372.2770996094, 13.416308403015, 0, 0, 0);
    CreateDynamicObject(923, 423.73916625977, -1362.3770751953, 14.727510452271, 0, 0, 0);
    CreateDynamicObject(923, 406.5537109375, -1372.7485351563, 14.704328536987, 0, 0, 0);
    CreateDynamicObject(922, 420.21182250977, -1364.9050292969, 14.71963596344, 0, 0, 28);
    CreateDynamicObject(922, 410.39373779297, -1370.9654541016, 14.709529876709, 0, 0, 27.998657226563);
    CreateDynamicObject(1332, 415.16540527344, -1367.4504394531, 14.901218414307, 0, 0, 30);
    CreateDynamicObject(2673, 416.48663330078, -1365.2662353516, 13.959301948547, 0, 0, 0);
    CreateDynamicObject(2673, 416.51885986328, -1355.1156005859, 14.054214477539, 0, 0, 0);
    CreateDynamicObject(13591, 406.95251464844, -1364.8581542969, 14.13360786438, 0, 0, 0);
    CreateDynamicObject(2677, 410.02487182617, -1362.6007080078, 14.195487976074, 0, 0, 0);
    CreateDynamicObject(2677, 400.88375854492, -1368.1541748047, 14.126281738281, 0, 0, 0);
    CreateDynamicObject(2677, 416.40145874023, -1356.9583740234, 14.240642547607, 0, 0, 0);
    CreateDynamicObject(3594, 496.66830444336, -1290.7041015625, 15.261932373047, 0, 0, 291.99462890625);
    CreateDynamicObject(2677, 494.7399597168, -1294.4782714844, 14.872811317444, 0, 0, 0);
    CreateDynamicObject(3594, 494.51626586914, -1272.5849609375, 15.265748977661, 0, 0, 291.99462890625);
    CreateDynamicObject(3594, 513.20764160156, -1278.052734375, 15.538871765137, 0, 0, 291.99462890625);
    CreateDynamicObject(3594, 515.24029541016, -1263.9165039063, 15.623738288879, 0, 0, 219.99462890625);
    CreateDynamicObject(3594, 529.84045410156, -1264.2978515625, 15.889513015747, 0, 0, 291.99462890625);
    CreateDynamicObject(3594, 526.02276611328, -1252.5992431641, 15.888323783875, 0, 0, 291.99462890625);
    CreateDynamicObject(3594, 538.94061279297, -1243.994140625, 16.241563796997, 0, 0, 291.99462890625);
    CreateDynamicObject(3594, 544.11877441406, -1254.3498535156, 16.255144119263, 0, 0, 231.99462890625);
    CreateDynamicObject(3594, 551.96704101563, -1234.3061523438, 16.624998092651, 0, 0, 231.99279785156);
    CreateDynamicObject(3594, 556.49652099609, -1249.369140625, 16.584581375122, 0, 0, 231.99279785156);
    CreateDynamicObject(3594, 566.00225830078, -1228.9417724609, 16.970546722412, 0, 0, 231.99279785156);
    CreateDynamicObject(3594, 563.70599365234, -1242.5258789063, 16.802471160889, 0, 0, 177.99279785156);
    CreateDynamicObject(3594, 580.03015136719, -1222.7158203125, 17.261627197266, 0, 0, 177.98950195313);
    CreateDynamicObject(3594, 578.73138427734, -1237.2294921875, 17.141431808472, 0, 0, 177.98950195313);
    CreateDynamicObject(3594, 603.73333740234, -1223.7338867188, 17.641958236694, 0, 0, 227.98950195313);
    CreateDynamicObject(2677, 600.32135009766, -1221.8338623047, 17.23957824707, 0, 0, 0);
    CreateDynamicObject(2677, 578.65881347656, -1219.6434326172, 16.894491195679, 0, 0, 0);
    CreateDynamicObject(2677, 581.82098388672, -1225.4442138672, 16.914157867432, 0, 0, 0);
    CreateDynamicObject(2677, 580.89514160156, -1233.8461914063, 16.844013214111, 0, 0, 0);
    CreateDynamicObject(2677, 576.79974365234, -1241.3524169922, 16.883169174194, 0, 0, 0);
    CreateDynamicObject(2677, 594.13635253906, -1241.0948486328, 17.274660110474, 0, 0, 0);
    CreateDynamicObject(2677, 586.98608398438, -1246.4455566406, 17.214967727661, 0, 0, 0);
    CreateDynamicObject(2677, 595.09509277344, -1230.8627929688, 17.093515396118, 0, 0, 0);
    CreateDynamicObject(3594, 590.75183105469, -1223.0762939453, 17.438138961792, 0, 0, 177.98950195313);
    CreateDynamicObject(2677, 589.63928222656, -1218.509765625, 17.091411590576, 0, 0, 0);
    CreateDynamicObject(2677, 592.22900390625, -1227.3549804688, 17.072553634644, 0, 0, 0);
    CreateDynamicObject(2677, 603.22637939453, -1211.3515625, 17.364995956421, 0, 0, 0);
    CreateDynamicObject(2677, 596.39868164063, -1216.359375, 17.216672897339, 0, 0, 0);
    CreateDynamicObject(2677, 566.69134521484, -1232.2336425781, 16.59593963623, 0, 0, 0);
    CreateDynamicObject(3119, 568.72137451172, -1246.4166259766, 16.720643997192, 0, 0, 0);
    CreateDynamicObject(3594, 481.95599365234, -1286.8682861328, 15.074636459351, 0, 0, 0);
    CreateDynamicObject(3461, 481.80389404297, -1289.2540283203, 13.622800827026, 0, 0, 0);
    CreateDynamicObject(3461, 494.44561767578, -1291.3846435547, 13.758991241455, 0, 0, 0);
    CreateDynamicObject(3461, 492.46258544922, -1273.3140869141, 13.899593353271, 0, 0, 0);
    CreateDynamicObject(3461, 510.93762207031, -1278.8037109375, 14.08716583252, 0, 0, 0);
    CreateDynamicObject(3461, 513.91577148438, -1262.2091064453, 14.156984329224, 0, 0, 0);
    CreateDynamicObject(3461, 527.42755126953, -1265.1038818359, 14.471841812134, 0, 0, 0);
    CreateDynamicObject(3461, 523.86492919922, -1253.3768310547, 14.429758071899, 0, 0, 0);
    CreateDynamicObject(3461, 542.30767822266, -1252.8681640625, 14.75138092041, 0, 0, 0);
    CreateDynamicObject(3461, 536.77679443359, -1244.7280273438, 14.807327270508, 0, 0, 0);
    CreateDynamicObject(3461, 554.68090820313, -1247.8374023438, 15.031116485596, 0, 0, 0);
    CreateDynamicObject(3461, 563.90985107422, -1240.2368164063, 15.092218399048, 0, 0, 0);
    CreateDynamicObject(3461, 564.31433105469, -1227.4753417969, 15.556753158569, 0, 0, 0);
    CreateDynamicObject(3461, 550.33441162109, -1232.9122314453, 15.13178062439, 0, 0, 0);
    CreateDynamicObject(3461, 578.93157958984, -1235.0386962891, 15.401880264282, 0, 0, 0);
    CreateDynamicObject(3461, 580.31921386719, -1220.3033447266, 15.764965057373, 0, 0, 0);
    CreateDynamicObject(3461, 590.9716796875, -1220.8267822266, 16.078088760376, 0, 0, 0);
    CreateDynamicObject(3461, 602.04406738281, -1222.0125732422, 15.941146850586, 0, 0, 0);
    CreateDynamicObject(2677, 499.79504394531, -1287.638671875, 14.948600769043, 0, 0, 0);
    CreateDynamicObject(2677, 491.76345825195, -1275.3675537109, 14.865511894226, 0, 0, 0);
    CreateDynamicObject(2677, 496.45074462891, -1282.0850830078, 14.910060882568, 0, 0, 0);
    CreateDynamicObject(2677, 488.65481567383, -1283.4113769531, 14.807759284973, 0, 0, 0);
    CreateDynamicObject(2677, 497.98672485352, -1270.0716552734, 14.957653045654, 0, 0, 0);
    CreateDynamicObject(2677, 516.59875488281, -1275.6433105469, 15.242523193359, 0, 0, 0);
    CreateDynamicObject(2677, 510.04281616211, -1281.2291259766, 15.11799621582, 0, 0, 0);
    CreateDynamicObject(2677, 511.81649780273, -1261.7318115234, 15.205371856689, 0, 0, 0);
    CreateDynamicObject(2677, 519.21875, -1266.6719970703, 15.310101509094, 0, 0, 0);
    CreateDynamicObject(2677, 523.81475830078, -1272.6048583984, 15.367579460144, 0, 0, 0);
    CreateDynamicObject(2677, 509.06701660156, -1270.0511474609, 15.139544487, 0, 0, 0);
    CreateDynamicObject(2677, 523.07977294922, -1255.3393554688, 15.455631256104, 0, 0, 0);
    CreateDynamicObject(2677, 529.81915283203, -1249.4776611328, 15.622891426086, 0, 0, 0);
    CreateDynamicObject(2677, 532.18737792969, -1261.2509765625, 15.593742370605, 0, 0, 0);
    CreateDynamicObject(2677, 526.83221435547, -1267.4926757813, 15.453196525574, 0, 0, 0);
    CreateDynamicObject(2677, 534.42553710938, -1244.2093505859, 15.772743225098, 0, 0, 0);
    CreateDynamicObject(2677, 542.31036376953, -1245.3708496094, 15.93479347229, 0, 0, 0);
    CreateDynamicObject(2677, 540.27642822266, -1252.8952636719, 15.827927589417, 0, 0, 0);
    CreateDynamicObject(2677, 547.4326171875, -1254.541015625, 15.966979980469, 0, 0, 0);
    CreateDynamicObject(2677, 554.90252685547, -1245.4499511719, 16.226400375366, 0, 0, 0);
    CreateDynamicObject(2677, 557.18988037109, -1253.4619140625, 16.373422622681, 0, 0, 0);
    CreateDynamicObject(2677, 548.09783935547, -1234.0187988281, 16.178792953491, 0, 0, 0);
    CreateDynamicObject(2677, 556.29992675781, -1236.0433349609, 16.345342636108, 0, 0, 0);
    CreateDynamicObject(2677, 561.67572021484, -1240.0319824219, 16.423414230347, 0, 0, 0);
    CreateDynamicObject(2677, 564.6064453125, -1247.1303710938, 16.595499038696, 0, 0, 0);
    CreateDynamicObject(2677, 571.16558837891, -1229.8414306641, 16.701231002808, 0, 0, 0);
    CreateDynamicObject(2677, 609.04943847656, -1229.6973876953, 17.609786987305, 0, 0, 0);
    CreateDynamicObject(2677, 610.41918945313, -1225.2934570313, 17.375070571899, 0, 0, 0);

//Parte 2
    CreateDynamicObject(13591, 652.15856933594, -1218.4967041016, 17.326356887817, 0, 0, 342);
    CreateDynamicObject(3594, 644.78588867188, -1209.1473388672, 17.740550994873, 0, 0, 0);
    CreateDynamicObject(3594, 641.7099609375, -1193.7131347656, 17.740550994873, 0, 0, 80);
    CreateDynamicObject(3594, 655.46398925781, -1201.0460205078, 17.674549102783, 0, 0, 0);
    CreateDynamicObject(3594, 653.3427734375, -1184.1868896484, 17.570289611816, 0, 0, 79.996948242188);
    CreateDynamicObject(3594, 664.75317382813, -1198.1285400391, 17.283205032349, 0, 0, 0);
    CreateDynamicObject(3594, 666.85998535156, -1175.0848388672, 15.341956138611, 0, 0, 121.99694824219);
    CreateDynamicObject(3594, 676.32196044922, -1185.2227783203, 15.454922676086, 0, 0, 0);
    CreateDynamicObject(3594, 684.94854736328, -1173.9655761719, 14.742792129517, 0, 0, 201.99694824219);
    CreateDynamicObject(3594, 671.79516601563, -1164.9233398438, 14.733922958374, 0, 0, 79.996948242188);
    CreateDynamicObject(3594, 687.69018554688, -1161.3037109375, 14.908309936523, 0, 0, 79.996948242188);
    CreateDynamicObject(3594, 684.93695068359, -1151.6925048828, 15.014196395874, 0, 0, 79.996948242188);
    CreateDynamicObject(3594, 702.32794189453, -1153.1791992188, 15.521706581116, 0, 0, 0);
    CreateDynamicObject(3594, 706.75457763672, -1143.4876708984, 16.123712539673, 0, 0, 0);
    CreateDynamicObject(3594, 711.78454589844, -1133.4136962891, 16.760738372803, 0, 0, 0);
    CreateDynamicObject(3594, 695.58135986328, -1126.18359375, 16.533866882324, 0, 0, 0);
    CreateDynamicObject(12957, 692.62268066406, -1136.1484375, 16.164873123169, 0, 0, 42);
    CreateDynamicObject(12957, 690.12316894531, -1104.2624511719, -26.903228759766, 0, 0, 41.995239257813);
    CreateDynamicObject(3594, 705.39837646484, -1122.2427978516, 17.111820220947, 0, 0, 72);
    CreateDynamicObject(3594, 694.51470947266, -1146.2042236328, 15.445862770081, 0, 0, 326);
    CreateDynamicObject(3594, 717.19195556641, -1118.6104736328, 17.750844955444, 0, 0, 71.998901367188);
    CreateDynamicObject(3594, 698.14477539063, -1109.7078857422, 17.952896118164, 0, 0, 141.99890136719);
    CreateDynamicObject(3594, 723.86779785156, -1110.3151855469, 18.754909515381, 0, 0, 141.99829101563);
    CreateDynamicObject(3594, 710.22424316406, -1108.8304443359, 18.211601257324, 0, 0, 141.99829101563);
    CreateDynamicObject(3594, 749.3056640625, -1082.1838378906, 22.525651931763, 0, 0, 141.99829101563);
    CreateDynamicObject(3594, 743.79864501953, -1087.2193603516, 21.659414291382, 0, 0, 141.99829101563);
    CreateDynamicObject(3594, 708.7998046875, -1107.7955322266, 18.237329483032, 0, 34, 141.99829101563);
    CreateDynamicObject(3594, 763.43200683594, -1031.1033935547, 23.60947227478, 0, 0, 141.99829101563);
    CreateDynamicObject(3594, 768.85766601563, -1029.7716064453, 23.740550994873, 0, 34, 175.99829101563);
    CreateDynamicObject(3594, 765.02947998047, -1036.1108398438, 23.622753143311, 0, 0, 111.99829101563);
    CreateDynamicObject(3594, 719.79290771484, -1098.5788574219, 19.355812072754, 0, 0, 217.99829101563);
    CreateDynamicObject(3594, 712.80670166016, -1087.7166748047, 19.940330505371, 0, 0, 277.99621582031);
    CreateDynamicObject(3594, 733.68328857422, -1089.7503662109, 20.70288848877, 0, 0, 277.99255371094);
    CreateDynamicObject(3594, 725.97186279297, -1084.2314453125, 20.796932220459, 0, 0, 181.99255371094);
    CreateDynamicObject(3594, 718.52764892578, -1072.0780029297, 21.502214431763, 0, 0, 181.98852539063);
    CreateDynamicObject(3594, 740.35192871094, -1081.2333984375, 21.782451629639, 0, 0, 181.98852539063);
    CreateDynamicObject(3594, 749.40155029297, -1071.7281494141, 23.010194778442, 0, 0, 103.98852539063);
    CreateDynamicObject(3594, 732.130859375, -1069.19921875, 22.130359649658, 0, 0, 103.98559570313);
    CreateDynamicObject(3594, 745.9111328125, -1051.7514648438, 23.010522842407, 0, 0, 103.98559570313);
    CreateDynamicObject(3594, 742.77661132813, -1062.6390380859, 22.953586578369, 0, 0, 23.985595703125);
    CreateDynamicObject(3593, 762.57427978516, -1063.3913574219, 24.037185668945, 0, 0, 0);
    CreateDynamicObject(3593, 753.66571044922, -1057.1605224609, 23.427854537964, 0, 0, 0);
    CreateDynamicObject(3593, 760.23052978516, -1046.7142333984, 23.464757919312, 0, 0, 0);
    CreateDynamicObject(3593, 777.60510253906, -1045.9864501953, 24.137619018555, 0, 0, 106);
    CreateDynamicObject(3593, 774.32403564453, -1046.7844238281, 24.040632247925, 342, 0, 109.99606323242);
    CreateDynamicObject(3594, 771.44104003906, -1055.2434082031, 23.991775512695, 0, 0, 41.99462890625);
    CreateDynamicObject(3594, 782.47186279297, -1053.2216796875, 24.156539916992, 0, 0, 163.98974609375);
    CreateDynamicObject(13591, 650.02740478516, -1228.6697998047, 17.377918243408, 0, 0, 13.998901367188);
    CreateDynamicObject(13591, 817.13305664063, -1055.3270263672, 24.084409713745, 0, 0, 0);
    CreateDynamicObject(13591, 820.70013427734, -1032.5743408203, 23.881021499634, 0, 0, 52);
    CreateDynamicObject(13591, 848.05725097656, -1032.4011230469, 25.494268417358, 354, 0, 125.99829101563);
    CreateDynamicObject(13591, 849.93157958984, -1018.4405517578, 27.776121139526, 11.995971679688, 0, 319.99670410156);
    CreateDynamicObject(3594, 816.09759521484, -1040.4357910156, 24.599925994873, 0, 0, 99.987426757813);
    CreateDynamicObject(3594, 807.94012451172, -1045.6165771484, 24.5592212677, 0, 0, 99.986572265625);
    CreateDynamicObject(3594, 831.01953125, -1048.3530273438, 24.79076385498, 0, 0, 129.9866027832);
    CreateDynamicObject(3594, 834.14392089844, -1038.6837158203, 24.555839538574, 0, 0, 129.98474121094);
    CreateDynamicObject(3594, 823.19982910156, -1048.5593261719, 24.599925994873, 0, 0, 129.98474121094);
    CreateDynamicObject(3594, 835.06457519531, -1021.7105712891, 25.913290023804, 0, 0, 129.98474121094);
    CreateDynamicObject(3594, 864.54443359375, -1018.6446533203, 30.054315567017, 0, 0, 129.98474121094);
    CreateDynamicObject(3594, 871.81695556641, -1009.7492675781, 33.016273498535, 0, 0, 129.98474121094);
    CreateDynamicObject(3594, 856.30279541016, -994.6953125, 32.936058044434, 0, 0, 129.98474121094);
    CreateDynamicObject(3594, 850.5029296875, -1004.84765625, 29.95592880249, 0, 0, 129.98474121094);
    CreateDynamicObject(3594, 862.78973388672, -981.63037109375, 34.540321350098, 0, 0, 129.98474121094);
    CreateDynamicObject(3594, 867.00714111328, -990.77136230469, 34.348445892334, 0, 0, 129.98474121094);
    CreateDynamicObject(3594, 880.798828125, -1003.59375, 34.330238342285, 0, 0, 129.98474121094);
    CreateDynamicObject(3594, 880.97680664063, -991.46343994141, 35.144737243652, 0, 0, 129.98474121094);
    CreateDynamicObject(3594, 889.84118652344, -974.7919921875, 36.604858398438, 0, 0, 129.98474121094);
    CreateDynamicObject(3594, 891.30285644531, -997.10791015625, 35.601409912109, 0, 0, 129.98474121094);
    CreateDynamicObject(3594, 900.28277587891, -982.01959228516, 36.744647979736, 0, 0, 129.98474121094);
    CreateDynamicObject(3594, 940.07385253906, -961.33312988281, 38.049831390381, 0, 0, 129.98474121094);
    CreateDynamicObject(3594, 905.41540527344, -969.05310058594, 37.664543151855, 0, 0, 129.98474121094);
    CreateDynamicObject(3594, 918.10784912109, -975.67950439453, 37.720085144043, 0, 0, 63.984741210938);
    CreateDynamicObject(3594, 922.59460449219, -963.44287109375, 37.976249694824, 0, 0, 63.984375);
    CreateDynamicObject(3594, 932.79602050781, -982.54888916016, 37.980442047119, 0, 0, 129.98474121094);
    CreateDynamicObject(3594, 911.5830078125, -987.7236328125, 37.183399200439, 0, 0, 129.98474121094);
    CreateDynamicObject(3594, 946.52905273438, -979.61212158203, 38.303638458252, 0, 0, 129.98474121094);
    CreateDynamicObject(3594, 951.716796875, -968.05847167969, 38.291477203369, 0, 0, 63.984375);
    CreateDynamicObject(3594, 980.97705078125, -975.83032226563, 39.319889068604, 0, 0, 63.984375);
    CreateDynamicObject(3594, 974.06372070313, -956.59283447266, 39.747573852539, 0, 0, 63.984375);
    CreateDynamicObject(3594, 984.13757324219, -958.5380859375, 39.827175140381, 0, 0, 189.984375);
    CreateDynamicObject(3594, 971.23663330078, -969.42584228516, 38.875980377197, 0, 0, 189.98107910156);
    CreateDynamicObject(3594, 969.63702392578, -969.548828125, 38.815658569336, 0, 40, 189.98107910156);
    CreateDynamicObject(3594, 1000.7244262695, -949.06646728516, 41.736240386963, 0, 0, 189.98107910156);
    CreateDynamicObject(3594, 1005.2229003906, -948.86151123047, 41.81893157959, 0, 0, 189.98107910156);
    CreateDynamicObject(3594, 1010.7871704102, -948.27856445313, 41.921695709229, 0, 0, 233.98107910156);
    CreateDynamicObject(3594, 993.74432373047, -974.28100585938, 40.167736053467, 0, 0, 189.98107910156);
    CreateDynamicObject(3594, 992.44549560547, -963.05255126953, 40.138843536377, 0, 0, 123.98107910156);
    CreateDynamicObject(3594, 1006.7236938477, -973.29760742188, 41.137477874756, 0, 0, 123.98068237305);
    CreateDynamicObject(3594, 1015.8478393555, -957.70318603516, 41.694534301758, 0, 0, 53.980651855469);
    CreateDynamicObject(3594, 1029.8796386719, -971.18182373047, 42.209163665771, 0, 0, 53.975830078125);
    CreateDynamicObject(3594, 1029.4663085938, -949.70178222656, 42.239685058594, 0, 0, 97.975830078125);
    CreateDynamicObject(3594, 1066.5213623047, -967.62713623047, 42.428050994873, 0, 0, 97.970581054688);
    CreateDynamicObject(3594, 1058.1372070313, -971.21765136719, 42.428050994873, 0, 0, 97.970581054688);
    CreateDynamicObject(3594, 1074.7573242188, -958.45611572266, 42.163265228271, 0, 0, 11.970581054688);
    CreateDynamicObject(13591, 1061.8046875, -946.94427490234, 41.788051605225, 0, 0, 0);
    CreateDynamicObject(3594, 1049.0916748047, -950.08996582031, 42.288745880127, 0, 0, 11.969604492188);
    CreateDynamicObject(3594, 1050.1497802734, -961.85485839844, 42.224925994873, 0, 0, 11.969604492188);
    CreateDynamicObject(3594, 1061.3355712891, -956.99627685547, 42.224925994873, 0, 0, 151.96966552734);
    CreateDynamicObject(3594, 1032.5437011719, -960.30541992188, 42.072063446045, 0, 0, 53.975830078125);
    CreateDynamicObject(3594, 1076.8187255859, -943.96325683594, 42.504341125488, 0, 0, 97.970581054688);
    CreateDynamicObject(2677, 1076.6080322266, -961.61376953125, 41.726119995117, 0, 0, 0);
    CreateDynamicObject(2677, 1072.8524169922, -954.32958984375, 41.865768432617, 0, 0, 0);
    CreateDynamicObject(2677, 1080.4897460938, -945.20733642578, 41.903232574463, 0, 0, 0);
    CreateDynamicObject(2677, 1073.1160888672, -942.07543945313, 42.186447143555, 0, 0, 0);
    CreateDynamicObject(2677, 1084.8577880859, -940.81213378906, 42.089794158936, 0, 0, 0);
    CreateDynamicObject(2677, 1061.6497802734, -961.00531005859, 41.865768432617, 0, 0, 0);
    CreateDynamicObject(2677, 1061.7857666016, -951.89904785156, 42.023918151855, 0, 0, 0);
    CreateDynamicObject(2677, 1070.5417480469, -968.96429443359, 42.021251678467, 0, 0, 0);
    CreateDynamicObject(2677, 1062.4321289063, -966.24603271484, 42.068893432617, 0, 0, 0);
    CreateDynamicObject(2677, 1054.4007568359, -969.99310302734, 42.068893432617, 0, 0, 0);
    CreateDynamicObject(2677, 1061.6190185547, -972.47521972656, 42.080085754395, 0, 0, 0);
    CreateDynamicObject(2677, 1061.9764404297, -942.83758544922, 42.23738861084, 0, 0, 0);
    CreateDynamicObject(2677, 1052.4056396484, -965.41015625, 41.865264892578, 0, 0, 0);
    CreateDynamicObject(2677, 1047.3248291016, -957.95324707031, 41.865768432617, 0, 0, 0);
    CreateDynamicObject(2677, 1052.0716552734, -953.68310546875, 41.948638916016, 0, 0, 0);
    CreateDynamicObject(2677, 1045.8985595703, -945.84783935547, 42.112731933594, 0, 0, 0);
    CreateDynamicObject(2677, 1036.4869384766, -961.53735351563, 41.77613067627, 0, 0, 0);
    CreateDynamicObject(2677, 1028.2897949219, -958.34680175781, 41.65092086792, 0, 0, 0);
    CreateDynamicObject(2677, 1033.5964355469, -951.79095458984, 41.750259399414, 0, 0, 0);
    CreateDynamicObject(2677, 1024.6938476563, -948.14459228516, 41.679145812988, 0, 0, 0);
    CreateDynamicObject(2677, 1034.0391845703, -972.74591064453, 41.914623260498, 0, 0, 0);
    CreateDynamicObject(2677, 1024.3725585938, -970.09887695313, 41.562286376953, 0, 0, 0);
    CreateDynamicObject(2677, 1041.5891113281, -969.84539794922, 41.860820770264, 0, 0, 0);
    CreateDynamicObject(2677, 1017.6347045898, -962.20141601563, 41.386863708496, 0, 0, 0);
    CreateDynamicObject(2677, 1014.1215209961, -953.37750244141, 41.310138702393, 0, 0, 0);
    CreateDynamicObject(2677, 1011.688659668, -972.83801269531, 41.038661956787, 0, 0, 0);
    CreateDynamicObject(2677, 1002.2030639648, -973.08587646484, 40.546882629395, 0, 0, 0);
    CreateDynamicObject(2677, 1004.3333740234, -960.34271240234, 40.723518371582, 0, 0, 0);
    CreateDynamicObject(2677, 1012.6053466797, -965.71276855469, 41.109912872314, 0, 0, 0);
    CreateDynamicObject(2677, 1003.0181274414, -952.32702636719, 41.417678833008, 0, 0, 0);
    CreateDynamicObject(2677, 1007.4325561523, -944.38757324219, 41.512100219727, 0, 0, 0);
    CreateDynamicObject(2677, 996.99450683594, -945.61431884766, 41.313026428223, 0, 0, 0);
    CreateDynamicObject(2677, 1011.4103393555, -951.59295654297, 41.569095611572, 0, 0, 0);
    CreateDynamicObject(2677, 995.98895263672, -951.94958496094, 41.311080932617, 0, 0, 0);
    CreateDynamicObject(2677, 1017.1795654297, -943.49078369141, 41.411224365234, 0, 0, 0);
    CreateDynamicObject(2677, 996.34375, -962.96405029297, 40.184036254883, 0, 0, 0);
    CreateDynamicObject(2677, 986.48260498047, -963.30706787109, 39.205932617188, 0, 0, 0);
    CreateDynamicObject(2677, 996.44952392578, -976.46710205078, 40.262405395508, 0, 0, 0);
    CreateDynamicObject(2677, 991.22259521484, -970.51062011719, 39.59289932251, 0, 0, 0);
    CreateDynamicObject(2677, 986.45684814453, -954.57208251953, 40.210613250732, 0, 0, 0);
    CreateDynamicObject(2677, 986.2333984375, -976.53265380859, 39.244293212891, 0, 0, 0);
    CreateDynamicObject(2677, 975.14526367188, -975.28375244141, 38.561828613281, 0, 0, 0);
    CreateDynamicObject(2677, 973.41156005859, -965.48278808594, 38.607517242432, 0, 0, 0);
    CreateDynamicObject(2677, 968, -974.84368896484, 38.357608795166, 0, 0, 0);
    CreateDynamicObject(2677, 980.34844970703, -964.85797119141, 38.843013763428, 0, 0, 0);
    CreateDynamicObject(2677, 977.68548583984, -956.55133056641, 39.464393615723, 0, 0, 0);
    CreateDynamicObject(2677, 968.06494140625, -955.51727294922, 39.422355651855, 0, 0, 0);
    CreateDynamicObject(2677, 955.87145996094, -968.12878417969, 38.007106781006, 0, 0, 0);
    CreateDynamicObject(2677, 947.01763916016, -968.00036621094, 37.838932037354, 0, 0, 0);
    CreateDynamicObject(2677, 949.63201904297, -976.07861328125, 37.922885894775, 0, 0, 0);
    CreateDynamicObject(2677, 953.59124755859, -961.29241943359, 38.539653778076, 0, 0, 0);
    CreateDynamicObject(2677, 955.74963378906, -978.6611328125, 38.154655456543, 0, 0, 0);
    CreateDynamicObject(2677, 938.77294921875, -965.95721435547, 37.646289825439, 0, 0, 0);
    CreateDynamicObject(2677, 941.24053955078, -957.95849609375, 38.164653778076, 0, 0, 0);
    CreateDynamicObject(2677, 935.10571289063, -978.53161621094, 37.578582763672, 0, 0, 0);
    CreateDynamicObject(2677, 939.83190917969, -981.31396484375, 37.762710571289, 0, 0, 0);
    CreateDynamicObject(2677, 924.83752441406, -967.34155273438, 37.474807739258, 0, 0, 0);
    CreateDynamicObject(2677, 923.72442626953, -961.13598632813, 37.699172973633, 0, 0, 0);
    CreateDynamicObject(2677, 922.39953613281, -977.13745117188, 37.418781280518, 0, 0, 0);
    CreateDynamicObject(2677, 914.38757324219, -972.88830566406, 37.335304260254, 0, 0, 0);
    CreateDynamicObject(2677, 922.11840820313, -985.14489746094, 37.592632293701, 0, 0, 0);
    CreateDynamicObject(2677, 929.81555175781, -973.03332519531, 37.51163482666, 0, 0, 0);
    CreateDynamicObject(2677, 914.6962890625, -985.13885498047, 37.259899139404, 0, 0, 0);
    CreateDynamicObject(2677, 906.63262939453, -992.94354248047, 36.942531585693, 0, 0, 0);
    CreateDynamicObject(2677, 905.13970947266, -980.39788818359, 36.910636901855, 0, 0, 0);
    CreateDynamicObject(2677, 896.91448974609, -970.48358154297, 36.972770690918, 0, 0, 0);
    CreateDynamicObject(2677, 887.66925048828, -978.97613525391, 36.284248352051, 0, 0, 0);
    CreateDynamicObject(2677, 892.41448974609, -970.77020263672, 36.568744659424, 0, 0, 0);
    CreateDynamicObject(2677, 893.44549560547, -975.10101318359, 36.564239501953, 0, 0, 0);
    CreateDynamicObject(2677, 895.74139404297, -993.74530029297, 36.255989074707, 0, 0, 0);
    CreateDynamicObject(2677, 886.41003417969, -987.958984375, 35.698219299316, 0, 0, 0);
    CreateDynamicObject(2677, 871.73199462891, -987.40826416016, 34.497966766357, 0, 0, 0);
    CreateDynamicObject(2677, 886.87731933594, -998.84381103516, 35.118938446045, 0, 0, 0);
    CreateDynamicObject(2677, 876.19287109375, -1004.2515258789, 33.925437927246, 0, 0, 0);
    CreateDynamicObject(2677, 865.23712158203, -1013.3352661133, 30.583456039429, 0, 0, 0);
    CreateDynamicObject(2677, 858.06860351563, -998.5927734375, 32.108226776123, 0, 0, 0);
    CreateDynamicObject(2677, 866.76531982422, -995.19305419922, 33.658309936523, 0, 0, 0);
    CreateDynamicObject(2677, 865.37487792969, -1003.3439941406, 32.669441223145, 0, 0, 0);
    CreateDynamicObject(2677, 873.90301513672, -996.71038818359, 34.196796417236, 0, 0, 0);
    CreateDynamicObject(2677, 868.58319091797, -980.42828369141, 34.556449890137, 0, 0, 0);
    CreateDynamicObject(2677, 874.34808349609, -980.56671142578, 35.068244934082, 0, 0, 0);
    CreateDynamicObject(2677, 855.63690185547, -1004.3135375977, 30.979835510254, 0, 0, 0);
    CreateDynamicObject(2677, 854.46704101563, -1017.2301025391, 28.34407043457, 0, 0, 0);
    CreateDynamicObject(2677, 857.72357177734, -1009.4990844727, 30.373474121094, 0, 0, 0);
    CreateDynamicObject(2677, 847.35876464844, -1007.776550293, 28.88982963562, 0, 0, 0);
    CreateDynamicObject(2677, 843.68927001953, -1017.7742919922, 27.089828491211, 0, 0, 0);
    CreateDynamicObject(2676, 843.05389404297, -1030.90234375, 25.031574249268, 0, 0, 0);
    CreateDynamicObject(2676, 847.06079101563, -1041.2021484375, 24.6295337677, 0, 0, 0);
    CreateDynamicObject(2676, 836.06817626953, -1033.8966064453, 24.512327194214, 0, 0, 0);
    CreateDynamicObject(2676, 833.84576416016, -1043.7938232422, 24.095849990845, 0, 0, 0);
    CreateDynamicObject(2676, 825.77203369141, -1031.59375, 24.11762046814, 0, 0, 0);
    CreateDynamicObject(2676, 832.52124023438, -1025.5319824219, 24.743841171265, 0, 0, 0);
    CreateDynamicObject(2676, 859.22155761719, -1028.8077392578, 26.62752532959, 0, 0, 0);
    CreateDynamicObject(2676, 824.15515136719, -1038.7510986328, 24.072072982788, 0, 0, 0);
    CreateDynamicObject(2676, 819.26794433594, -1041.865234375, 24.071924209595, 0, 0, 0);
    CreateDynamicObject(2676, 825.41265869141, -1045.4957275391, 24.072072982788, 0, 0, 0);
    CreateDynamicObject(2676, 822.16003417969, -1057.0841064453, 24.279111862183, 0, 0, 0);
    CreateDynamicObject(2676, 811.34832763672, -1047.2142333984, 24.073526382446, 0, 0, 0);
    CreateDynamicObject(2676, 808.9560546875, -1037.5319824219, 24.199405670166, 0, 0, 0);
    CreateDynamicObject(2676, 804.77728271484, -1056.4969482422, 23.856069564819, 0, 0, 0);
    CreateDynamicObject(2676, 803.10260009766, -1046.6236572266, 24.056222915649, 0, 0, 0);
    CreateDynamicObject(2676, 806.32958984375, -1039.8481445313, 23.935447692871, 0, 0, 0);
    CreateDynamicObject(2676, 810.27819824219, -1059.3413085938, 24.039182662964, 0, 0, 0);
    CreateDynamicObject(2676, 786.14361572266, -1051.7254638672, 23.70645904541, 0, 0, 0);
    CreateDynamicObject(2676, 777.90454101563, -1057.8952636719, 23.639753341675, 0, 0, 0);
    CreateDynamicObject(2676, 780.66943359375, -1042.5759277344, 23.466667175293, 0, 0, 0);
    CreateDynamicObject(2676, 769.56304931641, -1040.7895507813, 23.168439865112, 0, 0, 0);
    CreateDynamicObject(2676, 768.03894042969, -1049.7193603516, 23.284543991089, 0, 0, 0);
    CreateDynamicObject(2676, 763.67681884766, -1058.2662353516, 23.471342086792, 0, 0, 0);
    CreateDynamicObject(2675, 764.66607666016, -1048.1549072266, 23.076652526855, 0, 0, 0);
    CreateDynamicObject(2675, 755.45843505859, -1051.3046875, 22.807382583618, 0, 0, 0);
    CreateDynamicObject(2675, 754.90093994141, -1070.0811767578, 22.96527671814, 0, 0, 0);
    CreateDynamicObject(2675, 755.96911621094, -1061.4467773438, 23.005933761597, 0, 0, 0);
    CreateDynamicObject(2674, 743.17913818359, -1057.3278808594, 22.337646484375, 0, 0, 0);
    CreateDynamicObject(2674, 746.37084960938, -1066.3684082031, 22.385087966919, 0, 0, 0);
    CreateDynamicObject(2677, 766.45172119141, -1018.7653198242, 23.381391525269, 0, 0, 0);
    CreateDynamicObject(2677, 760.82983398438, -1024.5128173828, 23.241872787476, 0, 0, 0);
    CreateDynamicObject(2677, 757.93438720703, -1037.513671875, 23.077550888062, 0, 0, 0);
    CreateDynamicObject(2677, 752.64611816406, -1044.1961669922, 22.941328048706, 0, 0, 0);
    CreateDynamicObject(2677, 735.74206542969, -1054.6079101563, 22.748878479004, 0, 0, 0);
    CreateDynamicObject(2677, 731.38946533203, -1061.9188232422, 22.327835083008, 0, 0, 0);
    CreateDynamicObject(2677, 736.58679199219, -1072.5314941406, 21.804973602295, 0, 0, 0);
    CreateDynamicObject(2677, 743.63824462891, -1081.8256835938, 21.842418670654, 0, 0, 0);
    CreateDynamicObject(2677, 721.89599609375, -1070.3173828125, 21.365964889526, 0, 0, 0);
    CreateDynamicObject(2677, 731.04406738281, -1076.5003662109, 21.227939605713, 0, 0, 0);
    CreateDynamicObject(2677, 731.4501953125, -1086.2767333984, 20.523008346558, 0, 0, 0);
    CreateDynamicObject(2677, 722.75604248047, -1083.4415283203, 20.353183746338, 0, 0, 0);
    CreateDynamicObject(2677, 737.57836914063, -1080.5541992188, 21.286190032959, 0, 0, 0);
    CreateDynamicObject(2677, 726.34228515625, -1105.6127929688, 18.885160446167, 0, 0, 0);
    CreateDynamicObject(2677, 718.93115234375, -1093.6533203125, 19.366777420044, 0, 0, 0);
    CreateDynamicObject(2677, 716.32305908203, -1102.2875976563, 18.552471160889, 0, 0, 0);
    CreateDynamicObject(2677, 704.58709716797, -1094.4692382813, 18.926893234253, 0, 0, 0);
    CreateDynamicObject(2677, 731.16949462891, -1098.2507324219, 19.717254638672, 0, 0, 0);
    CreateDynamicObject(2677, 644.84484863281, -1215.5618896484, 17.553266525269, 0, 0, 0);
    CreateDynamicObject(2677, 648.87365722656, -1206.0678710938, 17.381391525269, 0, 0, 0);
    CreateDynamicObject(2677, 637.12890625, -1194.2742919922, 17.381391525269, 0, 0, 0);
    CreateDynamicObject(2677, 644.9287109375, -1197.4915771484, 17.388940811157, 0, 0, 0);
    CreateDynamicObject(2677, 643.76373291016, -1189.4224853516, 17.685888290405, 0, 0, 0);
    CreateDynamicObject(2677, 642.08819580078, -1229.8599853516, 17.61968421936, 0, 0, 0);
    CreateDynamicObject(2677, 652.97937011719, -1197.4946289063, 17.309228897095, 0, 0, 0);
    CreateDynamicObject(2677, 656.87933349609, -1187.8653564453, 16.805904388428, 0, 0, 0);
    CreateDynamicObject(2677, 667.91009521484, -1200.1414794922, 17.182998657227, 0, 0, 0);
    CreateDynamicObject(2677, 661.13659667969, -1199.2880859375, 17.212400436401, 0, 0, 0);
    CreateDynamicObject(2677, 663.80419921875, -1179.8679199219, 15.61697101593, 0, 0, 0);
    CreateDynamicObject(2677, 672.81585693359, -1189.9851074219, 15.754289627075, 0, 0, 0);
    CreateDynamicObject(2677, 670.55920410156, -1169.1038818359, 14.578585624695, 0, 0, 0);
    CreateDynamicObject(2677, 659.12036132813, -1175.580078125, 15.902075767517, 0, 0, 0);
    CreateDynamicObject(2677, 679.08563232422, -1195.5223388672, 15.940138816833, 0, 0, 0);
    CreateDynamicObject(2677, 664.69488525391, -1187.396484375, 16.211400985718, 0, 0, 0);
    CreateDynamicObject(2677, 679.02233886719, -1182.7598876953, 14.870826721191, 0, 0, 0);
    CreateDynamicObject(2677, 684.48986816406, -1178.6540527344, 14.530161857605, 0, 0, 0);
    CreateDynamicObject(2677, 687.85052490234, -1169.1235351563, 14.459448814392, 0, 0, 0);
    CreateDynamicObject(2677, 686.48571777344, -1184.3984375, 14.714357376099, 0, 0, 0);
    CreateDynamicObject(2677, 677.14294433594, -1173.7435302734, 14.560711860657, 0, 0, 0);
    CreateDynamicObject(2677, 673.73400878906, -1155.0788574219, 14.717034339905, 0, 0, 0);
    CreateDynamicObject(2677, 682.14733886719, -1162.6591796875, 14.494208335876, 0, 0, 0);
    CreateDynamicObject(2677, 693.34527587891, -1160.2219238281, 14.607342720032, 0, 0, 0);
    CreateDynamicObject(2677, 688.85711669922, -1154.623046875, 14.645877838135, 0, 0, 0);
    CreateDynamicObject(2677, 681.75201416016, -1147.7902832031, 14.674269676208, 0, 0, 0);
    CreateDynamicObject(2677, 690.32830810547, -1147.6350097656, 14.889321327209, 0, 0, 0);
    CreateDynamicObject(2677, 699.46728515625, -1144.5308837891, 15.311099052429, 0, 0, 0);
    CreateDynamicObject(2677, 705.8818359375, -1149.5600585938, 15.44011592865, 0, 0, 0);
    CreateDynamicObject(2677, 688.29779052734, -1135.6915283203, 15.459012985229, 0, 0, 0);
    CreateDynamicObject(2677, 682.08337402344, -1135.9039306641, 15.814723968506, 0, 0, 0);
    CreateDynamicObject(2677, 715.16998291016, -1132.6666259766, 16.546745300293, 0, 0, 0);
    CreateDynamicObject(2677, 710.26672363281, -1125.5194091797, 16.685457229614, 0, 0, 0);
    CreateDynamicObject(2677, 698.90979003906, -1120.8807373047, 16.634672164917, 0, 0, 0);
    CreateDynamicObject(2677, 701.64483642578, -1130.8233642578, 16.077058792114, 0, 0, 0);
    CreateDynamicObject(2677, 692.41314697266, -1119.0123291016, 16.755805969238, 0, 0, 0);
    CreateDynamicObject(2677, 703.53314208984, -1109.8942871094, 17.557106018066, 0, 0, 0);
    CreateDynamicObject(2677, 713.89501953125, -1113.3397216797, 17.65425491333, 0, 0, 0);
    CreateDynamicObject(2677, 718.90509033203, -1125.6159667969, 17.164323806763, 0, 0, 0);
    CreateDynamicObject(3461, 647.62780761719, -1219.3502197266, 15.775806427002, 0, 0, 0);
    CreateDynamicObject(3461, 649.79333496094, -1219.7651367188, 15.561309814453, 0, 0, 0);
    CreateDynamicObject(3461, 652.16534423828, -1220.2326660156, 15.70686340332, 0, 0, 0);
    CreateDynamicObject(3461, 649.74011230469, -1226.4024658203, 15.480199813843, 0, 0, 0);
    CreateDynamicObject(3461, 647.83178710938, -1227.2269287109, 15.563562393188, 0, 0, 0);
    CreateDynamicObject(3461, 645.36242675781, -1228.4466552734, 15.212322235107, 0, 0, 0);
    CreateDynamicObject(3461, 644.58135986328, -1211.3057861328, 15.678661346436, 0, 0, 0);
    CreateDynamicObject(3461, 643.80517578125, -1194.2664794922, 15.777311325073, 0, 0, 0);
    CreateDynamicObject(3461, 655.28112792969, -1203.1965332031, 15.410905838013, 0, 0, 0);
    CreateDynamicObject(3461, 655.38684082031, -1184.7386474609, 16.079545974731, 0, 0, 0);
    CreateDynamicObject(3461, 664.97259521484, -1200.3919677734, 15.222593307495, 0, 0, 0);
    CreateDynamicObject(3461, 676.03289794922, -1187.4228515625, 13.525501251221, 0, 0, 0);
    CreateDynamicObject(3461, 668.84399414063, -1174.1026611328, 13.558477401733, 0, 0, 0);
    CreateDynamicObject(3461, 684.16741943359, -1171.7960205078, 13.109939575195, 0, 0, 0);
    CreateDynamicObject(3461, 673.76635742188, -1165.4305419922, 12.886695861816, 0, 0, 0);
    CreateDynamicObject(3461, 689.72888183594, -1161.8726806641, 13.218494415283, 0, 0, 0);
    CreateDynamicObject(3461, 686.99426269531, -1152.2954101563, 13.45253944397, 0, 0, 0);
    CreateDynamicObject(3461, 693.095703125, -1148.0291748047, 14.064655303955, 0, 0, 0);
    CreateDynamicObject(3461, 702.16430664063, -1155.41015625, 13.861576080322, 0, 0, 0);
    CreateDynamicObject(3461, 706.60095214844, -1145.8587646484, 14.671117782593, 0, 0, 0);
    CreateDynamicObject(3461, 695.44946289063, -1128.4227294922, 15.022312164307, 0, 0, 0);
    CreateDynamicObject(3461, 707.61090087891, -1123.0030517578, 15.227626800537, 0, 0, 0);
    CreateDynamicObject(3461, 711.68963623047, -1135.5886230469, 15.319343566895, 0, 0, 0);
    CreateDynamicObject(3461, 719.22155761719, -1119.4632568359, 16.364751815796, 0, 0, 0);
    CreateDynamicObject(3461, 699.71478271484, -1108.1171875, 16.547761917114, 0, 0, 0);
    CreateDynamicObject(3461, 711.70812988281, -1107.2266845703, 16.749448776245, 0, 0, 0);
    CreateDynamicObject(3461, 725.31781005859, -1108.6848144531, 17.415185928345, 0, 0, 0);
    CreateDynamicObject(3461, 718.45690917969, -1096.7855224609, 17.89552116394, 0, 0, 0);
    CreateDynamicObject(3461, 710.61743164063, -1087.8953857422, 18.5758228302, 0, 0, 0);
    CreateDynamicObject(3461, 726.08807373047, -1081.9549560547, 19.316024780273, 0, 0, 0);
    CreateDynamicObject(3461, 731.53265380859, -1089.8024902344, 18.992309570313, 0, 0, 0);
    CreateDynamicObject(3461, 740.52770996094, -1079.0179443359, 20.276298522949, 0, 0, 0);
    CreateDynamicObject(3461, 751.54791259766, -1071.4992675781, 21.602630615234, 0, 0, 0);
    CreateDynamicObject(3461, 743.58850097656, -1064.9230957031, 21.630628585815, 0, 0, 0);
    CreateDynamicObject(3461, 734.36773681641, -1068.9498291016, 20.728281021118, 0, 0, 0);
    CreateDynamicObject(3461, 753.55499267578, -1055.0291748047, 21.958841323853, 0, 0, 0);

// Ruta alado TV por GROVE4L
    CreateDynamicObject(3594,1319.813,-1404.129,12.944,0.0,0.0,-56.250);
    CreateDynamicObject(3594,1286.338,-1394.984,12.771,0.0,0.0,-112.500);
    CreateDynamicObject(3594,1242.277,-1406.260,12.637,0.0,0.0,-45.000);
    CreateDynamicObject(3594,1206.788,-1394.458,12.915,0.0,0.0,-45.000);
    CreateDynamicObject(3594,1150.061,-1401.569,13.163,0.0,0.0,-101.250);
    CreateDynamicObject(3594,1121.095,-1393.620,13.038,0.0,0.0,-33.750);
    CreateDynamicObject(3594,1084.293,-1397.362,13.127,0.0,0.0,33.750);
    CreateDynamicObject(3594,1051.096,-1407.163,13.000,0.0,0.0,123.750);
    CreateDynamicObject(3594,1019.704,-1396.330,12.675,0.0,0.0,78.750);
    CreateDynamicObject(3594,976.209,-1403.144,12.744,0.0,0.0,225.000);
    CreateDynamicObject(3594,926.504,-1396.653,12.923,0.0,0.0,112.500);
    CreateDynamicObject(3594,880.371,-1403.799,12.549,0.0,0.0,146.250);
    CreateDynamicObject(3594,836.128,-1397.154,13.013,0.0,0.0,236.250);
    CreateDynamicObject(3594,779.437,-1400.973,12.998,0.0,0.0,180.000);
    CreateDynamicObject(3594,717.727,-1393.293,13.048,0.0,0.0,247.500);
    CreateDynamicObject(3594,662.426,-1403.419,13.030,0.0,0.0,326.250);
    CreateDynamicObject(3593,686.617,-1394.904,12.925,0.0,0.0,-45.000);
    CreateDynamicObject(3593,731.069,-1406.290,12.804,0.0,0.0,33.750);
    CreateDynamicObject(3593,800.173,-1404.355,12.764,0.0,0.0,-56.250);
    CreateDynamicObject(3593,858.841,-1399.755,12.495,0.0,0.0,-146.250);
    CreateDynamicObject(3593,957.123,-1404.800,12.644,0.0,0.0,-33.750);
    CreateDynamicObject(3593,992.757,-1392.877,12.539,0.0,0.0,33.750);
    CreateDynamicObject(3593,1056.138,-1393.013,12.867,0.0,0.0,33.750);
    CreateDynamicObject(3593,1111.786,-1406.161,12.815,0.0,0.0,78.750);
    CreateDynamicObject(3593,1178.647,-1400.306,12.699,0.0,0.0,22.500);
    CreateDynamicObject(3593,1264.699,-1403.506,12.414,0.0,0.0,135.000);
    CreateDynamicObject(3593,1305.897,-1405.225,12.672,0.0,0.0,135.000);
    CreateDynamicObject(3593,1331.607,-1392.846,12.804,0.0,0.0,33.750);
    CreateDynamicObject(12957,1308.017,-1395.344,13.129,0.0,0.0,45.000);
    CreateDynamicObject(12957,1230.209,-1398.231,12.995,0.0,0.0,-123.750);
    CreateDynamicObject(12957,1164.404,-1409.283,13.281,0.0,0.0,33.750);
    CreateDynamicObject(12957,1097.227,-1394.784,13.342,0.0,0.0,-22.500);
    CreateDynamicObject(12957,1069.641,-1402.792,13.400,0.0,0.0,45.000);
    CreateDynamicObject(12957,1037.693,-1399.128,13.173,0.0,0.0,-11.250);
    CreateDynamicObject(12957,1010.311,-1406.305,12.910,0.0,0.0,-101.250);
    CreateDynamicObject(12957,938.921,-1403.458,13.170,0.0,0.0,-146.250);
    CreateDynamicObject(12957,910.025,-1393.555,13.151,0.0,0.0,-78.750);
    CreateDynamicObject(12957,848.016,-1406.583,13.166,0.0,0.0,-135.000);
    CreateDynamicObject(12957,828.024,-1392.270,13.255,0.0,0.0,11.250);
    CreateDynamicObject(12957,800.641,-1391.761,13.438,0.0,0.0,67.500);
    CreateDynamicObject(12957,762.615,-1407.016,13.254,0.0,0.0,146.250);
    CreateDynamicObject(12957,736.597,-1392.372,13.286,0.0,0.0,78.750);
    CreateDynamicObject(12957,703.210,-1404.119,13.258,0.0,0.0,-56.250);
    CreateDynamicObject(12957,670.865,-1393.901,13.310,0.0,0.0,-135.000);
    CreateDynamicObject(3593,703.475,-1395.121,12.791,0.0,0.0,22.500);
    CreateDynamicObject(3594,694.658,-1410.345,13.039,0.0,0.0,247.500);
    CreateDynamicObject(3594,748.536,-1401.930,13.003,0.0,0.0,180.000);
    CreateDynamicObject(851,768.123,-1395.981,12.682,0.0,0.0,67.500);
    CreateDynamicObject(851,1325.101,-1394.805,12.331,0.0,0.0,123.750);
    CreateDynamicObject(851,1303.990,-1399.753,12.552,0.0,0.0,90.000);
    CreateDynamicObject(852,1326.152,-1407.048,12.296,0.0,0.0,0.0);
    CreateDynamicObject(910,1260.262,-1396.591,13.285,0.0,0.0,146.250);
    CreateDynamicObject(910,1183.330,-1407.574,13.493,0.0,0.0,90.000);
    CreateDynamicObject(912,1147.895,-1392.107,13.178,0.0,0.0,56.250);
    CreateDynamicObject(923,1127.704,-1406.307,13.322,0.0,0.0,67.500);
    CreateDynamicObject(923,1045.766,-1397.098,13.268,0.0,0.0,123.750);
    CreateDynamicObject(923,970.480,-1396.558,12.879,0.0,0.0,180.000);
    CreateDynamicObject(923,916.791,-1407.124,13.114,0.0,0.0,112.500);
    CreateDynamicObject(923,821.833,-1403.593,13.295,0.0,0.0,236.250);
    CreateDynamicObject(923,722.826,-1400.927,13.253,0.0,0.0,180.000);
    CreateDynamicObject(923,677.957,-1403.630,13.281,0.0,0.0,315.000);
    CreateDynamicObject(952,753.304,-1399.833,13.709,0.0,0.0,56.250);
    CreateDynamicObject(952,890.251,-1400.045,13.395,0.0,0.0,135.000);
    CreateDynamicObject(952,1110.097,-1398.664,13.758,0.0,0.0,202.500);
    CreateDynamicObject(952,1215.868,-1406.480,13.551,0.0,0.0,247.500);
    CreateDynamicObject(1265,1275.670,-1401.797,12.522,0.0,0.0,0.0);
    CreateDynamicObject(1265,1277.968,-1401.046,12.537,0.0,0.0,67.500);
    CreateDynamicObject(1265,1251.491,-1408.703,12.482,0.0,0.0,33.750);
    CreateDynamicObject(1236,1280.202,-1388.779,13.075,0.0,0.0,67.500);
    CreateDynamicObject(1236,1079.829,-1408.247,13.185,0.0,0.0,180.000);
    CreateDynamicObject(1333,792.044,-1390.337,13.435,0.0,0.0,67.500);
    CreateDynamicObject(1333,679.695,-1399.660,13.320,0.0,0.0,-11.250);
    CreateDynamicObject(1299,679.880,-1405.297,12.854,0.0,0.0,22.500);
    CreateDynamicObject(12957,796.748,-1373.915,13.284,0.0,0.0,202.500);
    CreateDynamicObject(12957,798.657,-1352.228,13.261,0.0,0.0,101.250);
    CreateDynamicObject(3594,804.477,-1366.353,13.178,0.0,0.0,236.250);
    CreateDynamicObject(3594,913.450,-1378.505,12.942,0.0,0.0,236.250);
    CreateDynamicObject(3594,919.409,-1362.588,12.835,0.0,0.0,146.250);
    CreateDynamicObject(3594,1046.892,-1389.472,13.085,0.0,0.0,225.000);
    CreateDynamicObject(3594,1330.769,-1404.345,12.995,0.0,0.0,146.250);
    CreateDynamicObject(1299,648.509,-1397.466,12.850,0.0,0.0,78.750);
    CreateDynamicObject(3594,650.287,-1405.291,13.030,0.0,0.0,236.250);

//Refugio TV por GROVE4L
    CreateDynamicObject(969,776.926,-1330.107,12.717,0.0,0.0,-1.719);
    CreateDynamicObject(3578,778.410,-1384.879,12.824,0.0,0.0,180.000);
    CreateDynamicObject(923,760.115,-1348.384,13.391,0.0,0.0,56.250);
    CreateDynamicObject(923,758.910,-1342.912,13.402,0.0,0.0,-11.250);
    CreateDynamicObject(939,733.130,-1346.848,14.956,0.0,0.0,90.000);
    CreateDynamicObject(960,748.253,-1348.254,12.892,0.0,0.0,78.750);
    CreateDynamicObject(960,744.762,-1351.652,12.882,0.0,0.0,33.750);
    CreateDynamicObject(960,738.437,-1350.292,12.882,0.0,0.0,123.750);
    CreateDynamicObject(960,740.030,-1351.029,12.882,0.0,0.0,45.000);
    CreateDynamicObject(960,758.939,-1347.607,12.893,0.0,0.0,56.250);
    CreateDynamicObject(961,748.249,-1348.269,12.864,0.0,0.0,78.750);
    CreateDynamicObject(1227,768.141,-1336.388,13.388,0.0,0.0,112.500);
    CreateDynamicObject(1415,775.138,-1384.150,12.826,0.0,0.0,-180.000);
    CreateDynamicObject(1415,775.781,-1384.144,13.127,0.859,-90.241,-180.000);
    CreateDynamicObject(1438,766.934,-1365.892,12.546,0.0,0.0,67.500);
    CreateDynamicObject(1438,775.836,-1353.609,12.564,0.0,0.0,11.250);
    CreateDynamicObject(1558,768.392,-1368.330,13.095,0.0,0.0,45.000);
    CreateDynamicObject(1558,764.708,-1368.290,13.091,0.0,0.0,-33.750);
    CreateDynamicObject(2672,779.941,-1388.011,12.920,0.0,0.0,0.0);
    CreateDynamicObject(2672,762.331,-1360.815,12.801,0.0,0.0,67.500);
    CreateDynamicObject(2672,776.949,-1332.695,12.821,0.0,0.0,67.500);
    CreateDynamicObject(2672,752.287,-1337.012,12.811,0.0,0.0,101.250);
    CreateDynamicObject(2674,782.663,-1344.191,12.560,0.0,0.0,45.000);
    CreateDynamicObject(2674,770.334,-1348.509,12.545,0.0,0.0,45.000);
    CreateDynamicObject(2676,782.172,-1373.363,12.677,0.0,0.0,-101.250);
    CreateDynamicObject(2676,738.603,-1335.020,12.643,0.0,0.0,45.000);
    CreateDynamicObject(3594,789.163,-1382.994,13.536,-8.594,-35.237,-157.500);
    CreateDynamicObject(3594,766.513,-1328.430,13.178,-8.594,-35.237,-78.750);
    CreateDynamicObject(3594,797.320,-1345.067,13.014,0.0,0.0,-22.500);
    CreateDynamicObject(3594,799.262,-1374.982,13.025,0.0,0.0,45.000);
    CreateDynamicObject(3594,754.818,-1317.210,13.022,0.0,0.0,123.750);
    CreateDynamicObject(12957,784.883,-1323.556,13.261,0.0,0.0,33.750);
    CreateDynamicObject(12957,812.616,-1337.422,13.419,0.0,0.0,33.750);
    CreateDynamicObject(12957,808.310,-1351.690,13.421,0.0,0.0,-45.000);
    CreateDynamicObject(12957,765.012,-1387.567,13.533,-32.659,0.0,-180.000);
    CreateDynamicObject(2905,775.269,-1376.483,12.699,0.0,0.0,45.000);
    CreateDynamicObject(2906,781.480,-1364.411,12.611,0.0,0.0,56.250);
    CreateDynamicObject(2907,754.620,-1333.309,12.703,0.0,0.0,78.750);
    CreateDynamicObject(2908,771.079,-1336.134,12.614,0.0,0.0,45.000);
    CreateDynamicObject(2909,649.333,-1354.214,13.853,0.0,0.0,180.000);
    CreateDynamicObject(2909,649.271,-1362.511,13.877,0.0,0.0,180.000);
    CreateDynamicObject(2901,772.728,-1327.967,12.944,0.0,0.0,22.500);
    CreateDynamicObject(2900,766.518,-1346.087,12.515,0.0,0.0,45.000);
    CreateDynamicObject(2899,779.733,-1330.853,12.665,0.0,0.0,90.000);
    CreateDynamicObject(2899,775.012,-1330.816,12.665,0.0,0.0,90.000);
    CreateDynamicObject(3359,767.780,-1378.724,12.488,0.0,0.0,-180.000);
    CreateDynamicObject(2907,740.271,-1341.484,12.682,0.0,0.0,135.000);
    CreateDynamicObject(2907,781.769,-1339.065,12.698,0.0,0.0,101.250);
    CreateDynamicObject(2907,777.742,-1357.133,12.693,0.0,0.0,157.500);
    CreateDynamicObject(2907,763.915,-1364.528,12.676,0.0,0.0,78.750);
    CreateDynamicObject(2907,764.282,-1379.697,12.817,0.0,0.0,146.250);
    CreateDynamicObject(2907,769.963,-1375.646,12.758,0.0,0.0,123.750);
    CreateDynamicObject(2906,772.003,-1340.695,12.600,0.0,0.0,123.750);
    CreateDynamicObject(2906,757.412,-1329.908,12.621,0.0,0.0,101.250);
    CreateDynamicObject(2906,745.317,-1340.342,12.598,0.0,0.0,146.250);
    CreateDynamicObject(2906,749.858,-1347.498,12.583,0.0,0.0,90.000);
    CreateDynamicObject(2906,767.479,-1367.867,12.594,0.0,0.0,11.250);
    CreateDynamicObject(2906,770.942,-1379.411,12.736,0.0,0.0,11.250);
    CreateDynamicObject(2908,772.098,-1335.684,12.612,0.0,0.0,101.250);
    CreateDynamicObject(2908,779.510,-1367.441,12.612,0.0,0.0,135.000);
    CreateDynamicObject(2908,780.586,-1376.400,12.710,0.0,0.0,191.250);
    CreateDynamicObject(2908,749.173,-1351.577,12.577,0.0,0.0,236.250);
    CreateDynamicObject(2908,765.186,-1380.389,12.725,0.0,0.0,315.000);
    CreateDynamicObject(3279,784.448,-1334.298,12.266,0.0,0.0,-90.000);
    CreateDynamicObject(3279,745.451,-1334.482,12.394,0.0,0.0,-90.000);
    CreateDynamicObject(3787,764.607,-1381.625,13.230,0.0,0.0,0.0);
    CreateDynamicObject(3791,768.763,-1380.447,13.117,0.0,0.0,-56.250);
    CreateDynamicObject(16093,751.450,-1371.569,28.973,0.0,0.0,90.000);
    CreateDynamicObject(11472,738.555,-1360.371,21.493,0.0,0.0,-90.000);
    CreateDynamicObject(13011,748.031,-1365.774,25.700,0.0,0.0,-90.000);
    CreateDynamicObject(970,754.908,-1374.286,29.132,0.0,0.0,90.000);
    CreateDynamicObject(970,754.916,-1370.143,29.132,0.0,0.0,90.000);
    CreateDynamicObject(970,754.893,-1368.718,29.107,0.0,0.0,90.000);
    CreateDynamicObject(970,752.818,-1376.331,29.157,0.0,0.0,180.000);
    CreateDynamicObject(970,748.696,-1376.338,29.157,0.0,0.0,180.000);

// Base Cerca Glen por JuanWtf
    CreateDynamicObject(3115, 1983.8345947266, -2065.8466796875, 18.095439910889, 0, 0, 0);
    CreateDynamicObject(3851, 1988.6486816406, -2056.5434570313, 14.299849510193, 0, 0, 269.93408203125);
    CreateDynamicObject(3851, 1978.9951171875, -2056.5498046875, 14.299849510193, 0, 0, 269.93408203125);
    CreateDynamicObject(3033, 1977.333984375, -2056.529296875, 14.426284790039, 0, 0, 0);
    CreateDynamicObject(3033, 1977.333984375, -2056.529296875, 18.186277389526, 0, 0, 0);
    CreateDynamicObject(3033, 1982.9217529297, -2056.5244140625, 14.426284790039, 0, 0, 0);
    CreateDynamicObject(3033, 1982.9208984375, -2056.5244140625, 18.186277389526, 0, 0, 0);
    CreateDynamicObject(3033, 1988.3176269531, -2056.533203125, 14.426284790039, 0, 0, 0);
    CreateDynamicObject(3033, 1988.3173828125, -2056.533203125, 18.186277389526, 0, 0, 0);
    CreateDynamicObject(3033, 1991.5422363281, -2056.533203125, 18.186277389526, 0, 0, 0);
    CreateDynamicObject(3033, 1991.5419921875, -2056.533203125, 14.426284790039, 0, 0, 0);
    CreateDynamicObject(3851, 1994.4509277344, -2062.0922851563, 15.834540367126, 0, 0, 359.99951171875);
    CreateDynamicObject(3851, 1994.4338378906, -2073.3696289063, 15.834540367126, 0, 0, 359.99450683594);
    CreateDynamicObject(3033, 1976.107421875, -2056.498046875, 18.186277389526, 0, 0, 0);
    CreateDynamicObject(3033, 1976.1046142578, -2056.5278320313, 14.426284790039, 0, 0, 0);
    CreateDynamicObject(3033, 1973.3709716797, -2067.6552734375, 13.275266647339, 0, 0, 90.054931640625);
    CreateDynamicObject(3033, 1973.3979492188, -2062.1687011719, 13.275266647339, 0, 0, 90.054931640625);
    CreateDynamicObject(3033, 1973.39453125, -2059.318359375, 18.10954284668, 0, 0, 90.054901123047);
    CreateDynamicObject(3851, 1973.4008789063, -2065.0458984375, 14.388289451599, 0, 0, 359.99450683594);
    CreateDynamicObject(3033, 1973.4123535156, -2064.8342285156, 18.10954284668, 0, 0, 90.054931640625);
    CreateDynamicObject(3033, 1973.3850097656, -2070.3391113281, 18.10954284668, 0, 0, 89.291656494141);
    CreateDynamicObject(2290, 1974.0015869141, -2062.4150390625, 12.386852264404, 0, 0, 90.065490722656);
    CreateDynamicObject(2290, 1974.0892333984, -2066.6401367188, 12.386852264404, 0, 0, 90.060424804688);
    CreateDynamicObject(3997, 1414.6126708984, 5333.8955078125, 17.812580108643, 0, 0, 0);
    CreateDynamicObject(974, 1337.7657470703, 5293.9541015625, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1344.2960205078, 5293.9462890625, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1350.9372558594, 5293.95703125, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1357.4562988281, 5293.9697265625, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1364.0524902344, 5293.984375, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1370.5070800781, 5293.9663085938, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1377.1115722656, 5293.9819335938, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1383.6187744141, 5293.9545898438, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1390.1899414063, 5293.9916992188, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1396.7006835938, 5293.9619140625, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1403.3614501953, 5293.94140625, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1409.8009033203, 5293.9301757813, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1416.3283691406, 5293.9233398438, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1422.9324951172, 5293.9155273438, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1429.5360107422, 5293.9077148438, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1436.0627441406, 5293.9008789063, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1442.5900878906, 5293.8940429688, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1449.1942138672, 5293.8862304688, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1455.8745117188, 5293.8774414063, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1462.4016113281, 5293.8706054688, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1469.0057373047, 5293.8627929688, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1475.4556884766, 5293.8569335938, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1481.9826660156, 5293.8500976563, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1488.5867919922, 5293.8422851563, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1495.1903076172, 5293.8344726563, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1494.7603759766, 5297.1665039063, 20.590320587158, 0, 0, 90.066314697266);
    CreateDynamicObject(974, 1494.7502441406, 5303.7094726563, 20.590320587158, 0, 0, 90.06591796875);
    CreateDynamicObject(974, 1494.7504882813, 5310.3002929688, 20.590320587158, 0, 0, 90.06591796875);
    CreateDynamicObject(974, 1494.7138671875, 5323.2895507813, 20.590320587158, 0, 0, 90.06591796875);
    CreateDynamicObject(974, 1494.6977539063, 5329.8188476563, 20.590320587158, 0, 0, 90.06591796875);
    CreateDynamicObject(974, 1494.6743164063, 5336.1948242188, 20.590320587158, 0, 0, 90.06591796875);
    CreateDynamicObject(974, 1494.6577148438, 5342.7241210938, 20.590320587158, 0, 0, 90.06591796875);
    CreateDynamicObject(974, 1494.6003417969, 5349.2495117188, 20.590320587158, 0, 0, 90.06591796875);
    CreateDynamicObject(974, 1494.595703125, 5355.8486328125, 20.590320587158, 0, 0, 90.060424804688);
    CreateDynamicObject(974, 1494.591796875, 5362.4482421875, 20.590320587158, 0, 0, 90.060424804688);
    CreateDynamicObject(974, 1494.6052246094, 5368.9736328125, 20.590320587158, 0, 0, 90.06591796875);
    CreateDynamicObject(974, 1494.6009521484, 5375.5737304688, 20.590320587158, 0, 0, 90.06591796875);
    CreateDynamicObject(974, 1494.5391845703, 5382.0815429688, 20.590320587158, 0, 0, 90.06591796875);
    CreateDynamicObject(974, 1494.5355224609, 5388.6811523438, 20.590320587158, 0, 0, 90.06591796875);
    CreateDynamicObject(14416, 1433.3009033203, 5395.4233398438, 17.812580108643, 0, 0, 0);
    CreateDynamicObject(14416, 1429.3889160156, 5395.4287109375, 17.812580108643, 0, 0, 0);
    CreateDynamicObject(14416, 1425.4006347656, 5395.435546875, 17.812580108643, 0, 0, 0);
    CreateDynamicObject(14416, 1421.4890136719, 5395.4370117188, 17.812580108643, 0, 0, 0);
    CreateDynamicObject(14416, 1417.4946289063, 5395.3911132813, 17.812580108643, 0, 0, 0);
    CreateDynamicObject(14416, 1413.5776367188, 5395.3427734375, 17.812580108643, 0, 0, 0);
    CreateDynamicObject(14416, 1409.5986328125, 5395.294921875, 17.812580108643, 0, 0, 0);
    CreateDynamicObject(974, 1494.5357666016, 5390.498046875, 20.590320587158, 0, 0, 90.06591796875);
    CreateDynamicObject(974, 1491.2208251953, 5392.9228515625, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1484.5729980469, 5392.9248046875, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1478.0006103516, 5392.9169921875, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1471.4283447266, 5392.9091796875, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1464.9321289063, 5392.8916015625, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1458.359375, 5392.8837890625, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1451.7877197266, 5392.8759765625, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1445.2154541016, 5392.8681640625, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1438.6997070313, 5392.8916015625, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1435.4694824219, 5396.2348632813, 20.590320587158, 0, 0, 269.16870117188);
    CreateDynamicObject(974, 1435.46875, 5396.234375, 26.115207672119, 0, 0, 269.1650390625);
    CreateDynamicObject(974, 1494.7280273438, 5316.8383789063, 20.590320587158, 0, 0, 90.06591796875);
    CreateDynamicObject(974, 1335.4216308594, 5297.2231445313, 20.590320587158, 0, 0, 90.06591796875);
    CreateDynamicObject(974, 1335.4020996094, 5303.8310546875, 20.590320587158, 0, 0, 90.06591796875);
    CreateDynamicObject(974, 1335.3863525391, 5310.3627929688, 20.590320587158, 0, 0, 90.06591796875);
    CreateDynamicObject(974, 1335.3669433594, 5316.970703125, 20.590320587158, 0, 0, 90.06591796875);
    CreateDynamicObject(974, 1335.3511962891, 5323.5024414063, 20.590320587158, 0, 0, 90.06591796875);
    CreateDynamicObject(974, 1335.3355712891, 5330.0336914063, 20.590320587158, 0, 0, 90.06591796875);
    CreateDynamicObject(974, 1335.3161621094, 5336.6416015625, 20.590320587158, 0, 0, 90.06591796875);
    CreateDynamicObject(974, 1335.2966308594, 5343.25, 20.590320587158, 0, 0, 90.06591796875);
    CreateDynamicObject(974, 1335.2808837891, 5349.7817382813, 20.590320587158, 0, 0, 90.06591796875);
    CreateDynamicObject(974, 1335.2652587891, 5356.3129882813, 20.590320587158, 0, 0, 90.06591796875);
    CreateDynamicObject(974, 1335.2458496094, 5362.9208984375, 20.590320587158, 0, 0, 90.06591796875);
    CreateDynamicObject(974, 1335.2263183594, 5369.529296875, 20.590320587158, 0, 0, 90.06591796875);
    CreateDynamicObject(974, 1335.2105712891, 5376.0610351563, 20.590320587158, 0, 0, 90.06591796875);
    CreateDynamicObject(974, 1335.1911621094, 5382.6689453125, 20.590320587158, 0, 0, 90.06591796875);
    CreateDynamicObject(974, 1335.1716308594, 5389.27734375, 20.590320587158, 0, 0, 90.06591796875);
    CreateDynamicObject(974, 1335.1756591797, 5390.5263671875, 20.590320587158, 0, 0, 90.06591796875);
    CreateDynamicObject(974, 1338.4866943359, 5393.2944335938, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1345.0584716797, 5393.310546875, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1351.6354980469, 5393.3173828125, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1358.2126464844, 5393.32421875, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1364.7557373047, 5393.3374023438, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1371.2987060547, 5393.3500976563, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1377.8416748047, 5393.3627929688, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1384.3929443359, 5393.3891601563, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1391.072265625, 5393.388671875, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1397.6748046875, 5393.388671875, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1404.2012939453, 5393.388671875, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1407.4906005859, 5396.7451171875, 20.590320587158, 0, 0, 269.1650390625);
    CreateDynamicObject(974, 1407.490234375, 5396.7451171875, 26.038473129272, 0, 0, 269.1650390625);
    CreateDynamicObject(6959, 1421.5693359375, 5418.0126953125, 21.034317016602, 0, 0, 0);
    CreateDynamicObject(974, 1404.1960449219, 5400.0034179688, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1404.1953125, 5400.0029296875, 25.961738586426, 0, 0, 0);
    CreateDynamicObject(974, 1438.8140869141, 5399.5336914063, 20.590320587158, 0, 0, 0);
    CreateDynamicObject(974, 1438.8134765625, 5399.533203125, 25.961738586426, 0, 0, 0);
    CreateDynamicObject(8420, 1421.6220703125, 5473.919921875, 21.040306091309, 0, 0, 271.45568847656);
    CreateDynamicObject(16771, 1482.677734375, 5468.7744140625, 27.623378753662, 0, 0, 91.587524414063);
    CreateDynamicObject(974, 1442.0306396484, 5402.8017578125, 23.780807495117, 0, 0, 90.060424804688);
    CreateDynamicObject(974, 1441.9971923828, 5409.435546875, 23.780807495117, 0, 0, 90.060424804688);
    CreateDynamicObject(974, 1441.9261474609, 5416.0024414063, 23.780807495117, 0, 0, 90.060424804688);
    CreateDynamicObject(974, 1441.8740234375, 5422.5390625, 23.780807495117, 0, 0, 90.060424804688);
    CreateDynamicObject(974, 1441.8464355469, 5429.134765625, 23.780807495117, 0, 0, 90.060424804688);
    CreateDynamicObject(974, 1441.8837890625, 5431.1279296875, 23.780807495117, 0, 0, 90.060424804688);
    CreateDynamicObject(974, 1401.1428222656, 5403.3505859375, 23.780807495117, 0, 0, 90.060424804688);
    CreateDynamicObject(974, 1401.1274414063, 5409.9013671875, 23.780807495117, 0, 0, 90.060424804688);
    CreateDynamicObject(974, 1401.1726074219, 5416.5419921875, 23.780807495117, 0, 0, 90.060424804688);
    CreateDynamicObject(974, 1401.1751708984, 5423.1704101563, 23.780807495117, 0, 0, 90.060424804688);
    CreateDynamicObject(974, 1401.1872558594, 5429.7983398438, 23.780807495117, 0, 0, 90.060424804688);
    CreateDynamicObject(974, 1445.1508789063, 5434.5634765625, 23.802417755127, 0, 0, 1.5265502929688);
    CreateDynamicObject(974, 1451.7690429688, 5434.7221679688, 23.802417755127, 0, 0, 1.5216064453125);
    CreateDynamicObject(974, 1458.3048095703, 5434.8779296875, 23.802417755127, 0, 0, 1.5216064453125);
    CreateDynamicObject(974, 1461.576171875, 5438.3271484375, 23.794609069824, 0, 0, 81.664398193359);
    CreateDynamicObject(974, 1397.8620605469, 5433.2431640625, 23.794609069824, 0, 0, 357.71008300781);
    CreateDynamicObject(974, 1391.2797851563, 5433.2817382813, 23.794609069824, 0, 0, 1.5258483886719);
    CreateDynamicObject(974, 1386.1358642578, 5433.1391601563, 23.794609069824, 0, 0, 1.5216064453125);
    CreateDynamicObject(8650, 1436.0490722656, 5433.7919921875, 20.583711624146, 0, 0, 271.46105957031);
    CreateDynamicObject(8650, 1405.7294921875, 5433.0131835938, 20.583711624146, 0, 0, 271.45568847656);
    CreateDynamicObject(18449, 1343.0688476563, 5440.0087890625, 20.633010864258, 0, 0, 0.76327514648438);
    CreateDynamicObject(18449, 1263.2928466797, 5438.9204101563, 20.640235900879, 0, 0, 0.758056640625);
    CreateDynamicObject(18449, 1183.5444335938, 5437.8583984375, 20.640235900879, 0, 0, 0.758056640625);
    CreateDynamicObject(18449, 1103.6330566406, 5436.8354492188, 20.640235900879, 0, 0, 0.758056640625);
    CreateDynamicObject(18449, 1024.0812988281, 5435.763671875, 20.640235900879, 0, 0, 0.758056640625);
    CreateDynamicObject(18449, 944.41925048828, 5434.7016601563, 20.640235900879, 0, 0, 0.758056640625);
    CreateDynamicObject(18449, 864.62280273438, 5433.6430664063, 20.640235900879, 0, 0, 0.758056640625);
    CreateDynamicObject(17310, 813.65551757813, 5432.8984375, 25.211515426636, 0, 212.689453125, 0.76327514648438);
    CreateDynamicObject(18449, 733.1357421875, 5432.7358398438, 7.5199952125549, 0, 0, 0.758056640625);
    CreateDynamicObject(18449, 653.67126464844, 5431.6372070313, 7.5199952125549, 0, 0, 0.758056640625);
    CreateDynamicObject(18449, 577.58709716797, 5430.64453125, 16.267734527588, 0, 12.975524902344, 0.758056640625);
    CreateDynamicObject(18449, 498.87487792969, 5429.6342773438, 25.180124282837, 0, 0, 0.758056640625);
    CreateDynamicObject(18449, 418.99383544922, 5428.6015625, 25.180124282837, 0, 0, 0.758056640625);
    CreateDynamicObject(18449, 339.09283447266, 5427.5830078125, 25.180124282837, 0, 0, 0.758056640625);
    CreateDynamicObject(18449, 339.03656005859, 5431.0517578125, 25.180124282837, 12.212249755859, 0, 0.758056640625);
    CreateDynamicObject(18449, 338.87756347656, 5435.5634765625, 26.177673339844, 31.292938232422, 0, 0.758056640625);
    CreateDynamicObject(18449, 338.85095214844, 5439.2290039063, 28.402975082397, 45.791137695313, 0, 0.758056640625);
    CreateDynamicObject(18449, 338.83898925781, 5441.9482421875, 31.242153167725, 60.293090820313, 0, 0.758056640625);
    CreateDynamicObject(18449, 259.09646606445, 5440.9291992188, 31.242153167725, 60.29296875, 0, 0.758056640625);
    CreateDynamicObject(18449, 259.3166809082, 5438.2094726563, 28.402975082397, 45.791015625, 0, 0.758056640625);
    CreateDynamicObject(18449, 180.66146850586, 5425.9072265625, 25.180124282837, 0, 0, 0.758056640625);
    CreateDynamicObject(18449, 180.14111328125, 5428.986328125, 25.180124282837, 12.211303710938, 0, 0.758056640625);
    CreateDynamicObject(18449, 179.49243164063, 5433.5498046875, 26.177673339844, 31.2890625, 0, 0.758056640625);
    CreateDynamicObject(18449, 259.24203491211, 5434.5791015625, 26.177673339844, 31.2890625, 0, 0.758056640625);
    CreateDynamicObject(18449, 179.4578704834, 5437.1870117188, 28.402975082397, 45.791015625, 0, 0.758056640625);
    CreateDynamicObject(18449, 179.35021972656, 5439.8540039063, 31.242153167725, 60.29296875, 0, 0.758056640625);
    CreateDynamicObject(18449, 100.94287872314, 5424.8486328125, 25.180124282837, 0, 0, 0.758056640625);
    CreateDynamicObject(18449, 21.10103225708, 5423.8002929688, 25.180124282837, 0, 0, 0.758056640625);
    CreateDynamicObject(3521, 1385.74609375, 5449.5083007813, 22.772970199585, 0, 0, 1.5265502929688);
    CreateDynamicObject(6299, 1402.1579589844, 5466.9291992188, 23.287256240845, 0, 0, 0);
    CreateDynamicObject(1570, 1425.8837890625, 5487.5107421875, 22.347993850708, 0, 0, 93.118621826172);
    CreateDynamicObject(3863, 1404.6749267578, 5483.6987304688, 22.189199447632, 0, 0, 0);
    CreateDynamicObject(6462, 1411.9842529297, 5463.1787109375, 23.02592086792, 0, 0, 0);
    CreateDynamicObject(6299, 1421.4636230469, 5475.77734375, 23.287256240845, 0, 0, 2.289794921875);
    CreateDynamicObject(1342, 1417.3930664063, 5472.3583984375, 22.050561904907, 0, 0, 0);
    CreateDynamicObject(1342, 1417.4871826172, 5465.8154296875, 22.050561904907, 0, 0, 0);
    CreateDynamicObject(1340, 1417.3868408203, 5468.9365234375, 22.144454956055, 0, 0, 0);
    CreateDynamicObject(1340, 1417.7537841797, 5462.875, 22.144454956055, 0, 0, 0);
    CreateDynamicObject(1363, 1425.9901123047, 5459.4350585938, 21.853231430054, 0, 0, 0);
    CreateDynamicObject(1571, 1427.4488525391, 5454.7260742188, 22.347684860229, 0, 0, 0);
    CreateDynamicObject(1225, 1339.5198974609, 5443.8500976563, 21.382514953613, 0, 0, 0);
    CreateDynamicObject(1225, 1339.484375, 5442.009765625, 21.382514953613, 0, 0, 0);
    CreateDynamicObject(1225, 1339.4448242188, 5439.9399414063, 21.382514953613, 0, 0, 0);
    CreateDynamicObject(1225, 1239.7919921875, 5438.4184570313, 21.389739990234, 0, 0, 0);
    CreateDynamicObject(1225, 1239.6096191406, 5436.0771484375, 21.389739990234, 0, 0, 0);
    CreateDynamicObject(1225, 1239.4361572266, 5433.66015625, 21.389739990234, 0, 0, 0);
    CreateDynamicObject(1225, 1143.0279541016, 5437.2749023438, 21.389739990234, 0, 0, 0);
    CreateDynamicObject(1225, 1139.0092773438, 5437.0678710938, 21.389739990234, 0, 0, 0);
    CreateDynamicObject(1225, 1138.5104980469, 5443.1293945313, 21.389739990234, 0, 0, 0);
    CreateDynamicObject(1225, 1143.3493652344, 5443.0356445313, 21.389739990234, 0, 0, 0);
    CreateDynamicObject(1225, 1143.2180175781, 5431.236328125, 21.389739990234, 0, 0, 0);
    CreateDynamicObject(1225, 1138.9641113281, 5430.9721679688, 21.389739990234, 0, 0, 0);
    CreateDynamicObject(1225, 1029.0849609375, 5435.6245117188, 21.389739990234, 0, 0, 0);
    CreateDynamicObject(1225, 1018.9779663086, 5429.7080078125, 21.389739990234, 0, 0, 0);
    CreateDynamicObject(1225, 1012.5404663086, 5435.4755859375, 21.389739990234, 0, 0, 0);
    CreateDynamicObject(1225, 935.17517089844, 5434.9765625, 21.389739990234, 0, 0, 0);
    CreateDynamicObject(1225, 935.24609375, 5436.203125, 21.389739990234, 0, 0, 0);
    CreateDynamicObject(1225, 935.32440185547, 5433.5834960938, 21.389739990234, 0, 0, 0);
    CreateDynamicObject(1225, 826.38421630859, 5426.4233398438, 21.591739654541, 0, 0, 0);
    CreateDynamicObject(1225, 826.16595458984, 5439.7924804688, 21.591739654541, 0, 0, 0);
    CreateDynamicObject(1225, 770.68774414063, 5427.7719726563, 8.2694997787476, 0, 0, 0);
    CreateDynamicObject(1225, 767.99072265625, 5429.2119140625, 8.2694997787476, 0, 0, 0);
    CreateDynamicObject(1225, 768.54248046875, 5432.14453125, 8.2694997787476, 0, 0, 0);
    CreateDynamicObject(1225, 766.88745117188, 5434.5571289063, 8.2694997787476, 0, 0, 0);
    CreateDynamicObject(1225, 768.95239257813, 5436.8159179688, 8.2694997787476, 0, 0, 0);
    CreateDynamicObject(1225, 770.45654296875, 5438.16796875, 8.2694997787476, 0, 0, 0);
    CreateDynamicObject(1225, 771.60571289063, 5433.9038085938, 8.2694997787476, 0, 0, 0);
    CreateDynamicObject(1225, 765.89965820313, 5431.3930664063, 8.2694997787476, 0, 0, 0);
    CreateDynamicObject(1225, 765.01391601563, 5436.2299804688, 8.2694997787476, 0, 0, 0);
    CreateDynamicObject(1225, 766.01635742188, 5427.8666992188, 8.2694997787476, 0, 0, 0);
    CreateDynamicObject(1225, 668.45001220703, 5426.7045898438, 8.2694997787476, 0, 0, 0);
    CreateDynamicObject(1225, 668.38989257813, 5428.5693359375, 8.2694997787476, 0, 0, 0);
    CreateDynamicObject(1225, 668.27026367188, 5430.7353515625, 8.2694997787476, 0, 0, 0);
    CreateDynamicObject(1225, 534.79431152344, 5424.5971679688, 25.929628372192, 0, 0, 0);
    CreateDynamicObject(1225, 534.78540039063, 5426.1298828125, 25.929628372192, 0, 0, 0);
    CreateDynamicObject(1225, 534.77661132813, 5427.6630859375, 25.929628372192, 0, 0, 0);
    CreateDynamicObject(1225, 534.76739501953, 5429.2729492188, 25.929628372192, 0, 0, 0);
    CreateDynamicObject(1225, 534.75634765625, 5431.1123046875, 25.929628372192, 0, 0, 0);
    CreateDynamicObject(1225, 534.74731445313, 5432.6455078125, 25.929628372192, 0, 0, 0);
    CreateDynamicObject(1225, 534.73681640625, 5434.4853515625, 25.929628372192, 0, 0, 0);
    CreateDynamicObject(1225, 534.72521972656, 5436.478515625, 25.929628372192, 0, 0, 0);
    CreateDynamicObject(1225, 422.37796020508, 5428.6499023438, 25.929628372192, 0, 0, 0);
    CreateDynamicObject(1225, 422.34606933594, 5430.029296875, 25.929628372192, 0, 0, 0);
    CreateDynamicObject(1225, 422.30676269531, 5431.7158203125, 25.929628372192, 0, 0, 0);
    CreateDynamicObject(1225, 422.26239013672, 5433.6323242188, 25.929628372192, 0, 0, 0);
    CreateDynamicObject(1225, 360.73135375977, 5427.1733398438, 25.929628372192, 0, 0, 0);
    CreateDynamicObject(1225, 361.16259765625, 5423.12109375, 25.929628372192, 0, 0, 0);
    CreateDynamicObject(1225, 360.21392822266, 5431.3090820313, 25.929628372192, 0, 0, 0);
    CreateDynamicObject(1225, 218.35025024414, 5422.8510742188, 25.929628372192, 0, 0, 0);
    CreateDynamicObject(1225, 218.31616210938, 5425.5131835938, 25.929628372192, 0, 0, 0);
    CreateDynamicObject(1225, 218.35308837891, 5428.8588867188, 25.929628372192, 0, 0, 0);
    CreateDynamicObject(1225, 138.82885742188, 5425.9780273438, 25.929628372192, 0, 0, 0);
    CreateDynamicObject(1225, 138.75485229492, 5427.3662109375, 25.929628372192, 0, 0, 0);
    CreateDynamicObject(1225, 138.83383178711, 5428.74609375, 25.929628372192, 0, 0, 0);
    CreateDynamicObject(1225, 138.64205932617, 5430.7568359375, 25.929628372192, 0, 0, 0);
    CreateDynamicObject(1225, 61.018676757813, 5424.2231445313, 25.929628372192, 0, 0, 0);
    CreateDynamicObject(1225, 60.931770324707, 5422.3061523438, 25.929628372192, 0, 0, 0);
    CreateDynamicObject(1225, 60.806671142578, 5419.5458984375, 25.929628372192, 0, 0, 0);
    CreateDynamicObject(1225, -17.95401763916, 5424.69921875, 25.929628372192, 0, 0, 0);
    CreateDynamicObject(1225, -18.303846359253, 5426.474609375, 25.929628372192, 0, 0, 0);
    CreateDynamicObject(1225, -18.446166992188, 5428.1518554688, 25.929628372192, 0, 0, 0);
    CreateDynamicObject(18449, -58.339668273926, 5422.7314453125, 25.180124282837, 0, 0, 0.758056640625);
    CreateDynamicObject(18449, -137.4249420166, 5421.6806640625, 25.104579925537, 0, 0, 0.758056640625);
    CreateDynamicObject(18449, -216.90444946289, 5420.6142578125, 25.084003448486, 0, 0, 0.758056640625);
    CreateDynamicObject(18449, -58.823947906494, 5418.1333007813, 31.165418624878, 299.06994628906, 180, 180.75805664063);
    CreateDynamicObject(18449, -58.911926269531, 5426.8657226563, 31.088684082031, 60.166809082031, 180, 180.75805664063);
    CreateDynamicObject(18449, -138.54191589355, 5417.0122070313, 31.165418624878, 299.06982421875, 179.99450683594, 180.75256347656);
    CreateDynamicObject(18449, -218.31112670898, 5415.927734375, 31.165418624878, 299.06982421875, 179.99450683594, 180.75256347656);
    CreateDynamicObject(18449, -138.75947570801, 5425.8002929688, 31.088684082031, 60.166625976563, 179.99450683594, 180.75256347656);
    CreateDynamicObject(18449, -218.71710205078, 5424.7739257813, 31.088684082031, 60.166625976563, 179.99450683594, 180.75256347656);
    CreateDynamicObject(18449, -256.51818847656, 5420.0708007813, 25.084003448486, 0, 90.065612792969, 0.758056640625);
    CreateDynamicObject(1225, -62.948406219482, 5422.185546875, 25.929628372192, 0, 0, 0);
    CreateDynamicObject(1225, -63.005695343018, 5420.8828125, 25.929628372192, 0, 0, 0);
    CreateDynamicObject(1225, -62.941150665283, 5419.259765625, 25.929628372192, 0, 0, 0);
    CreateDynamicObject(1225, -62.93729019165, 5417.796875, 25.929628372192, 0, 0, 0);
    CreateDynamicObject(1225, -118.05484008789, 5421.7875976563, 25.854084014893, 0, 0, 0);
    CreateDynamicObject(1225, -118.09094238281, 5420.4072265625, 25.854084014893, 0, 0, 0);
    CreateDynamicObject(1225, -118.13311767578, 5418.7973632813, 25.854084014893, 0, 0, 0);
    CreateDynamicObject(1225, -118.17712402344, 5417.1103515625, 25.854084014893, 0, 0, 0);
    CreateDynamicObject(1225, -172.52734375, 5421.5913085938, 25.854084014893, 0, 0, 0);
    CreateDynamicObject(1225, -172.89428710938, 5423.1889648438, 25.854084014893, 0, 0, 0);
    CreateDynamicObject(1225, -172.96240234375, 5425.0283203125, 25.854084014893, 0, 0, 0);
    CreateDynamicObject(1225, -173.02789306641, 5426.7915039063, 25.854084014893, 0, 0, 0);
    CreateDynamicObject(1225, -249.36814880371, 5420.3330078125, 25.833507537842, 0, 0, 0);
    CreateDynamicObject(1225, -249.41351318359, 5418.5698242188, 25.833507537842, 0, 0, 0);
    CreateDynamicObject(1225, -249.46343994141, 5416.6528320313, 25.833507537842, 0, 0, 0);
    CreateDynamicObject(1225, -249.50518798828, 5415.0424804688, 25.833507537842, 0, 0, 0);
    CreateDynamicObject(1225, -249.31756591797, 5422.1713867188, 25.833507537842, 0, 0, 0);
    CreateDynamicObject(1225, -249.27307128906, 5423.857421875, 25.833507537842, 0, 0, 0);
    CreateDynamicObject(1225, -249.23419189453, 5425.3139648438, 25.833507537842, 0, 0, 0);
    CreateDynamicObject(1225, -251.61933898926, 5425.0673828125, 25.833507537842, 0, 0, 0);
    CreateDynamicObject(1225, -252.95133972168, 5424.02734375, 25.833507537842, 0, 0, 0);
    CreateDynamicObject(1225, -252.98541259766, 5422.7241210938, 25.833507537842, 0, 0, 0);
    CreateDynamicObject(1225, -253.03369140625, 5420.8837890625, 25.833507537842, 0, 0, 0);
    CreateDynamicObject(1225, -253.08154296875, 5419.0439453125, 25.833507537842, 0, 0, 0);
    CreateDynamicObject(1225, -253.14147949219, 5416.744140625, 25.833507537842, 0, 0, 0);
    CreateDynamicObject(1225, -253.19097900391, 5414.8276367188, 25.833507537842, 0, 0, 0);
    CreateDynamicObject(1225, -251.1477355957, 5416.6162109375, 25.833507537842, 0, 0, 0);
    CreateDynamicObject(1225, -250.98834228516, 5422.6723632813, 25.833507537842, 0, 0, 0);
    CreateDynamicObject(974, 1382.1694335938, 5451.8217773438, 23.997734069824, 0, 0, 90.823699951172);
    CreateDynamicObject(974, 1382.1184082031, 5458.4555664063, 23.997734069824, 0, 0, 90.055206298828);
    CreateDynamicObject(974, 1382.0146484375, 5465.072265625, 23.997734069824, 0, 0, 91.581451416016);
    CreateDynamicObject(974, 1381.8348388672, 5471.6811523438, 23.997734069824, 0, 0, 91.576538085938);
    CreateDynamicObject(974, 1381.6624755859, 5478.2133789063, 23.997734069824, 0, 0, 91.576538085938);
    CreateDynamicObject(974, 1381.4989013672, 5484.6694335938, 23.997734069824, 0, 0, 91.576538085938);
    CreateDynamicObject(974, 1381.3814697266, 5489.2807617188, 23.997734069824, 0, 0, 91.576538085938);
    CreateDynamicObject(974, 1384.5871582031, 5492.6909179688, 23.920999526978, 0, 0, 1.5102233886719);
    CreateDynamicObject(974, 1400.0551757813, 5496.5283203125, 23.997734069824, 0, 0, 91.570617675781);
    CreateDynamicObject(974, 1399.8837890625, 5503.2099609375, 23.997734069824, 0, 0, 91.565551757813);
    CreateDynamicObject(974, 1399.712890625, 5509.8916015625, 23.997734069824, 0, 0, 91.565551757813);
    CreateDynamicObject(974, 1402.9442138672, 5513.265625, 23.997734069824, 0, 0, 1.5000610351563);
    CreateDynamicObject(974, 1409.5177001953, 5513.4497070313, 23.997734069824, 0, 0, 1.4996337890625);
    CreateDynamicObject(974, 1416.1033935547, 5513.5981445313, 23.997734069824, 0, 0, 1.4996337890625);
    CreateDynamicObject(974, 1422.7886962891, 5513.705078125, 23.997734069824, 0, 0, 1.4996337890625);
    CreateDynamicObject(974, 1429.3934326172, 5513.9096679688, 23.997734069824, 0, 0, 1.4996337890625);
    CreateDynamicObject(974, 1435.9979248047, 5514.1137695313, 23.997734069824, 0, 0, 1.4996337890625);
    CreateDynamicObject(974, 1439.7474365234, 5510.8227539063, 23.997734069824, 0, 0, 277.54052734375);
    CreateDynamicObject(974, 1440.2562255859, 5504.2333984375, 23.997734069824, 0, 0, 271.43029785156);
    CreateDynamicObject(974, 1440.4212646484, 5497.705078125, 23.997734069824, 0, 0, 272.19152832031);
    CreateDynamicObject(974, 1443.8548583984, 5494.4848632813, 23.537326812744, 0, 0, 182.12121582031);
    CreateDynamicObject(974, 1450.4744873047, 5494.78125, 23.460592269897, 0, 0, 182.12036132813);
    CreateDynamicObject(974, 1457.1270751953, 5494.9448242188, 23.383857727051, 0, 0, 181.35711669922);
    CreateDynamicObject(14416, 1390.0651855469, 5495.4130859375, 21.016868591309, 0, 0, 2.2898254394531);
    CreateDynamicObject(14416, 1394.0556640625, 5495.5908203125, 21.016868591309, 0, 0, 2.28515625);
    CreateDynamicObject(14416, 1398.0458984375, 5495.7685546875, 21.016868591309, 0, 0, 2.28515625);
    CreateDynamicObject(14416, 1393.7709960938, 5502.2163085938, 24.853595733643, 0, 0, 2.28515625);
    CreateDynamicObject(14416, 1397.7568359375, 5502.35546875, 24.853595733643, 0, 0, 2.28515625);
    CreateDynamicObject(14416, 1389.8548583984, 5502.0703125, 24.853595733643, 0, 0, 2.28515625);
    CreateDynamicObject(974, 1399.8837890625, 5503.2099609375, 29.522621154785, 0, 0, 91.565551757813);
    CreateDynamicObject(974, 1399.712890625, 5509.8916015625, 29.522621154785, 0, 0, 91.565551757813);
    CreateDynamicObject(6959, 1378.2088623047, 5523.650390625, 28.046287536621, 0, 0, 2.2898254394531);
    CreateDynamicObject(6959, 1337.3752441406, 5522.0708007813, 28.046287536621, 0, 0, 2.28515625);
    CreateDynamicObject(6959, 1335.7763671875, 5561.93359375, 28.046287536621, 0, 0, 2.28515625);
    CreateDynamicObject(6959, 1376.5944824219, 5563.5029296875, 28.046287536621, 0, 0, 2.28515625);
    CreateDynamicObject(974, 1399.0872802734, 5516.4545898438, 30.443435668945, 0, 0, 99.961578369141);
    CreateDynamicObject(974, 1398.5648193359, 5523.0654296875, 30.443435668945, 0, 0, 89.273345947266);
    CreateDynamicObject(974, 1398.48828125, 5529.6962890625, 30.443435668945, 0, 0, 92.322509765625);
    CreateDynamicObject(974, 1398.2590332031, 5536.314453125, 30.443435668945, 0, 0, 92.318115234375);
    CreateDynamicObject(974, 1398.0295410156, 5542.9326171875, 30.443435668945, 0, 0, 92.318115234375);
    CreateDynamicObject(974, 1397.8062744141, 5549.4741210938, 30.443435668945, 0, 0, 92.318115234375);
    CreateDynamicObject(974, 1397.4998779297, 5556.0854492188, 30.443435668945, 0, 0, 93.081359863281);
    CreateDynamicObject(974, 1397.1932373047, 5562.6967773438, 30.443435668945, 0, 0, 93.076171875);
    CreateDynamicObject(974, 1396.8803710938, 5569.384765625, 30.443435668945, 0, 0, 92.312896728516);
    CreateDynamicObject(974, 1396.5740966797, 5575.9965820313, 30.443435668945, 0, 0, 92.312622070313);
    CreateDynamicObject(974, 1396.4044189453, 5580.9213867188, 30.443435668945, 0, 0, 92.312622070313);
    CreateDynamicObject(974, 1392.9830322266, 5583.8813476563, 30.792778015137, 0, 0, 2.2898254394531);
    CreateDynamicObject(974, 1386.4122314453, 5583.6333007813, 30.792778015137, 0, 0, 2.28515625);
    CreateDynamicObject(974, 1379.8419189453, 5583.3852539063, 30.792778015137, 0, 0, 2.28515625);
    CreateDynamicObject(974, 1373.3461914063, 5583.1552734375, 30.792778015137, 0, 0, 2.28515625);
    CreateDynamicObject(974, 1366.7755126953, 5582.9077148438, 30.792778015137, 0, 0, 2.28515625);
    CreateDynamicObject(974, 1360.1025390625, 5582.6865234375, 30.792778015137, 0, 0, 2.28515625);
    CreateDynamicObject(974, 1353.4296875, 5582.4658203125, 30.792778015137, 0, 0, 2.28515625);
    CreateDynamicObject(974, 1346.7568359375, 5582.2451171875, 30.792778015137, 0, 0, 2.28515625);
    CreateDynamicObject(974, 1340.1640625, 5581.951171875, 30.792778015137, 0, 0, 2.28515625);
    CreateDynamicObject(974, 1333.4967041016, 5581.650390625, 30.792778015137, 0, 0, 2.28515625);
    CreateDynamicObject(974, 1326.8308105469, 5581.3271484375, 30.792778015137, 0, 0, 2.28515625);
    CreateDynamicObject(974, 1320.2393798828, 5581.0825195313, 30.792778015137, 0, 0, 2.28515625);
    CreateDynamicObject(974, 1317.7094726563, 5581.017578125, 30.792778015137, 0, 0, 2.28515625);
    CreateDynamicObject(974, 1314.5422363281, 5577.5576171875, 30.792778015137, 0, 0, 92.312896728516);
    CreateDynamicObject(974, 1314.8138427734, 5571.00390625, 30.792778015137, 0, 0, 92.312622070313);
    CreateDynamicObject(974, 1315.1079101563, 5564.44140625, 30.792778015137, 0, 0, 92.312622070313);
    CreateDynamicObject(974, 1315.39453125, 5557.802734375, 30.792778015137, 0, 0, 92.312622070313);
    CreateDynamicObject(974, 1315.681640625, 5551.1640625, 30.792778015137, 0, 0, 92.312622070313);
    CreateDynamicObject(974, 1315.8996582031, 5544.6088867188, 30.792778015137, 0, 0, 92.312622070313);
    CreateDynamicObject(974, 1316.2036132813, 5538.044921875, 30.792778015137, 0, 0, 93.075866699219);
    CreateDynamicObject(974, 1316.5549316406, 5531.3999023438, 30.792778015137, 0, 0, 93.070678710938);
    CreateDynamicObject(974, 1316.9267578125, 5524.7543945313, 30.792778015137, 0, 0, 93.070678710938);
    CreateDynamicObject(974, 1317.3041992188, 5518.1616210938, 30.792778015137, 0, 0, 93.070678710938);
    CreateDynamicObject(974, 1317.6047363281, 5511.5751953125, 30.792778015137, 0, 0, 93.070678710938);
    CreateDynamicObject(974, 1317.9832763672, 5504.912109375, 30.792778015137, 0, 0, 93.070678710938);
    CreateDynamicObject(974, 1321.4400634766, 5501.7568359375, 30.792778015137, 0, 0, 2.28515625);
    CreateDynamicObject(974, 1328.1068115234, 5502.0249023438, 30.792778015137, 0, 0, 2.28515625);
    CreateDynamicObject(974, 1334.7738037109, 5502.2924804688, 30.792778015137, 0, 0, 2.28515625);
    CreateDynamicObject(974, 1341.4134521484, 5502.5463867188, 30.792778015137, 0, 0, 2.28515625);
    CreateDynamicObject(974, 1348.0275878906, 5502.8041992188, 30.792778015137, 0, 0, 2.28515625);
    CreateDynamicObject(974, 1354.6418457031, 5503.0620117188, 30.792778015137, 0, 0, 2.28515625);
    CreateDynamicObject(974, 1361.2478027344, 5503.3393554688, 30.792778015137, 0, 0, 2.28515625);
    CreateDynamicObject(974, 1367.8880615234, 5503.587890625, 30.792778015137, 0, 0, 2.28515625);
    CreateDynamicObject(974, 1374.5697021484, 5503.7900390625, 30.792778015137, 0, 0, 2.28515625);
    CreateDynamicObject(974, 1381.2554931641, 5503.9697265625, 30.792778015137, 0, 0, 2.28515625);
    CreateDynamicObject(974, 1384.5551757813, 5504.109375, 30.792778015137, 0, 0, 2.28515625);
    CreateDynamicObject(974, 1387.9178466797, 5495.9951171875, 23.997734069824, 0, 0, 91.565551757813);
    CreateDynamicObject(974, 1387.7947998047, 5502.580078125, 23.997734069824, 0, 0, 91.565551757813);
    CreateDynamicObject(974, 1387.6951904297, 5501.0112304688, 29.369152069092, 0, 0, 91.565551757813);
    CreateDynamicObject(974, 1387.8565673828, 5496.0561523438, 29.369152069092, 0, 0, 91.565551757813);
    CreateDynamicObject(14781, 1414.6427001953, 5497.0024414063, 22.107217788696, 0, 0, 1.5265502929688);
    CreateDynamicObject(14781, 1425.1892089844, 5496.9516601563, 22.107217788696, 0, 0, 1.5216064453125);
    CreateDynamicObject(974, 2716.4267578125, -1144.810546875, 71.191802978516, 0, 0, 0);
    CreateDynamicObject(974, 2723.0539550781, -1144.8151855469, 71.191802978516, 0, 0, 0);
    CreateDynamicObject(974, 2744.1420898438, -1144.8360595703, 71.191802978516, 0, 0, 0);
    CreateDynamicObject(974, 2737.5400390625, -1144.8369140625, 71.191802978516, 0, 0, 0);
    CreateDynamicObject(3578, 2722.7639160156, -1162.2083740234, 69.192092895508, 0, 0, 0);
    CreateDynamicObject(3578, 2722.5478515625, -1152.81640625, 69.192092895508, 0, 0, 0.758056640625);
    CreateDynamicObject(3268, 2742.7421875, -1103.6396484375, 68.4140625, 0, 0, 0);
    CreateDynamicObject(3279, 2724.08203125, -1156.4521484375, 68.231201171875, 0, 0, 0);
    CreateDynamicObject(1358, 2724.583984375, -1146.6690673828, 69.617607116699, 0, 0, 0);
    CreateDynamicObject(3092, 2740.4865722656, -1101.5959472656, 69.608573913574, 89.30224609375, 0, 90.828735351563);
    CreateDynamicObject(2899, 2735.21875, -1162.328125, 68.476058959961, 0, 0, 90.060424804688);
    CreateDynamicObject(2899, 2740.1435546875, -1162.3374023438, 68.476058959961, 0, 0, 90.060424804688);
    CreateDynamicObject(2899, 2740.3159179688, -1157.5637207031, 68.476058959961, 0, 0, 90.060424804688);
    CreateDynamicObject(2899, 2735.390625, -1157.5541992188, 68.476058959961, 0, 0, 90.060424804688);
    CreateDynamicObject(2985, 2724.8076171875, -1158.548828125, 84.309326171875, 0, 0, 306.56799316406);
    CreateDynamicObject(2985, 2723.5, -1158.5487060547, 84.309326171875, 0, 0, 272.22094726563);
    CreateDynamicObject(3066, 2739.3000488281, -1124.7055664063, 69.314865112305, 0, 0, 0);
    CreateDynamicObject(2060, 2734.7749023438, -1147.8062744141, 68.57071685791, 0, 0, 0);
    CreateDynamicObject(2060, 2735.2321777344, -1147.8955078125, 68.800926208496, 0, 0, 0);
    CreateDynamicObject(2060, 2735.8181152344, -1147.7882080078, 68.57071685791, 0, 0, 0);
    CreateDynamicObject(2060, 2736.8598632813, -1147.810546875, 68.57071685791, 0, 0, 0);
    CreateDynamicObject(2060, 2736.24609375, -1147.83203125, 68.800926208496, 0, 0, 0);
    CreateDynamicObject(2060, 2737.8608398438, -1147.8389892578, 68.57071685791, 0, 0, 0);
    CreateDynamicObject(2060, 2737.3449707031, -1147.8634033203, 68.800926208496, 0, 0, 0);
    CreateDynamicObject(2060, 2736.7600097656, -1147.8626708984, 68.954399108887, 0, 0, 0);
    CreateDynamicObject(2060, 2735.673828125, -1147.87109375, 68.954399108887, 0, 0, 0);
    CreateDynamicObject(2060, 2738.9553222656, -1147.9246826172, 68.57071685791, 0, 0, 0);
    CreateDynamicObject(2060, 2738.4184570313, -1147.9289550781, 68.800926208496, 0, 0, 0);
    CreateDynamicObject(2060, 2737.7272949219, -1147.8585205078, 68.954399108887, 0, 0, 0);
    CreateDynamicObject(2060, 2739.4125976563, -1147.1208496094, 68.57071685791, 0, 0, 87.012420654297);
    CreateDynamicObject(2060, 2739.5280761719, -1146.0279541016, 68.57071685791, 0, 0, 87.01171875);
    CreateDynamicObject(2060, 2739.5717773438, -1145.2023925781, 68.57071685791, 0, 0, 0.7625732421875);
    CreateDynamicObject(2060, 2739.2888183594, -1147.5537109375, 68.800926208496, 0, 0, 80.906280517578);
    CreateDynamicObject(2060, 2739.4289550781, -1146.5205078125, 68.800926208496, 0, 0, 80.9033203125);
    CreateDynamicObject(2060, 2738.7353515625, -1147.8494873047, 68.954399108887, 0, 0, 0);
    CreateDynamicObject(2060, 2739.4309082031, -1146.8804931641, 68.954399108887, 0, 0, 80.906280517578);
    CreateDynamicObject(2060, 2739.6333007813, -1145.7282714844, 68.800926208496, 0, 0, 80.9033203125);
    CreateDynamicObject(3386, 2752.0959472656, -1103.0859375, 68.578125, 0, 0, 0);
    CreateDynamicObject(3386, 2752.0703125, -1100.8591308594, 68.578125, 0, 0, 0);
    CreateDynamicObject(3387, 2752.1127929688, -1105.2075195313, 68.578125, 0, 0, 0);
    CreateDynamicObject(3390, 2752.1196289063, -1108.1567382813, 68.578125, 0, 0, 0);
    CreateDynamicObject(3390, 2752.1999511719, -1111.7687988281, 68.578125, 0, 0, 0);
    CreateDynamicObject(3392, 2736.6069335938, -1089.2873535156, 68.337326049805, 0, 0, 90.065490722656);
    CreateDynamicObject(3392, 2740.0629882813, -1089.2875976563, 68.337326049805, 0, 0, 90.060424804688);
    CreateDynamicObject(3394, 2751.9592285156, -1098.5416259766, 68.578125, 0, 0, 0);
    CreateDynamicObject(3394, 2751.9106445313, -1095.060546875, 68.578125, 0, 0, 0);
    CreateDynamicObject(16782, 2733.0446777344, -1091.5850830078, 71.372146606445, 0, 0, 0);
    CreateDynamicObject(14455, 2737.8620605469, -1118.3413085938, 70.085823059082, 0, 0, 0);
    CreateDynamicObject(3383, 2740.7766113281, -1106.1545410156, 68.4140625, 0, 0, 0);
    CreateDynamicObject(3383, 2740.6225585938, -1101.6154785156, 68.4140625, 0, 0, 0);
    CreateDynamicObject(3092, 2740.6357421875, -1106.1271972656, 69.608573913574, 89.296875, 0, 90.823974609375);
    CreateDynamicObject(3675, 2733.4152832031, -1120.0882568359, 70.948020935059, 0, 0, 0);
    CreateDynamicObject(934, 2739.2145996094, -1112.0404052734, 69.742340087891, 0, 0, 0);
    CreateDynamicObject(934, 2736.2819824219, -1112.1573486328, 69.742340087891, 0, 0, 0);
    CreateDynamicObject(920, 2740.3059082031, -1104.0819091797, 68.898872375488, 0, 0, 0);
    CreateDynamicObject(3934, 2711.7583007813, -1065.7099609375, 74.365135192871, 0, 0, 0);
    CreateDynamicObject(974, 2712.7312011719, -1130.5124511719, 71.191802978516, 0, 0, 90.065490722656);
    CreateDynamicObject(974, 2683.9399414063, -1096.2280273438, 71.082260131836, 0, 0, 0);
    CreateDynamicObject(8947, 2711.7275390625, -1065.7473144531, 71.311592102051, 0, 0, 269.93450927734);
    CreateDynamicObject(2205, 2703.1293945313, -1060.7476806641, 68.366790771484, 0, 0, 0);
    CreateDynamicObject(2205, 2707.2062988281, -1060.7287597656, 68.366790771484, 0, 0, 0);
    CreateDynamicObject(2205, 2711.2099609375, -1060.7321777344, 68.366790771484, 0, 0, 0);
    CreateDynamicObject(2205, 2714.6613769531, -1060.7312011719, 68.366790771484, 0, 0, 0);
    CreateDynamicObject(2205, 2718.6491699219, -1060.7182617188, 68.366790771484, 0, 0, 0);
    CreateDynamicObject(1252, 2703.1477050781, -1061.029296875, 69.553070068359, 0, 0, 0);
    CreateDynamicObject(1252, 2704.2221679688, -1061.0534667969, 69.553070068359, 0, 0, 0);
    CreateDynamicObject(1252, 2703.7060546875, -1060.9997558594, 69.553070068359, 0, 0, 0);
    CreateDynamicObject(1252, 2704.6081542969, -1061.021484375, 69.553070068359, 0, 0, 0);
    CreateDynamicObject(1636, 2706.9028320313, -1060.8767089844, 69.436042785645, 0, 0, 0);
    CreateDynamicObject(1636, 2707.4567871094, -1060.8060302734, 69.436042785645, 0, 0, 0);
    CreateDynamicObject(1636, 2708.0004882813, -1060.9069824219, 69.436042785645, 0, 0, 0);
    CreateDynamicObject(1636, 2708.5141601563, -1060.9370117188, 69.436042785645, 0, 0, 0);
    CreateDynamicObject(1654, 2710.9133300781, -1060.9426269531, 69.620361328125, 0, 0, 0);
    CreateDynamicObject(1654, 2711.3237304688, -1060.9851074219, 69.620361328125, 0, 0, 0);
    CreateDynamicObject(1654, 2711.8076171875, -1061.0061035156, 69.620361328125, 0, 0, 0);
    CreateDynamicObject(1654, 2712.2919921875, -1061.0275878906, 69.620361328125, 0, 0, 0);
    CreateDynamicObject(1654, 2712.7763671875, -1061.0490722656, 69.620361328125, 0, 0, 0);
    CreateDynamicObject(2035, 2714.8161621094, -1060.4361572266, 69.327690124512, 0, 0, 0);
    CreateDynamicObject(2035, 2714.7883300781, -1060.9772949219, 69.327690124512, 0, 0, 0);
    CreateDynamicObject(2035, 2715.83984375, -1060.3977050781, 69.327690124512, 0, 0, 0);
    CreateDynamicObject(2035, 2715.8127441406, -1060.9392089844, 69.327690124512, 0, 0, 0);
    CreateDynamicObject(2036, 2719.3706054688, -1060.5362548828, 69.337181091309, 0, 0, 0);
    CreateDynamicObject(2036, 2719.375, -1060.9200439453, 69.337181091309, 0, 0, 0);
    CreateDynamicObject(2037, 2716.3586425781, -1060.6688232422, 69.375610351563, 0, 0, 0);
    CreateDynamicObject(2037, 2716.3767089844, -1061.0512695313, 69.375610351563, 0, 0, 0);
    CreateDynamicObject(2037, 2714.9741210938, -1060.6567382813, 69.375610351563, 0, 0, 0);
    CreateDynamicObject(2037, 2714.9956054688, -1061.1162109375, 69.375610351563, 0, 0, 0);
    CreateDynamicObject(1686, 2740.662109375, -1071.1774902344, 68.48681640625, 0, 0, 318.02035522461);
    CreateDynamicObject(1686, 2738.4401855469, -1073.6135253906, 68.48681640625, 0, 0, 318.01574707031);
    CreateDynamicObject(1686, 2736.2551269531, -1075.9809570313, 68.48681640625, 0, 0, 318.01574707031);
    CreateDynamicObject(1997, 2740.4074707031, -1096.9261474609, 68.4140625, 0, 0, 0);
    CreateDynamicObject(2983, 2733.3828125, -1121.3212890625, 70.218955993652, 0, 0, 0);
    CreateDynamicObject(18092, 2703.951171875, -1070.7321777344, 68.594879150391, 0, 0, 0);
    CreateDynamicObject(18092, 2710.12890625, -1070.6015625, 68.594879150391, 0, 0, 0);
    CreateDynamicObject(2044, 2717.7673339844, -1070.4353027344, 69.122932434082, 0, 0, 0);
    CreateDynamicObject(2044, 2717.9033203125, -1070.9541015625, 69.122932434082, 0, 0, 0);
    CreateDynamicObject(2044, 2717.1494140625, -1070.2001953125, 69.122932434082, 0, 0, 0);
    CreateDynamicObject(2044, 2717.0791015625, -1070.5361328125, 69.122932434082, 0, 0, 0);
    CreateDynamicObject(2044, 2716.5166015625, -1070.2080078125, 69.122932434082, 0, 0, 0);
    CreateDynamicObject(2044, 2718.0244140625, -1070.2080078125, 69.122932434082, 0, 0, 0);
    CreateDynamicObject(2044, 2716.3916015625, -1070.6376953125, 69.122932434082, 0, 0, 0);
    CreateDynamicObject(2057, 2715.7526855469, -1070.3258056641, 69.265853881836, 0, 0, 0);
    CreateDynamicObject(2057, 2714.8291015625, -1070.2944335938, 69.265853881836, 0, 0, 0);
    CreateDynamicObject(2057, 2713.9033203125, -1070.9576416016, 69.265853881836, 0, 0, 0);
    CreateDynamicObject(2057, 2713.9736328125, -1070.34765625, 69.265853881836, 0, 0, 0);
    CreateDynamicObject(2061, 2711.8232421875, -1070.2287597656, 69.387329101563, 0, 0, 0);
    CreateDynamicObject(2061, 2712.283203125, -1070.2248535156, 69.387329101563, 0, 0, 0);
    CreateDynamicObject(2061, 2712.28515625, -1070.5317382813, 69.387329101563, 0, 0, 0);
    CreateDynamicObject(2061, 2712.287109375, -1070.8383789063, 69.387329101563, 0, 0, 0);
    CreateDynamicObject(2061, 2711.9038085938, -1070.8409423828, 69.387329101563, 0, 0, 0);
    CreateDynamicObject(2061, 2711.9008789063, -1070.4569091797, 69.387329101563, 0, 0, 0);
    CreateDynamicObject(2690, 2711.0979003906, -1070.3243408203, 69.454811096191, 0, 0, 0);
    CreateDynamicObject(2690, 2710.4643554688, -1070.3068847656, 69.454811096191, 0, 0, 0);
    CreateDynamicObject(2690, 2709.7358398438, -1070.3425292969, 69.454811096191, 0, 0, 0);
    CreateDynamicObject(1672, 2708.9655761719, -1070.0874023438, 69.301116943359, 0, 0, 0);
    CreateDynamicObject(1672, 2709.3071289063, -1070.2603759766, 69.301116943359, 0, 0, 0);
    CreateDynamicObject(1672, 2708.8525390625, -1070.3395996094, 69.301116943359, 0, 0, 0);
    CreateDynamicObject(1672, 2708.7866210938, -1069.9610595703, 69.301116943359, 0, 0, 0);
    CreateDynamicObject(1672, 2709.2666015625, -1070.0322265625, 69.301116943359, 0, 0, 0);
    CreateDynamicObject(1672, 2709.0791015625, -1070.298828125, 69.301116943359, 0, 0, 0);
    CreateDynamicObject(2035, 2706.2536621094, -1070.5745849609, 69.119834899902, 0, 0, 269.93450927734);
    CreateDynamicObject(2035, 2705.7163085938, -1070.6058349609, 69.119834899902, 0, 0, 269.93408203125);
    CreateDynamicObject(2035, 2704.876953125, -1070.7318115234, 69.119834899902, 0, 0, 180.63236999512);
    CreateDynamicObject(2035, 2704.9272460938, -1070.2669677734, 69.119834899902, 0, 0, 180.63171386719);
    CreateDynamicObject(2035, 2703.798828125, -1070.7176513672, 69.119834899902, 0, 0, 180.63171386719);
    CreateDynamicObject(2035, 2703.7768554688, -1070.3334960938, 69.119834899902, 0, 0, 180.63171386719);
    CreateDynamicObject(2035, 2702.6987304688, -1070.3195800781, 69.119834899902, 0, 0, 180.63171386719);
    CreateDynamicObject(2035, 2702.7202148438, -1070.7026367188, 69.119834899902, 0, 0, 180.63171386719);
    CreateDynamicObject(2034, 2701.8793945313, -1070.7728271484, 69.12621307373, 0, 0, 0);
    CreateDynamicObject(2034, 2701.8732910156, -1070.3809814453, 69.12621307373, 0, 0, 0);
    CreateDynamicObject(2034, 2701.8842773438, -1071.1638183594, 69.12621307373, 0, 0, 0);
    CreateDynamicObject(2036, 2708.3986816406, -1070.5201416016, 69.129325866699, 0, 0, 270.69775390625);
    CreateDynamicObject(2036, 2707.9350585938, -1070.5239257813, 69.129325866699, 0, 0, 270.69763183594);
    CreateDynamicObject(10244, 2706.583984375, -1075.1105957031, 70.74715423584, 0, 0, 0);
    CreateDynamicObject(974, 2680.2856445313, -1057.9844970703, 72.419136047363, 0, 0, 0);
    CreateDynamicObject(974, 2686.8149414063, -1058.0002441406, 72.419136047363, 0, 0, 0);
    CreateDynamicObject(974, 2693.3664550781, -1057.9879150391, 72.419136047363, 0, 0, 0.76327514648438);
    CreateDynamicObject(974, 2699.984375, -1057.9467773438, 72.419136047363, 0, 0, 0);
    CreateDynamicObject(974, 2706.533203125, -1057.98828125, 72.419136047363, 0, 0, 359.23672485352);
    CreateDynamicObject(974, 2713.1193847656, -1058.0142822266, 72.419136047363, 0, 0, 0);
    CreateDynamicObject(974, 2719.7370605469, -1057.9953613281, 72.419136047363, 0, 0, 0);
    CreateDynamicObject(974, 2726.3024902344, -1057.9620361328, 72.419136047363, 0, 0, 0);
    CreateDynamicObject(974, 2673.6767578125, -1057.9655761719, 72.419136047363, 0, 0, 0);
    CreateDynamicObject(974, 2666.9916992188, -1057.9422607422, 72.419136047363, 0, 0, 0);
    CreateDynamicObject(974, 2732.3979492188, -1059.7707519531, 72.419136047363, 0, 0, 327.94284057617);
    CreateDynamicObject(974, 2738.0314941406, -1063.2469482422, 72.419136047363, 0, 0, 327.94189453125);
    CreateDynamicObject(974, 2743.0603027344, -1067.400390625, 72.419136047363, 0, 0, 313.43933105469);
    CreateDynamicObject(974, 2747.3605957031, -1072.3370361328, 72.419136047363, 0, 0, 308.09130859375);
    CreateDynamicObject(974, 2749.4289550781, -1074.8953857422, 72.419136047363, 0, 0, 308.08959960938);
    CreateDynamicObject(974, 2752.5078125, -1080.6396484375, 72.419136047363, 0, 0, 288.24389648438);
    CreateDynamicObject(974, 2754.3432617188, -1087.0014648438, 72.419136047363, 0, 0, 283.66296386719);
    CreateDynamicObject(974, 2755.3803710938, -1093.4793701172, 72.419136047363, 0, 0, 274.501953125);
    CreateDynamicObject(974, 2755.6140136719, -1100.0821533203, 72.419136047363, 0, 0, 269.91906738281);
    CreateDynamicObject(974, 2755.6008300781, -1106.7392578125, 72.419136047363, 0, 0, 269.91760253906);
    CreateDynamicObject(974, 2755.623046875, -1113.2630615234, 72.419136047363, 0, 0, 269.91760253906);
    CreateDynamicObject(974, 2755.5529785156, -1116.5783691406, 72.419136047363, 0, 0, 269.91760253906);
    CreateDynamicObject(974, 2753.986328125, -1122.8083496094, 72.419136047363, 0, 0, 240.91320800781);
    CreateDynamicObject(974, 2750.6647949219, -1128.5339355469, 72.419136047363, 0, 0, 240.908203125);
    CreateDynamicObject(974, 2748.7326660156, -1132.0151367188, 72.419136047363, 0, 0, 240.908203125);
    CreateDynamicObject(974, 2663.833984375, -1061.21875, 70.924324035645, 0, 0, 90.054931640625);
    CreateDynamicObject(974, 2663.814453125, -1067.80859375, 70.924324035645, 0, 0, 90.054931640625);
    CreateDynamicObject(974, 2663.7666015625, -1093.0703125, 71.00106048584, 0, 0, 90.054931640625);
    CreateDynamicObject(974, 2663.7353515625, -1086.3876953125, 71.00106048584, 0, 0, 90.054931640625);
    CreateDynamicObject(974, 2663.8349609375, -1071.111328125, 70.924324035645, 0, 0, 90.054931640625);
    CreateDynamicObject(3578, 2658.1286621094, -1073.5235595703, 69.091033935547, 0, 0.76327514648438, 0.758056640625);
    CreateDynamicObject(3578, 2658.2255859375, -1084.634765625, 69.091033935547, 0, 0.758056640625, 0.758056640625);
    CreateDynamicObject(3279, 2668.3356933594, -1067.4730224609, 68.063926696777, 0, 0, 0);
    CreateDynamicObject(3877, 2699.8481445313, -1072.7073974609, 76.030876159668, 0, 0, 0);
    CreateDynamicObject(3877, 2699.8701171875, -1058.7604980469, 76.030876159668, 0, 0, 0);
    CreateDynamicObject(3877, 2723.6013183594, -1058.7913818359, 76.030876159668, 0, 0, 0);
    CreateDynamicObject(3877, 2723.5844726563, -1072.7622070313, 76.030876159668, 0, 0, 0);
    CreateDynamicObject(1558, 2685.0834960938, -1063.2908935547, 68.870826721191, 0, 0, 0);
    CreateDynamicObject(1558, 2683.9841308594, -1063.3002929688, 68.870826721191, 0, 0, 0);
    CreateDynamicObject(1558, 2682.8845214844, -1063.3100585938, 68.870826721191, 0, 0, 0);
    CreateDynamicObject(1558, 2681.7849121094, -1063.3198242188, 68.870826721191, 0, 0, 0);
    CreateDynamicObject(1558, 2681.7448730469, -1061.9794921875, 68.870826721191, 0, 0, 0);
    CreateDynamicObject(1558, 2682.8430175781, -1061.9692382813, 68.870826721191, 0, 0, 0);
    CreateDynamicObject(1558, 2683.9416503906, -1061.9584960938, 68.870826721191, 0, 0, 0);
    CreateDynamicObject(1558, 2685.1127929688, -1061.9934082031, 68.870826721191, 0, 0, 0);
    CreateDynamicObject(952, 2678.3723144531, -1063.2131347656, 69.638381958008, 0, 0, 0);
    CreateDynamicObject(853, 2654.2810058594, -1087.9151611328, 68.836006164551, 0, 0, 0);
    CreateDynamicObject(853, 2658.6611328125, -1088.4389648438, 68.836006164551, 0, 0, 0);
    CreateDynamicObject(853, 2656.3718261719, -1088.0531005859, 68.836006164551, 0, 0, 0);
    CreateDynamicObject(852, 2654.6413574219, -1089.9245605469, 68.432647705078, 0, 0, 0);
    CreateDynamicObject(852, 2656.6115722656, -1089.7806396484, 68.432647705078, 0, 0, 45.795989990234);
    CreateDynamicObject(851, 2658.1997070313, -1090.0546875, 68.690101623535, 0, 0, 0);
    CreateDynamicObject(852, 2659.890625, -1089.3656005859, 68.432647705078, 0, 0, 45.791015625);
    CreateDynamicObject(2971, 2689.3825683594, -1089.3038330078, 68.125, 0, 0, 0);
    CreateDynamicObject(2971, 2691.8366699219, -1089.2756347656, 68.125, 0, 0, 0);
    CreateDynamicObject(2971, 2691.8640136719, -1091.7302246094, 68.125, 0, 0, 0);
    CreateDynamicObject(2971, 2689.3522949219, -1091.6647949219, 68.125, 0, 0, 0);
    CreateDynamicObject(1358, 2684.2924804688, -1089.3444824219, 69.328544616699, 0, 0, 0);
    CreateDynamicObject(1358, 2679.8330078125, -1089.1793212891, 69.328544616699, 0, 0, 0);
    CreateDynamicObject(12957, 2649.9765625, -1072.9931640625, 69.32901763916, 0, 0, 27.476806640625);
    CreateDynamicObject(3594, 2681.3359375, -1078.8154296875, 68.92805480957, 0, 0, 284.43603515625);
    CreateDynamicObject(3594, 2673.755859375, -1085.908203125, 68.92805480957, 0, 0, 224.90130615234);
    CreateDynamicObject(2985, 2666.7004394531, -1066.2001953125, 84.142051696777, 0, 0, 154.67858886719);
    CreateDynamicObject(2985, 2666.3190917969, -1068.2027587891, 84.142051696777, 0, 0, 215.7373046875);
    CreateDynamicObject(942, 2746.078125, -1090.0498046875, 71.021354675293, 0, 0, 0);
    CreateDynamicObject(964, 2743.9211425781, -1128.1298828125, 68.578125, 0, 0, 0);
    CreateDynamicObject(964, 2743.9645996094, -1126.482421875, 68.578125, 0, 0, 0);
    CreateDynamicObject(964, 2743.9387207031, -1124.8688964844, 68.578125, 0, 0, 0);
    CreateDynamicObject(1348, 2740.9196777344, -1130.6062011719, 69.116592407227, 0, 0, 0);
    CreateDynamicObject(2567, 2748.6826171875, -1122.1019287109, 70.505729675293, 0, 0, 0);
    CreateDynamicObject(2669, 2690.5432128906, -1062.1937255859, 69.713882446289, 1.5265197753906, 0, 0);
    CreateDynamicObject(3633, 2741.7290039063, -1121.4387207031, 68.888862609863, 0, 0, 0);
    CreateDynamicObject(18092, 2715.8916015625, -1070.4927978516, 68.594879150391, 0, 0, 0);
    CreateDynamicObject(3594, 2710.109375, -1083.8625488281, 68.885520935059, 0, 0, 284.43603515625);
    CreateDynamicObject(3594, 2738.572265625, -1173.7209472656, 68.871788024902, 0, 0, 284.43603515625);
    CreateDynamicObject(3594, 2735.2609863281, -1177.6678466797, 68.871788024902, 0, 0, 239.40325927734);
    CreateDynamicObject(3594, 2735.0302734375, -1185.8225097656, 68.718315124512, 0, 0, 179.86877441406);
    CreateDynamicObject(3594, 2722.818359375, -1134.2999267578, 69.04524230957, 0, 0, 284.43603515625);
    CreateDynamicObject(3594, 2723.7724609375, -1127.2897949219, 69.04524230957, 0, 0, 316.49325561523);
    CreateDynamicObject(3594, 2719.9052734375, -1122.025390625, 69.04524230957, 0, 0, 3.0478820800781);
    CreateDynamicObject(12957, 2639.9987792969, -1079.5676269531, 69.098808288574, 0, 0, 0.76251220703125);
    CreateDynamicObject(3594, 2689.041015625, -1070.0625, 68.697845458984, 0, 0, 211.16262817383);

//Map Playa/calles playa por prenafeta
    CreateDynamicObject(12957, 836.94805908203, -1602.6795654297, 13.425091743469, 0, 0, 165.05004882813);
    CreateDynamicObject(3594, 823.00885009766, -1609.0393066406, 13.178051948547, 0, 0, 117.24993896484);
    CreateDynamicObject(3593, 819.01104736328, -1594.6195068359, 13.092980384827, 0, 0, 0);
    CreateDynamicObject(13591, 827.52368164063, -1624.7052001953, 12.702886581421, 0, 0, 0);
    CreateDynamicObject(12957, 832.30841064453, -1630.3354492188, 13.425091743469, 0, 0, 278.94769287109);
    CreateDynamicObject(3092, 826.71252441406, -1610.1987304688, 18.761201858521, 0, 0, 0);
    CreateDynamicObject(3092, 803.33062744141, -1614.3198242188, 18.820547103882, 0, 90.449798583984, 0);
    CreateDynamicObject(3006, 831.04620361328, -1627.2509765625, 12.3828125, 0, 0, 0);
    CreateDynamicObject(2971, 813.62908935547, -1644.2708740234, 12.3828125, 0, 0, 0);
    CreateDynamicObject(2908, 825.18408203125, -1618.3117675781, 12.62429523468, 0, 0, 0);
    CreateDynamicObject(2907, 824.748046875, -1616.6614990234, 12.706911087036, 0, 0, 0);
    CreateDynamicObject(2906, 827.22882080078, -1615.3505859375, 12.620887756348, 0, 0, 0);
    CreateDynamicObject(2905, 823.14685058594, -1619.2573242188, 12.638323783875, 0, 0, 0);
    CreateDynamicObject(2670, 828.88928222656, -1618.5065917969, 12.482660293579, 0, 0, 0);
    CreateDynamicObject(2671, 831.30810546875, -1620.5881347656, 12.390607833862, 0, 0, 0);
    CreateDynamicObject(2672, 834.439453125, -1621.6549072266, 12.670069694519, 0, 0, 0);
    CreateDynamicObject(2673, 816.60339355469, -1620.7385253906, 12.722218513489, 0, 0, 0);
    CreateDynamicObject(2671, 821.25610351563, -1616.5384521484, 12.546875, 0, 0, 0);
    CreateDynamicObject(2671, 820.49963378906, -1635.1932373047, 12.390607833862, 0, 0, 0);
    CreateDynamicObject(2673, 815.07092285156, -1633.3988037109, 12.470640182495, 0, 0, 0);
    CreateDynamicObject(2675, 834.79650878906, -1609.2354736328, 12.447073936462, 0, 0, 0);
    CreateDynamicObject(2675, 845.97393798828, -1617.810546875, 12.611136436462, 0, 0, 0);
    CreateDynamicObject(854, 841.95178222656, -1614.0433349609, 12.589554786682, 0, 0, 0);
    CreateDynamicObject(849, 829.58367919922, -1615.0991210938, 12.690361976624, 0, 0, 0);
    CreateDynamicObject(852, 812.41485595703, -1635.0625, 12.3828125, 0, 0, 0);
    CreateDynamicObject(3593, 778.54376220703, -1576.5922851563, 13.257042884827, 0, 0, 50.25);
    CreateDynamicObject(3594, 792.24871826172, -1590.3214111328, 13.013989448547, 0, 0, 133.99606323242);
    CreateDynamicObject(853, 864.02355957031, -1586.28125, 12.783486366272, 0, 0, 0);
    CreateDynamicObject(851, 807.02954101563, -1595.2160644531, 12.703219413757, 0, 0, 0);
    CreateDynamicObject(2907, 828.75659179688, -1610.8729248047, 12.542848587036, 0, 0, 77.049987792969);
    CreateDynamicObject(2907, 812.66351318359, -1630.9930419922, 12.542848587036, 0, 0, 349.94714355469);
    CreateDynamicObject(2905, 831.02917480469, -1617.0682373047, 12.482056617737, 0, 0, 0);
    CreateDynamicObject(2908, 806.79504394531, -1618.1026611328, 18.608669281006, 0, 0, 0);
    CreateDynamicObject(2907, 809.19232177734, -1615.6285400391, 18.691286087036, 0, 0, 0);
    CreateDynamicObject(2905, 807.66510009766, -1619.6052246094, 18.6226978302, 0, 0, 0);
    CreateDynamicObject(2908, 800.57269287109, -1614.6522216797, 18.608669281006, 0, 0, 0);
    CreateDynamicObject(2905, 802.40270996094, -1621.2009277344, 18.6226978302, 0, 0, 53.599975585938);
    CreateDynamicObject(2907, 808.20959472656, -1625.0830078125, 26.071521759033, 0, 0, 56.949981689453);
    CreateDynamicObject(2905, 793.69055175781, -1606.2829589844, 18.6226978302, 0, 0, 53.596801757813);
    CreateDynamicObject(2907, 823.90594482422, -1596.9075927734, 12.542848587036, 0, 16.75, 133.99710083008);
    CreateDynamicObject(2905, 827.39215087891, -1596.5458984375, 12.638323783875, 0, 0, 0);
    CreateDynamicObject(1369, 816.71368408203, -1606.5509033203, 13.018749237061, 0, 269.55020141602, 0);
    CreateDynamicObject(3594, 1071.8294677734, -1859.1015625, 13.022859573364, 0, 0, 137.34606933594);
    CreateDynamicObject(3593, 1060.111328125, -1849.6395263672, 13.108605384827, 0, 0, 40.199981689453);
    CreateDynamicObject(3594, 1055.5501708984, -1831.9945068359, 13.154285430908, 0, 0, 137.34558105469);
    CreateDynamicObject(3594, 1041.6887207031, -1836.9583740234, 13.112099647522, 0, 356.64996337891, 53.595611572266);
    CreateDynamicObject(3593, 1046.0701904297, -1857.9617919922, 13.108605384827, 0, 0, 90.448944091797);
    CreateDynamicObject(12957, 812.04058837891, -1675.6163330078, 13.261029243469, 0, 0, 165.04760742188);
    CreateDynamicObject(12957, 923.60571289063, -1768.4703369141, 13.261029243469, 0, 0, 118.14755249023);
    CreateDynamicObject(12957, 947.28515625, -1792.5146484375, 13.825204849243, 0, 0, 118.14700317383);
    CreateDynamicObject(12957, 970.22216796875, -1780.2166748047, 13.978594779968, 0, 0, 24.347015380859);
    CreateDynamicObject(12957, 899.50921630859, -1786.1114501953, 13.313729286194, 0, 0, 57.847015380859);
    CreateDynamicObject(12957, 895.74572753906, -1770.4229736328, 13.261029243469, 0, 0, 118.14700317383);
    CreateDynamicObject(12957, 865.81726074219, -1785.4738769531, 13.519801139832, 0, 0, 181.79710388184);
    CreateDynamicObject(12957, 864.06280517578, -1769.6899414063, 13.261029243469, 0, 0, 54.497009277344);
    CreateDynamicObject(12957, 829.83361816406, -1784.8248291016, 13.609224319458, 0, 0, 54.497009277344);
    CreateDynamicObject(12957, 819.86663818359, -1768.0793457031, 13.276654243469, 0, 0, 320.69702148438);
    CreateDynamicObject(12957, 791.3583984375, -1780.5947265625, 13.121271133423, 0, 0, 118.14700317383);
    CreateDynamicObject(12957, 748.71929931641, -1753.1066894531, 12.945906639099, 0, 0, 118.14700317383);
    CreateDynamicObject(12957, 764.23364257813, -1787.6164550781, 12.901500701904, 0, 0, 195.19708251953);
    CreateDynamicObject(12957, 711.51953125, -1766.787109375, 14.151270866394, 0, 0, 24.347015380859);
    CreateDynamicObject(12957, 743.82769775391, -1771.8950195313, 13.149603843689, 0, 0, 31.047027587891);
    CreateDynamicObject(12957, 735.0966796875, -1759.765625, 13.873247146606, 0, 0, 201.89709472656);
    CreateDynamicObject(12957, 675.38250732422, -1739.0765380859, 13.293307304382, 0, 0, 24.347015380859);
    CreateDynamicObject(12957, 710.986328125, -1753.4217529297, 14.206421852112, 0, 0, 118.14700317383);
    CreateDynamicObject(12957, 653.4248046875, -1757.783203125, 13.404134750366, 0, 0, 118.14700317383);
    CreateDynamicObject(12957, 618.564453125, -1721.7216796875, 13.770315170288, 0, 0, 118.14697265625);
    CreateDynamicObject(12957, 570.3369140625, -1737.9921875, 13.359817504883, 0, 0, 118.14700317383);
    CreateDynamicObject(12957, 557.22265625, -1714.599609375, 13.059728622437, 0, 0, 118.14700317383);
    CreateDynamicObject(12957, 508.2841796875, -1725.607421875, 11.684452056885, 0, 0, 118.14700317383);
    CreateDynamicObject(12957, 514.96875, -1706.298828125, 12.416277885437, 0, 0, 118.14700317383);
    CreateDynamicObject(12957, 472.07531738281, -1719.578125, 10.78427028656, 0, 0, 118.14700317383);
    CreateDynamicObject(12957, 435.9755859375, -1699.6337890625, 11.355808258057, 0, 0, 118.14700317383);
    CreateDynamicObject(12957, 412.2978515625, -1717.818359375, 8.7549982070923, 0, 0, 118.14700317383);
    CreateDynamicObject(12957, 460.97741699219, -1737.9083251953, 9.0912275314331, 0, 0, 118.14700317383);
    CreateDynamicObject(12957, 337.98828125, -1696.8095703125, 6.4419045448303, 0, 0, 118.14700317383);
    CreateDynamicObject(12957, 344.48004150391, -1723.6203613281, 6.647114276886, 0, 0, 118.14697265625);
    CreateDynamicObject(3594, 1048.6712646484, -1815.1394042969, 13.216997146606, 0, 0, 190.94567871094);
    CreateDynamicObject(12957, 1059.7928466797, -1815.8524169922, 13.607620239258, 0, 0, 118.14697265625);
    CreateDynamicObject(3594, 1040.8011474609, -1826.4321289063, 13.220425605774, 0, 0, 164.14233398438);
    CreateDynamicObject(3594, 1041.8438720703, -1807.9464111328, 13.2397108078, 0, 0, 164.14123535156);
    CreateDynamicObject(3593, 1030.8742675781, -1817.9768066406, 13.300681114197, 0, 0, 113.89892578125);
    CreateDynamicObject(3594, 1027.3666992188, -1809.4727783203, 13.516485214233, 0, 0, 144.04116821289);
    CreateDynamicObject(12957, 1031.3288574219, -1790.6801757813, 13.577797889709, 0, 0, 118.14697265625);
    CreateDynamicObject(3593, 1035.3912353516, -1798.1918945313, 13.110441207886, 0, 0, 113.89526367188);
    CreateDynamicObject(3593, 1021.0629882813, -1799.0946044922, 13.225703239441, 0, 0, 160.79534912109);
    CreateDynamicObject(3594, 1010.81640625, -1809.0590820313, 13.528052330017, 0, 0, 194.28631591797);
    CreateDynamicObject(3594, 1024.3120117188, -1786.6519775391, 13.339468955994, 0, 0, 56.936279296875);
    CreateDynamicObject(3594, 983.38635253906, -1799.9610595703, 13.548493385315, 0, 0, 117.23211669922);
    CreateDynamicObject(3593, 1004.6591796875, -1790.1895751953, 13.432872772217, 0, 0, 123.94036865234);
    CreateDynamicObject(3594, 1003.3054199219, -1779.9523925781, 13.596891403198, 0, 0, 117.23211669922);
    CreateDynamicObject(12957, 995.53955078125, -1811.6423339844, 14.104347229004, 0, 0, 175.09704589844);
    CreateDynamicObject(3594, 967.33215332031, -1785.0885009766, 13.73389339447, 0, 0, 117.22961425781);
    CreateDynamicObject(3593, 940.69177246094, -1798.7099609375, 13.656686782837, 0, 0, 123.93676757813);
    CreateDynamicObject(12957, 1001.6390991211, -1796.6378173828, 13.866059303284, 0, 0, 17.647033691406);
    CreateDynamicObject(3593, 988.34210205078, -1807.0072021484, 13.318503379822, 0, 0, 123.93676757813);
    CreateDynamicObject(3594, 966.97198486328, -1797.9593505859, 13.730846405029, 0, 0, 227.77978515625);
    CreateDynamicObject(3594, 989.32977294922, -1786.2307128906, 13.698941230774, 0, 0, 197.62973022461);
    CreateDynamicObject(3594, 951.54406738281, -1780.2476806641, 13.42174243927, 0, 356.64996337891, 93.779357910156);
    CreateDynamicObject(12957, 949.67181396484, -1775.9069824219, 13.834679603577, 0, 0, 205.24713134766);
    CreateDynamicObject(3593, 913.5302734375, -1776.48828125, 12.800719261169, 0, 0, 123.93127441406);
    CreateDynamicObject(3594, 926.90600585938, -1788.6533203125, 12.800686836243, 0, 356.64916992188, 33.479339599609);
    CreateDynamicObject(3594, 894.11779785156, -1778.5855712891, 13.271606445313, 0, 356.64367675781, 33.475341796875);
    CreateDynamicObject(3593, 909.11102294922, -1733.6260986328, 13.257042884827, 0, 0, 123.93676757813);
    CreateDynamicObject(12957, 922.04901123047, -1717.0710449219, 13.261029243469, 0, 0, 118.14700317383);
    CreateDynamicObject(3594, 913.36810302734, -1706.2296142578, 13.009079933167, 0, 356.64367675781, 33.475341796875);
    CreateDynamicObject(3594, 913.54809570313, -1619.8432617188, 12.788990020752, 0, 356.64367675781, 33.475341796875);
    CreateDynamicObject(3594, 922.62976074219, -1651.7403564453, 12.953052520752, 0, 356.64367675781, 313.07534790039);
    CreateDynamicObject(12957, 916.82086181641, -1681.1041259766, 13.268839836121, 0, 0, 118.14700317383);
    CreateDynamicObject(3593, 920.91925048828, -1601.2198486328, 13.092980384827, 0, 0, 123.93676757813);
    CreateDynamicObject(3594, 872.18292236328, -1776.86328125, 13.306677818298, 0, 356.64367675781, 33.475341796875);
    CreateDynamicObject(3594, 878.26177978516, -1790.1413574219, 13.226990699768, 0, 356.64367675781, 316.42535400391);
    CreateDynamicObject(3594, 852.12591552734, -1782.9494628906, 13.421798706055, 0, 356.64367675781, 137.32528686523);
    CreateDynamicObject(3593, 843.30187988281, -1768.7718505859, 13.097493171692, 0, 0, 123.93676757813);
    CreateDynamicObject(3594, 810.19140625, -1783.8291015625, 13.12967300415, 0, 356.64367675781, 60.27099609375);
    CreateDynamicObject(3593, 805.36743164063, -1761.9041748047, 13.106778144836, 0, 0, 70.336791992188);
    CreateDynamicObject(3594, 811.22839355469, -1768.4471435547, 12.804615020752, 0, 356.64367675781, 60.27099609375);
    CreateDynamicObject(3593, 881.34948730469, -1769.3740234375, 13.092980384827, 0, 0, 3.331298828125);
    CreateDynamicObject(3593, 789.76373291016, -1764.4838867188, 12.909064292908, 0, 0, 3.328857421875);
    CreateDynamicObject(3594, 783.46203613281, -1774.4644775391, 12.909007072449, 0, 356.64367675781, 60.27099609375);
    CreateDynamicObject(3594, 754.24114990234, -1755.4749755859, 12.424506187439, 0, 356.64367675781, 60.27099609375);
    CreateDynamicObject(827, 754.81457519531, -1752.4057617188, 15.463244438171, 0, 0, 0);
    CreateDynamicObject(827, 747.68505859375, -1748.7698974609, 15.550486564636, 0, 0, 0);
    CreateDynamicObject(827, 756.72784423828, -1754.6673583984, 15.576011657715, 0, 0, 0);
    CreateDynamicObject(3593, 763.36364746094, -1771.3402099609, 12.559535980225, 0, 0, 316.42886352539);
    CreateDynamicObject(3593, 731.03552246094, -1768.2746582031, 14.047302246094, 0, 0, 319.77886962891);
    CreateDynamicObject(12957, 768.1787109375, -1761.4564208984, 12.887800216675, 0, 0, 9.3970947265625);
    CreateDynamicObject(3594, 769.46917724609, -1780.4916992188, 12.546496391296, 0, 356.64367675781, 23.420989990234);
    CreateDynamicObject(3593, 737.13983154297, -1789.1441650391, 13.121960639954, 0, 0, 3.328857421875);
    CreateDynamicObject(3594, 748.88513183594, -1682.1678466797, 3.5566656589508, 0, 356.64367675781, 60.27099609375);
    CreateDynamicObject(12957, 758.08367919922, -1703.6258544922, 5.2545428276062, 0, 0, 118.14700317383);
    CreateDynamicObject(3593, 755.56188964844, -1651.255859375, 4.4990491867065, 0, 0, 309.72885131836);
    CreateDynamicObject(3594, 746.09832763672, -1613.2950439453, 11.926264762878, 0, 356.64367675781, 60.27099609375);
    CreateDynamicObject(12957, 753.16595458984, -1595.3706054688, 13.614726066589, 0, 0, 118.14700317383);
    CreateDynamicObject(827, 751.96221923828, -1750.9664306641, 15.514963150024, 0, 0, 0);
    CreateDynamicObject(827, 749.77966308594, -1749.8845214844, 15.627770423889, 0, 0, 0);
    CreateDynamicObject(827, 758.93676757813, -1753.14453125, 15.508211135864, 0, 0, 0);
    CreateDynamicObject(827, 762.15142822266, -1753.7220458984, 15.698757171631, 0, 0, 0);
    CreateDynamicObject(827, 760.68963623047, -1755.3112792969, 15.780754089355, 0, 0, 0);
    CreateDynamicObject(3594, 750.43237304688, -1763.1207275391, 12.455237388611, 0, 356.64367675781, 23.417358398438);
    CreateDynamicObject(3594, 723.10662841797, -1751.6232910156, 14.052349090576, 0, 356.64367675781, 23.417358398438);
    CreateDynamicObject(3593, 695.82293701172, -1757.8201904297, 13.421967506409, 0, 0, 3.328857421875);
    CreateDynamicObject(3594, 697.88110351563, -1743.6661376953, 13.056818962097, 0, 356.64367675781, 23.417358398438);
    CreateDynamicObject(3593, 674.04559326172, -1762.9506835938, 13.251924514771, 0, 0, 3.328857421875);
    CreateDynamicObject(3594, 665.59564208984, -1748.2967529297, 13.252951622009, 0, 356.64367675781, 23.417358398438);
    CreateDynamicObject(3593, 639.15374755859, -1721.0053710938, 13.811861038208, 0, 0, 299.67889404297);
    CreateDynamicObject(3594, 652.36529541016, -1731.4154052734, 13.371697425842, 0, 356.64367675781, 346.5673828125);
    CreateDynamicObject(12957, 645.47454833984, -1740.3005371094, 13.355289459229, 0, 0, 20.997009277344);
    CreateDynamicObject(3594, 625.5, -1721.2734375, 13.461175918579, 0, 356.64367675781, 43.511352539063);
    CreateDynamicObject(12957, 601.9208984375, -1704.9345703125, 14.529293060303, 0, 0, 118.14697265625);
    CreateDynamicObject(3594, 607.8056640625, -1708.8515625, 14.089082717896, 0, 356.64367675781, 43.511352539063);
    CreateDynamicObject(3593, 601.8603515625, -1697.4970703125, 15.076699256897, 0, 0, 215.91979980469);
    CreateDynamicObject(3594, 595.056640625, -1692.7998046875, 15.679203987122, 0, 356.64367675781, 93.75732421875);
    CreateDynamicObject(3594, 610.6494140625, -1716.396484375, 13.404763221741, 0, 356.64367675781, 359.9560546875);
    CreateDynamicObject(3593, 608.419921875, -1728.18359375, 13.505126953125, 0, 0, 299.67407226563);
    CreateDynamicObject(12957, 627.17242431641, -1745.15234375, 13.183855056763, 0, 0, 20.994873046875);
    CreateDynamicObject(3594, 624.400390625, -1694.4130859375, 14.749731063843, 0, 356.64367675781, 43.511352539063);
    CreateDynamicObject(3594, 639.8125, -1697.23046875, 14.428174972534, 0, 356.64367675781, 137.30712890625);
    CreateDynamicObject(3593, 633.373046875, -1682.4267578125, 14.762257575989, 0, 0, 299.67407226563);
    CreateDynamicObject(12957, 622.0458984375, -1671.1865234375, 15.376347541809, 0, 0, 340.7958984375);
    CreateDynamicObject(3594, 641.02734375, -1664.1650390625, 14.062561035156, 0, 356.64367675781, 303.00842285156);
    CreateDynamicObject(3594, 634.609375, -1656.9716796875, 14.566779136658, 0, 356.64367675781, 303.0029296875);
    CreateDynamicObject(3594, 628.0380859375, -1655.6259765625, 14.819415092468, 0, 356.64367675781, 232.65747070313);
    CreateDynamicObject(3594, 645.4609375, -1633.2897949219, 14.647156715393, 0, 356.64367675781, 329.80834960938);
    CreateDynamicObject(3594, 622.3115234375, -1662.5361328125, 15.39071559906, 0, 356.64367675781, 232.65197753906);
    CreateDynamicObject(3594, 626.60363769531, -1645.8701171875, 15.275412559509, 0, 356.64367675781, 158.95733642578);
    CreateDynamicObject(12957, 625.42437744141, -1633.0771484375, 16.003591537476, 0, 0, 118.14700317383);
    CreateDynamicObject(12957, 637.88317871094, -1627.4606933594, 15.278026580811, 0, 0, 41.097015380859);
    CreateDynamicObject(3594, 619.83581542969, -1639.1958007813, 16.170763015747, 0, 356.64367675781, 158.95568847656);
    CreateDynamicObject(3594, 629.98083496094, -1614.0817871094, 15.573536872864, 0, 356.64367675781, 118.75561523438);
    CreateDynamicObject(3594, 637.66223144531, -1645.9820556641, 14.920300483704, 0, 356.64367675781, 329.80407714844);
    CreateDynamicObject(3594, 640.01147460938, -1610.4268798828, 15.101830482483, 0, 356.64367675781, 329.80407714844);
    CreateDynamicObject(12957, 621.04797363281, -1609.8272705078, 16.299715042114, 0, 0, 118.14700317383);
    CreateDynamicObject(3594, 646.43994140625, -1591.4375, 15.185864448547, 0, 356.64367675781, 158.95568847656);
    CreateDynamicObject(12957, 645.07452392578, -1579.5705566406, 15.588435173035, 0, 0, 41.094360351563);
    CreateDynamicObject(3594, 629.90966796875, -1594.7485351563, 15.171659469604, 0, 356.64367675781, 75.201232910156);
    CreateDynamicObject(3594, 636.98913574219, -1576.8824462891, 15.140207290649, 0, 356.64367675781, 75.195922851563);
    CreateDynamicObject(3594, 622.37994384766, -1578.0620117188, 15.154658317566, 0, 356.64367675781, 14.895935058594);
    CreateDynamicObject(12957, 618.36468505859, -1598.1911621094, 15.956630706787, 0, 353.29992675781, 148.29702758789);
    CreateDynamicObject(3593, 648.958984375, -1678.0224609375, 14.28767490387, 0, 0, 346.56921386719);
    CreateDynamicObject(12957, 654.46179199219, -1666.8254394531, 14.23032283783, 0, 0, 41.097015380859);
    CreateDynamicObject(3594, 665.78112792969, -1676.5806884766, 13.315028190613, 0, 356.64367675781, 303.00842285156);
    CreateDynamicObject(3593, 672.11700439453, -1667.3199462891, 13.021134376526, 0, 0, 26.774108886719);
    CreateDynamicObject(3594, 695.43286132813, -1680.1822509766, 11.218676567078, 0, 356.64367675781, 43.511352539063);
    CreateDynamicObject(12957, 698.08258056641, -1667.9271240234, 11.345497131348, 0, 0, 41.094360351563);
    CreateDynamicObject(3593, 720.06304931641, -1679.4500732422, 10.42140007019, 0, 0, 346.56921386719);
    CreateDynamicObject(3594, 728.39636230469, -1669.8403320313, 10.302097320557, 0, 356.64367675781, 43.511352539063);
    CreateDynamicObject(12957, 747.54595947266, -1678.4291992188, 10.685777664185, 0, 0, 223.54440307617);
    CreateDynamicObject(3593, 766.59167480469, -1670.1885986328, 12.363689422607, 0, 0, 346.56921386719);
    CreateDynamicObject(3594, 591.2998046875, -1597.6301269531, 15.810864448547, 0, 356.64367675781, 14.891967773438);
    CreateDynamicObject(12957, 590.63513183594, -1577.1794433594, 16.057905197144, 0, 353.29833984375, 148.29348754883);
    CreateDynamicObject(3593, 579.96112060547, -1585.9985351563, 15.725789070129, 0, 0, 299.67407226563);
    CreateDynamicObject(3594, 557.58929443359, -1578.9489746094, 15.638989448547, 0, 356.64367675781, 14.891967773438);
    CreateDynamicObject(12957, 533.65026855469, -1599.4016113281, 15.886029243469, 0, 353.29833984375, 148.29348754883);
    CreateDynamicObject(3593, 568.724609375, -1597.9849853516, 15.889855384827, 0, 0, 219.27404785156);
    CreateDynamicObject(12957, 524.13372802734, -1623.1479492188, 16.640310287476, 0, 353.29833984375, 81.29345703125);
    CreateDynamicObject(3593, 548.01281738281, -1611.2973632813, 16.102596282959, 0, 0, 219.27062988281);
    CreateDynamicObject(3594, 528.25732421875, -1637.9350585938, 16.928510665894, 0, 356.64367675781, 301.19195556641);
    CreateDynamicObject(3594, 517.84393310547, -1622.2386474609, 16.354890823364, 0, 356.64367675781, 301.19018554688);
    CreateDynamicObject(12957, 547.44580078125, -1632.2487792969, 17.039072036743, 0, 353.29833984375, 71.243469238281);
    CreateDynamicObject(3593, 545.98370361328, -1645.4694824219, 17.669828414917, 0, 0, 219.27062988281);
    CreateDynamicObject(3594, 539.17919921875, -1624.1524658203, 16.277135848999, 0, 356.64367675781, 254.29022216797);
    CreateDynamicObject(3594, 535.78277587891, -1646.98046875, 17.487413406372, 0, 356.64367675781, 247.59020996094);
    CreateDynamicObject(3594, 542.28289794922, -1663.91796875, 18.162425994873, 0, 356.64367675781, 247.587890625);
    CreateDynamicObject(3593, 534.13061523438, -1676.8471679688, 18.460168838501, 0, 0, 219.27062988281);
    CreateDynamicObject(12957, 517.89636230469, -1664.1252441406, 18.401937484741, 0, 353.29284667969, 134.89334106445);
    CreateDynamicObject(3594, 563.52099609375, -1673.5727539063, 17.714673995972, 0, 356.64367675781, 204.03782653809);
    CreateDynamicObject(3593, 555.71752929688, -1661.8735351563, 18.372417449951, 0, 0, 219.27062988281);
    CreateDynamicObject(3594, 572.86083984375, -1666.2651367188, 17.252708435059, 0, 356.64367675781, 200.68780517578);
    CreateDynamicObject(3593, 584.34545898438, -1677.9060058594, 16.447414398193, 0, 0, 219.27062988281);
    CreateDynamicObject(3594, 596.19396972656, -1669.3947753906, 15.7290391922, 0, 356.64367675781, 157.13720703125);
    CreateDynamicObject(3594, 608.99407958984, -1679.4051513672, 15.608539581299, 0, 356.64367675781, 157.13195800781);
    CreateDynamicObject(3594, 632.84350585938, -1559.5024414063, 14.962773323059, 0, 356.64367675781, 75.195922851563);
    CreateDynamicObject(12957, 623.07012939453, -1541.6768798828, 15.014819145203, 0, 0, 41.094360351563);
    CreateDynamicObject(3594, 641.37670898438, -1543.5281982422, 14.805414199829, 0, 356.64367675781, 297.84600830078);
    CreateDynamicObject(3593, 606.63421630859, -1587.1905517578, 15.717980384827, 0, 0, 232.67407226563);
    CreateDynamicObject(3593, 630.8974609375, -1525.7946777344, 14.679997444153, 0, 0, 232.67395019531);
    CreateDynamicObject(12957, 620.05755615234, -1505.1954345703, 14.805357933044, 0, 0, 283.84436035156);
    CreateDynamicObject(3593, 641.84686279297, -1509.1446533203, 14.511975288391, 0, 0, 303.02392578125);
    CreateDynamicObject(3594, 631.3701171875, -1504.3701171875, 14.385184288025, 0, 356.64367675781, 297.83935546875);
    CreateDynamicObject(3594, 621.68499755859, -1517.0142822266, 14.680724143982, 0, 356.64367675781, 75.195922851563);
    CreateDynamicObject(3593, 647.9892578125, -1475.2138671875, 14.383197784424, 0, 0, 303.01391601563);
    CreateDynamicObject(3594, 622.73345947266, -1475.3179931641, 14.071024894714, 0, 356.64367675781, 297.84484863281);
    CreateDynamicObject(12957, 632.4951171875, -1486.59375, 14.439222335815, 0, 0, 240.29278564453);
    CreateDynamicObject(3593, 591.58227539063, -1717.7955322266, 13.276920318604, 0, 0, 192.47399902344);
    CreateDynamicObject(3594, 585.76745605469, -1725.0876464844, 12.871571540833, 0, 356.64367675781, 326.46136474609);
    CreateDynamicObject(3594, 583.41766357422, -1734.9796142578, 12.590213775635, 0, 356.64367675781, 359.9560546875);
    CreateDynamicObject(12957, 585.5205078125, -1684.7122802734, 16.489315032959, 0, 0, 307.29702758789);
    CreateDynamicObject(3594, 611.14916992188, -1741.9665527344, 13.051175117493, 0, 356.64367675781, 212.55871582031);
    CreateDynamicObject(3594, 594.72088623047, -1738.7453613281, 12.899509429932, 0, 356.64367675781, 179.05792236328);
    CreateDynamicObject(12957, 604.63549804688, -1747.34765625, 13.321496963501, 0, 0, 118.14697265625);
    CreateDynamicObject(3594, 601.52191162109, -1717.5256347656, 13.507398605347, 0, 356.64367675781, 26.756042480469);
    CreateDynamicObject(3593, 573.63537597656, -1708.58203125, 13.947704315186, 333.20007324219, 0, 185.76947021484);
    CreateDynamicObject(3594, 572.84930419922, -1720.7757568359, 12.944915771484, 0, 356.64367675781, 209.20874023438);
    CreateDynamicObject(3594, 560.27862548828, -1730.6950683594, 12.500082015991, 0, 356.64367675781, 169.00708007813);
    CreateDynamicObject(3593, 544.50964355469, -1699.6970214844, 15.479448318481, 333.19885253906, 0, 185.76782226563);
    CreateDynamicObject(3593, 527.51354980469, -1696.3406982422, 15.632769584656, 333.19885253906, 0, 138.86773681641);
    CreateDynamicObject(3593, 545.03344726563, -1711.3781738281, 12.913855552673, 0, 0, 192.46948242188);
    CreateDynamicObject(3594, 541.54260253906, -1722.6060791016, 12.482081413269, 0, 356.64367675781, 31.652679443359);
    CreateDynamicObject(12957, 537.27258300781, -1733.3779296875, 12.218455314636, 0, 0, 148.29702758789);
    CreateDynamicObject(3594, 526.28826904297, -1707.5178222656, 12.54173374176, 0, 356.64367675781, 338.05157470703);
    CreateDynamicObject(3593, 519.72351074219, -1731.9410400391, 11.328423500061, 0.89990234375, 180, 325.56604003906);
    CreateDynamicObject(3594, 502.73825073242, -1711.0548095703, 11.536589622498, 0, 356.64367675781, 14.899322509766);
    CreateDynamicObject(3593, 527.00830078125, -1718.3911132813, 12.235463142395, 0, 0, 192.46948242188);
    CreateDynamicObject(3593, 494.63693237305, -1723.3227539063, 11.196082115173, 0, 0, 65.169372558594);
    CreateDynamicObject(3594, 495.2233581543, -1697.3836669922, 14.22899723053, 26.750366210938, 356.24090576172, 16.591369628906);
    CreateDynamicObject(3594, 470.02203369141, -1733.4071044922, 10.783493995667, 349.96740722656, 356.59149169922, 293.90301513672);
    CreateDynamicObject(3593, 454.15368652344, -1725.4361572266, 9.9257564544678, 0.8953857421875, 179.99450683594, 325.56335449219);
    CreateDynamicObject(3594, 525.64575195313, -1668.9923095703, 18.162425994873, 0, 356.64367675781, 338.04931640625);
    CreateDynamicObject(3593, 502.41766357422, -1657.8172607422, 19.236591339111, 0, 0, 192.46948242188);
    CreateDynamicObject(12957, 502.4592590332, -1668.5610351563, 19.160175323486, 0, 0, 31.047027587891);
    CreateDynamicObject(3593, 483.40454101563, -1701.7685546875, 11.512057304382, 0, 0, 21.615417480469);
    CreateDynamicObject(3594, 475.76943969727, -1707.4233398438, 10.903817176819, 0, 356.64367675781, 327.99743652344);
    CreateDynamicObject(3594, 470.60317993164, -1690.5672607422, 15.992962837219, 35.684143066406, 343.40997314453, 351.25262451172);
    CreateDynamicObject(3594, 488.23492431641, -1732.7550048828, 12.069571495056, 333.24963378906, 356.24087524414, 306.20294189453);
    CreateDynamicObject(3593, 327.26153564453, -1649.9793701172, 33.022666931152, 0, 0, 21.610107421875);
    CreateDynamicObject(12957, 344.91592407227, -1646.9006347656, 32.931560516357, 0, 0, 118.14700317383);
    CreateDynamicObject(3594, 314.56954956055, -1638.8374023438, 32.770385742188, 0, 356.64367675781, 327.99682617188);
    CreateDynamicObject(3593, 302.69183349609, -1644.0281982422, 32.858604431152, 0, 0, 21.610107421875);
    CreateDynamicObject(12957, 288.6178894043, -1639.8266601563, 33.026653289795, 0, 0, 118.14697265625);
    CreateDynamicObject(3594, 298.44799804688, -1633.7268066406, 32.948440551758, 0, 356.64367675781, 291.14685058594);
    CreateDynamicObject(3593, 463.52380371094, -1706.1688232422, 10.639086723328, 0, 0, 18.265411376953);
    CreateDynamicObject(3594, 483.31744384766, -1713.8264160156, 10.972917556763, 0, 356.64367675781, 21.596832275391);
    CreateDynamicObject(3594, 448.87344360352, -1699.9381103516, 10.250279426575, 0, 356.64367675781, 327.99682617188);
    CreateDynamicObject(3593, 445.11724853516, -1714.5792236328, 9.8942308425903, 0, 0, 18.264770507813);
    CreateDynamicObject(3594, 433.78704833984, -1714.4259033203, 9.1253957748413, 0, 356.64367675781, 28.296844482422);
    CreateDynamicObject(12957, 416.76766967773, -1696.3227539063, 9.4245948791504, 0, 0, 41.097015380859);
    CreateDynamicObject(3593, 414.3127746582, -1705.3896484375, 8.9584894180298, 0, 0, 51.764770507813);
    CreateDynamicObject(3593, 442.1575012207, -1774.490234375, 5.0615820884705, 0, 0, 18.264770507813);
    CreateDynamicObject(3594, 426.79943847656, -1771.0783691406, 4.9139404296875, 0, 356.64367675781, 327.99682617188);
    CreateDynamicObject(3594, 407.57144165039, -1779.5187988281, 5.1953992843628, 0, 356.64367675781, 28.295288085938);
    CreateDynamicObject(12957, 356.44848632813, -1768.8006591797, 5.1173377037048, 0, 0, 31.047027587891);
    CreateDynamicObject(3594, 399.50823974609, -1699.2779541016, 8.1913919448853, 0, 356.64367675781, 28.295288085938);
    CreateDynamicObject(12957, 390.1064453125, -1716.5968017578, 7.823447227478, 0, 0, 17.647033691406);
    CreateDynamicObject(3594, 376.10632324219, -1697.2481689453, 6.9772863388062, 0, 356.64367675781, 338.04528808594);
    CreateDynamicObject(3593, 381.34158325195, -1711.3110351563, 7.522997379303, 0, 0, 51.762084960938);
    CreateDynamicObject(3594, 345.80187988281, -1705.5466308594, 6.2427682876587, 0, 356.64367675781, 4.8438110351563);
    CreateDynamicObject(3593, 358.01965332031, -1717.4412841797, 6.4489388465881, 0, 0, 51.762084960938);
    CreateDynamicObject(3594, 355.75799560547, -1694.9891357422, 6.4999551773071, 0, 356.64367675781, 34.993804931641);
    CreateDynamicObject(3593, 329.54821777344, -1707.7412109375, 6.094527721405, 0, 0, 155.61212158203);
    CreateDynamicObject(3594, 319.99502563477, -1719.2895507813, 6.34144115448, 0, 356.64367675781, 18.243804931641);
    CreateDynamicObject(12957, 316.67935180664, -1691.2171630859, 6.7340888977051, 0, 0, 37.747039794922);
    CreateDynamicObject(3594, 312.97598266602, -1702.5891113281, 6.5010709762573, 0, 356.64367675781, 287.78948974609);
    CreateDynamicObject(3593, 297.46612548828, -1689.7354736328, 6.7210898399353, 0, 0, 155.6103515625);
    CreateDynamicObject(12957, 289.56024169922, -1706.4346923828, 7.0171675682068, 0, 0, 340.79351806641);
    CreateDynamicObject(3594, 283.55718994141, -1696.4139404297, 7.2946348190308, 0, 356.64367675781, 41.686859130859);
    CreateDynamicObject(3594, 303.78921508789, -1724.8278808594, 5.2637853622437, 13.376586914063, 356.54998779297, 19.041870117188);
    CreateDynamicObject(3594, 297.11151123047, -1740.47265625, 3.6342298984528, 0, 356.64367675781, 207.39277648926);
    CreateDynamicObject(3593, 287.50112915039, -1730.4908447266, 3.980516910553, 0, 0, 155.6103515625);
    CreateDynamicObject(12957, 268.71304321289, -1728.8924560547, 3.8157172203064, 0, 0, 216.84042358398);
    CreateDynamicObject(3593, 340.31848144531, -1743.7640380859, 4.208878993988, 0, 0, 155.6103515625);
    CreateDynamicObject(3594, 319.83636474609, -1740.2683105469, 4.0459814071655, 0, 356.64367675781, 180.59272766113);
    CreateDynamicObject(3593, 272.46133422852, -1702.0783691406, 7.5164403915405, 0, 0, 155.6103515625);
    CreateDynamicObject(3594, 275.39526367188, -1682.6834716797, 7.6557769775391, 0, 356.64367675781, 138.83215332031);
    CreateDynamicObject(12957, 261.51766967773, -1699.0908203125, 8.2080316543579, 0, 0, 193.39044189453);
    CreateDynamicObject(3594, 251.71533203125, -1689.7734375, 8.7280168533325, 0, 356.64367675781, 41.68212890625);
    CreateDynamicObject(3593, 241.21768188477, -1703.8874511719, 7.6280565261841, 353.29998779297, 0, 155.6103515625);
    CreateDynamicObject(3594, 243.58969116211, -1669.8531494141, 10.038331031799, 0, 356.64367675781, 138.82873535156);
    CreateDynamicObject(3594, 218.51553344727, -1662.583984375, 11.363241195679, 0, 356.64367675781, 348.07873535156);
    CreateDynamicObject(3594, 228.25216674805, -1649.4680175781, 11.550952911377, 0, 356.64367675781, 138.82873535156);
    CreateDynamicObject(3594, 185.28715515137, -1618.5877685547, 14.156757354736, 0, 356.64367675781, 98.628723144531);
    CreateDynamicObject(3594, 191.58212280273, -1604.3096923828, 13.86144733429, 0, 356.64367675781, 202.47888183594);
    CreateDynamicObject(3593, 232.62966918945, -1673.2977294922, 10.562718391418, 0, 0, 185.76037597656);
    CreateDynamicObject(3593, 215.61506652832, -1638.1805419922, 13.302580833435, 0, 0, 185.7568359375);
    CreateDynamicObject(12957, 223.22430419922, -1680.3488769531, 11.050658226013, 0, 0, 193.38684082031);
    CreateDynamicObject(12957, 200.82173156738, -1641.4357910156, 13.787499427795, 0, 0, 283.83688354492);
    CreateDynamicObject(3594, 639.98583984375, -1457.89453125, 13.883813858032, 0, 356.64367675781, 244.23931884766);
    CreateDynamicObject(3593, 633.20068359375, -1464.8349609375, 13.812378883362, 0, 349.95001220703, 249.41394042969);
    CreateDynamicObject(12957, 625.33184814453, -1446.6859130859, 14.016478538513, 0, 0, 320.68743896484);
    CreateDynamicObject(3594, 641.57012939453, -1441.1348876953, 13.712505340576, 0, 356.64367675781, 190.6369934082);
    CreateDynamicObject(3594, 632.06958007813, -1431.1470947266, 13.55822467804, 0, 356.64367675781, 120.28689575195);
    CreateDynamicObject(12957, 643.90051269531, -1422.8395996094, 13.691030502319, 0, 0, 320.68542480469);
    CreateDynamicObject(3593, 627.73944091797, -1414.2067871094, 13.091600418091, 0, 349.94750976563, 249.41162109375);

//Refugio Hospital Saint por GROVE4L
    CreateDynamicObject(3066,1204.826,-1341.723,13.454,0.0,0.0,-307.999);
    CreateDynamicObject(18257,1202.930,-1296.025,12.383,0.0,0.0,-202.002);
    CreateDynamicObject(3577,1204.457,-1308.956,13.175,0.0,0.0,-313.998);
    CreateDynamicObject(944,1195.581,-1355.540,13.271,0.0,0.0,-337.999);
    CreateDynamicObject(922,1185.267,-1330.206,13.460,0.0,0.0,-330.001);
    CreateDynamicObject(944,1188.009,-1307.096,13.440,0.0,0.0,-24.001);
    CreateDynamicObject(4597,1194.561,-1292.217,12.862,0.0,0.0,0.0);
    CreateDynamicObject(3578,1190.943,-1361.712,13.167,0.0,0.0,0.0);
    CreateDynamicObject(3578,1206.978,-1361.599,13.138,0.0,0.0,0.0);
    CreateDynamicObject(3578,1212.251,-1354.086,13.352,0.0,0.0,-270.001);
    CreateDynamicObject(3578,1212.424,-1340.727,13.349,0.0,0.0,-270.001);
    CreateDynamicObject(3578,1212.308,-1328.055,13.338,0.0,0.0,-270.001);
    CreateDynamicObject(3578,1212.397,-1315.063,13.335,0.0,0.0,-270.001);
    CreateDynamicObject(3578,1212.564,-1301.302,13.329,0.0,0.0,-270.001);
    CreateDynamicObject(960,1205.141,-1334.183,12.780,0.0,0.0,0.0);
    CreateDynamicObject(960,1200.910,-1334.687,12.780,0.0,0.0,-336.000);
    CreateDynamicObject(960,1202.762,-1332.196,12.780,0.0,0.0,-9.998);
    CreateDynamicObject(960,1183.005,-1309.159,12.954,0.0,0.0,0.0);
    CreateDynamicObject(851,1196.023,-1319.537,12.711,0.0,0.0,0.0);
    CreateDynamicObject(851,1195.795,-1348.298,12.714,0.0,0.0,0.0);
    CreateDynamicObject(851,1224.431,-1307.197,12.789,0.0,0.0,0.0);
    CreateDynamicObject(3097,1173.935,-1320.169,17.680,0.0,0.0,0.0);
    CreateDynamicObject(3097,1171.069,-1317.789,18.387,-345.001,-358.001,-268.998);
    CreateDynamicObject(3092,1176.859,-1321.583,13.006,-270.001,-180.000,-180.997);
    CreateDynamicObject(3092,1182.534,-1330.192,12.799,-270.001,-180.000,-180.997);
    CreateDynamicObject(1438,1188.451,-1335.084,12.562,0.0,0.0,-343.998);
    CreateDynamicObject(3577,1176.038,-1308.569,13.782,0.0,0.0,-234.999);
    CreateDynamicObject(2035,1187.238,-1307.123,14.025,0.0,0.0,0.0);
    CreateDynamicObject(2035,1188.363,-1307.370,14.025,0.0,0.0,-65.999);
    CreateDynamicObject(2044,1184.896,-1330.503,13.542,0.0,0.0,0.0);
    CreateDynamicObject(2044,1185.835,-1329.859,13.542,0.0,0.0,-80.002);
    CreateDynamicObject(2036,1185.345,-1330.144,13.548,0.0,0.0,-114.001);
    CreateDynamicObject(2059,1183.269,-1326.912,12.586,0.0,0.0,0.0);
    CreateDynamicObject(3005,1207.511,-1352.508,12.402,0.0,0.0,0.0);
    CreateDynamicObject(2907,1193.739,-1331.434,12.558,0.0,0.0,67.500);
    CreateDynamicObject(2907,1203.950,-1353.432,12.562,0.0,0.0,-43.997);
    CreateDynamicObject(2907,1201.546,-1302.617,12.548,0.0,0.0,-328.001);
    CreateDynamicObject(2907,1193.871,-1300.739,12.547,0.0,0.0,-80.999);
    CreateDynamicObject(2907,1194.882,-1295.926,12.543,0.0,0.0,-67.002);
    CreateDynamicObject(2907,1200.800,-1359.325,12.525,0.0,0.0,-105.000);
    CreateDynamicObject(2905,1199.109,-1295.203,12.474,0.0,0.0,-332.000);
    CreateDynamicObject(2905,1199.313,-1354.967,12.481,0.0,0.0,-332.997);
    CreateDynamicObject(2905,1209.715,-1307.845,12.483,0.0,0.0,-52.999);
    CreateDynamicObject(2905,1204.030,-1359.681,12.462,0.0,0.0,-52.999);
    CreateDynamicObject(2906,1188.112,-1304.489,12.627,0.0,0.0,-309.999);
    CreateDynamicObject(2906,1198.979,-1318.427,12.472,0.0,0.0,0.0);
    CreateDynamicObject(2906,1186.806,-1312.019,12.638,0.0,0.0,-230.999);
    CreateDynamicObject(2906,1195.137,-1358.840,12.441,0.0,0.0,-230.999);
    CreateDynamicObject(2906,1195.435,-1359.659,12.437,0.0,0.0,-150.997);
    CreateDynamicObject(2906,1195.239,-1299.478,12.460,0.0,0.0,-150.997);
    CreateDynamicObject(2906,1208.552,-1302.584,12.462,0.0,0.0,-240.998);
    CreateDynamicObject(2906,1198.073,-1297.123,12.458,0.0,0.0,-240.998);
    CreateDynamicObject(2906,1209.341,-1304.685,12.464,0.0,0.0,-311.001);
    CreateDynamicObject(2926,1205.335,-1325.666,12.398,0.0,0.0,0.0);
    CreateDynamicObject(2926,1206.573,-1313.426,12.398,0.0,0.0,-307.999);
    CreateDynamicObject(2926,1192.687,-1327.869,12.398,0.0,0.0,-238.998);
    CreateDynamicObject(2907,1207.680,-1330.946,12.558,0.0,0.0,0.0);
    CreateDynamicObject(2908,1205.357,-1328.153,12.476,0.0,0.0,0.0);
    CreateDynamicObject(2908,1198.285,-1339.501,12.476,0.0,0.0,0.0);
    CreateDynamicObject(2908,1195.956,-1326.659,12.476,0.0,0.0,67.500);
    CreateDynamicObject(2908,1191.755,-1327.315,12.476,0.0,0.0,0.0);
    CreateDynamicObject(2908,1197.008,-1295.667,12.460,0.0,0.0,-300.001);
    CreateDynamicObject(2908,1184.654,-1308.760,12.650,0.0,0.0,0.0);
    CreateDynamicObject(2672,1195.678,-1303.723,12.668,0.0,0.0,0.0);
    CreateDynamicObject(2672,1195.678,-1303.723,12.668,0.0,0.0,0.0);
    CreateDynamicObject(2672,1207.136,-1319.215,12.678,0.0,0.0,0.0);
    CreateDynamicObject(2676,1199.497,-1327.391,12.502,0.0,0.0,0.0);
    CreateDynamicObject(2676,1203.183,-1355.405,12.498,0.0,0.0,-41.998);
    CreateDynamicObject(3593,1207.181,-1369.254,12.696,0.0,0.0,0.0);
    CreateDynamicObject(3593,1194.910,-1372.737,13.034,0.0,0.0,-41.998);
    CreateDynamicObject(3593,1220.431,-1291.356,13.468,0.0,0.0,-65.002);
    CreateDynamicObject(3594,1204.621,-1377.491,12.896,0.0,0.0,56.250);
    CreateDynamicObject(3279,1177.291,-1350.905,18.214,0.0,0.0,90.000);
    CreateDynamicObject(3279,1214.590,-1350.763,12.374,0.0,0.0,180.000);
    CreateDynamicObject(3279,1214.455,-1311.776,12.432,0.0,0.0,180.000);
    CreateDynamicObject(3361,1178.739,-1340.005,16.353,0.0,0.0,0.0);
    CreateDynamicObject(3282,1182.003,-1348.148,18.449,0.0,0.0,90.000);
    CreateDynamicObject(3594,1228.426,-1371.907,13.046,0.0,0.0,56.250);
    CreateDynamicObject(3594,1224.970,-1321.801,13.119,0.0,0.0,112.500);
    CreateDynamicObject(3594,1238.984,-1295.460,12.988,0.0,0.0,146.250);
    CreateDynamicObject(3594,1240.669,-1350.939,13.002,0.0,0.0,-22.500);
    CreateDynamicObject(12957,1184.333,-1289.586,13.425,0.0,0.0,33.750);
    CreateDynamicObject(12957,1241.574,-1316.056,13.299,-27.502,0.859,-33.750);
    CreateDynamicObject(12957,1221.629,-1357.286,13.120,2.578,-50.707,90.000);
    CreateDynamicObject(2676,1223.364,-1352.095,12.599,0.0,0.0,0.0);
    CreateDynamicObject(2676,1240.147,-1337.449,12.472,0.0,0.0,56.250);
    CreateDynamicObject(2675,1228.679,-1296.598,12.517,0.0,0.0,0.0);
    CreateDynamicObject(911,1229.689,-1341.338,13.710,0.0,0.0,-90.000);
    CreateDynamicObject(910,1230.342,-1338.200,14.407,0.0,0.0,-45.000);
    CreateDynamicObject(923,1225.327,-1337.800,13.364,0.0,0.0,56.250);
    CreateDynamicObject(942,1183.152,-1347.741,15.618,0.0,0.0,180.000);
    CreateDynamicObject(960,1226.928,-1342.384,13.156,0.0,0.0,22.500);
    CreateDynamicObject(960,1223.768,-1339.364,12.866,0.0,0.0,90.000);
    CreateDynamicObject(960,1225.451,-1339.772,12.866,0.0,0.0,45.000);
    CreateDynamicObject(1227,1229.618,-1343.062,14.005,0.0,0.0,33.750);
    CreateDynamicObject(2044,1229.715,-1341.020,13.551,0.0,0.0,-90.000);
    CreateDynamicObject(2035,1229.841,-1341.523,13.528,0.0,0.0,236.250);
    CreateDynamicObject(3267,1215.674,-1351.948,27.688,-30.940,-1.719,-146.250);
    CreateDynamicObject(3267,1214.317,-1309.956,27.820,-30.940,-1.719,0.0);
    CreateDynamicObject(1215,1214.225,-1309.145,29.700,0.0,0.0,0.0);
    CreateDynamicObject(1215,1216.116,-1352.488,29.539,0.0,0.0,0.0);
    CreateDynamicObject(3525,1196.990,-1302.458,11.407,0.0,0.0,78.750);
    CreateDynamicObject(3525,1183.481,-1324.737,11.821,0.0,0.0,67.500);
    CreateDynamicObject(3525,1204.511,-1333.458,11.517,0.0,0.0,67.500);
    CreateDynamicObject(3525,1201.654,-1334.437,11.592,0.0,0.0,67.500);
    CreateDynamicObject(3525,1202.863,-1369.531,11.551,0.0,0.0,67.500);
    CreateDynamicObject(3525,1207.853,-1375.170,11.472,0.0,0.0,67.500);
    CreateDynamicObject(3525,1202.346,-1357.328,11.644,0.0,0.0,67.500);
    CreateDynamicObject(3525,1195.702,-1363.688,11.609,0.0,0.0,67.500);
    CreateDynamicObject(2908,1192.403,-1305.671,12.469,0.0,0.0,67.500);
    CreateDynamicObject(2908,1186.648,-1308.012,12.640,0.0,0.0,22.500);
    CreateDynamicObject(2906,1186.017,-1307.053,12.637,0.0,0.0,-174.749);

//Binco de GroveStreet por GROVE4L
    CreateDynamicObject(2846,2255.155,-1659.441,14.294,0.0,0.0,78.750);
    CreateDynamicObject(2846,2251.070,-1658.946,14.297,0.0,0.0,146.250);
    CreateDynamicObject(2846,2245.897,-1658.476,14.300,0.0,0.0,90.000);
    CreateDynamicObject(2846,2248.766,-1658.474,14.298,0.0,0.0,146.250);
    CreateDynamicObject(2846,2251.490,-1658.421,14.296,0.0,0.0,236.250);
    CreateDynamicObject(2845,2250.561,-1657.463,14.293,0.0,0.0,33.750);
    CreateDynamicObject(2845,2251.282,-1656.204,14.292,0.0,0.0,-22.500);
    CreateDynamicObject(2845,2252.598,-1660.799,14.291,0.0,0.0,-45.000);
    CreateDynamicObject(2845,2249.431,-1658.998,14.294,0.0,0.0,33.750);
    CreateDynamicObject(2843,2248.343,-1657.779,14.290,0.0,0.0,56.250);
    CreateDynamicObject(2843,2250.250,-1657.570,14.289,0.0,0.0,-45.000);
    CreateDynamicObject(2844,2252.572,-1658.614,14.286,0.0,0.0,-22.500);
    CreateDynamicObject(2844,2252.205,-1657.412,14.286,0.0,0.0,-135.000);
    CreateDynamicObject(2844,2248.140,-1659.819,14.289,0.0,0.0,-405.000);
    CreateDynamicObject(2844,2250.409,-1660.766,14.287,0.0,0.0,-405.000);
    CreateDynamicObject(2372,2250.150,-1660.401,14.285,0.0,0.0,56.250);
    CreateDynamicObject(2372,2251.506,-1658.170,14.284,0.0,0.0,0.0);
    CreateDynamicObject(2372,2252.984,-1659.550,14.283,0.0,0.0,123.750);
    CreateDynamicObject(2372,2244.380,-1658.851,14.289,0.0,0.0,180.000);
    CreateDynamicObject(2372,2242.973,-1656.722,14.290,0.0,0.0,90.000);
    CreateDynamicObject(2371,2249.597,-1657.880,14.281,0.0,0.0,45.000);
    CreateDynamicObject(2366,2253.887,-1662.570,14.249,0.0,0.0,0.0);
    CreateDynamicObject(2368,2246.496,-1660.145,14.280,0.0,0.0,90.000);
    CreateDynamicObject(2368,2246.762,-1663.557,14.471,0.0,0.0,22.500);
    CreateDynamicObject(2368,2240.755,-1662.506,14.471,0.0,0.0,-191.250);
    CreateDynamicObject(2375,2250.536,-1664.331,14.367,0.0,0.0,33.750);
    CreateDynamicObject(2376,2241.499,-1659.517,14.277,0.0,0.0,22.500);
    CreateDynamicObject(2379,2257.241,-1659.491,14.279,0.0,0.0,213.750);
    CreateDynamicObject(2387,2251.488,-1662.185,14.287,0.0,0.0,33.750);
    CreateDynamicObject(2387,2251.065,-1662.042,14.288,0.0,0.0,78.750);
    CreateDynamicObject(2387,2243.789,-1662.174,14.474,0.0,0.0,78.750);
    CreateDynamicObject(2413,2254.562,-1664.644,14.463,0.0,0.0,56.250);
    CreateDynamicObject(2434,2251.523,-1649.865,14.470,0.0,0.0,258.750);
    CreateDynamicObject(2434,2254.375,-1650.578,14.470,0.0,0.0,-11.250);
    CreateDynamicObject(2435,2252.602,-1650.226,14.470,0.0,0.0,-11.250);
    CreateDynamicObject(2435,2251.686,-1648.989,14.470,0.0,0.0,-101.250);
    CreateDynamicObject(2435,2251.842,-1648.105,14.470,0.0,0.0,-101.250);
    CreateDynamicObject(2435,2253.471,-1650.387,14.470,0.0,0.0,-11.250);
    CreateDynamicObject(2387,2256.056,-1659.894,14.284,-399.638,0.0,33.750);
    CreateDynamicObject(2375,2256.017,-1661.762,14.052,0.0,0.0,33.750);
    CreateDynamicObject(2704,2254.932,-1660.486,15.666,0.0,0.0,213.750);
    CreateDynamicObject(2704,2256.971,-1659.082,15.676,0.0,0.0,213.750);
    CreateDynamicObject(2705,2243.256,-1656.931,15.007,0.0,0.0,78.750);
    CreateDynamicObject(2844,2245.790,-1657.251,14.290,0.0,0.0,0.0);
    CreateDynamicObject(2844,2245.790,-1655.751,14.290,0.0,0.0,-135.000);
    CreateDynamicObject(2844,2247.446,-1656.809,14.289,0.0,0.0,-135.000);
    CreateDynamicObject(2845,2245.521,-1656.882,14.372,0.0,0.0,0.0);
    CreateDynamicObject(2844,2245.548,-1656.839,14.291,0.0,0.0,56.250);
    CreateDynamicObject(2843,2245.299,-1657.189,14.292,0.0,0.0,0.0);
    CreateDynamicObject(2409,2242.446,-1658.757,15.019,0.0,0.0,22.500);
    CreateDynamicObject(2401,2252.271,-1660.217,15.004,-18.048,0.0,-45.000);
    CreateDynamicObject(2392,2251.249,-1657.290,14.995,0.0,0.0,0.0);
    CreateDynamicObject(2394,2249.528,-1660.209,15.002,0.0,0.0,-33.750);
    CreateDynamicObject(2387,2252.002,-1650.631,14.470,0.0,0.0,45.000);

//Refugio Idlewood por GROVE4L
    CreateDynamicObject(1447,2360.826,-1273.049,24.271,0.0,0.0,90.000);
    CreateDynamicObject(1447,2360.863,-1267.813,24.289,0.0,0.0,90.000);
    CreateDynamicObject(3475,2313.990,-1221.110,23.119,0.0,0.0,0.0);
    CreateDynamicObject(3550,2314.230,-1220.879,24.092,-180.482,0.0,0.0);
    CreateDynamicObject(925,2327.612,-1226.317,22.609,0.0,0.0,22.500);
    CreateDynamicObject(925,2333.161,-1228.244,22.562,0.0,0.0,-45.000);
    CreateDynamicObject(930,2330.433,-1226.806,21.976,0.0,0.0,0.0);
    CreateDynamicObject(964,2331.051,-1215.226,21.500,0.0,0.0,0.0);
    CreateDynamicObject(964,2332.639,-1215.106,21.500,0.0,0.0,0.0);
    CreateDynamicObject(964,2334.267,-1214.940,21.500,0.0,0.0,0.0);
    CreateDynamicObject(1431,2336.303,-1214.738,22.048,0.0,0.0,0.0);
    CreateDynamicObject(1685,2311.907,-1212.999,23.860,0.0,0.0,45.000);
    CreateDynamicObject(3568,2363.269,-1271.816,25.292,0.0,0.0,0.0);
    CreateDynamicObject(3570,2350.146,-1234.287,22.848,0.0,0.0,0.0);
    CreateDynamicObject(3570,2342.076,-1234.282,22.848,0.0,0.0,0.0);
    CreateDynamicObject(3570,2334.050,-1234.300,22.848,0.0,0.0,0.0);
    CreateDynamicObject(3570,2326.107,-1234.311,22.848,0.0,0.0,180.000);
    CreateDynamicObject(3576,2345.472,-1218.390,22.993,0.0,0.0,45.000);
    CreateDynamicObject(3577,2339.824,-1214.551,22.283,0.0,0.0,180.000);
    CreateDynamicObject(3796,2349.231,-1230.326,21.506,0.0,0.0,-90.000);
    CreateDynamicObject(850,2364.753,-1272.232,22.955,0.0,0.0,0.0);
    CreateDynamicObject(851,2309.519,-1221.850,23.276,0.0,0.0,11.250);
    CreateDynamicObject(854,2304.381,-1207.735,23.245,2.578,0.0,0.0);
    CreateDynamicObject(2905,2310.173,-1218.339,23.054,0.0,0.0,56.250);
    CreateDynamicObject(2905,2326.145,-1216.165,21.636,0.0,0.0,56.250);
    CreateDynamicObject(2905,2337.465,-1218.709,21.591,0.0,0.0,101.250);
    CreateDynamicObject(2905,2338.258,-1224.237,21.591,0.0,0.0,33.750);
    CreateDynamicObject(2905,2326.976,-1220.334,21.652,0.0,0.0,67.500);
    CreateDynamicObject(2907,2330.658,-1219.165,21.660,0.0,0.0,33.750);
    CreateDynamicObject(2907,2310.648,-1209.484,23.232,0.0,0.0,67.500);
    CreateDynamicObject(2907,2311.546,-1226.063,23.265,0.0,0.0,-45.000);
    CreateDynamicObject(2907,2310.382,-1219.122,23.133,0.0,0.0,11.250);
    CreateDynamicObject(2907,2307.167,-1215.123,22.879,-0.859,170.169,56.250);
    CreateDynamicObject(2907,2338.685,-1222.058,21.585,-0.859,170.169,33.750);
    CreateDynamicObject(2907,2335.828,-1226.039,21.535,-0.859,170.169,56.250);
    CreateDynamicObject(2908,2329.472,-1223.786,21.585,0.0,0.0,0.0);
    CreateDynamicObject(2908,2325.776,-1220.743,21.663,0.0,0.0,-90.000);
    CreateDynamicObject(2908,2333.808,-1216.210,21.577,0.0,0.0,-45.000);
    CreateDynamicObject(2908,2342.200,-1225.834,21.577,0.0,0.0,-101.250);
    CreateDynamicObject(2908,2338.110,-1218.325,21.577,0.0,0.0,-56.250);
    CreateDynamicObject(2906,2338.170,-1220.715,21.574,0.0,0.0,-56.250);
    CreateDynamicObject(2906,2331.575,-1217.516,21.574,0.0,0.0,-45.000);
    CreateDynamicObject(2906,2328.514,-1221.369,21.602,0.0,0.0,-45.000);
    CreateDynamicObject(2906,2328.110,-1217.134,21.610,0.0,0.0,11.250);
    CreateDynamicObject(2906,2335.517,-1225.317,21.574,0.0,0.0,56.250);
    CreateDynamicObject(2906,2334.816,-1225.428,21.574,0.0,0.0,-33.750);
    CreateDynamicObject(2906,2308.870,-1211.132,23.104,0.0,0.0,-33.750);
    CreateDynamicObject(2906,2309.809,-1211.849,23.128,0.0,0.0,-90.000);
    CreateDynamicObject(2912,2312.356,-1219.260,23.114,0.0,0.0,33.750);
    CreateDynamicObject(2912,2312.321,-1220.488,23.114,0.0,0.0,-22.500);
    CreateDynamicObject(3525,2326.647,-1223.158,20.786,0.0,0.0,0.0);
    CreateDynamicObject(3525,2344.485,-1224.674,20.694,0.0,0.0,45.000);
    CreateDynamicObject(3525,2331.880,-1216.199,20.669,0.0,0.0,45.000);
    CreateDynamicObject(3525,2333.579,-1218.536,20.719,0.0,0.0,45.000);
    CreateDynamicObject(3525,2308.894,-1219.551,22.099,0.0,0.0,-22.500);
    CreateDynamicObject(3525,2310.758,-1211.826,22.272,0.0,0.0,-22.500);
    CreateDynamicObject(3525,2312.328,-1219.242,23.033,0.0,0.0,-22.500);
    CreateDynamicObject(3267,2312.082,-1213.018,23.795,-23.205,0.0,67.500);
    CreateDynamicObject(3057,2350.413,-1230.879,21.993,0.0,0.0,0.0);
    CreateDynamicObject(3057,2348.908,-1231.128,21.993,0.0,0.0,90.000);
    CreateDynamicObject(1217,2350.129,-1229.171,22.029,0.0,0.0,0.0);
    CreateDynamicObject(1217,2348.873,-1229.817,22.029,0.0,0.0,-67.500);
    CreateDynamicObject(3797,2350.155,-1228.035,22.641,0.0,0.0,0.0);
    CreateDynamicObject(3791,2350.113,-1225.795,21.965,0.0,0.0,67.500);
    CreateDynamicObject(1242,2336.620,-1214.886,22.733,0.0,0.0,0.0);
    CreateDynamicObject(1242,2335.939,-1214.867,22.783,0.0,0.0,101.250);
    CreateDynamicObject(2035,2334.453,-1215.302,22.465,0.0,0.0,0.0);
    CreateDynamicObject(2035,2333.996,-1215.119,22.465,0.0,0.0,45.000);
    CreateDynamicObject(2044,2334.555,-1214.935,22.468,0.0,0.0,-22.500);
    CreateDynamicObject(2068,2311.146,-1217.644,24.260,0.0,122.040,0.0);
    CreateDynamicObject(2068,2311.294,-1216.564,25.785,-60.161,0.0,101.250);

//RefugioArriba Idlewood
    CreateDynamicObject(987,2359.804,-1233.508,26.969,0.0,0.0,90.000);
    CreateDynamicObject(987,2351.320,-1241.942,26.977,0.0,0.0,45.000);
    CreateDynamicObject(987,2359.900,-1221.608,26.977,0.0,0.0,146.250);
    CreateDynamicObject(849,2315.784,-1221.108,27.276,0.0,0.0,0.0);
    CreateDynamicObject(849,2310.732,-1230.865,23.298,0.0,0.0,-56.250);
    CreateDynamicObject(851,2328.234,-1232.131,27.289,0.0,0.0,0.0);
    CreateDynamicObject(851,2348.735,-1218.369,27.289,0.0,0.0,-33.750);
    CreateDynamicObject(912,2313.429,-1224.712,23.741,0.0,0.0,56.250);
    CreateDynamicObject(912,2315.989,-1224.309,25.098,-0.859,-42.112,0.0);
    CreateDynamicObject(922,2323.007,-1225.538,27.862,0.0,0.0,90.000);
    CreateDynamicObject(923,2312.197,-1229.494,24.008,0.0,0.0,-11.250);
    CreateDynamicObject(923,2349.972,-1228.015,27.856,0.0,0.0,22.500);
    CreateDynamicObject(923,2341.557,-1231.937,27.856,0.0,0.0,-45.000);
    CreateDynamicObject(1227,2319.602,-1234.421,27.828,0.0,0.0,135.000);
    CreateDynamicObject(1299,2315.996,-1229.887,27.432,0.0,0.0,22.500);
    CreateDynamicObject(1345,2318.481,-1219.288,27.397,-92.819,-1.719,0.0);
    CreateDynamicObject(1344,2316.403,-1219.513,27.785,0.0,0.0,45.000);
    CreateDynamicObject(2676,2335.734,-1227.385,27.080,0.0,0.0,0.0);
    CreateDynamicObject(2676,2336.768,-1218.612,27.080,0.0,0.0,-67.500);
    CreateDynamicObject(2677,2321.182,-1227.776,27.249,0.0,0.0,0.0);
    CreateDynamicObject(2673,2322.119,-1221.677,27.064,0.0,0.0,0.0);
    CreateDynamicObject(2673,2306.117,-1215.925,22.932,0.0,0.0,33.750);
    CreateDynamicObject(2673,2310.014,-1232.282,23.038,0.0,0.0,-45.000);
    CreateDynamicObject(2671,2310.269,-1225.860,23.065,0.0,0.0,0.0);
    CreateDynamicObject(2671,2342.160,-1221.223,26.979,0.0,0.0,0.0);
    CreateDynamicObject(2671,2353.543,-1221.284,26.979,0.0,0.0,0.0);
    CreateDynamicObject(2671,2334.439,-1228.337,26.979,0.0,0.0,-56.250);
    CreateDynamicObject(930,2326.409,-1233.563,27.452,0.0,0.0,0.0);
    CreateDynamicObject(944,2355.868,-1224.767,27.861,0.0,0.0,-90.000);
    CreateDynamicObject(944,2355.908,-1224.776,29.082,0.0,0.0,-90.000);
    CreateDynamicObject(964,2355.037,-1233.086,26.977,0.0,0.0,202.500);
    CreateDynamicObject(1431,2353.837,-1234.740,27.517,0.0,0.0,-90.000);
    CreateDynamicObject(1685,2357.699,-1229.408,27.719,0.0,0.0,0.0);
    CreateDynamicObject(3569,2419.978,-1220.496,26.402,-2.578,0.0,87.972);
    CreateDynamicObject(2907,2343.567,-1223.544,27.137,0.0,0.0,0.0);
    CreateDynamicObject(2907,2347.035,-1229.095,27.137,0.0,0.0,-45.000);
    CreateDynamicObject(2907,2334.890,-1232.237,27.137,0.0,0.0,56.250);
    CreateDynamicObject(2907,2323.304,-1231.224,27.137,0.0,0.0,-11.250);
    CreateDynamicObject(2907,2320.330,-1230.049,27.137,0.0,0.0,56.250);
    CreateDynamicObject(2907,2324.092,-1224.426,27.137,0.0,0.0,11.250);
    CreateDynamicObject(2908,2311.718,-1228.242,23.190,0.0,0.0,0.0);
    CreateDynamicObject(2908,2310.179,-1225.653,23.140,0.0,0.0,-67.500);
    CreateDynamicObject(2908,2342.055,-1218.879,27.054,0.0,0.0,-67.500);
    CreateDynamicObject(2908,2330.423,-1218.974,27.054,0.0,0.0,11.250);
    CreateDynamicObject(2908,2322.684,-1218.721,27.054,0.0,0.0,-11.250);
    CreateDynamicObject(2908,2322.455,-1219.932,27.054,0.0,0.0,112.500);
    CreateDynamicObject(2905,2324.019,-1219.609,27.068,0.0,0.0,45.000);
    CreateDynamicObject(2905,2337.455,-1218.051,27.068,0.0,0.0,22.500);
    CreateDynamicObject(2905,2327.982,-1220.903,27.068,0.0,0.0,90.000);
    CreateDynamicObject(2905,2340.305,-1220.808,27.068,0.0,0.0,146.250);
    CreateDynamicObject(2905,2338.348,-1224.298,27.068,0.0,0.0,101.250);
    CreateDynamicObject(2905,2353.177,-1222.756,27.068,0.0,0.0,157.500);
    CreateDynamicObject(2905,2339.975,-1225.035,27.068,0.0,0.0,78.750);
    CreateDynamicObject(2906,2349.565,-1221.169,27.051,0.0,0.0,0.0);
    CreateDynamicObject(2906,2354.906,-1228.303,27.043,0.0,0.0,45.000);
    CreateDynamicObject(2906,2355.738,-1229.634,27.043,0.0,0.0,-78.750);
    CreateDynamicObject(2906,2344.905,-1228.761,27.051,0.0,0.0,22.500);
    CreateDynamicObject(2906,2347.393,-1225.939,27.051,0.0,0.0,-11.250);
    CreateDynamicObject(12957,2344.842,-1225.590,27.630,0.0,0.0,-45.000);
    CreateDynamicObject(3593,2333.669,-1220.978,28.612,-38.675,0.859,-180.000);
    CreateDynamicObject(3279,2295.071,-1222.194,22.760,0.0,0.0,0.0);
    CreateDynamicObject(3279,2338.660,-1241.633,34.715,0.0,0.0,-270.000);
    CreateDynamicObject(3279,2338.836,-1211.569,34.811,0.0,0.0,-450.000);
    CreateDynamicObject(8613,2337.287,-1228.774,30.573,0.0,0.0,-180.000);
    CreateDynamicObject(982,2350.163,-1224.316,34.160,-0.859,90.241,0.0);
    CreateDynamicObject(1468,2349.514,-1230.140,35.455,0.0,0.0,90.000);
    CreateDynamicObject(1468,2349.464,-1224.859,35.414,0.0,0.0,90.000);
    CreateDynamicObject(1468,2349.482,-1222.687,35.422,0.0,0.0,90.000);
    CreateDynamicObject(1468,2350.770,-1222.723,35.341,0.0,0.0,270.000);
    CreateDynamicObject(1468,2350.752,-1228.013,35.349,0.0,0.0,270.000);
    CreateDynamicObject(1468,2350.691,-1230.156,35.343,0.0,0.0,270.000);
    CreateDynamicObject(964,2336.844,-1211.886,50.839,0.0,0.0,90.000);
    CreateDynamicObject(964,2337.458,-1210.357,50.889,0.0,0.0,45.000);
    CreateDynamicObject(2061,2340.633,-1211.587,51.181,0.0,0.0,78.750);
    CreateDynamicObject(2061,2340.617,-1211.597,51.181,0.0,0.0,-11.250);
    CreateDynamicObject(2036,2336.905,-1211.896,51.838,0.0,0.0,45.000);
    CreateDynamicObject(2035,2337.157,-1210.534,51.879,0.0,0.0,-11.250);
    CreateDynamicObject(2035,2337.743,-1210.491,51.879,0.0,0.0,-112.500);
    CreateDynamicObject(2061,2340.601,-1212.193,51.181,0.0,0.0,0.0);
    CreateDynamicObject(2061,2340.354,-1212.917,51.181,0.0,0.0,56.250);
    CreateDynamicObject(2061,2340.911,-1210.905,51.181,0.0,0.0,-22.500);
    CreateDynamicObject(2061,2340.919,-1210.511,51.181,0.0,0.0,33.750);
    CreateDynamicObject(2061,2340.443,-1211.132,51.181,0.0,0.0,-11.250);
    CreateDynamicObject(2061,2340.655,-1210.986,51.181,0.0,0.0,56.250);

//Tablas de Idlewood por GROVE4L
    CreateDynamicObject(1219,2189.903,-1487.723,26.423,0.0,89.381,0.0);
    CreateDynamicObject(1219,2190.094,-1470.415,26.077,0.0,89.381,0.0);
    CreateDynamicObject(1219,2190.753,-1455.896,26.101,0.0,89.381,0.0);
    CreateDynamicObject(1219,2188.146,-1419.419,26.315,0.0,89.381,0.0);
    CreateDynamicObject(1219,2179.749,-1423.510,25.924,0.0,89.381,0.0);
    CreateDynamicObject(1219,2185.436,-1450.630,25.108,0.0,89.381,-84.766);
    CreateDynamicObject(1219,2156.820,-1470.083,25.847,0.0,89.381,-180.859);
    CreateDynamicObject(1219,2162.139,-1445.652,25.718,0.0,89.381,-0.859);
    CreateDynamicObject(1219,2161.207,-1399.969,25.658,0.0,89.381,-0.859);
    CreateDynamicObject(1219,2151.535,-1400.743,26.382,0.0,89.381,-0.859);
    CreateDynamicObject(1219,2151.274,-1419.075,25.956,0.0,89.381,179.141);
    CreateDynamicObject(1219,2150.308,-1433.832,26.186,-91.960,88.522,179.141);
    CreateDynamicObject(1219,2184.329,-1443.466,25.915,-91.960,88.522,179.141);
    CreateDynamicObject(1219,2186.191,-1404.806,25.754,-91.960,88.522,179.141);
    CreateDynamicObject(1219,2195.788,-1404.103,26.246,-91.960,88.522,179.141);
    CreateDynamicObject(1219,2193.702,-1442.891,26.233,-91.960,88.522,359.141);
    CreateDynamicObject(1219,2180.393,-1488.382,25.760,-91.960,88.522,359.141);
    CreateDynamicObject(1219,2180.596,-1471.391,25.645,-91.960,88.522,179.141);
    CreateDynamicObject(1219,2185.183,-1363.255,26.266,-91.960,88.522,269.141);
    CreateDynamicObject(1219,2202.721,-1363.146,26.251,-91.960,88.522,89.141);
    CreateDynamicObject(1219,2202.573,-1353.649,25.954,-91.960,88.522,89.141);
    CreateDynamicObject(1219,2184.417,-1353.683,25.858,0.0,89.381,89.141);
    CreateDynamicObject(1219,2199.354,-1363.146,26.533,0.0,89.381,269.141);
    CreateDynamicObject(1219,2132.682,-1361.236,26.381,0.0,89.381,269.141);
    CreateDynamicObject(1219,2155.510,-1438.979,25.794,0.0,89.381,269.141);
    CreateDynamicObject(1219,2160.945,-1418.020,25.822,-91.960,88.522,-0.859);
    CreateDynamicObject(1219,2206.041,-1363.321,26.592,-91.960,88.522,-90.859);
    CreateDynamicObject(1219,2126.234,-1361.161,26.476,-91.960,88.522,-90.859);
    CreateDynamicObject(1219,2147.769,-1365.694,26.201,-91.960,88.522,-90.859);
    CreateDynamicObject(1219,2129.347,-1351.740,25.945,-91.960,88.522,-90.859);
    CreateDynamicObject(1219,2146.964,-1356.198,25.830,-91.960,88.522,89.141);
    CreateDynamicObject(1219,2152.691,-1446.408,26.330,0.0,89.381,-0.859);
    CreateDynamicObject(1219,2147.223,-1470.385,26.273,0.0,89.381,179.141);
    CreateDynamicObject(1219,2149.363,-1485.064,26.846,-91.960,88.522,179.141);
    CreateDynamicObject(1219,2160.040,-1488.445,26.580,-91.960,88.522,88.281);
    CreateDynamicObject(1219,2230.753,-1407.040,24.149,0.0,89.381,-90.859);
    CreateDynamicObject(1219,2193.876,-1446.331,26.433,0.0,89.381,-179.923);
    CreateDynamicObject(1219,2193.876,-1439.833,25.858,0.0,89.381,0.077);
    CreateDynamicObject(1219,2256.726,-1407.115,24.006,0.0,89.381,-90.859);
    CreateDynamicObject(1219,2259.909,-1397.769,24.894,0.0,89.381,89.141);
    CreateDynamicObject(1219,2240.150,-1397.769,24.785,0.0,89.381,89.141);
    CreateDynamicObject(1219,2243.625,-1397.744,24.758,0.0,89.381,89.141);
    CreateDynamicObject(1219,2233.873,-1397.769,24.881,0.0,89.381,89.141);
    CreateDynamicObject(1219,2230.404,-1397.769,24.805,-91.960,88.522,89.141);
    CreateDynamicObject(1219,2227.324,-1397.743,24.667,-91.960,88.522,89.141);
    CreateDynamicObject(1219,2246.886,-1397.593,25.024,-91.960,88.522,89.141);
    CreateDynamicObject(1219,2253.365,-1397.593,24.998,-91.960,88.522,269.141);
    CreateDynamicObject(1219,2243.838,-1407.115,24.260,-91.960,88.522,89.141);
    CreateDynamicObject(1219,2263.688,-1459.438,24.065,-91.960,88.522,89.141);
    CreateDynamicObject(1219,2247.276,-1459.313,24.191,-91.960,88.522,89.141);
    CreateDynamicObject(1219,2232.354,-1459.413,24.338,0.0,89.381,89.141);
    CreateDynamicObject(1219,2229.261,-1468.860,24.848,0.0,89.381,89.141);
    CreateDynamicObject(1219,2244.350,-1468.910,24.974,0.0,89.381,-90.859);
    CreateDynamicObject(1219,2266.989,-1468.991,24.579,0.0,89.381,-90.859);
    CreateDynamicObject(1219,2260.498,-1468.910,24.605,0.0,89.381,-90.859);
    CreateDynamicObject(1219,2235.798,-1468.885,24.855,-91.960,88.522,-90.859);
    CreateDynamicObject(1219,2232.532,-1468.860,24.862,-91.960,88.522,86.562);
    CreateDynamicObject(1219,2250.796,-1468.985,24.914,-91.960,88.522,86.562);
    CreateDynamicObject(1219,2247.634,-1468.935,24.691,-91.960,88.522,266.562);
    CreateDynamicObject(1219,2264.008,-1468.985,24.650,-91.960,88.522,268.281);
    CreateDynamicObject(1219,2353.936,-1463.087,24.582,-91.960,88.522,179.141);
    CreateDynamicObject(1219,2353.985,-1465.561,24.497,-91.960,88.522,179.141);
    CreateDynamicObject(1219,2352.812,-1454.039,24.788,0.0,89.381,179.141);
    CreateDynamicObject(1219,2353.061,-1412.223,24.590,0.0,89.381,179.141);
    CreateDynamicObject(1219,2348.524,-1372.228,24.836,0.0,89.381,89.141);
    CreateDynamicObject(1219,2314.313,-1370.454,24.168,0.0,89.381,179.141);
    CreateDynamicObject(1219,2314.288,-1362.788,24.275,0.0,89.381,179.141);
    CreateDynamicObject(1219,2354.478,-1485.057,24.315,0.0,89.381,179.141);
    CreateDynamicObject(1219,2352.837,-1455.829,24.760,-91.960,88.522,179.141);
    CreateDynamicObject(1219,2354.963,-1511.215,24.484,-91.960,88.522,224.141);
    CreateDynamicObject(1219,2353.838,-1534.651,24.486,0.0,89.381,89.141);
    CreateDynamicObject(1219,2357.734,-1534.504,25.010,0.0,89.381,89.141);
    CreateDynamicObject(1219,2355.468,-1534.478,24.977,0.0,89.381,89.141);
    CreateDynamicObject(1219,2367.343,-1534.661,24.268,0.0,89.381,89.141);
    CreateDynamicObject(1219,2362.560,-1534.483,25.044,0.0,89.381,89.141);
    CreateDynamicObject(1219,2370.662,-1534.485,25.222,0.0,89.381,89.141);
    CreateDynamicObject(1219,2360.559,-1534.732,24.240,-91.960,88.522,89.141);
    CreateDynamicObject(1219,2364.287,-1534.509,24.959,-91.960,88.522,89.141);
    CreateDynamicObject(1219,2369.912,-1534.535,24.818,-91.960,88.522,89.141);
    CreateDynamicObject(1219,2389.267,-1549.458,24.486,-91.960,88.522,89.141);
    CreateDynamicObject(1219,2419.172,-1500.582,24.931,-91.960,88.522,-0.859);
    CreateDynamicObject(1219,2419.172,-1494.470,24.926,-91.960,88.522,-0.859);
    CreateDynamicObject(1219,2419.197,-1503.706,25.094,0.0,89.381,-0.859);
    CreateDynamicObject(1219,2419.172,-1497.572,25.147,0.0,89.381,-0.859);
    CreateDynamicObject(1219,2404.640,-1506.603,24.903,-91.960,88.522,-0.859);
    CreateDynamicObject(1219,2414.742,-1493.313,24.928,-91.960,88.522,89.141);
    CreateDynamicObject(1219,2417.674,-1493.313,24.968,-91.960,88.522,89.141);
    CreateDynamicObject(1219,2386.876,-1549.432,24.512,0.0,89.381,89.141);
    CreateDynamicObject(1219,2384.567,-1549.433,24.487,0.0,89.381,89.141);
    CreateDynamicObject(1219,2417.580,-1510.980,24.856,0.0,89.381,269.141);
    CreateDynamicObject(1681,2429.454,-1518.812,23.270,-27.502,0.0,33.750);
    CreateDynamicObject(1681,2428.511,-1513.373,21.666,39.534,0.0,11.250);
    CreateDynamicObject(1683,1810.050,-1771.234,41.844,42.972,20.626,112.500);
    CreateDynamicObject(3887,2380.557,-1474.157,30.700,0.0,0.0,90.000);
    CreateDynamicObject(6066,2418.927,-1505.411,25.493,0.0,0.0,0.0);
    CreateDynamicObject(1219,2452.173,-1490.600,23.994,0.0,89.381,269.141);
    CreateDynamicObject(1219,2454.147,-1490.600,24.602,0.0,89.381,269.141);
    CreateDynamicObject(1219,2456.592,-1493.393,25.194,0.0,89.381,269.141);
    CreateDynamicObject(1219,2481.311,-1493.871,24.128,0.0,89.381,269.141);
    CreateDynamicObject(1219,2501.818,-1494.046,24.432,0.0,89.381,269.141);
    CreateDynamicObject(1219,2508.926,-1492.788,24.307,0.0,89.381,269.141);
    CreateDynamicObject(1219,2529.651,-1492.686,24.628,0.0,89.381,269.141);
    CreateDynamicObject(1219,2480.101,-1536.778,23.988,0.0,89.381,181.719);
    CreateDynamicObject(1219,2441.376,-1517.339,24.361,0.0,89.381,181.719);
    CreateDynamicObject(1219,2441.138,-1536.719,24.188,-91.100,89.381,180.000);
    CreateDynamicObject(12957,2339.411,-1482.101,23.710,0.0,0.0,-56.250);
    CreateDynamicObject(12957,2391.676,-1527.336,23.706,0.0,0.0,-101.250);
    CreateDynamicObject(12957,2357.174,-1520.722,23.706,0.0,0.0,-45.000);
    CreateDynamicObject(12957,2433.759,-1528.807,23.711,0.0,0.0,-135.000);
    CreateDynamicObject(12957,2439.257,-1552.755,23.878,0.0,0.0,-303.750);
    CreateDynamicObject(3594,2385.243,-1448.088,23.636,0.0,0.0,-56.250);
    CreateDynamicObject(3594,2418.068,-1441.312,23.461,0.0,0.0,-157.500);
    CreateDynamicObject(3594,2437.771,-1441.027,23.459,0.0,0.0,-101.250);
    CreateDynamicObject(3594,2449.313,-1434.779,23.460,0.0,0.0,-168.750);
    CreateDynamicObject(3594,2430.828,-1457.542,23.461,0.0,0.0,-112.500);
    CreateDynamicObject(3594,2434.253,-1474.499,23.459,0.0,0.0,-146.250);
    CreateDynamicObject(3594,2448.705,-1504.860,23.459,0.0,0.0,-33.750);
    CreateDynamicObject(3594,2428.820,-1495.868,23.463,0.0,0.0,-112.500);
    CreateDynamicObject(3594,2431.889,-1556.724,23.459,0.0,0.0,-22.500);
    CreateDynamicObject(3594,2428.270,-1537.386,23.469,0.0,0.0,-123.750);
    CreateDynamicObject(3594,2397.950,-1517.032,23.467,0.0,0.0,-123.750);
    CreateDynamicObject(3594,2394.448,-1488.447,23.459,0.0,0.0,-225.000);
    CreateDynamicObject(3594,2364.295,-1529.310,23.459,0.0,0.0,-225.000);
    CreateDynamicObject(3594,2342.598,-1496.882,23.466,0.0,0.0,-303.750);
    CreateDynamicObject(3594,2343.577,-1543.082,23.466,0.0,0.0,-281.250);
    CreateDynamicObject(3594,2345.208,-1578.607,23.396,0.0,0.0,-337.500);
    CreateDynamicObject(3594,2342.042,-1525.153,23.474,0.0,0.0,-326.250);
    CreateDynamicObject(3594,2342.987,-1460.820,23.459,0.0,0.0,-326.250);
    CreateDynamicObject(3594,2321.487,-1384.863,23.492,0.0,0.0,-236.250);
    CreateDynamicObject(3594,2342.375,-1416.900,23.459,0.0,0.0,-315.000);
    CreateDynamicObject(3594,2363.943,-1382.756,23.479,0.0,0.0,-213.750);
    CreateDynamicObject(3594,2335.366,-1373.642,23.645,0.0,0.0,-146.250);
    CreateDynamicObject(3594,2392.220,-1433.499,23.465,0.0,0.0,-112.500);
    CreateDynamicObject(3594,2389.504,-1409.093,23.467,0.0,0.0,-112.500);
    CreateDynamicObject(3594,2368.353,-1349.551,23.467,0.0,0.0,-157.500);
    CreateDynamicObject(3594,2344.661,-1300.486,23.636,0.0,0.0,-101.250);
    CreateDynamicObject(12957,2440.201,-1500.793,23.697,0.0,0.0,-337.500);
    CreateDynamicObject(12957,2390.049,-1390.662,23.767,0.0,0.0,-258.750);
    CreateDynamicObject(12957,2341.794,-1399.662,23.691,0.0,0.0,-258.750);
    CreateDynamicObject(12957,2339.401,-1436.961,23.706,0.0,0.0,-191.250);
    CreateDynamicObject(12957,2344.755,-1550.449,23.713,0.0,0.0,-146.250);
    CreateDynamicObject(12957,2337.838,-1579.731,23.647,0.0,0.0,-123.750);
    CreateDynamicObject(12957,2331.840,-1565.819,23.624,0.0,0.0,-168.750);
    CreateDynamicObject(12957,2306.816,-1375.181,23.745,0.0,0.0,-168.750);
    CreateDynamicObject(12957,2258.297,-1384.628,23.712,0.0,0.0,-112.500);
    CreateDynamicObject(12957,2269.923,-1371.385,23.706,0.0,0.0,-146.250);
    CreateDynamicObject(12957,2300.878,-1259.813,23.496,0.0,0.0,-101.250);
    CreateDynamicObject(12957,2303.748,-1285.353,23.715,0.0,0.0,-157.500);
    CreateDynamicObject(12957,2372.037,-1331.658,23.713,0.0,0.0,-123.750);
    CreateDynamicObject(12957,2378.695,-1274.227,23.870,0.0,0.0,-247.500);
    CreateDynamicObject(12957,2290.860,-1481.738,22.819,0.0,0.0,-191.250);
    CreateDynamicObject(12957,2212.786,-1453.415,23.699,0.0,0.0,-236.250);
    CreateDynamicObject(12957,2210.564,-1402.937,23.701,0.0,0.0,-168.750);
    CreateDynamicObject(12957,2210.307,-1540.824,23.706,0.0,0.0,-168.750);
    CreateDynamicObject(12957,2210.905,-1494.326,23.697,0.0,0.0,-236.250);
    CreateDynamicObject(12957,2152.755,-1498.633,23.838,0.0,0.0,-236.250);
    CreateDynamicObject(12957,2091.412,-1462.499,23.654,0.0,0.0,-236.250);
    CreateDynamicObject(12957,2113.413,-1593.203,25.575,0.0,0.0,-236.250);
    CreateDynamicObject(12957,2113.478,-1528.296,23.741,0.0,0.0,-112.500);
    CreateDynamicObject(12957,2109.818,-1497.992,23.677,0.0,0.0,-337.500);
    CreateDynamicObject(12957,2111.653,-1416.807,23.706,0.0,0.0,-337.500);
    CreateDynamicObject(12957,2131.715,-1451.298,23.711,0.0,0.0,-303.750);
    CreateDynamicObject(12957,2170.073,-1380.209,23.706,0.0,0.0,-303.750);
    CreateDynamicObject(12957,2071.730,-1222.433,23.700,0.0,0.0,-236.250);
    CreateDynamicObject(12957,2172.795,-1235.295,23.699,0.0,0.0,-270.000);
    CreateDynamicObject(12957,2211.471,-1308.886,23.863,0.0,0.0,-315.000);
    CreateDynamicObject(12957,2251.120,-1296.911,23.711,0.0,0.0,-258.750);
    CreateDynamicObject(12957,2186.162,-1298.571,23.699,0.0,0.0,-202.500);
    CreateDynamicObject(12957,2072.344,-1297.101,23.699,0.0,0.0,-236.250);
    CreateDynamicObject(12957,2066.079,-1368.022,23.687,0.0,0.0,-213.750);
    CreateDynamicObject(12957,2052.172,-1341.237,23.699,0.0,0.0,-236.250);
    CreateDynamicObject(12957,2072.239,-1326.686,23.699,0.0,0.0,-213.750);
    CreateDynamicObject(12957,2066.847,-1269.623,23.699,0.0,0.0,-157.500);
    CreateDynamicObject(12957,2120.321,-1303.051,23.725,0.0,0.0,-123.750);
    CreateDynamicObject(12957,2169.470,-1265.789,23.699,0.0,0.0,-90.000);
    CreateDynamicObject(12957,2220.608,-1339.186,23.862,0.0,0.0,-112.500);
    CreateDynamicObject(12957,2186.978,-1343.416,23.863,0.0,0.0,-45.000);
    CreateDynamicObject(3594,2304.526,-1343.893,23.478,0.0,0.0,-315.000);
    CreateDynamicObject(3594,2304.630,-1299.921,23.459,0.0,0.0,-247.500);
    CreateDynamicObject(3594,2268.579,-1304.240,23.463,0.0,0.0,-315.000);
    CreateDynamicObject(3594,2272.339,-1346.075,23.459,0.0,0.0,-247.500);
    CreateDynamicObject(3594,2270.330,-1250.187,23.445,0.0,0.0,-270.000);
    CreateDynamicObject(3594,2243.558,-1218.315,23.444,0.0,0.0,-247.500);
    CreateDynamicObject(3594,2169.163,-1218.836,23.455,0.0,0.0,-281.250);
    CreateDynamicObject(3594,2174.265,-1252.594,23.451,0.0,0.0,-202.500);
    CreateDynamicObject(3594,2174.872,-1285.294,23.608,0.0,0.0,-258.750);
    CreateDynamicObject(3594,2172.074,-1339.799,23.616,0.0,0.0,-258.750);
    CreateDynamicObject(3594,2162.643,-1325.761,23.451,0.0,0.0,-326.250);
    CreateDynamicObject(3594,2252.327,-1376.828,23.611,0.0,0.0,-202.500);
    CreateDynamicObject(3594,2213.280,-1379.816,23.459,0.0,0.0,-236.250);
    CreateDynamicObject(3594,2212.636,-1470.226,23.459,0.0,0.0,-236.250);
    CreateDynamicObject(3594,2244.156,-1481.188,22.965,0.0,0.0,-168.750);
    CreateDynamicObject(3594,2214.111,-1556.810,23.346,0.0,0.0,-168.750);
    CreateDynamicObject(3594,2213.763,-1512.076,23.459,0.0,0.0,-135.000);
    CreateDynamicObject(3594,2212.860,-1425.338,23.459,0.0,0.0,-191.250);
    CreateDynamicObject(3594,2269.721,-1435.506,23.459,0.0,0.0,-191.250);
    CreateDynamicObject(3594,2243.671,-1449.720,23.459,0.0,0.0,-258.750);
    CreateDynamicObject(3594,2238.980,-1413.948,23.459,0.0,0.0,-213.750);
    CreateDynamicObject(3594,2109.762,-1429.187,23.459,0.0,0.0,-45.000);
    CreateDynamicObject(3594,2111.318,-1569.168,25.386,0.0,0.0,-45.000);
    CreateDynamicObject(3594,2114.164,-1506.258,23.406,0.0,0.0,-45.000);
    CreateDynamicObject(3594,2116.450,-1462.370,23.451,0.0,0.0,-78.750);
    CreateDynamicObject(3594,2129.794,-1487.363,23.439,0.0,0.0,-90.000);
    CreateDynamicObject(3594,2104.822,-1381.047,23.459,0.0,0.0,-90.000);
    CreateDynamicObject(3594,2073.531,-1381.890,23.451,0.0,0.0,-56.250);
    CreateDynamicObject(3594,2069.464,-1347.821,23.451,0.0,0.0,-112.500);
    CreateDynamicObject(3594,2066.460,-1240.236,23.445,0.0,0.0,-90.000);
    CreateDynamicObject(3594,2094.882,-1299.720,23.468,0.0,0.0,-157.500);
    CreateDynamicObject(3594,2138.640,-1298.806,23.459,0.0,0.0,-168.750);
    CreateDynamicObject(3593,2271.685,-1279.055,23.530,0.0,0.0,0.0);
    CreateDynamicObject(3593,2198.984,-1385.618,23.541,0.0,0.0,0.0);
    CreateDynamicObject(3593,2120.028,-1426.628,23.538,0.0,0.0,22.500);
    CreateDynamicObject(3593,2111.654,-1367.135,23.695,0.0,0.0,0.0);
    CreateDynamicObject(3593,2068.003,-1311.737,23.155,0.0,0.0,56.250);
    CreateDynamicObject(3593,2096.409,-1220.300,23.163,0.0,0.0,22.500);
    CreateDynamicObject(3593,2120.943,-1219.538,23.523,0.0,0.0,56.250);
    CreateDynamicObject(12957,2213.711,-1217.440,23.691,0.0,0.0,-360.000);
    CreateDynamicObject(3593,2303.190,-1212.269,23.204,0.0,0.0,56.250);
    CreateDynamicObject(910,2051.019,-1259.765,24.089,0.0,0.0,33.750);
    CreateDynamicObject(923,2068.344,-1285.169,23.700,0.0,0.0,0.0);
    CreateDynamicObject(960,2091.124,-1300.457,23.202,0.0,0.0,0.0);
    CreateDynamicObject(1219,2148.518,-1320.534,26.156,0.0,-89.381,-90.000);
    CreateDynamicObject(1219,2100.834,-1322.343,25.867,0.0,-89.381,-90.000);
    CreateDynamicObject(1219,2122.947,-1331.816,26.007,0.0,-89.381,0.0);
    CreateDynamicObject(1219,2090.980,-1277.359,25.987,0.0,-89.381,90.000);
    CreateDynamicObject(1219,2111.387,-1278.426,25.928,0.0,-89.381,90.000);
    CreateDynamicObject(1219,2150.259,-1284.516,24.545,0.0,-89.381,90.000);
    CreateDynamicObject(1219,2132.351,-1279.695,26.165,-86.803,-89.381,90.000);
    CreateDynamicObject(1219,2126.939,-1321.368,26.940,-86.803,-89.381,90.000);
    CreateDynamicObject(1219,2191.733,-1275.025,25.480,-86.803,-89.381,90.000);
    CreateDynamicObject(1219,2210.715,-1250.270,24.141,-86.803,-89.381,90.000);
    CreateDynamicObject(1219,2209.833,-1240.598,24.760,-86.803,-89.381,90.000);

//Entablados burger Playa por GROVE4L
    CreateDynamicObject(1219,654.921,-1713.944,14.828,0.0,-91.100,0.0);
    CreateDynamicObject(1219,658.229,-1652.604,15.202,0.0,-91.100,0.0);
    CreateDynamicObject(1219,656.274,-1635.232,15.725,0.0,-91.100,90.000);
    CreateDynamicObject(1219,797.678,-1577.106,13.747,0.0,-91.100,85.703);
    CreateDynamicObject(1219,795.531,-1577.004,13.219,0.0,-91.100,90.859);
    CreateDynamicObject(1219,793.103,-1576.949,13.385,96.257,0.0,0.0);
    CreateDynamicObject(1219,787.340,-1576.969,13.742,95.397,-1.719,0.0);
    CreateDynamicObject(1219,790.949,-1576.734,13.416,0.0,87.663,-90.859);
    CreateDynamicObject(1219,784.725,-1576.742,13.430,0.0,87.663,-94.297);
    CreateDynamicObject(1219,760.679,-1564.854,14.310,0.0,87.663,-4.297);
    CreateDynamicObject(1219,761.061,-1562.496,14.410,0.0,87.663,-4.297);
    CreateDynamicObject(1219,935.199,-1451.782,13.669,0.0,87.663,180.000);
    CreateDynamicObject(1219,935.174,-1443.106,13.650,0.0,87.663,180.000);
    CreateDynamicObject(1219,929.869,-1475.378,13.793,0.0,87.663,180.000);
    CreateDynamicObject(1219,963.224,-1501.551,14.106,0.0,87.663,90.000);
    CreateDynamicObject(1219,960.461,-1501.551,14.327,0.0,87.663,90.000);
    CreateDynamicObject(1219,966.490,-1501.600,13.892,0.0,87.663,90.000);
    CreateDynamicObject(1219,969.759,-1501.490,14.110,-91.960,87.663,90.000);
    CreateDynamicObject(1219,972.465,-1501.500,14.050,-269.004,87.663,91.719);
    CreateDynamicObject(1219,985.211,-1501.575,13.906,-269.004,87.663,91.719);
    CreateDynamicObject(1219,1025.614,-1478.855,14.334,-269.004,87.663,271.719);
    CreateDynamicObject(1219,1028.149,-1478.854,14.475,-455.501,91.100,271.719);
    CreateDynamicObject(1219,1014.293,-1505.386,14.201,-452.063,91.100,1.719);
    CreateDynamicObject(1219,1014.268,-1502.797,14.260,-452.063,91.100,1.719);
    CreateDynamicObject(1219,1014.368,-1524.481,14.276,-452.063,91.100,1.719);
    CreateDynamicObject(1219,1014.318,-1531.412,14.095,-452.063,91.100,1.719);
    CreateDynamicObject(1219,1014.368,-1527.767,14.154,-452.063,91.100,1.719);
    CreateDynamicObject(1219,804.089,-1577.592,13.691,0.0,90.241,-111.641);
    CreateDynamicObject(1219,806.314,-1578.624,13.558,0.0,90.241,-111.641);
    CreateDynamicObject(1219,809.785,-1579.720,13.478,0.0,90.241,-111.641);
    CreateDynamicObject(1219,836.161,-1596.845,13.790,0.0,90.241,-130.703);
    CreateDynamicObject(1219,834.293,-1595.114,13.640,0.0,90.241,-130.703);
    CreateDynamicObject(1219,975.813,-1501.625,14.164,0.0,90.241,88.281);
    CreateDynamicObject(1219,972.615,-1479.029,14.175,0.0,90.241,-90.859);
    CreateDynamicObject(1219,975.499,-1478.979,14.169,0.0,90.241,-90.859);
    CreateDynamicObject(1219,995.063,-1479.003,13.943,0.0,90.241,-90.859);
    CreateDynamicObject(1219,991.538,-1479.029,14.109,0.0,90.241,-90.859);
    CreateDynamicObject(1219,978.888,-1501.325,14.160,0.0,90.241,-270.859);
    CreateDynamicObject(1219,981.858,-1501.401,14.311,0.0,90.241,89.140);
    CreateDynamicObject(1219,1000.571,-1501.526,14.067,0.0,90.241,89.140);
    CreateDynamicObject(1219,998.075,-1501.400,14.146,0.0,90.241,89.140);
    CreateDynamicObject(1219,991.324,-1501.505,14.133,0.0,90.241,89.140);
    CreateDynamicObject(1219,1007.115,-1501.390,14.133,0.0,90.241,89.140);
    CreateDynamicObject(1219,1014.491,-1508.800,14.173,0.0,90.241,-0.859);
    CreateDynamicObject(1219,1014.318,-1522.086,14.304,0.0,90.241,-0.859);
    CreateDynamicObject(1219,1014.318,-1534.008,14.084,0.0,90.241,-0.859);
    CreateDynamicObject(1219,1014.418,-1537.424,13.892,0.0,90.241,-0.859);
    CreateDynamicObject(1219,1014.543,-1512.010,14.123,0.0,90.241,-0.859);
    CreateDynamicObject(1219,1014.393,-1514.544,14.080,-452.063,91.100,1.719);
    CreateDynamicObject(1219,967.792,-1478.955,14.352,-452.063,91.100,-88.281);
    CreateDynamicObject(1219,1011.119,-1479.004,14.038,-452.063,91.100,-88.281);
    CreateDynamicObject(1219,1034.396,-1478.929,13.815,-452.063,91.100,-88.281);
    CreateDynamicObject(1219,1030.801,-1478.879,14.155,-452.063,91.100,-88.281);
    CreateDynamicObject(1219,1017.422,-1478.904,14.302,-452.063,91.100,-88.281);
    CreateDynamicObject(1219,979.370,-1478.829,14.536,-452.063,91.100,-88.281);
    CreateDynamicObject(1219,989.094,-1478.904,14.350,-452.063,91.100,-88.281);
    CreateDynamicObject(1219,997.646,-1478.954,14.284,-452.063,91.100,-88.281);
    CreateDynamicObject(1219,1000.089,-1478.905,14.170,-631.685,91.100,-88.281);
    CreateDynamicObject(1219,970.156,-1478.989,14.277,0.0,90.241,-90.859);
    CreateDynamicObject(1219,977.990,-1478.829,14.419,0.0,90.241,-90.859);
    CreateDynamicObject(1219,981.636,-1478.829,14.226,0.0,90.241,-90.859);
    CreateDynamicObject(1219,986.604,-1478.855,14.452,0.0,90.241,-90.859);
    CreateDynamicObject(1219,1008.484,-1478.954,14.282,0.0,90.241,-90.859);
    CreateDynamicObject(1219,1006.151,-1478.938,14.060,0.0,90.241,-90.859);
    CreateDynamicObject(1219,1019.709,-1478.904,14.301,0.0,90.241,-90.859);
    CreateDynamicObject(1219,1036.703,-1478.854,14.040,0.0,90.241,-90.859);
    CreateDynamicObject(1219,1038.659,-1478.954,14.505,0.0,90.241,-90.859);
    CreateDynamicObject(1219,1013.187,-1501.439,14.086,-452.063,91.100,-88.281);
    CreateDynamicObject(1219,1009.822,-1501.501,14.122,-452.063,91.100,91.719);
    CreateDynamicObject(1219,1003.913,-1501.450,14.084,-452.063,91.100,91.719);
    CreateDynamicObject(1219,994.508,-1501.475,14.205,-452.063,91.100,91.719);
    CreateDynamicObject(1219,988.652,-1501.600,14.181,-452.063,91.100,271.719);
    CreateDynamicObject(1219,1014.810,-1478.979,14.173,0.0,90.241,-90.859);
    CreateDynamicObject(1219,1014.668,-1518.067,14.160,0.0,90.241,-0.859);
    CreateDynamicObject(1219,970.078,-1519.406,13.870,0.0,90.241,-90.859);
    CreateDynamicObject(1219,1014.925,-1559.764,14.449,0.0,90.241,-0.859);
    CreateDynamicObject(1219,1014.925,-1555.946,14.628,0.0,90.241,-0.859);
    CreateDynamicObject(1219,1014.925,-1555.982,17.193,0.0,90.241,-0.859);
    CreateDynamicObject(1219,1014.925,-1559.809,17.027,0.0,90.241,-0.859);
    CreateDynamicObject(1219,1014.925,-1557.784,14.860,0.0,90.241,-0.859);
    CreateDynamicObject(1219,1014.925,-1557.966,17.065,0.0,90.241,-0.859);
    CreateDynamicObject(1219,1014.925,-1551.385,15.251,0.0,90.241,-0.859);
    CreateDynamicObject(1219,1014.925,-1551.397,17.791,0.0,90.241,-0.859);
    CreateDynamicObject(1219,1014.925,-1547.576,17.574,0.0,90.241,-0.859);
    CreateDynamicObject(1219,1014.925,-1547.332,15.036,-452.063,91.100,1.719);
    CreateDynamicObject(1219,1014.925,-1549.413,15.074,-452.063,91.100,1.719);
    CreateDynamicObject(1219,1014.925,-1549.524,17.501,-452.063,91.100,1.719);
    CreateDynamicObject(1219,1050.494,-1584.020,14.304,-452.063,91.100,136.719);
    CreateDynamicObject(1219,1048.886,-1585.711,14.227,-452.063,91.100,136.719);
    CreateDynamicObject(1219,1054.246,-1582.752,13.707,0.0,90.241,89.140);
    CreateDynamicObject(1219,1059.759,-1582.661,14.449,0.0,90.241,89.140);
    CreateDynamicObject(1219,1067.137,-1582.799,14.477,0.0,90.241,89.140);
    CreateDynamicObject(1219,1070.589,-1582.854,14.463,0.0,90.241,89.140);
    CreateDynamicObject(1219,1080.106,-1582.839,13.624,0.0,90.241,89.140);
    CreateDynamicObject(1219,1082.540,-1582.841,14.379,0.0,90.241,89.140);
    CreateDynamicObject(1219,1102.207,-1582.839,14.254,0.0,90.241,89.140);
    CreateDynamicObject(1219,1130.362,-1582.758,14.105,0.0,90.241,89.140);
    CreateDynamicObject(1219,1127.852,-1582.787,13.698,0.0,90.241,89.140);
    CreateDynamicObject(1219,1119.833,-1582.722,14.209,0.0,90.241,89.140);
    CreateDynamicObject(1219,1063.368,-1582.818,14.308,-452.063,91.100,91.719);
    CreateDynamicObject(1219,1061.327,-1582.806,13.710,-452.063,91.100,91.719);
    CreateDynamicObject(1219,1074.307,-1582.886,13.849,-452.063,91.100,91.719);
    CreateDynamicObject(1219,1085.250,-1582.816,13.743,-452.063,91.100,91.719);
    CreateDynamicObject(1219,1099.738,-1582.793,13.823,-452.063,91.100,91.719);
    CreateDynamicObject(1219,1097.354,-1582.779,13.597,-452.063,91.100,91.719);
    CreateDynamicObject(1219,1094.692,-1582.809,13.610,-452.063,91.100,91.719);
    CreateDynamicObject(1219,1091.509,-1582.870,14.159,-452.063,91.100,91.719);
    CreateDynamicObject(1219,1089.235,-1582.879,13.685,-452.063,91.100,91.719);
    CreateDynamicObject(1219,1117.340,-1582.694,13.472,-452.063,91.100,91.719);
    CreateDynamicObject(1219,1125.468,-1582.778,13.537,-452.063,91.100,91.719);
    CreateDynamicObject(1219,1123.019,-1582.783,13.755,-452.063,91.100,91.719);
    CreateDynamicObject(1219,1134.995,-1582.561,14.070,-452.063,91.100,91.719);
    CreateDynamicObject(1219,1113.671,-1582.752,13.619,0.0,87.663,90.000);
    CreateDynamicObject(1219,1111.168,-1582.728,13.487,-452.063,91.100,86.485);
    CreateDynamicObject(1219,1108.438,-1582.757,13.663,0.0,87.663,90.000);
    CreateDynamicObject(1219,1204.704,-1582.741,14.792,0.0,87.663,90.000);
    CreateDynamicObject(1219,849.841,-1586.405,13.450,0.0,87.663,-45.000);
    CreateDynamicObject(1219,841.442,-1594.665,14.111,0.0,87.663,-45.000);
    CreateDynamicObject(1219,845.354,-1591.046,13.982,0.0,87.663,-45.000);
    CreateDynamicObject(1219,852.311,-1584.011,13.927,0.0,87.663,-45.000);
    CreateDynamicObject(1219,863.939,-1572.429,14.234,0.0,87.663,-45.000);
    CreateDynamicObject(1219,873.234,-1564.907,13.809,-91.960,0.0,202.500);
    CreateDynamicObject(1219,875.662,-1563.965,13.937,-91.960,0.0,202.500);
    CreateDynamicObject(1219,877.873,-1563.039,14.188,-91.960,0.0,202.500);
    CreateDynamicObject(1219,854.202,-1582.120,14.075,-91.960,0.0,225.000);
    CreateDynamicObject(1219,847.207,-1589.310,13.882,-88.522,1.719,225.859);
    CreateDynamicObject(1219,839.068,-1596.870,14.053,-88.522,1.719,225.859);
    CreateDynamicObject(1219,1199.448,-1582.766,14.518,0.0,87.663,90.000);
    CreateDynamicObject(1219,1196.977,-1582.690,14.524,0.0,87.663,90.000);
    CreateDynamicObject(1219,1217.247,-1585.213,13.856,0.0,87.663,90.000);
    CreateDynamicObject(1219,1231.034,-1582.647,14.359,0.0,87.663,90.000);
    CreateDynamicObject(1219,1224.459,-1582.619,14.441,0.0,87.663,90.000);
    CreateDynamicObject(1219,1286.003,-1588.179,14.366,0.0,87.663,45.000);
    CreateDynamicObject(1219,1284.261,-1586.427,14.215,0.0,87.663,45.000);
    CreateDynamicObject(1219,1279.169,-1582.634,14.557,0.0,87.663,90.000);
    CreateDynamicObject(1219,1273.940,-1582.600,14.470,0.0,87.663,90.000);
    CreateDynamicObject(1219,1261.655,-1583.299,14.441,0.0,87.663,123.750);
    CreateDynamicObject(1219,1259.818,-1584.569,14.613,0.0,87.663,123.750);
    CreateDynamicObject(1219,1254.916,-1584.506,14.453,0.0,87.663,56.250);
    CreateDynamicObject(1219,1265.296,-1582.614,14.512,0.0,87.663,90.000);
    CreateDynamicObject(1219,1246.124,-1582.710,14.467,0.0,87.663,90.000);
    CreateDynamicObject(1219,1240.185,-1584.567,14.396,0.0,87.663,123.750);
    CreateDynamicObject(1219,1233.539,-1583.397,14.308,0.0,87.663,56.250);
    CreateDynamicObject(1219,1226.810,-1582.633,14.398,-452.063,91.100,91.719);
    CreateDynamicObject(1219,1229.012,-1582.681,14.553,-452.063,91.100,91.719);
    CreateDynamicObject(1219,1237.880,-1585.162,13.580,-452.063,91.100,91.719);
    CreateDynamicObject(1219,1241.984,-1583.482,14.130,-452.063,91.100,127.188);
    CreateDynamicObject(1219,1253.003,-1583.349,14.443,-452.063,91.100,59.688);
    CreateDynamicObject(1219,1282.352,-1584.505,14.375,-452.063,91.100,51.094);
    CreateDynamicObject(1219,1281.233,-1583.423,14.336,-452.063,91.100,45.078);
    CreateDynamicObject(1219,1276.737,-1582.633,14.320,-452.063,91.100,90.078);
    CreateDynamicObject(1219,1271.442,-1582.693,14.388,-452.063,91.100,90.078);
    CreateDynamicObject(1219,1268.796,-1582.610,14.483,-452.063,91.100,90.078);
    CreateDynamicObject(1219,1264.030,-1582.591,14.164,-452.063,91.100,90.078);
    CreateDynamicObject(1219,1257.682,-1585.188,13.764,-452.063,91.100,90.078);
    CreateDynamicObject(1219,1250.352,-1582.720,14.521,-452.063,91.100,90.937);
    CreateDynamicObject(1219,1248.708,-1582.736,14.267,-452.063,91.100,90.937);
    CreateDynamicObject(1219,1244.069,-1582.718,14.397,-452.063,91.100,90.937);
    CreateDynamicObject(1219,1235.526,-1584.658,14.427,-452.063,91.100,62.344);
    CreateDynamicObject(1219,1221.844,-1583.499,14.560,-452.063,91.100,122.031);
    CreateDynamicObject(1219,1219.906,-1584.601,14.504,-452.063,91.100,122.031);
    CreateDynamicObject(1219,1212.307,-1583.366,14.350,-452.063,91.100,65.781);
    CreateDynamicObject(1219,1214.461,-1584.593,14.464,0.859,91.960,58.828);
    CreateDynamicObject(1219,1209.376,-1582.658,14.552,0.859,91.960,92.578);
    CreateDynamicObject(1219,1202.308,-1582.716,14.628,-452.063,91.100,91.719);
    CreateDynamicObject(1219,1206.943,-1582.741,14.066,-452.063,91.100,91.719);
    CreateDynamicObject(1219,1194.550,-1582.666,14.019,-452.063,91.100,91.719);
    CreateDynamicObject(1219,1192.063,-1582.690,14.337,-452.063,91.100,91.719);
    CreateDynamicObject(1219,1182.647,-1585.138,13.308,-452.063,91.100,91.719);
    CreateDynamicObject(1219,1187.921,-1583.502,14.398,-452.063,91.100,125.469);
    CreateDynamicObject(1219,1174.949,-1582.619,14.418,-452.063,91.100,91.719);
    CreateDynamicObject(1219,1180.275,-1584.552,14.405,-452.063,91.100,57.969);
    CreateDynamicObject(1219,1185.901,-1584.672,14.502,0.859,91.960,119.376);
    CreateDynamicObject(1219,1178.168,-1583.459,14.541,0.859,91.960,61.407);
    CreateDynamicObject(1219,1172.638,-1582.663,14.553,0.859,91.960,90.000);

//Base Groove por GROVE4L
    CreateDynamicObject(3578,2439.915,-1668.217,13.241,0.0,0.0,90.000);
    CreateDynamicObject(3578,2439.905,-1653.678,13.124,0.0,0.0,270.000);
    CreateDynamicObject(3578,2424.185,-1648.708,13.316,0.0,0.0,90.000);
    CreateDynamicObject(3578,2423.845,-1664.110,13.161,0.0,0.0,270.000);
    CreateDynamicObject(2060,2440.525,-1658.259,12.532,0.0,0.0,90.000);
    CreateDynamicObject(2060,2440.503,-1658.243,12.848,0.0,0.0,90.000);
    CreateDynamicObject(2060,2440.382,-1658.081,13.163,0.0,0.0,90.000);
    CreateDynamicObject(2060,2440.492,-1657.659,12.626,0.0,0.0,90.000);
    CreateDynamicObject(2060,2440.372,-1657.633,12.960,0.0,0.0,90.000);
    CreateDynamicObject(2060,2440.452,-1657.000,12.741,0.0,0.0,90.000);
    CreateDynamicObject(2060,2440.535,-1657.168,12.508,0.0,0.0,90.000);
    CreateDynamicObject(2060,2440.569,-1656.177,12.488,0.0,0.0,90.000);
    CreateDynamicObject(2060,2440.531,-1655.154,12.489,0.0,0.0,90.000);
    CreateDynamicObject(2060,2440.535,-1654.184,12.487,0.0,0.0,90.000);
    CreateDynamicObject(2060,2440.306,-1657.034,13.147,0.0,0.0,90.000);
    CreateDynamicObject(2060,2440.397,-1656.398,12.894,0.0,0.0,90.000);
    CreateDynamicObject(2060,2440.508,-1655.787,12.703,0.0,0.0,90.000);
    CreateDynamicObject(2060,2440.352,-1654.868,12.805,0.0,0.0,90.000);
    CreateDynamicObject(2060,2440.353,-1655.550,13.012,0.0,0.0,90.000);
    CreateDynamicObject(2060,2440.246,-1656.226,13.154,0.0,0.0,90.000);
    CreateDynamicObject(2060,2440.601,-1663.543,12.488,0.0,0.0,90.000);
    CreateDynamicObject(2060,2440.438,-1663.524,12.909,0.0,0.0,90.000);
    CreateDynamicObject(2060,2440.572,-1663.986,12.803,0.0,0.0,90.000);
    CreateDynamicObject(2060,2440.652,-1664.620,12.652,0.0,0.0,90.000);
    CreateDynamicObject(2060,2440.693,-1665.664,12.655,0.0,0.0,90.000);
    CreateDynamicObject(2060,2440.774,-1666.721,12.657,0.0,0.0,90.000);
    CreateDynamicObject(2060,2440.408,-1666.287,12.981,0.0,0.0,90.000);
    CreateDynamicObject(2060,2440.411,-1664.919,12.979,0.0,0.0,90.000);
    CreateDynamicObject(2060,2440.347,-1664.185,13.059,0.0,0.0,90.000);
    CreateDynamicObject(2060,2440.278,-1665.173,13.221,0.0,0.0,90.000);
    CreateDynamicObject(2060,2440.242,-1664.209,13.321,0.0,0.0,90.000);
    CreateDynamicObject(2060,2440.288,-1665.907,13.215,0.0,0.0,90.000);
    CreateDynamicObject(2060,2440.397,-1665.618,13.013,0.0,0.0,90.000);
    CreateDynamicObject(2060,2440.591,-1666.156,12.810,0.0,0.0,90.000);
    CreateDynamicObject(2060,2440.563,-1665.088,12.775,0.0,0.0,90.000);
    CreateDynamicObject(2060,2440.525,-1665.113,13.445,0.0,0.0,90.000);
    CreateDynamicObject(2060,2440.224,-1663.509,13.225,0.0,20.626,90.000);
    CreateDynamicObject(2060,2440.172,-1663.853,13.587,0.0,17.189,90.000);
    CreateDynamicObject(2060,2440.230,-1664.466,13.549,-0.859,9.454,90.000);
    CreateDynamicObject(2060,2440.253,-1657.532,13.379,0.0,0.0,90.000);
    CreateDynamicObject(853,2481.402,-1678.101,12.691,0.0,0.0,67.500);
    CreateDynamicObject(852,2483.633,-1690.704,12.480,0.0,0.0,-90.000);
    CreateDynamicObject(852,2480.871,-1702.815,12.494,0.0,0.0,0.0);
    CreateDynamicObject(850,2479.644,-1712.336,12.652,0.0,0.0,45.000);
    CreateDynamicObject(850,2482.183,-1708.184,12.646,0.0,0.0,-11.250);
    CreateDynamicObject(911,2478.368,-1714.194,13.108,0.0,0.0,90.000);
    CreateDynamicObject(910,2482.485,-1714.298,13.811,-32.659,-0.859,-90.000);
    CreateDynamicObject(912,2478.976,-1717.073,12.911,-90.241,0.0,157.500);
    CreateDynamicObject(912,2479.657,-1706.148,13.051,-90.241,0.0,236.250);
    CreateDynamicObject(922,2478.109,-1663.848,13.218,0.0,0.0,22.500);
    CreateDynamicObject(923,2475.639,-1674.962,13.217,0.0,0.0,-33.750);
    CreateDynamicObject(923,2496.226,-1669.088,13.216,0.0,0.0,56.250);
    CreateDynamicObject(923,2494.584,-1677.783,13.218,0.0,0.0,-22.500);
    CreateDynamicObject(960,2485.101,-1671.431,12.718,0.0,0.0,22.500);
    CreateDynamicObject(960,2481.540,-1673.786,12.722,0.0,0.0,0.0);
    CreateDynamicObject(1219,2465.484,-1691.196,14.275,-360.963,90.241,91.642);
    CreateDynamicObject(1219,2467.788,-1691.798,14.415,-360.963,90.241,65.858);
    CreateDynamicObject(1219,2463.537,-1691.630,14.702,-360.963,90.241,110.858);
    CreateDynamicObject(1219,2514.757,-1691.959,13.803,-360.963,90.241,322.812);
    CreateDynamicObject(1219,2518.015,-1688.248,14.115,-360.104,90.241,138.515);
    CreateDynamicObject(1219,2489.298,-1644.108,14.916,-360.104,90.241,269.140);
    CreateDynamicObject(1219,2482.485,-1645.332,18.718,0.0,-90.241,92.578);
    CreateDynamicObject(1219,2486.748,-1643.958,18.718,0.0,-90.241,92.578);
    CreateDynamicObject(1219,2489.450,-1643.932,18.724,19.767,-90.241,92.578);
    CreateDynamicObject(1219,2482.119,-1648.826,14.597,0.859,-89.381,92.578);
    CreateDynamicObject(1219,2480.793,-1648.357,14.463,0.859,-89.381,63.126);
    CreateDynamicObject(1219,2483.815,-1648.294,14.601,0.859,-89.381,118.516);
    CreateDynamicObject(1219,2448.780,-1640.734,14.456,0.859,-89.381,89.141);
    CreateDynamicObject(1219,2454.275,-1640.734,14.388,-178.763,-88.522,89.141);
    CreateDynamicObject(1219,2495.870,-1641.602,14.288,0.859,-89.381,90.000);
    CreateDynamicObject(1219,2501.433,-1641.477,14.552,0.859,-89.381,90.000);
    CreateDynamicObject(1219,2490.934,-1640.762,18.546,0.859,-89.381,180.859);
    CreateDynamicObject(1219,2490.958,-1632.613,18.626,0.859,-89.381,180.859);
    CreateDynamicObject(1219,2497.717,-1632.386,13.602,1.719,-88.522,270.000);
    CreateDynamicObject(1219,2524.984,-1641.554,14.322,1.719,-88.522,225.000);
    CreateDynamicObject(1219,2520.779,-1637.350,14.658,1.719,-88.522,225.000);
    CreateDynamicObject(1219,2525.332,-1655.916,15.939,1.719,-88.522,0.0);
    CreateDynamicObject(1219,2523.699,-1702.294,14.215,1.719,-88.522,-222.422);
    CreateDynamicObject(1219,2527.887,-1697.411,13.751,1.719,-90.241,-218.984);
    CreateDynamicObject(1227,2479.748,-1699.216,13.379,-220.875,0.0,-276.471);
    CreateDynamicObject(1299,2481.279,-1692.507,12.976,0.0,0.0,22.500);
    CreateDynamicObject(1299,2490.499,-1659.822,12.792,0.0,0.0,90.000);
    CreateDynamicObject(1429,2496.155,-1669.116,14.286,0.0,0.0,71.015);
    CreateDynamicObject(2672,2476.654,-1678.253,12.618,0.0,0.0,0.0);
    CreateDynamicObject(2672,2463.828,-1657.543,12.588,0.0,0.0,-78.750);
    CreateDynamicObject(2672,2490.499,-1669.007,12.615,0.0,0.0,-33.750);
    CreateDynamicObject(2672,2483.292,-1659.810,12.615,0.0,0.0,0.0);
    CreateDynamicObject(2672,2499.025,-1678.163,12.639,0.0,0.0,-45.000);
    CreateDynamicObject(2672,2502.343,-1665.390,12.640,0.0,0.0,45.000);
    CreateDynamicObject(2674,2488.149,-1679.297,12.358,0.0,0.0,0.0);
    CreateDynamicObject(2674,2478.845,-1666.606,12.353,0.0,0.0,45.000);
    CreateDynamicObject(2674,2498.141,-1660.066,12.371,0.0,0.0,11.250);
    CreateDynamicObject(3594,2421.129,-1661.772,13.014,-18.908,0.0,97.967);
    CreateDynamicObject(3594,2428.716,-1642.328,13.068,0.0,0.0,-22.500);
    CreateDynamicObject(3594,2457.742,-1668.411,13.112,0.0,0.0,-22.500);
    CreateDynamicObject(3594,2485.438,-1727.092,13.178,0.0,0.0,-146.250);
    CreateDynamicObject(3594,2471.895,-1734.016,13.014,0.0,0.0,-22.500);
    CreateDynamicObject(3593,2482.701,-1743.205,13.007,0.0,0.0,56.250);
    CreateDynamicObject(3593,2493.826,-1732.365,12.843,0.0,0.0,146.250);
    CreateDynamicObject(3593,2444.637,-1732.293,13.026,0.0,0.0,123.750);
    CreateDynamicObject(3593,2493.328,-1663.721,12.696,0.0,0.0,90.000);
    CreateDynamicObject(3593,2506.391,-1671.243,12.708,0.0,0.0,123.750);
    CreateDynamicObject(12957,2534.457,-1707.685,13.025,0.0,0.0,33.750);
    CreateDynamicObject(12957,2505.761,-1682.079,13.200,0.0,0.0,33.750);
    CreateDynamicObject(12957,2481.774,-1683.559,13.007,0.0,0.0,-56.250);
    CreateDynamicObject(12957,2437.198,-1678.861,13.633,0.0,0.0,22.500);
    CreateDynamicObject(3594,2432.589,-1671.101,13.212,0.0,0.0,-101.250);
    CreateDynamicObject(923,2428.160,-1676.780,13.589,0.0,0.0,135.000);
    CreateDynamicObject(922,2467.787,-1656.156,13.167,0.0,0.0,-90.000);
    CreateDynamicObject(960,2457.398,-1660.453,12.686,0.0,0.0,45.000);
    CreateDynamicObject(2905,2499.047,-1668.961,12.390,0.0,0.0,22.500);
    CreateDynamicObject(2905,2498.177,-1672.737,12.434,0.0,0.0,90.000);
    CreateDynamicObject(2905,2503.327,-1674.336,12.452,0.0,0.0,112.500);
    CreateDynamicObject(2906,2502.623,-1670.001,12.359,0.0,0.0,0.0);
    CreateDynamicObject(2906,2500.363,-1673.291,12.424,0.0,0.0,45.000);
    CreateDynamicObject(2906,2500.469,-1676.245,12.437,0.0,0.0,112.500);
    CreateDynamicObject(2907,2501.837,-1674.714,12.515,0.0,0.0,11.250);
    CreateDynamicObject(2907,2513.046,-1649.783,13.516,0.0,0.0,90.000);
    CreateDynamicObject(2907,2522.832,-1657.979,14.404,-176.185,0.0,157.500);
    CreateDynamicObject(2907,2523.719,-1660.161,14.479,-176.185,0.0,101.250);
    CreateDynamicObject(2907,2503.986,-1670.672,12.375,-176.185,0.0,180.000);
    CreateDynamicObject(2907,2495.536,-1673.138,12.496,0.0,0.0,-67.500);
    CreateDynamicObject(2908,2501.727,-1672.916,12.432,0.0,0.0,0.0);
    CreateDynamicObject(2908,2497.023,-1674.997,12.417,0.0,0.0,-45.000);
    CreateDynamicObject(2908,2510.793,-1652.245,12.887,0.0,0.0,33.750);
    CreateDynamicObject(2908,2523.125,-1661.322,14.571,0.0,0.0,33.750);
    CreateDynamicObject(2908,2501.308,-1670.250,12.433,0.0,0.0,78.750);
    CreateDynamicObject(2908,2499.549,-1663.563,12.427,0.0,0.0,146.250);
    CreateDynamicObject(2908,2490.158,-1670.796,12.413,0.0,0.0,146.250);
    CreateDynamicObject(2035,2500.067,-1672.909,12.374,0.0,0.0,56.250);
    CreateDynamicObject(2036,2503.035,-1668.935,12.397,0.0,0.0,123.750);
    CreateDynamicObject(2044,2499.950,-1676.454,12.383,0.0,0.0,56.250);
    CreateDynamicObject(2906,2505.513,-1677.051,12.451,0.0,0.0,213.750);
    CreateDynamicObject(2906,2494.551,-1666.409,12.418,0.0,0.0,225.000);
    CreateDynamicObject(2906,2503.596,-1652.627,12.634,0.0,0.0,146.250);
    CreateDynamicObject(2044,2503.465,-1652.974,12.675,73.052,0.0,78.750);
    CreateDynamicObject(2034,2494.828,-1666.584,12.444,94.538,4.297,-34.842);
    CreateDynamicObject(2045,2504.993,-1676.845,12.468,0.0,0.0,45.000);
    CreateDynamicObject(2035,2506.224,-1677.448,12.405,0.0,0.0,33.750);
    CreateDynamicObject(1293,2493.819,-1684.769,13.095,0.0,0.0,0.0);
    CreateDynamicObject(911,2485.634,-1645.148,13.644,0.0,0.0,90.000);
    CreateDynamicObject(911,2487.741,-1645.621,13.637,0.0,0.0,225.000);
    CreateDynamicObject(912,2486.457,-1646.454,13.637,-39.534,0.0,0.0);
    CreateDynamicObject(912,2496.624,-1643.655,13.349,0.0,0.0,78.750);
    CreateDynamicObject(913,2499.701,-1642.475,13.614,0.0,0.0,0.0);
    CreateDynamicObject(912,2499.557,-1644.385,13.349,0.0,0.0,-33.750);
    CreateDynamicObject(911,2514.673,-1650.882,13.864,-89.381,0.0,225.000);
    CreateDynamicObject(912,2524.404,-1657.419,15.060,0.0,0.0,-22.500);
    CreateDynamicObject(2907,2531.146,-1666.208,14.203,-176.185,0.0,213.750);
    CreateDynamicObject(2908,2532.720,-1666.901,14.243,0.0,0.0,33.750);
    CreateDynamicObject(2908,2524.760,-1664.670,14.149,0.0,0.0,101.250);
    CreateDynamicObject(3525,2495.542,-1670.751,11.605,0.0,0.0,67.500);
    CreateDynamicObject(3525,2506.337,-1671.448,11.682,0.0,0.0,0.0);
    CreateDynamicObject(3461,2506.754,-1671.903,10.763,0.0,0.0,0.0);
    CreateDynamicObject(3525,2491.725,-1656.310,11.613,0.0,0.0,56.250);
    CreateDynamicObject(3525,2483.318,-1695.047,11.666,0.0,0.0,146.250);
    CreateDynamicObject(3525,2482.947,-1713.439,11.736,0.0,0.0,146.250);
    CreateDynamicObject(3525,2479.968,-1699.074,13.294,0.0,0.0,146.250);
    CreateDynamicObject(3525,2480.798,-1681.351,11.550,0.0,0.0,146.250);
    CreateDynamicObject(3525,2499.578,-1671.897,11.367,0.0,0.0,146.250);
    CreateDynamicObject(3525,2481.238,-1652.645,11.713,0.0,0.0,213.750);
    CreateDynamicObject(3525,2483.283,-1668.755,11.538,0.0,0.0,213.750);
    CreateDynamicObject(3864,2469.030,-1678.315,18.505,0.0,0.0,-146.250);
    CreateDynamicObject(3593,2522.514,-1722.525,13.386,0.0,297.365,90.000);
    CreateDynamicObject(3594,2515.556,-1731.460,13.014,0.0,0.0,-67.500);
    CreateDynamicObject(3594,2529.041,-1751.050,13.014,0.0,0.0,-33.750);
    CreateDynamicObject(3594,2526.401,-1771.469,13.014,0.0,0.0,-101.250);
    CreateDynamicObject(3594,2539.525,-1713.817,13.111,0.0,0.0,-123.750);
    CreateDynamicObject(3594,2543.944,-1720.666,13.172,0.0,41.253,-225.000);
    CreateDynamicObject(3593,2523.375,-1733.967,12.743,0.0,0.0,101.250);
    CreateDynamicObject(3593,2542.215,-1733.925,12.718,0.0,0.0,33.750);
    CreateDynamicObject(12957,2458.688,-1732.332,13.313,0.0,0.0,-135.000);
    CreateDynamicObject(12957,2483.818,-1756.611,13.425,0.0,0.0,-33.750);
    CreateDynamicObject(12957,2508.516,-1739.722,13.433,0.0,0.0,22.500);
    CreateDynamicObject(1219,2507.517,-1746.188,13.426,-360.963,90.241,178.358);
    CreateDynamicObject(1219,2507.617,-1751.465,13.640,-360.963,90.241,178.358);
    CreateDynamicObject(1219,2501.154,-1760.682,13.693,-360.963,90.241,88.358);
    CreateDynamicObject(1219,2507.584,-1756.674,13.611,-360.963,90.241,178.358);
    CreateDynamicObject(1219,2495.830,-1760.751,13.594,-360.963,90.241,88.358);
    CreateDynamicObject(1219,2490.743,-1760.601,12.957,-360.963,90.241,273.592);
    CreateDynamicObject(1219,2489.424,-1760.590,13.710,-360.963,90.241,273.592);
    CreateDynamicObject(1219,2475.329,-1758.667,14.024,-360.963,90.241,272.733);
    CreateDynamicObject(1219,2473.133,-1758.817,14.326,-360.963,90.241,-87.267);
    CreateDynamicObject(1219,2477.669,-1758.742,14.311,0.859,-89.381,264.844);
    CreateDynamicObject(1219,2470.767,-1758.838,13.885,0.859,-88.522,270.937);
    CreateDynamicObject(1219,2467.046,-1744.964,13.931,-178.763,-87.663,270.937);
    CreateDynamicObject(1219,2474.664,-1750.507,13.488,-178.763,-89.381,180.937);
    CreateDynamicObject(1219,2464.565,-1744.763,13.703,-270.723,-90.241,270.937);
    CreateDynamicObject(1219,2518.395,-1701.291,14.308,-270.723,-90.241,229.375);
    CreateDynamicObject(1219,2515.635,-1698.840,13.879,-270.723,-90.241,51.094);
    CreateDynamicObject(3594,2407.591,-1660.708,13.014,0.0,0.0,56.250);
    CreateDynamicObject(3594,2342.177,-1671.545,12.993,0.0,0.0,-112.500);
    CreateDynamicObject(3594,2390.683,-1657.319,13.014,0.0,0.0,33.750);
    CreateDynamicObject(3594,2307.190,-1659.793,14.002,0.0,0.0,90.000);
    CreateDynamicObject(3594,2345.944,-1657.608,13.016,0.0,0.0,157.500);
    CreateDynamicObject(3594,2245.374,-1652.813,14.918,0.0,0.0,213.750);
    CreateDynamicObject(3594,2225.876,-1666.730,14.579,0.0,0.0,135.000);
    CreateDynamicObject(3594,2219.114,-1692.316,13.287,0.0,0.0,180.000);
    CreateDynamicObject(3594,2168.943,-1634.531,14.024,0.0,0.0,236.250);
    CreateDynamicObject(3594,2192.095,-1641.178,14.940,0.0,0.0,315.000);
    CreateDynamicObject(3594,2243.129,-1734.340,13.014,0.0,0.0,67.500);
    CreateDynamicObject(3594,2190.229,-1690.110,13.255,0.0,0.0,45.000);
    CreateDynamicObject(3594,2187.774,-1709.127,12.998,0.0,0.0,135.000);
    CreateDynamicObject(3594,2187.916,-1724.664,13.006,0.0,0.0,67.500);
    CreateDynamicObject(3594,2178.420,-1747.205,13.006,0.0,0.0,112.500);
    CreateDynamicObject(3594,2307.311,-1728.287,13.014,0.0,0.0,-11.250);
    CreateDynamicObject(3594,2327.683,-1751.237,13.009,0.0,0.0,56.250);
    CreateDynamicObject(3594,2385.815,-1730.290,13.014,0.0,0.0,0.0);
    CreateDynamicObject(3594,2338.014,-1732.145,13.014,0.0,0.0,45.000);
    CreateDynamicObject(3594,2312.850,-1742.010,13.014,0.0,0.0,101.250);
    CreateDynamicObject(3594,2343.865,-1692.746,12.991,0.0,0.0,135.000);
    CreateDynamicObject(3594,2342.378,-1714.729,12.991,0.0,0.0,78.750);
    CreateDynamicObject(3594,2394.699,-1750.075,13.014,0.0,0.0,-33.750);
    CreateDynamicObject(3594,2409.506,-1731.386,13.048,0.0,0.0,33.750);
    CreateDynamicObject(3594,2414.867,-1758.471,13.022,0.0,0.0,67.500);
    CreateDynamicObject(3594,2414.856,-1780.040,13.022,0.0,0.0,22.500);
    CreateDynamicObject(12957,2421.965,-1730.387,13.411,0.0,0.0,-67.500);
    CreateDynamicObject(12957,2410.036,-1746.233,13.261,0.0,0.0,-112.500);
    CreateDynamicObject(12957,2378.863,-1734.832,13.261,0.0,0.0,-56.250);
    CreateDynamicObject(12957,2372.111,-1747.335,13.261,0.0,0.0,-78.750);
    CreateDynamicObject(12957,2304.405,-1733.614,13.261,0.0,0.0,-22.500);
    CreateDynamicObject(12957,2231.359,-1740.001,13.430,0.0,0.0,-22.500);
    CreateDynamicObject(12957,2265.001,-1748.983,13.261,0.0,0.0,33.750);
    CreateDynamicObject(12957,2278.683,-1729.950,13.261,0.0,0.0,-33.750);
    CreateDynamicObject(12957,2205.341,-1729.572,13.296,0.0,0.0,-56.250);
    CreateDynamicObject(12957,2186.334,-1732.771,13.253,0.0,0.0,-22.500);
    CreateDynamicObject(12957,2189.279,-1674.600,14.063,0.0,0.0,11.250);
    CreateDynamicObject(12957,2220.027,-1706.653,13.324,0.0,0.0,-45.000);
    CreateDynamicObject(3593,2368.057,-1655.887,12.743,0.0,0.0,56.250);
    CreateDynamicObject(3593,2338.639,-1682.924,12.720,0.0,0.0,135.000);
    CreateDynamicObject(3593,2352.964,-1737.797,12.757,0.0,0.0,135.000);
    CreateDynamicObject(3593,2396.258,-1740.360,13.007,0.0,0.0,225.000);
    CreateDynamicObject(3593,2185.599,-1770.942,13.079,0.0,0.0,292.500);
    CreateDynamicObject(3593,2177.809,-1802.854,13.080,0.0,0.0,258.750);
    CreateDynamicObject(3594,2132.165,-1618.031,13.022,0.0,0.0,146.250);
    CreateDynamicObject(3594,2114.376,-1622.408,13.201,0.0,0.0,112.500);
    CreateDynamicObject(3594,2080.448,-1611.537,13.006,0.0,0.0,157.500);
    CreateDynamicObject(3594,2082.741,-1633.236,13.014,0.0,0.0,112.500);
    CreateDynamicObject(3594,2079.511,-1670.841,13.022,0.0,0.0,157.500);
    CreateDynamicObject(3594,2080.502,-1686.462,13.022,0.0,0.0,135.000);
    CreateDynamicObject(3594,2054.810,-1673.599,13.022,0.0,0.0,157.500);
    CreateDynamicObject(3594,2020.799,-1670.614,13.014,0.0,0.0,112.500);
    CreateDynamicObject(3594,1822.653,-1788.725,13.014,0.0,0.0,135.000);
    CreateDynamicObject(3594,1821.413,-1721.946,13.014,0.0,0.0,78.750);
    CreateDynamicObject(3594,1862.677,-1751.100,13.014,0.0,0.0,112.500);
    CreateDynamicObject(3594,1901.145,-1748.511,13.014,0.0,0.0,101.250);
    CreateDynamicObject(3594,1925.158,-1752.062,13.014,0.0,0.0,146.250);
    CreateDynamicObject(3594,2005.663,-1751.004,13.014,0.0,0.0,146.250);
    CreateDynamicObject(3594,2039.593,-1750.612,13.014,0.0,0.0,101.250);
    CreateDynamicObject(3594,2002.656,-1709.907,13.014,0.0,0.0,135.000);
    CreateDynamicObject(3594,1960.524,-1782.908,13.014,0.0,0.0,78.750);
    CreateDynamicObject(3594,1963.508,-1846.363,13.014,0.0,0.0,123.750);
    CreateDynamicObject(3594,2030.492,-1777.433,13.184,0.0,0.0,146.250);
    CreateDynamicObject(3594,2080.447,-1735.815,13.022,0.0,0.0,146.250);
    CreateDynamicObject(3594,2087.359,-1777.276,13.014,0.0,0.0,180.000);
    CreateDynamicObject(3594,2083.971,-1825.661,13.014,0.0,0.0,101.250);
    CreateDynamicObject(3594,2104.545,-1735.804,13.193,0.0,0.0,101.250);
    CreateDynamicObject(3594,2060.368,-1812.670,13.014,0.0,0.0,101.250);
    CreateDynamicObject(3594,2011.462,-1813.627,13.014,0.0,0.0,135.000);
    CreateDynamicObject(3594,1941.818,-1641.505,13.014,0.0,0.0,281.250);
    CreateDynamicObject(12957,2131.118,-1751.013,13.278,0.0,0.0,-22.500);
    CreateDynamicObject(12957,2087.356,-1784.928,13.261,0.0,0.0,-90.000);
    CreateDynamicObject(12957,2013.521,-1753.124,13.261,0.0,0.0,33.750);
    CreateDynamicObject(12957,1965.396,-1751.733,13.269,0.0,0.0,-78.750);
    CreateDynamicObject(12957,1945.341,-1780.671,13.269,0.0,0.0,-11.250);
    CreateDynamicObject(12957,1940.903,-1654.287,13.261,0.0,0.0,22.500);
    CreateDynamicObject(12957,1902.536,-1753.830,13.261,0.0,0.0,-33.750);
    CreateDynamicObject(12957,1844.708,-1753.122,13.261,0.0,0.0,0.0);
    CreateDynamicObject(12957,1817.321,-1652.643,13.261,0.0,0.0,11.250);
    CreateDynamicObject(12957,2003.093,-1690.640,13.261,0.0,0.0,11.250);
    CreateDynamicObject(3593,2192.184,-1654.947,14.821,0.0,0.0,258.750);
    CreateDynamicObject(3593,2037.483,-1672.260,12.643,0.0,0.0,258.750);
    CreateDynamicObject(3593,1992.989,-1746.590,12.853,0.0,0.0,292.500);
    CreateDynamicObject(3593,1998.795,-1753.307,12.743,0.0,0.0,0.0);
    CreateDynamicObject(3593,1817.751,-1762.977,12.893,0.0,0.0,-90.000);
    CreateDynamicObject(3593,1998.894,-1689.947,12.993,0.0,0.0,0.0);
    CreateDynamicObject(3593,2403.117,-1649.283,13.048,0.0,0.0,90.000);

// Unity por GROVE4L
    CreateDynamicObject(1843,1833.810,-1839.104,13.452,245.799,0.0,90.077);
    CreateDynamicObject(1842,1825.237,-1849.609,12.881,0.0,0.0,22.500);
    CreateDynamicObject(1845,1825.437,-1851.306,12.788,-0.859,23.205,-78.750);
    CreateDynamicObject(1849,1829.297,-1839.949,12.402,-21.486,0.0,56.250);
    CreateDynamicObject(1847,1827.230,-1839.136,12.202,0.0,0.0,-146.250);
    CreateDynamicObject(1884,1829.468,-1844.984,12.127,76.490,0.0,0.0);
    CreateDynamicObject(1973,1829.712,-1847.227,13.008,131.598,0.0,0.0);
    CreateDynamicObject(1983,1830.777,-1849.693,12.577,275.020,0.0,33.750);
    CreateDynamicObject(1983,1827.521,-1848.937,12.577,346.353,36.096,-157.500);
    CreateDynamicObject(1989,1831.968,-1842.391,12.405,0.0,0.0,-33.750);
    CreateDynamicObject(1984,1832.540,-1845.572,12.577,0.0,-28.361,0.0);
    CreateDynamicObject(1994,1827.390,-1842.225,12.584,0.0,0.0,56.250);
    CreateDynamicObject(1843,1831.081,-1843.221,12.577,0.0,0.0,-11.250);
    CreateDynamicObject(1844,1825.155,-1846.372,12.413,0.0,0.0,-67.500);
    CreateDynamicObject(1846,1824.850,-1843.073,11.467,0.0,0.0,0.0);
    CreateDynamicObject(1850,1830.024,-1850.342,12.577,0.0,0.0,-33.750);
    CreateDynamicObject(912,1810.734,-1846.024,13.045,0.0,0.0,90.000);
    CreateDynamicObject(911,1815.243,-1841.810,13.120,0.0,0.0,-33.750);
    CreateDynamicObject(854,1813.807,-1845.797,12.760,0.0,0.0,0.0);
    CreateDynamicObject(853,1816.965,-1830.822,12.815,0.0,0.0,0.0);
    CreateDynamicObject(3594,1823.269,-1835.421,12.920,0.0,0.0,-22.500);
    CreateDynamicObject(3594,1808.788,-1867.634,13.214,0.0,0.0,-90.000);
    CreateDynamicObject(3593,1816.026,-1852.689,12.699,0.0,0.0,22.500);
    CreateDynamicObject(3593,1836.589,-1854.447,12.725,0.0,0.0,0.0);
    CreateDynamicObject(2672,1822.969,-1846.750,12.694,0.0,0.0,0.0);
    CreateDynamicObject(2671,1819.777,-1841.465,12.417,0.0,0.0,0.0);
    CreateDynamicObject(2671,1808.674,-1852.957,12.417,0.0,0.0,0.0);
    CreateDynamicObject(2671,1821.735,-1862.709,12.417,0.0,0.0,0.0);
    CreateDynamicObject(2676,1829.627,-1853.052,12.681,0.0,0.0,-11.250);
    CreateDynamicObject(2676,1819.830,-1845.847,12.517,0.0,0.0,56.250);
    CreateDynamicObject(12957,1837.636,-1871.089,12.968,0.0,0.0,0.0);
    CreateDynamicObject(12957,1808.565,-1843.819,13.156,0.0,0.0,0.0);
    CreateDynamicObject(12957,1819.261,-1843.889,12.717,165.871,0.0,56.250);
    CreateDynamicObject(12954,1835.616,-1889.162,13.007,0.0,0.0,90.000);
    CreateDynamicObject(2672,1815.525,-1859.536,12.694,0.0,0.0,0.0);
    CreateDynamicObject(2672,1820.604,-1794.584,12.662,0.0,0.0,0.0);
    CreateDynamicObject(2672,1819.252,-1823.413,12.694,0.0,0.0,0.0);
    CreateDynamicObject(2672,1808.874,-1832.873,12.662,0.0,0.0,0.0);
    CreateDynamicObject(2672,1812.971,-1840.775,12.858,0.0,0.0,0.0);
    CreateDynamicObject(2671,1805.041,-1835.833,12.385,0.0,0.0,0.0);
    CreateDynamicObject(2671,1813.078,-1814.224,12.574,0.0,0.0,0.0);
    CreateDynamicObject(2671,1821.822,-1819.995,12.417,0.0,0.0,0.0);
    CreateDynamicObject(2671,1818.435,-1838.365,12.417,0.0,0.0,0.0);
    CreateDynamicObject(12957,1786.751,-1865.124,13.276,0.0,0.0,0.0);
    CreateDynamicObject(3594,1824.643,-1859.296,12.945,0.0,0.0,-101.250);
    CreateDynamicObject(3594,1841.284,-1864.181,13.021,0.0,0.0,-123.750);
    CreateDynamicObject(3593,1830.391,-1893.753,13.365,0.0,-41.253,0.0);
    CreateDynamicObject(3594,1819.521,-1876.769,13.028,0.0,0.0,-157.500);
    CreateDynamicObject(12957,1823.106,-1911.239,13.262,0.0,0.0,-56.250);
    CreateDynamicObject(12957,1819.548,-1893.294,13.258,0.0,0.0,11.250);
    CreateDynamicObject(3594,1801.264,-1897.618,13.036,0.0,0.0,-101.250);
    CreateDynamicObject(849,1814.823,-1902.853,12.873,0.0,0.0,0.0);
    CreateDynamicObject(13591,1785.511,-1909.282,12.356,0.0,0.0,-146.250);
    CreateDynamicObject(1450,1768.825,-1935.989,13.043,0.0,0.0,0.0);
    CreateDynamicObject(2674,1784.535,-1926.967,12.411,0.0,0.0,0.0);
    CreateDynamicObject(2674,1796.053,-1925.095,12.411,0.0,0.0,0.0);
    CreateDynamicObject(2674,1790.348,-1946.400,12.565,0.0,0.0,-56.250);
    CreateDynamicObject(2674,1768.883,-1941.239,12.583,0.0,0.0,-101.250);
    CreateDynamicObject(2674,1778.420,-1939.414,12.585,0.0,0.0,-33.750);
    CreateDynamicObject(2673,1777.391,-1930.797,12.475,0.0,0.0,0.0);
    CreateDynamicObject(1572,1783.436,-1939.036,13.125,0.0,0.0,56.250);
    CreateDynamicObject(1415,1787.691,-1929.945,12.403,0.0,0.0,-67.500);
    CreateDynamicObject(1332,1769.948,-1922.531,13.245,0.0,0.0,-90.000);
    CreateDynamicObject(3594,1790.447,-1897.376,12.828,0.0,0.0,-236.250);
    CreateDynamicObject(3594,1794.148,-1927.717,12.820,0.0,0.0,-303.750);
    CreateDynamicObject(3594,1790.250,-1946.060,13.027,0.0,0.0,-303.750);
    CreateDynamicObject(3593,1826.396,-1869.663,12.725,0.0,0.0,-33.750);
    CreateDynamicObject(3593,1799.797,-1888.759,12.714,0.0,0.0,-11.250);
    CreateDynamicObject(3593,1800.546,-1909.479,12.733,0.0,0.0,-56.250);
    CreateDynamicObject(942,1811.480,-1875.229,15.028,0.0,0.0,-90.000);
    CreateDynamicObject(933,1811.526,-1878.888,12.581,0.0,0.0,0.0);
    CreateDynamicObject(1442,1813.795,-1866.045,13.069,0.0,0.0,90.000);
    CreateDynamicObject(12957, 1548.8359375, -1676.625, 14.584999084473, 339.74670410156, 0, 87.742309570313);
    CreateDynamicObject(3593, 1528.0361328125, -1633.37109375, 13.092980384827, 0, 0, 320.99304199219);
    CreateDynamicObject(3594, 1425.3885498047, -1678.8337402344, 13.013989448547, 0, 0, 41.248168945313);
    CreateDynamicObject(3594, 1536.0205078125, -1676.0034179688, 13.013989448547, 0, 0, 2.9937744140625);
    CreateDynamicObject(6976, 1558.9852294922, -1636.3154296875, 18.571094512939, 0, 0, 0);
    CreateDynamicObject(6976, 1545.6748046875, -1636.25, 11.354433059692, 0, 0, 0);
    CreateDynamicObject(987, 1542.6744384766, -1649.6665039063, 27.402114868164, 0, 0, 0);
    CreateDynamicObject(987, 1542.6357421875, -1637.240234375, 27.402114868164, 0, 0, 270);
    CreateDynamicObject(987, 1554.46484375, -1637.3359375, 27.402114868164, 0, 0, 179.99450683594);
    CreateDynamicObject(987, 1566.3560791016, -1637.4111328125, 27.402114868164, 0, 0, 180);
    CreateDynamicObject(987, 1575.0081787109, -1637.2843017578, 27.402114868164, 0, 0, 180.75);
    CreateDynamicObject(987, 1577.826171875, -1647.3381347656, 27.402114868164, 0, 0, 91.499633789063);
    CreateDynamicObject(987, 1577.7043457031, -1659.1861572266, 27.395606994629, 0, 0, 89.247436523438);
    CreateDynamicObject(3279, 1548.99609375, -1641.1669921875, 27.402114868164, 0, 0, 0);
    CreateDynamicObject(16093, 1566.2410888672, -1644.0427246094, 31.682960510254, 0, 0, 182.24670410156);
    CreateDynamicObject(3593, 1486.5078125, -1637.173828125, 13.558606147766, 0, 0, 20.25);
    CreateDynamicObject(852, 1506.853515625, -1631.2857666016, 13.046875, 0, 0, 0);
    CreateDynamicObject(854, 1484.494140625, -1643.447265625, 13.362872123718, 0, 0, 0);
    CreateDynamicObject(853, 1476.7991943359, -1639.1693115234, 13.549111366272, 0, 0, 0);
    CreateDynamicObject(853, 1527.8323974609, -1608.8995361328, 12.783486366272, 0, 0, 0);
    CreateDynamicObject(851, 1528.4697265625, -1617.9013671875, 12.695683479309, 0, 0, 0);
    CreateDynamicObject(3092, 1545.1240234375, -1673.943359375, 12.999054908752, 0, 90, 356.99523925781);
    CreateDynamicObject(2908, 1553.4064941406, -1622.3739013672, 12.62429523468, 0, 0, 0);
    CreateDynamicObject(2907, 1558.7470703125, -1626.181640625, 12.542848587036, 0, 0, 0);
    CreateDynamicObject(2906, 1561.8264160156, -1621.3493652344, 12.620887756348, 0, 0, 0);
    CreateDynamicObject(2905, 1555.5517578125, -1628.537109375, 12.474261283875, 0, 0, 0);
    CreateDynamicObject(2906, 1568.8513183594, -1625.8656005859, 12.456825256348, 0, 0, 321);
    CreateDynamicObject(2905, 1551.125, -1609.07421875, 12.474261283875, 0, 0, 0);
    CreateDynamicObject(2908, 1565.970703125, -1609.8596191406, 12.46023273468, 0, 0, 0);
    CreateDynamicObject(2907, 1556.7141113281, -1610.5678710938, 12.542848587036, 0, 0, 0);
    CreateDynamicObject(2906, 1558, -1605.873046875, 12.456825256348, 0, 0, 0);
    CreateDynamicObject(2907, 1566.4189453125, -1615.6105957031, 12.542848587036, 0, 0, 318.75);
    CreateDynamicObject(2907, 1584.1657714844, -1612.5698242188, 12.542848587036, 0, 0, 51);
    CreateDynamicObject(2907, 1596.7318115234, -1626.1025390625, 12.590438842773, 0, 0, 321.75);
    CreateDynamicObject(2906, 1575.7281494141, -1614.318359375, 12.456825256348, 0, 0, 32.25);
    CreateDynamicObject(2906, 1595.7902832031, -1616.6644287109, 12.49071598053, 0, 0, 326.25);
    CreateDynamicObject(2905, 1594.3841552734, -1607.7950439453, 12.492699623108, 0, 0, 27);
    CreateDynamicObject(2905, 1581.705078125, -1628.333984375, 12.474261283875, 0, 0, 329.24926757813);
    CreateDynamicObject(2905, 1576.4439697266, -1607.0736083984, 12.474261283875, 0, 0, 58.5);
    CreateDynamicObject(851, 1565.7374267578, -1620.5104980469, 12.859745979309, 0, 0, 0);
    CreateDynamicObject(850, 1466.1363525391, -1591.5111083984, 12.494305610657, 0, 0, 0);
    CreateDynamicObject(852, 1550.4807128906, -1618.7495117188, 12.546875, 0, 0, 330);
    CreateDynamicObject(852, 1479.1119384766, -1615.1833496094, 13.03929901123, 0, 0, 0);
    CreateDynamicObject(851, 1473.0955810547, -1621.5499267578, 13.352168083191, 0, 0, 0);
    CreateDynamicObject(2744, 1519.4162597656, -1648.8630371094, 14.631126403809, 0, 0, 0);
    CreateDynamicObject(1299, 1517.5677490234, -1595.3303222656, 13.459580421448, 0, 0, 0);
    CreateDynamicObject(1219, 1497.1812744141, -1581.6843261719, 13.51275062561, 0, 269.25006103516, 89.25);
    CreateDynamicObject(1219, 1499.3305664063, -1581.6750488281, 13.587750434875, 0, 269.24743652344, 89.247436523438);
    CreateDynamicObject(1219, 1497.6166992188, -1581.6683349609, 15.24693107605, 0, 269.24743652344, 89.247436523438);
    CreateDynamicObject(1219, 1499.1965332031, -1581.5646972656, 15.324054718018, 0, 269.24743652344, 89.247436523438);
    CreateDynamicObject(1219, 1497.5759277344, -1581.7600097656, 17.355602264404, 0, 269.24743652344, 89.247436523438);
    CreateDynamicObject(1219, 1499.2965087891, -1581.7663574219, 17.424797058105, 0, 269.24743652344, 89.247436523438);
    CreateDynamicObject(2985, 1546.8388671875, -1641.068359375, 43.480239868164, 0, 0, 181.49963378906);
    CreateDynamicObject(2985, 1547.1884765625, -1643.033203125, 43.480239868164, 0, 0, 217.49633789063);
    CreateDynamicObject(2985, 1547.2392578125, -1639.4658203125, 43.480239868164, 0, 0, 147.74963378906);
    CreateDynamicObject(987, 1577.6431884766, -1670.9993896484, 27.395606994629, 0, 0, 89.247436523438);
    CreateDynamicObject(987, 1577.6153564453, -1682.4260253906, 27.395587921143, 0, 0, 89.991943359375);
    CreateDynamicObject(987, 1577.7790527344, -1694.1201171875, 27.395587921143, 0, 0, 89.989013671875);
    CreateDynamicObject(987, 1577.7120361328, -1705.6177978516, 27.3948097229, 0, 0, 89.989013671875);
    CreateDynamicObject(987, 1577.7219238281, -1714.4090576172, 27.3948097229, 0, 0, 89.989013671875);
    CreateDynamicObject(987, 1565.9089355469, -1714.40234375, 27.3948097229, 0, 0, 359.98901367188);
    CreateDynamicObject(987, 1554.2387695313, -1714.3057861328, 27.3948097229, 0, 0, 359.98352050781);
    CreateDynamicObject(987, 1542.5631103516, -1714.2623291016, 27.3948097229, 0, 0, 359.98352050781);
    CreateDynamicObject(987, 1542.7891845703, -1701.9968261719, 27.3948097229, 0, 0, 270);
    CreateDynamicObject(987, 1554.5921630859, -1702.0386962891, 27.3948097229, 0, 0, 179.99450683594);
    CreateDynamicObject(987, 1554.7576904297, -1690.1883544922, 27.395587921143, 0, 0, 270);
    CreateDynamicObject(987, 1554.9753417969, -1678.3587646484, 27.395587921143, 0, 0, 270);
    CreateDynamicObject(987, 1554.9770507813, -1666.8011474609, 27.395606994629, 0, 0, 270);
    CreateDynamicObject(987, 1555.0679931641, -1655.0427246094, 27.395606994629, 0, 0, 270);
    CreateDynamicObject(987, 1554.8454589844, -1649.5908203125, 27.402114868164, 0, 0, 270);
    CreateDynamicObject(12957, 1619.9169921875, -1726.1240234375, 13.425091743469, 0, 0, 131.24816894531);
    CreateDynamicObject(3594, 1519.3104248047, -1667.0787353516, 13.178051948547, 0, 0, 32.239379882813);
    CreateDynamicObject(852, 1532.5633544922, -1709.5263671875, 12.3828125, 0, 0, 0);
    CreateDynamicObject(851, 1526.6723632813, -1690.6915283203, 12.695683479309, 0, 0, 0);
    CreateDynamicObject(3594, 1463.9749755859, -1594.9780273438, 13.013989448547, 0, 0, 32.239379882813);
    CreateDynamicObject(827, 1315.4122314453, -1573.427734375, 14.223468780518, 0, 0, 0);
    CreateDynamicObject(827, 1313.4945068359, -1573.9952392578, 14.973466873169, 0, 0, 0);
    CreateDynamicObject(827, 1311.0053710938, -1587.0418701172, 15.273466110229, 0, 0, 0);
    CreateDynamicObject(827, 1315.2241210938, -1584.0366210938, 15.273466110229, 0, 0, 0);
    CreateDynamicObject(827, 1314.3065185547, -1783.6652832031, 14.973466873169, 0, 0, 0);
    CreateDynamicObject(827, 1311.7204589844, -1788.9715576172, 14.448468208313, 0, 0, 0);
    CreateDynamicObject(827, 1304.1584472656, -1784.8509521484, 14.687528610229, 0, 0, 0);
    CreateDynamicObject(827, 1298.4154052734, -1779.3675537109, 14.523468017578, 0, 0, 0);
    CreateDynamicObject(827, 1304.2084960938, -1769.3880615234, 14.83752822876, 0, 0, 0);
    CreateDynamicObject(827, 1308.3704833984, -1781.32421875, 14.523468017578, 0, 0, 0);
    CreateDynamicObject(827, 1297.5142822266, -1786.5828857422, 14.448468208313, 0, 0, 0);
    CreateDynamicObject(827, 1301.0710449219, -1797.9854736328, 14.673467636108, 0, 0, 0);
    CreateDynamicObject(827, 1309.9644775391, -1796.6884765625, 14.598467826843, 0, 0, 0);
    CreateDynamicObject(827, 1295.4527587891, -1768.0700683594, 14.823467254639, 0, 0, 0);
    CreateDynamicObject(827, 1300.0965576172, -1761.2103271484, 14.898467063904, 0, 0, 0);
    CreateDynamicObject(827, 1295.5985107422, -1754.0390625, 14.748467445374, 0, 0, 0);
    CreateDynamicObject(827, 1300.3975830078, -1746.623046875, 14.898467063904, 0, 0, 0);
    CreateDynamicObject(827, 1299.6563720703, -1771.3011474609, 14.748467445374, 0, 0, 0);
    CreateDynamicObject(827, 1309.2346191406, -1755.4724121094, 14.823467254639, 0, 0, 0);
    CreateDynamicObject(827, 1316.2783203125, -1747.5062255859, 14.298468589783, 0, 0, 0);
    CreateDynamicObject(827, 1310.5245361328, -1772.6881103516, 14.748467445374, 0, 0, 0);
    CreateDynamicObject(827, 1315.1673583984, -1763.9074707031, 14.012530326843, 0, 0, 0);
    CreateDynamicObject(827, 1298.6265869141, -1739.1616210938, 14.523468017578, 0, 0, 0);
    CreateDynamicObject(827, 1310.4334716797, -1742.0689697266, 14.673467636108, 0, 0, 0);
    CreateDynamicObject(827, 1315.8328857422, -1734.5269775391, 14.748467445374, 0, 0, 0);
    CreateDynamicObject(827, 1316.6181640625, -1739.0883789063, 14.073469161987, 0, 0, 0);
    CreateDynamicObject(827, 1310.6016845703, -1728.7758789063, 14.748467445374, 0, 0, 0);
    CreateDynamicObject(827, 1296.6578369141, -1727.7030029297, 14.223468780518, 0, 0, 0);
    CreateDynamicObject(827, 1311.0035400391, -1708.30859375, 14.448468208313, 0, 0, 0);
    CreateDynamicObject(827, 1291.9731445313, -1736.203125, 14.912528038025, 0, 0, 0);
    CreateDynamicObject(827, 1316.4517822266, -1725.79296875, 14.898467063904, 0, 0, 0);
    CreateDynamicObject(827, 1318.8347167969, -1722.6719970703, 14.612528800964, 0, 0, 0);
    CreateDynamicObject(827, 1311.0925292969, -1722.0278320313, 14.373468399048, 0, 0, 0);
    CreateDynamicObject(827, 1312.4826660156, -1716.9140625, 15.948464393616, 0, 0, 0);
    CreateDynamicObject(827, 1301.4030761719, -1702.5518798828, 27.830467224121, 0, 0, 0);
    CreateDynamicObject(827, 1287.7440185547, -1700.4216308594, 33.431983947754, 0, 0, 0);
    CreateDynamicObject(827, 1306.6695556641, -1552.6943359375, 14.98752784729, 0, 0, 0);
    CreateDynamicObject(827, 1313.3454589844, -1559.029296875, 14.756260871887, 0, 0, 0);
    CreateDynamicObject(827, 1313.9613037109, -1549.9367675781, 16.181259155273, 0, 0, 0);
    CreateDynamicObject(2907, 1532.9011230469, -1644.3022460938, 12.542848587036, 0, 0, 0);
    CreateDynamicObject(2905, 1529.7806396484, -1638.7990722656, 12.474261283875, 0, 0, 24);
    CreateDynamicObject(2905, 1535.7371826172, -1640.7926025391, 12.638323783875, 0, 0, 329.24926757813);
    CreateDynamicObject(2905, 1527.2325439453, -1642.8610839844, 12.474261283875, 0, 0, 115.5);
    CreateDynamicObject(2907, 1542.9885253906, -1667.8514404297, 12.715612411499, 0, 0, 0);
    CreateDynamicObject(2905, 1542.080078125, -1672.9693603516, 12.645251274109, 0, 0, 329.24926757813);
    CreateDynamicObject(2905, 1536.7664794922, -1672.98046875, 12.474261283875, 0, 0, 0);
    CreateDynamicObject(2905, 1526.7745361328, -1649.0096435547, 12.474261283875, 0, 0, 318);
    CreateDynamicObject(921, 1544.6654052734, -1650.5983886719, 18.592401504517, 0, 0, 0);
    CreateDynamicObject(910, 1544.1383056641, -1585.6563720703, 13.816030502319, 0, 0, 304.5);
    CreateDynamicObject(2905, 1532.4895019531, -1681.5948486328, 12.474261283875, 0, 0, 329.24926757813);
    CreateDynamicObject(2907, 1535.7824707031, -1691.7991943359, 12.706911087036, 0, 0, 21.75);
    CreateDynamicObject(2906, 1529.4072265625, -1660.0231933594, 12.456825256348, 0, 0, 0);
    CreateDynamicObject(3594, 1527.0773925781, -1653.4947509766, 13.013989448547, 0, 0, 47.989379882813);
    CreateDynamicObject(3594, 1535.6025390625, -1644.4658203125, 13.178051948547, 0, 0, 323.99230957031);
    CreateDynamicObject(3593, 1534.2874755859, -1663.6138916016, 13.092980384827, 0, 0, 320.99304199219);
    CreateDynamicObject(3279, 1558.6556396484, -1610.0334472656, 12.3828125, 0, 0, 0);
    CreateDynamicObject(3594, 1620.4921875, -1729.8974609375, 13.013989448547, 0, 0, 64.48974609375);
    CreateDynamicObject(3594, 1525.8176269531, -1674.2802734375, 13.013989448547, 0, 0, 58.489379882813);
    CreateDynamicObject(3593, 1512.3597412109, -1665.1784667969, 13.507042884827, 0, 0, 320.99304199219);
    CreateDynamicObject(3092, 1534.6141357422, -1717.3248291016, 17.018175125122, 0, 5.250244140625, 81.745208740234);
    CreateDynamicObject(3593, 1531.3426513672, -1688.2709960938, 13.092980384827, 0, 0, 320.99304199219);
    CreateDynamicObject(3594, 1521.0791015625, -1685.3981933594, 13.178051948547, 0, 0, 27.735717773438);
    CreateDynamicObject(3594, 1524.2746582031, -1697.0487060547, 13.178051948547, 0, 0, 58.485717773438);
    CreateDynamicObject(852, 1531.7561035156, -1693.3518066406, 12.3828125, 0, 0, 0);
    CreateDynamicObject(851, 1532.0133056641, -1675.0028076172, 12.695683479309, 0, 0, 0);
    CreateDynamicObject(851, 1513.8873291016, -1701.5980224609, 13.359745979309, 0, 0, 0);
    CreateDynamicObject(851, 1518.7730712891, -1713.0510253906, 12.859745979309, 0, 0, 0);
    CreateDynamicObject(3098, 1512.8686523438, -1692.7569580078, 15.332778930664, 0, 0, 0);
    CreateDynamicObject(3099, 1536.3790283203, -1702.2238769531, 12.546875, 0, 0, 308.25);
    CreateDynamicObject(3594, 1518.14453125, -1720.962890625, 13.178051948547, 0, 0, 58.480224609375);
    CreateDynamicObject(3594, 1531.5681152344, -1703.8043212891, 13.013989448547, 0, 0, 146.23568725586);
    CreateDynamicObject(12957, 1513.6892089844, -1709.5230712891, 13.925091743469, 359.99670410156, 0, 87.742309570313);
    CreateDynamicObject(3593, 1541.1571044922, -1673.2299804688, 13.262166976929, 0, 0, 294.74304199219);
    CreateDynamicObject(3593, 1519.5487060547, -1656.1749267578, 13.249342918396, 0, 0, 28.493041992188);
    CreateDynamicObject(3593, 1532.4285888672, -1719.6728515625, 13.092980384827, 0, 0, 320.99304199219);
    CreateDynamicObject(3594, 1530.21875, -1605.1247558594, 13.013989448547, 0, 0, 323.99230957031);
    CreateDynamicObject(3279, 1546.71484375, -1707.2841796875, 27.3948097229, 0, 0, 0);
    CreateDynamicObject(2985, 1544.8864746094, -1707.3182373047, 43.4729347229, 0, 0, 181.49963378906);
    CreateDynamicObject(2985, 1545.1833496094, -1705.6140136719, 43.4729347229, 0, 0, 147.74963378906);
    CreateDynamicObject(2985, 1545.177734375, -1708.8643798828, 43.4729347229, 0, 0, 217.49633789063);
    CreateDynamicObject(827, 1527.0512695313, -1662.2149658203, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1516.8182373047, -1712.2326660156, 16.58752822876, 0, 0, 0);
    CreateDynamicObject(827, 1507.8347167969, -1705.2106933594, 15.412521362305, 0, 0, 0);
    CreateDynamicObject(827, 1521.5212402344, -1720.9024658203, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1521.9389648438, -1708.9638671875, 14.762528419495, 0, 0, 0);
    CreateDynamicObject(827, 1529.6256103516, -1720.0233154297, 14.748467445374, 0, 0, 0);
    CreateDynamicObject(827, 1534.1372070313, -1722.6148681641, 14.748467445374, 0, 0, 0);
    CreateDynamicObject(827, 1531.8234863281, -1723.2639160156, 15.123466491699, 0, 0, 0);
    CreateDynamicObject(827, 1525.0290527344, -1721.3468017578, 15.123466491699, 0, 0, 0);
    CreateDynamicObject(827, 1525.0854492188, -1715.0284423828, 15.123466491699, 0, 0, 0);
    CreateDynamicObject(827, 1530.8693847656, -1709.0590820313, 14.823467254639, 0, 0, 0);
    CreateDynamicObject(827, 1533.8002929688, -1714.0007324219, 14.748467445374, 0, 0, 0);
    CreateDynamicObject(827, 1526.7333984375, -1703.6375732422, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1527.0809326172, -1709.0584716797, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1520.0308837891, -1693.1149902344, 15.13752746582, 0, 0, 0);
    CreateDynamicObject(827, 1519.6016845703, -1701.494140625, 14.762528419495, 0, 0, 0);
    CreateDynamicObject(827, 1532.0443115234, -1694.1062011719, 14.673467636108, 0, 0, 0);
    CreateDynamicObject(827, 1527.5123291016, -1683.9694824219, 14.673467636108, 0, 0, 0);
    CreateDynamicObject(827, 1519.0852050781, -1640.4503173828, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1520.3120117188, -1675.7639160156, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1522.5925292969, -1669.5428466797, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1522.6593017578, -1659.3607177734, 16.329830169678, 0, 0, 0);
    CreateDynamicObject(827, 1505.4384765625, -1676.3616943359, 16.83752822876, 0, 0, 0);
    CreateDynamicObject(3594, 1526.9786376953, -1665.8363037109, 13.013989448547, 0, 0, 47.98828125);
    CreateDynamicObject(827, 1531.8284912109, -1660.216796875, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(3578, 1561.6290283203, -1727.0778808594, 13.249908447266, 0, 0, 253.5);
    CreateDynamicObject(3578, 1971.1412353516, -1250.4295654297, 23.61803817749, 0, 0, 0);
    CreateDynamicObject(3578, 1980.8549804688, -1250.4774169922, 23.612125396729, 0, 0, 0);
    CreateDynamicObject(3578, 1974.5816650391, -1146.1727294922, 25.582103729248, 0, 0, 0);
    CreateDynamicObject(3578, 1965.1519775391, -1146.13671875, 25.581893920898, 0, 0, 0);
    CreateDynamicObject(3594, 1961.7836914063, -1204.1564941406, 25.718494415283, 339, 0, 310.5);
    CreateDynamicObject(3566, 1365.1971435547, -1279.7451171875, 15.160493850708, 0, 0, 0);
    CreateDynamicObject(3566, 2393.6984863281, -1898.0003662109, 15.160493850708, 0, 0, 91.5);
    CreateDynamicObject(3566, 2103.9597167969, -1805.6137695313, 15.168306350708, 0, 0, 0);
    CreateDynamicObject(3566, 925.68511962891, -1351.57421875, 14.989347457886, 0, 0, 0);
    CreateDynamicObject(827, 1361.9812011719, -1419.6273193359, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1358.7470703125, -1414.7817382813, 16.169500350952, 0, 0, 0);
    CreateDynamicObject(827, 1361.9830322266, -1410.9702148438, 16.176860809326, 0, 0, 0);
    CreateDynamicObject(827, 1357.8546142578, -1407.5158691406, 16.114496231079, 0, 0, 0);
    CreateDynamicObject(827, 1362.0189208984, -1405.0975341797, 16.204010009766, 0, 0, 0);
    CreateDynamicObject(827, 1367.1658935547, -1406.7019042969, 16.180988311768, 0, 0, 0);
    CreateDynamicObject(827, 1365.5714111328, -1398.2403564453, 16.203399658203, 0, 0, 0);
    CreateDynamicObject(827, 1360.5306396484, -1399.2901611328, 16.18436050415, 0, 0, 0);
    CreateDynamicObject(827, 1362.3001708984, -1393.6561279297, 16.269853591919, 0, 0, 0);
    CreateDynamicObject(827, 1365.6783447266, -1392.4223632813, 16.221485137939, 0, 0, 0);
    CreateDynamicObject(827, 1367.5856933594, -1402.0133056641, 16.174133300781, 0, 0, 0);
    CreateDynamicObject(827, 1353.2434082031, -1401.6352539063, 16.093473434448, 0, 0, 0);
    CreateDynamicObject(827, 1356.9698486328, -1402.7103271484, 16.078117370605, 0, 0, 0);
    CreateDynamicObject(827, 1353.1861572266, -1412.2261962891, 16.150722503662, 0, 0, 0);
    CreateDynamicObject(827, 1344.9404296875, -1426.0218505859, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1339.6485595703, -1409.4428710938, 16.140693664551, 0, 0, 0);
    CreateDynamicObject(827, 1337.4910888672, -1414.8148193359, 16.17501449585, 0, 0, 0);
    CreateDynamicObject(827, 1339.6196289063, -1403.3142089844, 16.105960845947, 0, 0, 0);
    CreateDynamicObject(827, 1344.4241943359, -1391.8742675781, 16.212535858154, 0, 0, 0);
    CreateDynamicObject(827, 1346.0144042969, -1386.4892578125, 16.29012298584, 0, 0, 0);
    CreateDynamicObject(827, 1335.3223876953, -1393.2082519531, 16.18701171875, 0, 0, 0);
    CreateDynamicObject(827, 1361.0042724609, -1382.6748046875, 16.298324584961, 0, 0, 0);
    CreateDynamicObject(827, 1337.5280761719, -1383.0197753906, 16.471115112305, 0, 0, 0);
    CreateDynamicObject(827, 1335.9256591797, -1397.9274902344, 16.111892700195, 0, 0, 0);
    CreateDynamicObject(1219, 2523.5268554688, -1679.6032714844, 15.90991973877, 0, 90, 178.49865722656);
    CreateDynamicObject(1219, 2495.3825683594, -1691.3460693359, 14.953545570374, 0, 90, 90);
    CreateDynamicObject(1219, 2514.458984375, -1691.7537841797, 13.933959960938, 0, 90, 138.74365234375);
    CreateDynamicObject(1219, 1880.1354980469, -1628.4582519531, 12.983682632446, 0, 91.499816894531, 90.749877929688);
    CreateDynamicObject(1219, 1879.8707275391, -1628.7463378906, 14.70316028595, 0, 91.499633789063, 90.7470703125);
    CreateDynamicObject(1219, 1877.7972412109, -1628.5523681641, 12.876895904541, 0, 91.499633789063, 90.7470703125);
    CreateDynamicObject(1219, 1877.5799560547, -1628.8392333984, 14.435007095337, 0, 91.499633789063, 90.7470703125);
    CreateDynamicObject(1219, 1875.5401611328, -1628.2421875, 12.93878364563, 0, 91.499633789063, 90.7470703125);
    CreateDynamicObject(1219, 1875.3122558594, -1628.2421875, 14.765460968018, 0, 91.499633789063, 90.7470703125);
    CreateDynamicObject(1219, 1837.2418212891, -1679.0035400391, 12.677286148071, 0, 91.499572753906, 176.24700927734);
    CreateDynamicObject(1219, 1837.181640625, -1681.4566650391, 12.679800033569, 0, 91.494140625, 176.24267578125);
    CreateDynamicObject(1219, 1837.0452880859, -1683.7783203125, 12.685499191284, 0, 91.494140625, 176.24267578125);
    CreateDynamicObject(1219, 1837.3225097656, -1679.0158691406, 14.398954391479, 0, 91.494140625, 176.24267578125);
    CreateDynamicObject(1219, 1837.1634521484, -1681.3415527344, 14.398665428162, 0, 91.494140625, 176.24267578125);
    CreateDynamicObject(1219, 1837.0960693359, -1683.6516113281, 14.406138420105, 0, 91.494140625, 176.24267578125);
    CreateDynamicObject(1219, 1837.0595703125, -1685.7120361328, 12.684900283813, 0, 91.494140625, 176.24267578125);
    CreateDynamicObject(1219, 1837.0236816406, -1685.7562255859, 14.403574943542, 0, 91.494140625, 176.24267578125);
    CreateDynamicObject(1219, 1875.4754638672, -1736.703125, 12.679246902466, 0, 91.499572753906, 267.7470703125);
    CreateDynamicObject(1219, 1875.4434814453, -1736.703125, 14.398754119873, 0, 91.494140625, 267.74230957031);
    CreateDynamicObject(1219, 1877.7764892578, -1736.703125, 12.679246902466, 0, 91.494140625, 267.74230957031);
    CreateDynamicObject(1219, 1877.7862548828, -1736.703125, 14.398792266846, 0, 91.494140625, 267.74230957031);
    CreateDynamicObject(1219, 1880.0047607422, -1736.703125, 12.679246902466, 0, 91.494140625, 267.74230957031);
    CreateDynamicObject(1219, 1880.3544921875, -1736.703125, 14.399146080017, 0, 91.494140625, 267.74230957031);
    CreateDynamicObject(1219, 1721.2266845703, -1741.5162353516, 13.627561569214, 0, 91.499633789063, 90.7470703125);
    CreateDynamicObject(1219, 1719.3530273438, -1741.5162353516, 17.489040374756, 0, 91.499633789063, 90.7470703125);
    CreateDynamicObject(1219, 1490.9183349609, -1772.6640625, 18.790658950806, 0, 91.499633789063, 90.7470703125);
    CreateDynamicObject(1219, 1488.9766845703, -1772.6640625, 18.728471755981, 0, 91.499633789063, 90.7470703125);
    CreateDynamicObject(1219, 1486.6020507813, -1772.6640625, 18.841053009033, 0, 91.499633789063, 90.7470703125);
    CreateDynamicObject(1219, 1490.9282226563, -1772.6640625, 20.51019859314, 0, 91.499633789063, 90.7470703125);
    CreateDynamicObject(1219, 1488.7401123047, -1772.6640625, 20.488752365112, 0, 91.499633789063, 90.7470703125);
    CreateDynamicObject(1219, 1486.6020507813, -1772.6640625, 20.560592651367, 0, 91.499633789063, 90.7470703125);
    CreateDynamicObject(1219, 1483.3515625, -1772.6640625, 19.94331741333, 0, 91.499633789063, 90.7470703125);
    CreateDynamicObject(1219, 1483.271484375, -1772.4383544922, 19.157583236694, 0, 91.499633789063, 90.7470703125);
    CreateDynamicObject(1219, 1481.2004394531, -1772.6640625, 19.126222610474, 0, 91.499633789063, 90.7470703125);
    CreateDynamicObject(1219, 1481.1512451172, -1772.6242675781, 19.978216171265, 0, 91.499633789063, 90.7470703125);
    CreateDynamicObject(1219, 1478.9315185547, -1772.6640625, 18.398181915283, 0, 91.499633789063, 90.7470703125);
    CreateDynamicObject(1219, 1479.0534667969, -1772.6640625, 20.117765426636, 0, 91.499633789063, 90.7470703125);
    CreateDynamicObject(1219, 1475.8176269531, -1772.6640625, 18.707962036133, 0, 91.499633789063, 90.7470703125);
    CreateDynamicObject(1219, 1473.7373046875, -1772.6640625, 18.670816421509, 0, 91.499633789063, 90.7470703125);
    CreateDynamicObject(1219, 1471.4291992188, -1772.6640625, 18.532817840576, 0, 91.499633789063, 90.7470703125);
    CreateDynamicObject(1219, 1475.7224121094, -1772.6173095703, 20.426244735718, 0, 91.499633789063, 90.7470703125);
    CreateDynamicObject(1219, 1473.6687011719, -1772.6640625, 20.390331268311, 0, 91.499633789063, 90.7470703125);
    CreateDynamicObject(1219, 1471.3892822266, -1772.6640625, 20.25234413147, 0, 91.499633789063, 90.7470703125);
    CreateDynamicObject(1219, 1518.0627441406, -1594.7442626953, 12.745735168457, 0, 0, 0);
    CreateDynamicObject(3594, 1525.7874755859, -1617.8093261719, 13.013989448547, 0, 0, 11.242309570313);
    CreateDynamicObject(12957, 1807.4979248047, -1734.9854736328, 13.268824577332, 0, 0, 131.24816894531);
    CreateDynamicObject(3594, 1687.3486328125, -1735.7689208984, 13.022953987122, 0, 0, 64.48974609375);
    CreateDynamicObject(3594, 1717.6655273438, -1733.3231201172, 13.013989448547, 0, 0, 320.98974609375);
    CreateDynamicObject(12957, 1516.8288574219, -1734.2550048828, 13.261029243469, 0, 0, 215.99816894531);
    CreateDynamicObject(3594, 1491.2038574219, -1730.3917236328, 13.013989448547, 0, 0, 58.480224609375);
    CreateDynamicObject(12957, 1484.7067871094, -1765.3548583984, 18.673973083496, 0, 0, 215.99670410156);
    CreateDynamicObject(3594, 1462.2999267578, -1734.2463378906, 13.013989448547, 0, 0, 332.23025512695);
    CreateDynamicObject(827, 1285.5834960938, -1562.1989746094, 16.345455169678, 0, 0, 0);
    CreateDynamicObject(827, 1287.9499511719, -1566.9533691406, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1289.8082275391, -1558.3388671875, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1295.2856445313, -1556.4777832031, 16.181259155273, 0, 0, 0);
    CreateDynamicObject(827, 1294.3215332031, -1561.7907714844, 16.181259155273, 0, 0, 0);
    CreateDynamicObject(827, 1301.0521240234, -1555.1759033203, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1293.9410400391, -1567.1076660156, 16.181259155273, 0, 0, 0);
    CreateDynamicObject(827, 1291.2568359375, -1562.0234375, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1298.2637939453, -1564.5787353516, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1300.6156005859, -1559.6217041016, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1289.9322509766, -1571.3298339844, 16.181259155273, 0, 0, 0);
    CreateDynamicObject(827, 1311.6848144531, -1541.2094726563, 16.181259155273, 0, 0, 0);
    CreateDynamicObject(827, 1287.1315917969, -1574.9766845703, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1291.1979980469, -1579.478515625, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1296.9735107422, -1580.5552978516, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1309.0795898438, -1608.8958740234, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1316.1253662109, -1610.9853515625, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1308.4251708984, -1602.3726806641, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1293.7319335938, -1598.7360839844, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1299.384765625, -1603.7059326172, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1293.8107910156, -1605.0883789063, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1297.1455078125, -1603.5440673828, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1292.4262695313, -1611.4466552734, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1300.3621826172, -1610.3299560547, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1297.4240722656, -1613.1002197266, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1293.4443359375, -1622.0065917969, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1297.9230957031, -1622.0700683594, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1301.8165283203, -1620.8134765625, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1307.6618652344, -1606.0865478516, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1305.5623779297, -1594.1735839844, 17.79914855957, 0, 0, 0);
    CreateDynamicObject(827, 1312.9017333984, -1592.3830566406, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1315.6909179688, -1615.8641357422, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1308.9926757813, -1615.3198242188, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1315.0318603516, -1620.3676757813, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1308.8352050781, -1621.6656494141, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1314.525390625, -1628.2331542969, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1289.9530029297, -1605.2950439453, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1288.6597900391, -1618.5567626953, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1288.9183349609, -1634.4670410156, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1299.9788818359, -1632.7064208984, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1294.4488525391, -1633.2028808594, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1312.8715820313, -1646.501953125, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1311.8931884766, -1642.0941162109, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1308.4084472656, -1638.6793212891, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1308.4138183594, -1630.9731445313, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1300.8316650391, -1637.9642333984, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1294.9938964844, -1638.2158203125, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1301.1490478516, -1627.6232910156, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1294.4116210938, -1626.7794189453, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1310.3209228516, -1632.9265136719, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1317.5776367188, -1633.2000732422, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1319.1907958984, -1624.8352050781, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1318.8719482422, -1639.2554931641, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1312.5895996094, -1654.2618408203, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1294.501953125, -1655.76953125, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1302.0474853516, -1661.8840332031, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1292.5906982422, -1667.8634033203, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1296.0062255859, -1672.4633789063, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1299.2242431641, -1673.2681884766, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1300.2042236328, -1681.138671875, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1300.8023681641, -1673.6669921875, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1302.0278320313, -1688.7626953125, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1317.7005615234, -1691.380859375, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1318.8103027344, -1699.951171875, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1314.7001953125, -1697.1458740234, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1318.8302001953, -1689.2667236328, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1314.2801513672, -1690.9030761719, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1310.4266357422, -1689.2935791016, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1302.5732421875, -1682.23828125, 28.290927886963, 0, 0, 0);
    CreateDynamicObject(827, 1308.6716308594, -1692.2961425781, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1295.8363037109, -1680.103515625, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1302.0703125, -1697.0701904297, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1303.5428466797, -1706.9337158203, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1316.8493652344, -1709.0052490234, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1315.3916015625, -1716.3135986328, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1297.0534667969, -1697.1696777344, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1297.4724121094, -1689.9116210938, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1294.0627441406, -1688.2620849609, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1293.0478515625, -1698.3685302734, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1296.2863769531, -1708.7342529297, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1317.0830078125, -1527.3892822266, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1304.8240966797, -1516.5581054688, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1316.8480224609, -1484.0437011719, -1.3636436462402, 0, 0, 0);
    CreateDynamicObject(827, 1314.43359375, -1512.8470458984, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1313.1624755859, -1526.1768798828, 16.329734802246, 0, 0, 0);
    CreateDynamicObject(827, 1309.3197021484, -1542.3083496094, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1317.6658935547, -1533.6292724609, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1324.3166503906, -1541.689453125, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1328.7938232422, -1525.7431640625, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1332.341796875, -1514.4927978516, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1327.4244384766, -1513.0129394531, 16.181262969971, 0, 0, 0);
    CreateDynamicObject(827, 1310.9453125, -1506.6500244141, 16.181262969971, 0, 0, 0);
    CreateDynamicObject(827, 1336.5614013672, -1487.1251220703, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1332.0959472656, -1467.0675048828, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1339.2950439453, -1495.8753662109, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1327.7124023438, -1496.7703857422, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1333.6137695313, -1478.1322021484, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1342.2966308594, -1480.6195068359, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1334.9442138672, -1496.4937744141, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1336.970703125, -1472.3448486328, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1340.9614257813, -1467.7083740234, 16.199104309082, 0, 0, 0);
    CreateDynamicObject(827, 1346.5006103516, -1456.8016357422, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1332.771484375, -1449.5223388672, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1326.8291015625, -1457.8853759766, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1326.9299316406, -1465.3988037109, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1336.8186035156, -1443.7978515625, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1342.2652587891, -1442.2557373047, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1353.8453369141, -1449.3665771484, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1351.0007324219, -1442.7097167969, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1358.3840332031, -1444.2132568359, 16.181262969971, 0, 0, 0);
    CreateDynamicObject(827, 1337.5958251953, -1435.2886962891, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1355.3966064453, -1436.6673583984, 16.181262969971, 0, 0, 0);
    CreateDynamicObject(827, 1357.66015625, -1468.4901123047, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1355.3458251953, -1477.890625, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1360.5260009766, -1458.7966308594, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1362.6680908203, -1444.8511962891, 16.329734802246, 0, 0, 0);
    CreateDynamicObject(827, 1362.2081298828, -1435.0780029297, 16.329734802246, 0, 0, 0);
    CreateDynamicObject(827, 1345.3125, -1433.00390625, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1351.4298095703, -1430.8466796875, 16.263301849365, 0, 0, 0);
    CreateDynamicObject(827, 1347.1997070313, -1439.8122558594, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1339.8852539063, -1427.4665527344, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1358.1762695313, -1428.4202880859, 16.181262969971, 0, 0, 0);
    CreateDynamicObject(827, 1340.3973388672, -1390.2847900391, 16.23543548584, 0, 0, 0);
    CreateDynamicObject(827, 1363.6663818359, -1376.9802246094, 16.424955368042, 0, 0, 0);
    CreateDynamicObject(827, 1364.8814697266, -1366.6690673828, 16.367301940918, 0, 0, 0);
    CreateDynamicObject(827, 1364.7757568359, -1358.7581787109, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1362.3884277344, -1352.9610595703, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1359.9399414063, -1358.3321533203, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1360.1063232422, -1365.9860839844, 16.20832824707, 0, 0, 0);
    CreateDynamicObject(827, 1360.5289306641, -1375.1485595703, 16.262027740479, 0, 0, 0);
    CreateDynamicObject(827, 1358.6236572266, -1353.8400878906, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1355.3853759766, -1358.7690429688, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1351.8330078125, -1381.326171875, 16.276815414429, 0, 0, 0);
    CreateDynamicObject(827, 1355.4931640625, -1368.2563476563, 16.213819503784, 0, 0, 0);
    CreateDynamicObject(827, 1355.7999267578, -1375.8134765625, 16.265926361084, 0, 0, 0);
    CreateDynamicObject(827, 1345.5540771484, -1361.3686523438, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1346.4412841797, -1368.0012207031, 16.220138549805, 0, 0, 0);
    CreateDynamicObject(827, 1346.5123291016, -1376.7459716797, 16.271389007568, 0, 0, 0);
    CreateDynamicObject(827, 1352.2454833984, -1375.2960205078, 16.314615249634, 0, 0, 0);
    CreateDynamicObject(827, 1353.6156005859, -1354.7661132813, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1347.4350585938, -1355.5699462891, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1342.2795410156, -1356.0778808594, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1336.5, -1358.4205322266, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1340.5234375, -1363.3919677734, 16.18531036377, 0, 0, 0);
    CreateDynamicObject(827, 1340.7882080078, -1371.1505126953, 16.238595962524, 0, 0, 0);
    CreateDynamicObject(827, 1341.4041748047, -1379.9228515625, 16.290008544922, 0, 0, 0);
    CreateDynamicObject(827, 1336.2487792969, -1368.1569824219, 16.368934631348, 0, 0, 0);
    CreateDynamicObject(827, 1334.9868164063, -1376.9493408203, 16.432573318481, 0, 0, 0);
    CreateDynamicObject(827, 1331.8441162109, -1384.5772705078, 16.713333129883, 0, 0, 0);
    CreateDynamicObject(827, 1329.2811279297, -1394.7355957031, 16.147943496704, 0, 0, 0);
    CreateDynamicObject(827, 1326.2570800781, -1407.380859375, 16.121192932129, 0, 0, 0);
    CreateDynamicObject(827, 1365.1162109375, -1350.2634277344, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1364.1809082031, -1334.7938232422, 16.329730987549, 0, 0, 0);
    CreateDynamicObject(827, 1368.859375, -1319.697265625, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1364.5258789063, -1328.2139892578, 16.329730987549, 0, 0, 0);
    CreateDynamicObject(827, 1363.6551513672, -1344.1549072266, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1360.1040039063, -1330.9278564453, 16.181259155273, 0, 0, 0);
    CreateDynamicObject(827, 1359.8076171875, -1338.8421630859, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1359.5772705078, -1348.9364013672, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1361.9378662109, -1340.1088867188, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1360.0012207031, -1324.7974853516, 16.181259155273, 0, 0, 0);
    CreateDynamicObject(827, 1357.6710205078, -1320.8503417969, 16.181259155273, 0, 0, 0);
    CreateDynamicObject(827, 1353.8696289063, -1324.9956054688, 16.181259155273, 0, 0, 0);
    CreateDynamicObject(827, 1356.572265625, -1329.3347167969, 16.181259155273, 0, 0, 0);
    CreateDynamicObject(827, 1352.5334472656, -1332.7514648438, 16.189714431763, 0, 0, 0);
    CreateDynamicObject(827, 1356.9188232422, -1336.5600585938, 16.181259155273, 0, 0, 0);
    CreateDynamicObject(827, 1353.666015625, -1344.1403808594, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1356.5334472656, -1350.7700195313, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1353.0043945313, -1319.6862792969, 16.181259155273, 0, 0, 0);
    CreateDynamicObject(827, 1348.4731445313, -1320.0518798828, 16.286777496338, 0, 0, 0);
    CreateDynamicObject(827, 1345.8551025391, -1328.3059082031, 16.181259155273, 0, 0, 0);
    CreateDynamicObject(827, 1346.3343505859, -1336.1635742188, 16.181259155273, 0, 0, 0);
    CreateDynamicObject(827, 1344.3321533203, -1322.2546386719, 16.181259155273, 0, 0, 0);
    CreateDynamicObject(827, 1341.3181152344, -1320.1268310547, 16.181259155273, 0, 0, 0);
    CreateDynamicObject(827, 1338.0069580078, -1328.1791992188, 16.181259155273, 0, 0, 0);
    CreateDynamicObject(827, 1340.5668945313, -1335.3489990234, 16.181259155273, 0, 0, 0);
    CreateDynamicObject(827, 1341.5264892578, -1329.5299072266, 16.181259155273, 0, 0, 0);
    CreateDynamicObject(827, 1347.9788818359, -1287.2648925781, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1345.8278808594, -1281.8201904297, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1339.7543945313, -1285.2238769531, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1342.3214111328, -1290.28125, 16.439239501953, 0, 0, 0);
    CreateDynamicObject(827, 1335.9206542969, -1290.5588378906, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1335.8430175781, -1299.3565673828, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1340.5220947266, -1298.3349609375, 16.339237213135, 0, 0, 0);
    CreateDynamicObject(827, 1344.9353027344, -1293.9123535156, 16.34098815918, 0, 0, 0);
    CreateDynamicObject(827, 1346.5710449219, -1300.349609375, 16.244155883789, 0, 0, 0);
    CreateDynamicObject(827, 1340.5295410156, -1307.8901367188, 16.263145446777, 0, 0, 0);
    CreateDynamicObject(827, 1334.9544677734, -1310.0031738281, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1347.1408691406, -1311.2099609375, 16.210424423218, 0, 0, 0);
    CreateDynamicObject(827, 1343.1765136719, -1310.8579101563, 16.226184844971, 0, 0, 0);
    CreateDynamicObject(827, 1352.5668945313, -1310.5310058594, 16.184185028076, 0, 0, 0);
    CreateDynamicObject(827, 1348.0045166016, -1305.5153808594, 16.219387054443, 0, 0, 0);
    CreateDynamicObject(827, 1337.2258300781, -1281.9053955078, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1332.4102783203, -1280.2315673828, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1332.6127929688, -1285.9328613281, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1334.1607666016, -1275.6687011719, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1339.7170410156, -1276.8653564453, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1335.7574462891, -1270.2469482422, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1340.9222412109, -1270.7485351563, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1344.2950439453, -1279.3641357422, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1346.6661376953, -1273.9936523438, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1353.3494873047, -1275.857421875, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1348.8278808594, -1277.1146240234, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1359.3516845703, -1278.1140136719, 16.167411804199, 0, 0, 0);
    CreateDynamicObject(827, 1337.1154785156, -1266.8597412109, 17.20040512085, 0, 0, 0);
    CreateDynamicObject(827, 1335.4835205078, -1260.4970703125, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1344.8804931641, -1268.3942871094, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1341.6240234375, -1264.8760986328, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1339.7265625, -1259.1981201172, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1356.5811767578, -1262.7669677734, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(827, 1347.6719970703, -1249.4235839844, 16.181198120117, 0, 0, 0);
    CreateDynamicObject(827, 1360.8518066406, -1109.2794189453, 26.577545166016, 0, 0, 0);
    CreateDynamicObject(827, 1355.2541503906, -1109.2397460938, 26.574710845947, 0, 0, 0);
    CreateDynamicObject(827, 1360.7427978516, -1124.4235839844, 26.475486755371, 0, 0, 0);
    CreateDynamicObject(827, 1354.1329345703, -1128.556640625, 26.460975646973, 0, 0, 0);
    CreateDynamicObject(827, 1355.8354492188, -1185.1771240234, 24.241046905518, 0, 0, 0);
    CreateDynamicObject(827, 1345.5874023438, -1168.3950195313, 26.502246856689, 0, 0, 0);
    CreateDynamicObject(827, 1339.3773193359, -1145.0112304688, 26.44690322876, 0, 0, 0);
    CreateDynamicObject(827, 1354.1064453125, -1166.1644287109, 26.573051452637, 0, 0, 0);
    CreateDynamicObject(827, 1362.9267578125, -1173.0272216797, 26.42643737793, 0, 0, 0);
    CreateDynamicObject(827, 1356.2291259766, -1175.6872558594, 25.963188171387, 0, 0, 0);
    CreateDynamicObject(827, 1362.0589599609, -1186.5749511719, 23.917789459229, 0, 0, 0);
    CreateDynamicObject(827, 1342.0520019531, -1181.0710449219, 25.087749481201, 0, 0, 0);
    CreateDynamicObject(827, 1337.0750732422, -1176.4622802734, 25.878463745117, 0, 0, 0);
    CreateDynamicObject(827, 1320.1953125, -1816.2542724609, 16.33752822876, 0, 0, 0);
    CreateDynamicObject(827, 1295.4196777344, -1810.7142333984, 16.17346572876, 0, 0, 0);
    CreateDynamicObject(3279, 1567.6710205078, -1708.4970703125, 27.3948097229, 0, 0, 0);


	//zombie

	CreateObject(18862, 1551.01721, -1696.65308, 15.32040,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1552.28479, -1685.83350, 15.32040,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1541.81567, -1693.03723, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1540.21387, -1681.76770, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1545.21753, -1672.34277, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1550.55981, -1666.10608, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1541.42139, -1646.86487, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1548.85144, -1649.70288, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1548.85144, -1649.70288, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1541.99597, -1658.93872, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1529.47656, -1653.29150, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1529.38562, -1630.66272, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1529.69531, -1614.64124, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1545.07373, -1630.14978, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1535.31604, -1671.98071, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1528.74524, -1689.71814, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1530.64368, -1705.41382, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1530.49219, -1716.43396, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1523.74731, -1656.93823, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1521.64819, -1648.17285, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1521.26270, -1638.06189, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1521.92761, -1629.35913, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1536.92834, -1614.22766, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1496.85559, -1687.50439, 15.32040,   0.00000, 0.00000, 0.00000);
	CreateObject(3866, 1464.10193, -1564.81702, 20.08680,   0.00000, 0.00000, 90.00000);
	CreateObject(3869, 1505.40454, -1567.06470, 20.08680,   -3.00000, -11.00000, 90.00000);
	CreateObject(3866, 1472.53223, -1544.83032, 20.08680,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1480.31506, -1576.85376, 12.51405,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1488.87610, -1576.63464, 12.51405,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1494.93640, -1575.30103, 12.51405,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1475.04358, -1572.64490, 12.51405,   0.00000, 0.00000, 0.00000);
	CreateObject(3869, 1500.93384, -1541.16687, 20.08680,   -3.00000, -11.00000, 0.00000);
	CreateObject(874, 1521.83081, -1689.77722, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1523.56726, -1671.18311, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1546.77087, -1715.79102, 12.53177,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1479.03235, -1686.40369, 15.32040,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1483.35913, -1736.03748, 12.94380,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1490.89209, -1728.89697, 12.94380,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1498.24438, -1731.87695, 12.94380,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1499.24011, -1742.50513, 12.94380,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1507.72437, -1750.15234, 12.94380,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1509.59473, -1741.22510, 12.94380,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1508.71155, -1732.70654, 12.94380,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1516.32373, -1730.46619, 12.94380,   0.00000, 0.00000, 45.00000);
	CreateObject(874, 1516.51880, -1722.74255, 12.94380,   0.00000, 0.00000, 45.00000);
	CreateObject(874, 1519.58838, -1715.53406, 12.94380,   0.00000, 0.00000, 45.00000);
	CreateObject(874, 1519.88635, -1707.18579, 12.94380,   0.00000, 0.00000, 45.00000);
	CreateObject(874, 1520.24207, -1698.98242, 12.94380,   0.00000, 0.00000, 45.00000);
	CreateObject(874, 1509.24097, -1715.06152, 13.34380,   0.00000, 0.00000, 45.00000);
	CreateObject(874, 1510.59363, -1706.48889, 13.34380,   0.00000, 0.00000, 45.00000);
	CreateObject(874, 1513.42236, -1697.12402, 13.34380,   0.00000, 0.00000, -45.00000);
	CreateObject(874, 1509.91223, -1687.37891, 13.34380,   0.00000, 0.00000, -45.00000);
	CreateObject(874, 1516.07446, -1678.64612, 13.34380,   0.00000, 0.00000, -45.00000);
	CreateObject(874, 1513.77356, -1671.08960, 13.34380,   0.00000, 0.00000, -45.00000);
	CreateObject(4206, 1544.38135, -1731.95422, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1521.08484, -1733.72083, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1500.86755, -1732.69604, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1477.92651, -1732.42615, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1470.89441, -1742.41675, 12.64840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1490.51416, -1742.23853, 12.64840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1490.51416, -1742.23853, 12.64840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1456.12122, -1734.24915, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1441.47974, -1734.76355, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1432.36487, -1726.05823, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1430.14270, -1706.70349, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(625, 1477.89880, -1680.75708, 10.29530,   356.85840, 0.00000, 3.14160);
	CreateObject(712, 1480.64270, -1666.49402, 9.45780,   356.85840, 0.00000, 3.14160);
	CreateObject(712, 1473.34265, -1666.64941, 9.45780,   3.14160, 0.00000, 45.38390);
	CreateObject(684, 1496.19226, -1671.70251, 13.45780,   3.14160, 0.00000, 42.78910);
	CreateObject(658, 1486.00427, -1701.54700, 13.02830,   1.00000, 84.00000, -40.00000);
	CreateObject(658, 1516.66760, -1714.63391, 13.22830,   1.00000, 91.00000, -18.00000);
	CreateObject(874, 1476.30029, -1733.51379, 12.94380,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1568.67688, -1752.24707, 12.54340,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1563.26550, -1737.72778, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1566.57373, -1769.74548, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1546.08545, -1660.95959, 12.56840,   0.00000, 0.00000, 0.00000);
	CreateObject(658, 1486.83594, -1606.95789, 13.02830,   1.00000, 84.00000, -40.00000);
	CreateObject(658, 1445.77222, -1720.28943, 13.02830,   1.00000, 84.00000, 40.00000);
	CreateObject(10984, 1469.02551, -1576.87756, 12.51405,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1461.78625, -1578.97888, 12.51410,   0.00000, 0.00000, 40.00000);
	CreateObject(3866, 1490.96106, -1556.57349, 9.00680,   0.00000, 40.00000, 0.00000);
	CreateObject(10984, 1488.68665, -1558.10461, 12.51405,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1485.84009, -1566.53748, 12.51405,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1495.55823, -1568.71887, 15.32040,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1478.13672, -1563.09680, 15.32040,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1471.45349, -1575.69824, 15.32040,   0.00000, 0.00000, 0.00000);
	CreateObject(4113, 1347.91223, -1555.83679, 30.05360,   10.13600, 24.43500, 0.00000);
	CreateObject(10984, 1352.05457, -1570.83179, 12.53177,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1345.74329, -1569.80212, 12.53177,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1338.28577, -1564.33020, 12.53177,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1317.53296, -1559.13940, 12.53177,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1319.09644, -1548.91467, 12.53177,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1320.65210, -1537.55042, 12.53177,   0.00000, 0.00000, 0.00000);
	CreateObject(3866, 1355.76367, -1559.91919, 69.86180,   23.71100, 0.18100, 81.67400);
	CreateObject(3866, 1372.47034, -1563.29236, 64.97480,   -20.81500, 1.99100, 257.64899);
	CreateObject(10984, 1371.35425, -1567.40137, 59.04880,   7.42100, 9.59300, -20.99600);
	CreateObject(10984, 1374.14844, -1560.56323, 59.04880,   7.42100, 9.59300, 0.00000);
	CreateObject(18862, 1453.64233, -1572.96228, 17.85440,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1519.84509, -1601.25195, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1547.92761, -1613.54712, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1560.52417, -1612.77551, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1569.09045, -1628.99023, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1575.56641, -1613.41357, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1530.13000, -1632.88428, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1536.76770, -1628.11877, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1544.62585, -1626.45337, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1551.66980, -1608.56775, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1548.59216, -1618.36438, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1548.59216, -1618.36438, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1561.32751, -1608.06860, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1563.47522, -1619.53430, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1567.68958, -1627.22571, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1573.62708, -1609.99500, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1591.84106, -1611.88440, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1589.28174, -1625.63184, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(3869, 1514.12268, -1546.64636, 20.08680,   -3.00000, -11.00000, 90.00000);
	CreateObject(734, 1457.43933, -1620.33350, 11.24550,   0.00000, 0.00000, 0.00000);
	CreateObject(734, 1500.57190, -1624.26477, 11.24550,   0.00000, 0.00000, 0.00000);
	CreateObject(735, 1478.74658, -1668.12488, 10.52150,   0.00000, 0.00000, 0.00000);
	CreateObject(735, 1461.34058, -1709.90906, -8.48350,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1369.20703, -1566.52600, 8.36880,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1373.31824, -1555.45056, 8.36880,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1375.65479, -1546.46399, 8.36880,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1380.45801, -1537.78833, 8.36880,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1375.98560, -1548.99597, 9.45480,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1373.47021, -1558.62915, 9.81680,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1389.53174, -1566.82898, 13.61780,   0.00000, 0.00000, 80.00000);
	CreateObject(3866, 1394.77563, -1564.33862, 10.13180,   46.74100, 0.54300, 80.95000);
	CreateObject(3866, 1387.13672, -1581.23572, 9.58880,   46.74100, 0.54300, 45.95000);
	CreateObject(10984, 1324.50781, -1564.55981, 12.53177,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1329.07581, -1566.55310, 12.53177,   0.00000, 0.00000, 0.00000);
	CreateObject(3866, 1368.15527, -1784.12842, 19.00500,   0.00000, 0.00000, -90.00000);
	CreateObject(3866, 1365.48157, -1808.95081, 20.08680,   0.00000, 0.00000, 180.00000);
	CreateObject(3866, 1365.78137, -1805.96265, 20.08680,   0.00000, 0.00000, 90.00000);
	CreateObject(4010, 1350.75781, -1802.28125, 12.69530,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1362.56799, -1814.94104, 12.47355,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1377.64624, -1815.04590, 12.47355,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1377.59839, -1804.24963, 12.47355,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1371.00830, -1800.42139, 12.47355,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1371.11621, -1778.91565, 15.59200,   0.00000, 0.00000, 0.00000);
	CreateObject(3866, 1368.31909, -1757.35645, 13.57500,   0.00000, 0.00000, -90.00000);
	CreateObject(10984, 1377.98364, -1765.15454, 12.47355,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1372.33789, -1743.83386, 12.47355,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1380.51575, -1750.36816, 12.47355,   0.00000, 0.00000, 0.00000);
	CreateObject(4002, 1482.54700, -1784.97144, -2.98260,   345.00000, -11.00000, 18.00000);
	CreateObject(10984, 1500.59070, -1753.21240, 12.51425,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1492.56555, -1753.43005, 12.51425,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1485.18103, -1753.59912, 12.51425,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1474.99292, -1756.17920, 12.51425,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1467.56311, -1757.76758, 12.51425,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1461.27515, -1753.63538, 12.51425,   0.00000, 0.00000, 0.00000);
	CreateObject(3887, 1518.70776, -1761.60168, 20.28530,   0.00000, 0.00000, -90.00000);
	CreateObject(3887, 1477.23022, -1761.62097, 20.28530,   0.00000, 0.00000, -90.00000);
	CreateObject(3887, 1447.38879, -1761.49487, 20.28530,   0.00000, 0.00000, -90.00000);
	CreateObject(3887, 1428.78955, -1780.49426, 20.28530,   0.00000, 0.00000, 0.00000);
	CreateObject(3887, 1428.72803, -1803.77148, 20.28530,   0.00000, 0.00000, 0.00000);
	CreateObject(3887, 1447.17615, -1820.65308, 20.28530,   0.00000, 0.00000, 90.00000);
	CreateObject(3887, 1485.76953, -1820.50708, 20.28530,   0.00000, 0.00000, 90.00000);
	CreateObject(3887, 1522.11975, -1819.97583, 20.28530,   0.00000, 0.00000, 90.00000);
	CreateObject(3887, 1540.94763, -1801.33667, 20.28530,   0.00000, 0.00000, 180.00000);
	CreateObject(3887, 1540.89685, -1782.05151, 20.28530,   0.00000, 0.00000, 180.00000);
	CreateObject(10984, 1528.69165, -1769.96082, 13.07480,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1526.98474, -1777.95776, 13.07480,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1535.64758, -1805.67480, 13.07480,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1502.10547, -1791.13733, 13.07480,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1523.24670, -1796.52979, 13.07480,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1515.05823, -1789.42310, 13.07480,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1533.55164, -1792.15723, 13.07480,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1521.25659, -1816.04919, 13.07480,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1549.83472, -1809.55481, 13.07480,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1456.83948, -1794.38391, 13.07480,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1481.59021, -1813.26086, 13.07480,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1501.28162, -1804.35022, 13.07480,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1511.90271, -1805.12866, 13.07480,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1525.20740, -1805.57788, 17.13040,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1514.84021, -1761.43127, 17.31140,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1553.16089, -1771.82629, 17.31140,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1492.40027, -1809.80725, 17.13040,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1478.78491, -1804.50281, 13.07480,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1463.30811, -1803.97998, 13.07480,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1452.82031, -1815.33215, 13.07480,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1445.05750, -1763.90955, 13.07480,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1470.21741, -1805.40454, 13.07480,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1459.15051, -1777.66870, 17.13040,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1437.64612, -1813.12537, 17.13040,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1419.22656, -1809.94263, 13.07480,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1432.10962, -1769.12866, 13.07480,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1433.88220, -1784.05762, 13.07480,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1443.49756, -1774.54468, 13.07480,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1449.37146, -1798.20508, 17.13040,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1433.71533, -1793.84351, 13.07480,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1444.57495, -1785.74060, 13.07480,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1418.37439, -1796.02832, 13.07480,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1417.43848, -1782.98340, 13.07480,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1412.69958, -1755.88342, 13.07480,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1453.73877, -1744.00952, 17.13040,   0.00000, 0.00000, 0.00000);
	CreateObject(735, 1516.37561, -1748.21008, 9.97850,   0.00000, 0.00000, 0.00000);
	CreateObject(735, 1427.51880, -1748.37415, 9.97850,   0.00000, 0.00000, 0.00000);
	CreateObject(1260, 1483.56897, -1859.59326, 18.52310,   25.00000, 4.00000, 47.00000);
	CreateObject(3866, 1545.78784, -1851.28308, 20.08680,   0.00000, 0.00000, 180.00000);
	CreateObject(3866, 1518.00916, -1851.21252, 20.08680,   0.00000, 0.00000, 180.00000);
	CreateObject(3866, 1517.62744, -1851.71985, 20.08680,   0.00000, 0.00000, 0.00000);
	CreateObject(3866, 1483.18518, -1851.73071, 20.08680,   0.00000, 0.00000, 0.00000);
	CreateObject(3866, 1455.96265, -1851.56104, 20.08680,   0.00000, 0.00000, 180.00000);
	CreateObject(3887, 1427.58582, -1853.34802, 20.28530,   0.00000, 0.00000, 90.00000);
	CreateObject(3887, 1532.70032, -1847.44580, 20.28530,   0.00000, 0.00000, -90.00000);
	CreateObject(873, 1529.05493, -1738.94360, 12.94380,   0.00000, 0.00000, 45.00000);
	CreateObject(873, 1530.17114, -1728.85730, 12.94380,   0.00000, 0.00000, 45.00000);
	CreateObject(874, 1544.82129, -1734.27759, 12.94380,   0.00000, 0.00000, 185.00000);
	CreateObject(874, 1542.03247, -1741.37952, 12.94380,   0.00000, 0.00000, 0.00000);
	CreateObject(873, 1542.15637, -1721.63538, 12.94380,   0.00000, 0.00000, 45.00000);
	CreateObject(873, 1555.09570, -1721.43323, 12.94380,   0.00000, 0.00000, 45.00000);
	CreateObject(874, 1555.03137, -1740.10352, 12.94380,   0.00000, 0.00000, 185.00000);
	CreateObject(874, 1529.75903, -1597.95483, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1520.64136, -1591.27856, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1511.40564, -1590.75452, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1508.66943, -1595.59082, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1502.46814, -1585.25525, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1501.14490, -1594.47876, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1512.47192, -1578.39307, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1493.09180, -1597.75574, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1492.49536, -1585.00317, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1484.94861, -1591.25684, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1478.80762, -1597.09753, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1473.52332, -1585.11316, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1465.31152, -1591.57043, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1487.06860, -1602.91968, 12.52865,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1481.65454, -1724.60266, 12.94380,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1453.51392, -1733.02661, 12.94380,   0.00000, 0.00000, 0.00000);
	CreateObject(1267, 1420.45862, -1722.98535, 21.40330,   11.00000, 11.00000, 0.00000);
	CreateObject(3887, 1331.33569, -1769.52893, 20.28530,   0.00000, 0.00000, 0.00000);
	CreateObject(3887, 1331.11572, -1811.86877, 20.28530,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1344.42773, -1819.04028, 12.47355,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1336.71252, -1819.59302, 12.47355,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1339.00134, -1811.72876, 12.47355,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1334.37231, -1804.77112, 12.47355,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1334.67126, -1794.76331, 12.47355,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1334.55420, -1778.84460, 12.47355,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1430.37927, -1684.97949, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1430.11023, -1666.15540, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1416.67957, -1653.62671, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1398.42761, -1650.93323, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1379.26367, -1650.08813, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1377.22449, -1655.38037, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1428.17676, -1641.59973, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1427.73157, -1622.37329, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1429.62427, -1600.34180, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1448.19312, -1589.48169, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1470.32739, -1594.04858, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1494.08716, -1591.55139, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1517.60254, -1593.34717, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1537.78748, -1585.45020, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1537.78955, -1596.19360, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(1260, 1546.77112, -1611.40466, 17.30980,   0.00000, 40.00000, -40.00000);
	CreateObject(734, 1305.04260, -1839.68628, 10.52150,   0.00000, 0.00000, 0.00000);
	CreateObject(735, 1304.58777, -1816.01025, 10.52150,   0.00000, 0.00000, 0.00000);
	CreateObject(3593, 1431.13477, -1708.78918, 12.88390,   0.00000, 0.00000, 69.00000);
	CreateObject(3594, 1455.74646, -1728.78186, 13.06490,   0.00000, 0.00000, 69.00000);
	CreateObject(3593, 1499.30774, -1733.11353, 12.88390,   0.00000, 0.00000, 185.00000);
	CreateObject(3594, 1541.12646, -1696.09973, 12.88390,   0.00000, 0.00000, 120.00000);
	CreateObject(3866, 1405.21301, -1631.21753, 20.08680,   0.00000, 0.00000, 180.00000);
	CreateObject(3866, 1408.02747, -1628.33325, 20.08680,   0.00000, 0.00000, 90.00000);
	CreateObject(3866, 1404.65039, -1620.84485, 17.91480,   -15.00000, -25.00000, -25.00000);
	CreateObject(10984, 1421.40967, -1622.58350, 12.51410,   0.00000, 0.00000, 40.00000);
	CreateObject(10984, 1406.75269, -1635.23083, 11.97110,   0.00000, 0.00000, 40.00000);
	CreateObject(10984, 1398.27405, -1613.57922, 12.51410,   0.00000, 0.00000, 40.00000);
	CreateObject(18862, 1401.27271, -1636.61816, 16.58740,   0.00000, 0.00000, 0.00000);
	CreateObject(4005, 1404.04370, -1681.30591, 15.22990,   337.00000, 0.00000, 3.00000);
	CreateObject(10984, 1415.83081, -1662.32983, 12.51410,   0.00000, 0.00000, 40.00000);
	CreateObject(10984, 1397.00732, -1658.39917, 12.51410,   0.00000, 0.00000, 40.00000);
	CreateObject(10984, 1407.06165, -1658.40674, 12.69510,   0.00000, 0.00000, 40.00000);
	CreateObject(4206, 1431.02649, -1585.58191, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1432.33008, -1571.14771, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1427.19653, -1557.22595, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(3991, 1613.86523, -1726.23877, 12.14420,   -10.67900, 0.00000, 0.00000);
	CreateObject(10984, 1624.96301, -1792.95142, 25.69120,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1613.81824, -1795.12146, 25.69120,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1608.60059, -1794.44812, 25.87220,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1619.57227, -1791.41394, 25.87220,   -4.00000, -4.00000, 25.00000);
	CreateObject(10984, 1589.66516, -1725.58545, 12.33373,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1596.32532, -1722.34583, 12.33373,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1604.92126, -1722.73462, 12.33373,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1613.08191, -1723.22717, 12.33373,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1621.44836, -1724.73291, 12.33373,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1628.74194, -1723.45679, 12.33373,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1582.01062, -1728.15942, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1598.61975, -1730.48999, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1412.92761, -1733.86023, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1409.58508, -1747.46021, 13.07480,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1416.79785, -1743.03394, 13.07480,   0.00000, 0.00000, 0.00000);
	CreateObject(4011, 1337.81580, -1643.70288, 6.35910,   0.00000, -18.00000, 0.00000);
	CreateObject(10984, 1324.84338, -1636.82153, 12.33819,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1327.95435, -1627.87305, 12.33819,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1324.37952, -1646.81860, 12.51920,   0.00000, 0.00000, 59.36700);
	CreateObject(10984, 1328.69348, -1655.33093, 12.51920,   0.00000, 0.00000, 59.36700);
	CreateObject(10984, 1595.89893, -1556.96008, 28.52975,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1607.80420, -1557.81604, 28.52975,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1563.00378, -1558.72070, 29.43480,   0.00000, 0.00000, 0.00000);
	CreateObject(4129, 1594.50610, -1602.21960, 17.08410,   13.57500, 0.00000, 0.00000);
	CreateObject(10984, 1589.48413, -1621.80627, 12.50372,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1598.80359, -1621.68054, 12.50372,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1606.03320, -1621.09595, 12.50372,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1618.03296, -1623.95776, 12.50372,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1611.21582, -1620.15247, 12.50372,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1622.76526, -1610.13538, 17.02870,   0.00000, 0.00000, 0.00000);
	CreateObject(18757, 1557.83447, -1675.92908, 16.99550,   0.00000, 0.00000, 0.00000);
	CreateObject(18757, 1557.83667, -1677.38550, 16.99550,   0.00000, 0.00000, 0.00000);
	CreateObject(646, 1553.29468, -1678.18591, 15.71350,   428.35339, 0.00000, 3.14160);
	CreateObject(1290, 1603.63171, -1744.97644, 16.86760,   76.00000, 91.00000, 0.00000);
	CreateObject(10984, 1624.93152, -1783.65576, 23.70020,   -5.97300, 0.00000, 0.00000);
	CreateObject(10984, 1616.71143, -1784.63684, 23.70020,   -5.97300, 0.00000, 0.00000);
	CreateObject(10984, 1610.42493, -1785.49109, 23.70020,   -5.97300, 0.00000, 0.00000);
	CreateObject(3887, 1587.56165, -1801.67126, 18.29430,   0.00000, -25.00000, 0.00000);
	CreateObject(3887, 1589.26709, -1832.15771, 15.39830,   0.00000, 18.00000, 0.00000);
	CreateObject(10984, 1580.83179, -1792.30176, 13.07480,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1580.99719, -1802.21289, 13.07480,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1592.30408, -1822.26392, 13.07480,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1583.70984, -1815.20667, 13.07480,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1589.53418, -1820.17871, 13.07480,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1593.36682, -1828.13025, 13.07480,   0.00000, 0.00000, 0.00000);
	CreateObject(986, 1573.26147, -1882.43884, 14.16200,   0.00000, 0.00000, 0.00000);
	CreateObject(986, 1562.32068, -1882.40637, 14.16200,   0.00000, 0.00000, 0.00000);
	CreateObject(986, 1567.43689, -1882.86853, 12.71400,   41.99200, 0.00000, 0.00000);
	CreateObject(684, 1564.43237, -1898.11621, 12.54100,   0.00000, 0.00000, 84.00000);
	CreateObject(684, 1570.31702, -1898.04883, 12.54100,   0.00000, 0.00000, -84.00000);
	CreateObject(642, 1468.51221, -1905.51892, 22.53125,   356.85840, 0.00000, -3.14159);
	CreateObject(643, 1464.24121, -1885.98145, 21.64063,   356.85840, 0.00000, 3.14159);
	CreateObject(625, 1451.13916, -1892.87561, 22.96880,   265.00000, 0.00000, 3.00000);
	CreateObject(625, 1472.91443, -1902.04211, 21.70180,   265.00000, 0.00000, -40.00000);
	CreateObject(642, 1465.38306, -1894.87927, 22.16930,   294.05899, 0.00000, -3.00000);
	CreateObject(642, 1476.10669, -1891.03516, 22.16930,   294.05899, 0.00000, -43.00000);
	CreateObject(625, 1468.17737, -1914.08630, 23.69280,   265.00000, 0.00000, -40.00000);
	CreateObject(625, 1475.45313, -1914.12146, 23.69280,   265.00000, 0.00000, 0.00000);
	CreateObject(642, 1448.36523, -1901.62268, 22.71230,   294.05899, 0.00000, 30.00000);
	CreateObject(1260, 1650.43604, -1798.81250, 20.15210,   3.00000, 47.00000, -33.00000);
	CreateObject(987, 1700.38879, -1872.77405, 12.56602,   0.00000, 0.00000, 0.00000);
	CreateObject(987, 1712.24854, -1872.69958, 12.56602,   0.00000, 0.00000, 0.00000);
	CreateObject(987, 1724.19275, -1872.95593, 12.56602,   0.00000, 0.00000, 0.00000);
	CreateObject(987, 1700.77222, -1899.99963, 15.27200,   0.00000, 0.00000, 90.00000);
	CreateObject(987, 1700.78040, -1911.83105, 15.27200,   0.00000, 0.00000, 90.00000);
	CreateObject(987, 1700.70520, -1923.43335, 15.27200,   0.00000, 0.00000, 90.00000);
	CreateObject(987, 1700.67859, -1935.40588, 15.27200,   0.00000, 0.00000, 90.00000);
	CreateObject(987, 1700.78406, -1935.19775, 15.27200,   0.00000, 0.00000, 0.00000);
	CreateObject(987, 1717.89783, -1935.04810, 15.27200,   0.00000, 0.00000, 0.00000);
	CreateObject(987, 1710.07739, -1935.92139, 11.29000,   -24.07300, 0.00000, 0.00000);
	CreateObject(10984, 1692.29407, -1934.48499, 10.94661,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1693.28149, -1939.42163, 10.94661,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1690.53772, -1943.93335, 12.35110,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1691.67664, -1937.55383, 12.35110,   0.00000, 0.00000, 0.00000);
	CreateObject(1280, 1714.96118, -1910.53125, 12.57550,   3.00000, 47.00000, 55.00000);
	CreateObject(1280, 1725.48547, -1915.94580, 12.57550,   3.00000, 47.00000, 0.00000);
	CreateObject(1280, 1725.15332, -1900.24780, 12.57550,   3.00000, 47.00000, 10.67900);
	CreateObject(4019, 1776.69250, -1773.97778, 0.75840,   18.00000, 0.00000, 11.00000);
	CreateObject(700, 1782.44995, -1829.25488, 13.17060,   270.00000, 0.00000, 3.00000);
	CreateObject(700, 1807.79980, -1826.80945, 13.17060,   270.00000, 0.00000, 43.00000);
	CreateObject(10984, 1775.88049, -1814.07104, 12.53577,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1767.85400, -1816.26575, 12.53577,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1752.36511, -1814.83630, 12.53577,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1748.49792, -1805.32227, 12.53577,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1746.35938, -1796.75903, 12.53577,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1745.88940, -1789.24634, 12.53577,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1784.59534, -1815.93469, 15.41030,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1796.03882, -1812.13867, 15.41030,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1814.88220, -1802.25977, 15.41030,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1813.11340, -1773.31946, 15.41030,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1808.73767, -1807.61426, 12.53577,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1814.88733, -1790.93970, 12.53577,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1814.16516, -1783.62305, 12.53577,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1809.50378, -1760.85461, 12.53577,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1805.19434, -1749.00696, 12.53577,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1807.41919, -1753.64209, 12.53577,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1799.75525, -1742.35535, 12.53577,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1790.21582, -1743.56665, 12.53577,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1780.49475, -1745.15869, 12.53577,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1765.99011, -1714.67053, 12.71680,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1775.52002, -1714.06226, 13.25980,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1783.80493, -1713.60046, 13.07880,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1793.44653, -1713.56445, 13.07880,   0.00000, 0.00000, 0.00000);
	CreateObject(3866, 1786.62976, -1711.48950, 12.51610,   0.00000, 0.00000, 180.00000);
	CreateObject(3866, 1772.64478, -1711.40076, 12.51610,   0.00000, 0.00000, 0.00000);
	CreateObject(3866, 1782.76392, -1711.40723, 17.22210,   0.00000, 0.00000, 0.00000);
	CreateObject(1260, 1800.41956, -1701.01282, 17.18440,   33.00000, 0.00000, 47.00000);
	CreateObject(1280, 1744.47229, -1864.42114, 12.93730,   0.00000, 0.00000, 90.00000);
	CreateObject(1280, 1741.64917, -1864.50098, 12.93730,   0.00000, 0.00000, 90.00000);
	CreateObject(1280, 1741.66443, -1864.40210, 13.66130,   0.00000, 0.00000, 90.00000);
	CreateObject(1280, 1744.46802, -1864.31860, 13.66130,   0.00000, 0.00000, 90.00000);
	CreateObject(1259, 1831.72180, -1834.37622, 14.39950,   338.00000, -69.00000, 135.00000);
	CreateObject(10984, 1850.36975, -1863.41675, 12.36093,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1845.63672, -1855.82813, 12.90390,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1834.25330, -1840.75452, 12.90390,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1709.72266, -1810.80432, 12.50370,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1724.58875, -1814.78284, 12.50370,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1742.72412, -1819.48022, 12.50370,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1764.50806, -1828.71375, 12.50370,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1780.56177, -1833.68860, 12.50370,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1800.53418, -1833.74548, 12.50370,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1818.45227, -1832.76184, 12.50370,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1827.31372, -1851.66943, 12.50370,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1838.61865, -1862.16394, 12.50370,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1825.15112, -1863.60925, 12.50370,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1804.12476, -1855.02563, 12.50370,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1787.48083, -1855.10083, 12.50370,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1789.32178, -1845.28979, 12.58070,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1809.86584, -1845.73608, 12.58070,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1763.49402, -1853.98083, 12.50370,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1740.01758, -1856.48987, 12.50370,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1725.25525, -1848.50281, 12.50370,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1738.57825, -1843.84521, 12.58070,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1741.55615, -1823.29846, 12.58070,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1728.30115, -1830.76331, 12.58070,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1748.68213, -1838.53613, 12.58070,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1762.27661, -1844.16370, 12.50660,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1766.94421, -1839.04834, 12.50660,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1771.43481, -1844.04639, 12.50660,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1771.43481, -1844.04639, 12.50660,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1777.68384, -1840.42651, 12.50660,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1776.63867, -1847.69495, 12.50660,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1779.89063, -1855.72729, 12.50660,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1771.45923, -1856.80627, 12.50660,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1762.08154, -1857.74902, 12.50660,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1753.63318, -1853.08118, 12.50660,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1754.37781, -1860.54492, 12.50660,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1748.37610, -1860.87659, 12.50660,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1740.54541, -1860.49194, 12.50660,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1736.82593, -1851.22180, 12.50660,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1730.00952, -1850.78516, 12.50660,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1729.96448, -1859.62939, 12.50660,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1725.53442, -1864.31104, 12.50660,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1723.23535, -1846.12256, 12.50660,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1720.27527, -1854.79871, 12.50660,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1720.53442, -1844.90918, 12.50660,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1715.25610, -1839.76514, 12.50660,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1712.29761, -1847.93335, 12.50660,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1714.76807, -1857.49792, 12.50660,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1705.15503, -1856.13269, 12.50660,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1716.36353, -1866.01465, 12.50660,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1704.53223, -1866.78943, 12.50660,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1704.53223, -1866.78943, 12.50660,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1781.35510, -1658.45117, 13.38786,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1784.62903, -1672.14136, 13.38786,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1789.12427, -1665.37732, 13.38786,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1794.11316, -1675.24744, 13.38786,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1802.49817, -1676.13098, 13.38786,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1801.88855, -1663.80688, 13.38786,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1791.81079, -1655.84900, 13.38786,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1774.34631, -1664.00269, 13.38786,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1770.74829, -1671.95129, 13.38786,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1771.45325, -1677.77527, 13.38786,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1769.08667, -1650.62488, 13.38786,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1760.48254, -1641.98828, 13.38786,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1763.51270, -1632.40259, 13.38786,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1773.37964, -1639.26575, 13.38786,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1783.22375, -1642.14270, 13.38786,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1793.72693, -1643.42249, 13.38786,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1801.89795, -1653.80042, 13.38786,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1777.24219, -1648.29028, 13.38786,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1774.16211, -1658.17859, 13.38786,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1776.11902, -1627.92627, 13.38786,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1785.42834, -1631.07434, 13.38786,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1793.67432, -1632.25037, 13.38786,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1767.30786, -1624.69592, 13.38786,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1759.89868, -1621.37402, 13.38786,   0.00000, 0.00000, 0.00000);
	CreateObject(734, 1777.71619, -1676.35718, 13.40110,   0.00000, 0.00000, 0.00000);
	CreateObject(735, 1792.34778, -1641.24365, 10.58010,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1781.94299, -1544.87976, 12.58440,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1775.31445, -1551.80884, 12.58440,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1771.28662, -1559.96997, 12.58440,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1767.14270, -1571.74731, 12.58440,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1764.99255, -1580.35925, 12.58440,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1814.20764, -1540.58252, 12.58440,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1799.52283, -1543.31860, 12.58440,   0.00000, 0.00000, 0.00000);
	CreateObject(3866, 1801.74670, -1564.73975, 12.38080,   0.00000, 0.00000, -45.00000);
	CreateObject(3866, 1801.71729, -1555.10974, 12.38080,   0.00000, 0.00000, 135.00000);
	CreateObject(3866, 1782.71240, -1584.79163, 10.56080,   18.00000, 0.00000, -45.00000);
	CreateObject(10984, 1795.13855, -1572.90845, 12.36367,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1786.50891, -1570.59656, 12.36367,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1761.65833, -1589.29138, 12.36367,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1769.51843, -1553.46619, 12.36367,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1804.10266, -1559.02783, 12.36367,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1807.59082, -1577.62915, 12.36367,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1798.32214, -1582.36548, 12.36367,   0.00000, 0.00000, 0.00000);
	CreateObject(1283, 1820.80762, -1603.36304, 11.81860,   76.00000, 0.00000, 0.00000);
	CreateObject(3866, 1860.93188, -1678.72595, 36.92340,   0.00000, 0.00000, 0.00000);
	CreateObject(3866, 1857.97058, -1684.38342, 36.92340,   0.00000, 0.00000, 90.00000);
	CreateObject(3866, 1873.72083, -1687.16138, 36.92340,   0.00000, 0.00000, 180.00000);
	CreateObject(3866, 1883.64270, -1687.39465, 36.92340,   0.00000, 0.00000, 180.00000);
	CreateObject(3866, 1883.58398, -1679.27942, 36.92340,   0.00000, 0.00000, 180.00000);
	CreateObject(3866, 1881.74841, -1678.80261, 36.92340,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1855.30920, -1666.93994, 33.21350,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1864.65967, -1663.99365, 30.75634,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1873.07739, -1664.89661, 30.75634,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1882.57690, -1667.25757, 30.75634,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1897.39368, -1671.28918, 30.75634,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1895.75159, -1689.76428, 30.75634,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1893.96631, -1699.17688, 30.75634,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1884.76318, -1699.02869, 30.75634,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1875.04004, -1699.21326, 30.75634,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1866.20630, -1699.25745, 30.75634,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1860.82166, -1697.75110, 30.75634,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1852.08997, -1702.01501, 30.75634,   0.00000, 0.00000, 0.00000);
	CreateObject(734, 1708.79504, -1710.59631, 12.76500,   0.00000, 0.00000, 0.00000);
	CreateObject(734, 1714.04883, -1697.93530, 12.76500,   0.00000, 0.00000, 0.00000);
	CreateObject(734, 1731.82642, -1691.35205, 12.76500,   0.00000, 0.00000, 0.00000);
	CreateObject(734, 1733.84644, -1707.05774, 12.76500,   0.00000, 0.00000, 40.00000);
	CreateObject(1216, 1720.38000, -1719.94336, 12.68060,   98.00000, 0.00000, 42.00000);
	CreateObject(1216, 1711.63672, -1715.83691, 12.68060,   98.00000, 0.00000, 42.00000);
	CreateObject(625, 1710.21899, -1719.28662, 13.00590,   273.00000, 0.00000, 113.00000);
	CreateObject(3887, 1711.82190, -1769.85547, 12.70044,   0.00000, 0.00000, 0.00000);
	CreateObject(3887, 1718.33386, -1756.33313, 12.70040,   0.00000, 0.00000, 180.00000);
	CreateObject(10984, 1715.38196, -1778.36694, 12.53577,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1715.95313, -1768.29126, 12.53577,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1715.39063, -1759.86914, 12.53577,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1715.86584, -1754.43530, 12.53577,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1715.69324, -1747.90857, 12.53577,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1639.32581, -1714.52686, 12.33373,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1656.98901, -1701.29895, 12.33373,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1658.91992, -1683.61584, 12.33370,   0.00000, 0.00000, 90.00000);
	CreateObject(10984, 1640.32874, -1692.40442, 12.33373,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1673.80103, -1712.11560, 12.33373,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1658.11987, -1716.18530, 12.33373,   0.00000, 0.00000, 0.00000);
	CreateObject(3866, 1649.93286, -1708.54639, 12.51850,   0.00000, 0.00000, 90.00000);
	CreateObject(3866, 1664.28137, -1708.58521, 12.51850,   0.00000, 0.00000, 90.00000);
	CreateObject(3866, 1664.28467, -1711.45874, 12.51850,   0.00000, 0.00000, 180.00000);
	CreateObject(3866, 1664.12585, -1697.40930, 12.51850,   0.00000, 0.00000, 180.00000);
	CreateObject(4013, 1656.21240, -1639.83887, 21.17860,   11.00000, 0.00000, 3.00000);
	CreateObject(10984, 1657.05872, -1691.78552, 12.33373,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1649.12024, -1692.81152, 12.33373,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1649.05249, -1701.30334, 12.33373,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1659.62756, -1705.41589, 12.33373,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1666.71167, -1705.87366, 12.33373,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1671.56885, -1706.08374, 12.33373,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1673.14673, -1698.93323, 12.33373,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1664.64709, -1697.10327, 12.33373,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1665.56897, -1716.57959, 12.33373,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1678.81543, -1648.35559, 12.33370,   0.00000, 0.00000, 90.00000);
	CreateObject(10984, 1675.53540, -1654.65710, 12.33370,   0.00000, 0.00000, 90.00000);
	CreateObject(10984, 1670.17908, -1657.76111, 12.33370,   0.00000, 0.00000, 90.00000);
	CreateObject(10984, 1664.96423, -1656.13379, 12.33370,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1657.77893, -1657.63794, 12.33370,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1649.65906, -1660.51550, 12.33370,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1643.43079, -1659.59717, 12.33370,   0.00000, 0.00000, 0.00000);
	CreateObject(3866, 1669.46545, -1651.51099, 12.51850,   0.00000, 0.00000, 180.00000);
	CreateObject(3866, 1648.71289, -1651.45703, 12.51850,   0.00000, 0.00000, 180.00000);
	CreateObject(3866, 1639.45105, -1651.33154, 12.51850,   0.00000, 0.00000, 180.00000);
	CreateObject(10984, 1673.62329, -1574.82397, 12.33370,   0.00000, 0.00000, 90.00000);
	CreateObject(10984, 1673.59106, -1560.65710, 12.33370,   0.00000, 0.00000, 90.00000);
	CreateObject(10984, 1688.70605, -1561.16260, 12.33370,   0.00000, 0.00000, 90.00000);
	CreateObject(10984, 1691.79761, -1575.71521, 12.33370,   0.00000, 0.00000, 90.00000);
	CreateObject(10984, 1701.79443, -1574.24060, 12.33370,   0.00000, 0.00000, 90.00000);
	CreateObject(10984, 1701.68726, -1560.78430, 12.33370,   0.00000, 0.00000, 90.00000);
	CreateObject(18862, 1688.70117, -1569.67529, 15.69610,   0.00000, 0.00000, 0.00000);
	CreateObject(3866, 1692.26855, -1571.78577, 12.52040,   0.00000, 0.00000, 180.00000);
	CreateObject(3866, 1675.06445, -1571.95789, 12.52040,   0.00000, 0.00000, 180.00000);
	CreateObject(3866, 1678.88391, -1569.00940, 12.52040,   0.00000, 0.00000, 90.00000);
	CreateObject(3866, 1681.89832, -1566.42896, 12.52040,   0.00000, 0.00000, 0.00000);
	CreateObject(3866, 1699.07983, -1566.43726, 12.52040,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1676.12830, -1610.58887, 12.33370,   0.00000, 0.00000, 90.00000);
	CreateObject(3866, 1713.47961, -1647.50623, 26.86380,   0.00000, 0.00000, 0.00000);
	CreateObject(3866, 1710.89563, -1664.98950, 26.86380,   0.00000, 0.00000, 90.00000);
	CreateObject(3866, 1726.04907, -1667.91089, 26.86380,   0.00000, 0.00000, 180.00000);
	CreateObject(3866, 1728.87976, -1650.62622, 26.86380,   0.00000, 0.00000, -90.00000);
	CreateObject(3866, 1711.00647, -1667.95007, 14.48780,   0.00000, 0.00000, 90.00000);
	CreateObject(3887, 1424.67175, -1873.13257, 7.72730,   0.00000, 0.00000, 55.00000);
	CreateObject(4206, 1407.42310, -1591.37219, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1385.15149, -1588.95435, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1455.87366, -1591.86353, 12.52870,   0.00000, 0.00000, 90.00000);
	CreateObject(874, 1447.12549, -1592.00330, 12.52870,   0.00000, 0.00000, 90.00000);
	CreateObject(874, 1436.80383, -1592.03894, 12.52870,   0.00000, 0.00000, 90.00000);
	CreateObject(874, 1428.81519, -1590.85815, 12.52870,   0.00000, 0.00000, 90.00000);
	CreateObject(874, 1428.14038, -1569.50171, 12.52870,   0.00000, 0.00000, 90.00000);
	CreateObject(874, 1428.08362, -1578.54492, 12.52870,   0.00000, 0.00000, 90.00000);
	CreateObject(874, 1428.08362, -1578.54492, 12.52870,   0.00000, 0.00000, 90.00000);
	CreateObject(874, 1429.11560, -1561.90161, 12.52870,   0.00000, 0.00000, 90.00000);
	CreateObject(874, 1429.74683, -1553.60437, 12.52870,   0.00000, 0.00000, 90.00000);
	CreateObject(874, 1432.02783, -1549.64368, 12.52870,   0.00000, 0.00000, 90.00000);
	CreateObject(874, 1427.58130, -1602.32776, 12.52870,   0.00000, 0.00000, 90.00000);
	CreateObject(874, 1427.76782, -1611.82117, 12.52870,   0.00000, 0.00000, 90.00000);
	CreateObject(874, 1427.35901, -1619.65662, 12.52870,   0.00000, 0.00000, 90.00000);
	CreateObject(874, 1428.54895, -1626.56689, 12.52870,   0.00000, 0.00000, 90.00000);
	CreateObject(874, 1428.22241, -1634.18066, 12.52870,   0.00000, 0.00000, 90.00000);
	CreateObject(874, 1427.68945, -1641.63196, 12.52870,   0.00000, 0.00000, 90.00000);
	CreateObject(874, 1417.94690, -1647.83960, 12.52870,   0.00000, 0.00000, 90.00000);
	CreateObject(874, 1427.50586, -1647.59241, 12.52870,   0.00000, 0.00000, 90.00000);
	CreateObject(874, 1428.03674, -1656.37927, 12.52870,   0.00000, 0.00000, 90.00000);
	CreateObject(874, 1427.21655, -1663.53479, 12.52870,   0.00000, 0.00000, 90.00000);
	CreateObject(874, 1428.01013, -1670.90210, 12.52870,   0.00000, 0.00000, 90.00000);
	CreateObject(874, 1428.32446, -1677.49170, 12.52870,   0.00000, 0.00000, 90.00000);
	CreateObject(874, 1427.48950, -1683.27002, 12.52870,   0.00000, 0.00000, 90.00000);
	CreateObject(10984, 1504.09619, -1477.53455, 12.51929,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1504.18054, -1460.05945, 12.51929,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1518.56250, -1461.13135, 12.51929,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1530.17578, -1460.38770, 12.51929,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1540.44885, -1460.43616, 12.51929,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1542.15198, -1476.89575, 12.51929,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1529.49792, -1476.16101, 12.51929,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1518.14063, -1475.96387, 12.51929,   0.00000, 0.00000, 0.00000);
	CreateObject(4020, 1544.83594, -1516.85156, 32.45313,   0.00000, 0.00000, 0.00000);
	CreateObject(3887, 1520.16882, -1459.35657, 19.52670,   0.00000, 0.00000, -90.00000);
	CreateObject(3887, 1520.12195, -1469.52820, 19.52670,   0.00000, 0.00000, 90.00000);
	CreateObject(3887, 1491.09619, -1469.58228, 19.52670,   0.00000, 0.00000, 90.00000);
	CreateObject(3887, 1491.92334, -1459.58301, 19.52670,   0.00000, 0.00000, -90.00000);
	CreateObject(4206, 1437.52148, -1537.81201, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1442.14392, -1520.38538, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1448.44653, -1503.08276, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(735, 1404.35059, -1765.90320, 9.97850,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1342.93274, -1579.44104, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1324.61658, -1574.37048, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1309.62036, -1566.66516, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1303.02856, -1556.42017, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1306.21741, -1542.24695, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1311.20178, -1529.97595, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1316.44678, -1519.70935, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1322.38171, -1510.34998, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1327.34045, -1501.75598, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1335.16272, -1491.43799, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1339.82813, -1480.31323, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1341.65759, -1470.76221, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1346.13489, -1462.55151, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1347.05396, -1450.15710, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1348.22742, -1441.47607, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1350.05261, -1431.68445, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1342.22009, -1411.92004, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1349.24487, -1420.61182, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1329.32043, -1401.00671, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1363.45642, -1406.76172, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1378.73535, -1400.26660, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1391.85364, -1411.42395, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1394.64111, -1424.07666, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1400.15430, -1438.49036, 12.43440,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1410.94763, -1438.44299, 12.43440,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1388.24866, -1399.67737, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1348.98938, -1389.94165, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(734, 1232.58081, -1376.54700, 13.08404,   0.00000, 0.00000, 0.00000);
	CreateObject(734, 1223.81030, -1340.00818, 13.08404,   0.00000, 0.00000, 0.00000);
	CreateObject(734, 1241.44202, -1350.72119, 13.08404,   0.00000, 0.00000, 0.00000);
	CreateObject(734, 1220.96265, -1360.13110, 13.08404,   0.00000, 0.00000, 0.00000);
	CreateObject(735, 1242.30481, -1365.74512, 10.57900,   0.00000, 0.00000, 0.00000);
	CreateObject(735, 1240.33069, -1326.34119, 10.57900,   0.00000, 0.00000, 0.00000);
	CreateObject(734, 1236.47144, -1307.61731, 13.08404,   0.00000, 0.00000, 0.00000);
	CreateObject(734, 1219.96094, -1321.16260, 13.08404,   0.00000, 0.00000, 0.00000);
	CreateObject(735, 1220.05225, -1297.59387, 10.57900,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1179.31543, -1299.78455, 16.71690,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1159.25635, -1301.15894, 16.71690,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1167.36511, -1315.31372, 16.71690,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1155.02576, -1320.85339, 16.71690,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1153.66516, -1333.25623, 16.71690,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1182.79236, -1318.37427, 12.36449,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1172.94739, -1329.41797, 12.36449,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1179.47571, -1333.05823, 12.36449,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1166.81958, -1342.27832, 12.36449,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1155.59229, -1349.49878, 12.99650,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1179.30847, -1346.72009, 12.36449,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1167.86633, -1355.26477, 12.36449,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1156.02490, -1363.33618, 12.99650,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1176.79932, -1360.65161, 16.71690,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1159.51831, -1376.00684, 16.71690,   0.00000, 0.00000, 0.00000);
	CreateObject(18862, 1176.06689, -1377.70850, 16.71690,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1150.16199, -1376.17090, 12.99650,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1169.31958, -1291.65210, 12.36449,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1149.90930, -1293.08594, 12.36449,   0.00000, 0.00000, 0.00000);
	CreateObject(3887, 1177.86060, -1356.98730, 12.53150,   0.00000, 0.00000, 180.00000);
	CreateObject(3887, 1177.80212, -1316.06042, 12.53150,   0.00000, 0.00000, 180.00000);
	CreateObject(3887, 1154.52026, -1318.45776, 12.53150,   0.00000, 0.00000, 0.00000);
	CreateObject(3887, 1154.43994, -1359.56848, 12.53150,   0.00000, 0.00000, 0.00000);
	CreateObject(3887, 1172.72949, -1376.21167, 12.53150,   0.00000, 0.00000, 90.00000);
	CreateObject(4206, 1315.56152, -1401.34253, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1304.21887, -1399.67285, 12.36940,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1289.67371, -1400.11755, 12.36940,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1283.35156, -1411.37341, 12.36940,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1271.75745, -1399.80554, 12.21140,   0.00000, 0.00000, 0.00000);
	CreateObject(1267, 1417.78162, -1417.34180, 15.11600,   -4.00000, 76.00000, -47.00000);
	CreateObject(1267, 1379.54333, -1400.13293, 13.53600,   -4.00000, 84.00000, 180.00000);
	CreateObject(734, 1356.17542, -1940.10791, 21.44650,   0.00000, 0.00000, 0.00000);
	CreateObject(734, 1342.41016, -1905.00000, 18.12850,   0.00000, 0.00000, 0.00000);
	CreateObject(734, 1378.92114, -1951.19556, 21.44650,   0.00000, 0.00000, 0.00000);
	CreateObject(734, 1404.54749, -1941.80237, 21.44650,   0.00000, 0.00000, 0.00000);
	CreateObject(734, 1436.08667, -1923.41345, 21.44650,   0.00000, 0.00000, 0.00000);
	CreateObject(4193, 1359.81042, -1842.05713, 14.08570,   18.00000, 0.00000, 19.00000);
	CreateObject(874, 1470.71106, -1731.80811, 12.94380,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1462.06665, -1731.04211, 12.94380,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1444.48193, -1733.25977, 12.94380,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1435.91577, -1732.88013, 12.94380,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1428.05786, -1732.09277, 12.94380,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1430.42029, -1719.96094, 12.94380,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1430.45862, -1707.83435, 12.94380,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1430.02515, -1697.64148, 12.94380,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1428.95593, -1690.16785, 12.94380,   0.00000, 0.00000, 0.00000);
	CreateObject(874, 1407.54492, -1731.02307, 12.94380,   0.00000, 0.00000, 0.00000);
	CreateObject(3269, 1476.88062, -1581.12671, 13.46843,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1900.43823, -1524.42529, 2.96370,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1910.62085, -1498.47107, 2.96370,   0.00000, 0.00000, 0.00000);
	CreateObject(740, 1909.79749, -1484.95166, 9.78130,   0.00000, 97.00000, -32.00000);
	CreateObject(10984, 1885.15369, -1370.67712, 13.29240,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1912.86609, -1386.83337, 12.99240,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1903.76416, -1386.30798, 12.99240,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1904.41052, -1400.63220, 12.99240,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1894.05981, -1402.26099, 12.99240,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1873.54663, -1423.44568, 12.99240,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1886.04688, -1415.54028, 12.99240,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1897.66797, -1418.51563, 12.99240,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1897.03455, -1432.48950, 12.99240,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1883.09778, -1432.58289, 12.99240,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1874.70117, -1435.16895, 12.99240,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1943.78491, -1434.05261, 12.99240,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1933.81555, -1426.76892, 12.99240,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1922.85376, -1427.87744, 12.99240,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1909.97217, -1428.13818, 12.99240,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1944.76123, -1417.32825, 12.99240,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1958.19263, -1418.11804, 12.99240,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1959.92981, -1431.42041, 12.99240,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1952.14648, -1439.00256, 12.99240,   0.00000, 0.00000, 0.00000);
	CreateObject(1308, 1870.05603, -1602.67981, 12.78130,   33.00000, -20.00000, 55.00000);
	CreateObject(3866, 1917.77417, -1586.56201, 20.06080,   0.00000, 0.00000, 180.00000);
	CreateObject(3866, 1905.92163, -1586.66650, 20.06080,   0.00000, 0.00000, 0.00000);
	CreateObject(3866, 1854.57495, -1590.32617, 20.06080,   0.00000, 0.00000, 0.00000);
	CreateObject(3866, 1866.17578, -1590.27686, 20.06080,   0.00000, 0.00000, 180.00000);
	CreateObject(10984, 1878.14539, -1599.72461, 12.56573,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1845.16589, -1598.67603, 12.56573,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1845.68005, -1584.43323, 12.56573,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1898.07385, -1599.54187, 12.56573,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1928.15125, -1597.81677, 12.56573,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1911.73376, -1595.94836, 12.56573,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1896.64978, -1579.23877, 12.56573,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1927.95203, -1579.68677, 12.56573,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1838.02576, -1820.50708, 6.57300,   0.10000, 48.00000, 14.00000);
	CreateObject(10984, 1836.36707, -1807.88196, 6.57300,   0.10000, 48.00000, 14.00000);
	CreateObject(3594, 1528.87085, -1703.09973, 12.88390,   0.00000, 0.00000, 120.00000);
	CreateObject(735, 1926.48877, -1363.98743, 11.80730,   0.00000, 0.00000, 0.00000);
	CreateObject(735, 1947.14172, -1394.59558, 12.10730,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1954.88977, -1738.91858, 12.52921,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1966.39282, -1740.32166, 12.52921,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1976.65930, -1740.71936, 12.52921,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1986.06177, -1740.49707, 12.52921,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1955.80078, -1728.21484, 12.52921,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1968.94495, -1727.48193, 12.52921,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1984.34021, -1726.33679, 12.52921,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1987.14111, -1712.41675, 12.52921,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1976.08081, -1709.77222, 12.52921,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1966.13428, -1709.32983, 12.52921,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1955.90210, -1709.17078, 12.52921,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1956.75098, -1695.81824, 12.52921,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1956.58386, -1683.05103, 12.52921,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1957.57434, -1668.76416, 12.52921,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1957.86377, -1653.73608, 12.52921,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1958.92078, -1641.30115, 12.52921,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1958.63220, -1628.87427, 12.52921,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1991.04895, -1629.54932, 12.52921,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1991.05847, -1640.02710, 12.52921,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1991.08435, -1651.99072, 12.52921,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1991.07886, -1669.04187, 12.52921,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1990.99146, -1685.80017, 12.52921,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1990.92725, -1696.44556, 12.52921,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1990.79565, -1729.34924, 12.52921,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1972.73792, -1695.01172, 12.52920,   0.00000, 0.00000, 90.00000);
	CreateObject(10984, 1972.81262, -1683.95508, 12.52920,   0.00000, 0.00000, 90.00000);
	CreateObject(10984, 1973.25378, -1673.30530, 12.52920,   0.00000, 0.00000, 90.00000);
	CreateObject(10984, 1973.74243, -1662.21167, 12.52920,   0.00000, 0.00000, 90.00000);
	CreateObject(10984, 1973.88696, -1650.09351, 12.52920,   0.00000, 0.00000, 90.00000);
	CreateObject(10984, 1974.21594, -1638.52795, 12.52920,   0.00000, 0.00000, 90.00000);
	CreateObject(10984, 1974.68518, -1626.51550, 12.52920,   0.00000, 0.00000, 90.00000);
	CreateObject(3887, 1960.00879, -1651.91382, 20.15290,   0.00000, 0.00000, 0.00000);
	CreateObject(3887, 1973.26624, -1651.87476, 20.15290,   0.00000, 0.00000, 0.00000);
	CreateObject(3887, 1984.00061, -1651.93103, 20.15290,   0.00000, 0.00000, 180.00000);
	CreateObject(3887, 1983.48438, -1715.22009, 20.15290,   0.00000, 0.00000, 180.00000);
	CreateObject(3887, 1983.62537, -1674.29797, 20.15290,   0.00000, 0.00000, 180.00000);
	CreateObject(3887, 1960.02893, -1692.62036, 20.15290,   0.00000, 0.00000, 0.00000);
	CreateObject(3887, 1959.98267, -1716.48499, 20.15290,   0.00000, 0.00000, 0.00000);
	CreateObject(735, 1923.17725, -1724.51086, 10.43350,   0.00000, 0.00000, 0.00000);
	CreateObject(735, 1927.68640, -1681.91174, 10.43350,   0.00000, 0.00000, 0.00000);
	CreateObject(735, 1922.31384, -1695.67834, 10.43350,   0.00000, 0.00000, 0.00000);
	CreateObject(735, 1922.31384, -1695.67834, 10.43350,   0.00000, 0.00000, 0.00000);
	CreateObject(735, 1921.86072, -1667.76941, 10.43350,   0.00000, 0.00000, 0.00000);
	CreateObject(735, 1928.60449, -1652.73059, 10.43350,   0.00000, 0.00000, 0.00000);
	CreateObject(735, 1924.80396, -1631.82861, 10.43350,   0.00000, 0.00000, 0.00000);
	CreateObject(3866, 1985.37354, -1773.25439, 19.32410,   0.00000, 0.00000, 0.00000);
	CreateObject(3866, 2033.97925, -1773.09900, 31.12410,   0.00000, 0.00000, 0.00000);
	CreateObject(3866, 2033.96545, -1779.86047, 19.62410,   0.00000, 0.00000, 0.00000);
	CreateObject(3866, 2022.54492, -1773.15356, 19.32410,   0.00000, 0.00000, 0.00000);
	CreateObject(3866, 2005.48083, -1773.30872, 19.32410,   0.00000, 0.00000, 0.00000);
	CreateObject(3866, 1985.68994, -1786.45898, 19.32410,   0.00000, 0.00000, 0.00000);
	CreateObject(3866, 2037.06177, -1777.33582, 20.02410,   0.00000, 0.00000, 180.00000);
	CreateObject(3887, 2132.38843, -1733.74023, 15.81960,   0.00000, 0.00000, 90.00000);
	CreateObject(3887, 2147.89185, -1733.65881, 15.81960,   0.00000, 0.00000, 90.00000);
	CreateObject(10984, 2164.66968, -1668.58362, 13.77330,   0.00000, 0.00000, 0.00000);
	CreateObject(3866, 2153.26782, -1704.17346, 14.04914,   0.00000, 0.00000, 0.00000);
	CreateObject(3866, 2153.26782, -1704.17346, 14.04910,   0.00000, 0.00000, 180.00000);
	CreateObject(3866, 2157.61670, -1663.91907, 14.04910,   0.00000, 0.00000, 60.00000);
	CreateObject(3866, 2153.50464, -1665.00330, 14.04910,   0.00000, 0.00000, 150.00000);
	CreateObject(10984, 2179.31787, -1653.54248, 14.06257,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 2133.90112, -1690.96594, 14.06257,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 2137.96973, -1652.51257, 14.06257,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 2151.49365, -1683.22656, 14.06257,   0.00000, 0.00000, 0.00000);
	CreateObject(3661, 2061.56543, -1716.22400, 13.31880,   0.00000, 5.60000, 0.00000);
	CreateObject(3661, 2024.44189, -1715.16479, 13.31880,   0.00000, 5.60000, 0.00000);
	CreateObject(10984, 2068.74487, -1732.45972, 12.35796,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 2067.49878, -1720.14832, 12.35796,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 2066.75439, -1703.38220, 12.35796,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 2056.34717, -1710.06006, 12.35796,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 2055.21191, -1726.88171, 12.35796,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 2031.00110, -1729.71814, 12.35796,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 2030.52539, -1713.36267, 12.35796,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 2018.96545, -1706.48645, 12.35796,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 2019.16724, -1718.67358, 12.35796,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 2019.17285, -1733.72510, 12.45800,   0.00000, 0.00000, 0.00000);
	CreateObject(3582, 2018.29187, -1654.03528, 14.00310,   0.00000, 8.70000, 80.00000);
	CreateObject(3582, 2019.96619, -1635.72778, 14.00310,   0.00000, 9.00000, 126.00000);
	CreateObject(10984, 2018.53821, -1644.65076, 12.53653,   0.00000, 0.00000, 0.00000);
	CreateObject(3582, 2062.92676, -1633.36389, 14.00310,   0.00000, 9.00000, -126.00000);
	CreateObject(3582, 2063.70850, -1652.71399, 14.00310,   0.00000, 9.00000, 126.00000);
	CreateObject(10984, 2064.70679, -1642.63147, 12.53653,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 2068.94434, -1658.74084, 12.33650,   0.00000, 0.00000, 0.00000);
	CreateObject(3887, 2063.95557, -1573.11938, 12.44835,   0.00000, 0.00000, 0.00000);
	CreateObject(3887, 2072.61548, -1569.57825, 12.44840,   0.00000, 0.00000, 180.00000);
	CreateObject(10984, 2063.91895, -1593.57153, 12.44572,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 2080.89063, -1594.56470, 12.44572,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 2081.23364, -1572.39685, 12.34570,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 2070.77417, -1549.61572, 12.44572,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 2066.02661, -1574.91260, 12.44572,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 2082.24268, -1554.00403, 12.24570,   0.00000, 0.00000, 0.00000);
	CreateObject(3866, 2145.55786, -1596.68823, 20.73270,   0.00000, 0.00000, 0.00000);
	CreateObject(3866, 2157.08130, -1596.62207, 20.73270,   0.00000, 0.00000, 180.00000);
	CreateObject(10984, 2153.25854, -1606.59668, 13.33417,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 2161.25806, -1611.00208, 13.33417,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 2138.57446, -1593.44885, 13.33417,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 2159.09937, -1592.72412, 13.33417,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 2178.31348, -1611.17761, 13.33417,   0.00000, 0.00000, 0.00000);
	CreateObject(17697, 2494.83936, -1696.42737, 13.95470,   4.00000, 0.00000, 180.00000);
	CreateObject(10984, 2453.20459, -1639.78906, 12.38740,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 2463.65015, -1639.78186, 12.38740,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 2473.20630, -1640.17468, 12.38740,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 2480.62695, -1639.84033, 12.38740,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 2488.71411, -1640.01221, 12.38740,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 2496.14868, -1642.10400, 12.38740,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 2503.78906, -1642.64648, 12.38740,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 2527.65039, -1658.72546, 14.18740,   0.00000, 0.00000, 180.00000);
	CreateObject(10984, 2525.78198, -1673.79065, 14.18740,   0.00000, 0.00000, 180.00000);
	CreateObject(10984, 2530.61182, -1674.58093, 15.48740,   0.00000, 0.00000, 180.00000);
	CreateObject(4206, 2494.89746, -1664.68860, 12.37660,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 2498.28345, -1678.01868, 12.37660,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 2479.69604, -1673.82068, 12.37660,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 2477.76611, -1659.52881, 12.37660,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 2455.73193, -1659.55847, 12.37660,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 2436.41333, -1658.68079, 12.37660,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 2423.48364, -1660.84729, 12.37660,   0.10000, 0.00000, 0.00000);
	CreateObject(4206, 2425.53589, -1659.19006, 12.37660,   0.10000, 0.00000, 0.00000);
	CreateObject(4206, 2409.35645, -1662.22607, 12.37660,   0.10000, 0.00000, 0.00000);
	CreateObject(4206, 2389.60254, -1662.14734, 12.37660,   0.10000, 0.00000, 0.00000);
	CreateObject(4206, 2369.87012, -1661.99915, 12.37660,   0.10000, 0.00000, 0.00000);
	CreateObject(4206, 2349.15356, -1660.58459, 12.37660,   0.10000, 0.00000, 0.00000);
	CreateObject(4206, 2337.53467, -1675.71558, 12.37660,   0.10000, 0.00000, 0.00000);
	CreateObject(4206, 2342.21362, -1697.25269, 12.37660,   0.10000, 0.00000, 0.00000);
	CreateObject(4206, 2342.01489, -1719.13843, 12.37660,   0.10000, 0.00000, 0.00000);
	CreateObject(4206, 2342.69141, -1732.79541, 12.37660,   0.10000, 0.00000, 0.00000);
	CreateObject(4206, 2363.57422, -1734.85620, 12.37660,   0.10000, 0.00000, 0.00000);
	CreateObject(4206, 2320.99170, -1734.46313, 12.37660,   0.10000, 0.00000, 0.00000);
	CreateObject(4206, 2298.96558, -1734.48633, 12.37660,   0.10000, 0.00000, 0.00000);
	CreateObject(4206, 2280.34814, -1734.13940, 12.37660,   0.10000, 0.00000, 0.00000);
	CreateObject(4206, 2283.66699, -1755.65576, 12.37660,   0.10000, 0.00000, 0.00000);
	CreateObject(4206, 2264.67871, -1755.65393, 12.37660,   0.10000, 0.00000, 0.00000);
	CreateObject(4206, 2245.64404, -1755.81238, 12.37660,   0.10000, 0.00000, 0.00000);
	CreateObject(4206, 2229.50610, -1757.72388, 12.37660,   0.10000, 0.00000, 0.00000);
	CreateObject(4206, 2261.65796, -1734.59668, 12.37660,   0.10000, 0.00000, 0.00000);
	CreateObject(4206, 2241.23462, -1734.38367, 12.37660,   0.10000, 0.00000, 0.00000);
	CreateObject(4206, 2219.19946, -1734.09998, 12.37660,   0.10000, 0.00000, 0.00000);
	CreateObject(4206, 2039.97827, -1674.48547, 12.39940,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 2019.18689, -1673.79834, 12.39940,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 2002.23865, -1686.57642, 12.39940,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 2001.97791, -1664.30591, 12.39940,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 2001.98596, -1643.39331, 12.39940,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 2005.24878, -1623.63794, 12.39940,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 2011.70435, -1615.97021, 12.39940,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 2028.24805, -1618.29578, 12.39940,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 2037.07288, -1616.05579, 12.39940,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 2041.05933, -1608.23755, 12.39940,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 2060.95386, -1615.54785, 12.39940,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 2078.97241, -1614.70337, 12.39940,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 2079.64844, -1632.78589, 12.39940,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 2078.91187, -1651.54944, 12.39940,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 2079.29980, -1669.22278, 12.39940,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 2061.54663, -1671.70544, 12.39940,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 2001.63306, -1708.63452, 12.39940,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 2002.34204, -1731.01917, 12.39940,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 2002.38696, -1751.91907, 12.39940,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1978.89600, -1752.58704, 12.39940,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1959.31946, -1751.69373, 12.39940,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1941.73950, -1753.25977, 12.39940,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1943.22656, -1728.08350, 12.39940,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1941.46814, -1707.36670, 12.39940,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1942.08118, -1686.48157, 12.39940,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1942.69312, -1664.49500, 12.39940,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1943.19312, -1642.29993, 12.39940,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1939.36804, -1619.68652, 12.39940,   0.00000, 0.00000, 0.00000);
	CreateObject(4206, 1557.30737, -1592.22791, 12.44840,   0.00000, 0.00000, 0.00000);
	CreateObject(1388, 1235.75293, -1322.58813, 12.16910,   3.00000, -57.60000, 27.70000);
	CreateObject(1391, 1223.15881, -1263.56116, 38.21410,   32.55000, -20.40000, 0.00000);
	CreateObject(10984, 1212.08105, -1464.86279, 12.52462,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1230.08948, -1465.85632, 12.52462,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1221.94275, -1464.75037, 12.52462,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1212.45593, -1451.36560, 12.52462,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1209.90747, -1434.91541, 12.52462,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1230.57068, -1434.27893, 12.52462,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1221.42615, -1433.93408, 12.52462,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1231.28162, -1450.01794, 12.52462,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1223.43005, -1449.90735, 12.52462,   0.00000, 0.00000, 0.00000);
	CreateObject(792, 1207.59021, -1416.26477, 12.66406,   356.85840, 0.00000, 3.14159);
	CreateObject(792, 1232.44153, -1418.00110, 12.71875,   356.85840, 0.00000, 3.14159);
	CreateObject(792, 1206.94971, -1417.53613, 12.66406,   356.85840, 0.00000, 3.14159);
	CreateObject(792, 1232.77625, -1416.55725, 12.71875,   356.85840, 0.00000, 3.14159);
	CreateObject(5463, 1218.37476, -1441.08398, 30.62480,   -8.10000, -9.00000, 0.00000);
	CreateObject(10984, 1196.59485, -1421.08301, 12.52462,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1201.03418, -1411.38525, 12.52462,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1209.05627, -1407.93420, 12.52462,   0.00000, 0.00000, 0.00000);
	CreateObject(10984, 1218.68396, -1407.31006, 12.52462,   0.00000, 0.00000, 0.00000);
	CreateObject(3866, 1403.17358, -1374.24292, 33.22620,   0.00000, 0.00000, 180.00000);
	CreateObject(3866, 1385.64209, -1374.38367, 33.22620,   0.00000, 0.00000, 180.00000);
	CreateObject(3866, 1383.34436, -1374.83472, 33.22620,   0.00000, 0.00000, 0.00000);
	CreateObject(3866, 1503.85400, -1893.00586, 39.13610,   0.00000, 0.00000, 0.00000);

	//zombie map

	CreateDynamicObject(891,1866.0000000,-2566.8000000,12.5000000,0.0000000,0.0000000,0.0000000); //object(elmdead_po) (1)
	CreateDynamicObject(709,1824.6000000,-2563.2000000,16.5000000,0.0000000,0.0000000,0.0000000); //object(sm_vegvbbigbrn) (1)
	CreateDynamicObject(709,1839.2000000,-2535.1001000,12.5000000,0.0000000,0.0000000,0.0000000); //object(sm_vegvbbigbrn) (2)
	CreateDynamicObject(709,1886.3000000,-2540.6001000,12.5000000,0.0000000,0.0000000,0.0000000); //object(sm_vegvbbigbrn) (3)
	CreateDynamicObject(17552,1867.4000000,-2559.3999000,17.6000000,0.0000000,0.0000000,0.0000000); //object(burnhous1_lae2) (1)
	CreateDynamicObject(709,1900.1999500,-2572.5000000,12.5000000,0.0000000,0.0000000,0.0000000); //object(sm_vegvbbigbrn) (4)
	CreateDynamicObject(5003,1901.0000000,-2576.7000000,22.1000000,0.0000000,0.0000000,0.0000000); //object(lasrnway5_las) (1)
	CreateDynamicObject(17552,1979.7000000,-2433.3999000,17.6000000,0.0000000,0.0000000,0.0000000); //object(burnhous1_lae2) (3)
	CreateDynamicObject(3594,1992.5000000,-2385.7000000,13.2000000,0.0000000,0.0000000,0.0000000); //object(la_fuckcar1) (1)
	CreateDynamicObject(3594,1968.6000000,-2405.0000000,13.2000000,0.0000000,0.0000000,0.0000000); //object(la_fuckcar1) (2)
	CreateDynamicObject(3594,1967.5000000,-2393.0000000,13.2000000,0.0000000,0.0000000,0.0000000); //object(la_fuckcar1) (3)
	CreateDynamicObject(3594,2000.4000000,-2364.7000000,13.2000000,0.0000000,0.0000000,0.0000000); //object(la_fuckcar1) (4)
	CreateDynamicObject(3594,1975.1000000,-2377.0000000,13.2000000,0.0000000,0.0000000,0.0000000); //object(la_fuckcar1) (5)
	CreateDynamicObject(3594,2011.4000000,-2374.2000000,15.2000000,0.0000000,0.0000000,0.0000000); //object(la_fuckcar1) (6)
	CreateDynamicObject(3594,2000.9000000,-2398.3000000,13.2000000,0.0000000,0.0000000,0.0000000); //object(la_fuckcar1) (7)
	CreateDynamicObject(3594,1930.5000000,-2588.7000000,16.5000000,0.0000000,0.0000000,0.0000000); //object(la_fuckcar1) (8)
	CreateDynamicObject(3594,1937.8000000,-2593.1001000,16.5000000,0.0000000,0.0000000,0.0000000); //object(la_fuckcar1) (9)
	CreateDynamicObject(3594,1946.5000000,-2598.2000000,16.5000000,0.0000000,0.0000000,0.0000000); //object(la_fuckcar1) (10)
	CreateDynamicObject(3594,1930.3000000,-2558.2000000,16.5000000,0.0000000,0.0000000,0.0000000); //object(la_fuckcar1) (11)
	CreateDynamicObject(3594,1955.3000000,-2573.3000000,16.5000000,0.0000000,0.0000000,0.0000000); //object(la_fuckcar1) (12)
	CreateDynamicObject(3594,1946.6000000,-2564.2000000,16.5000000,0.0000000,0.0000000,0.0000000); //object(la_fuckcar1) (13)
	CreateDynamicObject(3594,1961.2000000,-2589.1001000,16.5000000,0.0000000,0.0000000,0.0000000); //object(la_fuckcar1) (14)
	CreateDynamicObject(1337,1942.3447000,-2528.3447000,23.3337800,0.0000000,0.0000000,0.0000000); //object(binnt07_la) (1)
	CreateDynamicObject(709,1927.8000000,-2463.3999000,21.6000000,0.0000000,0.0000000,0.0000000); //object(sm_vegvbbigbrn) (5)
	CreateDynamicObject(709,1926.3000000,-2488.8999000,13.1000000,0.0000000,0.0000000,0.0000000); //object(sm_vegvbbigbrn) (6)
	CreateDynamicObject(709,1941.7000000,-2451.0000000,12.5000000,0.0000000,0.0000000,0.0000000); //object(sm_vegvbbigbrn) (7)
	CreateDynamicObject(708,1957.1000000,-2482.1001000,12.5000000,0.0000000,0.0000000,0.0000000); //object(sm_veg_tree4_vbig) (1)
	CreateDynamicObject(708,1937.5000000,-2503.8999000,16.2000000,0.0000000,0.0000000,0.0000000); //object(sm_veg_tree4_vbig) (2)
	CreateDynamicObject(708,1945.8000000,-2427.8999000,19.5000000,0.0000000,0.0000000,0.0000000); //object(sm_veg_tree4_vbig) (3)
	CreateDynamicObject(708,1955.4000000,-2416.8999000,20.5000000,0.0000000,0.0000000,0.0000000); //object(sm_veg_tree4_vbig) (4)
	CreateDynamicObject(709,1968.9000000,-2455.0000000,12.5000000,0.0000000,0.0000000,0.0000000); //object(sm_vegvbbigbrn) (8)
	CreateDynamicObject(3374,2037.8000000,-2457.8000000,14.0000000,0.0000000,0.0000000,0.0000000); //object(sw_haybreak02) (1)
	CreateDynamicObject(3374,2037.8000000,-2457.3999000,17.0000000,0.0000000,0.0000000,0.0000000); //object(sw_haybreak02) (2)
	CreateDynamicObject(3374,2038.0000000,-2457.8999000,20.0000000,0.0000000,0.0000000,0.0000000); //object(sw_haybreak02) (3)
	CreateDynamicObject(3374,2037.9000000,-2457.1001000,23.0000000,0.0000000,0.0000000,0.0000000); //object(sw_haybreak02) (4)
	CreateDynamicObject(3374,2037.9000000,-2456.2000000,26.0000000,0.0000000,0.0000000,0.0000000); //object(sw_haybreak02) (5)
	CreateDynamicObject(3374,2041.7000000,-2457.8000000,14.0000000,0.0000000,0.0000000,0.0000000); //object(sw_haybreak02) (6)
	CreateDynamicObject(3374,2045.5000000,-2457.5000000,14.0000000,0.0000000,0.0000000,0.0000000); //object(sw_haybreak02) (7)
	CreateDynamicObject(3267,2014.9000000,-2460.2000000,12.5000000,0.0000000,0.0000000,0.0000000); //object(mil_samsite) (1)
	CreateDynamicObject(3057,2013.6000000,-2447.1001000,12.9000000,0.0000000,0.0000000,0.0000000); //object(kb_barrel_exp) (1)
	CreateDynamicObject(3524,2032.8000000,-2462.3000000,15.4000000,0.0000000,0.0000000,0.0000000); //object(skullpillar01_lvs) (1)
	CreateDynamicObject(3461,2038.5000000,-2458.2000000,27.5000000,0.0000000,0.0000000,0.0000000); //object(tikitorch01_lvs) (1)
	CreateDynamicObject(3461,2042.0000000,-2459.8000000,14.1000000,0.0000000,0.0000000,0.0000000); //object(tikitorch01_lvs) (2)
	CreateDynamicObject(2905,2029.6000000,-2470.8000000,12.6000000,0.0000000,0.0000000,0.0000000); //object(kmb_deadleg) (1)
	CreateDynamicObject(686,2029.4000000,-2465.3999000,12.5000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_dead) (1)
	CreateDynamicObject(3092,2026.4000000,-2470.8999000,13.5000000,0.0000000,0.0000000,0.0000000); //object(dead_tied_cop) (1)
	CreateDynamicObject(2906,2014.2000000,-2469.8000000,12.6000000,0.0000000,0.0000000,0.0000000); //object(kmb_deadarm) (1)
	CreateDynamicObject(709,1613.2000000,-2426.7000000,12.6000000,0.0000000,0.0000000,0.0000000); //object(sm_vegvbbigbrn) (9)
	CreateDynamicObject(709,1641.6000000,-2432.2000000,12.6000000,0.0000000,0.0000000,0.0000000); //object(sm_vegvbbigbrn) (10)
	CreateDynamicObject(709,1598.2000000,-2451.8999000,12.6000000,0.0000000,0.0000000,0.0000000); //object(sm_vegvbbigbrn) (11)
	CreateDynamicObject(709,1632.2000000,-2456.8000000,12.6000000,0.0000000,0.0000000,0.0000000); //object(sm_vegvbbigbrn) (12)
	CreateDynamicObject(709,1450.3000000,-2459.0000000,12.6000000,0.0000000,0.0000000,0.0000000); //object(sm_vegvbbigbrn) (13)
	CreateDynamicObject(709,1476.6000000,-2445.3999000,12.6000000,0.0000000,0.0000000,0.0000000); //object(sm_vegvbbigbrn) (14)
	CreateDynamicObject(709,1494.4000000,-2464.2000000,12.6000000,0.0000000,0.0000000,0.0000000); //object(sm_vegvbbigbrn) (15)
	CreateDynamicObject(709,1519.0000000,-2630.8999000,12.5000000,0.0000000,0.0000000,0.0000000); //object(sm_vegvbbigbrn) (16)
	CreateDynamicObject(709,1488.5000000,-2642.5000000,12.5000000,0.0000000,0.0000000,0.0000000); //object(sm_vegvbbigbrn) (17)
	CreateDynamicObject(709,1480.0000000,-2626.1001000,12.5000000,0.0000000,0.0000000,0.0000000); //object(sm_vegvbbigbrn) (18)
	CreateDynamicObject(708,1474.2000000,-2639.3999000,12.5000000,0.0000000,0.0000000,0.0000000); //object(sm_veg_tree4_vbig) (5)
	CreateDynamicObject(708,1508.5000000,-2599.2000000,12.5000000,0.0000000,0.0000000,0.0000000); //object(sm_veg_tree4_vbig) (6)
	CreateDynamicObject(3594,1488.9000000,-2590.1001000,13.2000000,0.0000000,0.0000000,0.0000000); //object(la_fuckcar1) (15)
	CreateDynamicObject(3594,1470.9000000,-2584.8000000,13.2000000,0.0000000,0.0000000,0.0000000); //object(la_fuckcar1) (16)
	CreateDynamicObject(3594,1491.9000000,-2580.6001000,13.2000000,0.0000000,0.0000000,0.0000000); //object(la_fuckcar1) (17)
	CreateDynamicObject(3594,1512.3000000,-2587.3999000,13.2000000,0.0000000,0.0000000,0.0000000); //object(la_fuckcar1) (18)
	CreateDynamicObject(3594,1545.0000000,-2596.7000000,12.7000000,0.0000000,0.0000000,0.0000000); //object(la_fuckcar1) (19)
	CreateDynamicObject(3594,1523.3000000,-2586.8999000,13.2000000,0.0000000,0.0000000,0.0000000); //object(la_fuckcar1) (20)
	CreateDynamicObject(1457,1625.5000000,-2640.6001000,14.2000000,0.0000000,0.0000000,0.0000000); //object(dyn_outhouse_2) (1)
	CreateDynamicObject(3578,1705.4000000,-2592.3000000,13.3000000,142.0000000,112.0000000,4.0000000); //object(dockbarr1_la) (1)
	CreateDynamicObject(928,1721.1000000,-2595.1001000,12.8000000,0.0000000,0.0000000,0.0000000); //object(rubbish_box1) (1)
	CreateDynamicObject(17552,1731.4000000,-2586.6001000,17.6000000,0.0000000,0.0000000,0.0000000); //object(burnhous1_lae2) (2)
	CreateDynamicObject(4867,1733.8000000,-2530.0000000,12.5000000,0.0000000,0.0000000,0.0000000); //object(lasrnway3_las) (1)
	CreateDynamicObject(4865,1653.9000000,-2599.3999000,12.5000000,0.0000000,0.0000000,0.0000000); //object(lasrnway2_las) (1)
	CreateDynamicObject(11502,1669.0000000,-2625.0000000,12.5000000,0.0000000,0.0000000,0.0000000); //object(des_weebarn1_) (1)

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

public LoadUser_data(playerid,name[],value[])
{
    INI_Int("Password",PlayerInfo[playerid][ZVHPass]);
    INI_Int("Cash",PlayerInfo[playerid][ZVHCash]);
    INI_Int("Kills",PlayerInfo[playerid][ZVHKills]);
    INI_Int("Deaths",PlayerInfo[playerid][ZVHDeaths]);
    INI_Int("Score",PlayerInfo[playerid][ZVHScore]);
    return 1;
}

stock UserPath(playerid)
{
    new string[128],playername[MAX_PLAYER_NAME];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),PATH,playername);
    return string;
}

stock udb_hash(buf[]) {
    new length=strlen(buf);
    new s1 = 1;
    new s2 = 0;
    new n;
    for (n=0; n<length; n++)
    {
       s1 = (s1 + buf[n]) % 65521;
       s2 = (s2 + s1)     % 65521;
    }
    return (s2 << 16) + s1;
}

public OnGameModeExit()
{
	// u can add here wut to do when gamemode is exiting
    for(new i=0;i<MAX_PLAYERS;i++) {
        TextDrawDestroy(td_fuel[i]);
        TextDrawDestroy(td_vhealth[i]);
        TextDrawDestroy(td_vspeed[i]);
        TextDrawDestroy(td_box[i]);
    }
 	new p = GetMaxPlayers();
  	for (new i=0; i < p; i++) {
   		SetPVarInt(i, "laser", 0);
     	RemovePlayerAttachedObject(i, 0);
   	}
 	return 1;
}

public OnPlayerConnect(playerid)
{
 // this is on player connect u can do add any things like on player connect send him welcome message or more.
	group[playerid][gid] = -1;
	group[playerid][invited] = -1;
	group[playerid][attemptjoin] = -1;
    if(IsPlayerNPC(playerid)){
	SpawnPlayer(playerid);
	}
	pCPEnable [playerid] = true;
	PlayerInfo[playerid][ZVHScore] = 0;
    if(fexist(UserPath(playerid)))
    {
        INI_ParseFile(UserPath(playerid), "LoadUser_%s", .bExtra = true, .extra = playerid);
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,""COL_WHITE"Login",""COL_WHITE"Account already registered enter your password to signin.","Login","Quit");
    }
    else
    {
        ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD,""COL_WHITE"Registering...",""COL_WHITE"Register your account at Zombies VS Humans","Register","Quit");
    }
 	new pname[MAX_PLAYER_NAME], string[22 + MAX_PLAYER_NAME];
    GetPlayerName(playerid, pname, sizeof(pname));
    format(string, sizeof(string), "%s has joined the server", pname);
    SendClientMessageToAll(GREEN, string);
   	lastTPTime[playerid] = 0;
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
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
	switch(reason)
	{
	case 0: format(string, sizeof(string), "%s has left the server. (Lost Connection)", pName);
	case 1: format(string, sizeof(string), "%s has left the server. (Leaving)", pName);
	case 2: format(string, sizeof(string), "%s has left the server. (Kicked)", pName);
	}
	SendClientMessageToAll(BLUE, string);
	return 1;
}

COMMAND:ranks(playerid,params[])
{
    ShowPlayerDialog(playerid,1,DIALOG_STYLE_MSGBOX,"Ranks",""COL_WHITE"0 - Freshmeat ("#RANK_0_SCORE" score)\n1 - Bandit ("#RANK_1_SCORE" score)\n2 - Survivor ("#RANK_2_SCORE" score)\n3 - Manhunt ("#RANK_3_SCORE" score)\n4 - Zombie Hunter ("#RANK_4_SCORE" score)\n5 - Specialist ("#RANK_5_SCORE" score)\n6 - Mastermind ("#RANK_6_SCORE" score)\n7 - Terminator ("#RANK_7_SCORE" score)","OK","");
	return 1;
}

COMMAND:myrank(playerid,params[])
{
	if (GetPlayerScore(playerid) >= RANK_0_SCORE && GetPlayerScore(playerid) < RANK_1_SCORE)
	{
	    SendClientMessage(playerid,COLOR_WHITE,"Your current rank is 'Freshmeat' (Rank 0)");
	    SendClientMessage(playerid,COLOR_WHITE,"Type /ranks to find out more information about ranks");
	}
	if (GetPlayerScore(playerid) >= RANK_1_SCORE && GetPlayerScore(playerid) < RANK_2_SCORE)
	{
	    SendClientMessage(playerid,COLOR_WHITE,"Your current rank is 'Bandit' (Rank 1)");
	    SendClientMessage(playerid,COLOR_WHITE,"Type /ranks to find out more information about ranks");
	}
	if (GetPlayerScore(playerid) >= RANK_2_SCORE && GetPlayerScore(playerid) < RANK_3_SCORE)
	{
	    SendClientMessage(playerid,COLOR_WHITE,"Your current rank is 'Survivor' (Rank 2)");
	    SendClientMessage(playerid,COLOR_WHITE,"Type /ranks to find out more information about ranks");
	}
	if (GetPlayerScore(playerid) >= RANK_3_SCORE && GetPlayerScore(playerid) < RANK_4_SCORE)
	{
	    SendClientMessage(playerid,COLOR_WHITE,"Your current rank is 'Manhunt' (Rank 3)");
	    SendClientMessage(playerid,COLOR_WHITE,"Type /ranks to find out more information about ranks");
	}
	if (GetPlayerScore(playerid) >= RANK_4_SCORE && GetPlayerScore(playerid) < RANK_5_SCORE)
	{
	    SendClientMessage(playerid,COLOR_WHITE,"Your current rank is 'Zombie Hunter' (Rank 4)");
	    SendClientMessage(playerid,COLOR_WHITE,"Type /ranks to find out more information about ranks");
	}
	if (GetPlayerScore(playerid) >= RANK_5_SCORE && GetPlayerScore(playerid) < RANK_6_SCORE)
	{
	    SendClientMessage(playerid,COLOR_WHITE,"Your current rank is 'Specialist' (Rank 5)");
	    SendClientMessage(playerid,COLOR_WHITE,"Type /ranks to find out more information about ranks");
	}
	if (GetPlayerScore(playerid) >= RANK_6_SCORE && GetPlayerScore(playerid) < RANK_7_SCORE)
	{
	    SendClientMessage(playerid,COLOR_WHITE,"Your current rank is 'Terminator' (Rank 6)");
	    SendClientMessage(playerid,COLOR_WHITE,"Type /ranks to find out more information about ranks");
	}
	if (GetPlayerScore(playerid) >= RANK_7_SCORE)
	{
	    SendClientMessage(playerid,COLOR_WHITE,"Your current rank is 'Leon Kennedy' (Rank 7)");
	    SendClientMessage(playerid,COLOR_WHITE,"Type /ranks to find out more information about ranks");
	}
 	return 1;
}



COMMAND:pm(playerid, params[])
{
	new pName[MAX_PLAYER_NAME], string[250], String[250],target, tName[MAX_PLAYER_NAME];
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

COMMAND:pms(playerid, params[])
{
	if(pInfo[playerid][NoPM] == 0)
	{
	pInfo[playerid][NoPM] = 1;
	SendClientMessage(playerid, -1, "{FF0000}INFO : {FFFFFF}You Have Disabled PMS No One Will Be Able To PM You!");
	}
	else
	{
	pInfo[playerid][NoPM] = 0;
	SendClientMessage(playerid, -1, "{FF0000}INFO : {FFFFFF}You Have Enabled PMS EveryOne Will Be Able To PM You!");
	}
	return 1;
}

COMMAND:reply(playerid, params[])
{
	new pName[MAX_PLAYER_NAME], string[128],target, tName[MAX_PLAYER_NAME];
	if(sscanf(params, "s", params)) return SendClientMessage(playerid, COLOR_RED, "USAGE: /reply [MESSAGE]");
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

COMMAND:r(playerid, params[])
{
	new pName[MAX_PLAYER_NAME], string[128],target, tName[MAX_PLAYER_NAME];
	if(sscanf(params, "s", params)) return SendClientMessage(playerid, COLOR_RED, "USAGE: /reply [MESSAGE]");
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

COMMAND:inv(playerid, params[])
{
        if(gTeam[playerid] == TEAM_HUMAN) {
            ShowPlayerDialog(playerid,04042,DIALOG_STYLE_LIST,"Human Inventory","Flashlight On\nFlashlight Off\nLaser On\nLaser Off\nLaser Colors","Use","Cancel");
        }

        if(gTeam[playerid] == TEAM_ZOMBIE) {
            ShowPlayerDialog(playerid,04062,DIALOG_STYLE_LIST," Zombies Inventory","Digger","Use","Cancel");
        }

        return 1;
}

COMMAND:bezombie(playerid, params[])
{
	if(gTeam[playerid] == TEAM_HUMAN) {
 		SetPlayerHealth(playerid,0);
   	}
	if(gTeam[playerid] == TEAM_ZOMBIE) {
 		SendClientMessage(playerid,COLOR_YELLOW," You are already a zombie");
   	}
	return 1;
}

COMMAND:shelp(playerid, params[])
{
    	ShowPlayerDialog(playerid,04048,DIALOG_STYLE_MSGBOX,"Server Help"," This is Zombie VS Survivours Gamemode Created by Owen007. \n The whole Los Santos have been destroyed because a virus name (T) has been spread all over the LSA. \n There are a few survivours left now you have to survive.","Ok","Yea ofc");
        return 1;
}
COMMAND:zhelp(playerid, params[])
{
    	ShowPlayerDialog(playerid,04060,DIALOG_STYLE_MSGBOX,"Zombies Help"," Hello Zombies, \n You have to kill those bloddy survivours. \n You have some awesome powers like use your /inv. \n You can also bite them using your jump key. \n Use your knife in your hand just Aim and fire to shoot a knife. \n When no weapon in hand Press fire key to bite survivours. \n Want to fuck off survivours use Screamer press your walk key to use screamer mainy ALT.","Ok","Yea ofc");
        return 1;
}
COMMAND:hhelp(playerid, params[])
{
    	ShowPlayerDialog(playerid,04061,DIALOG_STYLE_MSGBOX,"Humans Help"," Hello Survivours, \n You have to survive the apocalypse the bloddy zombies are after you. \n Umbrella Corp has given you some awesome gadgets use /inv. \n You have clear all Checkpoints to win the round. \n Beware of zombies they can chase you whereever you go you can't hide. \n You get some money if u kill a zombie and scores. \n You can't run from zombies so try to kill them.","Ok","Yea ofc");
        return 1;
}
COMMAND:gcmds(playerid, params[])
{
    	ShowPlayerDialog(playerid,04048,DIALOG_STYLE_MSGBOX,"Group Commands"," /groupcreate,  /groupleave,  /groupinvite,  /groupleader,  /groupjoin,  /groupkick, /groupmessage  , /grouplist,  /groups ","Ok","Yea ofc");
        return 1;
}
COMMAND:sengine(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, LIGHTBLUE, "You need to be in a vehicle to use this command");

	if(vehEngine[vehicleid] == 0)
	{
	    vehEngine[vehicleid] = 2;
		SetTimerEx("StartEngine", 3000, 0, "i", playerid);
		SendClientMessage(playerid, GREEN, "Vehicle engine starting");
	}
	else if(vehEngine[vehicleid] == 1)
	{
	    vehEngine[vehicleid] = 0;
		TogglePlayerControllable(playerid, 0);
		SendClientMessage(playerid, GREEN, "Vehicle engine stopped successfully");
		SendClientMessage(playerid, LIGHTBLUE, "Press LMB or /sengine to start the Vehicle again");
	}
	return 1;
}
COMMAND:cmds(playerid, params[])
{
    	ShowPlayerDialog(playerid,04047,DIALOG_STYLE_MSGBOX,"Server Commands","/shelp , /zhelp  ,/hhelp,  /rules , /buyweap , /cmds, /stats, /sengine, /bezombie, /pm, /pms, /reply, /r, /gcmds, /inv, /rcon login passwordhere, /rconinfo.","Ok","Yea ofc");
        return 1;
}
COMMAND:stats(playerid, params[])
{
    	new password = PlayerInfo[playerid][ZVHPass];
		new money = PlayerInfo[playerid][ZVHCash];
		new deaths = PlayerInfo[playerid][ZVHDeaths];
		new kills = PlayerInfo[playerid][ZVHKills];
		new score = PlayerInfo[playerid][ZVHScore];
		new string[500];
		format(string,sizeof(string),"Password: %d | Money: %d | Deaths: %d | Kills: %d | Score: %d",password,money,deaths,kills,score);
		SendClientMessage(playerid,GREEN,string);
        return 1;
}
COMMAND:rconinfo(playerid, params[])
{
        ShowPlayerDialog(playerid,04046,DIALOG_STYLE_MSGBOX,"RCON Info","If you are using the rcon filescript I provided then do /uracmds to check commands of rcon admin.","Ok","Yea ofc");
        return 1;
}
COMMAND:rules(playerid, params[])
{
        ShowPlayerDialog(playerid,04045,DIALOG_STYLE_MSGBOX,"Server Rules"," Donot Bunny Hop to gain speed or you will be punished.\n Dont use hacks.\n Dont abuse each other.\n Only English in the main chat.\n No account sharing allowed.\n Scores farming leads to perm ban.","Ok","Yea ofc");
        return 1;
}
COMMAND:buyweap(playerid, params[])
{
        if(gTeam[playerid] == TEAM_HUMAN) {
            ShowPlayerDialog(playerid,04041,DIALOG_STYLE_TABLIST_HEADERS,"Weapons Shop","Weapon\tPrice\tAmmo\nSawnOffs\t$30000\t500\nDesert Eagle\t$6000\t500\nM4-Carbine\t$20000\t500\nMP5\t$7000\t500\nUzi\t$6500\t500\nKatana\t$8000\tN/A\nTec-9\t$4000\t500","Buy","Cancel");
        }

        if(gTeam[playerid] == TEAM_ZOMBIE) {
            SendClientMessage(playerid,ORANGE,"Weapons are made for Survivours..");
        }

        return 1;
}


COMMAND:groupcreate(playerid, params[])
{
  	if(group[playerid][gid] != -1) return SendClientMessage(playerid, 0xFF0000, "Leave your group with {FFFFFF}/groupleave{FF0000} before creating a new one!");
  	if(strlen(params) > 49 || strlen(params) < 3) return SendClientMessage(playerid, 0xFF0000, "Usage: {FFFFFF}/groupcreate{FF0000} (Group name 3-50 characters)!");
	if(IsGroupTaken(params)) return SendClientMessage(playerid, 0xFF0000, "Group name is already in use!");
	CreateGroup(params, playerid);
  	return 1;
}

COMMAND:groupleave(playerid, params[])
{
	if(group[playerid][gid] == -1) return SendClientMessage(playerid, 0xFF0000, "You are not in a group to leave one!");
 	LeaveGroup(playerid, 0);
 	return 1;
}

COMMAND:groupinvite(playerid, params[])
{
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

COMMAND:groupleader(playerid, params[])
{
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

COMMAND:groupjoin(playerid, params[])
{
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
	format(string, sizeof(string), "{FFFFFF}%s(%d) {FFCC66}has requested to join your group. Type /groupinvite %d to accept", pname, playerid, playerid);
	SendMessageToLeader(grid, string);
	return 1;
}

COMMAND:groupkick(playerid, params[])
{
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

COMMAND:groupmessage(playerid, params[])
{
	if(group[playerid][gid] == -1) return SendClientMessage(playerid, 0xFF0000, "You are not in a group, you cannot group message!");
	if(isnull(params)) return SendClientMessage(playerid, 0xFF0000, "Usage: {FFFFFF}/gm{FF0000} (message)");
	new pname[24], string[140+24];
	GetPlayerName(playerid, pname, 24);
	format(string, sizeof(string), "%s(%d): %s", pname, playerid, params);
	SendMessageToAllGroupMembers(group[playerid][gid], string);
	return 1;
}


COMMAND:grouplist(playerid, params[])
{
    if(isnull(params) && group[playerid][gid] == -1) return SendClientMessage(playerid, 0xFF0000, "Usage: {FFFFFF}/grouplist{FF0000} (group)");
	if(isnull(params))
	{
 		DisplayGroupMembers(group[playerid][gid], playerid);
   		return 1;
	}
 	new grid = strval(params);
  	if(!groupinfo[grid][active]) return SendClientMessage(playerid, 0xFF0000, "The group ID you have entered is not active!");
   	DisplayGroupMembers(grid, playerid);
	return 1;
}

COMMAND:groups(playerid, params[])
{
    ListGroups(playerid);
    return 1;
}

COMMAND:grl(playerid, params[])
	return cmd_groupleave(playerid, params);

COMMAND:grc(playerid, params[])
	return cmd_groupcreate(playerid, params);

COMMAND:gri(playerid, params[])
	return cmd_groupinvite(playerid, params);

COMMAND:grlead(playerid, params[])
	return cmd_groupleader(playerid, params);

COMMAND:grj(playerid, params[])
	return cmd_groupjoin(playerid, params);

COMMAND:grk(playerid, params[])
	return cmd_groupkick(playerid, params);

COMMAND:gm(playerid, params[])
	return cmd_groupmessage(playerid, params);

COMMAND:grlist(playerid, params[])
	return cmd_grouplist(playerid, params);
	
public OnPlayerCommandPerformed(playerid, cmdtext[], success)
	{
	if(! success) return GameTextForPlayer(playerid, "~w~Unknown command~n~Use ~r~/cmds ~w~for commands list", 5000, 5);
		return 1;
	}

public OnPlayerSpawn(playerid)  //--- On palyer spawn--// read this u will easily understand it.
{
	if(IsPlayerNPC(playerid)) //Checks if the player that just spawned is an NPC.
  	{
  	new npcname[MAX_PLAYER_NAME];
  	GetPlayerName(playerid, npcname, sizeof(npcname)); //Getting the NPC's name.
  	if(!strcmp(npcname, "Owen007", true)) //Checking if the NPC's name is Owen007.
    	{
    	new Text3D:label = Create3DTextLabel("Owen007", GREEN, 30.0, 40.0, 50.0, 40.0, 0);
    	Attach3DTextLabelToPlayer(label, playerid, 0.0, 0.0, 1.5);
      	PutPlayerInVehicle(playerid, NPCVehicle, 0); //Putting the NPC into the vehicle we created for
  		return 1;
	}
  	if(!strcmp(npcname, "AbyssMorgan", true)) //Checking if the NPC's name is AbyssMorgan.
    	{
    	new Text3D:label = Create3DTextLabel("AbyssMorgan", GREEN, 30.0, 40.0, 50.0, 40.0, 0);
    	Attach3DTextLabelToPlayer(label, playerid, 0.0, 0.0, 1.5);
      	PutPlayerInVehicle(playerid, NPCVehicle2, 0); //Putting the NPC into the vehicle we created for
  		return 1;
	}
  	if(!strcmp(npcname, "Sreyas", true)) //Checking if the NPC's name is Sreyas.
    	{
    	new Text3D:label = Create3DTextLabel("Sreyas", GREEN, 30.0, 40.0, 50.0, 40.0, 0);
    	Attach3DTextLabelToPlayer(label, playerid, 0.0, 0.0, 1.5);
      	PutPlayerInVehicle(playerid, NPCVehicle3, 0); //Putting the NPC into the vehicle we created for
  		return 1;
	}
  	if(!strcmp(npcname, "FahadKing", true)) //Checking if the NPC's name is FahadKing.
    	{
    	new Text3D:label = Create3DTextLabel("FahadKing", GREEN, 30.0, 40.0, 50.0, 40.0, 0);
    	Attach3DTextLabelToPlayer(label, playerid, 0.0, 0.0, 1.5);
      	PutPlayerInVehicle(playerid, NPCVehicle4, 0); //Putting the NPC into the vehicle we created for
  		return 1;
  	}
  	return 1;
}
	SetPlayerScore(playerid, PlayerInfo[playerid][ZVHScore]);
	if (!GetPVarInt(playerid, "color")) SetPVarInt(playerid, "color", 18643);
    SetPlayerWorldBounds(playerid, 2907.791, 175.1681, -910.8743, -2791.012);
	if(gTeam[playerid] == TEAM_HUMAN) {
    	SetPlayerPos(playerid,1537.90,-1682.58,13.55);
        SetPlayerTime(playerid, 13,0 );
        SetPlayerColor(playerid,TEAM_HUMAN_COLOR);
        SendClientMessage(playerid,ORANGE,"Tip: Kill all Zombies and Survive till the end.");
        EnableStuntBonusForAll(0);
        SetPlayerTeam(playerid,TEAM_HUMAN);
   		ToggleKnifeShootForPlayer(playerid,false);
    ShowPlayerDialog(playerid,0,DIALOG_STYLE_LIST,"Select Class","Newibe (Rank 0)\nFreshmeat(Rank 0)\nSurvivor (Rank 1)\nManhunt (Rank 1)\nZombie Hunter (Rank 2)\nSpecialist (Rank 3)\nMastermind (Rank 4)\nTerminator (Rank 5)\n","Select","");
	if (GetPlayerScore(playerid) >= RANK_0_SCORE && GetPlayerScore(playerid) < RANK_1_SCORE)
	{
	    SendClientMessage(playerid,COLOR_WHITE,"Your current rank is 'Freshmeat aka Newibe' (Rank 0)");
	    SendClientMessage(playerid,COLOR_WHITE,"Rank bonus: None");
	    SendClientMessage(playerid,COLOR_WHITE,"Type /ranks to find out more information about ranks");
	}
	if (GetPlayerScore(playerid) >= RANK_1_SCORE && GetPlayerScore(playerid) < RANK_2_SCORE)
	{
	    SendClientMessage(playerid,COLOR_WHITE,"Your current rank is 'Bandit' (Rank 1)");
	    SendClientMessage(playerid,COLOR_WHITE,"Rank bonus: +5 Armour");
	    SetPlayerArmour(playerid, 5);
	    SendClientMessage(playerid,COLOR_WHITE,"Type /ranks to find out more information about ranks");
	}
	if (GetPlayerScore(playerid) >= RANK_2_SCORE && GetPlayerScore(playerid) < RANK_3_SCORE)
	{
	    SendClientMessage(playerid,COLOR_WHITE,"Your current rank is 'Survivor' (Rank 2)");
	    SendClientMessage(playerid,COLOR_WHITE,"Rank bonus: +10 Armour");
	    SetPlayerArmour(playerid, 10);
	    SendClientMessage(playerid,COLOR_WHITE,"Type /ranks to find out more information about ranks");
	}
	if (GetPlayerScore(playerid) >= RANK_3_SCORE && GetPlayerScore(playerid) < RANK_4_SCORE)
	{
	    SendClientMessage(playerid,COLOR_WHITE,"Your current rank is 'Manhunt' (Rank 3)");
	    SendClientMessage(playerid,COLOR_WHITE,"Rank bonus: +10 Armour");
	    SetPlayerArmour(playerid, 10);
	    SendClientMessage(playerid,COLOR_WHITE,"Type /ranks to find out more information about ranks");
	}
	if (GetPlayerScore(playerid) >= RANK_4_SCORE && GetPlayerScore(playerid) < RANK_5_SCORE)
	{
	    SendClientMessage(playerid,COLOR_WHITE,"Your current rank is 'Zombie Hunter' (Rank 4)");
	    SendClientMessage(playerid,COLOR_WHITE,"Rank bonus: +15 Armour");
	    SetPlayerArmour(playerid, 15);
	    SendClientMessage(playerid,COLOR_WHITE,"Type /ranks to find out more information about ranks");
	}
	if (GetPlayerScore(playerid) >= RANK_5_SCORE && GetPlayerScore(playerid) < RANK_6_SCORE)
	{
	    SendClientMessage(playerid,COLOR_WHITE,"Your current rank is 'Specialist' (Rank 5)");
	    SendClientMessage(playerid,COLOR_WHITE,"Rank bonus: +20 Armour");
	    SetPlayerArmour(playerid, 20);
	    SendClientMessage(playerid,COLOR_WHITE,"Type /ranks to find out more information about ranks");
	}
	if (GetPlayerScore(playerid) >= RANK_6_SCORE && GetPlayerScore(playerid) < RANK_7_SCORE)
	{
	    SendClientMessage(playerid,COLOR_WHITE,"Your current rank is 'Terminator' (Rank 6)");
	    SendClientMessage(playerid,COLOR_WHITE,"Rank bonus: +20 Armour");
	    SetPlayerArmour(playerid, 20);
	    SendClientMessage(playerid,COLOR_WHITE,"Type /ranks to find out more information about ranks");
	}
	if (GetPlayerScore(playerid) >= RANK_7_SCORE)
	{
	    SendClientMessage(playerid,COLOR_WHITE,"Your current rank is 'Leon Kennedy' (Rank 7)");
	    SendClientMessage(playerid,COLOR_WHITE,"Rank bonus: +25 Armour");
	    SetPlayerArmour(playerid, 25);
	    SendClientMessage(playerid,COLOR_WHITE,"Type /ranks to find out more information about ranks");
	}
 	return 1;
}
    if(gTeam[playerid] == TEAM_ZOMBIE) {
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

public OnPlayerRequestClass(playerid, classid) //--- this is the screen which appears when u select between team zombie and human.
{
	if(IsPlayerNPC(playerid)) return 1;
	SetPlayerPos(playerid, 2121.7322, -1623.2563, 26.8368);
	SetPlayerFacingAngle(playerid, 60.2360);
	SetPlayerCameraPos(playerid, 2111.9089 ,-1623.7340, 24.2307);
	SetPlayerCameraLookAt(playerid, 2121.7322, -1623.2563, 26.8368);
	SetPlayerWeather(playerid,700);
    if(classid >= 12 && classid <= 78) {
        GameTextForPlayer(playerid,"~b~Humans",5000,6);
        gTeam[playerid] = TEAM_HUMAN;
    } else { ///(classid >= 0 && classid <= 11)
        gTeam[playerid] = TEAM_ZOMBIE;
        GameTextForPlayer(playerid,"~p~Zombies",5000,6);
    }
    return 1;
}

public OnPlayerDeath(playerid, killerid, reason)  //--- on player death waht will happen these are wriiten in these. u can also give him some weapons when he get died. ;)
{
    if(gTeam[playerid] == TEAM_HUMAN) {
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

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if(gTeam[playerid] == TEAM_ZOMBIE) {
    SendClientMessage(playerid,ORANGE,"Zombies are bad drivers.");
    }
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{

    if(dialogid==04041) {
        if(response) {
            if(listitem==0) {
                if(GetPlayerMoney(playerid) < 30000) return SendClientMessage(playerid, GRAY, "You don't have enough Cash!");
                GivePlayerWeapon(playerid,26,500);
                GivePlayerMoney(playerid,-30000);
                SendClientMessage(playerid,GREEN,"You Have Purchased Sawnoffs for $30000.");
            }
            if(listitem==1) {
                if(GetPlayerMoney(playerid) < 6000) return SendClientMessage(playerid, GRAY, "You don't have enough Cash!");
                GivePlayerWeapon(playerid,24,500);
                GivePlayerMoney(playerid,-6000);
                SendClientMessage(playerid,GREEN,"You Have Purchased Desert Eagle for $6000.");
            }
            if(listitem==2) {
                if(GetPlayerMoney(playerid) < 20000) return SendClientMessage(playerid, GRAY, "You don't have enough Cash!");
                GivePlayerWeapon(playerid,31,500);
                GivePlayerMoney(playerid,-20000);
                SendClientMessage(playerid,GREEN,"You Have Purchased M4-Carbine for $20000.");
            }
            if(listitem==3) {
                if(GetPlayerMoney(playerid) < 7000) return SendClientMessage(playerid, GRAY, "You don't have enough Cash!");
                GivePlayerWeapon(playerid,29,500);
                GivePlayerMoney(playerid,-7000);
                SendClientMessage(playerid,GREEN,"You Have Purchased MP5 for $7000.");
            }
            if(listitem==4) {
                if(GetPlayerMoney(playerid) < 6500) return SendClientMessage(playerid, GRAY, "You don't have enough Cash!");
                GivePlayerWeapon(playerid,28,500);
                GivePlayerMoney(playerid,-6500);
                SendClientMessage(playerid,GREEN,"You Have Purchased Uzi for $6500.");
            }
            if(listitem==5) {
                if(GetPlayerMoney(playerid) < 8000) return SendClientMessage(playerid, GRAY, "You don't have enough Cash!");
                GivePlayerWeapon(playerid,8,500);
                GivePlayerMoney(playerid,-8000);
                SendClientMessage(playerid,GREEN,"You Have Purchased Katana for $8000.");
            }
            if(listitem==6) {
                if(GetPlayerMoney(playerid) < 4000) return SendClientMessage(playerid, GRAY, "You don't have enough Cash!");
                GivePlayerWeapon(playerid,32,500);
                GivePlayerMoney(playerid,-4000);
                SendClientMessage(playerid,GREEN,"You Have Purchased Tec Nine for $4000.");
            }

        }
    }
    if(dialogid==04042) {
        if(response) {
            if(listitem==0) {
				if(flashlight==0)
				SetPlayerAttachedObject(playerid, 1,18656, 5, 0.1, 0.038, -0.1, -90, 180, 0, 0.03, 0.03, 0.03);
				SetPlayerAttachedObject(playerid, 2,18641, 5, 0.1, 0.02, -0.05, 0, 0, 0, 1, 1, 1);
				flashlight=1;
    		}
            if(listitem==1) {
                if(flashlight==1)
				RemovePlayerAttachedObject(playerid,1);
				RemovePlayerAttachedObject(playerid,2);
				flashlight=0;
			}
            if(listitem==2) {
   				SendClientMessage(playerid, 0x00E800FF, "Laser Activated");
				SetPVarInt(playerid, "laser", 1);
		        SetPVarInt(playerid, "color", GetPVarInt(playerid, "color"));
    		}
			if(listitem==3) {
   				SendClientMessage(playerid, 0x00E800FF, "Laser Deactivated");
       			SetPVarInt(playerid, "laser", 0);
       			RemovePlayerAttachedObject(playerid, 0);
       		}
    		if(listitem==4) {
				ShowPlayerDialog(playerid, 04044, DIALOG_STYLE_LIST, "{FFFFFF}Laser Color", "Blue\nPink\nOrange\nGreen\nYellow", "Select", "Cancel");
			}
		}
	}
	if(dialogid==04044) {
    	if(response) {
        	if(listitem==0) {
        	    SetPVarInt(playerid, "color", 19080);
 			}
 			if(listitem==1) {
 			    SetPVarInt(playerid, "color", 19081);
			}
			if(listitem==2) {
				SetPVarInt(playerid, "color", 19082);
			}
			if(listitem==3) {
			    SetPVarInt(playerid, "color", 19083);
			}
			if(listitem==4) {
			    SetPVarInt(playerid, "color", 19084);
			}
		}
	}
	if(dialogid==04062) {
    	if(response) {
    		if(listitem==0) {
				ShowPlayerDialog(playerid, 04063, DIALOG_STYLE_LIST, "Zombies Digger","Zombies Underground Hive 1\nZombies Underground Hive 2\nZombies Underground Hive 3\nZombies Underground Hive 4\nZombies Underground Hive 5\nZombies Underground Hive 6\nZombies Underground Hive 7\nZombies Underground Hive 8", "Select", "Cancel");
			}
		}
	}
	if(dialogid==04063) {
    	if(response) {
    		if(gettime() < lastTPTime[playerid])return SendClientMessage(playerid, -1, "You can't dig right now wait 3 min to dig again..");
        	if(listitem==0) {
        	    SetPlayerPos(playerid, 1547.29,-1168.56,24.08);
  	    		lastTPTime[playerid] = (gettime() + 180);
 			}
 			if(listitem==1) {
 			    SetPlayerPos(playerid, 395.57,-1643.37,31.16);
    			lastTPTime[playerid] = (gettime() + 180);
			}
			if(listitem==2) {
				SetPlayerPos(playerid, 1820.14,-1758.75,13.38);
				lastTPTime[playerid] = (gettime() + 180);
			}
			if(listitem==3) {
			    SetPlayerPos(playerid, 2496.49,-1590.69,23.03);
	    		lastTPTime[playerid] = (gettime() + 180);
			}
			if(listitem==4) {
			    SetPlayerPos(playerid, 873.06,-1358.05,13.55);
	    		lastTPTime[playerid] = (gettime() + 180);
			}
			if(listitem==5) {
 			    SetPlayerPos(playerid, 448.95,-1587.97,25.30);
 				lastTPTime[playerid] = (gettime() + 180);
			}
			if(listitem==6) {
				SetPlayerPos(playerid, 1278.66,-1266.55,13.53);
				lastTPTime[playerid] = (gettime() + 180);
			}
			if(listitem==7) {
			    SetPlayerPos(playerid, 2586.94,-992.30,79.03);
	    		lastTPTime[playerid] = (gettime() + 180);
			}
		}
	}
	if(dialogid == 0)
	{
	    if(response)
	    {
	        if(listitem == 0)
	        {
	            ResetPlayerWeapons(playerid);
	            SendClientMessage(playerid,COLOR_WHITE,"You selected '"COL_GREEN"Freshmeat"COL_WHITE"' class.");
	            GivePlayerWeapon(playerid, 22, 200);//Pistol
	            GivePlayerWeapon(playerid, 2, 0);//Pistol
	        }
	    }
 	}
 	if(dialogid == 0)
 	{
 	    if(response)
 	    {
 	        if(listitem == 1)
 	        {
 	            ResetPlayerWeapons(playerid);
 	            SendClientMessage(playerid,COLOR_WHITE,"You selected '"COL_GREEN"Bandit"COL_WHITE"' class.");
 	            GivePlayerWeapon(playerid, 23, 200);//Silenced Pistol
 	            GivePlayerWeapon(playerid, 3, 0);//Pistol
 	        }
 	    }
 	}
    if(dialogid == 0)
 	{
 	    if(response)
 	    {
 	        if(listitem == 2)
 	        {
 	            if (GetPlayerScore(playerid) < RANK_1_SCORE)
 	            {
 	                SendClientMessage(playerid,COLOR_RED,"ERROR: You need "#RANK_1_SCORE" score (Rank 1) to select this rank");
 	                ShowPlayerDialog(playerid,0,DIALOG_STYLE_LIST,"Select Class","Freshmeat (Rank 0)\nBandit(Rank 0)\nSurvivor (Rank 1)\nManhunt (Rank 1)\nZombie Hunter (Rank 2)\nSpecialist (Rank 3)\nMastermind (Rank 4)\nTerminator (Rank 5)\n","Select","");
              	}
              	else
              	    {
              	        ResetPlayerWeapons(playerid);
              			SendClientMessage(playerid,COLOR_WHITE,"You selected '"COL_GREEN"Survivor"COL_WHITE"' class.");
              			GivePlayerWeapon(playerid, 23, 100);//Silenced Pistol
		 	            GivePlayerWeapon(playerid, 25, 200);//Shotgun
              		}
            }
		}
	}
	if(dialogid == 0)
 	{
 	    if(response)
 	    {
 	        if(listitem == 3)
 	        {
 	            if (GetPlayerScore(playerid) < RANK_1_SCORE)
 	            {
 	                SendClientMessage(playerid,COLOR_RED,"ERROR: You need "#RANK_1_SCORE" score (Rank 1) to select this rank");
 	                ShowPlayerDialog(playerid,0,DIALOG_STYLE_LIST,"Select Class","Freshmeat (Rank 0)\nBandit(Rank 0)\nSurvivor (Rank 1)\nManhunt (Rank 1)\nZombie Hunter (Rank 2)\nSpecialist (Rank 3)\nMastermind (Rank 4)\nTerminator (Rank 5)\n","Select","");
              	}
              	else
              	    {
              	        ResetPlayerWeapons(playerid);
              			SendClientMessage(playerid,COLOR_WHITE,"You selected '"COL_GREEN"Gangster"COL_WHITE"' class.");
						GivePlayerWeapon(playerid, 23, 100);//Silenced Pistol
		            	GivePlayerWeapon(playerid, 29, 200);//MP5

		            }
		    }
  	    }
	}
	if(dialogid == 0)
 	{
 	    if(response)
 	    {
 	        if(listitem == 4)
 	        {
 	            if (GetPlayerScore(playerid) < RANK_2_SCORE)
 	            {
 	                SendClientMessage(playerid,COLOR_RED,"ERROR: You need "#RANK_2_SCORE" score (Rank 2) to select this rank");
 	                ShowPlayerDialog(playerid,0,DIALOG_STYLE_LIST,"Select Class","Freshmeat (Rank 0)\nBandit(Rank 0)\nSurvivor (Rank 1)\nManhunt (Rank 1)\nZombie Hunter (Rank 2)\nSpecialist (Rank 3)\nMastermind (Rank 4)\nTerminator (Rank 5)\n","Select","");
              	}
              	else
              	    {
              	        ResetPlayerWeapons(playerid);
              			SendClientMessage(playerid,COLOR_WHITE,"You selected '"COL_GREEN"Double Gangster"COL_WHITE"' class.");
              			GivePlayerWeapon(playerid, 16, 4);//Grenade
		            	GivePlayerWeapon(playerid, 24, 100);//Desert Eagle
		            	GivePlayerWeapon(playerid, 31, 300);//M4
		            }
		    }
  	    }
	}
	if(dialogid == 0)
 	{
 	    if(response)
 	    {
 	        if(listitem == 5)
 	        {
 	            if (GetPlayerScore(playerid) < RANK_3_SCORE)
 	            {
 	                SendClientMessage(playerid,COLOR_RED,"ERROR: You need "#RANK_3_SCORE" score (Rank 3) to select this rank");
 	                ShowPlayerDialog(playerid,0,DIALOG_STYLE_LIST,"Select Class","Freshmeat (Rank 0)\nBandit(Rank 0)\nSurvivor (Rank 1)\nManhunt (Rank 1)\nZombie Hunter (Rank 2)\nSpecialist (Rank 3)\nMastermind (Rank 4)\nTerminator (Rank 5)\n","Select","");
              	}
              	else
              	    {
              	        ResetPlayerWeapons(playerid);
              			SendClientMessage(playerid,COLOR_WHITE,"You selected '"COL_GREEN"Scout"COL_WHITE"' class.");
              			GivePlayerWeapon(playerid, 16, 4);//Grenade
		            	GivePlayerWeapon(playerid, 24, 125);//Desert Eagle
		            	GivePlayerWeapon(playerid, 29, 275);//MP5
		            	GivePlayerWeapon(playerid, 31, 325);//M4
		            }
		    }
  	    }
	}
	if(dialogid == 0)
 	{
 	    if(response)
 	    {
 	        if(listitem == 6)
 	        {
 	            if (GetPlayerScore(playerid) < RANK_4_SCORE)
 	            {
 	                SendClientMessage(playerid,COLOR_RED,"ERROR: You need "#RANK_4_SCORE" score (Rank 4) to select this rank");
 	                ShowPlayerDialog(playerid,0,DIALOG_STYLE_LIST,"Select Class","Freshmeat (Rank 0)\nBandit(Rank 0)\nSurvivor (Rank 1)\nManhunt (Rank 1)\nZombie Hunter (Rank 2)\nSpecialist (Rank 3)\nMastermind (Rank 4)\nTerminator (Rank 5)\n","Select","");
              	}
              	else
              	    {
              	        ResetPlayerWeapons(playerid);
              			SendClientMessage(playerid,COLOR_WHITE,"You selected '"COL_GREEN"Mastermind"COL_WHITE"' class.");
              			GivePlayerWeapon(playerid, 16, 5);//Grenade
		            	GivePlayerWeapon(playerid, 24, 150);//Desert Eagle
		            	GivePlayerWeapon(playerid, 28, 150);//Uzi
		            	GivePlayerWeapon(playerid, 31, 350);//M4
		            }
		    }
  	    }
	}
	if(dialogid == 0)
 	{
 	    if(response)
 	    {
 	        if(listitem == 7)
 	        {
 	            if (GetPlayerScore(playerid) < RANK_5_SCORE)
 	            {
 	                SendClientMessage(playerid,COLOR_RED,"ERROR: You need "#RANK_5_SCORE" score (Rank 5) to select this rank");
 	                ShowPlayerDialog(playerid,0,DIALOG_STYLE_LIST,"Select Class","Freshmeat (Rank 0)\nBandit(Rank 0)\nSurvivor (Rank 1)\nManhunt (Rank 1)\nZombie Hunter (Rank 2)\nSpecialist (Rank 3)\nMastermind (Rank 4)\nTerminator (Rank 5)\n","Select","");
              	}
              	else
              	    {
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
	switch( dialogid )
    {
        case DIALOG_REGISTER:
        {
            if (!response) return Kick(playerid);
            if(response)
            {
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

        case DIALOG_LOGIN:
        {
            if ( !response ) return Kick ( playerid );
            if( response )
            {
                if(udb_hash(inputtext) == PlayerInfo[playerid][ZVHPass])
                {
                    INI_ParseFile(UserPath(playerid), "LoadUser_%s", .bExtra = true, .extra = playerid);
                    GivePlayerMoney(playerid, PlayerInfo[playerid][ZVHCash]);
                    SetPlayerScore(playerid,PlayerInfo[playerid][ZVHScore]);
					ShowPlayerDialog(playerid, DIALOG_SUCCESS_2, DIALOG_STYLE_MSGBOX,""COL_WHITE"Success!",""COL_GREEN"You have successfully logged in!","Ok","");
                }
                else
                {
                    ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,""COL_WHITE"Login",""COL_RED"You have entered an incorrect password.\n"COL_WHITE"Type your password below to login.","Login","Quit");
                }
                return 1;
            }
        }
    }
    return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if (newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
    {
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

	if(newstate == PLAYER_STATE_DRIVER)
	{
	    if(vehEngine[vehicleid] == 0)
	    {
	        TogglePlayerControllable(playerid, 0);
	        SendClientMessage(playerid, LIGHTBLUE, "Press LMB and /sengine to start the vehicle");
	        SendClientMessage(playerid, red, "Vehicle engine is jammed.");
		}
		else if(vehEngine[vehicleid] == 1)
		{
		    TogglePlayerControllable(playerid, 1);
		    SendClientMessage(playerid, GREEN, "Vehicle engine running");

		}
	}
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
   if(newkeys & KEY_WALK) {
        if(gTeam[playerid] == TEAM_ZOMBIE) {
   			if(GetPlayerWeapon(playerid) == 0) {
			ApplyAnimation (playerid,"ON_LOOKERS","shout_01",3.9,0,1,1,1,1,1);
                new victimid = GetClosestPlayers(playerid);
                if(IsPlayerConnected(victimid)) {
                    if(GetDistanceBetweenPlayers(playerid,victimid) < 2) {
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
    if(newkeys & KEY_FIRE) {
        if(gTeam[playerid] == TEAM_ZOMBIE) {
            if(GetPlayerWeapon(playerid) == 0) {
            ApplyAnimation (playerid,"food","EAT_Burger",3.9,0,1,1,1,1,1);
                new victimid = GetClosestPlayers(playerid);
                if(IsPlayerConnected(victimid)) {
                    if(GetDistanceBetweenPlayers(playerid,victimid) < 2) {
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
	if(IsPlayerInAnyVehicle(playerid))
	{
	    if(vehEngine[vehicleid] == 0)
	    {
	        if(newkeys == KEY_FIRE)
	        {
	            PlayAudioStreamForPlayer(playerid, "http://www.sounddogs.com/previews/44/mp3/493673_SOUNDDOGS__au.mp3");
				vehEngine[vehicleid] = 2;
				SetTimerEx("StartEngine", 3000, 0, "i", playerid);
				SendClientMessage(playerid, GREEN, "Vehicle engine starting");
			}
		}
		if(newkeys == KEY_SECONDARY_ATTACK)
		{
		    RemovePlayerFromVehicle(playerid);
		    TogglePlayerControllable(playerid, 1);

		}
	}
	return 1;
}

public OnPlayerUpdate(playerid)
{
		new player[MAX_PLAYER_NAME];
		new str[128];
	//Anti-Jetpack Hack
	if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK)
    {
    GetPlayerName(playerid,player,sizeof(player));
    format(str,sizeof(str),"[Anti-Jetpack] %s: Jetpack Hack Detected!",player);
    SendClientMessageToAll(0xFF4500AA,str);
    format(str,sizeof(str),"Player ''%s'' has been Kicked from the server. (Reason: Jetpack Hack Detected!)",player);
    SendClientMessageToAll(0xFF0000FF,str);
   	ShowPlayerDialog(playerid,3,DIALOG_STYLE_MSGBOX, "You Have Been Kicked!", "{FFFFFF}You've been {FF0000}kicked{FFFFFF}!\nReason: Jetpack Hack Detected!", "OK", "OK");
    Kick(playerid);
    }
	new Float:armour;
    GetPlayerArmour(playerid, armour);
    if(armour == 100)
    {
    new string[64], pName[MAX_PLAYER_NAME];
    GetPlayerName(playerid,pName,MAX_PLAYER_NAME);
    format(string,sizeof string,"* %s was Kicked (Armour Hack)",pName);
    SendClientMessageToAll(0xFF0000FF,string);
    BanEx(playerid, "Armour Hack");
    }
    new iCurWeap = GetPlayerWeapon(playerid);
    if(iCurWeap != GetPVarInt(playerid, "iCurrentWeapon"))
    {
        OnPlayerChangeWeapon(playerid, GetPVarInt(playerid, "iCurrentWeapon"), iCurWeap);
        SetPVarInt(playerid, "iCurrentWeapon", iCurWeap);
    }
        if (GetPVarInt(playerid, "laser")) {
                RemovePlayerAttachedObject(playerid, 0);
                if ((IsPlayerInAnyVehicle(playerid)) || (IsPlayerInWater(playerid))) return 1;
                switch (GetPlayerWeapon(playerid)) {
                        case 23: {
                                if (IsPlayerAiming(playerid)) {
                                        if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK) {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,
                                                0.108249, 0.030232, 0.118051, 1.468254, 350.512573, 364.284240);
                                        } else {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,
                                                0.108249, 0.030232, 0.118051, 1.468254, 349.862579, 364.784240);
                                        }
                                } else {
                                        if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK) {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,
                                                0.078248, 0.027239, 0.113051, -11.131746, 350.602722, 362.384216);
                                        } else {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,
                                                0.078248, 0.027239, 0.113051, -11.131746, 350.602722, 362.384216);
                        }       }       }
                        case 27: {
                                if (IsPlayerAiming(playerid)) {
                                        if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK) {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,
                                                0.588246, -0.022766, 0.138052, -11.531745, 347.712585, 352.784271);
                                        } else {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,
                                                0.588246, -0.022766, 0.138052, 1.468254, 350.712585, 352.784271);
                                        }
                                } else {
                                        if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK) {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,
                                                0.563249, -0.01976, 0.134051, -11.131746, 351.602722, 351.384216);
                                        } else {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,
                                                0.563249, -0.01976, 0.134051, -11.131746, 351.602722, 351.384216);
                        }       }       }
                        case 30: {
                                if (IsPlayerAiming(playerid)) {
                                        if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK) {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,
                                                0.628249, -0.027766, 0.078052, -6.621746, 352.552642, 355.084289);
                                        } else {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,
                                                0.628249, -0.027766, 0.078052, -1.621746, 356.202667, 355.084289);
                                        }
                                } else {
                                        if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK) {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,
                                                0.663249, -0.02976, 0.080051, -11.131746, 358.302734, 353.384216);
                                        } else {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,
                                                0.663249, -0.02976, 0.080051, -11.131746, 358.302734, 353.384216);
                        }       }       }
                        case 31: {
                                if (IsPlayerAiming(playerid)) {
                                        if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK) {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,
                                                0.528249, -0.020266, 0.068052, -6.621746, 352.552642, 355.084289);
                                        } else {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,
                                                0.528249, -0.020266, 0.068052, -1.621746, 356.202667, 355.084289);
                                        }
                                } else {
                                        if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK) {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,
                                                0.503249, -0.02376, 0.065051, -11.131746, 357.302734, 354.484222);
                                        } else {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,
                                                0.503249, -0.02376, 0.065051, -11.131746, 357.302734, 354.484222);
                        }       }       }
			case 34: {
				if (IsPlayerAiming(playerid)) {
					if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK) {
						SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,
						0.528249, -0.020266, 0.068052, -6.621746, 352.552642, 355.084289);
					} else {
						SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,
						0.528249, -0.020266, 0.068052, -1.621746, 356.202667, 355.084289);
					}
					return 1;
				} else {
					if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK) {
						SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,
						0.658248, -0.03276, 0.133051, -11.631746, 355.302673, 353.584259);
					} else {
						SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,
						0.658248, -0.03276, 0.133051, -11.631746, 355.302673, 353.584259);
			} } }
                        case 29: {
                                if (IsPlayerAiming(playerid)) {
                                        if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK) {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,
                                                0.298249, -0.02776, 0.158052, -11.631746, 359.302673, 357.584259);
                                        } else {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,
                                                0.298249, -0.02776, 0.158052, 8.368253, 358.302673, 352.584259);
                                        }
                                } else {
                                        if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK) {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,
                                                0.293249, -0.027759, 0.195051, -12.131746, 354.302734, 352.484222);
                                        } else {
                                                SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6,
                                                0.293249, -0.027759, 0.195051, -12.131746, 354.302734, 352.484222);
		}       }       }       }       }
		return 1;
}

stock OnPlayerChangeWeapon(playerid, oldweapon, newweapon)
{
	new oWeapon[24],
		nWeapon[24];

	GetWeaponName(oldweapon, oWeapon, sizeof(oWeapon));
	GetWeaponName(newweapon, nWeapon, sizeof(nWeapon));
 	if(newweapon==WEAPON_DEAGLE || newweapon==WEAPON_M4 || newweapon==WEAPON_SHOTGUN)
 	{
 			if(flashlight==1)
			{
				SetPlayerAttachedObject(playerid, 1,18656, 6, 0.25, -0.0155, 0.16, 86.5, -185, 86.5, 0.03, 0.03, 0.03);
				SetPlayerAttachedObject(playerid, 2,18641, 6, 0.2, 0.01, 0.16, 90, -95, 90, 1, 1, 1);
				flashlight=1;
				return 1;
			}
	}
    return 1;
}

public StartEngine(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    new Float:health;
    new rand = random(2);

    GetVehicleHealth(vehicleid, health);

	if(IsPlayerInAnyVehicle(playerid))
	{
	    if(vehEngine[vehicleid] == 2)
	    {
	        if(health > 300)
			{
			    if(rand == 0)
			    {
					vehEngine[vehicleid] = 1;
  					TogglePlayerControllable(playerid, 1);
  					SetTimerEx("DamagedEngine", 1000, 1, "i", playerid);
	        		SendClientMessage(playerid, LIGHTBLUE, "Vehicle engine started sucessfully");
				}
				if(rand == 1)
				{
				    vehEngine[vehicleid] = 0;
				    TogglePlayerControllable(playerid, 0);
				    SendClientMessage(playerid, red, "Vehicle engine failed to start");
				}
			}
			else
			{
			    vehEngine[vehicleid] = 0;
			    TogglePlayerControllable(playerid, 0);
			    SendClientMessage(playerid, red
				, "Vehicle engine failed to start due to damage");
			}
		}
	}
	return 1;
}

public DamagedEngine(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    new Float:health;

    GetVehicleHealth(vehicleid, health);

	if(IsPlayerInAnyVehicle(playerid))
	{
	    if(vehEngine[vehicleid] == 1)
	    {
	        if(health < 300)
			{
			    vehEngine[vehicleid] = 0;
				TogglePlayerControllable(playerid, 0);
			    SendClientMessage(playerid, red, "Vehicle engine stopped due to damage");
			}
		}
	}
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	TogglePlayerControllable(playerid, 1);
	return 1;
}

public OnPlayerEnterCheckpoint(playerid){

	if(IsPlayerNPC(playerid))
	{
	return 0;
	}
    if(gTeam[playerid] == TEAM_HUMAN && pCPEnable[playerid]) {  //<--- look
        GameTextForPlayer(playerid,"~g~ Stay in the Checkpoint to Clear it..", 6000, 4);
        SendClientMessageToAll(PURPLE,"You have been given 7000$");
        SendClientMessageToAll(PURPLE,"You have been given Medical Attention.");
        SetPlayerScore(playerid, GetPlayerScore(playerid) + 1);
        SetPlayerHealth(playerid, 100);
        GivePlayerMoney(playerid, 7000);
        pCPEnable[playerid] = false;
        SetTimerEx("ResetPlayerCP",30*1000,false,"d",playerid);
    }
    if(gTeam[playerid] == TEAM_ZOMBIE) {
        GameTextForPlayer(playerid,"~p~ Fuck those survivors.", 6000, 4);
    }
	return 1;
}

public GetClosestPlayers(p1)
{
    new x,Float:dis,Float:dis2,player;
    player = -1;
    dis = 99999.99;
    for (x=0;x<MAX_PLAYERS;x++) {
        if(IsPlayerConnected(x)) {
            if(x != p1) {
                dis2 = GetDistanceBetweenPlayers(x,p1);
                if(dis2 < dis && dis2 != -1.00) {
                    dis = dis2;
                    player = x;
                }
            }
        }
    }

    return player;
}


stock IsPlayerInWater(playerid) {
        new anim = GetPlayerAnimationIndex(playerid);
        if (((anim >=  1538) && (anim <= 1542)) || (anim == 1544) || (anim == 1250) || (anim == 1062)) return 1;
        return 0;
}

public ResetPlayerCP(playerid){
	pCPEnable[playerid] = true;
	return 1;
}

public SendRandomMsgToAll()
{
	switch(random(11))
	{
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

public timer_update()
{
    for(new i=0;i<MAX_PLAYERS;i++) {
        if (isrefuelling[i]) return 0;
        new vid = GetPlayerVehicleID(i);
        if (GetPlayerVehicleSeat(i) == 0) {
            fuel[vid] = fuel[vid] - 1;
            if (fuel[vid]<1)
            {
                fuel[vid] = 0;
                new veh = GetPlayerVehicleID(i);
                new engine,lights,alarm,doors,bonnet,boot,objective;
                GetVehicleParamsEx(veh,engine,lights,alarm,doors,bonnet,boot,objective);
                SetVehicleParamsEx(veh,VEHICLE_PARAMS_OFF,lights,alarm,doors,bonnet,boot,objective);
                Engine[i]=0;
                GameTextForPlayer(i,"~r~You are out of ~w~fuel~r~!",5000,4);
            }
        }
        new string[128];format(string,sizeof string,"Fuel:    %i",fuel[vid] /3);
        TextDrawSetString(td_fuel[i],string);

        new Float:speed_x,Float:speed_y,Float:speed_z,Float:temp_speed,final_speed,Float:health;

        GetVehicleVelocity(vid,speed_x,speed_y,speed_z);
        temp_speed = floatsqroot(((speed_x*speed_x)+(speed_y*speed_y))+(speed_z*speed_z))*136.666667;
        final_speed = floatround(temp_speed,floatround_round);
        format(string,sizeof string,"Speed:  %i",final_speed);
        TextDrawSetString(td_vspeed[i],string);

        GetVehicleHealth(vid,health);
        if (max_vhealth[vid] == 0)
        {
            fuel[vid] = 300;
            GetVehicleHealth(vid,max_vhealth[vid]);
        }
        health = (((health - max_vhealth[vid]) /max_vhealth[vid]) *100)+ 100;
        format(string,sizeof string,"Health: %i",floatround(health,floatround_round));
        TextDrawSetString(td_vhealth[i],string);
    }
    return 1;
}

public timer_refuel(playerid)
{
    new vid = GetPlayerVehicleID(playerid);
    if(Engine[playerid]==0)
    {
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

stock DisplayGroupMembers(groupid, playerid)
{
    new amount[2], string[200], shortstr[55], pname[24];
    format(string, sizeof(string), "Group Members for %s(ID:%d)", groupinfo[groupid][grname], groupid);
	SendClientMessage(playerid, 0xFFFFFF, string);
	string = "";
	for(new x; x<MAX_PLAYERS; x++)
	{
	    if(group[x][gid] == groupid)
	    {
	        amount[0] ++;
	        amount[1] ++;
	        GetPlayerName(x, pname, 24);
	        if(groupinfo[groupid][leader] != x) format(shortstr, sizeof(shortstr), "%s(%d),", pname, x);
	        if(groupinfo[groupid][leader] == x) format(shortstr, sizeof(shortstr), "[LEADER]%s(%d),", pname, x);
	        if(amount[1] == 1) format(string, sizeof(string), "%s", shortstr);
	        if(amount[1] != 1) format(string, sizeof(string), "%s %s", string, shortstr);
			if(amount[0] == 6)
	        {
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

stock ListGroups(playerid)
{
	new amount[2], string[200], shortstr[55];
	SendClientMessage(playerid, 0xFFFFFF, "Current groups:");
	for(new x=0; x<MAX_GROUPS; x++)
	{
		if(groupinfo[x][active])
		{
	 		amount[0] ++;
	 		amount[1] ++;
	 		format(shortstr, sizeof(shortstr), "%s(ID:%d)", groupinfo[x][grname], x);
			if(amount[1] == 1) format(string, sizeof(string), "%s", shortstr);
	        if(amount[1] != 1) format(string, sizeof(string), "%s %s", string, shortstr);
			if(amount[0] == 4)
			{
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

stock GroupJoin(playerid, groupi)
{
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

stock FindNextSlot()
{
	new id;
	while(groupinfo[id][active]) id ++;
	return id;
}

stock IsGroupTaken(grpname[])
{
	for(new x; x<MAX_GROUPS; x++)
	{
	    if(groupinfo[x][active] == 1)
	    {
			if(!strcmp(grpname, groupinfo[x][grname], true) && strlen(groupinfo[x][grname]) != 0) return 1;
		}
	}
	return 0;
}

stock GroupInvite(playerid, groupid)
    return group[playerid][invited] = groupid;

stock CreateGroup(grpname[], owner)
{
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

stock LeaveGroup(playerid, reason)
{
	new groupid = group[playerid][gid], orderid = group[playerid][order], string[100], pname[24];
	group[playerid][gid] = -1;
	group[playerid][order] = -1;
	GroupCheck(groupid, orderid);
	GetPlayerName(playerid, pname, 24);
	if(reason == 0)
	{
 		format(string, sizeof(string), "{FFFFFF}%s(%d){FFCC66} has left your group!", pname, playerid);
 		SendClientMessage(playerid, 0xFFCC66, "You have left your group");
 	}
	if(reason == 1)
	{
		format(string, sizeof(string), "{FFFFFF}%s(%d){FFCC66} has left your group (Kicked by the leader)!", pname, playerid);
        SendClientMessage(playerid, 0xFFCC66, "You have been kicked from your group!");
	}
    if(reason == 2) format(string, sizeof(string), "{FFFFFF}%s(%d){FFCC66} has left your group (Disconnected)!", pname, playerid);
	SendMessageToAllGroupMembers(groupid, string);
	return 1;
}

stock GroupCheck(groupid, orderid)
{
	new gmems = GroupMembers(groupid);
	if(!gmems) groupinfo[groupid][active] = 0;
	if(gmems != 0) ChangeMemberOrder(groupid, orderid);
	return 1;
}

stock GroupMembers(groupid)
{
    if(!groupinfo[groupid][active]) return 0;
	new groupmembers;
	for(new i; i<MAX_PLAYERS; i++) if(group[i][gid] == groupid) groupmembers++;
	return groupmembers;
}

stock ChangeMemberOrder(groupid, orderid)
{
	for(new x; x<MAX_PLAYERS; x++)
	{
		if(group[x][gid] != groupid || group[x][order] < orderid) continue;
		group[x][order] --;
		if(group[x][order] == 1)
		{
			groupinfo[groupid][leader] = x;
			new string[128], pname[24];
			GetPlayerName(x, pname, 24);
			format(string, sizeof(string), "{FFFFFF}%s(%d){FFCC66} has been promoted to the new group leader!", pname, x);
			SendMessageToAllGroupMembers(groupid, string);
		}
	}
	return 1;
}

stock SendMessageToAllGroupMembers(groupid, message[])
{
	if(!groupinfo[groupid][active]) return 0;
	for(new x; x<MAX_PLAYERS; x++) if(group[x][gid] == groupid) SendClientMessage(x, 0xFFCC66, message);
	return 1;
}

public TransMission()
{
	COUNTER++;
	switch (COUNTER)
	{
	case 1:
	{
    SendClientMessageToAll(red,"~Radio TRANSMISSION~");
    SendClientMessageToAll(GREEN,"If any Survivours is hearing this message");
    SendClientMessageToAll(GREEN,"Please go to ____Glen Park___ for further assisstance");
    SendClientMessageToAll(GREEN,"Umbrella Corp had setup their for survivors");
    SendClientMessageToAll(GREEN,"We have Food and Medical Service");
    SendClientMessageToAll(GREEN,"Please be safe while arriving here or zombies will hunt you down.");
    foreach(Player,i)
    PlayAudioStreamForPlayer(i,"http://k003.kiwi6.com/hotlink/blb3aqymb1/Glen_park.mp3"),
    SetPlayerCheckpoint(i, 1969.99, -1199.42, 25.64, 35.0); //CheckPoint 1
	}
	case 2:
	{
    SendClientMessageToAll(red,"~Radio TRANSMISSION~");
    SendClientMessageToAll(GREEN,"If any Survivours is hearing this message");
    SendClientMessageToAll(GREEN,"Please go to ___Santa Maria Beach___ for further assisstance");
    SendClientMessageToAll(GREEN,"Umbrella Corp had setup their for survivors");
    SendClientMessageToAll(GREEN,"We have Food and Medical Service");
    SendClientMessageToAll(GREEN,"Please be safe while arriving here or zombies will hunt you down.");
    foreach(Player,i)
    PlayAudioStreamForPlayer(i,"http://k003.kiwi6.com/hotlink/346l57lq9m/Santa_beacg.mp3"),
    SetPlayerCheckpoint(i, 369.48, -2030.19, 7.67, 35.0); //CheckPoint 2
	}
	case 3:
	{
    SendClientMessageToAll(red,"~Radio TRANSMISSION~");
    SendClientMessageToAll(GREEN,"If any Survivours is hearing this message");
    SendClientMessageToAll(GREEN,"Please go to ____Unity Station____ for further assisstance");
    SendClientMessageToAll(GREEN,"Umbrella Corp had setup their for survivors");
    SendClientMessageToAll(GREEN,"We have Food and Medical Service");
    SendClientMessageToAll(GREEN,"Please be safe while arriving here or zombies will hunt you down.");
    foreach(Player,i)
	PlayAudioStreamForPlayer(i,"http://k003.kiwi6.com/hotlink/nqc1mpl4qe/Unity.mp3"),
    SetPlayerCheckpoint(i, 1774.26, -1939.52, 13.56, 35.0); //CheckPoint 3
	}
	case 4:
	{
    SendClientMessageToAll(red,"~Radio TRANSMISSION~");
    SendClientMessageToAll(GREEN,"If any Survivours is hearing this message");
    SendClientMessageToAll(GREEN,"Please go to ___Market___ for further assisstance");
    SendClientMessageToAll(GREEN,"Umbrella Corp had setup their for survivors");
    SendClientMessageToAll(GREEN,"We have Food and Medical Service");
    SendClientMessageToAll(GREEN,"Please be safe while arriving here or zombies will hunt you down.");
    foreach(Player,i)
	PlayAudioStreamForPlayer(i,"http://k003.kiwi6.com/hotlink/kirjuuvsky/Marker.mp3"),
    SetPlayerCheckpoint(i, 776.31, -1353.71, 13.54, 35.0); //CheckPoint 4
	}
	case 5:
	{
    SendClientMessageToAll(red,"~Radio TRANSMISSION~");
    SendClientMessageToAll(GREEN,"If any Survivours is hearing this message");
    SendClientMessageToAll(GREEN,"Please go to ___Grove Street___ for further assisstance");
    SendClientMessageToAll(GREEN,"Umbrella Corp had setup their for survivors");
    SendClientMessageToAll(GREEN,"We have Food and Medical Service");
    SendClientMessageToAll(GREEN,"Please be safe while arriving here or zombies will hunt you down.");
    foreach(Player,i)
	PlayAudioStreamForPlayer(i,"http://k003.kiwi6.com/hotlink/2fxrypdl9j/Grove.mp3"),
    SetPlayerCheckpoint(i, 2501.05, -1666.91, 13.36, 35.0); //CheckPoint 5
	}
	case 6:
	{
    SendClientMessageToAll(red,"~Radio TRANSMISSION~");
    SendClientMessageToAll(GREEN,"If any Survivours is hearing this message");
    SendClientMessageToAll(GREEN,"Please go to ___Rodeo___ for further assisstance");
    SendClientMessageToAll(GREEN,"Umbrella Corp had setup their for survivors");
    SendClientMessageToAll(GREEN,"We have Food and Medical Service");
    SendClientMessageToAll(GREEN,"Please be safe while arriving here or zombies will hunt you down.");
    foreach(Player,i)
	PlayAudioStreamForPlayer(i,"http://k003.kiwi6.com/hotlink/0f4psm4ncu/Rodeo.mp3"),
    SetPlayerCheckpoint(i, 535.44, -1477.09, 14.54, 35.0); //CheckPoint 7
	}
	case 7:
	{
    SendClientMessageToAll(red,"~Radio TRANSMISSION~");
    SendClientMessageToAll(GREEN,"If any Survivours is hearing this message");
    SendClientMessageToAll(GREEN,"Please go to ___Military Secret base___ for further assisstance");
    SendClientMessageToAll(GREEN,"Umbrella Corp had setup their for survivors");
    SendClientMessageToAll(GREEN,"We have Food and Medical Service");
    SendClientMessageToAll(GREEN,"Please be safe while arriving here or zombies will hunt you down.");
    foreach(Player,i)
	PlayAudioStreamForPlayer(i,"http://k003.kiwi6.com/hotlink/urrtvuftnd/Secret_base.mp3"),
    SetPlayerCheckpoint(i, 2709.97, -1065.97, 75.37, 35.0); //CheckPoint 6
	}
	case 8:
	{
    SendClientMessageToAll(red,"~Radio TRANSMISSION~");
    SendClientMessageToAll(GREEN,"If any Survivours is hearing this message");
    SendClientMessageToAll(GREEN,"Please go to ___Vinewood___ for further assisstance");
    SendClientMessageToAll(GREEN,"Umbrella Corp had setup their for survivors");
    SendClientMessageToAll(GREEN,"We have Food and Medical Service");
    SendClientMessageToAll(GREEN,"Please be safe while arriving here or zombies will hunt you down.");
    foreach(Player,i)
	PlayAudioStreamForPlayer(i,"http://k003.kiwi6.com/hotlink/55fy49xlr5/Vinewood.mp3"),
    SetPlayerCheckpoint(i, 1005.63, -940.09, 42.18, 35.0); //CheckPoint 8
	}
	case 9:
	{
    SendClientMessageToAll(red,"~Radio TRANSMISSION~");
    SendClientMessageToAll(GREEN,"If any Survivours is hearing this message");
    SendClientMessageToAll(GREEN,"Please go to ___Gate C___ for further assisstance");
    SendClientMessageToAll(GREEN,"Umbrella Corp had setup their for survivors");
    SendClientMessageToAll(GREEN,"We have Food and Medical Service");
    SendClientMessageToAll(GREEN,"Please be safe while arriving here or zombies will hunt you down.");
    foreach(Player,i)
	PlayAudioStreamForPlayer(i,"http://k003.kiwi6.com/hotlink/ppm8ehtlwu/Gate_c.mp3"),
    SetPlayerCheckpoint(i, 1628.96, -1010.14, 23.90, 35.0); //CheckPoint 9
	}
	case 10:
	{
    SendClientMessageToAll(red,"~Radio TRANSMISSION~");
    SendClientMessageToAll(GREEN,"If any Survivours is hearing this message");
    SendClientMessageToAll(GREEN,"Please go to ___D12 Crash Site___ for further assisstance");
    SendClientMessageToAll(GREEN,"Umbrella Corp had setup their for survivors");
    SendClientMessageToAll(GREEN,"We have Food and Medical Service");
    SendClientMessageToAll(GREEN,"Please be safe while arriving here or zombies will hunt you down.");
    foreach(Player,i)
	PlayAudioStreamForPlayer(i,"http://k003.kiwi6.com/hotlink/wpk02p7f3f/D12.mp3"),
    SetPlayerCheckpoint(i, 2434.31, -1502.13, 23.83, 35.0); //CheckPoint 10
	COUNTER = 0;
	}
	}
	return 1;
}
