#define FILTERSCRIPT

#include <a_samp>
#include <dudb>
#include <izcmd>
#include <sscanf>

#define COLOUR_WHITE		0xFFFFFFFF
#define COLOUR_BLACK		0x000000FF
#define COLOUR_GREEN		0x33AA33AA
#define COLOUR_RED			0xFF3333AA
#define COLOUR_YELLOW		0xFFFF00AA
#define COLOUR_LIGHTBLUE	0x33CCFFAA
#define COLOUR_ORANGE		0xFF9900AA
#define COLOUR_PINK			0xE100E1FF
#define COLOUR_GREY			0xAFAFAFAA
#define COLOUR_BLUE			0x0088FFAA
#define COLOUR_LIGHTGREEN	0x9ACD32AA

new mute[MAX_PLAYERS],
	god[MAX_PLAYERS],
	jail[MAX_PLAYERS],
	spam[MAX_PLAYERS],
	Menu:teleport,
	Menu:LS,
	Menu:SF,
	Menu:LV;

stock bool:IsValidSkin(skinid){
	if(skinid < 0 || skinid > 311) return false;
	switch(skinid){
		case 74: return false;
    }
	return true;
}

public OnFilterScriptInit(){
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

public OnPlayerText(playerid, text[]){
	if(mute[playerid] == 1){
		SendClientMessage(playerid,COLOUR_RED,"You are muted!");
		return 0;
	} else {
		return 1;
	}
}

public OnPlayerConnect(playerid){
	spam[playerid] = 0;
	return 1;
}

public OnPlayerDisconnect(playerid){
	spam[playerid] = 0;
	return 1;
}

CMD:uracmds(playerid){
	if(!IsPlayerAdmin(playerid)) return 0;
	
	SendClientMessage(playerid,COLOUR_BLUE,"-----[Ultimate RCON Admin Commands]-----");
	SendClientMessage(playerid,COLOUR_YELLOW,"/heal /sethp /godon /godoff /givecash /setcash /weapon /resetweapon");
	SendClientMessage(playerid,COLOUR_YELLOW,"/skin /car /teleport /mute /unmute /ip /ajail /aunjail /goto /get");
	SendClientMessage(playerid,COLOUR_YELLOW,"/warp /spamon /spamoff /nuke");
	return 1;
}

CMD:heal(playerid,params[]){
	if(!IsPlayerAdmin(playerid)) return 0;
	
	new pid;
	if(sscanf(params,"u",pid)) return SendClientMessage(playerid,COLOUR_RED,"USAGE: /heal [ID]");
	if(pid == INVALID_PLAYER_ID) return SendClientMessage(playerid,COLOUR_RED,"Player was not found.");
	
	new give[42],got[51],name[MAX_PLAYER_NAME],name2[MAX_PLAYER_NAME];
	GetPlayerName(playerid,name,sizeof(name));
	GetPlayerName(pid,name2,sizeof(name2));
	SetPlayerHealth(pid,100);
	format(give,sizeof(give),"You have healed %s",name2);
	format(got,sizeof(got),"You have been healed by %s",name);
	SendClientMessage(playerid,COLOUR_YELLOW,give);
	SendClientMessage(pid,COLOUR_YELLOW,got);
	return 1;
}

CMD:sethp(playerid,params[]){
	if(!IsPlayerAdmin(playerid)) return 0;
	
	new pid,ammount;
	if(sscanf(params,"ud",pid,ammount)) return SendClientMessage(playerid,COLOUR_RED,"USAGE: /sethp [ID] [Ammount]");
	if(pid == INVALID_PLAYER_ID) return SendClientMessage(playerid,COLOUR_RED,"Player was not found");
	
	new string[50],string1[50],name[MAX_PLAYER_NAME],name2[MAX_PLAYER_NAME];
	GetPlayerName(playerid,name,sizeof(name));
	GetPlayerName(pid,name2,sizeof(name2));
	SetPlayerHealth(pid,ammount);
	format(string,sizeof(string),"You have set %s's health",name2);
	format(string1,sizeof(string1),"Your health has been set by %s ",name);
	SendClientMessage(pid,COLOUR_YELLOW,string1);
	SendClientMessage(playerid,COLOUR_YELLOW,string);
	return 1;
}

CMD:godon(playerid){
	if(!IsPlayerAdmin(playerid)) return 0;
	if(god[playerid] == 1) return SendClientMessage(playerid,COLOUR_RED,"You are already godlike");

	print("A player has turned on godmode using RCON Admin!!!");
	SendClientMessage(playerid,COLOUR_WHITE,"You are now godlike");
	god[playerid] = 1;
	return 1;
}

CMD:godoff(playerid){
	if(!IsPlayerAdmin(playerid)) return 0;
	if(god[playerid] == 0) return SendClientMessage(playerid,COLOUR_RED,"You Can't turn godmode off. You are not godlike!");
	
	god[playerid] = 0;
	SendClientMessage(playerid,COLOUR_RED,"Godmode has been turned off");
	return 1;
}

CMD:givecash(playerid,params[]){
	if(!IsPlayerAdmin(playerid)) return 0;
	
	new pid,ammount;
	if(sscanf(params,"ud",pid,ammount)) return SendClientMessage(playerid,COLOUR_RED,"USAGE: /givecash [ID] [Ammount]");
	if(pid == INVALID_PLAYER_ID) return SendClientMessage(playerid,COLOUR_RED,"Player was not found");

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

CMD:setcash(playerid,params[]){
	if(!IsPlayerAdmin(playerid)) return 0;
	
	new pid,ammount;
	if(sscanf(params,"ud",pid,ammount)) return SendClientMessage(playerid,COLOUR_RED,"USAGE: /setcash [ID] [Ammount]");
	if(pid == INVALID_PLAYER_ID) return SendClientMessage(playerid,COLOUR_RED,"Player was not found");

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

CMD:weapon(playerid,params[]){
	if(!IsPlayerAdmin(playerid)) return 0;
	
	new pid,wepid,ammo;
	if(sscanf(params,"udd",pid,wepid,ammo)) return SendClientMessage(playerid,COLOUR_RED,"USAGE: /weapon [ID] [Wep ID] [Ammo]");
	if(pid == INVALID_PLAYER_ID) return SendClientMessage(playerid,COLOUR_RED,"Player was not found");

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

CMD:resetwep(playerid,params[]){
	if(!IsPlayerAdmin(playerid)) return 0;
	
	new pid;
	if(sscanf(params,"u",pid)) return SendClientMessage(playerid,COLOUR_RED,"USAGE: /heal [ID]");
	if(pid == INVALID_PLAYER_ID) return SendClientMessage(playerid,COLOUR_RED,"Player was not found.");
	
	new give[42],got[51],name[MAX_PLAYER_NAME],name2[MAX_PLAYER_NAME];
	GetPlayerName(playerid,name,sizeof(name));
	GetPlayerName(pid,name2,sizeof(name2));
	ResetPlayerWeapons(playerid);
	format(give,sizeof(give),"You have reset %s's weapons",name2);
	format(got,sizeof(got),"Your weapons have been resetted by %s",name);
	SendClientMessage(playerid,COLOUR_YELLOW,give);
	SendClientMessage(pid,COLOUR_RED,got);
	return 1;
}

CMD:car(playerid,params[]){
	if(!IsPlayerAdmin(playerid)) return 0;
	if(isnull(params)) return SendClientMessage(playerid,COLOUR_RED,"USAGE: /car [Model ID]");
	
	new Float:X , Float:Y , Float:Z, Float:Angle , VW , Int , Car , string[23], id = strval(params);
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

CMD:skin(playerid,params[]){
	if(!IsPlayerAdmin(playerid)) return 0;
	if(isnull(params)) return SendClientMessage(playerid,COLOUR_RED,"USAGE: /skin [ID]");

	new string[22];
	new skinid = strval(params);
	if(!IsValidSkin(skinid)) return SendClientMessage(playerid,COLOUR_RED,"Invalid skin ID!");
	SetPlayerSkin(playerid,skinid);
	format(string,sizeof(string),"You have changed skin");
	SendClientMessage(playerid,COLOUR_YELLOW,string);
	return 1;
}

CMD:teleport(playerid){
	if(!IsPlayerAdmin(playerid)) return 0;
	ShowMenuForPlayer(teleport,playerid);
	return 1;
}

CMD:mute(playerid,params[]){
	if(!IsPlayerAdmin(playerid)) return 0;
	
	new pid;
	if(mute[playerid] == 1) return SendClientMessage(playerid,COLOUR_RED,"You are muted!");
	if(sscanf(params,"u",pid)) return SendClientMessage(playerid,COLOUR_RED,"USAGE: /mute [ID]");

	new name[MAX_PLAYER_NAME],string[32];
	mute[pid] = 1;
	SendClientMessage(pid,COLOUR_RED,"You have been muted!");
	GetPlayerName(pid,name,sizeof(name));
	format(string,sizeof(string),"You have muted %s",name);
	SendClientMessage(playerid,COLOUR_YELLOW,string);
	return 1;
}
	
CMD:unmute(playerid,params[]){
	if(!IsPlayerAdmin(playerid)) return 0;
	
	new pid;
	if(sscanf(params,"u",pid)) return SendClientMessage(playerid,COLOUR_RED,"USAGE: /unmute [ID]");
	
	new name[MAX_PLAYER_NAME],string[34];
	mute[pid] = 0;
	SendClientMessage(pid,COLOUR_RED,"You have been unmuted");
	GetPlayerName(pid,name,sizeof(name));
	format(string,sizeof(string),"You have unmuted %s",name);
	SendClientMessage(playerid,COLOUR_YELLOW,string);
	return 1;
}

CMD:ip(playerid,params[]){
	if(!IsPlayerAdmin(playerid)) return 0;
	new pid;
	if(sscanf(params,"u",pid)) return SendClientMessage(playerid,COLOUR_RED,"USAGE: /ip [ID]");

	new name[MAX_PLAYER_NAME],string[50],IP[16];
	GetPlayerName(pid,name,sizeof(name));
	GetPlayerIp(pid,IP,sizeof(IP));
	format(string,sizeof(string),"%s's IP: %s",name,IP);
	SendClientMessage(playerid,COLOUR_YELLOW,string);
	return 1;
}

CMD:ajail(playerid,params[]){
	if(!IsPlayerAdmin(playerid)) return 0;
	
	new pid;
	if(sscanf(params,"u",pid)) return SendClientMessage(playerid,COLOUR_RED,"USAGE: /ajail [ID]");
	
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

CMD:aunjail(playerid,params[]){
	if(!IsPlayerAdmin(playerid)) return 0;
	
	new pid;
	if(sscanf(params,"u",pid)) return SendClientMessage(playerid,COLOUR_RED,"USAGE: /aunjail [ID]");
	if(jail[pid] == 0) return SendClientMessage(playerid,COLOUR_RED,"That player is not jailed!");
	
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

CMD:goto(playerid,params[]){
	if(!IsPlayerAdmin(playerid)) return 0;
	new pid;
	
	if(sscanf(params,"u",pid)) return SendClientMessage(playerid,COLOUR_RED,"USAGE: /goto [ID]");

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

CMD:get(playerid,params[]){
	if(!IsPlayerAdmin(playerid)) return 0;
	
	new pid;
	if(sscanf(params,"u",pid)) return SendClientMessage(playerid,COLOUR_RED,"USAGE: /get [ID]");
	
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

CMD:warp(playerid,params[]){
	new pid,tid;
	if(!IsPlayerAdmin(playerid)) return 0;
	if(sscanf(params,"uu",tid,pid)) return SendClientMessage(playerid,COLOUR_RED,"USAGE: /warp [ID] [ID]");

	new name1[MAX_PLAYER_NAME],name2[MAX_PLAYER_NAME],name3[MAX_PLAYER_NAME],Float:X,Float:Y,Float:Z,int,string1[58],string2[65],string3[65];
	GetPlayerName(playerid,name1,sizeof(name1));
	GetPlayerName(tid,name2,sizeof(name2));
	GetPlayerName(pid,name3,sizeof(name3));
	GetPlayerPos(pid,X,Y,Z);
	int = GetPlayerInterior(pid);
	SetPlayerPos(tid,X+1,Y,Z);
	SetPlayerInterior(tid,int);
	format(string1,sizeof(string1),"You have teleported %s to %s",name2,name3); //playerid
	format(string2,sizeof(string2),"You have been teleported to %s by %s",name3,name1); //tid
	format(string3,sizeof(string3),"%s has been teleported to you by %s",name2,name1); //pid
	SendClientMessage(playerid,COLOUR_YELLOW,string1);
	SendClientMessage(tid,COLOUR_YELLOW,string2);
	SendClientMessage(pid,COLOUR_YELLOW,string3);
	return 1;
}

CMD:spamon(playerid,params[]){
	if(!IsPlayerAdmin(playerid)) return 0;
	
	new pid;
	if(sscanf(params,"u",pid)) return SendClientMessage(playerid,COLOUR_RED,"USAGE: /spam [ID]");
	if(spam[pid] == 1) return SendClientMessage(playerid,COLOUR_RED,"That ID is already being spammed!");

	new string[46],name[MAX_PLAYER_NAME];
	GetPlayerName(pid,name,sizeof(name));
	format(string,sizeof(string),"You have turned spam on onto %s",name);
	SendClientMessage(playerid,COLOUR_YELLOW,string);
	spam[pid] = 1;
	return 1;
}

CMD:spamoff(playerid,params[]){
	if(!IsPlayerAdmin(playerid)) return 0;
	
	new pid;
	if(sscanf(params,"u",pid)) return SendClientMessage(playerid,COLOUR_RED,"USAGE: /spamoff [ID]");
	if(spam[pid] == 0) return SendClientMessage(playerid,COLOUR_RED,"That ID is not being spammed!");

	new string[50],name[MAX_PLAYER_NAME];
	GetPlayerName(pid,name,sizeof(name));
	format(string,sizeof(string),"You have turned spam off on %s",name);
	SendClientMessage(playerid,COLOUR_YELLOW,string);
	spam[pid] = 0;
	return 1;
}

CMD:nuke(playerid,params[]){
	if(!IsPlayerAdmin(playerid)) return 0;
	
	new pid;
	if(sscanf(params,"u",pid)) return SendClientMessage(playerid,COLOUR_RED,"USAGE: /nuke [ID]");

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

public OnPlayerSelectedMenuRow(playerid, row){
	new Menu:currentmenu = GetPlayerMenu(playerid);
	if(currentmenu == teleport){
		switch(row){
			case 0: {
				ShowMenuForPlayer(LS,playerid);
				SendClientMessage(playerid,COLOUR_YELLOW,"Choose location");
				return 1;
			}
			case 1: {
				ShowMenuForPlayer(SF,playerid);
				SendClientMessage(playerid,COLOUR_YELLOW,"Choose location");
				return 1;
			}
			case 2: {
				ShowMenuForPlayer(LV,playerid);
				SendClientMessage(playerid,COLOUR_YELLOW,"Choose location");
				return 1;
			}
		}
		return 1;
	}
	
	if(currentmenu == LS){
		switch(row){
			case 0: {
				SetPlayerPos(playerid,2511.5010,-1670.2648,13.4482);
				SendClientMessage(playerid,COLOUR_YELLOW,"You have teleported.");
				return 1;
			}
			case 1: {
				SetPlayerPos(playerid,2048.7852,-1196.4884,23.6326);
				SendClientMessage(playerid,COLOUR_YELLOW,"You have teleported.");
				return 1;
			}
			case 2: {
				SetPlayerPos(playerid,1540.2794,-1674.9877,13.5503);
				SendClientMessage(playerid,COLOUR_YELLOW,"You have teleported.");
				return 1;
			}
			case 3: {
				SetPlayerPos(playerid,1685.6362,-2329.8545,13.5469);
				SendClientMessage(playerid,COLOUR_YELLOW,"You have teleported.");
				return 1;
			}
			case 4: {
				SetPlayerPos(playerid,1182.1171,-1323.7235,13.5812);
				SendClientMessage(playerid,COLOUR_YELLOW,"You have teleported.");
				return 1;
			}
		}
	}
	
	if(currentmenu == SF){
		switch(row){
			case 0: {
				SetPlayerPos(playerid,-2023.0795,154.1555,28.8359);
				SendClientMessage(playerid,COLOUR_YELLOW,"You have teleported.");
				return 1;
			}
			case 1: {
				SetPlayerPos(playerid,-1604.9398,718.1047,11.8727);
				SendClientMessage(playerid,COLOUR_YELLOW,"You have teleported.");
				return 1;
			}
			case 2: {
				SetPlayerPos(playerid,-2666.8835,609.7924,14.4545);
				SendClientMessage(playerid,COLOUR_YELLOW,"You have teleported.");
				return 1;
			}
			case 3: {
				SetPlayerPos(playerid,-1417.3279,-293.8440,14.1484);
				SendClientMessage(playerid,COLOUR_YELLOW,"You have teleported.");
				return 1;
			}
			case 4: {
				SetPlayerPos(playerid,-2316.8677,-1624.1256,483.7078);
				SendClientMessage(playerid,COLOUR_YELLOW,"You have teleported.");
				return 1;
			}
		}
	}
	
	if(currentmenu == LV){
		switch(row){
			case 0: {
				SetPlayerPos(playerid,2025.0122,1008.5726,10.8203);
				SendClientMessage(playerid,COLOUR_YELLOW,"You have teleported.");
				return 1;
			}
			case 1: {
				SetPlayerPos(playerid,2192.6394,1676.4242,12.3672);
				SendClientMessage(playerid,COLOUR_YELLOW,"You have teleported.");
				return 1;
			}
			case 2: {
				SetPlayerPos(playerid,1607.4633,1819.7698,10.8280);
				SendClientMessage(playerid,COLOUR_YELLOW,"You have teleported.");
				return 1;
			}
			case 3: {
				SetPlayerPos(playerid,2290.0586,2428.9065,10.8203);
				SendClientMessage(playerid,COLOUR_YELLOW,"You have teleported.");
				return 1;
			}
			case 4: {
				SetPlayerPos(playerid,1678.4406,1451.8649,10.7751);
				SendClientMessage(playerid,COLOUR_YELLOW,"You have teleported.");
				return 1;
			}
		}
	}
	return 1;
}


public OnPlayerExitedMenu(playerid){

	return 1;
}

public OnPlayerUpdate(playerid){
	if(god[playerid] == 1){
		new Float:health;
		GetPlayerHealth(playerid,health);
		if(health < 100){
			SetPlayerHealth(playerid,100);
			return 1;
		}
	}
	if(spam[playerid] == 1) return SendClientMessage(playerid,COLOUR_RED,"An admin has turned spam on on your ID");
	return 1;
}

//EOF