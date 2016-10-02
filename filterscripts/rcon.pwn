#include <a_samp>
#include <dutils>
#include <dudb>
#include <float>
#include <dini>

#define COLOUR_WHITE           0xFFFFFFFF
#define COLOUR_BLACK           0x000000FF
#define COLOUR_GREEN           0x33AA33AA
#define COLOUR_RED             0xFF3333AA
#define COLOUR_YELLOW          0xFFFF00AA
#define COLOUR_LIGHTBLUE       0x33CCFFAA
#define COLOUR_ORANGE          0xFF9900AA
#define COLOUR_PINK 		   0xE100E1FF
#define COLOUR_GREY 		   0xAFAFAFAA
#define COLOUR_BLUE 		   0x0088FFAA
#define COLOUR_LIGHTGREEN      0x9ACD32AA


#define dcmd(%1,%2,%3) if ((strcmp((%3)[1], #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1
#pragma unused ret_memcpy
#pragma tabsize 4

new mute[MAX_PLAYERS];
new god[MAX_PLAYERS];
new jail[MAX_PLAYERS];
new spam[MAX_PLAYERS];
new Menu:teleport;
new Menu:LS;
new Menu:SF;
new Menu:LV;

#define FILTERSCRIPT

#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
	teleport = CreateMenu("Teleports",3,200.0, 100.0, 150.0, 150.0);
	LS = CreateMenu("Los Santos",5,200.0, 100.0, 150.0, 150.0);
	SF = CreateMenu("San Fierro",5,200.0, 100.0, 150.0, 150.0);
	LV = CreateMenu("Las Venturas",5,200.0, 100.0, 150.0, 150.0);
	AddMenuItem(teleport,0,"Los Santos");
	AddMenuItem(teleport,0,"San Fierro");
	AddMenuItem(teleport,0,"Las Venturas");
	AddMenuItem(LS,0,"Grove Street");
	AddMenuItem(LS,0,"Glen Park");
	AddMenuItem(LS,0,"Los Santos PD");
	AddMenuItem(LS,0,"Los Santos Airport");
	AddMenuItem(LS,0,"Los Santos Hospital");
	AddMenuItem(SF,0,"Doherty");
	AddMenuItem(SF,0,"San Fierro PD");
	AddMenuItem(SF,0,"San Fierro Hospital");
	AddMenuItem(SF,0,"San Fierro Airport");
	AddMenuItem(SF,0,"Mount Chilliad");
	AddMenuItem(LV,0,"4 Dragons");
	AddMenuItem(LV,0,"Caligulas");
	AddMenuItem(LV,0,"Las Venturas Hospital");
	AddMenuItem(LV,0,"Las Venturas PD");
	AddMenuItem(LV,0,"Las Venturas Airport");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

#endif


public OnPlayerText(playerid, text[])
{
	if(mute[playerid] == 1)
	{
	    SendClientMessage(playerid,COLOUR_RED,"You are muted!");
		return 0;
		}
	else
	{
	    return 1;
	}
}

public OnPlayerConnect(playerid)
{
	spam[playerid] = 0;
	return 1;
}
public OnPlayerDisconnect(playerid)
{
	spam[playerid] = 0;
	return 1;
}
public OnPlayerCommandText(playerid, cmdtext[])
{
	dcmd(heal,4,cmdtext);
	dcmd(sethp,5,cmdtext);
	dcmd(godon,5,cmdtext);
	dcmd(godoff,6,cmdtext);
	dcmd(givecash,8,cmdtext);
	dcmd(setcash,7,cmdtext);
	dcmd(weapon,6,cmdtext);
	dcmd(resetwep,8,cmdtext);
	dcmd(skin,4,cmdtext);
	dcmd(car,3,cmdtext);
	dcmd(teleport,8,cmdtext);
	dcmd(mute,4,cmdtext);
	dcmd(unmute,6,cmdtext);
	dcmd(ip,2,cmdtext);
	dcmd(ajail,5,cmdtext);
	dcmd(aunjail,7,cmdtext);
	dcmd(goto,4,cmdtext);
	dcmd(get,3,cmdtext);
	dcmd(warp,4,cmdtext);
	dcmd(spamon,6,cmdtext);
	dcmd(spamoff,7,cmdtext);
	dcmd(nuke,4,cmdtext);
	dcmd(uracmds,7,cmdtext);
	return 0;
}
dcmd_uracmds(playerid,params[])
{
	#pragma unused params
	if(!IsPlayerAdmin(playerid)) return 0;
	else
	{
	    SendClientMessage(playerid,COLOUR_BLUE,"-----[Ultimate RCON Admin Commands]-----");
	    SendClientMessage(playerid,COLOUR_YELLOW,"/heal /sethp /godon /godoff /givecash /setcash /weapon /resetweapon");
	    SendClientMessage(playerid,COLOUR_YELLOW,"/skin /car /teleport /mute /unmute /ip /ajail /aunjail /goto /get");
	    SendClientMessage(playerid,COLOUR_YELLOW,"/warp /spamon /spamoff /nuke");
	    return 1;
	    }
}
dcmd_heal(playerid,params[])
{
	new pid;
	if(!IsPlayerAdmin(playerid)) return 0;
	else if(sscanf(params,"u",pid)) SendClientMessage(playerid,COLOUR_RED,"USAGE: /heal [ID]");
	else if(pid == INVALID_PLAYER_ID) SendClientMessage(playerid,COLOUR_RED,"Player was not found.");
	else
	{
	    new give[42],got[51],name[MAX_PLAYER_NAME],name2[MAX_PLAYER_NAME];
	    GetPlayerName(playerid,name,sizeof(name));
	    GetPlayerName(pid,name2,sizeof(name2));
	    SetPlayerHealth(pid,100);
	    format(give,sizeof(give),"You have healed %s",name2);
	    format(got,sizeof(got),"You have been healed by %s",name);
	    SendClientMessage(playerid,COLOUR_YELLOW,give);
	    SendClientMessage(pid,COLOUR_YELLOW,got);
	    }
	return 1;
	}
dcmd_sethp(playerid,params[])
{
	new pid,ammount;
	if(!IsPlayerAdmin(playerid)) return 0;
	else if(sscanf(params,"ud",pid,ammount)) SendClientMessage(playerid,COLOUR_RED,"USAGE: /sethp [ID] [Ammount]");
	else if(pid == INVALID_PLAYER_ID) SendClientMessage(playerid,COLOUR_RED,"Player was not found");
	else
	{
	    new string[50],string1[50],name[MAX_PLAYER_NAME],name2[MAX_PLAYER_NAME];
	    GetPlayerName(playerid,name,sizeof(name));
	    GetPlayerName(pid,name2,sizeof(name2));
	    SetPlayerHealth(pid,ammount);
		format(string,sizeof(string),"You have set %s's health",name2);
		format(string1,sizeof(string1),"Your health has been set by %s ",name);
		SendClientMessage(pid,COLOUR_YELLOW,string1);
		SendClientMessage(playerid,COLOUR_YELLOW,string);
		}
	return 1;
	}
dcmd_godon(playerid,params[])
{
	#pragma unused params
	if(!IsPlayerAdmin(playerid)) return 0;
	if(god[playerid] == 1) SendClientMessage(playerid,COLOUR_RED,"You are already godlike");
	else
	print("A player has turned on godmode using RCON Admin!!!");
	SendClientMessage(playerid,COLOUR_WHITE,"You are now godlike");
	god[playerid] = 1;
	return 1;
}
dcmd_godoff(playerid,params[])
{
	#pragma unused params
	if(!IsPlayerAdmin(playerid)) return 0;
	else if(god[playerid] == 0) SendClientMessage(playerid,COLOUR_RED,"You Can't turn godmode off. You are not godlike!");
	else
	{
	    god[playerid] = 0;
		SendClientMessage(playerid,COLOUR_RED,"Godmode has been turned off");
		return 1;
		}
	return 1;
}
dcmd_givecash(playerid,params[])
{
	new pid,ammount;
	if(!IsPlayerAdmin(playerid)) return 0;
	else if(sscanf(params,"ud",pid,ammount)) SendClientMessage(playerid,COLOUR_RED,"USAGE: /givecash [ID] [Ammount]");
	else if(pid == INVALID_PLAYER_ID) SendClientMessage(playerid,COLOUR_RED,"Player was not found");
	else
	{
	    new string[128],string1[128],name[MAX_PLAYER_NAME],name2[MAX_PLAYER_NAME];
	    GetPlayerName(playerid,name,sizeof(name));
	    GetPlayerName(pid,name2,sizeof(name2));
	    GivePlayerMoney(pid,ammount);
		format(string,sizeof(string),"You have given %s money",name2);
		format(string1,sizeof(string1),"%s has given you money using admin power ",name);
		SendClientMessage(pid,COLOUR_YELLOW,string1);
		SendClientMessage(playerid,COLOUR_YELLOW,string);
		return 1;
		}
	return 1;
}
dcmd_setcash(playerid,params[])
{
	new pid,ammount;
	if(!IsPlayerAdmin(playerid)) return 0;
	else if(sscanf(params,"ud",pid,ammount)) SendClientMessage(playerid,COLOUR_RED,"USAGE: /setcash [ID] [Ammount]");
	else if(pid == INVALID_PLAYER_ID) SendClientMessage(playerid,COLOUR_RED,"Player was not found");
	else
	{
	    new string[50],string1[70],name[MAX_PLAYER_NAME],name2[MAX_PLAYER_NAME];
	    GetPlayerName(playerid,name,sizeof(name));
	    GetPlayerName(pid,name2,sizeof(name2));
	    SetPlayerMoney(pid,ammount);
		format(string,sizeof(string),"You have set %s's money",name2);
		format(string1,sizeof(string1),"%s has set your money using admin power ",name);
		SendClientMessage(pid,COLOUR_YELLOW,string1);
		SendClientMessage(playerid,COLOUR_YELLOW,string);
		return 1;
		}
	return 1;
}
dcmd_weapon(playerid,params[])
{
	new pid,wepid,ammo;
	if(!IsPlayerAdmin(playerid)) return 0;
	else if(sscanf(params,"udd",pid,wepid,ammo)) SendClientMessage(playerid,COLOUR_RED,"USAGE: /weapon [ID] [Wep ID] [Ammo]");
	else if(pid == INVALID_PLAYER_ID) SendClientMessage(playerid,COLOUR_RED,"Player was not found");
	else
	{
	    new string[50],string1[50],name[MAX_PLAYER_NAME],name2[MAX_PLAYER_NAME];
	    GetPlayerName(playerid,name,sizeof(name));
	    GetPlayerName(pid,name2,sizeof(name2));
	    GivePlayerWeapon(pid,wepid,ammo);
		format(string,sizeof(string),"You have given %s a weapon",name2);
		format(string1,sizeof(string1),"%s has given you a weapon ",name);
		SendClientMessage(pid,COLOUR_YELLOW,string1);
		SendClientMessage(playerid,COLOUR_YELLOW,string);
		return 1;
		}
	return 1;
}
dcmd_resetwep(playerid,params[])
{
	new pid;
	if(!IsPlayerAdmin(playerid)) return 0;
	else if(sscanf(params,"u",pid)) SendClientMessage(playerid,COLOUR_RED,"USAGE: /heal [ID]");
	else if(pid == INVALID_PLAYER_ID) SendClientMessage(playerid,COLOUR_RED,"Player was not found.");
	else
	{
	    new give[42],got[51],name[MAX_PLAYER_NAME],name2[MAX_PLAYER_NAME];
	    GetPlayerName(playerid,name,sizeof(name));
	    GetPlayerName(pid,name2,sizeof(name2));
	    ResetPlayerWeapons(playerid);
	    format(give,sizeof(give),"You have reset %s's weapons",name2);
	    format(got,sizeof(got),"Your weapons have been resetted by %s",name);
	    SendClientMessage(playerid,COLOUR_YELLOW,give);
	    SendClientMessage(pid,COLOUR_RED,got);
	    }
	return 1;
	}
dcmd_car(playerid,params[])
{
	if(!IsPlayerAdmin(playerid)) return 0;
	else {
	new tmp[255],idx;
	tmp = strtok(params,idx);
	if(!strlen(tmp))
	{
	    SendClientMessage(playerid,COLOUR_RED,"USAGE: /car [Model ID]");
	    return 1;
		}
	else if (strlen(tmp))
	{
	    new Float:X , Float:Y , Float:Z, Float:Angle , VW , Int , Car , string[23];
	    new id = strval(tmp);
	    if(id < 400 || id > 611) return SendClientMessage(playerid,COLOUR_RED,"Invalid model ID. 400-611");
	    GetPlayerPos(playerid,X,Y,Z);
		GetPlayerFacingAngle(playerid,Angle);
	    VW = GetPlayerVirtualWorld(playerid);
	    Int = GetPlayerInterior(playerid);
	    Car = CreateVehicle(id,X,Y,Z,Angle,-1,-1,50000);
		PutPlayerInVehicle(playerid,Car,0);
		TogglePlayerControllable(playerid,1);
		LinkVehicleToInterior(Car,Int);
		SetVehicleVirtualWorld(Car,VW);
		format(string,sizeof(string),"You have spawned a car");
		SendClientMessage(playerid,COLOUR_YELLOW,string);
		return 1;
		}
	return 1;
	}
}
dcmd_skin(playerid,params[])
{
	if(!IsPlayerAdmin(playerid)) return 0;
	else {
	new tmp[255],idx;
	tmp = strtok(params,idx);
	if(!strlen(tmp))
	{
	    SendClientMessage(playerid,COLOUR_RED,"USAGE: /skin [ID]");
	    return 1;
	    }
	else
	{
	    new string[22];
	    new skinid = strval(tmp);
	    if(!IsValidSkin(skinid)) return SendClientMessage(playerid,COLOUR_RED,"Invalid skin ID!");
	    SetPlayerSkin(playerid,skinid);
	    format(string,sizeof(string),"You have changed skin");
	    SendClientMessage(playerid,COLOUR_YELLOW,string);
	    return 1;
	    }
	}
}
dcmd_teleport(playerid,params[])
{
	#pragma unused params
	if(!IsPlayerAdmin(playerid)) return 0;
	else {
	ShowMenuForPlayer(teleport,playerid);
	return 1;
}}
dcmd_mute(playerid,params[])
{
	new pid;
	if(!IsPlayerAdmin(playerid)) return 0;
	else if(mute[playerid] == 1) SendClientMessage(playerid,COLOUR_RED,"You are muted!");
	else if(sscanf(params,"u",pid)) SendClientMessage(playerid,COLOUR_RED,"USAGE: /mute [ID]");
	else
	{
	    new name[MAX_PLAYER_NAME],string[32];
	    mute[pid] = 1;
	    SendClientMessage(pid,COLOUR_RED,"You have been muted!");
	    GetPlayerName(pid,name,sizeof(name));
		format(string,sizeof(string),"You have muted %s",name);
		SendClientMessage(playerid,COLOUR_YELLOW,string);
		return 1;
		}
	return 1;
	}
dcmd_unmute(playerid,params[])
{
	new pid;
	if(!IsPlayerAdmin(playerid)) return 0;
	else if(sscanf(params,"u",pid)) SendClientMessage(playerid,COLOUR_RED,"USAGE: /unmute [ID]");
	else
	{
	    new name[MAX_PLAYER_NAME],string[34];
	    mute[pid] = 0;
	    SendClientMessage(pid,COLOUR_RED,"You have been unmuted");
	    GetPlayerName(pid,name,sizeof(name));
		format(string,sizeof(string),"You have unmuted %s",name);
		SendClientMessage(playerid,COLOUR_YELLOW,string);
		return 1;
		}
	return 1;
	}
dcmd_ip(playerid,params[])
{
	new pid;
	if(!IsPlayerAdmin(playerid)) return 0;
	else if(sscanf(params,"u",pid)) SendClientMessage(playerid,COLOUR_RED,"USAGE: /ip [ID]");
	else
	{
	    new name[MAX_PLAYER_NAME],string[50],IP[16];
	    GetPlayerName(pid,name,sizeof(name));
	    GetPlayerIp(pid,IP,sizeof(IP));
	    format(string,sizeof(string),"%s's IP: %s",name,IP);
	    SendClientMessage(playerid,COLOUR_YELLOW,string);
	    return 1;
	    }
	return 1;
}
dcmd_ajail(playerid,params[])
{
	new pid;
	if(!IsPlayerAdmin(playerid)) return 0;
	else if(sscanf(params,"u",pid)) SendClientMessage(playerid,COLOUR_RED,"USAGE: /ajail [ID]");
	else
	{
	    new name[MAX_PLAYER_NAME],string[33];
	    GetPlayerName(pid,name,sizeof(name));
	    SetPlayerPos(pid,264.6288,77.5742,1001.0391);
	    SetPlayerFacingAngle(pid,271.3159);
	    SetPlayerInterior(pid,6);
	    SetCameraBehindPlayer(pid);
	    TogglePlayerControllable(pid,0);
		format(string,sizeof(string),"You have jailed %s",name);
		SendClientMessage(playerid,COLOUR_YELLOW,string);
		SendClientMessage(pid,COLOUR_RED,"An admin has jailed you!");
		jail[pid] = 1;
		return 1;
		}
	return 1;
}
dcmd_aunjail(playerid,params[])
{
	new pid;
	if(!IsPlayerAdmin(playerid)) return 0;
	else if(sscanf(params,"u",pid)) SendClientMessage(playerid,COLOUR_RED,"USAGE: /aunjail [ID]");
	else if(jail[pid] == 0) SendClientMessage(playerid,COLOUR_RED,"That player is not jailed!");
	else
	{
	    new name[MAX_PLAYER_NAME],string[35];
	    GetPlayerName(pid,name,sizeof(name));
	    SetPlayerPos(pid,1490.7981,-1608.7092,14.0393);
	    SetPlayerFacingAngle(pid,0.8749);
	    SetPlayerInterior(pid,6);
	    SetCameraBehindPlayer(pid);
	    TogglePlayerControllable(pid,1);
		format(string,sizeof(string),"You have unjailed %s",name);
		SendClientMessage(playerid,COLOUR_YELLOW,string);
		SendClientMessage(pid,COLOUR_RED,"An admin has unjailed you!");
		jail[pid] = 0;
		return 1;
		}
	return 1;
}
dcmd_goto(playerid,params[])
{
	new pid;
	if(!IsPlayerAdmin(playerid)) return 0;
	else if(sscanf(params,"u",pid)) SendClientMessage(playerid,COLOUR_RED,"USAGE: /goto [ID]");
	else
	{
	    new Float:X,Float:Y,Float:Z,pint,name[MAX_PLAYER_NAME],name2[MAX_PLAYER_NAME],string[40],string2[39];
	    GetPlayerName(playerid,name,sizeof(name));
	    GetPlayerName(pid,name2,sizeof(name2));
	    GetPlayerPos(pid,X,Y,Z);
	    pint = GetPlayerInterior(pid);
	    SetPlayerPos(playerid,X+1,Y,Z);
	    SetPlayerInterior(playerid,pint);
		format(string,sizeof(string),"You have teleported to %s",name2);
		format(string2,sizeof(string2),"%s has teleported to you",name);
		SendClientMessage(playerid,COLOUR_YELLOW,string);
		SendClientMessage(pid,COLOUR_YELLOW,string2);
		return 1;
		}
	return 1;
}
dcmd_get(playerid,params[])
{
	new pid;
	if(!IsPlayerAdmin(playerid)) return 0;
	else if(sscanf(params,"u",pid)) SendClientMessage(playerid,COLOUR_RED,"USAGE: /get [ID]");
	else
	{
	    new Float:X,Float:Y,Float:Z,pint,name[MAX_PLAYER_NAME],name2[MAX_PLAYER_NAME],string[44],string2[45];
	    GetPlayerName(playerid,name,sizeof(name));
	    GetPlayerName(pid,name2,sizeof(name2));
	    GetPlayerPos(playerid,X,Y,Z);
	    pint = GetPlayerInterior(playerid);
	    SetPlayerPos(pid,X+1,Y,Z);
	    SetPlayerInterior(pid,pint);
		format(string,sizeof(string),"You have teleported %s to you",name2);
		format(string2,sizeof(string2),"You have been teleported to %s",name);
		SendClientMessage(playerid,COLOUR_YELLOW,string);
		SendClientMessage(pid,COLOUR_YELLOW,string2);
		return 1;
		}
	return 1;
}
dcmd_warp(playerid,params[])
{
	new pid,tid;
	if(!IsPlayerAdmin(playerid)) return 0;
	else if(sscanf(params,"uu",tid,pid)) SendClientMessage(playerid,COLOUR_RED,"USAGE: /warp [ID] [ID]");
	else
	{
	    new name1[MAX_PLAYER_NAME],name2[MAX_PLAYER_NAME],name3[MAX_PLAYER_NAME],Float:X,Float:Y,Float:Z,int,string1[58],string2[65],string3[65];
	    GetPlayerName(playerid,name1,sizeof(name1));
	    GetPlayerName(tid,name2,sizeof(name2));
	    GetPlayerName(pid,name3,sizeof(name3));
	    GetPlayerPos(pid,X,Y,Z);
	    int = GetPlayerInterior(pid);
		SetPlayerPos(tid,X+1,Y,Z);
		SetPlayerInterior(tid,int);
		format(string1,sizeof(string1),"You have teleported %s to %s",name2,name3);//playerid
		format(string2,sizeof(string2),"You have been teleported to %s by %s",name3,name1);//tid
		format(string3,sizeof(string3),"%s has been teleported to you by %s",name2,name1);//pid
		SendClientMessage(playerid,COLOUR_YELLOW,string1);
		SendClientMessage(tid,COLOUR_YELLOW,string2);
		SendClientMessage(pid,COLOUR_YELLOW,string3);
		return 1;
		}
	return 1;
}
dcmd_spamon(playerid,params[])
{
	new pid;
	if(!IsPlayerAdmin(playerid)) return 0;
	else if(sscanf(params,"u",pid)) SendClientMessage(playerid,COLOUR_RED,"USAGE: /spam [ID]");
	else if(spam[pid] == 1) SendClientMessage(playerid,COLOUR_RED,"That ID is already being spammed!");
	else
	{
	    new string[46],name[MAX_PLAYER_NAME];
	    GetPlayerName(pid,name,sizeof(name));
	    format(string,sizeof(string),"You have turned spam on onto %s",name);
	    SendClientMessage(playerid,COLOUR_YELLOW,string);
	    spam[pid] = 1;
	    return 1;
	    }
	return 1;
}
dcmd_spamoff(playerid,params[])
{
	new pid;
	if(!IsPlayerAdmin(playerid)) return 0;
	else if(sscanf(params,"u",pid)) SendClientMessage(playerid,COLOUR_RED,"USAGE: /spamoff [ID]");
	else if(spam[pid] == 0) SendClientMessage(playerid,COLOUR_RED,"That ID is not being spammed!");
	else
	{
	    new string[50],name[MAX_PLAYER_NAME];
	    GetPlayerName(pid,name,sizeof(name));
	    format(string,sizeof(string),"You have turned spam off on %s",name);
	    SendClientMessage(playerid,COLOUR_YELLOW,string);
	    spam[pid] = 0;
	    return 1;
	    }
	return 1;
}
dcmd_nuke(playerid,params[])
{
	new pid;
	if(!IsPlayerAdmin(playerid)) return 0;
	else if(sscanf(params,"u",pid)) SendClientMessage(playerid,COLOUR_RED,"USAGE: /nuke [ID]");
	else
	{
	    new name[MAX_PLAYER_NAME],name2[MAX_PLAYER_NAME],string[32],string2[40],Float:X,Float:Y,Float:Z;
	    GetPlayerName(playerid,name,sizeof(name));
	    GetPlayerName(pid,name2,sizeof(name2));
	    GetPlayerPos(pid,X,Y,Z);
	    CreateExplosion(X,Y,Z,6,0.1);
	    format(string,sizeof(string),"You have nuked %s",name2);
	    format(string2,sizeof(string2),"You have been nuked by %s",name);
	    SendClientMessage(playerid,COLOUR_YELLOW,string);
	    SendClientMessage(pid,COLOUR_YELLOW,string2);
	    return 1;
	    }
	return 1;
}
public OnPlayerSelectedMenuRow(playerid, row)
{
    new Menu:currentmenu = GetPlayerMenu(playerid);
    if(currentmenu == teleport)
    {
        switch(row)
        {
            case 0:
            {
				ShowMenuForPlayer(LS,playerid);
				SendClientMessage(playerid,COLOUR_YELLOW,"Choose location");
				return 1;
				}
			case 1:
			{
			    ShowMenuForPlayer(SF,playerid);
			    SendClientMessage(playerid,COLOUR_YELLOW,"Choose location");
			    return 1;
			    }
			case 2:
			{
			    ShowMenuForPlayer(LV,playerid);
			    SendClientMessage(playerid,COLOUR_YELLOW,"Choose location");
			    return 1;
			    }
			}
		return 1;
		}
	if(currentmenu == LS)
	{
	    switch(row)
	    {
	        case 0:
	        {
	            SetPlayerPos(playerid,2511.5010,-1670.2648,13.4482);
	            SendClientMessage(playerid,COLOUR_YELLOW,"You have teleported.");
	            return 1;
	            }
	        case 1:
	        {
	            SetPlayerPos(playerid,2048.7852,-1196.4884,23.6326);
	            SendClientMessage(playerid,COLOUR_YELLOW,"You have teleported.");
	            return 1;
	            }
	        case 2:
	        {
	            SetPlayerPos(playerid,1540.2794,-1674.9877,13.5503);
	            SendClientMessage(playerid,COLOUR_YELLOW,"You have teleported.");
	            return 1;
	            }
	        case 3:
	        {
	            SetPlayerPos(playerid,1685.6362,-2329.8545,13.5469);
	            SendClientMessage(playerid,COLOUR_YELLOW,"You have teleported.");
	            return 1;
	            }
	        case 4:
	        {
	            SetPlayerPos(playerid,1182.1171,-1323.7235,13.5812);
	            SendClientMessage(playerid,COLOUR_YELLOW,"You have teleported.");
	            return 1;
	            }
			}
		}
	if(currentmenu == SF)
	{
	    switch(row)
	    {
	        case 0:
	        {
	            SetPlayerPos(playerid,-2023.0795,154.1555,28.8359);
	            SendClientMessage(playerid,COLOUR_YELLOW,"You have teleported.");
	            return 1;
	            }
	        case 1:
	        {
	            SetPlayerPos(playerid,-1604.9398,718.1047,11.8727);
	            SendClientMessage(playerid,COLOUR_YELLOW,"You have teleported.");
	            return 1;
	            }
	        case 2:
	        {
	            SetPlayerPos(playerid,-2666.8835,609.7924,14.4545);
	            SendClientMessage(playerid,COLOUR_YELLOW,"You have teleported.");
	            return 1;
	            }
	        case 3:
	        {
	            SetPlayerPos(playerid,-1417.3279,-293.8440,14.1484);
	            SendClientMessage(playerid,COLOUR_YELLOW,"You have teleported.");
	            return 1;
	            }
	        case 4:
	        {
	            SetPlayerPos(playerid,-2316.8677,-1624.1256,483.7078);
	            SendClientMessage(playerid,COLOUR_YELLOW,"You have teleported.");
	            return 1;
	            }
			}
		}
	if(currentmenu == LV)
	{
	    switch(row)
	    {
	        case 0:
	        {
	            SetPlayerPos(playerid,2025.0122,1008.5726,10.8203);
	            SendClientMessage(playerid,COLOUR_YELLOW,"You have teleported.");
	            return 1;
	            }
	        case 1:
	        {
	            SetPlayerPos(playerid,2192.6394,1676.4242,12.3672);
	            SendClientMessage(playerid,COLOUR_YELLOW,"You have teleported.");
	            return 1;
	            }
	        case 2:
	        {
	            SetPlayerPos(playerid,1607.4633,1819.7698,10.8280);
	            SendClientMessage(playerid,COLOUR_YELLOW,"You have teleported.");
	            return 1;
	            }
	        case 3:
	        {
	            SetPlayerPos(playerid,2290.0586,2428.9065,10.8203);
	            SendClientMessage(playerid,COLOUR_YELLOW,"You have teleported.");
	            return 1;
	            }
	        case 4:
	        {
	            SetPlayerPos(playerid,1678.4406,1451.8649,10.7751);
	            SendClientMessage(playerid,COLOUR_YELLOW,"You have teleported.");
	            return 1;
	            }
			}
		}
	return 1;
	}


public OnPlayerExitedMenu(playerid)
{
	return 1;
}

stock sscanf(string[], format[], {Float,_}:...)
{
	#if defined isnull
		if (isnull(string))
	#else
		if (string[0] == 0 || (string[0] == 1 && string[1] == 0))
	#endif
		{
			return format[0];
		}
	#pragma tabsize 4
	new
		formatPos = 0,
		stringPos = 0,
		paramPos = 2,
		paramCount = numargs(),
		delim = ' ';
	while (string[stringPos] && string[stringPos] <= ' ')
	{
		stringPos++;
	}
	while (paramPos < paramCount && string[stringPos])
	{
		switch (format[formatPos++])
		{
			case '\0':
			{
				return 0;
			}
			case 'i', 'd':
			{
				new
					neg = 1,
					num = 0,
					ch = string[stringPos];
				if (ch == '-')
				{
					neg = -1;
					ch = string[++stringPos];
				}
				do
				{
					stringPos++;
					if ('0' <= ch <= '9')
					{
						num = (num * 10) + (ch - '0');
					}
					else
					{
						return -1;
					}
				}
				while ((ch = string[stringPos]) > ' ' && ch != delim);
				setarg(paramPos, 0, num * neg);
			}
			case 'h', 'x':
			{
				new
					num = 0,
					ch = string[stringPos];
				do
				{
					stringPos++;
					switch (ch)
					{
						case 'x', 'X':
						{
							num = 0;
							continue;
						}
						case '0' .. '9':
						{
							num = (num << 4) | (ch - '0');
						}
						case 'a' .. 'f':
						{
							num = (num << 4) | (ch - ('a' - 10));
						}
						case 'A' .. 'F':
						{
							num = (num << 4) | (ch - ('A' - 10));
						}
						default:
						{
							return -1;
						}
					}
				}
				while ((ch = string[stringPos]) > ' ' && ch != delim);
				setarg(paramPos, 0, num);
			}
			case 'c':
			{
				setarg(paramPos, 0, string[stringPos++]);
			}
			case 'f':
			{
				setarg(paramPos, 0, _:floatstr(string[stringPos]));
			}
			case 'p':
			{
				delim = format[formatPos++];
				continue;
			}
			case '\'':
			{
				new
					end = formatPos - 1,
					ch;
				while ((ch = format[++end]) && ch != '\'') {}
				if (!ch)
				{
					return -1;
				}
				format[end] = '\0';
				if ((ch = strfind(string, format[formatPos], false, stringPos)) == -1)
				{
					if (format[end + 1])
					{
						return -1;
					}
					return 0;
				}
				format[end] = '\'';
				stringPos = ch + (end - formatPos);
				formatPos = end + 1;
			}
			case 'u':
			{
				new
					end = stringPos - 1,
					id = 0,
					bool:num = true,
					ch;
				while ((ch = string[++end]) && ch != delim)
				{
					if (num)
					{
						if ('0' <= ch <= '9')
						{
							id = (id * 10) + (ch - '0');
						}
						else
						{
							num = false;
						}
					}
				}
				if (num && IsPlayerConnected(id))
				{
					setarg(paramPos, 0, id);
				}
				else
				{
					#if !defined foreach
						#define foreach(%1,%2) for (new %2 = 0; %2 < MAX_PLAYERS; %2++) if (IsPlayerConnected(%2))
						#define __SSCANF_FOREACH__
					#endif
					string[end] = '\0';
					num = false;
					new
						name[MAX_PLAYER_NAME];
					id = end - stringPos;
					foreach (Player, playerid)
					{
						GetPlayerName(playerid, name, sizeof (name));
						if (!strcmp(name, string[stringPos], true, id))
						{
							setarg(paramPos, 0, playerid);
							num = true;
							break;
						}
					}
					if (!num)
					{
						setarg(paramPos, 0, INVALID_PLAYER_ID);
					}
					string[end] = ch;
					#if defined __SSCANF_FOREACH__
						#undef foreach
						#undef __SSCANF_FOREACH__
					#endif
				}
				stringPos = end;
			}
			case 's', 'z':
			{
				new
					i = 0,
					ch;
				if (format[formatPos])
				{
					while ((ch = string[stringPos++]) && ch != delim)
					{
						setarg(paramPos, i++, ch);
					}
					if (!i)
					{
						return -1;
					}
				}
				else
				{
					while ((ch = string[stringPos++]))
					{
						setarg(paramPos, i++, ch);
					}
				}
				stringPos--;
				setarg(paramPos, i, '\0');
			}
			default:
			{
				continue;
			}
		}
		while (string[stringPos] && string[stringPos] != delim && string[stringPos] > ' ')
		{
			stringPos++;
		}
		while (string[stringPos] && (string[stringPos] == delim || string[stringPos] <= ' '))
		{
			stringPos++;
		}
		paramPos++;
	}
	do
	{
		if ((delim = format[formatPos++]) > ' ')
		{
			if (delim == '\'')
			{
				while ((delim = format[formatPos++]) && delim != '\'') {}
			}
			else if (delim != 'z')
			{
				return delim;
			}
		}
	}
	while (delim > ' ');
	return 0;
}

public OnPlayerUpdate(playerid)
{
	if(god[playerid] == 1)
	{
	    new Float:health;
		GetPlayerHealth(playerid,health);
	    if(health < 100)
	    {
	        SetPlayerHealth(playerid,100);
	        return 1;
	        }
		}
	if(spam[playerid] == 1)
	{
	    SendClientMessage(playerid,COLOUR_RED,"An admin has turned spam on on your ID");
	    return 1;
	    }
	return 1;
	}
stock IsValidSkin(skinid)
{
	// Created by Simon.
	// Checks whether the skinid parsed is crashable or not. // WHICH IS PRETTY FUCKING GOOD DAWG

	#define	MAX_BAD_SKINS  20

	new badSkins[MAX_BAD_SKINS] = {
		3, 4, 5, 6, 8, 42, 65, 74, 86,
		119, 149, 208, 265, 266, 267,
	    269, 271, 270, 273, 289
	};

	if  (skinid < 0 || skinid > 299) return false;
	for (new i = 0; i < MAX_BAD_SKINS; i++) {
	    if (skinid == badSkins[i]) return false;
	}

	#undef MAX_BAD_SKINS
	return true;
}
