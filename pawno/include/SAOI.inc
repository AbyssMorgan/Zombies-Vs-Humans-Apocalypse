/**********************************************************************************************************************************
 *                                                                                                                                *
 *                                           )(   San Andreas Object Image Loader   )(                                            *
 *                                                                                                                                *
 * Copyright © 2017 Abyss Morgan. All rights reserved.                                                                            *
 *                                                                                                                                *
 * Download: https://github.com/AbyssMorgan/SAOI/tree/master/include                                                              *
 * Publication: http://forum.sa-mp.com/showthread.php?t=618429                                                                    *
 *                                                                                                                                *
 * Plugins: Streamer, SScanf                                                                                                      *
 * Modules: None                                                                                                                  *
 * Attributes: Overload resistance. Functionality for one script.                                                                 *
 *                                                                                                                                *
 * File Version: 1.9.0                                                                                                            *
 * SA:MP Version: 0.3.7                                                                                                           *
 * Streamer Version: 2.8.2                                                                                                        *
 * SScanf Version: 2.8.2                                                                                                          *
 *                                                                                                                                *
 * Functions:                                                                                                                     *
 * SAOI:CreateSAOIFile(const name[],author[],version[],description[] = "");                                                       *
 * SAOI:GetSAOIFileHeader(const name[],author[],version[],description[]);                                                         *
 * SAOI:LoadObjectImage(const name[],bool:save_logs=true,bool:fast_boot=false);                                                   *
 * bool:UnloadObjectImage(SAOI:index);                                                                                            *
 * bool:IsSAOIFileLoaded(const name[],&SAOI:index=INVALID_SAOI_FILE);                                                             *
 * SAOI:SAOIHeaderCopy(const input[],const output[]);                                                                             *
 * SAOI:SaveDynamicObject(objectid,const name[]);                                                                                 *
 * SAOI:SaveDynamic3DTextLabel(Text3D:textid,const name[]);                                                                       *
 * SAOI:SaveDynamicPickup(pickupid,const name[]);                                                                                 *
 * SAOI:SaveDynamicMapIcon(iconid,const name[]);                                                                                  *
 * SAOI:SaveDynamicArea(areaid,const name[]);                                                                                     *
 * SAOI:SaveDynamicActor(actorid,const name[]);                                                                                   *
 * SAOI:SetSAOIBumperIP(const name[],server_ip[]);                                                                                *
 * SAOI:SetSAOIBumperPort(const name[],server_port);                                                                              *
 * bool:GetSAOIPositionFlag(SAOI:index,&Float:x,&Float:y,&Float:z,&Float:angle,&virtualworld,&interior);                          *
 * SAOI:SetSAOIPositionFlag(const name[],Float:x,Float:y,Float:z,Float:angle,virtualworld,interior);                              *
 * SAOI:SaveRemoveBuilding(const name[],modelid,Float:x,Float:y,Float:z,Float:radius);                                            *
 * SAOI:SAOI_SaveVehicle(const name[],vehicletype,Float:x,Float:y,Float:z,Float:rotation,color1,color2,respawn_delay,addsiren=0,  *
 *                       worldid=0,interiorid=0);                                                                                 *
 * bool:SAOI_GetFileCreationDate(SAOI:index,output[],max_dest = sizeof(output));                                                  *
 * SAOI_CountDynamicObject(SAOI:index);                                                                                           *
 * SAOI_CountDynamic3DTextLabel(SAOI:index);                                                                                      *
 * SAOI_CountDynamicPickup(SAOI:index);                                                                                           *
 * SAOI_CountDynamicMapIcon(SAOI:index);                                                                                          *
 * SAOI_CountDynamicArea(SAOI:index);                                                                                             *
 * SAOI_CountDynamicActor(SAOI:index);                                                                                            *
 * SAOI_CountVehicle(SAOI:index);                                                                                                 *
 * SAOI_CountMaterial(SAOI:index);                                                                                                *
 * SAOI_CountMaterialText(SAOI:index);                                                                                            *
 * SAOI_CountRemoveBuilding(SAOI:index);                                                                                          *
 * SAOI_CountColAndreasObject(SAOI:index);                                                                                        *
 * SAOI_GetFileName(SAOI:index);                                                                                                  *
 * SAOI_GetLoadTime(SAOI:index);                                                                                                  *
 * SAOI_GetActiveTime(SAOI:index);                                                                                                *
 * SAOI_GetFileSize(SAOI:index);                                                                                                  *
 * SAOI_CountFileLoaded();                                                                                                        *
 * SAOI_CountAllElementsByIndex(SAOI:index);                                                                                      *
 * SAOI_CountAllElements();                                                                                                       *
 * SAOI:SAOI_SetEOF(const name[]);                                                                                                *
 * bool:SAOI_IsPositionFlagSet(SAOI:index);                                                                                       *
 * SAOI_ToggleVisibleItems(const name[],playerid,type,toggle);                                                                    *
 *                                                                                                                                *
 * Extended Functions:                                                                                                            *
 * SAOIToInt(SAOI:variable);                                                                                                      *
 * SAOI:SAOI_GetFreeID();                                                                                                         *
 * SAOI_IsLoaded(SAOI:index);                                                                                                     *
 * SAOI_IsStatic(SAOI:index);                                                                                                     *
 * SAOI_IsReadOnly(SAOI:index);                                                                                                   *
 * SAOI_GetFreeRemoveBuildingID();                                                                                                *
 * SAOI_RemoveBuilding(SAOI:index,modelid,Float:x,Float:y,Float:z,Float:radius);                                                  *
 * SAOI_GetRemoveBuilding(remove_id,&SAOI:index,&modelid,&Float:x,&Float:y,&Float:z,&Float:radius);                               *
 * SAOI_DropRemoveBuildings(SAOI:index);                                                                                          *
 * SAOI_CleanupElements(SAOI:index);                                                                                              *
 * SAOI_RemoveBuildingsForPlayer(playerid);                                                                                       *
 * SAOI_UpdateBuildingsForPlayer(playerid,SAOI:index);                                                                            *
 * SAOI_CountRemovedBuildings();                                                                                                  *
 * SAOI_GetMemoryLoaded();                                                                                                        *
 * SAOI_GetErrorName(SAOI:index,error_name[],maxdest = sizeof(error_name));                                                       *
 *                                                                                                                                *
 * Callbacks:                                                                                                                     *
 * SAOI_OnRemovedBuildings(playerid,buildings);                                                                                   *
 * SAOI_OnVehicleDestroyed(vehicleid);                                                                                            *
 * SAOI_OnVehicleCreated(vehicleid);                                                                                              *
 *                                                                                                                                *
 **********************************************************************************************************************************/

/*
//Check Version SAOI.inc
#if !defined _SAOI_LOADER
	#error You need SAOI.inc v1.9.0
#elseif !defined SAOI_LOADER_VERSION
	#error Update you SAOI.inc to v1.9.0
#elseif (SAOI_LOADER_VERSION < 10900)
	#error Update you SAOI.inc to v1.9.0
#endif
*/

#if !defined Streamer_AppendArrayData
	#error [ADM] Unknown Streamer Version
#endif

#if !defined sscanf
	#error [ADM] Unknown SScanf Version
#endif

#if defined _streamer_spec
	#if !defined DISABLE_STREAMER_SPEC_FIXES
		#error [ADM] Invalid mechanism StreamerFunction.inc:DestroyFix (Use #define DISABLE_STREAMER_SPEC_FIXES before StreamerFunction.inc)
	#endif
#endif

#if defined _SAOI_LOADER
	#endinput
#endif
#define _SAOI_LOADER

#define SAOI_LOADER_VERSION 				(10900)			//a.b[c] 10000*a+100*b+c

#define SAOI::								SAOI:

#define SAOI_HEADER_KEY						"SAOI 1.1 ADM"	//You can never change !!!

#define INVALID_SAOI_FILE					(SAOI:0)		//You can never change !!!
#define SAOI_EXTRA_ID_OFFSET				(1000000)		//You can never change !!!

#define MAX_SAOI_FILE_SIZE					(0x4000000)		//64 MB
#define MAX_SAOI_NAME_SIZE					(64)
#define MAX_SAOI_ERROR_NAME					(80)

#define MAX_SAOI_AUTHOR_SIZE 				(32)			//Max Value: 255 (auto resize header, compatible with all version) 
#define MAX_SAOI_VERSION_SIZE 				(32)			//Max Value: 255 (auto resize header, compatible with all version)
#define MAX_SAOI_DESCRIPTION_SIZE 			(128)			//Max Value: 255 (auto resize header, compatible with all version)

#define MAX_FONT_NAME 						(32)			//Max Value: 255 (These limits can be changed according to the San Andreas)
#define MAX_TXD_NAME						(32)			//Max Value: 255 (These limits can be changed according to the San Andreas)
#define MAX_TEXTURE_NAME					(32)			//Max Value: 255 (These limits can be changed according to the San Andreas)
#define MAX_TEXT_NAME						(2048)			//Max Value: 65535 (These limits can be changed according to the San Andreas)

#if !defined MAX_SAOI_FILE
	#define MAX_SAOI_FILE					(SAOI:2001)		//more ? why not
#endif

#define SAOI_ERROR_UNEXEC					(SAOI:0)		//function unexecutable
#define SAOI_ERROR_SUCCESS					(SAOI:-1)		//success
#define SAOI_ERROR_INPUT_NOT_EXIST			(SAOI:-2)		//input file not exist
#define SAOI_ERROR_OUTPUT_NOT_EXIST			(SAOI:-3)		//output file not exist
#define SAOI_ERROR_INPUT_EXIST				(SAOI:-4)		//input file exist
#define SAOI_ERROR_OUTPUT_EXIST				(SAOI:-5)		//output file exist
#define SAOI_ERROR_INPUT_NOT_OPEN			(SAOI:-6)		//error open input file
#define SAOI_ERROR_OUTPUT_NOT_OPEN			(SAOI:-7)		//error open output file
#define SAOI_ERROR_FILE_SIZE				(SAOI:-8)		//invalid file size
#define SAOI_ERROR_INVALID_OBJECTID			(SAOI:-9)		//invalid objectid
#define SAOI_ERROR_AUTHOR_SIZE				(SAOI:-10)		//invalid author size
#define SAOI_ERROR_VERSION_SIZE				(SAOI:-11)		//invalid version size
#define SAOI_ERROR_DESCRIPTION_SIZE			(SAOI:-12)		//invalid description size
#define SAOI_ERROR_INVALID_HEADER			(SAOI:-13)		//invalid header
#define SAOI_ERROR_INPUT_EXTENSION			(SAOI:-14)		//invalid input extension
#define SAOI_ERROR_OUTPUT_EXTENSION			(SAOI:-15)		//invalid output extension
#define SAOI_ERROR_NOT_ENOUGH_CAPACITY		(SAOI:-16)		//not enough capacity, to load new file
#define SAOI_ERROR_INVALID_ARG_COUNT		(SAOI:-17)		//number of arguments exceeds the specified arguments (error structure version)
#define SAOI_ERROR_INVALID_SERVER_IP		(SAOI:-18)		//bumper: invalid server ip
#define SAOI_ERROR_INVALID_SERVER_PORT		(SAOI:-19)		//bumper: invalid server port
#define SAOI_ERROR_MEMORY_BLOCKED			(SAOI:-20)		//memory blocked
#define SAOI_ERROR_IS_LOADED				(SAOI:-21)		//file is already loaded

#define ELEMENT_FLAG_ANTI_AREA				(0)
#define ELEMENT_FLAG_NO_CAMERA_COL			(1)
#define ELEMENT_FLAG_COLANDREAS				(2)
#define ELEMENT_FLAG_COLSTATIC				(3)

#define INVALID_REMOVE_BUILDING_ID			(-1)

#define SAOI_BUMPER_ACTOR					(99)
#define SAOI_BUMPER_3D_TEXT_LABEL			(100)
#define SAOI_BUMPER_PICKUP					(101)
#define SAOI_BUMPER_MAPICON					(104)
#define SAOI_BUMPER_VEHICLE					(109)
#define SAOI_BUMPER_AREA_CIRCLE				(110)
#define SAOI_BUMPER_AREA_CYLINDER			(111)
#define SAOI_BUMPER_AREA_SPHERE				(112)
#define SAOI_BUMPER_AREA_RECTANGLE			(113)
#define SAOI_BUMPER_AREA_CUBOID				(114)
#define SAOI_BUMPER_AREA_POLYGON			(115)

#define SAOI_BUMPER_IP						(201)
#define SAOI_BUMPER_PORT					(202)
#define SAOI_BUMPER_POS						(203)
#define SAOI_BUMPER_CREATED					(204)
#define SAOI_BUMPER_REMOVEBUILDING			(205)
#define SAOI_BUMPER_EOF						(255)

#define SAOIToInt(%0)						(_:%0)
#define SAOI_IntMod(%0)						(0xFF & (%0)+128)
#define SAOI_Comp(%0,%1)					(SAOI_IntMod(%0) != (%1))
#define SAOI_Foreach(%0)					for(new SAOI:%0 = SAOI:1; %0 < MAX_SAOI_FILE; %0 = SAOI:(SAOIToInt(%0)+1))

#define SAOI_Function::						stock
#define SAOI_Public::%0(%1)					forward %0(%1); public %0(%1)

#define SAOIV:								S11V

//BitFunctions.inc
#define SAOI_GetValueBit(%0,%1)				((%0) >>> (%1) & 0x01)
#define SAOI_SetValueBit(%0,%1,%2)			((%0) = (((%0) & ~(0x01 << (%1))) | ((0x01 << (%1))*(%2))))

#define SAOI_ExtractValue(%0,%1,%2,%3,%4)	((%1) = (((%0) & 0xFF000000) >>> 24),(%2) = (((%0) & 0x00FF0000) >>> 16),(%3) = (((%0) & 0x0000FF00) >>> 8),(%4) = ((%0) & 0x000000FF))
#define SAOI_ExtractFloat(%0,%1,%2,%3,%4)	((%1) = (((_:%0) & 0xFF000000) >>> 24),(%2) = (((_:%0) & 0x00FF0000) >>> 16),(%3) = (((_:%0) & 0x0000FF00) >>> 8),(%4) = ((_:%0) & 0x000000FF))

#define SAOI_MergeValue(%0,%1,%2,%3,%4)		((%0) = (((%1) << 24) | ((%2) << 16) | ((%3) << 8) | (%4)))
#define SAOI_MergeFloat(%0,%1,%2,%3,%4)		((%0) = Float:(((%1) << 24) | ((%2) << 16) | ((%3) << 8) | (%4)))

#define SAOI_MergeValueEx(%1,%2,%3,%4)		(((%1) << 24) | ((%2) << 16) | ((%3) << 8) | (%4))
#define SAOI_MergeFloatEx(%1,%2,%3,%4)		(Float:(((%1) << 24) | ((%2) << 16) | ((%3) << 8) | (%4)))

#if !defined isnull
	#define isnull(%1) 						((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
#endif

#if !defined MAX_POLYGON_POINTS
	#define MAX_POLYGON_POINTS 				(256)
#endif

#if (defined COLANDREAS)
	#define SAOI_ColAndreas
#endif

enum e_remove_building {
	SAOI:SAOIV:index,
	SAOIV:modelid,
	Float:SAOIV:X,
	Float:SAOIV:Y,
	Float:SAOIV:Z,
	Float:SAOIV:R
}

enum e_saoi {
	bool:SAOIV:status,
	SAOIV:name[MAX_SAOI_NAME_SIZE],
	bool:SAOIV:is_static,
	
	SAOIV:cnt_object,
	SAOIV:cnt_pickup,
	SAOIV:cnt_3dtext,
	SAOIV:cnt_mapicon,
	SAOIV:cnt_area,
	SAOIV:cnt_actor,
	SAOIV:cnt_vehicle,
	
	SAOIV:cnt_material,
	SAOIV:cnt_materialtext,
	SAOIV:cnt_removebuilding,
	
	SAOIV:offset_object,
	SAOIV:offset_pickup,
	SAOIV:offset_3dtext,
	SAOIV:offset_mapicon,
	SAOIV:offset_area,
	SAOIV:offset_actor,
	SAOIV:offset_vehicle,
	
	#if defined SAOI_ColAndreas
		SAOIV:cnt_caobject,
		SAOIV:offset_caobject,
	#endif
	
	SAOIV:load_time,
	SAOIV:active_tick,
	SAOIV:file_size,
	bool:SAOIV:write_lock,
	
	Float:SAOIV:X,
	Float:SAOIV:Y,
	Float:SAOIV:Z,
	Float:SAOIV:A,
	SAOIV:VW,
	SAOIV:INT,
	
	SAOIV:created[32]
}

new SAOIFile[SAOI:MAX_SAOI_FILE][e_saoi],
	SAOI:SAOI_Vehicles[MAX_VEHICLES],
	SAOIRemoveBuildings[MAX_OBJECTS][e_remove_building],
	SAOIRemoveUpperbound = INVALID_REMOVE_BUILDING_ID,
	bool:SAOIPlayerFirstSpawn[MAX_PLAYERS],
	bool:CRC_SAOIAccess = false;
	
forward SAOI_OnRemovedBuildings(playerid,buildings);
forward SAOI_OnVehicleDestroyed(vehicleid);
forward SAOI_OnVehicleCreated(vehicleid);

#define SAOI_IsStatic(%0) 					(SAOIFile[(%0)][SAOIV:is_static])
#define SAOI_IsLoaded(%0) 					(SAOIFile[(%0)][SAOIV:status])
#define SAOI_GetFileSize(%0)				(SAOIFile[(%0)][SAOIV:file_size])
#define SAOI_GetActiveTime(%0)				(GetTickCount()-SAOIFile[(%0)][SAOIV:active_tick])
#define SAOI_GetFileName(%0)				(SAOIFile[(%0)][SAOIV:name])
#define SAOI_GetLoadTime(%0)				(SAOIFile[(%0)][SAOIV:load_time])
#define SAOI_IsReadOnly(%0)					(SAOIFile[(%0)][SAOIV:write_lock])
#define SAOI_CountDynamicObject(%0)			(SAOIFile[(%0)][SAOIV:cnt_object])
#define SAOI_CountDynamicPickup(%0)			(SAOIFile[(%0)][SAOIV:cnt_pickup])
#define SAOI_CountDynamic3DTextLabel(%0)	(SAOIFile[(%0)][SAOIV:cnt_3dtext])
#define SAOI_CountDynamicActor(%0)			(SAOIFile[(%0)][SAOIV:cnt_actor])
#define SAOI_CountDynamicMapIcon(%0)		(SAOIFile[(%0)][SAOIV:cnt_mapicon])
#define SAOI_CountDynamicArea(%0)			(SAOIFile[(%0)][SAOIV:cnt_area])
#define SAOI_CountVehicle(%0)				(SAOIFile[(%0)][SAOIV:cnt_vehicle])
#define SAOI_CountMaterial(%0)				(SAOIFile[(%0)][SAOIV:cnt_material])
#define SAOI_CountMaterialText(%0)			(SAOIFile[(%0)][SAOIV:cnt_materialtext])
#define SAOI_CountRemoveBuilding(%0)		(SAOIFile[(%0)][SAOIV:cnt_removebuilding])

#if defined SAOI_ColAndreas
	#define SAOI_CountColAndreasObject(%0)	(SAOIFile[(%0)][SAOIV:cnt_caobject])
#endif

SAOI_Function:: SAOI_GetErrorName(SAOI:index,error_name[],maxdest = sizeof(error_name)){
	switch(index){
		case SAOI_ERROR_UNEXEC: 				format(error_name,maxdest,"Error function unexecutable");
		case SAOI_ERROR_SUCCESS:				format(error_name,maxdest,"Success");
		case SAOI_ERROR_INPUT_NOT_EXIST: 		format(error_name,maxdest,"Error input file not exist");
		case SAOI_ERROR_OUTPUT_NOT_EXIST: 		format(error_name,maxdest,"Error output file not exist");
		case SAOI_ERROR_INPUT_EXIST: 			format(error_name,maxdest,"Error input file exist");
		case SAOI_ERROR_OUTPUT_EXIST:		 	format(error_name,maxdest,"Error output file exist");
		case SAOI_ERROR_INPUT_NOT_OPEN: 		format(error_name,maxdest,"Error open input file");
		case SAOI_ERROR_OUTPUT_NOT_OPEN: 		format(error_name,maxdest,"Error open output file");
		case SAOI_ERROR_FILE_SIZE: 				format(error_name,maxdest,"Error invalid file size");
		case SAOI_ERROR_INVALID_OBJECTID:	 	format(error_name,maxdest,"Error invalid objectid");
		case SAOI_ERROR_AUTHOR_SIZE: 			format(error_name,maxdest,"Error invalid author size");
		case SAOI_ERROR_VERSION_SIZE: 			format(error_name,maxdest,"Error invalid version size");
		case SAOI_ERROR_DESCRIPTION_SIZE:	 	format(error_name,maxdest,"Error invalid description size");
		case SAOI_ERROR_INVALID_HEADER: 		format(error_name,maxdest,"Error invalid header");
		case SAOI_ERROR_INPUT_EXTENSION: 		format(error_name,maxdest,"Error invalid input extension");
		case SAOI_ERROR_OUTPUT_EXTENSION: 		format(error_name,maxdest,"Error invalid output extension");
		case SAOI_ERROR_NOT_ENOUGH_CAPACITY: 	format(error_name,maxdest,"Error not enough capacity, to load new file");
		case SAOI_ERROR_INVALID_ARG_COUNT: 		format(error_name,maxdest,"Error number of arguments exceeds the specified arguments");
		case SAOI_ERROR_INVALID_SERVER_IP:		format(error_name,maxdest,"Error invalid server ip");
		case SAOI_ERROR_INVALID_SERVER_PORT:	format(error_name,maxdest,"Error invalid server port");
		case SAOI_ERROR_MEMORY_BLOCKED:			format(error_name,maxdest,"Error memory blocked");
		case SAOI_ERROR_IS_LOADED:				format(error_name,maxdest,"Error file is already loaded");
	}
}

SAOI_Function:: SAOIV:Construct(){
	new SAOIV:data[e_saoi];
	#if defined SAOI_ColAndreas
		SAOIV:data[SAOIV:offset_caobject] = -1;
	#endif
	return SAOIV:data;
}

SAOI_Function:: SAOI_CountAllElementsByIndex(SAOI:index){
	new items = 0;
	items += SAOI_CountDynamicObject(index);
	items += SAOI_CountDynamicPickup(index);
	items += SAOI_CountDynamic3DTextLabel(index);
	items += SAOI_CountDynamicMapIcon(index);
	items += SAOI_CountDynamicArea(index);
	items += SAOI_CountDynamicActor(index);
	items += SAOI_CountVehicle(index);
	items += SAOI_CountMaterial(index);
	items += SAOI_CountMaterialText(index);
	items += SAOI_CountRemoveBuilding(index);
	#if defined SAOI_ColAndreas
		items += SAOI_CountColAndreasObject(index);
	#endif
	return items;
}

SAOI_Function:: SAOI_CountAllElements(){
	new items = 0;
	SAOI_Foreach(i){
		if(SAOI_IsLoaded(i)){
			items += SAOI_CountAllElementsByIndex(i);
		}
	}
	return items;
}

SAOI_Function:: SAOI_CountRemovedBuildings(){
	if(!CRC_SAOIAccess) return 0;
	new cnt = 0;
	for(new i = SAOIRemoveUpperbound; i >= 0; i--){
		if(SAOIRemoveBuildings[i][SAOIV:modelid] != 0){
			cnt++;
		}
	}
	return cnt;
}

SAOI_Function:: SAOI_GetFreeRemoveBuildingID(){
	if(!CRC_SAOIAccess) return INVALID_REMOVE_BUILDING_ID;
	for(new i = 0; i < MAX_OBJECTS; i++){
		if(SAOIRemoveBuildings[i][SAOIV:modelid] == 0){
			if(i > SAOIRemoveUpperbound) SAOIRemoveUpperbound = i;
			return i;
		}
	}
	return INVALID_REMOVE_BUILDING_ID;
}

SAOI_Function:: SAOI_GetRemoveBuilding(remove_id,&SAOI:index,&modelid,&Float:x,&Float:y,&Float:z,&Float:radius){
	if(!CRC_SAOIAccess) return 0;
	if(SAOIRemoveBuildings[remove_id][SAOIV:modelid] == 0) return 0;
	modelid = SAOIRemoveBuildings[remove_id][SAOIV:modelid];
	x = SAOIRemoveBuildings[remove_id][SAOIV:X];
	y = SAOIRemoveBuildings[remove_id][SAOIV:Y];
	z = SAOIRemoveBuildings[remove_id][SAOIV:Z];
	radius = SAOIRemoveBuildings[remove_id][SAOIV:R];
	index = SAOIRemoveBuildings[remove_id][SAOIV:index];
	return 1;
}

SAOI_Function:: SAOI_RemoveBuilding(SAOI:index,modelid,Float:x,Float:y,Float:z,Float:radius){
	if(!CRC_SAOIAccess) return INVALID_REMOVE_BUILDING_ID;
	if(!SAOI_IsLoaded(index)) return INVALID_REMOVE_BUILDING_ID;
	new remove_id = SAOI_GetFreeRemoveBuildingID();
	if(remove_id == INVALID_REMOVE_BUILDING_ID) return INVALID_REMOVE_BUILDING_ID;
	SAOIRemoveBuildings[remove_id][SAOIV:modelid] = modelid;
	SAOIRemoveBuildings[remove_id][SAOIV:X] = x;
	SAOIRemoveBuildings[remove_id][SAOIV:Y] = y;
	SAOIRemoveBuildings[remove_id][SAOIV:Z] = z;
	SAOIRemoveBuildings[remove_id][SAOIV:R] = radius;
	SAOIRemoveBuildings[remove_id][SAOIV:index] = index;
	return remove_id;
}

SAOI_Function:: SAOI_DropRemoveBuildings(SAOI:index){
	if(!CRC_SAOIAccess) return 0;
	if(!SAOI_IsLoaded(index)) return 0;
	new cnt = 0;
	for(new i = SAOIRemoveUpperbound; i >= 0; i--){
		if(SAOIRemoveBuildings[i][SAOIV:index] == index){
			SAOIRemoveBuildings[i][SAOIV:modelid] = 0;
			SAOIRemoveBuildings[i][SAOIV:X] = 0.0;
			SAOIRemoveBuildings[i][SAOIV:Y] = 0.0;
			SAOIRemoveBuildings[i][SAOIV:Z] = 0.0;
			SAOIRemoveBuildings[i][SAOIV:R] = 0.0;
			SAOIRemoveBuildings[i][SAOIV:index] = INVALID_SAOI_FILE;
			if(i == SAOIRemoveUpperbound) SAOIRemoveUpperbound--;
			cnt++;
		}
	}
	return cnt;
}

SAOI_Function:: SAOI_RemoveBuildingsForPlayer(playerid){
	if(!CRC_SAOIAccess) return 0;
	new cnt = 0;
	for(new i = SAOIRemoveUpperbound; i >= 0; i--){
		if(SAOIRemoveBuildings[i][SAOIV:modelid] != 0){
			RemoveBuildingForPlayer(playerid,SAOIRemoveBuildings[i][SAOIV:modelid],SAOIRemoveBuildings[i][SAOIV:X],SAOIRemoveBuildings[i][SAOIV:Y],SAOIRemoveBuildings[i][SAOIV:Z],SAOIRemoveBuildings[i][SAOIV:R]);
			cnt++;
		}
	}
	return cnt;
}

SAOI_Function:: SAOI_UpdateBuildingsForPlayer(playerid,SAOI:index){
	if(!CRC_SAOIAccess) return 0;
	if(!SAOI_IsLoaded(index)) return 0;
	new cnt = 0;
	for(new i = SAOIRemoveUpperbound; i >= 0; i--){
		if(SAOIRemoveBuildings[i][SAOIV:modelid] != 0 && SAOIRemoveBuildings[i][SAOIV:index] == index){
			RemoveBuildingForPlayer(playerid,SAOIRemoveBuildings[i][SAOIV:modelid],SAOIRemoveBuildings[i][SAOIV:X],SAOIRemoveBuildings[i][SAOIV:Y],SAOIRemoveBuildings[i][SAOIV:Z],SAOIRemoveBuildings[i][SAOIV:R]);
			cnt++;
		}
	}
	return cnt;
}

SAOI_Function:: SAOI:SAOI_GetFreeID(){
	if(!CRC_SAOIAccess) return INVALID_SAOI_FILE;
	SAOI_Foreach(i){
		if(!SAOI_IsLoaded(i)) return i;
	}
	return INVALID_SAOI_FILE;
}

SAOI_Function:: SAOI_CountFileLoaded(){
	if(!CRC_SAOIAccess) return 0;
	new cnt = 0;
	SAOI_Foreach(i){
		if(SAOI_IsLoaded(i)) cnt++;
	}
	return cnt;
}

SAOI_Function:: SAOI_GetMemoryLoaded(){
	if(!CRC_SAOIAccess) return 0;
	new cnt = 0;
	SAOI_Foreach(i){
		if(SAOI_IsLoaded(i)) cnt += SAOIFile[i][SAOIV:file_size];
	}
	return cnt;
}

SAOI_Function:: SAOI:SAOI_SetEOF(const name[]){
	if(!fexist(name)) return SAOI_ERROR_OUTPUT_NOT_EXIST;
	if(strfind(name,".saoi",true) == -1) return SAOI_ERROR_OUTPUT_EXTENSION;
	new File:outf = fopen(name,io_append);
	if(!outf) return SAOI_ERROR_OUTPUT_NOT_OPEN;
	fputchar(outf,SAOI_BUMPER_EOF,false);
	fclose(outf);
	return SAOI_ERROR_SUCCESS;
}

SAOI_Function:: bool:SAOI_GetFileCreationDate(SAOI:index,output[],max_dest = sizeof(output)){
	if(!CRC_SAOIAccess) return false;
	if(!SAOI_IsLoaded(index)) return false;
	format(output,max_dest,"%s",SAOIFile[index][SAOIV:created]);
	return true;
}

SAOI_Function:: bool:GetSAOIPositionFlag(SAOI:index,&Float:x,&Float:y,&Float:z,&Float:angle,&virtualworld,&interior){
	if(!CRC_SAOIAccess) return false;
	if(!SAOI_IsLoaded(index)) return false;
	x = SAOIFile[index][SAOIV:X];
	y = SAOIFile[index][SAOIV:Y];
	z = SAOIFile[index][SAOIV:Z];
	angle = SAOIFile[index][SAOIV:A];
	virtualworld = SAOIFile[index][SAOIV:VW];
	interior = SAOIFile[index][SAOIV:INT];
	return true;
}

SAOI_Function:: bool:SAOI_IsPositionFlagSet(SAOI:index){
	if(!CRC_SAOIAccess) return false;
	if(!SAOI_IsLoaded(index)) return false;
	if(SAOIFile[index][SAOIV:X] == 0.0 && SAOIFile[index][SAOIV:Y] == 0.0 && SAOIFile[index][SAOIV:Z] == 0.0 && SAOIFile[index][SAOIV:A] == 0.0) return false;
	return true;
}

SAOI_Function:: SAOI:SetSAOIPositionFlag(const name[],Float:x,Float:y,Float:z,Float:angle,virtualworld,interior){
	if(!fexist(name)) return SAOI_ERROR_OUTPUT_NOT_EXIST;
	if(strfind(name,".saoi",true) == -1) return SAOI_ERROR_OUTPUT_EXTENSION;
	new File:outf = fopen(name,io_append), int1, int2, int3, int4;
	if(!outf) return SAOI_ERROR_OUTPUT_NOT_OPEN;
	
	fputchar(outf,SAOI_BUMPER_POS,false);
	
	SAOI_ExtractFloat(x,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	SAOI_ExtractFloat(y,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	SAOI_ExtractFloat(z,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	SAOI_ExtractFloat(angle,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	SAOI_ExtractValue(virtualworld,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);

	SAOI_ExtractValue(interior,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	fclose(outf);
	return SAOI_ERROR_SUCCESS;
}

SAOI_Function:: SAOI:SaveRemoveBuilding(const name[],modelid,Float:x,Float:y,Float:z,Float:radius){
	if(!fexist(name)) return SAOI_ERROR_OUTPUT_NOT_EXIST;
	if(strfind(name,".saoi",true) == -1) return SAOI_ERROR_OUTPUT_EXTENSION;
	new File:outf = fopen(name,io_append), int1, int2, int3, int4;
	if(!outf) return SAOI_ERROR_OUTPUT_NOT_OPEN;
	
	fputchar(outf,SAOI_BUMPER_REMOVEBUILDING,false);
	
	SAOI_ExtractValue(modelid,int1,int2,int3,int4);
	fputchar(outf,int3,false), fputchar(outf,int4,false);

	SAOI_ExtractFloat(x,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	SAOI_ExtractFloat(y,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	SAOI_ExtractFloat(z,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	SAOI_ExtractFloat(radius,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	fclose(outf);
	return SAOI_ERROR_SUCCESS;
}

SAOI_Function:: bool:IsSAOIFileLoaded(const name[],&SAOI:index=INVALID_SAOI_FILE){
	if(!CRC_SAOIAccess) return false;
	new tmp_saoi_name[MAX_SAOI_NAME_SIZE];
	format(tmp_saoi_name,MAX_SAOI_NAME_SIZE,"%s",name);
	for(new i = strlen(tmp_saoi_name)-1; i >= 0; i--){
		if(tmp_saoi_name[i] == '.'){
			tmp_saoi_name[i] = EOS;
			break;
		}
	}
	SAOI_Foreach(i){
		if(SAOI_IsLoaded(i)){
			if(!strcmp(tmp_saoi_name,SAOIFile[i][SAOIV:name],true)){
				index = i;
				return true;
			}
		}
	}
	return false;
}

SAOI_Function:: SAOI:CreateSAOIFile(const name[],author[],version[],description[] = ""){
	if(fexist(name)) return SAOI_ERROR_OUTPUT_EXIST;
	if(strfind(name,".saoi",true) == -1) return SAOI_ERROR_OUTPUT_EXTENSION;
	new File:outf = fopen(name,io_readwrite);
	if(!outf) return SAOI_ERROR_OUTPUT_NOT_OPEN;
	
	new year,month,day,hour,minute,second;
	getdate(year,month,day);
	gettime(hour,minute,second);
	
	fwrite(outf,SAOI_HEADER_KEY);
	//Create Header
	new author_size = strlen(author),
		version_size = strlen(version),
		description_size = strlen(description);
	
	if(author_size > MAX_SAOI_AUTHOR_SIZE){
		fclose(outf);
		return SAOI_ERROR_AUTHOR_SIZE;
	}
	if(version_size > MAX_SAOI_VERSION_SIZE ){
		fclose(outf);
		return SAOI_ERROR_VERSION_SIZE;
	}
	if(description_size > MAX_SAOI_DESCRIPTION_SIZE){
		fclose(outf);
		return SAOI_ERROR_DESCRIPTION_SIZE;
	}
	
	new key[32];
	for(new i = 0; i < 32; i++){
		key[i] = random(255)+1;
	}
	
	new step;
	
	step = 0;
	for(new i = 0; i < author_size; i++){
		author[i] = ((author[i]+key[step]) & 0xFF);
		step++;
		if(step >= 32) step = 0;
	}
	fputchar(outf,author_size,false);
	for(new i = 0; i < author_size; i++){
		fputchar(outf,author[i],false);
	}
	
	step = 0;
	for(new i = 0; i < version_size; i++){
		version[i] = ((version[i]+key[step]) & 0xFF);
		step++;
		if(step >= 32) step = 0;
	}
	fputchar(outf,version_size,false);
	for(new i = 0; i < version_size; i++){
		fputchar(outf,version[i],false);
	}
	
	step = 0;
	for(new i = 0; i < description_size; i++){
		description[i] = ((description[i]+key[step]) & 0xFF);
		step++;
		if(step >= 32) step = 0;
	}
	fputchar(outf,description_size,false);
	for(new i = 0; i < description_size; i++){
		fputchar(outf,description[i],false);
	}
	
	for(new i = 0; i < 32; i++){
		fputchar(outf,((256-key[i]) & 0xFF),false);
	}

	fputchar(outf,SAOI_BUMPER_CREATED,false);
	
	new int1, int2, int3, int4;
	SAOI_ExtractValue(year,int1,int2,int3,int4);
	fputchar(outf,SAOI_IntMod(int3),false);
	fputchar(outf,SAOI_IntMod(int4),false);
	
	fputchar(outf,SAOI_IntMod(month),false);
	fputchar(outf,SAOI_IntMod(day),false);
	fputchar(outf,SAOI_IntMod(hour),false);
	fputchar(outf,SAOI_IntMod(minute),false);
	fputchar(outf,SAOI_IntMod(second),false);
	
	#pragma unused int1,int2
	
	fclose(outf);
	return SAOI_ERROR_SUCCESS;
}

SAOI_Function:: SAOI:SaveDynamicObject(objectid,const name[]){
	if(!IsValidDynamicObject(objectid)) return SAOI_ERROR_INVALID_OBJECTID;
	if(!fexist(name)) return SAOI_ERROR_OUTPUT_NOT_EXIST;
	if(strfind(name,".saoi",true) == -1) return SAOI_ERROR_OUTPUT_EXTENSION;
	new File:outf = fopen(name,io_append);
	if(!outf) return SAOI_ERROR_OUTPUT_NOT_OPEN;
	
	new modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, worldid, interiorid, Float:streamdistance, Float:drawdistance, areaid, priority,
		arg_count = 14, material_used = 0, material_text_used = 0, element_flag;
	
	//Get Object Info
	modelid = Streamer_GetIntData(STREAMER_TYPE_OBJECT,objectid,E_STREAMER_MODEL_ID);
	GetDynamicObjectPos(objectid,x,y,z);
	GetDynamicObjectRot(objectid,rx,ry,rz);
	worldid = Streamer_GetIntData(STREAMER_TYPE_OBJECT,objectid,E_STREAMER_WORLD_ID);
	interiorid = Streamer_GetIntData(STREAMER_TYPE_OBJECT,objectid,E_STREAMER_INTERIOR_ID);
	
	Streamer_GetFloatData(STREAMER_TYPE_OBJECT,objectid,E_STREAMER_STREAM_DISTANCE,streamdistance);
	Streamer_GetFloatData(STREAMER_TYPE_OBJECT,objectid,E_STREAMER_DRAW_DISTANCE,drawdistance);
	
	areaid = Streamer_GetIntData(STREAMER_TYPE_OBJECT,objectid,E_STREAMER_AREA_ID);
	priority = Streamer_GetIntData(STREAMER_TYPE_OBJECT,objectid,E_STREAMER_PRIORITY);
	
	if(Streamer_IsToggleItemInvAreas(STREAMER_TYPE_OBJECT,objectid)){
		SAOI_SetValueBit(element_flag,ELEMENT_FLAG_ANTI_AREA,1);
	}
	if(GetDynamicObjectNoCameraCol(objectid)){
		SAOI_SetValueBit(element_flag,ELEMENT_FLAG_NO_CAMERA_COL,1);
	}
	
	element_flag |= (Streamer_GetIntData(STREAMER_TYPE_OBJECT,objectid,E_STREAMER_EXTRA_ID) & 0xFF);
	
	//Count Arg
	for(new i = arg_count; i > 7; i--){
		switch(i){
			case 14: {
				if(element_flag == 0){
					arg_count--;
				} else {
					break;
				}
			}
			case 13: {
				if(priority == 0){
					arg_count--;
				} else {
					break;
				}
			}
			case 12: {
				if(areaid == -1){
					arg_count--;
				} else {
					break;
				}
			}
			case 11: {
				if(drawdistance == STREAMER_OBJECT_DD){
					arg_count--;
				} else {
					break;
				}
			}
			case 10: {
				if(streamdistance == STREAMER_OBJECT_SD){
					arg_count--;
				} else {
					break;
				}
			}
			case 9: {
				if(interiorid == -1){
					arg_count--;
				} else {
					break;
				}
			}
			case 8: {
				if(worldid == -1){
					arg_count--;
				} else {
					break;
				}
			}
		}
	}
	
	//RAW Generator
	new int1, int2, int3, int4;
	
	//Save Arg Count
	fputchar(outf,arg_count,false);
	
	//Save Object Info
	SAOI_ExtractValue(modelid,int1,int2,int3,int4);
	fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	SAOI_ExtractFloat(x,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	SAOI_ExtractFloat(y,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	SAOI_ExtractFloat(z,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	SAOI_ExtractFloat(rx,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	SAOI_ExtractFloat(ry,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	SAOI_ExtractFloat(rz,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	if(arg_count >= 8){
		SAOI_ExtractValue(worldid,int1,int2,int3,int4);
		fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	}
	if(arg_count >= 9){
		SAOI_ExtractValue(interiorid,int1,int2,int3,int4);
		fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	}
	if(arg_count >= 10){
		SAOI_ExtractFloat(streamdistance,int1,int2,int3,int4);
		fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	}
	if(arg_count >= 11){
		SAOI_ExtractFloat(drawdistance,int1,int2,int3,int4);
		fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	}
	if(arg_count >= 12){
		SAOI_ExtractValue(areaid,int1,int2,int3,int4);
		fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	}
	if(arg_count >= 13){
		SAOI_ExtractValue(priority,int1,int2,int3,int4);
		fputchar(outf,int4,false);
	}
	if(arg_count >= 14){
		SAOI_ExtractValue(element_flag,int1,int2,int3,int4);
		fputchar(outf,int4,false);
	}
	
	
	//Get and Save Object Material
	for(new i = 0; i < 16; i++){
		if(IsDynamicObjectMaterialUsed(objectid,i)){
			SAOI_SetValueBit(material_used,i,1);
		}
	}
	
	SAOI_ExtractValue(material_used,int1,int2,int3,int4);
	fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	new mid, txdname[MAX_TXD_NAME], texturename[MAX_TEXTURE_NAME], materialcolor;
	for(new i = 0; i < 16; i++){
		if(SAOI_GetValueBit(material_used,i) == 1){
			GetDynamicObjectMaterial(objectid,i,mid,txdname,texturename,materialcolor);
			
			SAOI_ExtractValue(mid,int1,int2,int3,int4);
			fputchar(outf,int3,false), fputchar(outf,int4,false);
			
			fputchar(outf,strlen(txdname),false);
			for(new k = 0, l = strlen(txdname); k < l; k++){
				fputchar(outf,SAOI_IntMod(txdname[k]),false);
			}
			
			fputchar(outf,strlen(texturename),false);
			for(new k = 0, l = strlen(texturename); k < l; k++){
				fputchar(outf,SAOI_IntMod(texturename[k]),false);
			}
			
			SAOI_ExtractValue(materialcolor,int1,int2,int3,int4);
			fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
		}
	}
	
	//Get and Save Object Material Text
	for(new i = 0; i < 16; i++){
		if(IsDynamicObjectMaterialTextUsed(objectid,i)){
			SAOI_SetValueBit(material_text_used,i,1);
		}
	}
	
	SAOI_ExtractValue(material_text_used,int1,int2,int3,int4);
	fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	new text[MAX_TEXT_NAME], materialsize, fontface[MAX_FONT_NAME], fontsize, bold, fontcolor, backcolor, textalignment;
	for(new i = 0; i < 16; i++){
		if(SAOI_GetValueBit(material_text_used,i) == 1){
			GetDynamicObjectMaterialText(objectid,i,text,materialsize,fontface,fontsize,bold,fontcolor,backcolor,textalignment);
			
			new len = strlen(text);
			SAOI_ExtractValue(len,int1,int2,int3,int4);
			fputchar(outf,int3,false), fputchar(outf,int4,false);
			
			for(new k = 0, l = strlen(text); k < l; k++){
				fputchar(outf,SAOI_IntMod(text[k]),false);
			}
			
			fputchar(outf,materialsize,false);
			
			fputchar(outf,strlen(fontface),false);
			for(new k = 0, l = strlen(fontface); k < l; k++){
				fputchar(outf,SAOI_IntMod(fontface[k]),false);
			}
			
			fputchar(outf,fontsize,false);
			
			fputchar(outf,bold,false);
			
			SAOI_ExtractValue(fontcolor,int1,int2,int3,int4);
			fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			
			SAOI_ExtractValue(backcolor,int1,int2,int3,int4);
			fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			
			fputchar(outf,textalignment,false);
			
		}
	}
	
	fclose(outf);
	return SAOI_ERROR_SUCCESS;
}

SAOI_Function:: SAOI:SaveDynamicPickup(pickupid,const name[]){
	if(!IsValidDynamicPickup(pickupid)) return SAOI_ERROR_INVALID_OBJECTID;
	if(!fexist(name)) return SAOI_ERROR_OUTPUT_NOT_EXIST;
	if(strfind(name,".saoi",true) == -1) return SAOI_ERROR_OUTPUT_EXTENSION;
	new File:outf = fopen(name,io_append);
	if(!outf) return SAOI_ERROR_OUTPUT_NOT_OPEN;
	
	new modelid, Float:x, Float:y, Float:z, type, worldid, interiorid, Float:streamdistance, areaid, priority,
		arg_count = 11, element_flag;
	
	//Get Pickup Info
	modelid = Streamer_GetIntData(STREAMER_TYPE_PICKUP,pickupid,E_STREAMER_MODEL_ID);
	
	Streamer_GetFloatData(STREAMER_TYPE_PICKUP,pickupid,E_STREAMER_X,x);
	Streamer_GetFloatData(STREAMER_TYPE_PICKUP,pickupid,E_STREAMER_Y,y);
	Streamer_GetFloatData(STREAMER_TYPE_PICKUP,pickupid,E_STREAMER_Z,z);
	
	worldid = Streamer_GetIntData(STREAMER_TYPE_PICKUP,pickupid,E_STREAMER_WORLD_ID);
	interiorid = Streamer_GetIntData(STREAMER_TYPE_PICKUP,pickupid,E_STREAMER_INTERIOR_ID);
	
	Streamer_GetFloatData(STREAMER_TYPE_PICKUP,pickupid,E_STREAMER_STREAM_DISTANCE,streamdistance);
	type = Streamer_GetIntData(STREAMER_TYPE_PICKUP,pickupid,E_STREAMER_TYPE);
	
	areaid = Streamer_GetIntData(STREAMER_TYPE_PICKUP,pickupid,E_STREAMER_AREA_ID);
	priority = Streamer_GetIntData(STREAMER_TYPE_PICKUP,pickupid,E_STREAMER_PRIORITY);
	
	if(Streamer_IsToggleItemInvAreas(STREAMER_TYPE_PICKUP,pickupid)){
		SAOI_SetValueBit(element_flag,ELEMENT_FLAG_ANTI_AREA,1);
	}
	
	//Count Arg
	for(new i = arg_count; i > 5; i--){
		switch(i){
			case 11: {
				if(element_flag == 0){
					arg_count--;
				} else {
					break;
				}
			}
			case 10: {
				if(priority == 0){
					arg_count--;
				} else {
					break;
				}
			}
			case 9: {
				if(areaid == -1){
					arg_count--;
				} else {
					break;
				}
			}
			case 8: {
				if(streamdistance == STREAMER_OBJECT_SD){
					arg_count--;
				} else {
					break;
				}
			}
			case 7: {
				if(interiorid == -1){
					arg_count--;
				} else {
					break;
				}
			}
			case 6: {
				if(worldid == -1){
					arg_count--;
				} else {
					break;
				}
			}
		}
	}
	
	//RAW Generator
	new int1, int2, int3, int4;
	
	//Save Arg Count
	fputchar(outf,SAOI_BUMPER_PICKUP,false);
	fputchar(outf,arg_count,false);
	
	//Save Pickup Info
	SAOI_ExtractValue(modelid,int1,int2,int3,int4);
	fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	SAOI_ExtractValue(type,int1,int2,int3,int4);
	fputchar(outf,int4,false);
	
	SAOI_ExtractFloat(x,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	SAOI_ExtractFloat(y,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	SAOI_ExtractFloat(z,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	if(arg_count >= 6){
		SAOI_ExtractValue(worldid,int1,int2,int3,int4);
		fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	}
	if(arg_count >= 7){
		SAOI_ExtractValue(interiorid,int1,int2,int3,int4);
		fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	}
	if(arg_count >= 8){
		SAOI_ExtractFloat(streamdistance,int1,int2,int3,int4);
		fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	}
	if(arg_count >= 9){
		SAOI_ExtractValue(areaid,int1,int2,int3,int4);
		fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	}
	if(arg_count >= 10){
		SAOI_ExtractValue(priority,int1,int2,int3,int4);
		fputchar(outf,int4,false);
	}
	if(arg_count >= 11){
		SAOI_ExtractValue(element_flag,int1,int2,int3,int4);
		fputchar(outf,int4,false);
	}
	
	fclose(outf);
	return SAOI_ERROR_SUCCESS;
}

SAOI_Function:: SAOI:SaveDynamic3DTextLabel(Text3D:textid,const name[]){
	if(!IsValidDynamic3DTextLabel(textid)) return SAOI_ERROR_INVALID_OBJECTID;
	if(!fexist(name)) return SAOI_ERROR_OUTPUT_NOT_EXIST;
	if(strfind(name,".saoi",true) == -1) return SAOI_ERROR_OUTPUT_EXTENSION;
	new File:outf = fopen(name,io_append);
	if(!outf) return SAOI_ERROR_OUTPUT_NOT_OPEN;
	
	new Float:x, Float:y, Float:z, testlos, worldid, interiorid, Float:streamdistance, areaid, priority,
		arg_count = 14, element_flag, textsize, text[2048], color, Float:drawdistance;
	
	//Get 3DTextLabel Info
	GetDynamic3DTextLabelText(textid,text,sizeof(text));
	textsize = strlen(text);
	
	Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL,textid,E_STREAMER_X,x);
	Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL,textid,E_STREAMER_Y,y);
	Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL,textid,E_STREAMER_Z,z);
	
	worldid = Streamer_GetIntData(STREAMER_TYPE_3D_TEXT_LABEL,textid,E_STREAMER_WORLD_ID);
	interiorid = Streamer_GetIntData(STREAMER_TYPE_3D_TEXT_LABEL,textid,E_STREAMER_INTERIOR_ID);
	
	Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL,textid,E_STREAMER_STREAM_DISTANCE,streamdistance);
	Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL,textid,E_STREAMER_DRAW_DISTANCE,drawdistance);
	testlos = Streamer_GetIntData(STREAMER_TYPE_3D_TEXT_LABEL,textid,E_STREAMER_TEST_LOS);
	color = Streamer_GetIntData(STREAMER_TYPE_3D_TEXT_LABEL,textid,E_STREAMER_COLOR);
	
	areaid = Streamer_GetIntData(STREAMER_TYPE_3D_TEXT_LABEL,textid,E_STREAMER_AREA_ID);
	priority = Streamer_GetIntData(STREAMER_TYPE_3D_TEXT_LABEL,textid,E_STREAMER_PRIORITY);
	
	if(Streamer_IsToggleItemInvAreas(STREAMER_TYPE_3D_TEXT_LABEL,textid)){
		SAOI_SetValueBit(element_flag,ELEMENT_FLAG_ANTI_AREA,1);
	}
	
	//Count Arg
	for(new i = arg_count; i > 7; i--){
		switch(i){
			case 14: {
				if(element_flag == 0){
					arg_count--;
				} else {
					break;
				}
			}
			case 13: {
				if(priority == 0){
					arg_count--;
				} else {
					break;
				}
			}
			case 12: {
				if(areaid == -1){
					arg_count--;
				} else {
					break;
				}
			}
			case 11: {
				if(streamdistance == STREAMER_OBJECT_SD){
					arg_count--;
				} else {
					break;
				}
			}
			case 10: {
				if(interiorid == -1){
					arg_count--;
				} else {
					break;
				}
			}
			case 9: {
				if(worldid == -1){
					arg_count--;
				} else {
					break;
				}
			}
			case 8: {
				if(testlos == 0){
					arg_count--;
				} else {
					break;
				}
			}
		}
	}
	
	//RAW Generator
	new int1, int2, int3, int4;
	
	//Save Arg Count
	fputchar(outf,SAOI_BUMPER_3D_TEXT_LABEL,false);
	fputchar(outf,arg_count,false);
	
	//Save 3DTextLabel Info
	SAOI_ExtractValue(textsize,int1,int2,int3,int4);
	fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	for(new k = 0; k < textsize; k++){
		fputchar(outf,SAOI_IntMod(text[k]),false);
	}
	
	SAOI_ExtractValue(color,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	SAOI_ExtractFloat(x,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	SAOI_ExtractFloat(y,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	SAOI_ExtractFloat(z,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	SAOI_ExtractFloat(drawdistance,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);

	if(arg_count >= 8){
		SAOI_ExtractValue(testlos,int1,int2,int3,int4);
		fputchar(outf,int4,false);
	}
	if(arg_count >= 9){
		SAOI_ExtractValue(worldid,int1,int2,int3,int4);
		fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	}
	if(arg_count >= 10){
		SAOI_ExtractValue(interiorid,int1,int2,int3,int4);
		fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	}
	if(arg_count >= 11){
		SAOI_ExtractFloat(streamdistance,int1,int2,int3,int4);
		fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	}
	if(arg_count >= 12){
		SAOI_ExtractValue(areaid,int1,int2,int3,int4);
		fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	}
	if(arg_count >= 13){
		SAOI_ExtractValue(priority,int1,int2,int3,int4);
		fputchar(outf,int4,false);
	}
	if(arg_count >= 14){
		SAOI_ExtractValue(element_flag,int1,int2,int3,int4);
		fputchar(outf,int4,false);
	}
	
	fclose(outf);
	return SAOI_ERROR_SUCCESS;
}

SAOI_Function:: SAOI:SaveDynamicMapIcon(iconid,const name[]){
	if(!IsValidDynamicMapIcon(iconid)) return SAOI_ERROR_INVALID_OBJECTID;
	if(!fexist(name)) return SAOI_ERROR_OUTPUT_NOT_EXIST;
	if(strfind(name,".saoi",true) == -1) return SAOI_ERROR_OUTPUT_EXTENSION;
	new File:outf = fopen(name,io_append);
	if(!outf) return SAOI_ERROR_OUTPUT_NOT_OPEN;
	
	new Float:x, Float:y, Float:z, type, worldid, interiorid, Float:streamdistance, areaid, priority,
		arg_count = 12, element_flag, color, style;
	
	//Get MapIcon Info
	Streamer_GetFloatData(STREAMER_TYPE_MAP_ICON,iconid,E_STREAMER_X,x);
	Streamer_GetFloatData(STREAMER_TYPE_MAP_ICON,iconid,E_STREAMER_Y,y);
	Streamer_GetFloatData(STREAMER_TYPE_MAP_ICON,iconid,E_STREAMER_Z,z);
	
	worldid = Streamer_GetIntData(STREAMER_TYPE_MAP_ICON,iconid,E_STREAMER_WORLD_ID);
	interiorid = Streamer_GetIntData(STREAMER_TYPE_MAP_ICON,iconid,E_STREAMER_INTERIOR_ID);
	
	Streamer_GetFloatData(STREAMER_TYPE_MAP_ICON,iconid,E_STREAMER_STREAM_DISTANCE,streamdistance);
	type = Streamer_GetIntData(STREAMER_TYPE_MAP_ICON,iconid,E_STREAMER_TYPE);
	color = Streamer_GetIntData(STREAMER_TYPE_MAP_ICON,iconid,E_STREAMER_COLOR);
	style = Streamer_GetIntData(STREAMER_TYPE_MAP_ICON,iconid,E_STREAMER_STYLE);
	
	areaid = Streamer_GetIntData(STREAMER_TYPE_MAP_ICON,iconid,E_STREAMER_AREA_ID);
	priority = Streamer_GetIntData(STREAMER_TYPE_MAP_ICON,iconid,E_STREAMER_PRIORITY);
	
	if(Streamer_IsToggleItemInvAreas(STREAMER_TYPE_MAP_ICON,iconid)){
		SAOI_SetValueBit(element_flag,ELEMENT_FLAG_ANTI_AREA,1);
	}
	
	//Count Arg
	for(new i = arg_count; i > 5; i--){
		switch(i){
			case 12: {
				if(element_flag == 0){
					arg_count--;
				} else {
					break;
				}
			}
			case 11: {
				if(priority == 0){
					arg_count--;
				} else {
					break;
				}
			}
			case 10: {
				if(areaid == -1){
					arg_count--;
				} else {
					break;
				}
			}
			case 9: {
				if(style == MAPICON_LOCAL){
					arg_count--;
				} else {
					break;
				}
			}
			case 8: {
				if(streamdistance == STREAMER_OBJECT_SD){
					arg_count--;
				} else {
					break;
				}
			}
			case 7: {
				if(interiorid == -1){
					arg_count--;
				} else {
					break;
				}
			}
			case 6: {
				if(worldid == -1){
					arg_count--;
				} else {
					break;
				}
			}
		}
	}
	
	//RAW Generator
	new int1, int2, int3, int4;
	
	//Save Arg Count
	fputchar(outf,SAOI_BUMPER_MAPICON,false);
	fputchar(outf,arg_count,false);
	
	//Save MapIcon Info
	SAOI_ExtractFloat(x,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	SAOI_ExtractFloat(y,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	SAOI_ExtractFloat(z,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	SAOI_ExtractValue(type,int1,int2,int3,int4);
	fputchar(outf,int4,false);
	
	SAOI_ExtractValue(color,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	if(arg_count >= 6){
		SAOI_ExtractValue(worldid,int1,int2,int3,int4);
		fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	}
	if(arg_count >= 7){
		SAOI_ExtractValue(interiorid,int1,int2,int3,int4);
		fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	}
	if(arg_count >= 8){
		SAOI_ExtractFloat(streamdistance,int1,int2,int3,int4);
		fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	}
	if(arg_count >= 9){
		SAOI_ExtractValue(style,int1,int2,int3,int4);
		fputchar(outf,int4,false);
	}
	if(arg_count >= 10){
		SAOI_ExtractValue(areaid,int1,int2,int3,int4);
		fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	}
	if(arg_count >= 11){
		SAOI_ExtractValue(priority,int1,int2,int3,int4);
		fputchar(outf,int4,false);
	}
	if(arg_count >= 12){
		SAOI_ExtractValue(element_flag,int1,int2,int3,int4);
		fputchar(outf,int4,false);
	}
	
	fclose(outf);
	return SAOI_ERROR_SUCCESS;
}

SAOI_Function:: SAOI:SaveDynamicActor(actorid,const name[]){
	if(!IsValidDynamicActor(actorid)) return SAOI_ERROR_INVALID_OBJECTID;
	if(!fexist(name)) return SAOI_ERROR_OUTPUT_NOT_EXIST;
	if(strfind(name,".saoi",true) == -1) return SAOI_ERROR_OUTPUT_EXTENSION;
	new File:outf = fopen(name,io_append);
	if(!outf) return SAOI_ERROR_OUTPUT_NOT_OPEN;
	
	new Float:x, Float:y, Float:z, Float:z_angle, modelid, worldid, interiorid, Float:streamdistance, areaid, priority,
		arg_count = 13, element_flag, invulnerable = 0, Float:health;
	
	//Get Actor Info
	GetDynamicActorPos(actorid,x,y,z);
	GetDynamicActorFacingAngle(actorid,z_angle);
	
	modelid = Streamer_GetIntData(STREAMER_TYPE_ACTOR,actorid,E_STREAMER_MODEL_ID);
	worldid = GetDynamicActorVirtualWorld(actorid);
	interiorid = Streamer_GetIntData(STREAMER_TYPE_ACTOR,actorid,E_STREAMER_INTERIOR_ID);
	
	if(IsDynamicActorInvulnerable(actorid)) invulnerable = 1;
	
	Streamer_GetFloatData(STREAMER_TYPE_ACTOR,actorid,E_STREAMER_STREAM_DISTANCE,streamdistance);
	GetDynamicActorHealth(actorid,health);
	
	areaid = Streamer_GetIntData(STREAMER_TYPE_ACTOR,actorid,E_STREAMER_AREA_ID);
	priority = Streamer_GetIntData(STREAMER_TYPE_ACTOR,actorid,E_STREAMER_PRIORITY);
	
	if(Streamer_IsToggleItemInvAreas(STREAMER_TYPE_ACTOR,actorid)){
		SAOI_SetValueBit(element_flag,ELEMENT_FLAG_ANTI_AREA,1);
	}
	
	//Count Arg
	for(new i = arg_count; i > 5; i--){
		switch(i){
			case 13: {
				if(element_flag == 0){
					arg_count--;
				} else {
					break;
				}
			}
			case 12: {
				if(priority == 0){
					arg_count--;
				} else {
					break;
				}
			}
			case 11: {
				if(areaid == -1){
					arg_count--;
				} else {
					break;
				}
			}
			case 10: {
				if(streamdistance == STREAMER_OBJECT_SD){
					arg_count--;
				} else {
					break;
				}
			}
			case 9: {
				if(interiorid == -1){
					arg_count--;
				} else {
					break;
				}
			}
			case 8: {
				if(worldid == -1){
					arg_count--;
				} else {
					break;
				}
			}
			case 7: {
				if(health == 100.0){
					arg_count--;
				} else {
					break;
				}
			}
			case 6: {
				if(invulnerable == 1){
					arg_count--;
				} else {
					break;
				}
			}
		}
	}
	
	//RAW Generator
	new int1, int2, int3, int4;
	
	//Save Arg Count
	fputchar(outf,SAOI_BUMPER_ACTOR,false);
	fputchar(outf,arg_count,false);
	
	//Save Actor Info
	SAOI_ExtractValue(modelid,int1,int2,int3,int4);
	fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	SAOI_ExtractFloat(x,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	SAOI_ExtractFloat(y,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	SAOI_ExtractFloat(z,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	SAOI_ExtractFloat(z_angle,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	if(arg_count >= 6){
		SAOI_ExtractValue(invulnerable,int1,int2,int3,int4);
		fputchar(outf,int4,false);
	}
	if(arg_count >= 7){
		SAOI_ExtractFloat(health,int1,int2,int3,int4);
		fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	}
	if(arg_count >= 8){
		SAOI_ExtractValue(worldid,int1,int2,int3,int4);
		fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	}
	if(arg_count >= 9){
		SAOI_ExtractValue(interiorid,int1,int2,int3,int4);
		fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	}
	if(arg_count >= 10){
		SAOI_ExtractFloat(streamdistance,int1,int2,int3,int4);
		fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	}
	if(arg_count >= 11){
		SAOI_ExtractValue(areaid,int1,int2,int3,int4);
		fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	}
	if(arg_count >= 12){
		SAOI_ExtractValue(priority,int1,int2,int3,int4);
		fputchar(outf,int4,false);
	}
	if(arg_count >= 13){
		SAOI_ExtractValue(element_flag,int1,int2,int3,int4);
		fputchar(outf,int4,false);
	}
	
	fclose(outf);
	return SAOI_ERROR_SUCCESS;
}

SAOI_Function:: SAOI:SaveDynamicArea(areaid,const name[]){
	if(!IsValidDynamicArea(areaid)) return SAOI_ERROR_INVALID_OBJECTID;
	if(!fexist(name)) return SAOI_ERROR_OUTPUT_NOT_EXIST;
	if(strfind(name,".saoi",true) == -1) return SAOI_ERROR_OUTPUT_EXTENSION;
	new File:outf = fopen(name,io_append);
	if(!outf) return SAOI_ERROR_OUTPUT_NOT_OPEN;
	
	//RAW Generator
	new int1, int2, int3, int4;
	
	switch(Streamer_GetIntData(STREAMER_TYPE_AREA,areaid,E_STREAMER_TYPE)){
		case STREAMER_AREA_TYPE_CIRCLE: {
			//Get Area Data
			new arg_count = 6, Float:x, Float:y, Float:size, worldid = -1, interiorid = -1;
			
			Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_X,x);
			Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_Y,y);
			Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_SIZE,size);
	
			worldid = Streamer_GetIntData(STREAMER_TYPE_AREA,areaid,E_STREAMER_WORLD_ID);
			interiorid = Streamer_GetIntData(STREAMER_TYPE_AREA,areaid,E_STREAMER_INTERIOR_ID);
			
			//Count Arg
			for(new i = arg_count; i > 4; i--){
				switch(i){
					case 6: {
						if(interiorid == -1){
							arg_count--;
						} else {
							break;
						}
					}
					case 5: {
						if(worldid == -1){
							arg_count--;
						} else {
							break;
						}
					}
				}
			}
			
			//Save Arg Count
			fputchar(outf,SAOI_BUMPER_AREA_CIRCLE,false);
			fputchar(outf,arg_count,false);
			
			//Save Area Info
			SAOI_ExtractValue(areaid,int1,int2,int3,int4);
			fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			
			SAOI_ExtractFloat(x,int1,int2,int3,int4);
			fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			
			SAOI_ExtractFloat(y,int1,int2,int3,int4);
			fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			
			SAOI_ExtractFloat(size,int1,int2,int3,int4);
			fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			
			if(arg_count >= 5){
				SAOI_ExtractValue(worldid,int1,int2,int3,int4);
				fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			}
			if(arg_count >= 6){
				SAOI_ExtractValue(interiorid,int1,int2,int3,int4);
				fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			}
		}
		case STREAMER_AREA_TYPE_CYLINDER: {
			//Get Area Data
			new arg_count = 8, Float:x, Float:y, Float:minz, Float:maxz, Float:size, worldid = -1, interiorid = -1;
			
			Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_X,x);
			Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_Y,y);
			
			Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_MIN_Z,minz);
			Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_MAX_Z,maxz);
			
			Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_SIZE,size);
	
			worldid = Streamer_GetIntData(STREAMER_TYPE_AREA,areaid,E_STREAMER_WORLD_ID);
			interiorid = Streamer_GetIntData(STREAMER_TYPE_AREA,areaid,E_STREAMER_INTERIOR_ID);
			
			//Count Arg
			for(new i = arg_count; i > 6; i--){
				switch(i){
					case 8: {
						if(interiorid == -1){
							arg_count--;
						} else {
							break;
						}
					}
					case 7: {
						if(worldid == -1){
							arg_count--;
						} else {
							break;
						}
					}
				}
			}
			
			//Save Arg Count
			fputchar(outf,SAOI_BUMPER_AREA_CYLINDER,false);
			fputchar(outf,arg_count,false);
			
			//Save Area Info
			SAOI_ExtractValue(areaid,int1,int2,int3,int4);
			fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			
			SAOI_ExtractFloat(x,int1,int2,int3,int4);
			fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			
			SAOI_ExtractFloat(y,int1,int2,int3,int4);
			fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			
			SAOI_ExtractFloat(minz,int1,int2,int3,int4);
			fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			
			SAOI_ExtractFloat(maxz,int1,int2,int3,int4);
			fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			
			SAOI_ExtractFloat(size,int1,int2,int3,int4);
			fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			
			if(arg_count >= 7){
				SAOI_ExtractValue(worldid,int1,int2,int3,int4);
				fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			}
			if(arg_count >= 8){
				SAOI_ExtractValue(interiorid,int1,int2,int3,int4);
				fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			}
		}
		case STREAMER_AREA_TYPE_SPHERE: {
			//Get Area Data
			new arg_count = 7, Float:x, Float:y, Float:z, Float:size, worldid = -1, interiorid = -1;
			
			Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_X,x);
			Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_Y,y);
			Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_Z,z);
			Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_SIZE,size);
	
			worldid = Streamer_GetIntData(STREAMER_TYPE_AREA,areaid,E_STREAMER_WORLD_ID);
			interiorid = Streamer_GetIntData(STREAMER_TYPE_AREA,areaid,E_STREAMER_INTERIOR_ID);
			
			//Count Arg
			for(new i = arg_count; i > 5; i--){
				switch(i){
					case 7: {
						if(interiorid == -1){
							arg_count--;
						} else {
							break;
						}
					}
					case 6: {
						if(worldid == -1){
							arg_count--;
						} else {
							break;
						}
					}
				}
			}
			
			//Save Arg Count
			fputchar(outf,SAOI_BUMPER_AREA_SPHERE,false);
			fputchar(outf,arg_count,false);
			
			//Save Area Info
			SAOI_ExtractValue(areaid,int1,int2,int3,int4);
			fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			
			SAOI_ExtractFloat(x,int1,int2,int3,int4);
			fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			
			SAOI_ExtractFloat(y,int1,int2,int3,int4);
			fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			
			SAOI_ExtractFloat(z,int1,int2,int3,int4);
			fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			
			SAOI_ExtractFloat(size,int1,int2,int3,int4);
			fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			
			if(arg_count >= 6){
				SAOI_ExtractValue(worldid,int1,int2,int3,int4);
				fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			}
			if(arg_count >= 7){
				SAOI_ExtractValue(interiorid,int1,int2,int3,int4);
				fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			}
		}
		case STREAMER_AREA_TYPE_RECTANGLE: {
			//Get Area Data
			new arg_count = 7, Float:minx, Float:miny, Float:maxx, Float:maxy, worldid = -1, interiorid = -1;
			
			Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_MIN_X,minx);
			Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_MIN_Y,miny);
			Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_MAX_X,maxx);
			Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_MAX_Y,maxy);
	
			worldid = Streamer_GetIntData(STREAMER_TYPE_AREA,areaid,E_STREAMER_WORLD_ID);
			interiorid = Streamer_GetIntData(STREAMER_TYPE_AREA,areaid,E_STREAMER_INTERIOR_ID);
			
			//Count Arg
			for(new i = arg_count; i > 5; i--){
				switch(i){
					case 7: {
						if(interiorid == -1){
							arg_count--;
						} else {
							break;
						}
					}
					case 6: {
						if(worldid == -1){
							arg_count--;
						} else {
							break;
						}
					}
				}
			}
			
			//Save Arg Count
			fputchar(outf,SAOI_BUMPER_AREA_RECTANGLE,false);
			fputchar(outf,arg_count,false);
			
			//Save Area Info
			SAOI_ExtractValue(areaid,int1,int2,int3,int4);
			fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			
			SAOI_ExtractFloat(minx,int1,int2,int3,int4);
			fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			
			SAOI_ExtractFloat(miny,int1,int2,int3,int4);
			fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			
			SAOI_ExtractFloat(maxx,int1,int2,int3,int4);
			fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			
			SAOI_ExtractFloat(maxy,int1,int2,int3,int4);
			fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			
			if(arg_count >= 6){
				SAOI_ExtractValue(worldid,int1,int2,int3,int4);
				fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			}
			if(arg_count >= 7){
				SAOI_ExtractValue(interiorid,int1,int2,int3,int4);
				fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			}
		}
		case STREAMER_AREA_TYPE_CUBOID: {
			//Get Area Data
			new arg_count = 9, Float:minx, Float:miny, Float:minz, Float:maxx, Float:maxy, Float:maxz, worldid = -1, interiorid = -1;
			
			Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_MIN_X,minx);
			Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_MIN_Y,miny);
			Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_MIN_Z,minz);
			Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_MAX_X,maxx);
			Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_MAX_Y,maxy);
			Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_MAX_Z,maxz);
	
			worldid = Streamer_GetIntData(STREAMER_TYPE_AREA,areaid,E_STREAMER_WORLD_ID);
			interiorid = Streamer_GetIntData(STREAMER_TYPE_AREA,areaid,E_STREAMER_INTERIOR_ID);
			
			//Count Arg
			for(new i = arg_count; i > 7; i--){
				switch(i){
					case 9: {
						if(interiorid == -1){
							arg_count--;
						} else {
							break;
						}
					}
					case 8: {
						if(worldid == -1){
							arg_count--;
						} else {
							break;
						}
					}
				}
			}
			
			//Save Arg Count
			fputchar(outf,SAOI_BUMPER_AREA_CUBOID,false);
			fputchar(outf,arg_count,false);
			
			//Save Area Info
			SAOI_ExtractValue(areaid,int1,int2,int3,int4);
			fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			
			SAOI_ExtractFloat(minx,int1,int2,int3,int4);
			fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			
			SAOI_ExtractFloat(miny,int1,int2,int3,int4);
			fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			
			SAOI_ExtractFloat(minz,int1,int2,int3,int4);
			fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			
			SAOI_ExtractFloat(maxx,int1,int2,int3,int4);
			fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			
			SAOI_ExtractFloat(maxy,int1,int2,int3,int4);
			fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			
			SAOI_ExtractFloat(maxz,int1,int2,int3,int4);
			fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			
			if(arg_count >= 8){
				SAOI_ExtractValue(worldid,int1,int2,int3,int4);
				fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			}
			if(arg_count >= 9){
				SAOI_ExtractValue(interiorid,int1,int2,int3,int4);
				fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			}
		}
		case STREAMER_AREA_TYPE_POLYGON: {
			//Get Area Data
			new arg_count = 7, Float:minz = -FLOAT_INFINITY, Float:maxz = FLOAT_INFINITY, worldid = -1, interiorid = -1, Float:Polygon_Points[MAX_POLYGON_POINTS*2], max_points;
			
			GetDynamicPolygonPoints(areaid,Polygon_Points,sizeof(Polygon_Points));
			max_points = GetDynamicPolygonNumberPoints(areaid) * 2;
			
			Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_MIN_Z,minz);
			Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_MAX_Z,maxz);
			
			worldid = Streamer_GetIntData(STREAMER_TYPE_AREA,areaid,E_STREAMER_WORLD_ID);
			interiorid = Streamer_GetIntData(STREAMER_TYPE_AREA,areaid,E_STREAMER_INTERIOR_ID);
			
			//Count Arg
			for(new i = arg_count; i > 3; i--){
				switch(i){
					case 7: {
						if(interiorid == -1){
							arg_count--;
						} else {
							break;
						}
					}
					case 6: {
						if(worldid == -1){
							arg_count--;
						} else {
							break;
						}
					}
					case 5: {
						if(maxz == FLOAT_INFINITY){
							arg_count--;
						} else {
							break;
						}
					}
					case 4: {
						if(minz == -FLOAT_INFINITY){
							arg_count--;
						} else {
							break;
						}
					}
				}
			}
			
			//Save Arg Count
			fputchar(outf,SAOI_BUMPER_AREA_POLYGON,false);
			fputchar(outf,arg_count,false);
			
			//Save Area Info
			SAOI_ExtractValue(areaid,int1,int2,int3,int4);
			fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			
			SAOI_ExtractValue(max_points,int1,int2,int3,int4);
			fputchar(outf,int3,false), fputchar(outf,int4,false);
			
			for(new k = 0; k < max_points; k++){
				SAOI_ExtractFloat(Polygon_Points[k],int1,int2,int3,int4);
				fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			}
			
			if(arg_count >= 4){
				SAOI_ExtractFloat(minz,int1,int2,int3,int4);
				fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			}
			
			if(arg_count >= 5){
				SAOI_ExtractFloat(maxz,int1,int2,int3,int4);
				fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			}
			
			if(arg_count >= 6){
				SAOI_ExtractValue(worldid,int1,int2,int3,int4);
				fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			}
			if(arg_count >= 7){
				SAOI_ExtractValue(interiorid,int1,int2,int3,int4);
				fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
			}
		}
	}
	
	fclose(outf);
	return SAOI_ERROR_SUCCESS;
}

SAOI_Function:: SAOI:SAOI_SaveVehicle(const name[],vehicletype,Float:x,Float:y,Float:z,Float:rotation,color1,color2,respawn_delay,addsiren=0,worldid=0,interiorid=0){
	if(!fexist(name)) return SAOI_ERROR_OUTPUT_NOT_EXIST;
	if(strfind(name,".saoi",true) == -1) return SAOI_ERROR_OUTPUT_EXTENSION;
	new File:outf = fopen(name,io_append);
	if(!outf) return SAOI_ERROR_OUTPUT_NOT_OPEN;
	
	if(color1 == -1) color1 = 0xFFFF;
	if(color2 == -1) color2 = 0xFFFF;
	
	//RAW Generator
	new int1, int2, int3, int4;
	
	//Save Arg Count
	fputchar(outf,SAOI_BUMPER_VEHICLE,false);

	//Save Vehicle Info
	SAOI_ExtractValue(vehicletype,int1,int2,int3,int4);
	fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	SAOI_ExtractFloat(x,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	SAOI_ExtractFloat(y,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	SAOI_ExtractFloat(z,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	SAOI_ExtractFloat(rotation,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	SAOI_ExtractValue(color1,int1,int2,int3,int4);
	fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	SAOI_ExtractValue(color2,int1,int2,int3,int4);
	fputchar(outf,int3,false), fputchar(outf,int4,false);

	SAOI_ExtractValue(respawn_delay,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);	
	
	SAOI_ExtractValue(addsiren,int1,int2,int3,int4);
	fputchar(outf,int4,false);

	SAOI_ExtractValue(worldid,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);

	SAOI_ExtractValue(interiorid,int1,int2,int3,int4);
	fputchar(outf,int1,false), fputchar(outf,int2,false), fputchar(outf,int3,false), fputchar(outf,int4,false);
	
	fclose(outf);
	return SAOI_ERROR_SUCCESS;
}

SAOI_Function:: SAOI:SetSAOIBumperIP(const name[],server_ip[]){
	if(!fexist(name)) return SAOI_ERROR_OUTPUT_NOT_EXIST;
	if(strfind(name,".saoi",true) == -1) return SAOI_ERROR_OUTPUT_EXTENSION;
	new File:outf = fopen(name,io_append);
	if(!outf) return SAOI_ERROR_OUTPUT_NOT_OPEN;
	
	new serv_ipsum[4], saoi_ipsum[4];
	sscanf(server_ip,"p<.>dddd",serv_ipsum[0],serv_ipsum[1],serv_ipsum[2],serv_ipsum[3]);
	
	saoi_ipsum[0] = SAOI_IntMod(serv_ipsum[3]);
	saoi_ipsum[1] = SAOI_IntMod(serv_ipsum[2]);
	saoi_ipsum[2] = SAOI_IntMod(serv_ipsum[1]);
	saoi_ipsum[3] = SAOI_IntMod(serv_ipsum[0]);
	
	fputchar(outf,SAOI_BUMPER_IP,false);
	for(new i = 0; i < 4; i++){
		fputchar(outf,saoi_ipsum[i],false);
	}

	fclose(outf);
	return SAOI_ERROR_SUCCESS;
}

SAOI_Function:: SAOI:SetSAOIBumperPort(const name[],server_port){
	if(!fexist(name)) return SAOI_ERROR_OUTPUT_NOT_EXIST;
	if(strfind(name,".saoi",true) == -1) return SAOI_ERROR_OUTPUT_EXTENSION;
	new File:outf = fopen(name,io_append);
	if(!outf) return SAOI_ERROR_OUTPUT_NOT_OPEN;
	
	new serv_portsum[4], saoi_portsum[4];
	SAOI_ExtractValue(server_port,serv_portsum[0],serv_portsum[1],serv_portsum[2],serv_portsum[3]);
	
	saoi_portsum[0] = SAOI_IntMod(serv_portsum[3]);
	saoi_portsum[1] = SAOI_IntMod(serv_portsum[2]);
	saoi_portsum[2] = SAOI_IntMod(serv_portsum[1]);
	saoi_portsum[3] = SAOI_IntMod(serv_portsum[0]);
	
	fputchar(outf,SAOI_BUMPER_PORT,false);
	for(new i = 0; i < 4; i++){
		fputchar(outf,saoi_portsum[i],false);
	}

	fclose(outf);
	return SAOI_ERROR_SUCCESS;
}

SAOI_Function:: SAOI:GetSAOIFileHeader(const name[],author[],version[],description[]){
	if(!fexist(name)) return SAOI_ERROR_INPUT_NOT_EXIST;
	if(strfind(name,".saoi",true) == -1) return SAOI_ERROR_INPUT_EXTENSION;
	new File:inpf = fopen(name,io_read);
	if(!inpf) return SAOI_ERROR_INPUT_NOT_OPEN;
	new asize = flength(inpf);
	if(asize > MAX_SAOI_FILE_SIZE || asize < 0){
		fclose(inpf);
		return SAOI_ERROR_FILE_SIZE;
	}
	new h_len = strlen(SAOI_HEADER_KEY), h_key[32];
	for(new i = 0; i < h_len; i++){
		h_key[i] = fgetchar(inpf,0,false);
	}
	h_key[h_len] = EOS;

	if(!strcmp(h_key,SAOI_HEADER_KEY,true)){
		new author_size, version_size, description_size, key[32];
		
		author_size = fgetchar(inpf,0,false);
		for(new i = 0; i < author_size; i++){
			author[i] = fgetchar(inpf,0,false);
		}
		
		version_size = fgetchar(inpf,0,false);
		for(new i = 0; i < version_size; i++){
			version[i] = fgetchar(inpf,0,false);
		}
		
		description_size = fgetchar(inpf,0,false);
		for(new i = 0; i < description_size; i++){
			description[i] = fgetchar(inpf,0,false);
		}
		
		for(new i = 0; i < 32; i++){
			key[i] = fgetchar(inpf,0,false);
		}
		
		new step;
		
		step = 0;
		for(new i = 0; i < author_size; i++){
			author[i] = ((author[i]+key[step]) & 0xFF);
			step++;
			if(step >= 32) step = 0;
		}
		
		step = 0;
		for(new i = 0; i < version_size; i++){
			version[i] = ((version[i]+key[step]) & 0xFF);
			step++;
			if(step >= 32) step = 0;
		}
		
		step = 0;
		for(new i = 0; i < description_size; i++){
			description[i] = ((description[i]+key[step]) & 0xFF);
			step++;
			if(step >= 32) step = 0;
		}
		
	} else {
		fclose(inpf);
		return SAOI_ERROR_INVALID_HEADER;
	}
	
	fclose(inpf);
	return SAOI_ERROR_SUCCESS;
}

SAOI_Function:: SAOI:SAOIHeaderCopy(const input[],const output[]){
	if(!fexist(input)) return SAOI_ERROR_INPUT_NOT_EXIST;
	if(fexist(output)) return SAOI_ERROR_OUTPUT_EXIST;
	new File:inpf = fopen(input,io_read);
	if(!inpf) return SAOI_ERROR_INPUT_NOT_OPEN;
	new File:outf = fopen(output,io_append);
	if(!outf){
		fclose(inpf);
		return SAOI_ERROR_OUTPUT_NOT_OPEN;
	}
	new h_len = strlen(SAOI_HEADER_KEY), h_key[32];
	for(new i = 0; i < h_len; i++){
		h_key[i] = fgetchar(inpf,0,false);
	}
	h_key[h_len] = EOS;
	if(!strcmp(h_key,SAOI_HEADER_KEY,true)){
		new key[32],
			author[MAX_SAOI_AUTHOR_SIZE],
			version[MAX_SAOI_VERSION_SIZE],
			description[MAX_SAOI_DESCRIPTION_SIZE],
			author_size,
			version_size,
			description_size;
		
		//load
		author_size = fgetchar(inpf,0,false);
		for(new i = 0; i < author_size; i++){
			author[i] = fgetchar(inpf,0,false);
		}
		
		version_size = fgetchar(inpf,0,false);
		for(new i = 0; i < version_size; i++){
			version[i] = fgetchar(inpf,0,false);
		}
		
		description_size = fgetchar(inpf,0,false);
		for(new i = 0; i < description_size; i++){
			description[i] = fgetchar(inpf,0,false);
		}
		
		for(new i = 0; i < 32; i++){
			key[i] = fgetchar(inpf,0,false);
		}
		
		
		//save
		fwrite(outf,SAOI_HEADER_KEY);
		
		fputchar(outf,author_size,false);
		for(new i = 0; i < author_size; i++){
			fputchar(outf,author[i],false);
		}
		
		fputchar(outf,version_size,false);
		for(new i = 0; i < version_size; i++){
			fputchar(outf,version[i],false);
		}
		
		fputchar(outf,description_size,false);
		for(new i = 0; i < description_size; i++){
			fputchar(outf,description[i],false);
		}
		
		for(new i = 0; i < 32; i++){
			fputchar(outf,key[i],false);
		}
		
	} else {
		fclose(inpf);
		fclose(outf);
		fremove(output);
		return SAOI_ERROR_INVALID_HEADER;
	}
	fclose(inpf);
	fclose(outf);
	return SAOI_ERROR_SUCCESS;
	
}

SAOI_Function:: SAOI_CleanupElements(SAOI:index){
	if(!SAOI_IsLoaded(index)) return false;
	
	new extraid = (SAOI_EXTRA_ID_OFFSET+SAOIToInt(index));
	
	//Remove Buildings
	SAOI_DropRemoveBuildings(index);
	
	//Objects
	if(SAOIFile[index][SAOIV:cnt_object] > 0){
		new max_idx = SAOIFile[index][SAOIV:cnt_object], i = SAOIFile[index][SAOIV:offset_object], j = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT);
		while(i <= j && max_idx > 0){
			if(IsValidDynamicObject(i)){
				if(Streamer_GetIntData(STREAMER_TYPE_OBJECT,i,E_STREAMER_EXTRA_ID) == extraid){
					max_idx--;
					DestroyDynamicObject(i);
				}
			}
			i++;
		}
	}

	//CA_CreateObject
	#if defined SAOI_ColAndreas
		if(SAOIFile[index][SAOIV:cnt_caobject] > 0){
			new max_idx = SAOIFile[index][SAOIV:cnt_caobject], i = SAOIFile[index][SAOIV:offset_caobject];
			while(i < MAX_CA_OBJECTS && max_idx > 0){
				if(CA_GetObjectExtraID(i,CA_EXTRA_1) == extraid){
					max_idx--;
					CA_DestroyObject_DC(i);
				}
				i++;
			}
		}
	#endif
	
	//3DTextLabels
	if(SAOIFile[index][SAOIV:cnt_3dtext] > 0){
		new max_idx = SAOIFile[index][SAOIV:cnt_3dtext], i = SAOIFile[index][SAOIV:offset_3dtext], j = Streamer_GetUpperBound(STREAMER_TYPE_3D_TEXT_LABEL);
		while(i <= j && max_idx > 0){
			if(IsValidDynamic3DTextLabel(Text3D:i)){
				if(Streamer_GetIntData(STREAMER_TYPE_3D_TEXT_LABEL,i,E_STREAMER_EXTRA_ID) == extraid){
					max_idx--;
					DestroyDynamic3DTextLabel(Text3D:i);
				}
			}
			i++;
		}
	}
	
	//Pickups
	if(SAOIFile[index][SAOIV:cnt_pickup] > 0){
		new max_idx = SAOIFile[index][SAOIV:cnt_pickup], i = SAOIFile[index][SAOIV:offset_pickup], j = Streamer_GetUpperBound(STREAMER_TYPE_PICKUP);
		while(i <= j && max_idx > 0){
			if(IsValidDynamicPickup(i)){
				if(Streamer_GetIntData(STREAMER_TYPE_PICKUP,i,E_STREAMER_EXTRA_ID) == extraid){
					max_idx--;
					DestroyDynamicPickup(i);
				}
			}
			i++;
		}
	}
	
	//MapIcons
	if(SAOIFile[index][SAOIV:cnt_mapicon] > 0){
		new max_idx = SAOIFile[index][SAOIV:cnt_mapicon], i = SAOIFile[index][SAOIV:offset_mapicon], j = Streamer_GetUpperBound(STREAMER_TYPE_MAP_ICON);
		while(i <= j && max_idx > 0){
			if(IsValidDynamicMapIcon(i)){
				if(Streamer_GetIntData(STREAMER_TYPE_MAP_ICON,i,E_STREAMER_EXTRA_ID) == extraid){
					max_idx--;
					DestroyDynamicMapIcon(i);
				}
			}
			i++;
		}
	}
	
	//Actors
	if(SAOIFile[index][SAOIV:cnt_actor] > 0){
		new max_idx = SAOIFile[index][SAOIV:cnt_actor], i = SAOIFile[index][SAOIV:offset_actor], j = Streamer_GetUpperBound(STREAMER_TYPE_ACTOR);
		while(i <= j && max_idx > 0){
			if(IsValidDynamicActor(i)){
				if(Streamer_GetIntData(STREAMER_TYPE_ACTOR,i,E_STREAMER_EXTRA_ID) == extraid){
					max_idx--;
					DestroyDynamicActor(i);
				}
			}
			i++;
		}
	}
	
	//Areas
	if(SAOIFile[index][SAOIV:cnt_area] > 0){
		new max_idx = SAOIFile[index][SAOIV:cnt_area], i = SAOIFile[index][SAOIV:offset_area], j = Streamer_GetUpperBound(STREAMER_TYPE_AREA);
		while(i <= j && max_idx > 0){
			if(IsValidDynamicArea(i)){
				if(Streamer_GetIntData(STREAMER_TYPE_AREA,i,E_STREAMER_EXTRA_ID) == extraid){
					max_idx--;
					DestroyDynamicArea(i);
				}
			}
			i++;
		}
	}
	
	//Vehicles
	new prot_i = 0;
	if(SAOIFile[index][SAOIV:cnt_vehicle] > 0){
		new max_idx = SAOIFile[index][SAOIV:cnt_vehicle], i = SAOIFile[index][SAOIV:offset_vehicle], j = GetVehiclePoolSize();
		while(i <= j && max_idx > 0){
			prot_i = i;
			if(IsValidVehicle(i)){
				if(SAOI_Vehicles[i] == index){
					max_idx--;
					DestroyVehicle(prot_i);
					CallRemoteFunction("SAOI_OnVehicleDestroyed","d",i);
					SAOI_Vehicles[i] = INVALID_SAOI_FILE;
				}
			}
			i++;
		}
	}
	
	return true;
}

SAOI_Function:: SAOI:LoadObjectImage(const name[],bool:save_logs=true,bool:fast_boot=false){
	if(!CRC_SAOIAccess) return SAOI_ERROR_MEMORY_BLOCKED;
	new SAOI:index = SAOI_GetFreeID();
	if(index == INVALID_SAOI_FILE) return SAOI_ERROR_NOT_ENOUGH_CAPACITY;
	if(!fast_boot && IsSAOIFileLoaded(name)) return SAOI_ERROR_IS_LOADED;
	
	new NTTime = GetTickCount();
	if(!fexist(name)) return SAOI_ERROR_INPUT_NOT_EXIST;
	if(strfind(name,".saoi",true) == -1) return SAOI_ERROR_INPUT_EXTENSION;
	new File:inpf = fopen(name,io_read);
	if(!inpf) return SAOI_ERROR_INPUT_NOT_OPEN;
	new asize = flength(inpf), idx = 0;
	if(asize > MAX_SAOI_FILE_SIZE || asize < 0){
		fclose(inpf);
		return SAOI_ERROR_FILE_SIZE;
	}
	new author[MAX_SAOI_AUTHOR_SIZE], version[MAX_SAOI_VERSION_SIZE], description[MAX_SAOI_DESCRIPTION_SIZE];
	
	SAOIFile[index] = SAOIV:Construct();
	SAOIFile[index][SAOIV:status] = true;
	format(SAOIFile[index][SAOIV:name],MAX_SAOI_NAME_SIZE,"%s",name);
	for(new i = strlen(SAOIFile[index][SAOIV:name])-1; i >= 0; i--){
		if(SAOIFile[index][SAOIV:name][i] == '.'){
			SAOIFile[index][SAOIV:name][i] = EOS;
			break;
		}
	}
	
	new extraid = (SAOI_EXTRA_ID_OFFSET+SAOIToInt(index));
	
	new modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, worldid, interiorid,
		Float:streamdistance = STREAMER_OBJECT_SD, Float:drawdistance, areaid, priority,
		arg_count, material_used, material_text_used, elementid, element_flag,
		txdname[MAX_TXD_NAME], texturename[MAX_TEXTURE_NAME], materialcolor, txdsize, texturenamesize,
		text[MAX_TEXT_NAME], fontface[MAX_FONT_NAME], textsize, materialsize, fontfacesize, bold, fontcolor, backcolor,
		textalignment, fontsize, load_time, type, style, color,
		color1, color2, respawn_delay, addsiren, Float:size, invulnerable, Float:health,
		Float:minx, Float:miny, Float:minz, Float:maxx, Float:maxy, Float:maxz,
		Float:Polygon_Points[MAX_POLYGON_POINTS*2], max_points, DynamicAreas[512], testlos;
	
	#if defined SAOI_ColAndreas
		new col_elementid;
	#endif
	
	//Get Header
	new h_len = strlen(SAOI_HEADER_KEY), h_key[32];
	for(new i = 0; i < h_len; i++){
		h_key[i] = fgetchar(inpf,0,false), idx++;
	}
	h_key[h_len] = EOS;
	if(!strcmp(h_key,SAOI_HEADER_KEY,true)){
		new author_size, version_size, description_size, key[32];
		
		author_size = fgetchar(inpf,0,false), idx++;
		for(new i = 0; i < author_size; i++){
			author[i] = fgetchar(inpf,0,false), idx++;
		}
		
		version_size = fgetchar(inpf,0,false), idx++;
		for(new i = 0; i < version_size; i++){
			version[i] = fgetchar(inpf,0,false), idx++;
		}
		
		description_size = fgetchar(inpf,0,false), idx++;
		for(new i = 0; i < description_size; i++){
			description[i] = fgetchar(inpf,0,false), idx++;
		}
		
		for(new i = 0; i < 32; i++){
			key[i] = fgetchar(inpf,0,false), idx++;
		}
		
		new step;
		
		step = 0;
		for(new i = 0; i < author_size; i++){
			author[i] = ((author[i]+key[step]) & 0xFF);
			step++;
			if(step >= 32) step = 0;
		}
		
		step = 0;
		for(new i = 0; i < version_size; i++){
			version[i] = ((version[i]+key[step]) & 0xFF);
			step++;
			if(step >= 32) step = 0;
		}
		
		step = 0;
		for(new i = 0; i < description_size; i++){
			description[i] = ((description[i]+key[step]) & 0xFF);
			step++;
			if(step >= 32) step = 0;
		}
	} else {
		SAOIFile[index][SAOIV:status] = false;
		fclose(inpf);
		return SAOI_ERROR_INVALID_HEADER;
	}
	
	while(idx < asize){
		//Get Arg Count
		arg_count = fgetchar(inpf,0,false), idx++;
		switch(arg_count){
			case 7..14: {
				//Reset Data
				elementid = INVALID_STREAMER_ID;
				material_used = 0;
				material_text_used = 0;
				worldid = -1;
				interiorid = -1;
				streamdistance = STREAMER_OBJECT_SD;
				drawdistance = STREAMER_OBJECT_DD;
				areaid = -1;
				priority = 0;
				element_flag = 0;
		
				SAOI_MergeValue(modelid,0,0,fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(x,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(y,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(z,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(rx,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(ry,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(rz,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				idx += 26;
				
				if(arg_count >= 8){
					SAOI_MergeValue(worldid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}
				if(arg_count >= 9){
					SAOI_MergeValue(interiorid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}
				if(arg_count >= 10){
					SAOI_MergeFloat(streamdistance,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}
				if(arg_count >= 11){
					SAOI_MergeFloat(drawdistance,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}
				if(arg_count >= 12){
					SAOI_MergeValue(areaid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}
				if(arg_count >= 13){
					SAOI_MergeValue(priority,0,0,0,fgetchar(inpf,0,false));
					idx += 1;
				}
				if(arg_count >= 14){
					SAOI_MergeValue(element_flag,0,0,0,fgetchar(inpf,0,false));
					idx += 1;
				}
				if(areaid == -1){
					elementid = CreateDynamicObject(modelid,x,y,z,rx,ry,rz,worldid,interiorid,-1,streamdistance,drawdistance,areaid,priority);
				} else {
					elementid = CreateDynamicObject(modelid,x,y,z,rx,ry,rz,worldid,interiorid,-1,streamdistance,drawdistance,DynamicAreas[areaid],priority);
				}
				//Get Materials
				SAOI_MergeValue(material_used,0,0,fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				idx += 2;
				
				for(new mat = 0; mat < 16; mat++){
					if(SAOI_GetValueBit(material_used,mat) == 1){
						SAOI_MergeValue(modelid,0,0,fgetchar(inpf,0,false),fgetchar(inpf,0,false));
						idx += 2;
						
						txdsize = fgetchar(inpf,0,false), idx++;
						for(new i = 0; i < txdsize; i++){
							txdname[i] = SAOI_IntMod(fgetchar(inpf,0,false)), idx++;
						}
						txdname[txdsize] = EOS;
						
						texturenamesize = fgetchar(inpf,0,false), idx++;
						
						for(new i = 0; i < texturenamesize; i++){
							texturename[i] = SAOI_IntMod(fgetchar(inpf,0,false)), idx++;
						}
						texturename[texturenamesize] = EOS;

						SAOI_MergeValue(materialcolor,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
						idx += 4;
						
						SetDynamicObjectMaterial(elementid,mat,modelid,txdname,texturename,materialcolor);
						SAOIFile[index][SAOIV:cnt_material]++;
					}
				}
				
				//Get Materials Text
				SAOI_MergeValue(material_text_used,0,0,fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				idx += 2;
				
				for(new mat = 0; mat < 16; mat++){
					if(SAOI_GetValueBit(material_text_used,mat) == 1){
						SAOI_MergeValue(textsize,0,0,fgetchar(inpf,0,false),fgetchar(inpf,0,false));
						idx += 2;
						
						for(new i = 0; i < textsize; i++){
							text[i] = SAOI_IntMod(fgetchar(inpf,0,false)), idx++;
						}
						text[textsize] = EOS;

						materialsize = fgetchar(inpf,0,false), idx++;
						
						fontfacesize = fgetchar(inpf,0,false), idx++;
						
						for(new i = 0; i < fontfacesize; i++){
							fontface[i] = SAOI_IntMod(fgetchar(inpf,0,false)), idx++;
						}
						fontface[fontfacesize] = EOS;

						fontsize = fgetchar(inpf,0,false), idx++;
						
						bold = fgetchar(inpf,0,false), idx++;
						
						SAOI_MergeValue(fontcolor,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
						idx += 4;
						
						SAOI_MergeValue(backcolor,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
						idx += 4;
						
						textalignment = fgetchar(inpf,0,false), idx++;
						
						SetDynamicObjectMaterialText(elementid,mat,text,materialsize,fontface,fontsize,bold,fontcolor,backcolor,textalignment);
						SAOIFile[index][SAOIV:cnt_materialtext]++;
					}
				}
				if(SAOIFile[index][SAOIV:offset_object] == INVALID_STREAMER_ID){
					SAOIFile[index][SAOIV:offset_object] = elementid;
				}
				Streamer_SetIntData(STREAMER_TYPE_OBJECT,elementid,E_STREAMER_EXTRA_ID,extraid);
				if(SAOI_GetValueBit(element_flag,ELEMENT_FLAG_ANTI_AREA) == 1){
					Streamer_ToggleItemInvAreas(STREAMER_TYPE_OBJECT,elementid,1);
				}
				if(SAOI_GetValueBit(element_flag,ELEMENT_FLAG_NO_CAMERA_COL) == 1){
					SetDynamicObjectNoCameraCol(elementid);
				}
				SAOIFile[index][SAOIV:cnt_object]++;
				#if defined SAOI_ColAndreas
					if(SAOI_GetValueBit(element_flag,ELEMENT_FLAG_COLANDREAS) == 1){
						col_elementid = CA_CreateObject(modelid,x,y,z,rx,ry,rz,true);
						CA_SetObjectExtraID(col_elementid,CA_EXTRA_1,extraid);
						SAOIFile[index][SAOIV:cnt_caobject]++;
						if(SAOIFile[index][SAOIV:offset_caobject] == -1){
							SAOIFile[index][SAOIV:offset_caobject] = col_elementid;
						}
					} else if(SAOI_GetValueBit(element_flag,ELEMENT_FLAG_COLSTATIC) == 1){
						CA_CreateObject(modelid,x,y,z,rx,ry,rz,false);
						SAOIFile[index][SAOIV:cnt_caobject]++;
						SAOIFile[index][SAOIV:is_static] = true;
					}
				#endif
				continue;
			}
			
			case SAOI_BUMPER_ACTOR: {
				arg_count = fgetchar(inpf,0,false), idx++;
				
				//Reset Data
				elementid = INVALID_STREAMER_ID;
				invulnerable = 1;
				health = 100.0;
				worldid = -1;
				interiorid = -1;
				streamdistance = STREAMER_OBJECT_SD;
				areaid = -1;
				priority = 0;
				element_flag = 0;
				
				SAOI_MergeValue(modelid,0,0,fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(x,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(y,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(z,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(rz,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				idx += 18;
			
				if(arg_count >= 6){
					SAOI_MergeValue(invulnerable,0,0,0,fgetchar(inpf,0,false));
					idx += 1;
				}
				if(arg_count >= 7){
					SAOI_MergeFloat(health,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}
				if(arg_count >= 8){
					SAOI_MergeValue(worldid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}
				if(arg_count >= 9){
					SAOI_MergeValue(interiorid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}
				if(arg_count >= 10){
					SAOI_MergeFloat(streamdistance,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}
				if(arg_count >= 11){
					SAOI_MergeValue(areaid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}
				if(arg_count >= 12){
					SAOI_MergeValue(priority,0,0,0,fgetchar(inpf,0,false));
					idx += 1;
				}
				if(arg_count >= 13){
					SAOI_MergeValue(element_flag,0,0,0,fgetchar(inpf,0,false));
					idx += 1;
				}
				if(areaid == -1){
					elementid = CreateDynamicActor(modelid,x,y,z,rz,invulnerable,health,worldid,interiorid,-1,streamdistance,areaid,priority);
				} else {
					elementid = CreateDynamicActor(modelid,x,y,z,rz,invulnerable,health,worldid,interiorid,-1,streamdistance,DynamicAreas[areaid],priority);
				}
				
				if(SAOIFile[index][SAOIV:offset_actor] == INVALID_STREAMER_ID){
					SAOIFile[index][SAOIV:offset_actor] = elementid;
				}
				Streamer_SetIntData(STREAMER_TYPE_ACTOR,elementid,E_STREAMER_EXTRA_ID,SAOI_EXTRA_ID_OFFSET+SAOIToInt(index));
				if(SAOI_GetValueBit(element_flag,ELEMENT_FLAG_ANTI_AREA) == 1){
					Streamer_ToggleItemInvAreas(STREAMER_TYPE_ACTOR,elementid,1);
				}
				SAOIFile[index][SAOIV:cnt_actor]++;
				continue;
			}
			
			case SAOI_BUMPER_3D_TEXT_LABEL: {
				arg_count = fgetchar(inpf,0,false), idx++;
				
				//Reset Data
				elementid = INVALID_STREAMER_ID;
				textsize = 0;
				text = "";
				testlos = 0;
				worldid = -1;
				interiorid = -1;
				streamdistance = STREAMER_OBJECT_SD;
				areaid = -1;
				priority = 0;
				element_flag = 0;
				
				SAOI_MergeValue(textsize,0,0,fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				idx += 2;
				
				for(new i = 0; i < textsize; i++){
					text[i] = SAOI_IntMod(fgetchar(inpf,0,false)), idx++;
				}
				text[textsize] = EOS;
				
				SAOI_MergeValue(color,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(x,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(y,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(z,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(drawdistance,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				idx += 20;
				
				if(arg_count >= 8){
					SAOI_MergeValue(testlos,0,0,0,fgetchar(inpf,0,false));
					idx += 1;
				}
				if(arg_count >= 9){
					SAOI_MergeValue(worldid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}
				if(arg_count >= 10){
					SAOI_MergeValue(interiorid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}
				if(arg_count >= 11){
					SAOI_MergeFloat(streamdistance,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}
				if(arg_count >= 12){
					SAOI_MergeValue(areaid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}
				if(arg_count >= 13){
					SAOI_MergeValue(priority,0,0,0,fgetchar(inpf,0,false));
					idx += 1;
				}
				if(arg_count >= 14){
					SAOI_MergeValue(element_flag,0,0,0,fgetchar(inpf,0,false));
					idx += 1;
				}
				if(areaid == -1){
					elementid = _:CreateDynamic3DTextLabel(text,color,x,y,z,drawdistance,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,testlos,worldid,interiorid,-1,streamdistance,areaid,priority);
				} else {
					elementid = _:CreateDynamic3DTextLabel(text,color,x,y,z,drawdistance,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,testlos,worldid,interiorid,-1,streamdistance,DynamicAreas[areaid],priority);
				}
				
				if(SAOIFile[index][SAOIV:offset_3dtext] == INVALID_STREAMER_ID){
					SAOIFile[index][SAOIV:offset_3dtext] = elementid;
				}
				Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL,elementid,E_STREAMER_EXTRA_ID,SAOI_EXTRA_ID_OFFSET+SAOIToInt(index));
				if(SAOI_GetValueBit(element_flag,ELEMENT_FLAG_ANTI_AREA) == 1){
					Streamer_ToggleItemInvAreas(STREAMER_TYPE_3D_TEXT_LABEL,elementid,1);
				}
				SAOIFile[index][SAOIV:cnt_3dtext]++;
				continue;
			}
			
			case SAOI_BUMPER_PICKUP: {
				arg_count = fgetchar(inpf,0,false), idx++;
				
				//Reset Data
				elementid = INVALID_STREAMER_ID, type = 0, worldid = -1, interiorid = -1, streamdistance = STREAMER_OBJECT_SD,
				areaid = -1, priority = 0, element_flag = 0;
		
				SAOI_MergeValue(modelid,0,0,fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeValue(type,0,0,0,fgetchar(inpf,0,false));
				SAOI_MergeFloat(x,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(y,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(z,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				idx += 15;
				
				if(arg_count >= 6){
					SAOI_MergeValue(worldid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}
				if(arg_count >= 7){
					SAOI_MergeValue(interiorid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}
				if(arg_count >= 8){
					SAOI_MergeFloat(streamdistance,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}
				if(arg_count >= 9){
					SAOI_MergeValue(areaid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}
				if(arg_count >= 10){
					SAOI_MergeValue(priority,0,0,0,fgetchar(inpf,0,false));
					idx += 1;
				}
				if(arg_count >= 11){
					SAOI_MergeValue(element_flag,0,0,0,fgetchar(inpf,0,false));
					idx += 1;
				}
				if(areaid == -1){
					elementid = CreateDynamicPickup(modelid,type,x,y,z,worldid,interiorid,-1,streamdistance,areaid,priority);
				} else {
					elementid = CreateDynamicPickup(modelid,type,x,y,z,worldid,interiorid,-1,streamdistance,DynamicAreas[areaid],priority);
				}
				
				if(SAOIFile[index][SAOIV:offset_pickup] == INVALID_STREAMER_ID){
					SAOIFile[index][SAOIV:offset_pickup] = elementid;
				}
				Streamer_SetIntData(STREAMER_TYPE_PICKUP,elementid,E_STREAMER_EXTRA_ID,SAOI_EXTRA_ID_OFFSET+SAOIToInt(index));
				if(SAOI_GetValueBit(element_flag,ELEMENT_FLAG_ANTI_AREA) == 1){
					Streamer_ToggleItemInvAreas(STREAMER_TYPE_PICKUP,elementid,1);
				}
				SAOIFile[index][SAOIV:cnt_pickup]++;
				continue;
			}

			case SAOI_BUMPER_MAPICON: {
				arg_count = fgetchar(inpf,0,false), idx++;
				
				//Reset Data
				elementid = INVALID_STREAMER_ID;
				worldid = -1;
				interiorid = -1;
				streamdistance = STREAMER_OBJECT_SD;
				style = 0;
				areaid = -1;
				priority = 0;
				element_flag = 0;
				
		
				SAOI_MergeFloat(x,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(y,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(z,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeValue(type,0,0,0,fgetchar(inpf,0,false));
				SAOI_MergeValue(color,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				idx += 17;
				
				if(arg_count >= 6){
					SAOI_MergeValue(worldid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}
				if(arg_count >= 7){
					SAOI_MergeValue(interiorid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}
				if(arg_count >= 8){
					SAOI_MergeFloat(streamdistance,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}
				if(arg_count >= 9){
					SAOI_MergeValue(style,0,0,0,fgetchar(inpf,0,false));
					idx += 1;
				}
				if(arg_count >= 10){
					SAOI_MergeValue(areaid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}
				if(arg_count >= 11){
					SAOI_MergeValue(priority,0,0,0,fgetchar(inpf,0,false));
					idx += 1;
				}
				if(arg_count >= 12){
					SAOI_MergeValue(element_flag,0,0,0,fgetchar(inpf,0,false));
					idx += 1;
				}
				if(areaid == -1){
					elementid = CreateDynamicMapIcon(x,y,z,type,color,worldid,interiorid,-1,streamdistance,style,areaid,priority);
				} else {
					elementid = CreateDynamicMapIcon(x,y,z,type,color,worldid,interiorid,-1,streamdistance,style,DynamicAreas[areaid],priority);
				}
				
				if(SAOIFile[index][SAOIV:offset_mapicon] == INVALID_STREAMER_ID){
					SAOIFile[index][SAOIV:offset_mapicon] = elementid;
				}
				Streamer_SetIntData(STREAMER_TYPE_MAP_ICON,elementid,E_STREAMER_EXTRA_ID,SAOI_EXTRA_ID_OFFSET+SAOIToInt(index));
				if(SAOI_GetValueBit(element_flag,ELEMENT_FLAG_ANTI_AREA) == 1){
					Streamer_ToggleItemInvAreas(STREAMER_TYPE_MAP_ICON,elementid,1);
				}
				SAOIFile[index][SAOIV:cnt_mapicon]++;
				continue;
			}

			case SAOI_BUMPER_VEHICLE: {
				SAOI_MergeValue(type,0,0,fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(x,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(y,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(z,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(rz,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeValue(color1,0,0,fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeValue(color2,0,0,fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeValue(respawn_delay,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeValue(addsiren,0,0,0,fgetchar(inpf,0,false));
				SAOI_MergeValue(worldid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeValue(interiorid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				idx += 35;
				
				if(color1 == 0xFFFF) color1 = -1;
				if(color2 == 0xFFFF) color2 = -1;
				
				elementid = CreateVehicle(type,x,y,z,rz,color1,color2,respawn_delay,addsiren);
				if(elementid == INVALID_VEHICLE_ID){
					printf("[SAOI DEBUG] Can't create vehicle, limit exceeded !");
				} else {
					if(interiorid != 0) LinkVehicleToInterior(elementid,interiorid);
					if(worldid != 0) SetVehicleVirtualWorld(elementid,worldid);
					SAOI_Vehicles[elementid] = index;
					
					CallRemoteFunction("SAOI_OnVehicleCreated","d",elementid);
					
					if(SAOIFile[index][SAOIV:offset_vehicle] == 0){
						SAOIFile[index][SAOIV:offset_mapicon] = elementid;
					}
					
					SAOIFile[index][SAOIV:cnt_vehicle]++;
				}
				continue;
			}

			case SAOI_BUMPER_AREA_CIRCLE: {
				arg_count = fgetchar(inpf,0,false), idx++;
				
				//Reset Data
				elementid = INVALID_STREAMER_ID;
				worldid = -1;
				interiorid = -1;
				
				SAOI_MergeValue(areaid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(x,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(y,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(size,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				idx += 16;
				
				if(arg_count >= 5){
					SAOI_MergeValue(worldid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}
				if(arg_count >= 6){
					SAOI_MergeValue(interiorid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}
				elementid = CreateDynamicCircle(x,y,size,worldid,interiorid,-1);
				DynamicAreas[areaid] = elementid;
				
				if(SAOIFile[index][SAOIV:offset_area] == INVALID_STREAMER_ID){
					SAOIFile[index][SAOIV:offset_area] = elementid;
				}
				Streamer_SetIntData(STREAMER_TYPE_AREA,elementid,E_STREAMER_EXTRA_ID,SAOI_EXTRA_ID_OFFSET+SAOIToInt(index));
				
				SAOIFile[index][SAOIV:cnt_area]++;
				continue;
			}

			case SAOI_BUMPER_AREA_CYLINDER: {
				arg_count = fgetchar(inpf,0,false), idx++;
				
				//Reset Data
				elementid = INVALID_STREAMER_ID;
				worldid = -1;
				interiorid = -1;
				
				SAOI_MergeValue(areaid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(x,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(y,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(minz,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(maxz,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(size,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				idx += 24;
				
				if(arg_count >= 7){
					SAOI_MergeValue(worldid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}
				if(arg_count >= 8){
					SAOI_MergeValue(interiorid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}
				elementid = CreateDynamicCylinder(x,y,minz,maxz,size,worldid,interiorid,-1);
				
				DynamicAreas[areaid] = elementid;
				
				if(SAOIFile[index][SAOIV:offset_area] == INVALID_STREAMER_ID){
					SAOIFile[index][SAOIV:offset_area] = elementid;
				}
				Streamer_SetIntData(STREAMER_TYPE_AREA,elementid,E_STREAMER_EXTRA_ID,SAOI_EXTRA_ID_OFFSET+SAOIToInt(index));
				
				SAOIFile[index][SAOIV:cnt_area]++;
				continue;
			}

			case SAOI_BUMPER_AREA_SPHERE: {
				arg_count = fgetchar(inpf,0,false), idx++;
				
				//Reset Data
				elementid = INVALID_STREAMER_ID;
				worldid = -1;
				interiorid = -1;
				
				SAOI_MergeValue(areaid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(x,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(y,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(z,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(size,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				idx += 20;
				
				if(arg_count >= 6){
					SAOI_MergeValue(worldid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}
				if(arg_count >= 7){
					SAOI_MergeValue(interiorid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}
				elementid = CreateDynamicSphere(x,y,z,size,worldid,interiorid,-1);
				DynamicAreas[areaid] = elementid;
				
				if(SAOIFile[index][SAOIV:offset_area] == INVALID_STREAMER_ID){
					SAOIFile[index][SAOIV:offset_area] = elementid;
				}
				Streamer_SetIntData(STREAMER_TYPE_AREA,elementid,E_STREAMER_EXTRA_ID,SAOI_EXTRA_ID_OFFSET+SAOIToInt(index));
				
				SAOIFile[index][SAOIV:cnt_area]++;
				continue;
			}

			case SAOI_BUMPER_AREA_RECTANGLE: {
				arg_count = fgetchar(inpf,0,false), idx++;
				
				//Reset Data
				elementid = INVALID_STREAMER_ID;
				worldid = -1;
				interiorid = -1;
				
				SAOI_MergeValue(areaid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(minx,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(miny,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(maxx,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(maxy,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				idx += 20;
				
				if(arg_count >= 6){
					SAOI_MergeValue(worldid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}
				if(arg_count >= 7){
					SAOI_MergeValue(interiorid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}
				elementid = CreateDynamicRectangle(minx,miny,maxx,maxy,worldid,interiorid,-1);
				DynamicAreas[areaid] = elementid;
				
				if(SAOIFile[index][SAOIV:offset_area] == INVALID_STREAMER_ID){
					SAOIFile[index][SAOIV:offset_area] = elementid;
				}
				Streamer_SetIntData(STREAMER_TYPE_AREA,elementid,E_STREAMER_EXTRA_ID,SAOI_EXTRA_ID_OFFSET+SAOIToInt(index));
				
				SAOIFile[index][SAOIV:cnt_area]++;
				continue;
			}

			case SAOI_BUMPER_AREA_CUBOID: {
				arg_count = fgetchar(inpf,0,false), idx++;
				
				//Reset Data
				elementid = INVALID_STREAMER_ID;
				worldid = -1;
				interiorid = -1;
				
				SAOI_MergeValue(areaid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(minx,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(miny,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(minz,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(maxx,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(maxy,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeFloat(maxz,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				idx += 28;
				
				if(arg_count >= 8){
					SAOI_MergeValue(worldid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}
				if(arg_count >= 9){
					SAOI_MergeValue(interiorid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}
				elementid = CreateDynamicCube(minx,miny,minz,maxx,maxy,maxz,worldid,interiorid,-1);
				DynamicAreas[areaid] = elementid;
				
				if(SAOIFile[index][SAOIV:offset_area] == INVALID_STREAMER_ID){
					SAOIFile[index][SAOIV:offset_area] = elementid;
				}
				Streamer_SetIntData(STREAMER_TYPE_AREA,elementid,E_STREAMER_EXTRA_ID,SAOI_EXTRA_ID_OFFSET+SAOIToInt(index));
				
				SAOIFile[index][SAOIV:cnt_area]++;
				continue;
			}

			case SAOI_BUMPER_AREA_POLYGON: {
				arg_count = fgetchar(inpf,0,false), idx++;
				
				//Reset Data
				elementid = INVALID_STREAMER_ID;
				minz = -FLOAT_INFINITY;
				maxz = FLOAT_INFINITY;
				worldid = -1;
				interiorid = -1;
				
				SAOI_MergeValue(areaid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOI_MergeValue(max_points,0,0,fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				idx += 6;
				
				for(new k = 0; k < max_points; k++){
					SAOI_MergeFloat(Polygon_Points[k],fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}
				
				if(arg_count >= 4){
					SAOI_MergeFloat(minz,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}
				if(arg_count >= 5){
					SAOI_MergeFloat(maxz,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}
				if(arg_count >= 6){
					SAOI_MergeValue(worldid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}
				if(arg_count >= 7){
					SAOI_MergeValue(interiorid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
					idx += 4;
				}

				elementid = CreateDynamicPolygon(Polygon_Points,minz,maxz,max_points,worldid,interiorid,-1);
				DynamicAreas[areaid] = elementid;
				
				if(SAOIFile[index][SAOIV:offset_area] == INVALID_STREAMER_ID){
					SAOIFile[index][SAOIV:offset_area] = elementid;
				}
				Streamer_SetIntData(STREAMER_TYPE_AREA,elementid,E_STREAMER_EXTRA_ID,SAOI_EXTRA_ID_OFFSET+SAOIToInt(index));
				
				SAOIFile[index][SAOIV:cnt_area]++;
				continue;
			}
			
			case SAOI_BUMPER_REMOVEBUILDING: {
				//RemoveBuildingForPlayer
				modelid = SAOI_MergeValue(modelid,0,0,fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				x = SAOI_MergeFloatEx(fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				y = SAOI_MergeFloatEx(fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				z = SAOI_MergeFloatEx(fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				streamdistance = SAOI_MergeFloatEx(fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				idx += 18;
				SAOI_RemoveBuilding(index,modelid,x,y,z,streamdistance);
				SAOIFile[index][SAOIV:cnt_removebuilding]++;
				continue;
			}
			case SAOI_BUMPER_CREATED: {
				new year,month,day,hour,minute,second;
				year = SAOI_MergeValueEx(0,0,SAOI_IntMod(fgetchar(inpf,0,false)),SAOI_IntMod(fgetchar(inpf,0,false)));
				month = SAOI_IntMod(fgetchar(inpf,0,false));
				day = SAOI_IntMod(fgetchar(inpf,0,false));
				hour = SAOI_IntMod(fgetchar(inpf,0,false));
				minute = SAOI_IntMod(fgetchar(inpf,0,false));
				second = SAOI_IntMod(fgetchar(inpf,0,false));
				format(SAOIFile[index][SAOIV:created],32,"%04d.%02d.%02d %02d:%02d:%02d",year,month,day,hour,minute,second);
				idx += 7;
				continue;
			}
			case SAOI_BUMPER_POS: {
				SAOIFile[index][SAOIV:X] = SAOI_MergeFloatEx(fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOIFile[index][SAOIV:Y] = SAOI_MergeFloatEx(fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false)); 
				SAOIFile[index][SAOIV:Z] = SAOI_MergeFloatEx(fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOIFile[index][SAOIV:A] = SAOI_MergeFloatEx(fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOIFile[index][SAOIV:VW] = SAOI_MergeValueEx(fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				SAOIFile[index][SAOIV:INT] = SAOI_MergeValueEx(fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				idx += 24;
				continue;
			}
			case SAOI_BUMPER_IP: {
				new serv_ipsum[4], saoi_ipsum[4], serv_ip[16];
				GetServerVarAsString("bind",serv_ip,sizeof(serv_ip));
				for(new i = 0; i < 4; i++){
					saoi_ipsum[i] = fgetchar(inpf,0,false), idx++;
				}
				sscanf(serv_ip,"p<.>dddd",serv_ipsum[0],serv_ipsum[1],serv_ipsum[2],serv_ipsum[3]);
				if(SAOI_Comp(serv_ipsum[0],saoi_ipsum[3]) || SAOI_Comp(serv_ipsum[1],saoi_ipsum[2]) || SAOI_Comp(serv_ipsum[2],saoi_ipsum[1]) || SAOI_Comp(serv_ipsum[3],saoi_ipsum[0])){
					fclose(inpf);
					printf("[ADM] Error: This SAOI file is protected.");
					SendRconCommand("exit");
					return SAOI_ERROR_INVALID_SERVER_IP;
				}
				continue;
			}
			case SAOI_BUMPER_PORT: {
				new serv_port = GetServerVarAsInt("port"), serv_portsum[4], saoi_portsum[4];
				for(new i = 0; i < 4; i++){
					saoi_portsum[i] = fgetchar(inpf,0,false), idx++;
				}
				SAOI_ExtractValue(serv_port,serv_portsum[0],serv_portsum[1],serv_portsum[2],serv_portsum[3]);
				if(SAOI_Comp(serv_portsum[0],saoi_portsum[3]) || SAOI_Comp(serv_portsum[1],saoi_portsum[2]) || SAOI_Comp(serv_portsum[2],saoi_portsum[1]) || SAOI_Comp(serv_portsum[3],saoi_portsum[0])){
					fclose(inpf);
					printf("[ADM] Error: This SAOI file is protected.");
					SendRconCommand("exit");
					return SAOI_ERROR_INVALID_SERVER_PORT;
				}
				continue;
			}
			case SAOI_BUMPER_EOF: {
				SAOIFile[index][SAOIV:write_lock] = true;
				break;
			}
			default: {
				SAOI_CleanupElements(index);
				SAOIFile[index][SAOIV:status] = false;
				
				new d_raw[8], offset = idx-1;
				for(new i = 0; i < 8; i++){
					if(idx < asize){
						d_raw[i] = fgetchar(inpf,0,false), idx++;
					} else {
						d_raw[i] = 0;
					}
				}

				fclose(inpf);
				
				//Print Error Backtrace
				printf(" ");
				printf("[SAOI DEBUG] Parse Error '%s' Offset 0x%08x Argument: 0x%02x Buffer: %02x %02x %02x %02x %02x %02x %02x %02x",name,offset,arg_count,d_raw[0],d_raw[1],d_raw[2],d_raw[3],d_raw[4],d_raw[5],d_raw[6],d_raw[7]);
				printf("[SAOI DEBUG] File Size: 0x%08x",asize);
				if(isnull(SAOIFile[index][SAOIV:created])){
					printf("[SAOI DEBUG] File Creation Date: (null)");
				} else {
					printf("[SAOI DEBUG] File Creation Date: %s",SAOIFile[index][SAOIV:created]);
				}
				printf(" ");
				return SAOI_ERROR_INVALID_ARG_COUNT;
			}
		}
	}
	for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++){
		if(IsPlayerConnected(i)){
			SAOI_UpdateBuildingsForPlayer(i,index);
		}
	}
	
	SAOIFile[index][SAOIV:file_size] = idx;
	
	fclose(inpf);
	
	load_time = GetTickCount()-NTTime;
	
	SAOIFile[index][SAOIV:load_time] = load_time;
	SAOIFile[index][SAOIV:active_tick] = GetTickCount();
	
	if(save_logs){
		new buffer[256];
		format(buffer,sizeof buffer,"File %s has been loaded as %s in %d ms",name,(SAOI_IsStatic(index)?("static"):("dynamic")),load_time);
		printf(buffer);
		format(buffer,sizeof buffer,"Author: %s Version: %s Items: %d",author,version,SAOI_CountAllElementsByIndex(index));
		printf(buffer);
		if(!isnull(description)){
			format(buffer,sizeof buffer,"Description: %s",description);
			printf(buffer);
		}
		printf(" ");
	}
	return index;
}

SAOI_Function:: bool:UnloadObjectImage(SAOI:index){
	if(!CRC_SAOIAccess) return false;
	if(!SAOI_IsLoaded(index) || SAOI_IsStatic(index)) return false;
	SAOI_CleanupElements(index);
	SAOIFile[index] = SAOIV:Construct();
	return true;
}

SAOI_Public:: SAOI_ToggleVisibleItems(const name[],playerid,type,toggle){
	if(!CRC_SAOIAccess) return 0;
	new SAOI:index;
	if(!IsSAOIFileLoaded(name,index)) return 0;
	
	new extraid = (SAOI_EXTRA_ID_OFFSET+SAOIToInt(index)), cnt = 0;
	
	switch(type){
		case STREAMER_TYPE_OBJECT: {
			//Objects
			if(SAOIFile[index][SAOIV:cnt_object] > 0){
				new max_idx = SAOIFile[index][SAOIV:cnt_object], i = SAOIFile[index][SAOIV:offset_object], j = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT);
				while(i <= j && max_idx > 0){
					if(IsValidDynamicObject(i)){
						if(Streamer_GetIntData(STREAMER_TYPE_OBJECT,i,E_STREAMER_EXTRA_ID) == extraid){
							max_idx--;
							Streamer_ToggleItem(playerid,type,i,toggle);
							cnt++;
						}
					}
					i++;
				}
			}
		}
		case STREAMER_TYPE_PICKUP: {
			//Pickups
			if(SAOIFile[index][SAOIV:cnt_pickup] > 0){
				new max_idx = SAOIFile[index][SAOIV:cnt_pickup], i = SAOIFile[index][SAOIV:offset_pickup], j = Streamer_GetUpperBound(STREAMER_TYPE_PICKUP);
				while(i <= j && max_idx > 0){
					if(IsValidDynamicPickup(i)){
						if(Streamer_GetIntData(STREAMER_TYPE_PICKUP,i,E_STREAMER_EXTRA_ID) == extraid){
							max_idx--;
							Streamer_ToggleItem(playerid,type,i,toggle);
							cnt++;
						}
					}
					i++;
				}
			}
		}
		case STREAMER_TYPE_MAP_ICON: {
			//MapIcons
			if(SAOIFile[index][SAOIV:cnt_mapicon] > 0){
				new max_idx = SAOIFile[index][SAOIV:cnt_mapicon], i = SAOIFile[index][SAOIV:offset_mapicon], j = Streamer_GetUpperBound(STREAMER_TYPE_MAP_ICON);
				while(i <= j && max_idx > 0){
					if(IsValidDynamicMapIcon(i)){
						if(Streamer_GetIntData(STREAMER_TYPE_MAP_ICON,i,E_STREAMER_EXTRA_ID) == extraid){
							max_idx--;
							Streamer_ToggleItem(playerid,type,i,toggle);
							cnt++;
						}
					}
					i++;
				}
			}
		}
		case STREAMER_TYPE_3D_TEXT_LABEL: {
			//3DTextLabels
			if(SAOIFile[index][SAOIV:cnt_3dtext] > 0){
				new max_idx = SAOIFile[index][SAOIV:cnt_3dtext], i = SAOIFile[index][SAOIV:offset_3dtext], j = Streamer_GetUpperBound(STREAMER_TYPE_3D_TEXT_LABEL);
				while(i <= j && max_idx > 0){
					if(IsValidDynamic3DTextLabel(Text3D:i)){
						if(Streamer_GetIntData(STREAMER_TYPE_3D_TEXT_LABEL,i,E_STREAMER_EXTRA_ID) == extraid){
							max_idx--;
							Streamer_ToggleItem(playerid,type,Text3D:i,toggle);
							cnt++;
						}
					}
					i++;
				}
			}
		}
		case STREAMER_TYPE_AREA: {
			//Areas
			if(SAOIFile[index][SAOIV:cnt_area] > 0){
				new max_idx = SAOIFile[index][SAOIV:cnt_area], i = SAOIFile[index][SAOIV:offset_area], j = Streamer_GetUpperBound(STREAMER_TYPE_AREA);
				while(i <= j && max_idx > 0){
					if(IsValidDynamicArea(i)){
						if(Streamer_GetIntData(STREAMER_TYPE_AREA,i,E_STREAMER_EXTRA_ID) == extraid){
							max_idx--;
							Streamer_ToggleItem(playerid,type,i,toggle);
							cnt++;
						}
					}
					i++;
				}
			}
		}
		case STREAMER_TYPE_ACTOR: {
			//Actors
			if(SAOIFile[index][SAOIV:cnt_actor] > 0){
				new max_idx = SAOIFile[index][SAOIV:cnt_actor], i = SAOIFile[index][SAOIV:offset_actor], j = Streamer_GetUpperBound(STREAMER_TYPE_ACTOR);
				while(i <= j && max_idx > 0){
					if(IsValidDynamicActor(i)){
						if(Streamer_GetIntData(STREAMER_TYPE_ACTOR,i,E_STREAMER_EXTRA_ID) == extraid){
							max_idx--;
							Streamer_ToggleItem(playerid,type,i,toggle);
							cnt++;
						}
					}
					i++;
				}
			}
		}
	}
	return cnt;
}

new bool:CRC_SAOIInit = true,
	bool:CRC_SAOIExit = true;

forward SAOI_RemoteCheck();

public SAOI_RemoteCheck(){
	#if defined LOCK_SAOI_MEMORY
		if(GetSVarInt("ADM:SAOI:LOCK") == 0){
			SetSVarInt("ADM:SAOI:LOCK",1);
			SetSVarString("ADM:SAOI:FM",LOCK_SAOI_MEMORY);
			printf("[ADM] Info: SAOI has been attached to %s",LOCK_SAOI_MEMORY);
			CRC_SAOIAccess = true;
		} else {
			new saoi_fm_name[64];
			GetSVarString("ADM:SAOI:FM",saoi_fm_name,64);
			printf("[SAOI DEBUG] SAOI.inc was blocked by %s !",saoi_fm_name);
			printf("[SAOI DEBUG] You can not modify the memory remotely");
			CRC_SAOIAccess = false;
		}
	#else
		if(GetSVarInt("ADM:SAOI:LOCK") == 1){
			new saoi_fm_name[64];
			GetSVarString("ADM:SAOI:FM",saoi_fm_name,64);
			printf("[SAOI DEBUG] SAOI.inc was blocked by %s !",saoi_fm_name);
			printf("[SAOI DEBUG] You can not modify the memory remotely");
			CRC_SAOIAccess = false;
		} else {
			CRC_SAOIAccess = true;
		}
	#endif
	return 1;
}

SAOI_Function:: SAOI_Init(){
	CallRemoteFunction("SAOI_RemoteCheck","");
}

SAOI_Function:: SAOI_Exit(){
	#if defined LOCK_SAOI_MEMORY
		SetSVarInt("ADM:SAOI:LOCK",0);
		DeleteSVar("ADM:SAOI:FM");
		printf("[ADM] Info: SAOI has been detached from %s",LOCK_SAOI_MEMORY);
	#endif
	
	//Vehicles
	new prot_i = 0;
	for(new i = 0, j = GetVehiclePoolSize(); i <= j; i++){
		prot_i = i;
		if(IsValidVehicle(i)){
			if(SAOI_Vehicles[i] != INVALID_SAOI_FILE){
				DestroyVehicle(prot_i);
				CallRemoteFunction("SAOI_OnVehicleDestroyed","d",i);
				SAOI_Vehicles[i] = INVALID_SAOI_FILE;
			}
		}
	}
}

//Hook: OnPlayerConnect
public OnPlayerConnect(playerid){
	SAOIPlayerFirstSpawn[playerid] = true;
	#if defined SAOI_OnPlayerConnect
		SAOI_OnPlayerConnect(playerid);
	#endif
	return 1;
}

#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect SAOI_OnPlayerConnect
#if defined SAOI_OnPlayerConnect
	forward SAOI_OnPlayerConnect(playerid);
#endif

//Hook: OnPlayerSpawn
public OnPlayerSpawn(playerid){
	if(SAOIPlayerFirstSpawn[playerid]){
		SAOIPlayerFirstSpawn[playerid] = false;
		CallRemoteFunction("SAOI_OnRemovedBuildings","dd",playerid,SAOI_RemoveBuildingsForPlayer(playerid));
	}
	#if defined SAOI_OnPlayerSpawn
		SAOI_OnPlayerSpawn(playerid);
	#endif
	return 1;
}

#if defined _ALS_OnPlayerSpawn
	#undef OnPlayerSpawn
#else
	#define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn SAOI_OnPlayerSpawn
#if defined SAOI_OnPlayerSpawn
	forward SAOI_OnPlayerSpawn(playerid);
#endif

//Hook: OnFilterScriptInit
public OnFilterScriptInit(){
	if(CRC_SAOIInit){
		CRC_SAOIInit = false;
		SAOI_Init();
	}
	#if defined SAOI_OnFilterScriptInit
		SAOI_OnFilterScriptInit();
	#endif
	return 1;
}

#if defined _ALS_OnFilterScriptInit
	#undef OnFilterScriptInit
#else
	#define _ALS_OnFilterScriptInit
#endif
#define OnFilterScriptInit SAOI_OnFilterScriptInit
#if defined SAOI_OnFilterScriptInit
	forward SAOI_OnFilterScriptInit();
#endif

//Hook: OnGameModeInit
public OnGameModeInit(){
	if(CRC_SAOIInit){
		CRC_SAOIInit = false;
		SAOI_Init();
	}
	#if defined SAOI_OnGameModeInit
		SAOI_OnGameModeInit();
	#endif
	return 1;
}

#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit SAOI_OnGameModeInit
#if defined SAOI_OnGameModeInit
	forward SAOI_OnGameModeInit();
#endif

//Hook: OnFilterScriptExit
public OnFilterScriptExit(){
	if(CRC_SAOIExit){
		CRC_SAOIExit = false;
		SAOI_Exit();
	}
	#if defined SAOI_OnFilterScriptExit
		SAOI_OnFilterScriptExit();
	#endif
	return 1;
}

#if defined _ALS_OnFilterScriptExit
	#undef OnFilterScriptExit
#else
	#define _ALS_OnFilterScriptExit
#endif
#define OnFilterScriptExit SAOI_OnFilterScriptExit
#if defined SAOI_OnFilterScriptExit
	forward SAOI_OnFilterScriptExit();
#endif

//Hook: OnGameModeExit
public OnGameModeExit(){
	if(CRC_SAOIExit){
		CRC_SAOIExit = false;
		SAOI_Exit();
	}
	#if defined SAOI_OnGameModeExit
		SAOI_OnGameModeExit();
	#endif
	return 1;
}

#if defined _ALS_OnGameModeExit
	#undef OnGameModeExit
#else
	#define _ALS_OnGameModeExit
#endif
#define OnGameModeExit SAOI_OnGameModeExit
#if defined SAOI_OnGameModeExit
	forward SAOI_OnGameModeExit();
#endif

//EOF