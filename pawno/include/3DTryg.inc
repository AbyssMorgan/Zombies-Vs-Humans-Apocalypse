/**********************************************************************************************************************************
 *                                                                                                                                *
 *                                                       3D Tryg Functions                                                        *
 *                                                                                                                                *
 * Copyright © 2016 Abyss Morgan. All rights reserved.                                                                            *
 *                                                                                                                                *
 * Download: https://github.com/AbyssMorgan/SA-MP/tree/master/include/SAM                                                         *
 *                                                                                                                                *
 * File Version: 2.5C                                                                                                             *
 *                                                                                                                                *
 * Functions:                                                                                                                     *
 * Float:sqrtN(Float:value,Float:exponent);                                                                                       *
 * abs(value);                                                                                                                    *
 * power(value,Float:exponent);                                                                                                   *
 * Float:ctg(Float:value,anglemode:mode=radian);                                                                                  *
 * Float:secans(Float:value,anglemode:mode=radian);                                                                               *
 * Float:cosecans(Float:value,anglemode:mode=radian);                                                                             *
 * single_clock(max,id);                                                                                                          *
 * even_clock(max,id);                                                                                                            *
 * uneven_clock(max,id);                                                                                                          *
 * IsEven(value);                                                                                                                 *
 * GetRandomHit(Float:x,Float:y,Float:z,range,&Float:tx,&Float:ty,&Float:tz);                                                     *
 * Float:GetDistanceBetweenPoints1D(Float:x1,Float:x2);                                                                           *
 * Float:GetDistanceBetweenPoints2D(Float:x1,Float:y1,Float:x2,Float:y2);                                                         *
 * Float:GetDistanceBetweenPoints3D(Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2);                                       *
 * NLTZ(value);              //NotLessThanZero                                                                                    *
 * NMTZ(value);              //NotMoreThanZero                                                                                    *
 * Float:NLTZF(Float:value); //NotLessThanZeroFloat                                                                               *
 * Float:NMTZF(Float:value); //NotMoreThanZeroFloat                                                                               *
 * CompRotation(rotation,&crotation=0); //CompressRotation                                                                        *
 * Float:CompRotationFloat(Float:rotation,&Float:crotation=0.0); //CompressRotationFloat                                          *
 * GetPointInFront2D(Float:x,Float:y,Float:rz,Float:radius,&Float:tx,&Float:ty);                                                  *
 * Float:GetPointInFrontOfPlayer(playerid,&Float:tx,&Float:ty,Float:radius);                                                      *
 * Float:GetPointInFrontOfCamera2D(playerid,&Float:tx,&Float:ty,Float:radius);                                                    *
 * GetPointInFrontOfCamera3D(playerid,&Float:tx,&Float:ty,&Float:tz,Float:radius,&Float:rx=0.0,&Float:rz=0.0);                    *
 * GetPointInFront3D(Float:x,Float:y,Float:z,Float:rx,Float:rz,Float:radius,&Float:tx,&Float:ty,&Float:tz);                       *
 * GetRotationFor2Point2D(Float:x,Float:y,Float:tx,Float:ty,&Float:rz);                                                           *
 * GetRotationFor2Point3D(Float:x,Float:y,Float:z,Float:tx,Float:ty,Float:tz,&Float:rx,&Float:rz);                                *
 * GetRandomClockPos(Float:x,Float:y,Float:z,Float:radius,&Float:tx,&Float:ty,&Float:tz,&Float:trz,Float:rz = -1000.0);           *
 * GetRandomPointInCube(Float:minx,Float:miny,Float:minz,Float:maxx,Float:maxy,Float:maxz,&Float:x,&Float:y,&Float:z);            *
 * Float:ShiftDegreeToRadian(Float:deg);                                                                                          *
 * Float:ShiftDegreeToRadianEx(Float:deg);                                                                                        *
 * Float:ShiftDegreeToGrades(Float:deg);                                                                                          *
 * Float:ShiftRadianToDegree(Float:rad);                                                                                          *
 * Float:ShiftRadianToDegreeEx(Float:rad);                                                                                        *
 * Float:ShiftRadianToGrades(Float:rad);                                                                                          *
 * Float:ShiftGradesToDegree(Float:grad);                                                                                         *
 * Float:ShiftGradesToRadian(Float:grad);                                                                                         *
 * ConvertMTARaceRotation(Float:rotation1,Float:rotation2,Float:rotation3,&Float:rx,&Float:ry,&Float:rz);                         *
 * ConvertToMTARaceRotation(Float:rx,Float:ry,Float:rz,&Float:rotation1,&Float:rotation2,&Float:rotation3);                       *
 * GetMoveTime(Float:x,Float:y,Float:z,Float:tx,Float:ty,Float:tz,Float:speed,&rtime);                                            *
 * Float:GetSpeedForMoveTime(Float:x,Float:y,Float:z,Float:tx,Float:ty,Float:tz,&Float:speed,rtime);                              *
 * GetVehicleRotation(vehicleid,&Float:rx,&Float:ry,&Float:rz);                                                                   *
 * Float:GetPointInFrontOfVehicle2D(vehicleid,&Float:tx,&Float:ty,Float:radius);                                                  *
 * GetPointInFrontOfVehicle3D(vehicleid,&Float:tx,&Float:ty,&Float:tz,Float:radius,&Float:rx=0.0,&Float:rz=0.0);                  *
 * GetPlayerCameraRotation(playerid,&Float:rx,&Float:rz);                                                                         *
 * Float:GetPlayerCameraZAngle(playerid,&Float:rz=0.0);                                                                           *
 * GetPointFor2Point2D(Float:x1,Float:y1,Float:x2,Float:y2,Float:percent_size,&Float:tx,&Float:ty);                               *
 * GetPointFor2Point3D(Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2,Float:percent_size,&Float:tx,&Float:ty,&Float:tz);   *
 * ShiftVectorToRotation(Float:vx,Float:vy,Float:vz,&Float:rx,&Float:rz);                                                         *
 * ShiftRotationToVector(Float:rx,Float:rz,&Float:vx,&Float:vy,&Float:vz);                                                        *
 * bool:IsPointBetween2Points2D(Float:px,Float:py,Float:xA,Float:yA,Float:xB,Float:yB);                                           *
 * bool:IsPointBetween2Points3D(Float:px,Float:py,Float:pz,Float:xA,Float:yA,Float:zA,Float:xB,Float:yB,Float:zB);                *
 * bool:IsPointNearly2Points2D(Float:px,Float:py,Float:xA,Float:yA,Float:xB,Float:yB,Float:maxdist);                              *
 * bool:IsPointNearly2Points3D(Float:px,Float:py,Float:pz,Float:xA,Float:yA,Float:zA,Float:xB,Float:yB,Float:zB,Float:maxdist);   *
 * bool:IsPointInCylinder(Float:px,Float:py,Float:pz,Float:xA,Float:yA,Float:zA,Float:xB,Float:yB,Float:zB,Float:maxdist);        *
 * bool:IsProbable(chance);                                                                                                       *
 * GetGroundRotation(Float:x,Float:y,Float:size,&Float:rx,&Float:ry);                                                             *
 * GetPointInFrontOnGround(Float:x,Float:y,Float:z,Float:rx,Float:rz,&Float:tx,&Float:ty,&Float:tz,Float:max_distance);           *
 * Float:GetPlayerTargetAngle(playerid,Float:x,Float:y,&Float:rz=0.0);                                                            *
 * Float:SetPlayerTargetAngle(playerid,Float:x,Float:y,&Float:rz=0.0);                                                            *
 *                                                                                                                                *
 * Deprecated Functions:                                                                                                          *
 * GetXYInFrontOfPlayer       -> GetPointInFrontOfPlayer                                                                          *
 * GetPointInFront            -> GetPointInFront3D                                                                                *
 * GetPointInFrontOfCamera    -> GetPointInFrontOfCamera3D                                                                        *
 * GetDistanceBetweenPoints   -> GetDistanceBetweenPoints3D                                                                       *
 * CompressRotation           -> CompRotation                                                                                     *
 * CompressRotationFloat      -> CompRotationFloat                                                                                *
 *                                                                                                                                *
 * Old prototype:                                                                                                                 *
 * GetAngle                   -> GetPlayerTargetAngle / SetPlayerTargetAngle / GetRotationFor2Point2D                             *
 *                                                                                                                                *
 **********************************************************************************************************************************/

/*
//Check Version 3DTryg.inc
#if !defined _3D_Tryg
	#error You need 3DTryg.inc v2.5C
#elseif !defined Tryg3D_Version
	#error Update you 3DTryg.inc to v2.5C
#elseif (Tryg3D_Version < 20503)
	#error Update you 3DTryg.inc to v2.5C
#endif
*/

#if defined _3D_Tryg
	#endinput
#endif
#define _3D_Tryg

#define Tryg3D_Version									(20503) //a.b[c] 10000*a+100*b+c

#if defined _Map_Andreas_Ex
	#define _3DTryg_MapAndreasFindZ						MapAndreasFindZ
#else
	#define _3DTryg_MapAndreasFindZ						MapAndreas_FindZ_For2DCoord
#endif

#if !defined FLOAT_PI
	#define FLOAT_PI		 							(3.14159265358979323846)
#endif

#define ctg(%0,%1)										(1.0/floattan((%0),(%1)))
#define secans(%0,%1)									(1.0/floatcos((%0),(%1)))
#define cosecans(%0,%1)									(1.0/floatsin((%0),(%1)))
#define abs(%0)											(((%0) < 0)?(-(%0)):((%0)))

#define single_clock(%1,%2)								((360.0/(%1))*(%2))
#define even_clock(%1,%2)								((360.0/(%1))*(2*(%2)))
#define uneven_clock(%1,%2)								((360.0/(%1))*((2*(%2))-1))

#define	sqrtN(%0,%1)									floatpower((%0),(1.0/(%1)))

#define GetDistanceBetweenPoints1D(%1,%2)				VectorSize((%1)-(%2),0.0,0.0)
#define GetDistanceBetweenPoints2D(%1,%2,%3,%4)			VectorSize((%1)-(%3),(%2)-(%4),0.0)
#define GetDistanceBetweenPoints3D(%1,%2,%3,%4,%5,%6)	VectorSize((%1)-(%4),(%2)-(%5),(%3)-(%6))

#define NLTZ(%0)										(((%0) < 0)?(0):(%0))
#define NMTZ(%0)										(((%0) > 0)?(0):(%0))
#define NLTZF(%0)										(((%0) < 0.0)?(0.0):(%0))
#define NMTZF(%0)										(((%0) > 0.0)?(0.0):(%0))

#define IsEven(%0)										((((%0) % 2) == 0)?(true):(false))
#define power(%0,%1)									(floatround(floatpower((%0),(%1))))

#define ShiftDegreeToRadian(%0)							((%0)*((FLOAT_PI*2)/360.0))
#define ShiftDegreeToRadianEx(%0)						((360.0-CompRotationFloat(%0))*(-((FLOAT_PI*2)/360.0)))
#define ShiftDegreeToGrades(%0)							((%0)*(10.0/9.0))
#define ShiftRadianToDegree(%0)							((%0)/((FLOAT_PI*2)/360.0))
#define ShiftRadianToDegreeEx(%0) 						(CompRotationFloat(floatabs(((%0)/((FLOAT_PI*2)/360.0))+360.0)))
#define ShiftRadianToGrades(%0)							(ShiftDegreeToGrades(ShiftRadianToDegree(%0)))
#define ShiftGradesToDegree(%0)							((%0)*0.9)
#define ShiftGradesToRadian(%0)							(ShiftDegreeToRadian(ShiftGradesToDegree(%0)))

#define ShiftRotationToVector(%0,%1,%2,%3,%4)			(GetPointInFront3D(0.0,0.0,0.0,(%0),(%1),1.0,(%2),(%3),(%4)))

//old code version made by Zoutdaxv (modified version)
#define GetRotationFor2Point2D(%0,%1,%2,%3,%4)			(CompRotationFloat((atan2((%3)-(%1),(%2)-(%0))-90.0),(%4)))

stock GetRandomHit(Float:x,Float:y,Float:z,range,&Float:tx,&Float:ty,&Float:tz){
	tx = x + (random(range * 2 + 1)-range);
	ty = y + (random(range * 2 + 1)-range);
	tz = z + (random(range * 2 + 1)-range);
}

stock CompRotation(rotation,&crotation=0){
	crotation = rotation;
	while(crotation < 0) crotation += 360;
	while(crotation >= 360) crotation -= 360;
	return crotation;
}

stock Float:CompRotationFloat(Float:rotation,&Float:crotation=0.0){
	crotation = rotation;
	while(crotation < 0.0) crotation += 360.0;
	while(crotation >= 360.0) crotation -= 360.0;
	return crotation;
}

//old code version
stock GetPointInFront2D(Float:x,Float:y,Float:rz,Float:radius,&Float:tx,&Float:ty){
	tx = x + (radius*floatsin(-rz,degrees));
	ty = y + (radius*floatcos(-rz,degrees));
}

//new code version support 3D made by Abyss Morgan
stock GetPointInFront3D(Float:x,Float:y,Float:z,Float:rx,Float:rz,Float:radius,&Float:tx,&Float:ty,&Float:tz){
	tx = x + (radius * floatsin(rx+90.0,degrees) * floatcos(rz+90.0,degrees));
	ty = y + (radius * floatsin(rx+90.0,degrees) * floatsin(rz+90.0,degrees));
	tz = z + (radius * floatcos(-rx+90.0,degrees));
}

//GetXYInFrontOfPlayer
stock Float:GetPointInFrontOfPlayer(playerid,&Float:tx,&Float:ty,Float:radius){
	new Float:rz;
	GetPlayerPos(playerid,tx,ty,rz);
	GetPlayerFacingAngle(playerid,rz);
	if(IsPlayerInAnyVehicle(playerid)){
		GetVehicleZAngle(GetPlayerVehicleID(playerid),rz);
	}
	GetPointInFront2D(tx,ty,rz,radius,tx,ty);
	return rz;
}

stock Float:GetPlayerCameraZAngle(playerid,&Float:rz=0.0){
	new Float:mx,Float:my,Float:mz;
	GetPlayerCameraFrontVector(playerid,mx,my,mz);
	CompRotationFloat((atan2(my,mx)-90.0),rz);
	return rz;
}

stock Float:GetPointInFrontOfCamera2D(playerid,&Float:tx,&Float:ty,Float:radius){
	new Float:x,Float:y,Float:rz;
	GetPlayerCameraPos(playerid,x,y,rz);
	GetPlayerCameraZAngle(playerid,rz);
	GetPointInFront2D(tx,ty,rz,radius,x,y);
	return rz;
}

stock GetPointInFrontOfCamera3D(playerid,&Float:tx,&Float:ty,&Float:tz,Float:radius,&Float:rx=0.0,&Float:rz=0.0){
	new Float:x,Float:y,Float:z;
	GetPlayerCameraPos(playerid,x,y,z);
	GetPlayerCameraRotation(playerid,rx,rz);
	GetPointInFront3D(x,y,z,rx,rz,radius,tx,ty,tz);
}

//new code version support 3D made by Abyss Morgan
stock GetRotationFor2Point3D(Float:x,Float:y,Float:z,Float:tx,Float:ty,Float:tz,&Float:rx,&Float:rz){
	new Float:radius = GetDistanceBetweenPoints3D(x,y,z,tx,ty,tz);
	if(radius > 0.0){
		CompRotationFloat(-(acos((tz-z)/radius)-90.0),rx);
		CompRotationFloat((atan2(ty-y,tx-x)-90),rz);
	} else {
		if(GetSVarInt("ADM:Logging:Disable") == 0){
			print("[ADM] Warring: Get the rotation wrong, identical points.");
		}
	}
}

//random clock pos
stock GetRandomClockPos(Float:x,Float:y,Float:z,Float:radius,&Float:tx,&Float:ty,&Float:tz,&Float:trz,Float:rz = -1000.0){
	new rand = random(360);
	if(rz == -1000.0) rz = rand;
	GetPointInFront3D(x,y,z,0.0,rz,radius,tx,ty,tz);
	CompRotationFloat(rz-180,trz);
}

stock GetRandomPointInCube(Float:minx,Float:miny,Float:minz,Float:maxx,Float:maxy,Float:maxz,&Float:x,&Float:y,&Float:z){
	x = random(floatround(floatsqroot(floatpower(minx-maxx,2)))+1)+minx;
	y = random(floatround(floatsqroot(floatpower(miny-maxy,2)))+1)+miny;
	z = random(floatround(floatsqroot(floatpower(minz-maxz,2)))+1)+minz;
}

stock ConvertMTARaceRotation(Float:rotation1,Float:rotation2,Float:rotation3,&Float:rx,&Float:ry,&Float:rz){
	rx = ShiftRadianToDegreeEx(rotation3);
	ry = ShiftRadianToDegreeEx(rotation2);
	rz = ShiftRadianToDegreeEx(rotation1);
}

stock ConvertToMTARaceRotation(Float:rx,Float:ry,Float:rz,&Float:rotation1,&Float:rotation2,&Float:rotation3){
	rotation3 = ShiftDegreeToRadianEx(rx);
	rotation2 = ShiftDegreeToRadianEx(ry);
	rotation1 = ShiftDegreeToRadianEx(rz);
}

stock GetMoveTime(Float:x,Float:y,Float:z,Float:tx,Float:ty,Float:tz,Float:speed,&rtime=0){
	if(speed <= 0.0){
		rtime = 0x7F800000;
	} else {
		new Float:dist = GetDistanceBetweenPoints3D(x,y,z,tx,ty,tz);
		rtime = floatround((dist/speed)*1000.0);
	}
	return rtime;
}

stock Float:GetSpeedForMoveTime(Float:x,Float:y,Float:z,Float:tx,Float:ty,Float:tz,&Float:speed,rtime){
	if(rtime/1000.0 <= 0.0){
		speed = Float:0x7F800000;
		if(GetSVarInt("ADM:Logging:Disable") == 0){
			print("[ADM] Warring: Get speed error, the wrong time.");
		}
	} else {
		speed = (GetDistanceBetweenPoints3D(x,y,z,tx,ty,tz)/(rtime/1000.0));
	}
	return speed;
}

//GetVehicleRotation Created by IllidanS4
stock GetVehicleRotation(vehicleid,&Float:rx,&Float:ry,&Float:rz){
	new Float:qw,Float:qx,Float:qy,Float:qz;
	GetVehicleRotationQuat(vehicleid,qw,qx,qy,qz);
	rx = asin(2*qy*qz-2*qx*qw);
	ry = -atan2(qx*qz+qy*qw,0.5-qx*qx-qy*qy);
	rz = -atan2(qx*qy+qz*qw,0.5-qx*qx-qz*qz);
}

stock Float:GetPointInFrontOfVehicle2D(vehicleid,&Float:tx,&Float:ty,Float:radius){
	new Float:rx,Float:ry,Float:rz,Float:x,Float:y;
	GetVehiclePos(vehicleid,x,y,rz);
	GetVehicleRotation(vehicleid,rx,ry,rz);
	GetPointInFront2D(x,y,rz,radius,tx,ty);
	return rz;
}

stock GetPointInFrontOfVehicle3D(vehicleid,&Float:tx,&Float:ty,&Float:tz,Float:radius,&Float:rx=0.0,&Float:rz=0.0){
	new Float:ry,Float:x,Float:y,Float:z;
	GetVehiclePos(vehicleid,x,y,z);
	GetVehicleRotation(vehicleid,rx,ry,rz);
	GetPointInFront3D(x,y,z,rx,rz,radius,tx,ty,tz);
}

stock ShiftVectorToRotation(Float:vx,Float:vy,Float:vz,&Float:rx,&Float:rz){
	CompRotationFloat(-(acos(vz)-90.0),rx);
	CompRotationFloat((atan2(vy,vx)-90.0),rz);
}

stock GetPlayerCameraRotation(playerid,&Float:rx,&Float:rz){
	new Float:mx,Float:my,Float:mz;
	GetPlayerCameraFrontVector(playerid,mx,my,mz);
	CompRotationFloat(-(acos(mz)-90.0),rx);
	CompRotationFloat((atan2(my,mx)-90.0),rz);
}

stock GetPointFor2Point2D(Float:x1,Float:y1,Float:x2,Float:y2,Float:percent_size,&Float:tx,&Float:ty){
	new Float:dist,Float:dest_dist,Float:rz;
	dist = GetDistanceBetweenPoints2D(x1,y1,x2,y2);
	dest_dist = (dist*(percent_size/100.0));
	GetRotationFor2Point2D(x1,y1,x2,y2,rz);
	GetPointInFront2D(x1,y1,rz,dest_dist,tx,ty);
}

stock GetPointFor2Point3D(Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2,Float:percent_size,&Float:tx,&Float:ty,&Float:tz){
	new Float:dist,Float:dest_dist,Float:rx,Float:rz;
	dist = GetDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2);
	dest_dist = (dist*(percent_size/100.0));
	GetRotationFor2Point3D(x1,y1,z1,x2,y2,z2,rx,rz);
	GetPointInFront3D(x1,y1,z1,rx,rz,dest_dist,tx,ty,tz);
}

stock bool:IsPointBetween2Points2D(Float:px,Float:py,Float:xA,Float:yA,Float:xB,Float:yB){
	new Float:dAP = GetDistanceBetweenPoints2D(xA,yA,px,py),
		Float:dBP = GetDistanceBetweenPoints2D(xB,yB,px,py),
		Float:dAB = GetDistanceBetweenPoints2D(xA,yA,xB,yB);
	if(dAB == (dAP + dBP)) return true;
	return false;
}

stock bool:IsPointBetween2Points3D(Float:px,Float:py,Float:pz,Float:xA,Float:yA,Float:zA,Float:xB,Float:yB,Float:zB){
	new Float:dAP = GetDistanceBetweenPoints3D(xA,yA,zA,px,py,pz),
		Float:dBP = GetDistanceBetweenPoints3D(xB,yB,zB,px,py,pz),
		Float:dAB = GetDistanceBetweenPoints3D(xA,yA,zA,xB,yB,zB);
	if(dAB == (dAP + dBP)) return true;
	return false;
}

//Orig: Greg James - gjames@NVIDIA.com SRC: http://www.flipcode.com/archives/Fast_Point-In-Cylinder_Test.shtml
stock bool:IsPointInCylinder(Float:px,Float:py,Float:pz,Float:xA,Float:yA,Float:zA,Float:xB,Float:yB,Float:zB,Float:maxdist){
	new Float:dx,Float:dy,Float:dz,Float:pdx,Float:pdy,Float:pdz,Float:dot,Float:dsq,Float:lengthsq;
	
	dx = xB - xA;
	dy = yB - yA; 
	dz = zB - zA;
	
	pdx = px - xA;
	pdy = py - yA;
	pdz = pz - zA;
	
	dot = pdx * dx + pdy * dy + pdz * dz;
	
	lengthsq = GetDistanceBetweenPoints3D(xA,yA,zA,xB,yB,zB);
	lengthsq = lengthsq*lengthsq;
	if(lengthsq <= 0.0 || maxdist <= 0.0){
		if(GetSVarInt("ADM:Logging:Disable") == 0){
			print("[ADM] Warring: Invalid lengthsq OR maxdist");
		}
		return false;
	}
	if(dot < 0.0 || dot > lengthsq){
		return false;
	} else {
		dsq = (pdx*pdx + pdy*pdy + pdz*pdz) - dot*dot/lengthsq;
		if(dsq <= (maxdist*maxdist)){
			return true;
		}
	}
	return false;
}

//Prototype function
stock bool:IsPointNearly2Points2D(Float:px,Float:py,Float:xA,Float:yA,Float:xB,Float:yB,Float:maxdist){
	new Float:dAP = GetDistanceBetweenPoints2D(xA,yA,px,py),
		Float:dBP = GetDistanceBetweenPoints2D(xB,yB,px,py),
		Float:dAB = GetDistanceBetweenPoints2D(xA,yA,xB,yB);
	if(dAB <= (dAP + dBP) <= (dAB+(maxdist))) return true;
	return false;
}

//Prototype function
stock bool:IsPointNearly2Points3D(Float:px,Float:py,Float:pz,Float:xA,Float:yA,Float:zA,Float:xB,Float:yB,Float:zB,Float:maxdist){
	new Float:dAP = GetDistanceBetweenPoints3D(xA,yA,zA,px,py,pz),
		Float:dBP = GetDistanceBetweenPoints3D(xB,yB,zB,px,py,pz),
		Float:dAB = GetDistanceBetweenPoints3D(xA,yA,zA,xB,yB,zB);
	if(dAB <= (dAP + dBP) <= (dAB+(maxdist))) return true;
	return false;
}

stock bool:IsProbable(chance){
	if(chance <= 0) return false;
	if(chance >= 100) return true;
	if((random(100)+1) <= chance) return true;
	return false;
}

#if defined MapAndreas_FindZ_For2DCoord
	stock GetGroundRotation(Float:x,Float:y,Float:size,&Float:rx,&Float:ry){
		new Float:tpx1,Float:tpy1,Float:tpz1,
			Float:tpx2,Float:tpy2,Float:tpz2,
			Float:tmp;
		GetPointInFront2D(x,y,0.0,size,tpx1,tpy1);
		GetPointInFront2D(x,y,180.0,size,tpx2,tpy2);
		_3DTryg_MapAndreasFindZ(tpx1,tpy1,tpz1);
		_3DTryg_MapAndreasFindZ(tpx2,tpy2,tpz2);
		GetRotationFor2Point3D(tpx1,tpy1,tpz1,tpx2,tpy2,tpz2,rx,tmp);
		
		GetPointInFront2D(x,y,90.0,size,tpx1,tpy1);
		GetPointInFront2D(x,y,270.0,size,tpx2,tpy2);
		_3DTryg_MapAndreasFindZ(tpx1,tpy1,tpz1);
		_3DTryg_MapAndreasFindZ(tpx2,tpy2,tpz2);
		GetRotationFor2Point3D(tpx1,tpy1,tpz1,tpx2,tpy2,tpz2,ry,tmp);
	}
#endif

#if defined MapAndreas_FindZ_For2DCoord
	stock GetPointInFrontOnGround(Float:x,Float:y,Float:z,Float:rx,Float:rz,&Float:tx,&Float:ty,&Float:tz,Float:max_distance){
		new Float:tmpz;
		_3DTryg_MapAndreasFindZ(x,y,tmpz);
		new Float:radius = GetDistanceBetweenPoints3D(x,y,z,x,y,tmpz),
			Float:cos = floatcos(rx+90.0,degrees),
			Float:dist;
		if(cos == 0.0){
			dist = radius;
		} else {
			dist = floatabs(radius/cos);
		}
		if((dist > max_distance) || (rx >= 0.0 && rx <= 180.0)){
			dist = max_distance;
		}
		GetPointInFront3D(x,y,z,rx,rz,dist,tx,ty,tz);
		if((dist > max_distance) || (rx >= 0.0 && rx <= 180.0)){

		} else {
			_3DTryg_MapAndreasFindZ(tx,ty,tz);
		}
	}
#endif

stock Float:GetPlayerTargetAngle(playerid,Float:x,Float:y,&Float:rz=0.0){
	new Float:mx, Float:my;
	GetPlayerPos(playerid,mx,my,rz);
	GetRotationFor2Point2D(mx,my,x,y,rz);
	return rz;
}

stock Float:SetPlayerTargetAngle(playerid,Float:x,Float:y,&Float:rz=0.0){
	new Float:mx, Float:my;
	GetPlayerPos(playerid,mx,my,rz);
	GetRotationFor2Point2D(mx,my,x,y,rz);
	SetPlayerFacingAngle(playerid,rz);
	return rz;
}

#define GetXYInFrontOfPlayer							GetPointInFrontOfPlayer
#define GetPointInFront									GetPointInFront3D
#define GetPointInFrontOfCamera							GetPointInFrontOfCamera3D
#define GetDistanceBetweenPoints						GetDistanceBetweenPoints3D
#define CompressRotation								CompRotation
#define CompressRotationFloat							CompRotationFloat
	
#if !defined USE_OLD_PROTOTYPE_FUNCTION
	
	#if defined GetAngle
		#error GetAngle is old prototype. Use GetPlayerTargetAngle / SetPlayerTargetAngle / GetRotationFor2Point2D
	#endif
	
	
#endif

//EOF