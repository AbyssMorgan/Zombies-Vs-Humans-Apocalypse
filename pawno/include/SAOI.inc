/**********************************************************************************************************************************
 *                                                                                                                                *
 *                                                San Andreas Object Image Loader                                                 *
 *                                                                                                                                *
 * Copyright © 2016 Abyss Morgan & Crayder. All rights reserved.                                                                  *
 *                                                                                                                                *
 * Download: https://github.com/AbyssMorgan/SA-MP/tree/master/include/core                                                        *
 *                                                                                                                                *
 * This is Beta Version!                                                                                                          *
 *                                                                                                                                *
 * Plugins: Streamer, SScanf                                                                                                      *
 * Modules: None                                                                                                                  *
 *                                                                                                                                *
 * File Version: 1.4.2                                                                                                            *
 * SA:MP Version: 0.3.7                                                                                                           *
 * Streamer Version: 2.8.2                                                                                                        *
 * SScanf Version: 2.8.2                                                                                                          *
 *                                                                                                                                *
 * Functions:                                                                                                                     *
 * SAOI:CreateSAOIFile(const name[],author[],version[],description[] = "");                                                       *
 * SAOI:GetSAOIFileHeader(const name[],author[],version[],description[]);                                                         *
 * SAOI:SaveDynamicObject(objectid,const name[]);                                                                                 *
 * SAOI:LoadObjectImage(const name[],&object_cnt=0,&material_cnt=0,&material_text_cnt=0,&load_time=0,bool:use_saoi_area=false);   *
 * SAOI:SAOIHeaderCopy(const input[],const output[]);                                                                             *
 * SAOI:SetSAOIBumperIP(const name[],server_ip[]);                                                                                *
 * SAOI:SetSAOIBumperPort(const name[],server_port);                                                                              *
 * bool:UnloadObjectImage(&SAOI:index);                                                                                           *
 * bool:GetSAOILoadData(SAOI:index,name[],&object_cnt=0,&material_cnt=0,&material_text_cnt=0,&load_time=0,&active_tick=0);        *
 * bool:IsSAOIFileLoaded(const name[],&SAOI:index=INVALID_SAOI_FILE);                                                             *
 * CountObjectsForIndex(SAOI:index);                                                                                              *
 * CountSAOIFileLoaded();                                                                                                         *
 * GetSAOIActiveTime(SAOI:index);                                                                                                 *
 * bool:IsSAOISlotFree(SAOI:index);                                                                                               *
 *                                                                                                                                *
 * Extended Functions:                                                                                                            *
 * SAOIToInt(SAOI:variable);                                                                                                      *
 * SAOI:FindFreeSAOIID();                                                                                                         *
 *                                                                                                                                *
 **********************************************************************************************************************************
 *                                                                                                                                *
 * Support:                                                                                                                       *
 * - CreateDynamicObject for all params                                                                                           *
 * - Extra parameter: Streamer_ToggleItemAntiAreas, SetDynamicObjectNoCameraCol                                                   *
 * - SetDynamicObjectMaterial for all materialindex                                                                               *
 * - SetDynamicObjectMaterialText for all materialindex                                                                           *
 * - Unique compressed file structure (Dynamic moving datagram)                                                                   *
 * - Encrypted information: Author, Version, Description                                                                          *
 * - Ability to load, unload the selected files                                                                                   *
 * - Compression performance. Ratio ~33%                                                                                          *
 *                                                                                                                                *
 **********************************************************************************************************************************/

/*
//Check Version SAOI.inc
#if !defined _SAOI_VERSION
	#error You need SAOI.inc v1.4.1
#elseif !defined SAOI_LOADER_VERSION
	#error Update you SAOI.inc to v1.4.1
#elseif (SAOI_LOADER_VERSION < 10401)
	#error Update you SAOI.inc to v1.4.1
#endif
*/


#if !defined Streamer_AppendArrayData
	#error Unknown Streamer Version
#endif

#if !defined sscanf
	#error [ADM] Unknown SScanf Version
#endif

#if defined _SAOI_VERSION
	#endinput
#endif
#define _SAOI_VERSION

#define SAOI_LOADER_VERSION 				(10401)			//a.b[c] 10000*a+100*b+c

#define SAOI::								SAOI:

#define SAOI_HEADER_KEY						"SAOI 1.1 ADM"	//You can never change !!!

#define INVALID_SAOI_FILE					(SAOI:0)		//You can never change !!!
#define SAOI_EXTRA_ID_OFFSET				(1000000)		//You can never change !!!

#define MAX_SAOI_FILE_SIZE					(68157440)		//64 MB
#define MAX_SAOI_FILE						(SAOI:512)		//more ? why not
#define MAX_SAOI_NAME_SIZE					(64)
#define MAX_SAOI_AREA						(256)

#define MAX_SAOI_AUTHOR_SIZE 				(32)			//Max Value: 255 (auto resize header, compatible with all version) 
#define MAX_SAOI_VERSION_SIZE 				(32)			//Max Value: 255 (auto resize header, compatible with all version)
#define MAX_SAOI_DESCRIPTION_SIZE 			(128)			//Max Value: 255 (auto resize header, compatible with all version)

#define MAX_FONT_NAME 						(32)			//Max Value: 255 (These limits can be changed according to the San Andreas)
#define MAX_TXD_NAME						(32)			//Max Value: 255 (These limits can be changed according to the San Andreas)
#define MAX_TEXTURE_NAME					(32)			//Max Value: 255 (These limits can be changed according to the San Andreas)
#define MAX_TEXT_NAME						(2048)			//Max Value: 65535 (These limits can be changed according to the San Andreas)

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

#define MAX_ARG_COUNT						(14)			//argument number 1 - 14 !!
#define PARSE_STEP_ARG_COUNT				(0)
#define PARSE_STEP_ARG_START				(1)
#define PARSE_STEP_ARG_END					(MAX_ARG_COUNT)
#define PARSE_STEP_MATERIAL_HEAD			(MAX_ARG_COUNT+1)
#define PARSE_STEP_MATERIAL_START			(MAX_ARG_COUNT+2)
#define PARSE_STEP_MATERIAL_END				(MAX_ARG_COUNT+17)
#define PARSE_STEP_MATERIAL_TEXT_HEAD		(MAX_ARG_COUNT+18)
#define PARSE_STEP_MATERIAL_TEXT_START		(MAX_ARG_COUNT+19)
#define PARSE_STEP_MATERIAL_TEXT_END		(MAX_ARG_COUNT+34)

#define OBJECT_FLAG_ANTI_AREA				(0)
#define OBJECT_FLAG_NO_CAMERA_COL			(1)

#define SAOI_BUMPER_IP						(201)
#define SAOI_BUMPER_PORT					(202)

#define SAOIToInt(%0)						(_:%0)

#define SAOI_Comp(%0,%1)					((((%0)+128) & 0xFF) != (%1))


//BitFunctions.inc
#define SAOI_GetValueBit(%0,%1)				((%0) >>> (%1) & 0x01)
#define SAOI_SetValueBit(%0,%1,%2)			((%0) = (((%0) & ~(0x01 << (%1))) | ((0x01 << (%1))*(%2))))

#define SAOI_ExtractValue(%0,%1,%2,%3,%4)	((%1) = (((%0) & 0xFF000000) >>> 24),(%2) = (((%0) & 0x00FF0000) >>> 16),(%3) = (((%0) & 0x0000FF00) >>> 8),(%4) = ((%0) & 0x000000FF))
#define SAOI_ExtractFloat(%0,%1,%2,%3,%4)	((%1) = (((_:%0) & 0xFF000000) >>> 24),(%2) = (((_:%0) & 0x00FF0000) >>> 16),(%3) = (((_:%0) & 0x0000FF00) >>> 8),(%4) = ((_:%0) & 0x000000FF))

#define SAOI_MergeValue(%0,%1,%2,%3,%4)		((%0) = (((%1) << 24) | ((%2) << 16) | ((%3) << 8) | (%4)))
#define SAOI_MergeFloat(%0,%1,%2,%3,%4)		((%0) = Float:(((%1) << 24) | ((%2) << 16) | ((%3) << 8) | (%4)))

#define SAOI_MergeValueEx(%1,%2,%3,%4)		(((%1) << 24) | ((%2) << 16) | ((%3) << 8) | (%4))
#define SAOI_MergeFloatEx(%1,%2,%3,%4)		(Float:(((%1) << 24) | ((%2) << 16) | ((%3) << 8) | (%4)))

#define SAOI_IntMod(%0)						(0xFF & (%0)+128)

#if !defined isnull
	#define isnull(%1) ((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
#endif

enum e_saoi {
	bool:saoi_status,
	saoi_name[MAX_SAOI_NAME_SIZE],
	saoi_object_cnt,
	saoi_material_cnt,
	saoi_material_text_cnt,
	saoi_load_time,
	saoi_active_tick
}

new bool:SAOIFile[SAOI:MAX_SAOI_FILE][e_saoi],
	SAOIObjectArea[MAX_SAOI_AREA];

stock bool:IsSAOIFileLoaded(const name[],&SAOI:index=INVALID_SAOI_FILE){
	new tmp_saoi_name[MAX_SAOI_NAME_SIZE];
	format(tmp_saoi_name,MAX_SAOI_NAME_SIZE,"%s",name);
	for(new i = strlen(tmp_saoi_name)-1; i >= 0; i--){
		if(tmp_saoi_name[i] == '.'){
			tmp_saoi_name[i] = EOS;
			break;
		}
	}
	for(new SAOI:i = SAOI:1; i < MAX_SAOI_FILE; i = SAOI:(SAOIToInt(i)+1)){
		if(SAOIFile[i][saoi_status]){
			if(!strcmp(tmp_saoi_name,SAOIFile[i][saoi_name],true)){
				index = i;
				return true;
			}
		}
	}
	return false;
}

stock CountSAOIFileLoaded(){
	new cnt = 0;
	for(new SAOI:i = SAOI:1; i < MAX_SAOI_FILE; i = SAOI:(SAOIToInt(i)+1)){
		if(SAOIFile[i][saoi_status]) cnt++;
	}
	return cnt;
}

stock bool:IsSAOISlotFree(SAOI:index){
	if(!SAOIFile[index][saoi_status]) return true;
	return false;
}

stock SAOI:FindFreeSAOIID(){
	for(new SAOI:i = SAOI:1; i < MAX_SAOI_FILE; i = SAOI:(SAOIToInt(i)+1)){
		if(!SAOIFile[i][saoi_status]) return i;
	}
	return INVALID_SAOI_FILE;
}

stock bool:GetSAOILoadData(SAOI:index,name[],&object_cnt=0,&material_cnt=0,&material_text_cnt=0,&load_time=0,&active_tick=0){
	if(!SAOIFile[index][saoi_status]) return false;
	object_cnt =		SAOIFile[index][saoi_object_cnt];
	material_cnt =		SAOIFile[index][saoi_material_cnt];
	material_text_cnt =	SAOIFile[index][saoi_material_text_cnt];
	load_time =			SAOIFile[index][saoi_load_time];
	active_tick =		SAOIFile[index][saoi_active_tick];
	format(name,MAX_SAOI_NAME_SIZE,"%s",SAOIFile[index][saoi_name]);
	return true;
}

stock SAOI:CreateSAOIFile(const name[],author[],version[],description[] = ""){
	if(fexist(name)) return SAOI_ERROR_OUTPUT_EXIST;
	if(strfind(name,".saoi",true) == -1) return SAOI_ERROR_OUTPUT_EXTENSION;
	new File:outf = fopen(name,io_readwrite);
	if(!outf) return SAOI_ERROR_OUTPUT_NOT_OPEN;
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
	fclose(outf);
	return SAOI_ERROR_SUCCESS;
}

stock SAOI:SaveDynamicObject(objectid,const name[]){
	if(!IsValidDynamicObject(objectid)) return SAOI_ERROR_INVALID_OBJECTID;
	if(!fexist(name)) return SAOI_ERROR_OUTPUT_NOT_EXIST;
	if(strfind(name,".saoi",true) == -1) return SAOI_ERROR_OUTPUT_EXTENSION;
	new File:outf = fopen(name,io_append);
	if(!outf) return SAOI_ERROR_OUTPUT_NOT_OPEN;
	
	new modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, worldid, interiorid, Float:streamdistance, Float:drawdistance, areaid, priority,
		arg_count = PARSE_STEP_ARG_END, material_used = 0, material_text_used = 0, object_flag;
	
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
	
	if(Streamer_IsToggleItemAntiAreas(STREAMER_TYPE_OBJECT,objectid)){
		SAOI_SetValueBit(object_flag,OBJECT_FLAG_ANTI_AREA,1);
	}
	if(GetDynamicObjectNoCameraCol(objectid)){
		SAOI_SetValueBit(object_flag,OBJECT_FLAG_NO_CAMERA_COL,1);
	}
	
	//Count Arg
	for(new i = PARSE_STEP_ARG_END; i > 7; i--){
		switch(i){
			case 14: {
				if(object_flag == 0){
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
				if(drawdistance == 0.0){
					arg_count--;
				} else {
					break;
				}
			}
			case 10: {
				if(streamdistance == 300.0){
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
		SAOI_ExtractValue(object_flag,int1,int2,int3,int4);
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
	
	for(new i = 0; i < 16; i++){
		if(SAOI_GetValueBit(material_used,i) == 1){
			new mid, txdname[MAX_TXD_NAME], texturename[MAX_TEXTURE_NAME], materialcolor;
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
	
	for(new i = 0; i < 16; i++){
		if(SAOI_GetValueBit(material_text_used,i) == 1){
			new text[MAX_TEXT_NAME], materialsize, fontface[MAX_FONT_NAME], fontsize, bold, fontcolor, backcolor, textalignment;
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

stock SAOI:SetSAOIBumperIP(const name[],server_ip[]){
	if(!fexist(name)) return SAOI_ERROR_OUTPUT_NOT_EXIST;
	if(strfind(name,".saoi",true) == -1) return SAOI_ERROR_OUTPUT_EXTENSION;
	new File:outf = fopen(name,io_append);
	if(!outf) return SAOI_ERROR_OUTPUT_NOT_OPEN;
	
	new serv_ipsum[4], saoi_ipsum[4];
	sscanf(server_ip,"p<.>dddd",serv_ipsum[0],serv_ipsum[1],serv_ipsum[2],serv_ipsum[3]);
	
	saoi_ipsum[0] = ((serv_ipsum[3]+128) & 0xFF);
	saoi_ipsum[1] = ((serv_ipsum[2]+128) & 0xFF);
	saoi_ipsum[2] = ((serv_ipsum[1]+128) & 0xFF);
	saoi_ipsum[3] = ((serv_ipsum[0]+128) & 0xFF);
	
	fputchar(outf,SAOI_BUMPER_IP,false);
	for(new i = 0; i < 4; i++){
		fputchar(outf,saoi_ipsum[i],false);
	}

	fclose(outf);
	return SAOI_ERROR_SUCCESS;
}

stock SAOI:SetSAOIBumperPort(const name[],server_port){
	if(!fexist(name)) return SAOI_ERROR_OUTPUT_NOT_EXIST;
	if(strfind(name,".saoi",true) == -1) return SAOI_ERROR_OUTPUT_EXTENSION;
	new File:outf = fopen(name,io_append);
	if(!outf) return SAOI_ERROR_OUTPUT_NOT_OPEN;
	
	new serv_portsum[4], saoi_portsum[4];
	SAOI_ExtractValue(server_port,serv_portsum[0],serv_portsum[1],serv_portsum[2],serv_portsum[3]);
	
	saoi_portsum[0] = ((serv_portsum[3]+128) & 0xFF);
	saoi_portsum[1] = ((serv_portsum[2]+128) & 0xFF);
	saoi_portsum[2] = ((serv_portsum[1]+128) & 0xFF);
	saoi_portsum[3] = ((serv_portsum[0]+128) & 0xFF);
	
	fputchar(outf,SAOI_BUMPER_PORT,false);
	for(new i = 0; i < 4; i++){
		fputchar(outf,saoi_portsum[i],false);
	}

	fclose(outf);
	return SAOI_ERROR_SUCCESS;
}

stock SAOI:GetSAOIFileHeader(const name[],author[],version[],description[]){
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

stock SAOI:SAOIHeaderCopy(const input[],const output[]){
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

stock SAOI:LoadObjectImage(const name[],&object_cnt=0,&material_cnt=0,&material_text_cnt=0,&load_time=0,bool:use_saoi_area=false){
	object_cnt = 0, material_cnt = 0, material_text_cnt = 0, load_time = 0;
	new SAOI:index = FindFreeSAOIID();
	if(index == INVALID_SAOI_FILE) return SAOI_ERROR_NOT_ENOUGH_CAPACITY;
	
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
	new parse_step, bool:parse_header, author[MAX_SAOI_AUTHOR_SIZE], version[MAX_SAOI_VERSION_SIZE], description[MAX_SAOI_DESCRIPTION_SIZE];
	
	SAOIFile[index][saoi_status] = true;
	format(SAOIFile[index][saoi_name],MAX_SAOI_NAME_SIZE,"%s",name);
	for(new i = strlen(SAOIFile[index][saoi_name])-1; i >= 0; i--){
		if(SAOIFile[index][saoi_name][i] == '.'){
			SAOIFile[index][saoi_name][i] = EOS;
			break;
		}
	}
	
	new modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, worldid = -1, interiorid = -1, Float:streamdistance = 300.0, Float:drawdistance = 0.0, areaid = -1, priority = 0,
		arg_count = 0, material_used = 0, material_text_used = 0, objectid, object_flag = 0;
	
	while(idx < asize){
		if(!parse_header){
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
				
				parse_header = true;
			} else {
				fclose(inpf);
				return SAOI_ERROR_INVALID_HEADER;
			}
		} else {
			if(parse_step == PARSE_STEP_ARG_COUNT){
				//Get Arg Count
				arg_count = fgetchar(inpf,0,false), idx++;
				if(arg_count > MAX_ARG_COUNT){
					switch(arg_count){
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
						default: {
							fclose(inpf);
							return SAOI_ERROR_INVALID_ARG_COUNT;
						}
					}
				}
				//Reset Data
				objectid = 0, material_used = 0, material_text_used = 0, worldid = -1, interiorid = -1, streamdistance = 300.0,
				drawdistance = 0.0, areaid = -1, priority = 0, object_flag = 0;
			} else if(parse_step >= PARSE_STEP_ARG_START && parse_step <= arg_count){
				switch(parse_step){
					case 1: {
						SAOI_MergeValue(modelid,0,0,fgetchar(inpf,0,false),fgetchar(inpf,0,false));
						idx += 2;
					}
					case 2: {
						SAOI_MergeFloat(x,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
						idx += 4;
					}
					case 3: {
						SAOI_MergeFloat(y,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
						idx += 4;
					}
					case 4: {
						SAOI_MergeFloat(z,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
						idx += 4;
					}
					case 5: {
						SAOI_MergeFloat(rx,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
						idx += 4;
					}
					case 6: {
						SAOI_MergeFloat(ry,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
						idx += 4;
					}
					case 7: {
						SAOI_MergeFloat(rz,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
						idx += 4;
					}
					case 8: {
						SAOI_MergeValue(worldid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
						idx += 4;
					}
					case 9: {
						SAOI_MergeValue(interiorid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
						idx += 4;
					}
					case 10: {
						SAOI_MergeFloat(streamdistance,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
						idx += 4;
					}
					case 11: {
						SAOI_MergeFloat(drawdistance,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
						idx += 4;
					}
					case 12: {
						SAOI_MergeValue(areaid,fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false),fgetchar(inpf,0,false));
						idx += 4;
					}
					case 13: {
						SAOI_MergeValue(priority,0,0,0,fgetchar(inpf,0,false));
						idx += 1;
					}
					case 14: {
						SAOI_MergeValue(object_flag,0,0,0,fgetchar(inpf,0,false));
						idx += 1;
					}
				}
			} else if(parse_step == PARSE_STEP_MATERIAL_HEAD){
				SAOI_MergeValue(material_used,0,0,fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				idx += 2;
			} else if(parse_step >= PARSE_STEP_MATERIAL_START && parse_step <= PARSE_STEP_MATERIAL_END){
				if(SAOI_GetValueBit(material_used,(parse_step-PARSE_STEP_MATERIAL_START)) == 1){
					new txdname[MAX_TXD_NAME], texturename[MAX_TEXTURE_NAME], materialcolor, txdsize, texturenamesize;
					
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
					
					SetDynamicObjectMaterial(objectid,(parse_step-PARSE_STEP_MATERIAL_START),modelid,txdname,texturename,materialcolor);
					material_cnt++;
				}
			} else if(parse_step == PARSE_STEP_MATERIAL_TEXT_HEAD){
				SAOI_MergeValue(material_text_used,0,0,fgetchar(inpf,0,false),fgetchar(inpf,0,false));
				idx += 2;
			} else if(parse_step >= PARSE_STEP_MATERIAL_TEXT_START && parse_step <= PARSE_STEP_MATERIAL_TEXT_END){
				if(SAOI_GetValueBit(material_text_used,(parse_step-PARSE_STEP_MATERIAL_TEXT_START)) == 1){
					new text[MAX_TEXT_NAME], fontface[MAX_FONT_NAME], textsize, materialsize, fontfacesize, bold, fontcolor, backcolor,
						textalignment, fontsize;
					
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
					
					SetDynamicObjectMaterialText(objectid,(parse_step-PARSE_STEP_MATERIAL_TEXT_START),text,materialsize,fontface,fontsize,bold,fontcolor,backcolor,textalignment);
					material_text_cnt++;
				}
			}
			
			if(parse_step == arg_count){
				if(areaid == -1 || !use_saoi_area){
					objectid = CreateDynamicObject(modelid,x,y,z,rx,ry,rz,worldid,interiorid,-1,streamdistance,drawdistance,areaid,priority);
				} else {
					objectid = CreateDynamicObject(modelid,x,y,z,rx,ry,rz,worldid,interiorid,-1,streamdistance,drawdistance,SAOIObjectArea[areaid],priority);
				}
				Streamer_SetIntData(STREAMER_TYPE_OBJECT,objectid,E_STREAMER_EXTRA_ID,SAOI_EXTRA_ID_OFFSET+SAOIToInt(index)); //identify objects
				if(SAOI_GetValueBit(object_flag,OBJECT_FLAG_ANTI_AREA) == 1){
					Streamer_ToggleItemAntiAreas(STREAMER_TYPE_OBJECT,objectid,1);
				}
				if(SAOI_GetValueBit(object_flag,OBJECT_FLAG_NO_CAMERA_COL) == 1){
					SetDynamicObjectNoCameraCol(objectid);
				}
				object_cnt++;
				parse_step = PARSE_STEP_ARG_END;
			} else if(parse_step == PARSE_STEP_MATERIAL_TEXT_END){
				parse_step = -1;
			}
			parse_step++;
		}
	}
	fclose(inpf);
	
	load_time = GetTickCount()-NTTime;
	
	
	SAOIFile[index][saoi_object_cnt] = object_cnt;
	SAOIFile[index][saoi_material_cnt] = material_cnt;
	SAOIFile[index][saoi_material_text_cnt] = material_text_cnt;
	SAOIFile[index][saoi_load_time] = load_time;
	SAOIFile[index][saoi_active_tick] = GetTickCount();
	
	new buffer[256];
	format(buffer,sizeof buffer,"File %s has been loaded in %d ms",name,load_time);
	printf(buffer);
	format(buffer,sizeof buffer,"Author: %s Version: %s Objects: %d Material: %d Material Text: %d",author,version,object_cnt,material_cnt,material_text_cnt);
	printf(buffer);
	if(!isnull(description)){
		format(buffer,sizeof buffer,"Description: %s",description);
		printf(buffer);
	}
	return index;
}

stock bool:UnloadObjectImage(&SAOI:index){
	if(!SAOIFile[index][saoi_status]) return false;
	new max_idx = SAOIFile[index][saoi_object_cnt], i = 1, j = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT);
	while(i <= j && max_idx > 0){
		if(IsValidDynamicObject(i)){
				if(Streamer_GetIntData(STREAMER_TYPE_OBJECT,i,E_STREAMER_EXTRA_ID) == (SAOI_EXTRA_ID_OFFSET+SAOIToInt(index))){
				max_idx--;
				DestroyDynamicObject(i);
			}
		}
		i++;
	}
	SAOIFile[index][saoi_status] = false;
	SAOIFile[index][saoi_name] = EOS;
	SAOIFile[index][saoi_object_cnt] = 0;
	SAOIFile[index][saoi_material_cnt] = 0;
	SAOIFile[index][saoi_material_text_cnt] = 0;
	SAOIFile[index][saoi_load_time] = 0;
	SAOIFile[index][saoi_active_tick] = 0;
	index = INVALID_SAOI_FILE;
	return true;
}

stock CountObjectsForIndex(SAOI:index){
	if(!SAOIFile[index][saoi_status]) return 0;
	return SAOIFile[index][saoi_object_cnt];
}

stock GetSAOIActiveTime(SAOI:index){
	return (GetTickCount()-SAOIFile[index][saoi_active_tick]);
}

//EOF