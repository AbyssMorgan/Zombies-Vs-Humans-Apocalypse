/************************************************************************************************************************************
 *                                                                                                                                  *
 *                                                    )(   3DTryg Functions   )(                                                    *
 *                                                                                                                                  *
 * Copyright © 2017 Abyss Morgan. All rights reserved.                                                                              *
 * Contributors: Crayder, IllidanS4, Nero_3D, RyDeR, Zoutdaxv, hesambia, Neil Lamoureux                                             *
 *                                                                                                                                  *
 * Download: https://github.com/AbyssMorgan/SA-MP/tree/master/include/SAM                                                           *
 * Publication: http://forum.sa-mp.com/showthread.php?t=591010                                                                      *
 * Wiki: https://github.com/AbyssMorgan/SA-MP/wiki/3DTryg                                                                           *
 *                                                                                                                                  *
 * Plugins: MapAndreas, ColAndreas, YSF, Streamer, FCNPC                                                                            *
 * Modules: FoxForeach, Foreach                                                                                                     *
 * Internal Modules: Stream3D, Line3D, Actor, ATM, Anims                                                                            *
 * Attributes: Overload resistance.                                                                                                 *
 *                                                                                                                                  *
 * File Version: 3.3.0                                                                                                              *
 * SA:MP Version: 0.3.7 (REQUIRE)                                                                                                   *
 * MapAndreas Version: 1.2.1                                                                                                        *
 * ColAndreas Version: 1.4.0                                                                                                        *
 * YSF Version: R18-2 (kurta999)                                                                                                    *
 * Streamer Version: 2.8.2                                                                                                          *
 * FCNPC Version: 1.6.1                                                                                                             *
 *                                                                                                                                  *
 * 3DTryg FindZ Precision:                                                                                                          *
 * 1. ColAndreas   - The most accurate precision with ColAndreas plugin.                                                            *
 * 2. MapAndreas   - Average precision MapAndreas plugin.                                                                           *
 *                                                                                                                                  *
 * Foreach Types:                                                                                                                   *
 * 1. FoxForeach                                                                                                                    *
 * 2. YSIForeach                                                                                                                    *
 * 3. GetPlayerPoolSize                                                                                                             *
 *                                                                                                                                  *
 * Compiler Options:                                                                                                                *
 * DISABLE_3D_TRYG_CHECK        //Use before 3DTryg.inc for disable Check Plugin Version                                            *
 * DISABLE_3D_TRYG_INIT         //Use before 3DTryg.inc for disable MapAndreas/ColAndreas Auto Init                                 *
 * DISABLE_3D_TRYG_ATM          //Use before 3DTryg.inc for disable ATM Module                                                      *
 * DISABLE_3D_TRYG_ACTOR        //Use before 3DTryg.inc for disable Actors Module                                                   *
 * DISABLE_3D_TRYG_MAPANDREAS   //Use before 3DTryg.inc for disable MapAndreas Module                                               *
 * DISABLE_3D_TRYG_COLANDREAS   //Use before 3DTryg.inc for disable ColAndreas Module                                               *
 * DISABLE_3D_TRYG_YSF          //Use before 3DTryg.inc for disable YSF Module                                                      *
 * DISABLE_3D_TRYG_STREAMER     //Use before 3DTryg.inc for disable Streamer Module                                                 *
 * DISABLE_3D_TRYG_FOXFOREACH   //Use before 3DTryg.inc for disable FoxForeach Module                                               *
 * DISABLE_3D_TRYG_YSIFOREACH   //Use before 3DTryg.inc for disable Foreach Module                                                  *
 * DISABLE_3D_TRYG_FCNPC        //Use before 3DTryg.inc for disable FCNPC Module                                                    *
 * ENABLE_3D_TRYG_TIMELINE_SYNC //Use before 3DTryg.inc for enable Timeline Sync                                                    *
 * ENABLE_3D_TRYG_STREAM3D      //Use before 3DTryg.inc for enable Stream3D Module                                                  *
 * ENABLE_3D_TRYG_LINE3D        //Use before 3DTryg.inc for enable Line3D Module                                                    *
 * ENABLE_3D_TRYG_ANIMS         //Use before 3DTryg.inc for enable Anims Module                                                     *
 *                                                                                                                                  *
 * Complementary Functions:                                                                                                         *
 * Float:sqrtN(Float:value,Float:exponent);                                                                                         *
 * abs(value);                                                                                                                      *
 * Float:fabs(Float:value);                                                                                                         *
 * power(value,Float:exponent);                                                                                                     *
 * Float:ctg(Float:value,anglemode:mode=radian);                                                                                    *
 * Float:secans(Float:value,anglemode:mode=radian);                                                                                 *
 * Float:cosecans(Float:value,anglemode:mode=radian);                                                                               *
 * IsEven(value);                                                                                                                   *
 * Float:RandomFloat(Float:min,Float:max,accuracy = 4);                                                                             *
 *                                                                                                                                  *
 * Internal Functions:                                                                                                              *
 * single_clock(max,id); //For GetRandomPointOnClock parameter rz                                                                   *
 * even_clock(max,id);   //For GetRandomPointOnClock parameter rz                                                                   *
 * uneven_clock(max,id); //For GetRandomPointOnClock parameter rz                                                                   *
 * NLTZ(value);                           //NotLessThanZero                                                                         *
 * NMTZ(value);                           //NotMoreThanZero                                                                         *
 * Float:NLTZF(Float:value);              //NotLessThanZeroFloat                                                                    *
 * Float:NMTZF(Float:value);              //NotMoreThanZeroFloat                                                                    *
 * NLTV(value,min);                       //NotLessThanValue                                                                        *
 * NMTV(value,max);                       //NotMoreThanValue                                                                        *
 * Float:NLTVF(Float:value,Float:min);    //NotLessThanValueFloat                                                                   *
 * Float:NMTVF(Float:value,Float:max);    //NotMoreThanValueFloat                                                                   *
 * CompRotation(rotation,&crotation=0);   //CompressRotation                                                                        *
 * DeCompRotation(rotation,&crotation=0); //DeCompressRotation                                                                      *
 * Float:CompRotationFloat(Float:rotation,&Float:crotation=0.0);   //CompressRotationFloat                                          *
 * Float:DeCompRotationFloat(Float:rotation,&Float:crotation=0.0); //DeCompressRotationFloat                                        *
 * bool:IsRotationTest(Float:rotation,Float:r_min,Float:r_max);                                                                     *
 * Tryg3D_GetRotationMatrixEuler(Float:matrix[][],Float:rx,Float:ry,Float:rz,T3D:eulermode:mode=T3D:euler_default);                 *
 * Tryg3D_MatrixRotate(Float:matrix[][],Float:oX,Float:oY,Float:oZ,&Float:x,&Float:y,&Float:z);                                     *
 * Tryg3D_GivePlayerDamage(targetid,Float:damage,playerid,weaponid,bool:force_spawn=true,bool:death_msg=true,bool:death_call=true); *
 * Tryg3D_GetWeaponDamage(weaponid);                                                                                                *
 * Tryg3D_SwapInt(variable1,variable2);                                                                                             *
 * bool:Tryg3D_IsPlayerSpawned(playerid);                                                                                           *
 *                                                                                                                                  *
 * General Functions:                                                                                                               *
 * CountPlayers(bool:isplayer=true,bool:isnpc=true);                                                                                *
 * CountActors();                                                                                                                   *
 * RecoilFloat(Float:value,Float:recoil);                                                                                           *
 * RecoilVector(&Float:vx,&Float:vy,&Float:vz,Float:sx,Float:sy,Float:sz);                                                          *
 * Float:ShiftDegreeToRadian(Float:deg);                                                                                            *
 * Float:ShiftDegreeToRadianEx(Float:deg);                                                                                          *
 * Float:ShiftDegreeToGrades(Float:deg);                                                                                            *
 * Float:ShiftRadianToDegree(Float:rad);                                                                                            *
 * Float:ShiftRadianToDegreeEx(Float:rad);                                                                                          *
 * Float:ShiftRadianToGrades(Float:rad);                                                                                            *
 * Float:ShiftGradesToDegree(Float:grad);                                                                                           *
 * Float:ShiftGradesToRadian(Float:grad);                                                                                           *
 * GetRandomHit(Float:x,Float:y,Float:z,range,&Float:tx,&Float:ty,&Float:tz);                                                       *
 * Float:GetDistanceBetweenPoints1D(Float:x1,Float:x2);                                                                             *
 * Float:GetDistanceBetweenPoints2D(Float:x1,Float:y1,Float:x2,Float:y2);                                                           *
 * Float:GetDistanceBetweenPoints3D(Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2);                                         *
 * GetPointInFront2D(Float:x,Float:y,Float:rz,Float:radius,&Float:tx,&Float:ty);                                                    *
 * GetPointInFront3D(Float:x,Float:y,Float:z,Float:rx,Float:rz,Float:radius,&Float:tx,&Float:ty,&Float:tz);                         *
 * Float:GetPointInFrontOfPlayer(playerid,&Float:tx,&Float:ty,Float:radius);                                                        *
 * Float:GetPointInFrontOfCamera2D(playerid,&Float:tx,&Float:ty,Float:radius);                                                      *
 * GetPointInFrontOfCamera3D(playerid,&Float:tx,&Float:ty,&Float:tz,Float:radius,&Float:rx=0.0,&Float:rz=0.0);                      *
 * GetRotationFor2Point2D(Float:x,Float:y,Float:tx,Float:ty,&Float:rz);                                                             *
 * bool:GetRotationFor2Point3D(Float:x,Float:y,Float:z,Float:tx,Float:ty,Float:tz,&Float:rx,&Float:rz);                             *
 * ConvertMTARaceRotation(Float:rotation1,Float:rotation2,Float:rotation3,&Float:rx,&Float:ry,&Float:rz);                           *
 * ConvertToMTARaceRotation(Float:rx,Float:ry,Float:rz,&Float:rotation1,&Float:rotation2,&Float:rotation3);                         *
 * GetMoveTime(Float:x,Float:y,Float:z,Float:tx,Float:ty,Float:tz,Float:speed,&rtime=0);                                            *
 * GetSpeedForMoveTime(Float:x,Float:y,Float:z,Float:tx,Float:ty,Float:tz,&Float:speed,rtime);                                      *
 * GetVehicleRotation(vehicleid,&Float:rx,&Float:ry,&Float:rz);                                                                     *
 * Float:GetPointInFrontOfVehicle2D(vehicleid,&Float:tx,&Float:ty,Float:radius);                                                    *
 * GetPointInFrontOfVehicle3D(vehicleid,&Float:tx,&Float:ty,&Float:tz,Float:radius,&Float:rx=0.0,&Float:rz=0.0);                    *
 * GetPlayerCameraRotation(playerid,&Float:rx,&Float:rz);                                                                           *
 * SetPlayerCameraRotation(playerid,Float:rx,Float:rz);                                                                             *
 * Float:GetPlayerCameraZAngle(playerid,&Float:rz=0.0);                                                                             *
 * SetPlayerCameraZAngle(playerid,Float:rz);                                                                                        *
 * GetPointFor2Point2D(Float:x1,Float:y1,Float:x2,Float:y2,Float:percent_size,&Float:tx,&Float:ty);                                 *
 * GetPointFor2Point3D(Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2,Float:percent_size,&Float:tx,&Float:ty,&Float:tz);     *
 * GetPointFor2Point2DEx(Float:x1,Float:y1,Float:x2,Float:y2,Float:distance,&Float:tx,&Float:ty);                                   *
 * GetPointFor2Point3DEx(Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2,Float:distance,&Float:tx,&Float:ty,&Float:tz);       *
 * ShiftVectorToRotation(Float:vx,Float:vy,Float:vz,&Float:rx,&Float:rz);                                                           *
 * ShiftRotationToVector(Float:rx,Float:rz,&Float:vx,&Float:vy,&Float:vz);                                                          *
 * Float:GetRandomPointOnClock(Float:x,Float:y,Float:radius,&Float:tx,&Float:ty,&Float:trz,Float:rz = INVALID_ROTATION);            *
 * GetRandomPointInCircle(Float:x,Float:y,Float:radius,&Float:tx,&Float:ty);                                                        *
 * GetRandomPointInCylinder2D(Float:x,Float:y,Float:minz,Float:maxz,Float:radius,&Float:tx,&Float:ty,&Float:tz);                    *
 * GetRandomPointInSphere(Float:x,Float:y,Float:z,Float:radius,&Float:tx,&Float:ty,&Float:tz);                                      *
 * GetRandomPointInRectangle(Float:minx,Float:miny,Float:maxx,Float:maxy,&Float:tx,&Float:ty);                                      *
 * GetRandomPointInCube(Float:minx,Float:miny,Float:minz,Float:maxx,Float:maxy,Float:maxz,&Float:tx,&Float:ty,&Float:tz);           *
 * GetRandomPointInCircularSector(Float:x,Float:y,Float:rz,Float:radius,Float:view_angle,&Float:tx,&Float:ty);                      *
 * GetRandomPointOnCircle(Float:x,Float:y,Float:radius,&Float:tx,&Float:ty);                                                        *
 * GetRandomPointOnSphere(Float:x,Float:y,Float:z,Float:radius,&Float:tx,&Float:ty,&Float:tz);                                      *
 * GetRandomPointOnCircularSector(Float:x,Float:y,Float:rz,Float:radius,Float:view_angle,&Float:tx,&Float:ty);                      *
 * bool:IsPointBetween2Points2D(Float:px,Float:py,Float:xA,Float:yA,Float:xB,Float:yB);                                             *
 * bool:IsPointBetween2Points3D(Float:px,Float:py,Float:pz,Float:xA,Float:yA,Float:zA,Float:xB,Float:yB,Float:zB);                  *
 * bool:IsPointNearly2Points2D(Float:px,Float:py,Float:xA,Float:yA,Float:xB,Float:yB,Float:maxdist);                                *
 * bool:IsPointNearly2Points3D(Float:px,Float:py,Float:pz,Float:xA,Float:yA,Float:zA,Float:xB,Float:yB,Float:zB,Float:maxdist);     *
 * bool:IsPointInCircle(Float:px,Float:py,Float:x,Float:y,Float:radius);                                                            *
 * bool:IsPointInCylinder3D(Float:px,Float:py,Float:pz,Float:xA,Float:yA,Float:zA,Float:xB,Float:yB,Float:zB,Float:radius);         *
 * bool:IsPointInCylinder2D(Float:px,Float:py,Float:pz,Float:x,Float:y,Float:minz,Float:maxz,Float:radius);                         *
 * bool:IsPointInSphere(Float:px,Float:py,Float:pz,Float:x,Float:y,Float:z,Float:radius);                                           *
 * bool:IsPointInRectangle(Float:x,Float:y,Float:minx,Float:miny,Float:maxx,Float:maxy);                                            *
 * bool:IsPointInCube(Float:x,Float:y,Float:z,Float:minx,Float:miny,Float:minz,Float:maxx,Float:maxy,Float:maxz);                   *
 * bool:IsPointInPolygon(Float:x,Float:y,Float:points[],maxpoints = sizeof(points));                                                *
 * bool:IsPointInCircularSector(Float:px,Float:py,Float:x,Float:y,Float:rz,Float:radius,Float:view_angle);                          *
 * bool:IsPointInSphericalSector(Float:px,Float:py,Float:pz,Float:x,Float:y,Float:z,Float:rx,Float:rz,Float:radius,                 *
 *                               Float:vrx,Float:vrz);                                                                              *
 * bool:IsPointInCone3D(Float:px,Float:py,Float:pz,Float:xA,Float:yA,Float:zA,Float:xB,Float:yB,Float:zB,                           *
 *                      Float:pointA_radius,Float:pointB_radius);                                                                   *
 * bool:IsProbable(chance);                                                                                                         *
 * Float:CalculatePercent(Float:value,Float:maxvalue);                                                                              *
 * Float:GetPlayerTargetAngle(playerid,Float:x,Float:y,&Float:rz=0.0);                                                              *
 * Float:SetPlayerTargetAngle(playerid,Float:x,Float:y,&Float:rz=0.0);                                                              *
 * Float:GetPlayerTargetPlayerAngle(playerid,targetid,&Float:rz=0.0);                                                               *
 * Float:SetPlayerTargetPlayerAngle(playerid,targetid,&Float:rz=0.0);                                                               *
 * Float:GetVehicleSpeed(vehicleid);                                                                                                *
 * Float:GetPlayerSpeed(playerid);                                                                                                  *
 * CreateDynamicExplosion(Float:x,Float:y,Float:z,type,Float:radius,worldid=-1,interiorid=-1,playerid=-1,Float:distance=200.0);     *
 * GetVehicleFlags(vehicleid);                                                                                                      *
 * GetVehicleFlagsByModel(modelid);                                                                                                 *
 * IsVehicleFlag(value,flag);                                                                                                       *
 * GetPlayerOrientationPos(playerid,element_orientation:orientation,Float:distance,&Float:tx,&Float:ty,&Float:tz,isactor=false);    *
 * GetVehicleOrientationPos(vehicleid,element_orientation:orientation,Float:distance,&Float:tx,&Float:ty,&Float:tz);                *
 * GetObjectOrientationPos(objectid,element_orientation:orientation,Float:distance,&Float:tx,&Float:ty,&Float:tz);                  *
 * GetWeaponShotPos(playerid,hittype,&Float:fx,&Float:fy,&Float:fz);                                                                *
 * SetPlayerLookAtPlayer(playerid,targetid,cut = CAMERA_CUT);                                                                       *
 * GetPlayerCameraLookAt(playerid,&Float:x,&Float:y,&Float:z);                                                                      *
 * bool:IsPlayerLookAtSky(playerid);                                                                                                *
 * GetVehicleUpVector(vehicleid,&Float:vx,&Float:vy,&Float:vz);                                                                     *
 * GetVehicleUpPos(vehicleid,Float:radius,&Float:x,&Float:y,&Float:z);                                                              *
 * GetVehicleDownPos(vehicleid,Float:radius,&Float:x,&Float:y,&Float:z);                                                            *
 * GetObjectRotationQuat(objectid,&Float:qw,&Float:qx,&Float:qy,&Float:qz);                                                         *
 * GetObjectUpVector(objectid,&Float:vx,&Float:vy,&Float:vz);                                                                       *
 * GetObjectUpPos(objectid,Float:radius,&Float:x,&Float:y,&Float:z);                                                                *
 * GetObjectDownPos(objectid,Float:radius,&Float:x,&Float:y,&Float:z);                                                              *
 * GetQuatUpVector(Float:qw,Float:qx,Float:qy,Float:qz,&Float:vx,&Float:vy,&Float:vz);                                              *
 * GetQuatFromRot(Float:rx,Float:ry,Float:rz,&Float:qw,&Float:qx,&Float:qy,&Float:qz);                                              *
 * Float:GetLineSize2D(Float:points[][],maxpoints=sizeof(points));                                                                  *
 * Float:GetLineSize3D(Float:points[][],maxpoints=sizeof(points));                                                                  *
 * bool:GetPointToPointVector(Float:x,Float:y,Float:z,Float:tx,Float:ty,Float:tz,&Float:vx,&Float:vy,&Float:vz);                    *
 * bool:GetPlayerToPointVector(playerid,Float:tx,Float:ty,Float:tz,&Float:vx,&Float:vy,&Float:vz);                                  *
 * bool:GetObjectToPointVector(objectid,Float:tx,Float:ty,Float:tz,&Float:vx,&Float:vy,&Float:vz);                                  *
 * bool:GetVehicleToPointVector(vehicleid,Float:tx,Float:ty,Float:tz,&Float:vx,&Float:vy,&Float:vz);                                *
 * bool:IsVehicleInRangeOfPoint(vehicleid,Float:range,Float:x,Float:y,Float:z);                                                     *
 * bool:IsActorInRangeOfPoint(actorid,Float:range,Float:x,Float:y,Float:z);                                                         *
 * bool:IsObjectInRangeOfPoint(objectid,Float:range,Float:x,Float:y,Float:z);                                                       *
 * ShiftLineRotation(Float:sX,Float:sY,Float:sZ,Float:eX,Float:eY,Float:eZ,Float:rx,Float:ry,Float:rz,                              *
 *                   &Float:nX,&Float:nY,&Float:nZ);                                                                                *
 * ShiftLineRotationVector(Float:sX,Float:sY,Float:sZ,Float:eX,Float:eY,Float:eZ,Float:rx,Float:ry,Float:rz,                        *
 *                         &Float:nX,&Float:nY,&Float:nZ);                                                                          *
 * GetPlayerRotatedVector(playerid,Float:tx,Float:ty,Float:tz,&Float:vx,&Float:vy,&Float:vz,bool:return_vector=true,                *
 *                        Float:rx=0.0,Float:ry=0.0,Float:rz=0.0);                                                                  *
 * GetObjectRotatedVector(objectid,Float:tx,Float:ty,Float:tz,&Float:vx,&Float:vy,&Float:vz,bool:return_vector=true,                *
 *                        Float:rx=0.0,Float:ry=0.0,Float:rz=0.0);                                                                  *
 * GetVehicleRotatedVector(vehicleid,Float:tx,Float:ty,Float:tz,&Float:vx,&Float:vy,&Float:vz,bool:return_vector=true,              *
 *                         Float:rx=0.0,Float:ry=0.0,Float:rz=0.0);                                                                 *
 * bool:GetArcPointsFloor2D(Float:x,Float:y,Float:z,Float:tx,Float:ty,Float:spread,Float:points[][],max_points=sizeof(points));     *
 * bool:GetArcPointsCellar2D(Float:x,Float:y,Float:z,Float:tx,Float:ty,Float:spread,Float:points[][],max_points=sizeof(points));    *
 * bool:GetArcPointsStarboard2D(Float:x,Float:y,Float:z,Float:tx,Float:ty,Float:spread,Float:points[][],max_points=sizeof(points)); *
 * bool:GetArcPointsLarboard2D(Float:x,Float:y,Float:z,Float:tx,Float:ty,Float:spread,Float:points[][],max_points=sizeof(points));  *
 * bool:IsPointInSphericalSectorEx(Float:px,Float:py,Float:pz,Float:x,Float:y,Float:z,Float:rx,Float:rz,Float:radius,               *
 *                                 Float:vrx,Float:vrz,bool:testLOS=true);                                                          *
 * Float:GetDistanceFromPointToLine(Float:px,Float:py,Float:pz,Float:sX,Float:sY,Float:sZ,Float:eX,Float:eY,Float:eZ,               *
 *                                  &Float:iX=0.0,&Float:iY=0.0,&Float:iZ=0.0);                                                     *
 *                                                                                                                                  *
 * Universal Functions:                                                                                                             *
 * bool:GetElementPos({Text3D,_}:elementid,Item3D_Type:element_type,&Float:x,&Float:y,&Float:z);                                    *
 * Float:GetElementsDistance({Text3D,_}:elementid,Item3D_Type:element_type,{Text3D,_}:targetid,Item3D_Type:target_type);            *
 * Float:GetElementDistanceFromPoint({Text3D,_}:elementid,Item3D_Type:element_type,Float:x,Float:y,Float:z);                        *
 * bool:IsElementOnPlayerScreen(playerid,{Text3D,_}:targetid,Item3D_Type:target_type=item_player,                                   *
 *                              element_orientation:orientation=o_front,Float:rx=INVALID_ROTATION,Float:rz=INVALID_ROTATION,        *
 *                              Float:vrx=VERTICAL_CAMERA_RADIUS,Float:vrz=HORIZONTAL_CAMERA_RADIUS,bool:testLOS=true,              *
 *                              bool:testVW=true);                                                                                  *
 * bool:IsElementOnFakeScreen(Float:x,Float:y,Float:z,{Text3D,_}:targetid,Item3D_Type:target_type,Float:rx,Float:rz,                *
 *                            Float:vrx=VERTICAL_CAMERA_RADIUS,Float:vrz=HORIZONTAL_CAMERA_RADIUS,bool:testLOS=true);               *
 * bool:IsElementInCircle({Text3D,_}:elementid,Item3D_Type:element_type,Float:x,Float:y,Float:radius);                              *
 * bool:IsElementInCylinder3D({Text3D,_}:elementid,Item3D_Type:element_type,Float:xA,Float:yA,Float:zA,Float:xB,Float:yB,Float:zB,  *
 *                            Float:radius);                                                                                        *
 * bool:IsElementInCylinder2D({Text3D,_}:elementid,Item3D_Type:element_type,Float:x,Float:y,Float:minz,Float:maxz,Float:radius);    *
 * bool:IsElementInSphere({Text3D,_}:elementid,Item3D_Type:element_type,Float:x,Float:y,Float:z,Float:radius);                      *
 * bool:IsElementInRectangle({Text3D,_}:elementid,Item3D_Type:element_type,Float:minx,Float:miny,Float:maxx,Float:maxy);            *
 * bool:IsElementInCube({Text3D,_}:elementid,Item3D_Type:element_type,Float:minx,Float:miny,Float:minz,                             *
 *                      Float:maxx,Float:maxy,Float:maxz);                                                                          *
 * bool:IsElementInPolygon({Text3D,_}:elementid,Item3D_Type:element_type,Float:points[],maxpoints = sizeof(points));                *
 * bool:IsElementInCircularSector({Text3D,_}:elementid,Item3D_Type:element_type,Float:x,Float:y,Float:rz,Float:radius,              *
 *                                Float:view_angle);                                                                                *
 * bool:IsElementInSphericalSector({Text3D,_}:elementid,Item3D_Type:element_type,Float:x,Float:y,Float:z,Float:rx,Float:rz,         *
 *                                 Float:radius,Float:vrx,Float:vrz);                                                               *
 * bool:IsElementInCone({Text3D,_}:elementid,Item3D_Type:element_type,Float:xA,Float:yA,Float:zA,Float:xB,Float:yB,Float:zB,        *
 *                      Float:pointA_radius,Float:pointB_radius);                                                                   *
 * bool:IsElementInStream({Text3D,_}:elementid,Item3D_Type:element_type,Stream:StreamData[Stream3D]);                               *
 *                                                                                                                                  *
 * Useless Functions:                                                                                                               *
 * ShiftPositionToOrion(Float:x,Float:y,Float:z,&Float:orion,&Float:lon,&Float:lat);                                                *
 * ShiftOrionToPosition(Float:orion,Float:lon,Float:lat,&Float:x,&Float:y,&Float:z);                                                *
 *                                                                                                                                  *
 * Extended Functions:                                                                                                              *
 * Tryg3D_GetModules(&modules_count=0);                                                                                             *
 * bool:Tryg3D_IsModuleLoaded(Tryg3DModule:moduleid);                                                                               *
 * Tryg3D_GetEfficiency(bool:use_colandreas=false);                                                                                 *
 * Tryg3D_GetErrorCount();                                                                                                          *
 * Tryg3D_ResetErrorCount();                                                                                                        *
 * Tryg3D_SetStreamDistance(Float:streamdistance); //default 300.0                                                                  *
 * Float:Tryg3D_GetStreamDistance();                                                                                                *
 * Tryg3D_GetActiveCount();                                                                                                         *
 *                                                                                                                                  *
 * Animation Functions:                                                                                                             *
 * bool:IsPlayerSkydiving(playerid);      //Animation Test                                                                          *
 * bool:IsPlayerUsingParachute(playerid); //Animation Test                                                                          *
 * bool:IsPlayerAiming(playerid);         //Animation Test                                                                          *
 * bool:IsPlayerStay(playerid);           //Animation Test                                                                          *
 * bool:IsPlayerRunning(playerid);        //Animation Test                                                                          *
 * bool:IsPlayerSwim(playerid);           //Animation Test                                                                          *
 * bool:IsPlayerJump(playerid);           //Animation Test                                                                          *
 * bool:IsPlayerParaFall(playerid);       //Animation Test                                                                          *
 * bool:IsPlayerParaGlide(playerid);      //Animation Test                                                                          *
 * bool:IsPlayerFall(playerid);           //Animation Test                                                                          *
 *                                                                                                                                  *
 * ATM Module Functions:                                                                                                            *
 * randomex(min,max);                                                                                                               *
 * Tryg3D_KeyPressed(key);                                                                                                          *
 * Tryg3D_KeyReleased(key);                                                                                                         *
 * Tryg3D_KeyHolding(key);                                                                                                          *
 * T3D:GetSAMIncludeVersion(value,name[],maxdest = sizeof(name));                                                                   *
 * T3D:DisableADMLogging(bool:disable);                                                                                             *
 * T3D:SecToTimeDay(second);      //Use: %d:%02d:%02d:%02d                                                                          *
 * T3D:MSToTimeDay(millisecond);  //Use: %d:%02d:%02d:%02d                                                                          *
 * T3D:SecToTime(second);         //Use: %02d:%02d:%02d                                                                             *
 * T3D:MSToTime(millisecond);     //Use: %02d:%02d:%02d                                                                             *
 * T3D:SecToTimeMini(second);     //Use: %02d:%02d                                                                                  *
 * T3D:MSToTimeMini(millisecond); //Use: %02d:%02d                                                                                  *
 *                                                                                                                                  *
 * Streamer Functions:                                                                                                              *
 * GetDynamicObjectOrientationPos(objectid,element_orientation:orientation,Float:distance,&Float:tx,&Float:ty,&Float:tz);           *
 * GetDynamicObjectRotationQuat(objectid,&Float:qw,&Float:qx,&Float:qy,&Float:qz);                                                  *
 * GetDynamicObjectUpVector(objectid,&Float:vx,&Float:vy,&Float:vz);                                                                *
 * GetDynamicObjectUpPos(objectid,Float:radius,&Float:x,&Float:y,&Float:z);                                                         *
 * GetDynamicObjectDownPos(objectid,Float:radius,&Float:x,&Float:y,&Float:z);                                                       *
 * bool:GetDynamicObjectToPointVector(objectid,Float:tx,Float:ty,Float:tz,&Float:vx,&Float:vy,&Float:vz);                           *
 * bool:IsDynamicObjectInRangeOfPoint(objectid,Float:range,Float:x,Float:y,Float:z);                                                *
 * SetPlayerAbsolutePosition(playerid,Float:x,Float:y,Float:z,Float:angle,worldid = -1,interiorid = -1,compensatedtime = -1);       *
 * SetPlayerAbsolutePositionVeh(playerid,Float:x,Float:y,Float:z,Float:angle,worldid = -1,interiorid = -1,compensatedtime = -1);    *
 * GetDynamicObjectRotatedVector(objectid,Float:tx,Float:ty,Float:tz,&Float:vx,&Float:vy,&Float:vz,bool:return_vector=true,         *
 *                               Float:rx=0.0,Float:ry=0.0,Float:rz=0.0);                                                           *
 * bool:IsDynamicActorInRangeOfPoint(actorid,Float:range,Float:x,Float:y,Float:z);                                                  *
 * GetDynamicActorOrientationPos(actorid,element_orientation:orientation,Float:distance,&Float:tx,&Float:ty,&Float:tz);             *
 *                                                                                                                                  *
 * Streamer Extended Functions:                                                                                                     *
 * bool:Tryg3D_IsValidStreamer(version);                                                                                            *
 * Tryg3D_GetStreamerVersionName(name[],value = TRYG3D_GET_STREAMER_VERSION,maxdest = sizeof(name));                                *
 * Tryg3D_CheckStreamerVersion();                                                                                                   *
 *                                                                                                                                  *
 * Streamer Functions (ColAndreas):                                                                                                 *
 * GetDynamicObjectOrientPosCol(objectid,element_orientation:orientation,Float:distance,&Float:tx,&Float:ty,&Float:tz);             *
 * GetDynamicObjectCollisionFlags(objectid);                                                                                        *
 * GetDynamicActorOrientPosCol(actorid,element_orientation:orientation,Float:distance,&Float:tx,&Float:ty,&Float:tz);               *
 * bool:IsPlayerInRangeOfDynamicObject(playerid,Float:range,objectid,bool:testLOS=true);                                            *
 * bool:IsPlayerInRangeOfDynamicActor(playerid,Float:range,actorid,bool:testLOS=true);                                              *
 *                                                                                                                                  *
 * Streamer Functions (FCNPC):                                                                                                      *
 * SetNPCAbsolutePosition(npcid,Float:x,Float:y,Float:z,Float:angle,worldid = -1,interiorid = -1,compensatedtime = -1);             *
 *                                                                                                                                  *
 * MapAndreas Functions:                                                                                                            *
 * Float:MapAndreasFindZ(Float:x,Float:y,&Float:z=0.0);                                                                             *
 * GetGroundRotation(Float:x,Float:y,Float:size,&Float:rx,&Float:ry);                                                               *
 * GetPointInFrontOnGround(Float:x,Float:y,Float:z,Float:rx,Float:rz,&Float:tx,&Float:ty,&Float:tz,Float:max_distance);             *
 * bool:IsPointInWaterFrontOfPlayer(playerid,Float:radius);                                                                         *
 * bool:IsPointInWater(Float:x,Float:y,Float:z=0.0);                                                                                *
 *                                                                                                                                  *
 * MapAndreas Extended Functions:                                                                                                   *
 * bool:IsMapAndreasInit();                                                                                                         *
 * SafeMapAndreasInit(mode = MAP_ANDREAS_MODE_FULL, name[]="", len=sizeof(name));                                                   *
 *                                                                                                                                  *
 * ColAndreas Functions:                                                                                                            *
 * MovePointCol(Float:StartX,Float:StartY,Float:StartZ,Float:EndX,Float:EndY,Float:EndZ,&Float:x,&Float:y,&Float:z);                *
 * bool:MovePointColCutLine(Float:sX,Float:sY,Float:sZ,Float:eX,Float:eY,Float:eZ,&Float:x,&Float:y,&Float:z,Float:cut_size=0.0);   *
 * bool:MovePointColCutLineEx(Float:sX,Float:sY,Float:sZ,Float:eX,Float:eY,Float:eZ,&Float:x,&Float:y,&Float:z,Float:cut_size=0.0); *
 * GetPointInFront3DCol(Float:x,Float:y,Float:z,Float:rx,Float:rz,Float:radius,&Float:tx,&Float:ty,&Float:tz);                      *
 * Float:GetPointInFrontOfPlayerCol(playerid,&Float:tx,&Float:ty,Float:radius);                                                     *
 * Float:GetPointInFrontOfCamera2DCol(playerid,&Float:tx,&Float:ty,Float:radius);                                                   *
 * GetPointInFrontOfCamera3DCol(playerid,&Float:tx,&Float:ty,&Float:tz,Float:radius,&Float:rx=0.0,&Float:rz=0.0);                   *
 * Float:GetPointInFrontOfVehicle2DCol(vehicleid,&Float:tx,&Float:ty,Float:radius);                                                 *
 * GetPointInFrontOfVehicle3DCol(vehicleid,&Float:tx,&Float:ty,&Float:tz,Float:radius,&Float:rx=0.0,&Float:rz=0.0);                 *
 * GetGroundRotation(Float:x,Float:y,Float:size,&Float:rx,&Float:ry);                                                               *
 * GetPointInFrontOnGround(Float:x,Float:y,Float:z,Float:rx,Float:rz,&Float:tx,&Float:ty,&Float:tz,Float:max_distance);             *
 * GetPointCollisionFlags(Float:x,Float:y,Float:z,interiorid=0);                                                                    *
 * GetPlayerCollisionFlags(playerid);                                                                                               *
 * GetVehicleCollisionFlags(vehicleid);                                                                                             *
 * GetObjectCollisionFlags(objectid);                                                                                               *
 * IsCollisionFlag(value,flag);                                                                                                     *
 * Float:UndergroundFindZ(Float:x,Float:y,&Float:z=0.0);                                                                            *
 * Float:InteriorFindZ(Float:px,Float:py,Float:pz=1000.0,Float:size=2.0,&Float:z=0.0);                                              *
 * bool:IsPointInWater(Float:x,Float:y,Float:z=0.0);                                                                                *
 * bool:IsPointInUnderwater(Float:x,Float:y,Float:z);                                                                               *
 * bool:IsPointInUnderground(Float:x,Float:y,Float:z);                                                                              *
 * bool:IsPointInAir(Float:x,Float:y,Float:z,bool:interior=false,Float:max_distance=2.2);                                           *
 * bool:IsPointInGround(Float:x,Float:y,Float:z,bool:interior=false,Float:max_distance=2.2);                                        *
 * bool:IsPointInWaterFrontOfPlayer(playerid,Float:radius);                                                                         *
 * Float:ColAndreasFindZ(Float:x,Float:y,&Float:z=0.0);                                                                             *
 * GetPlayerOrientationPosCol(playerid,element_orientation:orientation,Float:distance,&Float:tx,&Float:ty,&Float:tz,isactor=false); *
 * GetVehicleOrientationPosCol(vehicleid,element_orientation:orientation,Float:distance,&Float:tx,&Float:ty,&Float:tz);             *
 * GetObjectOrientationPosCol(objectid,element_orientation:orientation,Float:distance,&Float:tx,&Float:ty,&Float:tz);               *
 * bool:IsBetweenPlayersIsWall(playerid,targetid);                                                                                  *
 * bool:IsBetweenPlayerToPointIsWall(playerid,Float:x,Float:y,Float:z);                                                             *
 * bool:GetPointInWallForPoint(Float:x,Float:y,Float:z,Float:radius,&Float:tx,&Float:ty,&Float:tz,Float:sector=90.0);               *
 * bool:IsPlayerInRangeOfVehicle(playerid,Float:range,vehicleid,bool:testLOS=true);                                                 *
 * bool:IsPlayerInRangeOfPlayer(playerid,Float:range,targetid,bool:testLOS=true);                                                   *
 * bool:IsPlayerInRangeOfObject(playerid,Float:range,objectid,bool:testLOS=true);                                                   *
 * bool:IsPlayerInRangeOfPointCol(playerid,Float:range,Float:x,Float:y,Float:z,bool:testLOS=true);                                  *
 * bool:IsPlayerInRangeOfActor(playerid,Float:range,actorid,bool:testLOS=true);                                                     *
 *                                                                                                                                  *
 * ColAndreas Extended Functions:                                                                                                   *
 * bool:IsColAndreasInit();                                                                                                         *
 * SafeColAndreasInit();                                                                                                            *
 * GetColAndreasVersion();                                                                                                          *
 * GetValidColAndreasVersion();                                                                                                     *
 * bool:IsValidColAndreas(version);                                                                                                 *
 * GetColAndreasVersionName(name[],value = GET_COLANDREAS_VERSION,maxdest = sizeof(name));                                          *
 * CheckColAndreasVersion();                                                                                                        *
 *                                                                                                                                  *
 * ColAndreas Callbacks:                                                                                                            *
 * OnColAndreasRemoveBuilding();                                                                                                    *
 *                                                                                                                                  *
 * YSF Functions:                                                                                                                   *
 * Float:GetPlayerHydraReactorRX(playerid);                                                                                         *
 * bool:IsPlayerHydraReactorBoost(playerid);                                                                                        *
 * GetPlayerRotation(playerid,&Float:rx,&Float:ry,&Float:rz);                                                                       *
 * CountTextDraw();                                                                                                                 *
 * CountPlayerTextDraw(playerid);                                                                                                   *
 * CountVisibleTextDraw(playerid);                                                                                                  *
 * CountVisiblePlayerTextDraw(playerid);                                                                                            *
 * bool:IsVehicleOnSpawn(vehicleid,Float:check_radius=1.0);                                                                         *
 * bool:IsPlayerOnSpawn(playerid,Float:check_radius=1.0);                                                                           *
 * GetRandomPointInGangZone(zoneid,&Float:tx,&Float:ty);                                                                            *
 * GetRandomPointInPlayerGangZone(playerid,zoneid,&Float:tx,&Float:ty);                                                             *
 *                                                                                                                                  *
 * YSF Functions (TimeLine):                                                                                                        *
 * UpdatePlayerTimeline(playerid);                                                                                                  *
 * GetPlayerTimeline(playerid);                                                                                                     *
 * SetPlayerTimeline(playerid,timeline);                                                                                            *
 * GetPlayerPos4D(playerid,&Float:x,&Float:y,&Float:z,&timeline);                                                                   *
 * SetPlayerPos4D(playerid,Float:x,Float:y,Float:z,timeline=0);                                                                     *
 * CreateDynamicExplosion4D(Float:x,Float:y,Float:z,type,Float:radius,worldid = -1,interiorid = -1,timeline = -1,playerid = -1,     *
 *                          Float:distance = 200.0);                                                                                *
 * TogglePlayerVisibleOnServer(playerid,bool:toggle);                                                                               *
 * bool:IsPlayerVisibleOnServer(playerid);                                                                                          *
 *                                                                                                                                  *
 * YSF Extended Functions (TimeLine):                                                                                               *
 * UpdatePlayerOnServer(playerid); //Performed automatically                                                                        *
 * CheckPlayersOnServer(playerid); //Performed automatically                                                                        *
 *                                                                                                                                  *
 * FCNPC Functions:                                                                                                                 *
 * Float:GetPointInFrontOfNPC(npcid,&Float:tx,&Float:ty,Float:radius);                                                              *
 * GetNPCOrientationPos(npcid,element_orientation:orientation,Float:distance,&Float:tx,&Float:ty,&Float:tz);                        *
 * bool:IsNPCInRangeOfPoint(npcid,Float:range,Float:x,Float:y,Float:z);                                                             *
 * Float:GetNPCSpeed(npcid);                                                                                                        *
 * Float:GetNPCTargetAngle(npcid,Float:x,Float:y,&Float:rz=0.0);                                                                    *
 * Float:SetNPCTargetAngle(npcid,Float:x,Float:y,&Float:rz=0.0);                                                                    *
 * Float:GetNPCTargetNPCAngle(npcid,targetid,&Float:rz=0.0);                                                                        *
 * Float:SetNPCTargetNPCAngle(npcid,targetid,&Float:rz=0.0);                                                                        *
 * bool:GetNPCToPointVector(npcid,Float:tx,Float:ty,Float:tz,&Float:vx,&Float:vy,&Float:vz);                                        *
 * FCNPC_SetVehicleRotation(npcid,Float:rx,Float:ry,Float:rz);                                                                      *
 * bool:FCNPC_SetVehicleTargetRotation(npcid,Float:tx,Float:ty,Float:tz,Float:ry=0.0);                                              *
 * GetNPCRotatedVector(npcid,Float:tx,Float:ty,Float:tz,&Float:vx,&Float:vy,&Float:vz,bool:return_vector=true,                      *
 *                     Float:rx=0.0,Float:ry=0.0,Float:rz=0.0);                                                                     *
 * FCNPC_GoToAir(npcid,Float:x,Float:y,Float:z,type = MOVE_TYPE_AUTO,Float:speed = MOVE_SPEED_AUTO);                                *
 *                                                                                                                                  *
 * FCNPC Functions (ColAndreas):                                                                                                    *
 * Float:GetPointInFrontOfNPCCol(npcid,&Float:tx,&Float:ty,Float:radius);                                                           *
 * GetNPCCollisionFlags(npcid);                                                                                                     *
 * bool:IsBetweenNPCsIsWall(npcid,targetid);                                                                                        *
 * bool:IsBetweenNPCToPointIsWall(npcid,Float:x,Float:y,Float:z);                                                                   *
 * GetNPCOrientationPosCol(npcid,element_orientation:orientation,Float:distance,&Float:tx,&Float:ty,&Float:tz);                     *
 * FCNPC_GoToCol(npcid,Float:x,Float:y,Float:z,type = MOVE_TYPE_AUTO,Float:speed = MOVE_SPEED_AUTO,bool:UseMapAndreas = false,      *
 *               Float:cut_size = 0.0,bool:setangle = true);                                                                        *
 * FCNPC_GoToPlayerCol(npcid,playerid,type = MOVE_TYPE_AUTO,Float:speed = MOVE_SPEED_AUTO,bool:UseMapAndreas = false,               *
 *                     Float:cut_size = 0.0,bool:setangle = true);                                                                  *
 * FCNPC_GoToPlayerOnGroundCol(npcid,playerid,type = MOVE_TYPE_AUTO,Float:speed = MOVE_SPEED_AUTO,bool:UseMapAndreas = false,       *
 *                             Float:cut_size = 1.0,Float:climbing = 2.0,bool:setangle = true);                                     *
 * FCNPC_GoToAirCol(npcid,Float:x,Float:y,Float:z,type = MOVE_TYPE_AUTO,Float:speed = MOVE_SPEED_AUTO,Float:cut_size = 0.0);        *
 * bool:IsPlayerInRangeOfNPC(playerid,Float:range,npcid,bool:testLOS=true);                                                         *
 *                                                                                                                                  *
 * FCNPC Functions (ColAndreas OR MapAndreas):                                                                                      *
 * bool:IsPointInWaterFrontOfNPC(npcid,Float:radius);                                                                               *
 *                                                                                                                                  *
 * Stream3D Functions:                                                                                                              *
 * StreamCreate(variable);                                                                                                          *
 * StreamType:GetStreamType(Stream:StreamData[Stream3D]);                                                                           *
 * Stream:ConvertAreaToStream(areaid);                                                                                              *
 * Stream:StreamCircle(Float:x,Float:y,Float:radius);                                                                               *
 * Stream:StreamCylinder3D(Float:xA,Float:yA,Float:zA,Float:xB,Float:yB,Float:zB,Float:radius);                                     *
 * Stream:StreamCylinder2D(Float:x,Float:y,Float:minz,Float:maxz,Float:radius);                                                     *
 * Stream:StreamSphere(Float:x,Float:y,Float:z,Float:radius);                                                                       *
 * Stream:StreamRectangle(Float:minx,Float:miny,Float:maxx,Float:maxy);                                                             *
 * Stream:StreamCube(Float:minx,Float:miny,Float:minz,Float:maxx,Float:maxy,Float:maxz);                                            *
 * Stream:StreamCircularSector(Float:x,Float:y,Float:rz,Float:radius,Float:view_angle);                                             *
 * Stream:StreamSphericalSector(Float:x,Float:y,Float:z,Float:rx,Float:rz,Float:radius,Float:vrx,Float:vrz);                        *
 * Stream:StreamCone3D(Float:xA,Float:yA,Float:zA,Float:xB,Float:yB,Float:zB,Float:pointA_radius,Float:pointB_radius);              *
 * bool:IsValidStream(Stream:StreamData[Stream3D]);                                                                                 *
 * bool:IsPointInStream(Float:x,Float:y,Float:z,Stream:StreamData[Stream3D]);                                                       *
 * bool:GetRandomPointInStream(Stream:StreamData[Stream3D],&Float:x,&Float:y,&Float:z);                                             *
 *                                                                                                                                  *
 * Line3D Functions:                                                                                                                *
 * Line3DCreate(variable,max_points);                                                                                               *
 * GetLine3DValue(variable,pointid,name);                                                                                           *
 * SetLine3DValue(variable,pointid,name,value);                                                                                     *
 * bool:GetLine3DPointPos(Line3D:LineData[][LinePoint3D],pointid,&Float:x,&Float:y,&Float:z,max_points = sizeof(LineData));         *
 * bool:SetLine3DPointPos(Line3D:LineData[][LinePoint3D],pointid,Float:x,Float:y,Float:z,max_points = sizeof(LineData));            *
 * bool:GetLine3DPointRot(Line3D:LineData[][LinePoint3D],pointid,&Float:rx,&Float:ry,&Float:rz,max_points = sizeof(LineData));      *
 * bool:SetLine3DPointRot(Line3D:LineData[][LinePoint3D],pointid,Float:rx,Float:ry,Float:rz,max_points = sizeof(LineData));         *
 * CountLine3DPoints(Line3D:LineData[][LinePoint3D],max_points = sizeof(LineData));                                                 *
 * AddPointToLine3D(Line3D:LineData[][LinePoint3D],Float:x,Float:y,Float:z,Float:rx=INVALID_ROTATION,                               *
 *                  Float:ry=INVALID_ROTATION,Float:rz=INVALID_ROTATION,max_points = sizeof(LineData));                             *
 *                                                                                                                                  *
 * Deprecated Functions:                                                                                                            *
 * GetXYZInFrontOfVehicle(vehicleid,Float:distance,&Float:x,&Float:y,&Float:z); //New -> GetPointInFrontOfVehicle3D                 *
 * GetRandomClockPos(Float:x,Float:y,Float:z,Float:radius,&Float:tx,&Float:ty,&Float:tz,&Float:trz,Float:rz = INVALID_ROTATION);    *
 * Float:GetActorDistanceFromPoint(actorid,Float:x,Float:y,Float:z);                                                                *
 * Float:GetObjectDistanceFromPoint(objectid,Float:x,Float:y,Float:z);                                                              *
 * Float:GetDistanceBetweenPlayers(playerid_a,playerid_b);                                                                          *
 * Float:GetDistanceBetweenVehicles(vehicleid_a,vehicleid_b);                                                                       *
 * Float:GetDistanceBetweenObjects(objectid_a,objectid_b);                                                                          *
 * Float:GetPlayerActorDistance(playerid,actorid);                                                                                  *
 * Float:GetPlayerVehicleDistance(playerid,vehicleid);                                                                              *
 * Float:GetPlayerObjectDistance(playerid,objectid);                                                                                *
 * bool:IsPlayerInCircle(playerid,Float:x,Float:y,Float:radius);                                                                    *
 * bool:IsPlayerInCylinder3D(playerid,Float:xA,Float:yA,Float:zA,Float:xB,Float:yB,Float:zB,Float:radius);                          *
 * bool:IsPlayerInCylinder2D(playerid,Float:x,Float:y,Float:minz,Float:maxz,Float:radius);                                          *
 * bool:IsPlayerInSphere(playerid,Float:x,Float:y,Float:z,Float:radius);                                                            *
 * bool:IsPlayerInRectangle(playerid,Float:minx,Float:miny,Float:maxx,Float:maxy);                                                  *
 * bool:IsPlayerInCube(playerid,Float:minx,Float:miny,Float:minz,Float:maxx,Float:maxy,Float:maxz);                                 *
 * bool:IsPlayerInPolygon(playerid,Float:points[],maxpoints = sizeof(points));                                                      *
 * bool:IsPlayerInCircularSector(playerid,Float:x,Float:y,Float:rz,Float:radius,Float:view_angle);                                  *
 * bool:IsPlayerInSphericalSector(playerid,Float:x,Float:y,Float:z,Float:rx,Float:rz,Float:radius,Float:vrx,Float:vrz);             *
 * bool:IsPlayerInCone(playerid,Float:xA,Float:yA,Float:zA,Float:xB,Float:yB,Float:zB,Float:pointA_radius,Float:pointB_radius);     *
 *                                                                                                                                  *
 * Symbols:                                                                                                                         *
 * FLOAT_PI                   - pi constant value                                                                                   *
 * FLOAT_EULER                - Euler number                                                                                        *
 * FLOAT_NAN                  - Float NaN                                                                                           *
 * FLOAT_DEFECT               - Float defect (Arc Test)                                                                             *
 * FLOAT_INFINITY             - Float Infinity                                                                                      *
 * VBTP                       - Value Bigger Than Possible                                                                          *
 * VLTP                       - Value Lower Than Possible                                                                           *
 *                                                                                                                                  *
 * Definitions:                                                                                                                     *
 * VERTICAL_CAMERA_RADIUS     - (modifiable)                                                                                        *
 * HORIZONTAL_CAMERA_RADIUS   - (modifiable)                                                                                        *
 * INVALID_ROTATION           - (modifiable)                                                                                        *
 * MAX_POLYGON_POINTS         - (modifiable)                                                                                        *
 * VEHICLE_SPEED_MULTIPLIER   - (modifiable)                                                                                        *
 * PLAYER_SPEED_MULTIPLIER    - (modifiable)                                                                                        *
 * INVALID_MOVE_TIME          - (modifiable)                                                                                        *
 * INVALID_MOVE_SPEED         - (modifiable)                                                                                        *
 * INVALID_LINE3D_POINT_ID                                                                                                          *
 *                                                                                                                                  *
 * Module ID:                                                                                                                       *
 * TRYG3D_MODULEID_MAPANDREAS - MapAndreas Plugin Module ID                                                                         *
 * TRYG3D_MODULEID_COLANDREAS - ColAndreas Plugin Module ID                                                                         *
 * TRYG3D_MODULEID_YSF        - YSF Plugin Module ID                                                                                *
 * TRYG3D_MODULEID_STREAMER   - Streamer Plugin Module ID                                                                           *
 * TRYG3D_MODULEID_FOXFOREACH - FoxForeach Include Module ID                                                                        *
 * TRYG3D_MODULEID_YSIFOREACH - YSIForeach Include Module ID                                                                        *
 * TRYG3D_MODULEID_FCNPC      - FCNPC Plugin Module ID                                                                              *
 * TRYG3D_MODULEID_STREAM3D   - Stream3D Module ID                                                                                  *
 * TRYG3D_MODULEID_LINE3D     - Line3D Module ID                                                                                    *
 *                                                                                                                                  *
 * Position Flags:                                                                                                                  *
 * POSITION_FLAG_WORLD                                                                                                              *
 * POSITION_FLAG_INTERIOR                                                                                                           *
 * POSITION_FLAG_AIR                                                                                                                *
 * POSITION_FLAG_GROUND                                                                                                             *
 * POSITION_FLAG_WATER                                                                                                              *
 * POSITION_FLAG_UNDERWATER                                                                                                         *
 * POSITION_FLAG_UNDERGROUND                                                                                                        *
 *                                                                                                                                  *
 * Vehicle Flags:                                                                                                                   *
 * VF_STREET        VF_AIRBORNE      VF_NATATORIAL    VF_MILITARY      VF_TRAIN         VF_RC            VF_CARRIAGE                *
 * VF_AIRPLANE      VF_HELICOPTER    VF_BIKES         VF_TRAILER       VF_TOWABLE       VF_POLICE                                   *
 *                                                                                                                                  *
 *                                                                                                                                  *
 * enum 'element_orientation'                                                                                                       *
 * # o_left                   - Orientation Left                                                                                    *
 * # o_right                  - Orientation Right                                                                                   *
 * # o_up                     - Orientation UP                                                                                      *
 * # o_down                   - Orientation Down                                                                                    *
 * # o_front                  - Orientation Front                                                                                   *
 * # o_back                   - Orientation Back                                                                                    *
 *                                                                                                                                  *
 * enum 'Item3D_Type'                                                                                                               *
 * # item_player                                                                                                                    *
 * # item_npc                                                                                                                       *
 * # item_actor                                                                                                                     *
 * # item_object                                                                                                                    *
 * # item_vehicle                                                                                                                   *
 * # item_dynamic_object                                                                                                            *
 * # item_dynamic_pickup                                                                                                            *
 * # item_dynamic_cp                                                                                                                *
 * # item_dynamic_racecp                                                                                                            *
 * # item_dynamic_mapicon                                                                                                           *
 * # item_dynamic_3dtext                                                                                                            *
 * # item_dynamic_actor                                                                                                             *
 *                                                                                                                                  *
 * enum 'Vectors3D'                                                                                                                 *
 * # Float: T3D:X             - Position X                                                                                          *
 * # Float: T3D:Y             - Position Y                                                                                          *
 * # Float: T3D:Z             - Position Z                                                                                          *
 * # Float: T3D:A             - Angle                                                                                               *
 *                                                                                                                                  *
 * enum 'Orions3D'                                                                                                                  *
 * # Float: T3D:orion         - First orion value                                                                                   *
 * # Float: T3D:lon           - Second orion value                                                                                  *
 * # Float: T3D:lat           - Third orion value                                                                                   *
 *                                                                                                                                  *
 * enum 'Float3D'                                                                                                                   *
 * # Float: T3D:X             - Position X                                                                                          *
 * # Float: T3D:Y             - Position Y                                                                                          *
 * # Float: T3D:Z             - Position Z                                                                                          *
 * # Float: T3D:rX            - Rotation X                                                                                          *
 * # Float: T3D:rY            - Rotation Y                                                                                          *
 * # Float: T3D:rZ            - Rotation Z                                                                                          *
 * # Float: T3D:tX            - Target Position X                                                                                   *
 * # Float: T3D:tY            - Target Position Y                                                                                   *
 * # Float: T3D:tZ            - Target Position Z                                                                                   *
 * #        T3D:VW            - Virtual World ID                                                                                    *
 * #        T3D:INT           - Interior ID                                                                                         *
 * # Float: T3D:SPEED         - Speed                                                                                               *
 *                                                                                                                                  *
 * enum 'LongFloat3D'                                                                                                               *
 * # Float: T3D:X             - Position X                                                                                          *
 * # Float: T3D:Y             - Position Y                                                                                          *
 * # Float: T3D:Z             - Position Z                                                                                          *
 * # Float: T3D:rX            - Rotation X                                                                                          *
 * # Float: T3D:rY            - Rotation Y                                                                                          *
 * # Float: T3D:rZ            - Rotation Z                                                                                          *
 * # Float: T3D:tX            - Target Position X                                                                                   *
 * # Float: T3D:tY            - Target Position Y                                                                                   *
 * # Float: T3D:tZ            - Target Position Z                                                                                   *
 * # Float: T3D:trX           - Target Rotation X                                                                                   *
 * # Float: T3D:trY           - Target Rotation Y                                                                                   *
 * # Float: T3D:trZ           - Target Rotation Z                                                                                   *
 * # Float: T3D:VecX          - Vector Position X                                                                                   *
 * # Float: T3D:VecY          - Vector Position Y                                                                                   *
 * # Float: T3D:VecZ          - Vector Position Z                                                                                   *
 * #        T3D:VW            - Virtual World ID                                                                                    *
 * #        T3D:INT           - Interior ID                                                                                         *
 * # Float: T3D:SPEED         - Speed                                                                                               *
 *                                                                                                                                  *
 * enum 'StreamType'                                                                                                                *
 * # s_invalid                                                                                                                      *
 * # s_circle                                                                                                                       *
 * # s_cylinder3d                                                                                                                   *
 * # s_cylinder2d                                                                                                                   *
 * # s_sphere                                                                                                                       *
 * # s_rectangle                                                                                                                    *
 * # s_cube                                                                                                                         *
 * # s_circularsector                                                                                                               *
 * # s_sphericalsector                                                                                                              *
 * # s_cone                                                                                                                         *
 *                                                                                                                                  *
 * enum 'LinePoint3D'                                                                                                               *
 * # bool:  T3D:PointUsed     - Is point used                                                                                       *
 * # Float: T3D:X             - Position X                                                                                          *
 * # Float: T3D:Y             - Position Y                                                                                          *
 * # Float: T3D:Z             - Position Z                                                                                          *
 * # Float: T3D:rX            - Rotation X                                                                                          *
 * # Float: T3D:rY            - Rotation Y                                                                                          *
 * # Float: T3D:rZ            - Rotation Z                                                                                          *
 *                                                                                                                                  *
 * Functions extra names:                                                                                                           *
 * GetXYInFrontOfPlayer       -> GetPointInFrontOfPlayer                                                                            *
 * GetPointInFront            -> GetPointInFront3D                                                                                  *
 * GetPointInFrontOfCamera    -> GetPointInFrontOfCamera3D                                                                          *
 * GetDistanceBetweenPoints   -> GetDistanceBetweenPoints3D                                                                         *
 * GetXYZInFrontOfVehicle     -> GetPointInFrontOfVehicle3D (Attention, different syntax)                                           *
 * GetVehicleAngle            -> GetVehicleRotation                                                                                 *
 * GetXYInFrontOfPlayerCol    -> GetPointInFrontOfPlayerCol                                                                         *
 * GetPointInFrontCol         -> GetPointInFront3DCol                                                                               *
 * GetPointInFrontOfCameraCol -> GetPointInFrontOfCamera3DCol                                                                       *
 * GetPlayersDistance         -> GetDistanceBetweenPlayers                                                                          *
 * GetVehiclesDistance        -> GetDistanceBetweenVehicles                                                                         *
 * GetObjectsDistance         -> GetDistanceBetweenObjects                                                                          *
 * Tryg3D_MapAndreasFindZ      -> CA_FindZ_For2DCoord / MapAndreasFindZ                                                             *
 * GetXYInFrontOfNPC          -> GetPointInFrontOfNPC                                                                               *
 * GetXYInFrontOfNPCCol       -> GetPointInFrontOfNPCCol                                                                            *
 *                                                                                                                                  *
 ************************************************************************************************************************************/

/*
//Check Version 3DTryg.inc
#if !defined _3D_Tryg
	#error [ADM] You need 3DTryg.inc v3.3.0
#elseif !defined Tryg3D_Version
	#error [ADM] Update you 3DTryg.inc to v3.3.0
#elseif (Tryg3D_Version < 30300)
	#error [ADM] Update you 3DTryg.inc to v3.3.0
#endif
*/

/************************************************************************************************************************************
 *                                                                                                                                  *
 * Version                                                                                                                          *
 *                                                                                                                                  *
 ************************************************************************************************************************************/
 
#if defined _3D_Tryg
	#endinput
#endif
#define _3D_Tryg

#if (!defined GetPlayerPoolSize)
	#error [ADM] This include requires SA:MP version 0.3.7
#endif

#if defined _Text_Draw_Ex
	#error [ADM] Please remove deprecated file TextDrawEx.inc
#endif

#if defined _Map_Andreas_Ex
	#error [ADM] Please remove deprecated file MapAndreasEx.inc
#endif

#define Tryg3D_Version									(30300) //a.b.c 10000*a+100*b+c
#define Tryg3D_SAMP_Version								"0.3.7"

//Update Checker
#if !defined HTTP
	#tryinclude <a_http>
#endif

#if !defined HTTP
	#tryinclude "a_http"
#endif

#if !defined HTTP
	#error [ADM] Please include a_http.inc before 3DTryg.inc
#endif


/************************************************************************************************************************************
 *                                                                                                                                  *
 * Modules                                                                                                                          *
 *                                                                                                                                  *
 ************************************************************************************************************************************/

//Tryg3D Plugin Module List
#define TRYG3D_MODULEID_MAPANDREAS						(Tryg3DModule:0b0000000000000001)
#define TRYG3D_MODULEID_COLANDREAS						(Tryg3DModule:0b0000000000000010)
#define TRYG3D_MODULEID_YSF								(Tryg3DModule:0b0000000000000100)
#define TRYG3D_MODULEID_STREAMER						(Tryg3DModule:0b0000000000001000)
#define TRYG3D_MODULEID_FOXFOREACH						(Tryg3DModule:0b0000000000010000)
#define TRYG3D_MODULEID_YSIFOREACH						(Tryg3DModule:0b0000000000100000)
#define TRYG3D_MODULEID_FCNPC							(Tryg3DModule:0b0000000001000000)
#define TRYG3D_MODULEID_STREAM3D						(Tryg3DModule:0b0000000010000000)
#define TRYG3D_MODULEID_LINE3D							(Tryg3DModule:0b0000000100000000)
#define TRYG3D_MODULEID_ACTOR 							(Tryg3DModule:0b0000001000000000)
#define TRYG3D_MODULEID_ATM   							(Tryg3DModule:0b0000010000000000)
#define TRYG3D_MODULEID_ANIMS 							(Tryg3DModule:0b0000100000000000)

//Detect MapAndreas Plugin [Slot: 1]
#if ((defined MapAndreas_FindZ_For2DCoord) && (!defined DISABLE_3D_TRYG_MAPANDREAS))
	#define Tryg3D_MapAndreas
	#define Tryg3D_MapAndreasVersion					(10201) //a.b.c 10000*a+100*b+c
	#define Tryg3D_Module_MapAndreas					(true)
#else
	#define Tryg3D_Module_MapAndreas					(false)
#endif

//Detect ColAndreas Plugin [Slot: 2]
#if ((defined COLANDREAS) && (!defined DISABLE_3D_TRYG_COLANDREAS))
	#define Tryg3D_ColAndreas
	#define Tryg3D_ColAndreasVersion					(10400) //a.b.c 10000*a+100*b+c
	#define Tryg3D_Module_ColAndreas					(true)
#else
	#define Tryg3D_Module_ColAndreas					(false)
#endif

#if !defined COLANDREAS_VERSION
	#define COLANDREAS_VERSION							(0)
#endif

//Detect YSF Plugin [Slot: 3]
#if ((defined _YSF_included) && (!defined DISABLE_3D_TRYG_YSF))
	#define Tryg3D_YSF
	#define Tryg3D_Module_YSF							(true)
#else
	#define Tryg3D_Module_YSF							(false)
#endif

//Detect Streamer Plugin [Slot: 4]
#if ((defined Streamer_AppendArrayData) && (defined INVALID_STREAMER_ID) && (!defined DISABLE_3D_TRYG_STREAMER))
	#define Tryg3D_Streamer
	#define Tryg3D_StreamerVersion						(0x282001)
	#define Tryg3D_Module_Streamer						(true)
#else
	#define Tryg3D_Module_Streamer						(false)
#endif

//Detect FoxForeach Include [Slot: 5]
//Detect YSIForeach Include [Slot: 6]
#if ((defined _FoX_Foreach) && (!defined DISABLE_3D_TRYG_FOXFOREACH))
	#define Tryg3DForeach(%0) 							FoxForeach(%0,Character)
	#define Tryg3D_FoxForeach
	
	#define Tryg3D_Module_FoxForeach					(true)
	#define Tryg3D_Module_YSIForeach					(false)
#elseif ((defined _FOREACH_LOCAL_VERSION) && (!defined DISABLE_3D_TRYG_YSIFOREACH))
	#define Tryg3DForeach(%0)							foreach(new %0 : Character)
	#define Tryg3D_YSIForeach
	
	#define Tryg3D_Module_FoxForeach					(false)
	#define Tryg3D_Module_YSIForeach					(true)
#else
	#define Tryg3DForeach(%0)							for(new %0 = 0, p_%0 = GetPlayerPoolSize(); %0 <= p_%0; %0++) if(IsPlayerConnected(%0))
	
	#define Tryg3D_Module_FoxForeach					(false)
	#define Tryg3D_Module_YSIForeach					(false)
#endif

//Detect FCNPC Plugin [Slot: 7]
#if ((defined _FCNPC_included) && (defined FCNPC_INCLUDE_VERSION) && (!defined DISABLE_3D_TRYG_FCNPC))
	#define Tryg3D_FCNPC
	#define Tryg3D_FCNPCVersion							(161) //a.b.c 100*a+10*b+c
	#define Tryg3D_Module_FCNPC							(true)
	#if (!defined MOVE_TYPE_AUTO || !defined MOVE_SPEED_AUTO)
		#error [ADM] You need update FCNPC Plugin
	#endif
#else
	#define Tryg3D_Module_FCNPC							(false)
#endif

//Detect Stream3D Module [Slot: 8]
#if defined ENABLE_3D_TRYG_STREAM3D
	#define Tryg3D_Stream3D
	#define Tryg3D_Module_Stream3D						(true)
#else
	#define Tryg3D_Module_Stream3D						(false)
#endif

//Detect Line3D Module [Slot: 9]
#if defined ENABLE_3D_TRYG_LINE3D
	#define Tryg3D_Line3D
	#define Tryg3D_Module_Line3D						(true)
#else
	#define Tryg3D_Module_Line3D						(false)
#endif

//Detect a_actor Include [Slot: 10]
#if ((defined _actor_included) && (!defined DISABLE_3D_TRYG_ACTOR))
	#define Tryg3D_Actor
	#define Tryg3D_Module_Actor							(true)
#else
	#define Tryg3D_Module_Actor							(false)
#endif

//Detect ATM Module [Slot: 11]
#if !defined DISABLE_3D_TRYG_ATM)
	#define Tryg3D_ATM
	#define Tryg3D_Module_ATM							(true)
#else
	#define Tryg3D_Module_ATM							(false)
#endif

//Detect Anims Module [Slot: 12]
#if defined ENABLE_3D_TRYG_ANIMS)
	#define Tryg3D_Anims
	#define Tryg3D_Module_Anims							(true)
#else
	#define Tryg3D_Module_Anims							(false)
#endif

//Detect i_quat Include by IllidanS4 [Slot: 102]
#if ((defined GetVehicleRotation) && (defined VectorRelToAbsQuat))
	#define Tryg3D_i_quat
#endif

//Detect Prot [Slot: 999]
#define Tryg3D_Function::								stock
#define Tryg3D_Deprecated::								stock
#define T3D:											v3D

/************************************************************************************************************************************
 *                                                                                                                                  *
 * Symbols                                                                                                                          *
 *                                                                                                                                  *
 ************************************************************************************************************************************/

#if !defined FLOAT_PI
	#define FLOAT_PI		 							(3.14159265358979323846)
#endif

#if !defined FLOAT_EULER
	#define FLOAT_EULER									(2.718281828459)
#endif

#if !defined FLOAT_NAN
	#define FLOAT_NAN 									(Float:0xFFFFFFFF)
#endif

#if !defined FLOAT_DEFECT
	#define FLOAT_DEFECT								(0.000001)
#endif

#if !defined INVALID_ROTATION
	#define INVALID_ROTATION							(-1000.0)
#endif

#if !defined VBTP
	#define VBTP 										(0x7FFFFFFF)
#endif

#if !defined VLTP
	#define VLTP 										(0x80000000)
#endif

#if !defined FLOAT_INFINITY
    #define FLOAT_INFINITY 								(Float:0x7F800000)
#endif

#if !defined MAX_POLYGON_POINTS
	#define MAX_POLYGON_POINTS 							(256)
#endif

#if !defined VEHICLE_SPEED_MULTIPLIER
	#define VEHICLE_SPEED_MULTIPLIER 					(170.0)
#endif

#if !defined PLAYER_SPEED_MULTIPLIER
	#define PLAYER_SPEED_MULTIPLIER						(1.0)
#endif

#if !defined INVALID_MOVE_TIME
	#define INVALID_MOVE_TIME 							(-1)
#endif

#if !defined INVALID_MOVE_SPEED
	#define INVALID_MOVE_SPEED							(-1.0)
#endif

#if !defined VERTICAL_CAMERA_RADIUS
	#define VERTICAL_CAMERA_RADIUS 						(55.0) // 27.5 * 2
#endif

#if !defined HORIZONTAL_CAMERA_RADIUS
	#define HORIZONTAL_CAMERA_RADIUS					(70.0) // 35.0 * 2
#endif

//Vehicle Flags
#define VF_STREET										(0b0000000000000001)
#define VF_AIRBORNE										(0b0000000000000010)
#define VF_NATATORIAL									(0b0000000000000100)
#define VF_MILITARY										(0b0000000000001000)
#define VF_TRAIN										(0b0000000000010000)
#define VF_RC		 									(0b0000000000100000)
#define VF_CARRIAGE 									(0b0000000001000000)
#define VF_AIRPLANE										(0b0000000010000000)
#define VF_HELICOPTER 									(0b0000000100000000)
#define VF_BIKES	 									(0b0000001000000000)
#define VF_TRAILER										(0b0000010000000000)
#define VF_TOWABLE										(0b0000100000000000)
#define VF_POLICE		 								(0b0001000000000000)

//Player Position Flag
#if defined Tryg3D_ColAndreas
	#define POSITION_FLAG_WORLD							(0b0000000000000001)
	#define POSITION_FLAG_INTERIOR						(0b0000000000000010)
	#define POSITION_FLAG_AIR							(0b0000000000000100)
	#define POSITION_FLAG_GROUND						(0b0000000000001000)
	#define POSITION_FLAG_WATER							(0b0000000000010000)
	#define POSITION_FLAG_UNDERWATER					(0b0000000000100000)
	#define POSITION_FLAG_UNDERGROUND					(0b0000000001000000)
#endif

/************************************************************************************************************************************
 *                                                                                                                                  *
 * Variables                                                                                                                        *
 *                                                                                                                                  *
 ************************************************************************************************************************************/

new Float:Tryg3D_StreamDistance = 300.0;

new const Float:Tryg3D_WeaponDamage[] = {
	1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,82.5,0.0,1.0,9.9,46.2,0.0,8.25,13.2,46.2,3.3,3.3,4.95,6.6,8.25,
	9.9,9.9,6.6,24.75,41.25,82.5,82.5,1.0,46.2,82.5,0.0,0.33,0.33,0.0,0.0,0.0,0.0,0.0,2.64,9.9,330.0,82.5,1.0,1.0,165.0
};

/************************************************************************************************************************************
 *                                                                                                                                  *
 * Enums                                                                                                                            *
 *                                                                                                                                  *
 ************************************************************************************************************************************/
 
enum element_orientation {
	o_left,
	o_right,
	o_up,
	o_down,
	o_front,
	o_back
}

enum Item3D_Type {
	item_player,
	item_npc,
	item_actor,
	item_object,
	item_vehicle,
	item_dynamic_object,
	item_dynamic_pickup,
	item_dynamic_cp,
	item_dynamic_racecp,
	item_dynamic_mapicon,
	item_dynamic_3dtext,
	item_dynamic_actor
}

enum Vectors3D {
	Float:T3D:X, Float:T3D:Y, Float:T3D:Z, Float:T3D:A
}

enum Orions3D {
	Float:T3D:orion, Float:T3D:lon, Float:T3D:lat
}

enum Float3D {
	Float:T3D:X, Float:T3D:Y, Float:T3D:Z,
	Float:T3D:rX, Float:T3D:rY, Float:T3D:rZ,
	
	Float:T3D:tX, Float:T3D:tY, Float:T3D:tZ,
	
	T3D:VW, T3D:INT, Float:T3D:SPEED
}

enum Float4D {
	Float:T3D:X, Float:T3D:Y, Float:T3D:Z,
	Float:T3D:rX, Float:T3D:rY, Float:T3D:rZ,
	
	Float:T3D:tX, Float:T3D:tY, Float:T3D:tZ,
	
	T3D:VW, T3D:INT, T3D:TL, Float:T3D:SPEED
}

enum LongFloat3D {
	Float:T3D:X, Float:T3D:Y, Float:T3D:Z,
	Float:T3D:rX, Float:T3D:rY, Float:T3D:rZ,
	
	Float:T3D:tX, Float:T3D:tY, Float:T3D:tZ,
	Float:T3D:trX, Float:T3D:trY, Float:T3D:trZ,
	
	Float:T3D:VecX, Float:T3D:VecY, Float:T3D:VecZ,
	
	T3D:VW, T3D:INT, Float:T3D:SPEED
}

enum LongFloat4D {
	Float:T3D:X, Float:T3D:Y, Float:T3D:Z,
	Float:T3D:rX, Float:T3D:rY, Float:T3D:rZ,
	
	Float:T3D:tX, Float:T3D:tY, Float:T3D:tZ,
	Float:T3D:trX, Float:T3D:trY, Float:T3D:trZ,
	
	Float:T3D:VecX, Float:T3D:VecY, Float:T3D:VecZ,
	
	T3D:VW, T3D:INT, T3D:TL, Float:T3D:SPEED
}

#if defined Tryg3D_Stream3D
	enum StreamType {
		s_invalid,
		s_circle,
		s_cylinder3d,
		s_cylinder2d,
		s_sphere,
		s_rectangle,
		s_cube,
		s_circularsector,
		s_sphericalsector,
		s_cone
	}

	enum Stream3D {
		StreamType:T3D:type,
		
		Float:T3D:X,	Float:T3D:Y,	Float:T3D:Z,
		
		Float:T3D:minX,	Float:T3D:minY,	Float:T3D:minZ,
		Float:T3D:maxX,	Float:T3D:maxY,	Float:T3D:maxZ,
		
		Float:T3D:R
	}
#endif

#if defined Tryg3D_Line3D
	enum LinePoint3D {
		bool:T3D:PointUsed,
		Float:T3D:X,
		Float:T3D:Y,
		Float:T3D:Z,
		Float:T3D:rX,
		Float:T3D:rY,
		Float:T3D:rZ
	}
#endif

/************************************************************************************************************************************
 *                                                                                                                                  *
 * Fixes                                                                                                                            *
 *                                                                                                                                  *
 ************************************************************************************************************************************/
 
#if !defined isnull
	#define isnull(%1) 									((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
#endif

#if !defined CreateExplosionForPlayer
	native CreateExplosionForPlayer(playerid,Float:X,Float:Y,Float:Z,type,Float:Radius);
#endif

/************************************************************************************************************************************
 *                                                                                                                                  *
 * MapAndreas Update                                                                                                                *
 *                                                                                                                                  *
 ************************************************************************************************************************************/

#if defined Tryg3D_ColAndreas
	
	//ColAndreas Version
	#define IsMapAndreasInit							Tryg3D_IsColAndreasInit
	#define SafeMapAndreasInit							Tryg3D_SafeColAndreasInit
	
	Tryg3D_Function:: Float:MapAndreasFindZ(Float:x,Float:y,&Float:z=0.0){
		if(x <= -3000.0 || x >= 3000.0 || y <= -3000.0 || y >= 3000.0){
			z = 0.0;
		} else {
			CA_FindZ_For2DCoord(x,y,z);
		}
		return z;
	}
	
	#define ColAndreasFindZ 							MapAndreasFindZ
	
#elseif defined Tryg3D_MapAndreas

	//MapAndreas Version
	#define IsMapAndreasInit							Tryg3D_IsMapAndreasInit
	#define SafeMapAndreasInit							Tryg3D_SafeMapAndreasInit
	
	Tryg3D_Function:: Float:MapAndreasFindZ(Float:x,Float:y,&Float:z=0.0){
		if(x <= -3000.0 || x >= 3000.0 || y <= -3000.0 || y >= 3000.0){
			z = 0.0;
		} else {
			MapAndreas_FindZ_For2DCoord(x,y,z);
		}
		return z;
	}
	
#endif

//Define FindZ Precision
#if defined Tryg3D_ColAndreas
	#define Tryg3D_MapAndreasFindZ						CA_FindZ_For2DCoord
	#define Tryg3DMapAndreasFindZ						Tryg3D_MapAndreasFindZ
#elseif defined Tryg3D_MapAndreas
	#define Tryg3D_MapAndreasFindZ						MapAndreasFindZ
	#define Tryg3DMapAndreasFindZ						Tryg3D_MapAndreasFindZ
#endif

/************************************************************************************************************************************
 *                                                                                                                                  *
 * Complementary Functions                                                                                                          *
 *                                                                                                                                  *
 ************************************************************************************************************************************/
 
#define ctg(%0,%1)										(1.0/floattan((%0),(%1)))
#define secans(%0,%1)									(1.0/floatcos((%0),(%1)))
#define cosecans(%0,%1)									(1.0/floatsin((%0),(%1)))

#define abs(%0)											(((%0) < 0)?(-(%0)):((%0)))
#define fabs(%0)										(((%0) < 0.0)?(-(%0)):((%0)))

#define	sqrtN(%0,%1)									floatpower((%0),(1.0/(%1)))

#define IsEven(%0)										((((%0) % 2) == 0)?(true):(false))
#define power(%0,%1)									(floatround(floatpower((%0),(%1))))

//Author: hesambia random.inc
Tryg3D_Function:: Float:RandomFloat(Float:min,Float:max,accuracy = 4){
	if(min >= max) return 0.0;
	if(min < 0.0 || max < 0.0) return 0.0;
	if(accuracy < 1 || accuracy > 6) return 0.0;
	new T3D:divValue = floatround(floatpower(10.0,accuracy));
	return random(floatround(max)-floatround(min))+min+(random(T3D:divValue)/T3D:divValue);
}
 
/************************************************************************************************************************************
 *                                                                                                                                  *
 * Internal Functions                                                                                                               *
 *                                                                                                                                  *
 ************************************************************************************************************************************/

#define single_clock(%1,%2)								((360.0/(%1))*(%2))
#define even_clock(%1,%2)								((360.0/(%1))*(2*(%2)))
#define uneven_clock(%1,%2)								((360.0/(%1))*((2*(%2))-1))

#define NLTZ(%0)										(((%0) < 0)?(0):(%0))
#define NMTZ(%0)										(((%0) > 0)?(0):(%0))
#define NLTZF(%0)										(((%0) < 0.0)?(0.0):(%0))
#define NMTZF(%0)										(((%0) > 0.0)?(0.0):(%0))

#define NLTV(%0,%1)										(((%0) < (%1))?(%1):(%0))
#define NMTV(%0,%1)										(((%0) > (%1))?(%1):(%0))
#define NLTVF(%0,%1)									(((%0) < (%1))?(%1):(%0))
#define NMTVF(%0,%1)									(((%0) > (%1))?(%1):(%0))

//swapvars by Crayder
#define Tryg3D_SwapInt(%0,%1)							(((%0) ^= (%1)), ((%1) ^= (%0)), ((%0) ^= (%1)))

Tryg3D_Function:: CompRotation(rotation,&crotation=0){
	crotation = rotation;
	while(crotation < 0) crotation += 360;
	while(crotation >= 360) crotation -= 360;
	return crotation;
}

Tryg3D_Function:: Float:CompRotationFloat(Float:rotation,&Float:crotation=0.0){
	crotation = rotation;
	while(crotation < 0.0) crotation += 360.0;
	while(crotation >= 360.0) crotation -= 360.0;
	return crotation;
}

Tryg3D_Function:: DeCompRotation(rotation,&crotation=0){
	crotation = rotation;
	while(crotation >= 180) crotation -= 360;
	while(crotation < -180) crotation += 360;
	return crotation;
}

Tryg3D_Function:: Float:DeCompRotationFloat(Float:rotation,&Float:crotation=0.0){
	crotation = rotation;
	while(crotation >= 180.0) crotation -= 360.0;
	while(crotation < -180.0) crotation += 360.0;
	return crotation;
}

Tryg3D_Function:: bool:IsRotationTest(Float:rotation,Float:r_min,Float:r_max){
	rotation = CompRotationFloat(rotation);
	r_min = CompRotationFloat(r_min);
	r_max = CompRotationFloat(r_max);
	if(r_min > r_max){
		if(((-100.0*FLOAT_DEFECT) <= rotation <= r_max+(100*FLOAT_DEFECT)) || (r_min-(100*FLOAT_DEFECT) <= rotation <= 360.0+(100*FLOAT_DEFECT))) return true;
	} else {
		if(r_min-(100.0*FLOAT_DEFECT) <= rotation <= r_max+(100.0*FLOAT_DEFECT)) return true;
	}
	return false;
}

Tryg3D_Function:: bool:Tryg3D_IsPlayerSpawned(playerid){
	#if defined ENABLE_3D_TRYG_TIMELINE_SYNC
		if(!GetPVarInt(playerid,"T3D:PlayerVisible")) return false;
	#endif
	new T3D:pstate = GetPlayerState(playerid);
	if(T3D:pstate != 1 && T3D:pstate != 2 && T3D:pstate != 3) return false;
	return true;
}

#define Tryg3D_GetWeaponDamage(%0)						Tryg3D_WeaponDamage[(%0)]

//Module: rotation.inc by Nero_3D
//Code anti-collision: YES
enum T3D:eulermode {
	// Proper / Classic Euler angles
	T3D:euler_xzx,
	T3D:euler_xyx,
	T3D:euler_yxy,
	T3D:euler_yzy,
	T3D:euler_zyz,
	T3D:euler_zxz,
	// Tait-Bryan angles
	T3D:euler_xzy,
	T3D:euler_xyz,
	T3D:euler_yxz,
	T3D:euler_yzx,
	T3D:euler_zyx, // pitch roll yaw
	T3D:euler_zxy // sa-mp
}

const T3D:eulermode: T3D:euler_default = T3D:euler_zxy;

//GetRotationMatrixFromEuler by Nero_3D
Tryg3D_Function:: Tryg3D_GetRotationMatrixEuler(Float:matrix[][],Float:rx,Float:ry,Float:rz,T3D:eulermode:mode=T3D:euler_default){
	// could be done with matrix multiplication but would be slower
	new Float:cosX = floatcos(rx,degrees),
		Float:cosY = floatcos(ry,degrees),
		Float:cosZ = floatcos(rz,degrees),
		Float:sinX = floatsin(rx,degrees),
		Float:sinY = floatsin(ry,degrees),
		Float:sinZ = floatsin(rz,degrees);

	switch(mode){
		//Proper Euler angles - 1(rx), 2(ry), 3(rz)
		case T3D:euler_xzx: {
			matrix[0][0] = cosY;
			matrix[0][1] = -cosZ * sinY;
			matrix[0][2] = sinY * sinZ;
			matrix[1][0] = cosX * sinY;
			matrix[1][1] = cosX * cosY * cosZ - sinX * sinZ;
			matrix[1][2] = -cosZ * sinX - cosX * cosY * sinZ;
			matrix[2][0] = sinX * sinY;
			matrix[2][1] = cosX * sinZ + cosY * cosZ * sinX;
			matrix[2][2] = cosX * cosZ - cosY * sinX * sinZ;
		}
		case T3D:euler_xyx: {
			matrix[0][0] = cosY;
			matrix[0][1] = sinY * sinZ;
			matrix[0][2] = cosZ * sinY;
			matrix[1][0] = sinX * sinY;
			matrix[1][1] = cosX * cosZ - cosY * sinX * sinZ;
			matrix[1][2] = -cosX * sinZ - cosY * cosZ * sinX;
			matrix[2][0] = -cosX * sinY;
			matrix[2][1] = cosZ * sinX + cosX * cosY * sinZ;
			matrix[2][2] = cosX * cosY * cosZ - sinX * sinZ;
		}
		case T3D:euler_yxy: {
			matrix[0][0] = cosX * cosZ - cosY * sinX * sinZ;
			matrix[0][1] = sinX * sinY;
			matrix[0][2] = cosX * sinZ + cosY * cosZ * sinX;
			matrix[1][0] = sinY * sinZ;
			matrix[1][1] = cosY;
			matrix[1][2] = -cosZ * sinY;
			matrix[2][0] = -cosZ * sinX - cosX * cosY * sinZ;
			matrix[2][1] = cosX * sinY;
			matrix[2][2] = cosX * cosY * cosZ - sinX * sinZ;
		}
		case T3D:euler_yzy: {
			matrix[0][0] = cosX * cosY * cosZ - sinX * sinZ;
			matrix[0][1] = -cosX * sinY;
			matrix[0][2] = cosZ * sinX + cosX * cosY * sinZ;
			matrix[1][0] = cosZ * sinY;
			matrix[1][1] = cosY;
			matrix[1][2] = sinY * sinZ;
			matrix[2][0] = -cosX * sinZ - cosY * cosZ * sinX;
			matrix[2][1] = sinX * sinY;
			matrix[2][2] = cosX * cosZ - cosY * sinX * sinZ;
		}
		case T3D:euler_zyz: {
			matrix[0][0] = cosX * cosY * cosZ - sinX * sinZ;
			matrix[0][1] = -cosZ * sinX - cosX * cosY * sinZ;
			matrix[0][2] = cosX * sinY;
			matrix[1][0] = cosX * sinZ + cosY * cosZ * sinX;
			matrix[1][1] = cosX * cosZ - cosY * sinX * sinZ;
			matrix[1][2] = sinX * sinY;
			matrix[2][0] = -cosZ * sinY;
			matrix[2][1] = sinY * sinZ;
			matrix[2][2] = cosY;
		}
		case T3D:euler_zxz: {
			matrix[0][0] = cosX * cosZ - cosY * sinX * sinZ;
			matrix[0][1] = -cosX * sinZ - cosY * cosZ * sinX;
			matrix[0][2] = sinX * sinY;
			matrix[1][0] = cosZ * sinX + cosX * cosY * sinZ;
			matrix[1][1] = cosX * cosY * cosZ - sinX * sinZ;
			matrix[1][2] = -cosX * sinY;
			matrix[2][0] = sinY * sinZ;
			matrix[2][1] = cosZ * sinY;
			matrix[2][2] = cosY;
		}
		//Tait-Bryan angles - X(rx), Y(ry), Z(rz)
		case T3D:euler_xzy: {
			matrix[0][0] = cosZ * cosY;
			matrix[0][1] = -sinZ;
			matrix[0][2] = cosZ * sinY;
			matrix[1][0] = sinX * sinY + cosX * cosY * sinZ;
			matrix[1][1] = cosX * cosZ;
			matrix[1][2] = cosX * sinZ * sinY - cosY * sinX;
			matrix[2][0] = cosY * sinX * sinZ - cosX * sinY;
			matrix[2][1] = cosZ * sinX;
			matrix[2][2] = cosX * cosY + sinX * sinZ * sinY;
		}
		case T3D:euler_xyz: {
			matrix[0][0] = cosY * cosZ;
			matrix[0][1] = -cosY * sinZ;
			matrix[0][2] = sinY;
			matrix[1][0] = cosX * sinZ + cosZ * sinX * sinY;
			matrix[1][1] = cosX * cosZ - sinX * sinY * sinZ;
			matrix[1][2] = -cosY * sinX;
			matrix[2][0] = sinX * sinZ - cosX * cosZ * sinY;
			matrix[2][1] = cosZ * sinX + cosX * sinY * sinZ;
			matrix[2][2] = cosX * cosY;
		}
		case T3D:euler_yxz: {
			matrix[0][0] = cosY * cosZ + sinY * sinX * sinZ;
			matrix[0][1] = cosZ * sinY * sinX - cosY * sinZ;
			matrix[0][2] = cosX * sinY;
			matrix[1][0] = cosX * sinZ;
			matrix[1][1] = cosX * cosZ;
			matrix[1][2] = -sinX;
			matrix[2][0] = cosY * sinX * sinZ - cosZ * sinY;
			matrix[2][1] = cosY * cosZ * sinX + sinY * sinZ;
			matrix[2][2] = cosY * cosX;
		}
		case T3D:euler_yzx: {
			matrix[0][0] = cosY * cosZ;
			matrix[0][1] = sinY * sinX - cosY * cosX * sinZ;
			matrix[0][2] = cosX * sinY + cosY * sinZ * sinX;
			matrix[1][0] = sinZ;
			matrix[1][1] = cosZ * cosX;
			matrix[1][2] = -cosZ * sinX;
			matrix[2][0] = -cosZ * sinY;
			matrix[2][1] = cosY * sinX + cosX * sinY * sinZ;
			matrix[2][2] = cosY * cosX - sinY * sinZ * sinX;
		}
		case T3D:euler_zyx: { // pitch roll yaw
			matrix[0][0] = cosZ * cosY;
			matrix[0][1] = cosZ * sinY * sinX - cosX * sinZ;
			matrix[0][2] = sinZ * sinX + cosZ * cosX * sinY;
			matrix[1][0] = cosY * sinZ;
			matrix[1][1] = cosZ * cosX + sinZ * sinY * sinX;
			matrix[1][2] = cosX * sinZ * sinY - cosZ * sinX;
			matrix[2][0] = -sinY;
			matrix[2][1] = cosY * sinX;
			matrix[2][2] = cosY * cosX;
		}
		case T3D:euler_zxy: { // sa-mp
			matrix[0][0] = cosZ * cosY - sinZ * sinX * sinY;
			matrix[0][1] = -sinZ * cosX;
			matrix[0][2] = cosZ * sinY + sinZ * sinX * cosY;
			matrix[1][0] = sinZ * cosY + cosZ * sinX * sinY;
			matrix[1][1] = cosZ * cosX;
			matrix[1][2] = sinZ * sinY - cosZ * sinX * cosY;
			matrix[2][0] = -cosX * sinY;
			matrix[2][1] = sinX;
			matrix[2][2] = cosX * cosY;
		}
	}
}

//MatrixRotate by Nero_3D
Tryg3D_Function:: Tryg3D_MatrixRotate(Float:matrix[][],Float:oX,Float:oY,Float:oZ,&Float:x,&Float:y,&Float:z){
	x += oX * matrix[0][0] + oY * matrix[0][1] + oZ * matrix[0][2]; // M * v | v = [oX, oY, oZ]
	y += oX * matrix[1][0] + oY * matrix[1][1] + oZ * matrix[1][2];
	z += oX * matrix[2][0] + oY * matrix[2][1] + oZ * matrix[2][2];
}
//End Module: rotation.inc

Tryg3D_Function:: Tryg3D_GivePlayerDamage(targetid,Float:damage,playerid,weaponid,bool:force_spawn=true,bool:death_msg=true,bool:death_call=true){
	new Float:T3D:health,Float:T3D:armour;
	GetPlayerArmour(targetid,T3D:armour);
	GetPlayerHealth(targetid,T3D:health);
	if(T3D:armour >= damage){
		SetPlayerArmour(targetid,T3D:armour-damage);
	} else if(T3D:armour < damage){
		damage -= T3D:armour;
		SetPlayerArmour(targetid,0.0);
		if(T3D:health-damage <= 0.0){
			if(force_spawn){
				SpawnPlayer(targetid);
			} else {
				SetPlayerHealth(targetid,0.0);
			}
			if(death_msg) SendDeathMessage(playerid,targetid,weaponid);
			if(death_call) CallRemoteFunction("OnPlayerDeath","ddd",targetid,playerid,weaponid);
		} else {
			SetPlayerHealth(targetid,T3D:health-damage);
		}
	} else {
		if(T3D:health-damage <= 0.0){
			if(force_spawn){
				SpawnPlayer(targetid);
			} else {
				SetPlayerHealth(targetid,0.0);
			}
			if(death_msg) SendDeathMessage(playerid,targetid,weaponid);
			if(death_call) CallRemoteFunction("OnPlayerDeath","ddd",targetid,playerid,weaponid);
		} else {
			SetPlayerHealth(targetid,T3D:health-damage);
		}
	}
}

/************************************************************************************************************************************
 *                                                                                                                                  *
 * General Functions                                                                                                                *
 *                                                                                                                                  *
 ************************************************************************************************************************************/

#define GetDistanceBetweenPoints1D(%1,%2)				VectorSize((%1)-(%2),0.0,0.0)
#define GetDistanceBetweenPoints2D(%1,%2,%3,%4)			VectorSize((%1)-(%3),(%2)-(%4),0.0)
#define GetDistanceBetweenPoints3D(%1,%2,%3,%4,%5,%6)	VectorSize((%1)-(%4),(%2)-(%5),(%3)-(%6))

#define CalculatePercent(%0,%1)							(((%0)/(%1))*100.0)

#define ShiftDegreeToRadian(%0)							((%0)*((FLOAT_PI*2)/360.0))
#define ShiftDegreeToRadianEx(%0)						((360.0-CompRotationFloat(%0))*(-((FLOAT_PI*2)/360.0)))
#define ShiftDegreeToGrades(%0)							((%0)*(10.0/9.0))
#define ShiftRadianToDegree(%0)							((%0)/((FLOAT_PI*2)/360.0))
#define ShiftRadianToDegreeEx(%0) 						(CompRotationFloat(floatabs(((%0)/((FLOAT_PI*2)/360.0))+360.0)))
#define ShiftRadianToGrades(%0)							(ShiftDegreeToGrades(ShiftRadianToDegree(%0)))
#define ShiftGradesToDegree(%0)							((%0)*0.9)
#define ShiftGradesToRadian(%0)							(ShiftDegreeToRadian(ShiftGradesToDegree(%0)))

#define ShiftRotationToVector(%0,%1,%2,%3,%4)			(GetPointInFront3D(0.0,0.0,0.0,(%0),(%1),1.0,(%2),(%3),(%4)))

#define RecoilFloat(%0,%1)								(((%0) >= 0.0)?((%0)+(%1)):((%0)-(%1)))

//old code version made by Zoutdaxv (modified version)
#define GetRotationFor2Point2D(%0,%1,%2,%3,%4)			(CompRotationFloat((atan2((%3)-(%1),(%2)-(%0))-90.0),(%4)))

#define IsPointInCylinder2D(%0,%1,%2,%3,%4,%5,%6,%7)	IsPointInCylinder3D((%0),(%1),(%2),(%3),(%4),(%5),(%3),(%4),(%6),(%7))
#define GetRandomPointOnCircle(%0,%1,%2,%3,%4)			GetPointInFront2D((%0),(%1),RandomFloat(0.0,360.0),(%2),(%3),(%4))
#define IsVehicleInRangeOfPoint(%0,%1,%2,%3,%4)			(GetVehicleDistanceFromPoint((%0),(%2),(%3),(%4)) <= (%1))

#define ShiftVectorToRotation(%0,%1,%2,%3,%4)			CompRotationFloat(-(acos(%2)-90.0),(%3)), CompRotationFloat((atan2((%1),(%0))-90.0),(%4))
#define IsPointInCircle(%0,%1,%2,%3,%4) 				(GetDistanceBetweenPoints2D((%0),(%1),(%2),(%3)) <= (%4))
#define IsPointInSphere(%0,%1,%2,%3,%4,%5,%6)			(GetDistanceBetweenPoints3D((%0),(%1),(%2),(%3),(%4),(%5)) <= (%6))
#define IsPointInRectangle(%1,%2,%3,%4,%5,%6)			(((%1) >= (%3) && (%1) <= (%5)) && ((%2) >= (%4) && (%2) <= (%6)))
#define IsPointInCube(%1,%2,%3,%4,%5,%6,%7,%8,%9)		(((%1) >= (%4) && (%1) <= (%7)) && ((%2) >= (%5) && (%2) <= (%8)) && ((%3) >= (%6) && (%3) <= (%9)))
#define GetPlayerCameraLookAt(%0,%1,%2,%3)				GetPointInFrontOfCamera3D((%0),(%1),(%2),(%3),5.0)
#define IsProbable(%0)									((random(100)+1) <= (%0))
#define GetVehicleFlags(%0)								GetVehicleFlagsByModel(GetVehicleModel(%0))
#define IsVehicleFlag(%0,%1)							((%0) & (%1))

//Universal boost
#define GetObjectDistanceFromPoint(%0,%1,%2,%3)			GetElementDistanceFromPoint((%0),item_object,(%1),(%2),(%3))
#define IsObjectInRangeOfPoint(%0,%1,%2,%3,%4)			(GetElementDistanceFromPoint((%0),item_object,(%2),(%3),(%4)) <= (%1))

#define GetPlayerObjectDistance(%1,%2)					GetElementsDistance((%1),item_player,(%1),item_object)
#define GetDistanceBetweenPlayers(%1,%2)				GetElementsDistance((%1),item_player,(%2),item_player)
#define GetDistanceBetweenVehicles(%1,%2)				GetElementsDistance((%1),item_vehicle,(%2),item_vehicle)
#define GetDistanceBetweenObjects(%1,%2)				GetElementsDistance((%1),item_object,(%2),item_object)
#define GetPlayerVehicleDistance(%1,%2)					GetElementsDistance((%1),item_player,(%2),item_object)

#define IsPlayerInCircle(%0,%1,%2,%3)					IsElementInCircle((%0),item_player,(%1),(%2),(%3))
#define IsPlayerInCylinder3D(%0,%1,%2,%3,%4,%5,%6,%7)	IsElementInCylinder3D((%0),item_player,(%1),(%2),(%3),(%4),(%5),(%6),(%7))
#define IsPlayerInCylinder2D(%0,%1,%2,%3,%4,%5)			IsElementInCylinder2D((%0),item_player,(%1),(%2),(%3),(%4),(%5))
#define IsPlayerInSphere(%0,%1,%2,%3,%4)				IsElementInSphere((%0),item_player,(%1),(%2),(%3),(%4))
#define IsPlayerInRectangle(%0,%1,%2,%3,%4)				IsElementInRectangle((%0),item_player,(%1),(%2),(%3),(%4))
#define IsPlayerInCube(%0,%1,%2,%3,%4,%5,%6)			IsElementInCube((%0),item_player,(%1),(%2),(%3),(%4),(%5),(%6))
#define IsPlayerInPolygon(%0,%1)						IsElementInPolygon((%0),item_player,(%1))
#define IsPlayerInCircularSector(%0,%1,%2,%3,%4,%5)		IsElementInCircularSector((%0),item_player,(%1),(%2),(%3),(%4),(%5))
#define IsPlayerInCone(%0,%1,%2,%3,%4,%5,%6,%7,%8)		IsElementInCone((%0),item_player,(%1),(%2),(%3),(%4),(%5),(%6),(%7),(%8))

#define IsPlayerInSphericalSector(%0,%1,%2,%3,%4,%5,%6,%7,%8)	IsElementInSphericalSector((%0),item_player,(%1),(%2),(%3),(%4),(%5),(%6),(%7),(%8))

#if !defined Tryg3D_i_quat
	//GetVehicleRotation Created by IllidanS4
	Tryg3D_Function:: GetVehicleRotation(vehicleid,&Float:rx,&Float:ry,&Float:rz){
		new Float:qw,Float:qx,Float:qy,Float:qz;
		GetVehicleRotationQuat(vehicleid,qw,qx,qy,qz);
		CompRotationFloat(asin(2*qy*qz-2*qx*qw),rx);
		CompRotationFloat(-atan2(qx*qz+qy*qw,0.5-qx*qx-qy*qy),ry);
		CompRotationFloat(-atan2(qx*qy+qz*qw,0.5-qx*qx-qz*qz),rz);
	}
#endif

Tryg3D_Function:: Float:GetLineSize2D(Float:points[][],maxpoints=sizeof(points)){
	if(maxpoints < 2) return 0.0;
	new Float:T3D:distance = 0.0;
	for(new i = 1; i < maxpoints; i++){
		T3D:distance += GetDistanceBetweenPoints2D(points[i-1][0],points[i-1][1],points[i][0],points[i][1]);
	}
	return T3D:distance;
}

Tryg3D_Function:: Float:GetLineSize3D(Float:points[][],maxpoints=sizeof(points)){
	if(maxpoints < 2) return 0.0;
	new Float:T3D:distance = 0.0;
	for(new i = 1; i < maxpoints; i++){
		T3D:distance += GetDistanceBetweenPoints3D(points[i-1][0],points[i-1][1],points[i-1][2],points[i][0],points[i][1],points[i][2]);
	}
	return T3D:distance;
}

Tryg3D_Function:: RecoilVector(&Float:vx,&Float:vy,&Float:vz,Float:sx,Float:sy,Float:sz){
	vx = RecoilFloat(vx,sx), vy = RecoilFloat(vy,sy), vz = RecoilFloat(vz,sz);
}

Tryg3D_Function:: SetPlayerLookAtPlayer(playerid,targetid,cut = CAMERA_CUT){
	new Float:x,Float:y,Float:z;
	GetPlayerPos(targetid,x,y,z);
	SetPlayerCameraLookAt(playerid,x,y,z,cut);
}

Tryg3D_Function:: Float:GetVehicleSpeed(vehicleid){
	new Float:x,Float:y,Float:z;
	GetVehicleVelocity(vehicleid,x,y,z);
	return floatmul(VectorSize(x,y,z),VEHICLE_SPEED_MULTIPLIER);
}

//Prototype function
Tryg3D_Function:: Float:GetPlayerSpeed(playerid){
	new Float:x,Float:y,Float:z;
	GetPlayerVelocity(playerid,x,y,z);
	return floatmul(VectorSize(x,y,z),PLAYER_SPEED_MULTIPLIER);
}

Tryg3D_Function:: GetVehicleFlagsByModel(modelid){
	new flag_value = 0;
	switch(modelid){
		case 425,548,417,487,497,563,469,447,488: flag_value += VF_AIRBORNE + VF_HELICOPTER;
		case 460,476,511,512,520,593,592,553,519,513,577: flag_value += VF_AIRBORNE + VF_AIRPLANE;
		case 539: flag_value += VF_AIRBORNE;
	}
	switch(modelid){
		case 425,520,432: flag_value += VF_MILITARY;
	}
	switch(modelid){
		case 472,473,493,595,484,430,453,452,446,454,539,447,460: flag_value += VF_NATATORIAL;
	}
	switch(modelid){
		case 441,464,465,501,564,594: flag_value += VF_RC;
	}
	switch(modelid){
		case 471,468,586,463,523,521,461,522,581,448,462,510,481,509: flag_value += VF_BIKES;
	}
	switch(modelid){
		case 435,450,584,590,591,606,607,608,610,611: flag_value += VF_TRAILER;
	}
	switch(modelid){
		case 449,537,538: flag_value += VF_TRAIN;
	}
	switch(modelid){
		case 569,570,590: flag_value += VF_CARRIAGE;
	}
	if(modelid == 539 || ((flag_value & VF_NATATORIAL != VF_NATATORIAL) && (flag_value & VF_AIRBORNE != VF_AIRBORNE))) flag_value += VF_STREET;
	switch(modelid){
		case 437,544,431,407,408,570,569,538,537,449,532,524,403,514,515,443,435,433,432,406: {	}

		default: {
			if(flag_value&VF_NATATORIAL!=VF_NATATORIAL && flag_value&VF_AIRBORNE!=VF_AIRBORNE && flag_value&VF_RC!=VF_RC && flag_value&VF_BIKES!=VF_BIKES){
				flag_value += VF_TOWABLE;
			}
		}

	}
	switch(modelid){
		case 416,523,427,490,407,544,596,598,597,599: flag_value += VF_POLICE;
	}
	return flag_value;
}

Tryg3D_Function:: CountPlayers(bool:isplayer=true,bool:isnpc=true){
	new T3D:count = 0;
	Tryg3DForeach(i){
		if(IsPlayerNPC(i)){
			if(isnpc) T3D:count++;
		} else {
			if(isplayer) T3D:count++;
		}
	}
	return T3D:count;
}

Tryg3D_Function:: GetRandomHit(Float:x,Float:y,Float:z,range,&Float:tx,&Float:ty,&Float:tz){
	tx = x + (random(range * 2 + 1) - range);
	ty = y + (random(range * 2 + 1) - range);
	tz = z + (random(range * 2 + 1) - range);
}

//Old code version, Updated by Nero_3D
Tryg3D_Function:: GetPointInFront2D(Float:x,Float:y,Float:rz,Float:radius,&Float:tx,&Float:ty){
	tx = x - (radius * floatsin(rz,degrees));
	ty = y + (radius * floatcos(rz,degrees));
}

//new code version support 3D made by Abyss Morgan, Update by Nero_3D
Tryg3D_Function:: GetPointInFront3D(Float:x,Float:y,Float:z,Float:rx,Float:rz,Float:radius,&Float:tx,&Float:ty,&Float:tz){
	tx = x - (radius * floatcos(rx,degrees) * floatsin(rz,degrees));
	ty = y + (radius * floatcos(rx,degrees) * floatcos(rz,degrees));
	tz = z + (radius * floatsin(rx,degrees));
}

//GetXYInFrontOfPlayer
Tryg3D_Function:: Float:GetPointInFrontOfPlayer(playerid,&Float:tx,&Float:ty,Float:radius){
	new Float:rz;
	GetPlayerPos(playerid,tx,ty,rz);
	if(IsPlayerInAnyVehicle(playerid)){
		GetVehicleZAngle(GetPlayerVehicleID(playerid),rz);
	} else {
		GetPlayerFacingAngle(playerid,rz);
	}
	GetPointInFront2D(tx,ty,rz,radius,tx,ty);
	return rz;
}

Tryg3D_Function:: GetPlayerCameraRotation(playerid,&Float:rx,&Float:rz){
	new Float:mx,Float:my,Float:mz;
	GetPlayerCameraFrontVector(playerid,mx,my,mz);
	CompRotationFloat(-(acos(mz)-90.0),rx);
	CompRotationFloat((atan2(my,mx)-90.0),rz);
}

Tryg3D_Function:: SetPlayerCameraRotation(playerid,Float:rx,Float:rz){
	new Float:x,Float:y,Float:z,Float:tx,Float:ty,Float:tz;
	GetPlayerCameraPos(playerid,x,y,z);
	GetPointInFront3D(x,y,z,rx,rz,1.0,tx,ty,tz);
	SetPlayerCameraLookAt(playerid,tx,ty,tz);
}

Tryg3D_Function:: Float:GetPlayerCameraZAngle(playerid,&Float:rz=0.0){
	new Float:mx,Float:my,Float:mz;
	GetPlayerCameraFrontVector(playerid,mx,my,mz);
	CompRotationFloat((atan2(my,mx)-90.0),rz);
	return rz;
}

Tryg3D_Function:: SetPlayerCameraZAngle(playerid,Float:rz){
	new Float:x,Float:y,Float:z,Float:tx,Float:ty,Float:tz,Float:rx,Float:tmp_float;
	GetPlayerCameraPos(playerid,x,y,z);
	GetPlayerCameraRotation(playerid,rx,tmp_float);
	GetPointInFront3D(x,y,z,rx,rz,1.0,tx,ty,tz);
	SetPlayerCameraLookAt(playerid,tx,ty,tz);
}

Tryg3D_Function:: Float:GetPointInFrontOfCamera2D(playerid,&Float:tx,&Float:ty,Float:radius){
	new Float:x,Float:y,Float:rz;
	GetPlayerCameraPos(playerid,x,y,rz);
	GetPlayerCameraZAngle(playerid,rz);
	GetPointInFront2D(x,y,rz,radius,tx,ty);
	return rz;
}

//new code version support 3D made by Abyss Morgan
Tryg3D_Function:: bool:GetRotationFor2Point3D(Float:x,Float:y,Float:z,Float:tx,Float:ty,Float:tz,&Float:rx,&Float:rz){
	new Float:radius = GetDistanceBetweenPoints3D(x,y,z,tx,ty,tz);
	if(radius <= 0.0) return false;
	CompRotationFloat(-(acos((tz-z)/radius)-90.0),rx);
	CompRotationFloat((atan2(ty-y,tx-x)-90.0),rz);
	return true;
}

//random clock pos
Tryg3D_Function:: GetRandomClockPos(Float:x,Float:y,Float:z,Float:radius,&Float:tx,&Float:ty,&Float:tz,&Float:trz,Float:rz = INVALID_ROTATION){
	if(rz == INVALID_ROTATION) rz = RandomFloat(0.0,360.0);
	GetPointInFront2D(x,y,rz,radius,tx,ty);
	CompRotationFloat(rz-180.0,trz);
	tz = z;
}

Tryg3D_Function:: Float:GetRandomPointOnClock(Float:x,Float:y,Float:radius,&Float:tx,&Float:ty,&Float:trz,Float:rz = INVALID_ROTATION){
	if(rz == INVALID_ROTATION) rz = RandomFloat(0.0,360.0);
	GetPointInFront2D(x,y,rz,radius,tx,ty);
	return CompRotationFloat(rz-180.0,trz);
}

//GetRandomPointInCircle by Crayder
Tryg3D_Function:: GetRandomPointInCircle(Float:x,Float:y,Float:radius,&Float:tx,&Float:ty){
	//"float(random(1000001)) / 1000000.0" is RandomFloat for 0.0 - 1.0.
	new Float:T3D:alfa = float(random(1000001))/1000000.0,
		Float:T3D:beta = float(random(1000001))/1000000.0;
	if(T3D:beta < T3D:alfa) Tryg3D_SwapInt(T3D:alfa,T3D:beta);
	tx = x + (T3D:beta * radius * floatcos(2.0 * FLOAT_PI * T3D:alfa / T3D:beta));
	ty = y + (T3D:beta * radius * floatsin(2.0 * FLOAT_PI * T3D:alfa / T3D:beta));
}

//GetRandomPointInCylinder2D by Crayder
Tryg3D_Function:: GetRandomPointInCylinder2D(Float:x,Float:y,Float:minz,Float:maxz,Float:radius,&Float:tx,&Float:ty,&Float:tz){
	GetRandomPointInCircle(x,y,radius,tx,ty);
	tz = RandomFloat(0.0,floatsqroot(floatpower(minz-maxz,2)))+minz;
}

Tryg3D_Function:: GetRandomPointInSphere(Float:x,Float:y,Float:z,Float:radius,&Float:tx,&Float:ty,&Float:tz){
	GetPointInFront3D(x,y,z,RandomFloat(0.0,360.0),RandomFloat(0.0,360.0),RandomFloat(0.0,radius),tx,ty,tz);
}

//GetRandomPointOnSphere by Neil Lamoureux
Tryg3D_Function:: GetRandomPointOnSphere(Float:x,Float:y,Float:z,Float:radius,&Float:tx,&Float:ty,&Float:tz){
	new Float:T3D:alfa = float(random(1000001))/1000000.0,
		Float:T3D:beta = float(random(1000001))/1000000.0,
		Float:T3D:theta = 2 * FLOAT_PI * T3D:alfa,
		Float:T3D:phi = acos(2 * T3D:beta - 1);
	tx = x + (radius * floatsin(T3D:phi,degrees) * floatcos(T3D:theta,degrees));
	ty = y + (radius * floatsin(T3D:phi,degrees) * floatsin(T3D:theta,degrees));
	tz = z + (radius * floatcos(T3D:phi,degrees));
}

Tryg3D_Function:: GetRandomPointInRectangle(Float:minx,Float:miny,Float:maxx,Float:maxy,&Float:tx,&Float:ty){
	tx = random(floatround(floatsqroot(floatpower(minx-maxx,2)))+1)+minx;
	ty = random(floatround(floatsqroot(floatpower(miny-maxy,2)))+1)+miny;
}

Tryg3D_Function:: GetRandomPointInCube(Float:minx,Float:miny,Float:minz,Float:maxx,Float:maxy,Float:maxz,&Float:tx,&Float:ty,&Float:tz){
	tx = random(floatround(floatsqroot(floatpower(minx-maxx,2)))+1)+minx;
	ty = random(floatround(floatsqroot(floatpower(miny-maxy,2)))+1)+miny;
	tz = random(floatround(floatsqroot(floatpower(minz-maxz,2)))+1)+minz;
}

Tryg3D_Function:: GetRandomPointInCircularSector(Float:x,Float:y,Float:rz,Float:radius,Float:view_angle,&Float:tx,&Float:ty){
	view_angle /= 2.0;
	new Float:rand_rz = CompRotationFloat(RandomFloat(rz-view_angle+360.0,rz+view_angle+360.0,6)),
		Float:rand_rad = RandomFloat(FLOAT_DEFECT*100.0,radius,6);
	if(rand_rad > radius) rand_rad = radius;
	rand_rz = NMTV(rand_rz,(rz+view_angle));
	rand_rz = NLTV(rand_rz,(rz-view_angle));
	GetPointInFront2D(x,y,rand_rz,rand_rad,tx,ty);
}

Tryg3D_Function:: GetRandomPointOnCircularSector(Float:x,Float:y,Float:rz,Float:radius,Float:view_angle,&Float:tx,&Float:ty){
	view_angle /= 2.0;
	new Float:rand_rz = CompRotationFloat(RandomFloat(rz-view_angle+360.0,rz+view_angle+360.0,6));
	rand_rz = NMTV(rand_rz,(rz+view_angle));
	rand_rz = NLTV(rand_rz,(rz-view_angle));
	GetPointInFront2D(x,y,rand_rz,radius,tx,ty);
}

Tryg3D_Function:: ConvertMTARaceRotation(Float:rotation1,Float:rotation2,Float:rotation3,&Float:rx,&Float:ry,&Float:rz){
	rx = ShiftRadianToDegreeEx(rotation3);
	ry = ShiftRadianToDegreeEx(rotation2);
	rz = ShiftRadianToDegreeEx(rotation1);
}

Tryg3D_Function:: ConvertToMTARaceRotation(Float:rx,Float:ry,Float:rz,&Float:rotation1,&Float:rotation2,&Float:rotation3){
	rotation3 = ShiftDegreeToRadianEx(rx);
	rotation2 = ShiftDegreeToRadianEx(ry);
	rotation1 = ShiftDegreeToRadianEx(rz);
}

Tryg3D_Function:: GetMoveTime(Float:x,Float:y,Float:z,Float:tx,Float:ty,Float:tz,Float:speed,&rtime=0){
	if(speed <= 0.0){
		rtime = INVALID_MOVE_TIME;
	} else {
		rtime = floatround((GetDistanceBetweenPoints3D(x,y,z,tx,ty,tz)/speed)*1000.0);
	}
	return rtime;
}

Tryg3D_Function:: GetSpeedForMoveTime(Float:x,Float:y,Float:z,Float:tx,Float:ty,Float:tz,&Float:speed,rtime){
	if(rtime/1000.0 <= 0.0){
		speed = INVALID_MOVE_SPEED;
	} else {
		speed = (GetDistanceBetweenPoints3D(x,y,z,tx,ty,tz)/(rtime/1000.0));
	}
}

//QuatUpVector by Nero_3D
Tryg3D_Function:: GetQuatUpVector(Float:qw,Float:qx,Float:qy,Float:qz,&Float:vx,&Float:vy,&Float:vz){
	vx = 2.0*(qy*qw+qz*qx);
	vy = 2.0*(qz*qy-qx*qw);
	vz = 1.0-(2.0*(qx*qx+qy*qy));
}

//GetQuatFromRot by Nero_3D
Tryg3D_Function:: GetQuatFromRot(Float:rx,Float:ry,Float:rz,&Float:qw,&Float:qx,&Float:qy,&Float:qz){
	rx /= 2.0;
	ry /= 2.0;
	rz /= 2.0;

	new Float:cosX = floatcos(rx,degrees), 
		Float:cosY = floatcos(ry,degrees), 
		Float:cosZ = floatcos(rz,degrees), 
		Float:sinX = floatsin(rx,degrees), 
		Float:sinY = floatsin(ry,degrees), 
		Float:sinZ = floatsin(rz,degrees); 

	qw = cosZ*cosX*cosY - sinZ*sinX*sinY; 
	qx = cosY*cosZ*sinX - sinZ*cosX*sinY; 
	qy = cosZ*cosX*sinY + cosY*sinZ*sinX; 
	qz = cosY*sinZ*cosX + cosZ*sinX*sinY; 
}

Tryg3D_Function:: bool:GetArcPointsFloor2D(Float:x,Float:y,Float:z,Float:tx,Float:ty,Float:spread,Float:points[][],max_points = sizeof(points)){
	if(max_points < 3) return false;
	
	max_points--;
	new Float:rz;
	GetRotationFor2Point2D(x,y,tx,ty,rz);
	
	if(spread <= 0.0) spread = 1.0;
	
	new Float:T3D:mercury = (1.0/(max_points)),
		Float:dist = GetDistanceBetweenPoints2D(x,y,tx,ty),
		Float:T3D:jun = (dist/2.0), Float:rsize, idx = 1;
	
	points[max_points][0] = x;
	points[max_points][1] = y;
	points[max_points][2] = z;
	
	for(new i = max_points-1; i > 0; i--){
		rsize = (dist*(T3D:mercury*idx));
		GetPointInFront2D(x,y,rz,rsize,points[i][0],points[i][1]);
		if(rsize == T3D:jun){
			points[i][2] = (z + spread);
		} else if(rsize < T3D:jun){
			//upward
			points[i][2] = (z + (rsize * (spread / T3D:jun)));
		} else {
			//downward
			points[i][2] = (z + spread - ((rsize * (spread / T3D:jun)) - spread));
		}
		idx++;
	}
	points[0][0] = tx;
	points[0][1] = ty;
	points[0][2] = z;
	return true;
}

Tryg3D_Function:: bool:GetArcPointsCellar2D(Float:x,Float:y,Float:z,Float:tx,Float:ty,Float:spread,Float:points[][],max_points = sizeof(points)){
	if(max_points < 3) return false;
	
	max_points--;
	new Float:rz;
	GetRotationFor2Point2D(x,y,tx,ty,rz);
	
	if(spread <= 0.0) spread = 1.0;
	
	new Float:T3D:mercury = (1.0/(max_points)),
		Float:dist = GetDistanceBetweenPoints2D(x,y,tx,ty),
		Float:T3D:jun = (dist/2.0), Float:rsize, idx = 1;
	
	points[max_points][0] = x;
	points[max_points][1] = y;
	points[max_points][2] = z;
	
	for(new i = max_points-1; i > 0; i--){
		rsize = (dist*(T3D:mercury*idx));
		GetPointInFront2D(x,y,rz,rsize,points[i][0],points[i][1]);
		if(rsize == T3D:jun){
			points[i][2] = (z - spread);
		} else if(rsize < T3D:jun){
			//downward
			points[i][2] = (z - (rsize * (spread / T3D:jun)));
		} else {
			//upward
			points[i][2] = ((z - spread + (rsize * (spread / T3D:jun))) - spread);
		}
		idx++;
	}
	points[0][0] = tx;
	points[0][1] = ty;
	points[0][2] = z;
	return true;
}

Tryg3D_Function:: bool:GetArcPointsLarboard2D(Float:x,Float:y,Float:z,Float:tx,Float:ty,Float:spread,Float:points[][],max_points = sizeof(points)){
	if(max_points < 3) return false;
	
	max_points--;
	new Float:rz, Float:line_x, Float:line_y, Float:trz;
	GetRotationFor2Point2D(x,y,tx,ty,rz);
	
	if(spread <= 0.0) spread = 1.0;
	
	new Float:T3D:mercury = (1.0/(max_points)),
		Float:dist = GetDistanceBetweenPoints2D(x,y,tx,ty),
		Float:T3D:jun = (dist/2.0), Float:rsize, idx = 1;
	
	points[max_points][0] = x;
	points[max_points][1] = y;
	points[max_points][2] = z;
	
	trz = CompRotationFloat(rz+90.0);
	
	for(new i = max_points-1; i > 0; i--){
		rsize = (dist*(T3D:mercury*idx));
		GetPointInFront2D(x,y,rz,rsize,line_x,line_y); //points[i][0],points[i][1]
		
		if(rsize == T3D:jun){
			GetPointInFront2D(line_x,line_y,trz,spread,points[i][0],points[i][1]);
		} else if(rsize < T3D:jun){
			//expansion
			GetPointInFront2D(line_x,line_y,trz,(rsize * (spread / T3D:jun)),points[i][0],points[i][1]);
		} else {
			//narrowing
			GetPointInFront2D(line_x,line_y,trz,(spread - ((rsize * (spread / T3D:jun)) - spread)),points[i][0],points[i][1]);
		}
		points[i][2] = z;
		idx++;
	}
	points[0][0] = tx;
	points[0][1] = ty;
	points[0][2] = z;
	return true;
}

Tryg3D_Function:: bool:GetArcPointsStarboard2D(Float:x,Float:y,Float:z,Float:tx,Float:ty,Float:spread,Float:points[][],max_points = sizeof(points)){
	if(max_points < 3) return false;
	
	max_points--;
	new Float:rz, Float:line_x, Float:line_y, Float:trz;
	GetRotationFor2Point2D(x,y,tx,ty,rz);
	
	if(spread <= 0.0) spread = 1.0;
	
	new Float:T3D:mercury = (1.0/(max_points)),
		Float:dist = GetDistanceBetweenPoints2D(x,y,tx,ty),
		Float:T3D:jun = (dist/2.0), Float:rsize, idx = 1;
	
	points[max_points][0] = x;
	points[max_points][1] = y;
	points[max_points][2] = z;
	
	trz = CompRotationFloat(rz-90.0);
	
	for(new i = max_points-1; i > 0; i--){
		rsize = (dist*(T3D:mercury*idx));
		GetPointInFront2D(x,y,rz,rsize,line_x,line_y); //points[i][0],points[i][1]
		
		if(rsize == T3D:jun){
			GetPointInFront2D(line_x,line_y,trz,spread,points[i][0],points[i][1]);
		} else if(rsize < T3D:jun){
			//expansion
			GetPointInFront2D(line_x,line_y,trz,(rsize * (spread / T3D:jun)),points[i][0],points[i][1]);
		} else {
			//narrowing
			GetPointInFront2D(line_x,line_y,trz,(spread - ((rsize * (spread / T3D:jun)) - spread)),points[i][0],points[i][1]);
		}
		points[i][2] = z;
		idx++;
	}
	points[0][0] = tx;
	points[0][1] = ty;
	points[0][2] = z;
	return true;
}

//GetVehicleUpVector by Nero_3D
Tryg3D_Function:: GetVehicleUpVector(vehicleid,&Float:vx,&Float:vy,&Float:vz){
	new Float:qw,Float:qx,Float:qy,Float:qz;
	GetVehicleRotationQuat(vehicleid,qw,qx,qy,qz);
	GetQuatUpVector(qw,-qx,-qy,-qz,vx,vy,vz);
}

Tryg3D_Function:: GetVehicleUpPos(vehicleid,Float:radius,&Float:x,&Float:y,&Float:z){
	new Float:rx,Float:rz;
	GetVehicleUpVector(vehicleid,x,y,z);
	ShiftVectorToRotation(x,y,z,rx,rz);
	GetVehiclePos(vehicleid,x,y,z);
	GetPointInFront3D(x,y,z,rx,rz,radius,x,y,z);
}

Tryg3D_Function:: GetVehicleDownPos(vehicleid,Float:radius,&Float:x,&Float:y,&Float:z){
	new Float:rx,Float:rz;
	GetVehicleUpVector(vehicleid,x,y,z);
	ShiftVectorToRotation(x,y,z,rx,rz);
	GetVehiclePos(vehicleid,x,y,z);
	GetPointInFront3D(x,y,z,CompRotationFloat(rx-180.0),rz,radius,x,y,z);
}

Tryg3D_Function:: Float:GetPointInFrontOfVehicle2D(vehicleid,&Float:tx,&Float:ty,Float:radius){
	new Float:rx,Float:ry,Float:rz,Float:x,Float:y;
	GetVehiclePos(vehicleid,x,y,rz);
	GetVehicleRotation(vehicleid,rx,ry,rz);
	GetPointInFront2D(x,y,rz,radius,tx,ty);
	return rz;
}

Tryg3D_Function:: GetPointInFrontOfVehicle3D(vehicleid,&Float:tx,&Float:ty,&Float:tz,Float:radius,&Float:rx=0.0,&Float:rz=0.0){
	new Float:ry,Float:x,Float:y,Float:z;
	GetVehiclePos(vehicleid,x,y,z);
	GetVehicleRotation(vehicleid,rx,ry,rz);
	GetPointInFront3D(x,y,z,rx,rz,radius,tx,ty,tz);
}

Tryg3D_Function:: GetPointInFrontOfCamera3D(playerid,&Float:tx,&Float:ty,&Float:tz,Float:radius,&Float:rx=0.0,&Float:rz=0.0){
	new Float:x,Float:y,Float:z;
	GetPlayerCameraPos(playerid,x,y,z);
	GetPlayerCameraRotation(playerid,rx,rz);
	GetPointInFront3D(x,y,z,rx,rz,radius,tx,ty,tz);
}

Tryg3D_Function:: bool:IsPlayerLookAtSky(playerid){
	new Float:rx,Float:rz;
	GetPlayerCameraRotation(playerid,rx,rz);
	return (rx > 0.0 && rx <= 90.0);
}

Tryg3D_Function:: GetPointFor2Point2D(Float:x1,Float:y1,Float:x2,Float:y2,Float:percent_size,&Float:tx,&Float:ty){
	new Float:rz;
	GetRotationFor2Point2D(x1,y1,x2,y2,rz);
	GetPointInFront2D(x1,y1,rz,(GetDistanceBetweenPoints2D(x1,y1,x2,y2)*(percent_size/100.0)),tx,ty);
}

Tryg3D_Function:: GetPointFor2Point3D(Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2,Float:percent_size,&Float:tx,&Float:ty,&Float:tz){
	new Float:rx,Float:rz;
	GetRotationFor2Point3D(x1,y1,z1,x2,y2,z2,rx,rz);
	GetPointInFront3D(x1,y1,z1,rx,rz,(GetDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)*(percent_size/100.0)),tx,ty,tz);
}

Tryg3D_Function:: GetPointFor2Point2DEx(Float:x1,Float:y1,Float:x2,Float:y2,Float:distance,&Float:tx,&Float:ty){
	new Float:rz;
	GetRotationFor2Point2D(x1,y1,x2,y2,rz);
	GetPointInFront2D(x1,y1,rz,distance,tx,ty);
}

Tryg3D_Function:: GetPointFor2Point3DEx(Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2,Float:distance,&Float:tx,&Float:ty,&Float:tz){
	new Float:rx,Float:rz;
	GetRotationFor2Point3D(x1,y1,z1,x2,y2,z2,rx,rz);
	GetPointInFront3D(x1,y1,z1,rx,rz,distance,tx,ty,tz);
}

Tryg3D_Function:: bool:IsPointBetween2Points2D(Float:px,Float:py,Float:xA,Float:yA,Float:xB,Float:yB){
	return (GetDistanceBetweenPoints2D(xA,yA,xB,yB) == (GetDistanceBetweenPoints2D(xA,yA,px,py) + GetDistanceBetweenPoints2D(xB,yB,px,py)));
}

Tryg3D_Function:: bool:IsPointBetween2Points3D(Float:px,Float:py,Float:pz,Float:xA,Float:yA,Float:zA,Float:xB,Float:yB,Float:zB){
	return (GetDistanceBetweenPoints3D(xA,yA,zA,xB,yB,zB) == (GetDistanceBetweenPoints3D(xA,yA,zA,px,py,pz) + GetDistanceBetweenPoints3D(xB,yB,zB,px,py,pz)));
}

//DistanceFromPointToLine by Crayder
Tryg3D_Function:: Float:GetDistanceFromPointToLine(Float:px,Float:py,Float:pz,Float:sX,Float:sY,Float:sZ,Float:eX,Float:eY,Float:eZ,&Float:iX=0.0,&Float:iY=0.0,&Float:iZ=0.0){
	new Float:dist = GetDistanceBetweenPoints3D(eX,eY,eZ,sX,sY,sZ);
	if(dist <= 0.0) return -1.0;
	new Float:T3D:U = (((px - sX) * (eX - sX)) + ((py - sY) * (eY - sY)) + ((pz - sZ) * (eZ - sZ))) / (dist*dist);
	if(T3D:U < 0.0 || T3D:U > 1.0) return -1.0;

	iX = sX + T3D:U * (eX - sX);
	iY = sY + T3D:U * (eY - sY);
	iZ = sZ + T3D:U * (eZ - sZ);

	return GetDistanceBetweenPoints3D(iX,iY,iZ,px,py,pz);
}

//Abyss Morgan Algorithm (False Ellipse Test 2D)
Tryg3D_Function:: bool:IsPointNearly2Points2D(Float:px,Float:py,Float:xA,Float:yA,Float:xB,Float:yB,Float:maxdist){
	new Float:dAB = GetDistanceBetweenPoints2D(xA,yA,xB,yB);
	return (dAB <= (GetDistanceBetweenPoints2D(xA,yA,px,py) + GetDistanceBetweenPoints2D(xB,yB,px,py)) <= (dAB+maxdist));
}

//Abyss Morgan Algorithm (False Ellipse Test 3D)
Tryg3D_Function:: bool:IsPointNearly2Points3D(Float:px,Float:py,Float:pz,Float:xA,Float:yA,Float:zA,Float:xB,Float:yB,Float:zB,Float:maxdist){
	new Float:dAB = GetDistanceBetweenPoints3D(xA,yA,zA,xB,yB,zB);
	return (dAB <= (GetDistanceBetweenPoints3D(xA,yA,zA,px,py,pz) + GetDistanceBetweenPoints3D(xB,yB,zB,px,py,pz)) <= (dAB+maxdist));
}

//IsPointInCylinder by Crayder
Tryg3D_Function:: bool:IsPointInCylinder3D(Float:px,Float:py,Float:pz,Float:xA,Float:yA,Float:zA,Float:xB,Float:yB,Float:zB,Float:radius){
	new Float:cylinder_length = GetDistanceBetweenPoints3D(xA,yA,zA,xB,yB,zB);
	if(cylinder_length <= 0.0) return false;
	new Float:iX, Float:iY, Float:iZ,
		Float:distance = GetDistanceFromPointToLine(px,py,pz,xA,yA,zA,xB,yB,zB,iX,iY,iZ),
		Float:tmp_radius = (GetDistanceBetweenPoints3D(iX,iY,iZ,xA,yA,zA) / cylinder_length * radius) + (GetDistanceBetweenPoints3D(iX,iY,iZ,xB,yB,zB) / cylinder_length * radius);
	return (distance != -1.0 && distance <= tmp_radius);
}

//Polygon Test by RyDeR SRC:http://forum.sa-mp.com/showpost.php?p=1154971&postcount=1871 (Updated)
Tryg3D_Function:: bool:IsPointInPolygon(Float:x,Float:y,Float:points[],maxpoints = sizeof(points)){
	new polygon_Sides = ((maxpoints - 2) / 2);
	if((maxpoints - 2) & 0b1 || polygon_Sides < 3) return false;
	
	new Float:polygon_Data[2][MAX_POLYGON_POINTS], cross_Total;
	
	for(new i = 0, j; i < maxpoints; i += 2, j++){
		polygon_Data[0][j] = points[i];
		polygon_Data[1][j] = points[i+1];
	}
	for(new i, j = polygon_Sides - 1; i < polygon_Sides; j = i, i++){
		if(polygon_Data[1][i] < y && polygon_Data[1][j] >= y || polygon_Data[1][j] < y && polygon_Data[1][i] >= y){
			if(polygon_Data[0][i] + (y - polygon_Data[1][i]) / (polygon_Data[1][j] - polygon_Data[1][i]) * (polygon_Data[0][j] - polygon_Data[0][i]) < x){
				cross_Total++;
			}
		}
	}
	return bool:(cross_Total & 0x1);
}

//Abyss Morgan Algorithm Circular Sector
Tryg3D_Function:: bool:IsPointInCircularSector(Float:px,Float:py,Float:x,Float:y,Float:rz,Float:radius,Float:view_angle){
	if(GetDistanceBetweenPoints2D(px,py,x,y)-radius > (FLOAT_DEFECT*100)) return false;
	new Float:trz;
	view_angle /= 2.0;
	GetRotationFor2Point2D(x,y,px,py,trz);
	return (IsRotationTest(trz,rz-view_angle,rz+view_angle));
}

//Abyss Morgan Algorithm Spherical Sector
Tryg3D_Function:: bool:IsPointInSphericalSector(Float:px,Float:py,Float:pz,Float:x,Float:y,Float:z,Float:rx,Float:rz,Float:radius,Float:vrx,Float:vrz){
	if(GetDistanceBetweenPoints3D(px,py,pz,x,y,z)-radius > (FLOAT_DEFECT*100)) return false;
	new Float:trx,Float:trz;
	vrx /= 2.0;
	vrz /= 2.0;
	if(!GetRotationFor2Point3D(x,y,z,px,py,pz,trx,trz)) return false;
	return (IsRotationTest(trx,rx-vrx,rx+vrx) && IsRotationTest(trz,rz-vrz,rz+vrz));
}

//IsPointInCone by Crayder
Tryg3D_Function:: bool:IsPointInCone3D(Float:px,Float:py,Float:pz,Float:xA,Float:yA,Float:zA,Float:xB,Float:yB,Float:zB,Float:pointA_radius,Float:pointB_radius){
	new Float:cylinder_length = GetDistanceBetweenPoints3D(xA,yA,zA,xB,yB,zB);
	if(cylinder_length <= 0.0) return false;
	new Float:iX, Float:iY, Float:iZ,
		Float:distance = GetDistanceFromPointToLine(px,py,pz,xA,yA,zA,xB,yB,zB,iX,iY,iZ),
		Float:radius = (GetDistanceBetweenPoints3D(iX,iY,iZ,xA,yA,zA) / cylinder_length * pointB_radius) + (GetDistanceBetweenPoints3D(iX,iY,iZ,xB,yB,zB) / cylinder_length * pointA_radius);
	return (distance != -1.0 && distance <= radius);
}

Tryg3D_Function:: Float:GetPlayerTargetAngle(playerid,Float:x,Float:y,&Float:rz=0.0){
	new Float:mx,Float:my;
	GetPlayerPos(playerid,mx,my,rz);
	GetRotationFor2Point2D(mx,my,x,y,rz);
	return rz;
}

Tryg3D_Function:: Float:SetPlayerTargetAngle(playerid,Float:x,Float:y,&Float:rz=0.0){
	new Float:mx,Float:my;
	GetPlayerPos(playerid,mx,my,rz);
	GetRotationFor2Point2D(mx,my,x,y,rz);
	SetPlayerFacingAngle(playerid,rz);
	return rz;
}

Tryg3D_Function:: Float:GetPlayerTargetPlayerAngle(playerid,targetid,&Float:rz=0.0){
	new Float:mx,Float:my,Float:x,Float:y;
	GetPlayerPos(playerid,mx,my,rz);
	GetPlayerPos(targetid,x,y,rz);
	GetRotationFor2Point2D(mx,my,x,y,rz);
	return rz;
}

Tryg3D_Function:: Float:SetPlayerTargetPlayerAngle(playerid,targetid,&Float:rz=0.0){
	new Float:mx,Float:my,Float:x,Float:y;
	GetPlayerPos(playerid,mx,my,rz);
	GetPlayerPos(targetid,x,y,rz);
	GetRotationFor2Point2D(mx,my,x,y,rz);
	SetPlayerFacingAngle(playerid,rz);
	return rz;
}

Tryg3D_Function:: GetObjectRotationQuat(objectid,&Float:qw,&Float:qx,&Float:qy,&Float:qz){
	new Float:rx,Float:ry,Float:rz;
	GetObjectRot(objectid,rx,ry,rz);
	GetQuatFromRot(rx,ry,rz,qw,qx,qy,qz);
}

Tryg3D_Function:: GetObjectUpVector(objectid,&Float:vx,&Float:vy,&Float:vz){
	new Float:qw,Float:qx,Float:qy,Float:qz;
	GetObjectRotationQuat(objectid,qw,qx,qy,qz);
	GetQuatUpVector(qw,qx,qy,qz,vx,vy,vz);
}

Tryg3D_Function:: GetObjectUpPos(objectid,Float:radius,&Float:x,&Float:y,&Float:z){
	new Float:rx,Float:rz;
	GetObjectUpVector(objectid,x,y,z);
	ShiftVectorToRotation(x,y,z,rx,rz);
	GetObjectPos(objectid,x,y,z);
	GetPointInFront3D(x,y,z,rx,rz,radius,x,y,z);
}

Tryg3D_Function:: GetObjectDownPos(objectid,Float:radius,&Float:x,&Float:y,&Float:z){
	new Float:rx,Float:rz;
	GetObjectUpVector(objectid,x,y,z);
	ShiftVectorToRotation(x,y,z,rx,rz);
	GetObjectPos(objectid,x,y,z);
	GetPointInFront3D(x,y,z,CompRotationFloat(rx-180.0),rz,radius,x,y,z);
}

Tryg3D_Function:: CreateDynamicExplosion(Float:x,Float:y,Float:z,type,Float:radius,worldid = -1,interiorid = -1,playerid = -1,Float:distance = 200.0){
	if(playerid == -1){
		Tryg3DForeach(i){
			new Float:px, Float:py, Float:pz;
			if(IsPlayerInAnyVehicle(i)){
				GetVehiclePos(GetPlayerVehicleID(i),px,py,pz);
			} else {
				GetPlayerPos(i,px,py,pz);
			}
			if((GetPlayerInterior(i) == interiorid || interiorid == -1) && (GetPlayerVirtualWorld(i) == worldid || worldid == -1) && (VectorSize(px-x,py-y,pz-z) <= distance)){
				CreateExplosionForPlayer(i,x,y,z,type,radius);
			}
		}
	} else {
		if(IsPlayerConnected(playerid)){
			new Float:px, Float:py, Float:pz;
			if(IsPlayerInAnyVehicle(playerid)){
				GetVehiclePos(GetPlayerVehicleID(playerid),px,py,pz);
			} else {
				GetPlayerPos(playerid,px,py,pz);
			}
			if((GetPlayerInterior(playerid) == interiorid || interiorid == -1) && (GetPlayerVirtualWorld(playerid) == worldid || worldid == -1) && (VectorSize(px-x,py-y,pz-z) <= distance)){
				CreateExplosionForPlayer(playerid,x,y,z,type,radius);
			}
		}
	}
}

Tryg3D_Function:: GetPlayerOrientationPos(playerid,element_orientation:orientation,Float:distance,&Float:tx,&Float:ty,&Float:tz,isactor=false){
	new Float:x, Float:y, Float:z, Float:rz;
	#if defined Tryg3D_Actor
		if(!isactor){
			GetPlayerPos(playerid,x,y,z);
			GetPlayerFacingAngle(playerid,rz);
		} else {
			GetActorPos(playerid,x,y,z);
			GetActorFacingAngle(playerid,rz);
		}
	#else
		#pragma unused isactor
		GetPlayerPos(playerid,x,y,z);
		GetPlayerFacingAngle(playerid,rz);
	#endif
	switch(orientation){
		case o_left:	GetPointInFront3D(x,y,z,0.0,CompRotationFloat(rz+90.0),distance,tx,ty,tz);
		case o_right:	GetPointInFront3D(x,y,z,0.0,CompRotationFloat(rz-90.0),distance,tx,ty,tz);
		case o_up:		tx = x, ty = y, tz = z + distance;
		case o_down:	tx = x, ty = y, tz = z - distance;
		case o_front:	GetPointInFront3D(x,y,z,0.0,rz,distance,tx,ty,tz);
		case o_back:	GetPointInFront3D(x,y,z,0.0,CompRotationFloat(rz+180.0),distance,tx,ty,tz);
	}
}

Tryg3D_Function:: GetVehicleOrientationPos(vehicleid,element_orientation:orientation,Float:distance,&Float:tx,&Float:ty,&Float:tz){
	new Float:x, Float:y, Float:z,
		Float:rx, Float:ry, Float:rz;
	GetVehiclePos(vehicleid,x,y,z);
	GetVehicleRotation(vehicleid,rx,ry,rz); 
	switch(orientation){
		case o_left:	GetPointInFront3D(x,y,z,ry,CompRotationFloat(rz+90.0),distance,tx,ty,tz);
		case o_right:	GetPointInFront3D(x,y,z,CompRotationFloat(ry+180.0),CompRotationFloat(rz+90.0),distance,tx,ty,tz);
		case o_up:		GetVehicleUpPos(vehicleid,distance,tx,ty,tz);
		case o_down:	GetVehicleDownPos(vehicleid,distance,tx,ty,tz);
		case o_front:	GetPointInFront3D(x,y,z,rx,rz,distance,tx,ty,tz);
		case o_back:	GetPointInFront3D(x,y,z,CompRotationFloat(rx+180.0),rz,distance,tx,ty,tz);
	}
}

Tryg3D_Function:: GetObjectOrientationPos(objectid,element_orientation:orientation,Float:distance,&Float:tx,&Float:ty,&Float:tz){
	new Float:x, Float:y, Float:z,
		Float:rx, Float:ry, Float:rz;
	GetObjectPos(objectid,x,y,z);
	GetObjectRot(objectid,rx,ry,rz); 
	switch(orientation){
		case o_left:	GetPointInFront3D(x,y,z,ry,CompRotationFloat(rz+90.0),distance,tx,ty,tz);
		case o_right:	GetPointInFront3D(x,y,z,CompRotationFloat(ry+180.0),CompRotationFloat(rz+90.0),distance,tx,ty,tz);
		case o_up:		GetObjectUpPos(objectid,distance,tx,ty,tz);
		case o_down:	GetObjectDownPos(objectid,distance,tx,ty,tz);
		case o_front:	GetPointInFront3D(x,y,z,rx,rz,distance,tx,ty,tz);
		case o_back:	GetPointInFront3D(x,y,z,CompRotationFloat(rx+180.0),rz,distance,tx,ty,tz);
	}
}

Tryg3D_Function:: GetWeaponShotPos(playerid,hittype,&Float:fx,&Float:fy,&Float:fz){
	new Float:ox,Float:oy,Float:oz;
	switch(hittype){
		case BULLET_HIT_TYPE_VEHICLE, BULLET_HIT_TYPE_OBJECT, BULLET_HIT_TYPE_PLAYER_OBJECT, BULLET_HIT_TYPE_PLAYER: {
			GetPlayerLastShotVectors(playerid,ox,oy,oz,fx,fy,fz);
		}
	}
}

Tryg3D_Function:: bool:GetPlayerToPointVector(playerid,Float:tx,Float:ty,Float:tz,&Float:vx,&Float:vy,&Float:vz){
	new Float:px,Float:py,Float:pz,Float:rx,Float:rz;
	GetPlayerPos(playerid,px,py,pz);
	if(GetRotationFor2Point3D(px,py,pz,tx,ty,tz,rx,rz)){
		ShiftRotationToVector(rx,rz,vx,vy,vz);
		return true;
	} else {
		vx = vy = vz = 0.0;
		return false;
	}
}

Tryg3D_Function:: bool:GetObjectToPointVector(objectid,Float:tx,Float:ty,Float:tz,&Float:vx,&Float:vy,&Float:vz){
	new Float:px,Float:py,Float:pz,Float:rx,Float:rz;
	GetObjectPos(objectid,px,py,pz);
	if(GetRotationFor2Point3D(px,py,pz,tx,ty,tz,rx,rz)){
		ShiftRotationToVector(rx,rz,vx,vy,vz);
		return true;
	} else {
		vx = vy = vz = 0.0;
		return false;
	}
}

Tryg3D_Function:: bool:GetVehicleToPointVector(vehicleid,Float:tx,Float:ty,Float:tz,&Float:vx,&Float:vy,&Float:vz){
	new Float:px,Float:py,Float:pz,Float:rx,Float:rz;
	GetVehiclePos(vehicleid,px,py,pz);
	if(GetRotationFor2Point3D(px,py,pz,tx,ty,tz,rx,rz)){
		ShiftRotationToVector(rx,rz,vx,vy,vz);
		return true;
	} else {
		vx = vy = vz = 0.0;
		return false;
	}
}

Tryg3D_Function:: bool:GetPointToPointVector(Float:x,Float:y,Float:z,Float:tx,Float:ty,Float:tz,&Float:vx,&Float:vy,&Float:vz){
	new Float:rx,Float:rz;
	if(GetRotationFor2Point3D(x,y,z,tx,ty,tz,rx,rz)){
		ShiftRotationToVector(rx,rz,vx,vy,vz);
		return true;
	} else {
		vx = vy = vz = 0.0;
		return false;
	}
}

//Abyss Morgan Algorithm Spherical Sector
Tryg3D_Function:: bool:IsPointInSphericalSectorEx(Float:px,Float:py,Float:pz,Float:x,Float:y,Float:z,Float:rx,Float:rz,Float:radius,Float:vrx,Float:vrz,bool:testLOS=true){
	if(GetDistanceBetweenPoints3D(px,py,pz,x,y,z) > radius) return false;
	
	vrx /= 2.0;
	vrz /= 2.0;
	
	new Float:trx,Float:trz;
	
	#if defined Tryg3D_ColAndreas
		if(testLOS){
			new Float:xC,Float:yC,Float:zC;
			CA_RayCastLine(x,y,z,px,py,pz,xC,yC,zC);
			if(!(xC == 0.0 || yC == 0.0 || zC == 0.0)) return false;
		}
	#else
		#pragma unused testLOS
	#endif
	
	if(!GetRotationFor2Point3D(x,y,z,px,py,pz,trx,trz)) return false;
	return (IsRotationTest(trx,rx-vrx,rx+vrx) && IsRotationTest(trz,rz-vrz,rz+vrz));
}

//Original code by Crayder
Tryg3D_Function:: ShiftLineRotation(Float:sX,Float:sY,Float:sZ,Float:eX,Float:eY,Float:eZ,Float:rx,Float:ry,Float:rz,&Float:nX,&Float:nY,&Float:nZ){
	//Get difference
	eX -= sX;
	eY -= sY;
	eZ -= sZ;
	//Get rotation matrix from degrees
	new Float:T3D:matrix[3][3];
	Tryg3D_GetRotationMatrixEuler(T3D:matrix,rx,ry,rz);
	Tryg3D_MatrixRotate(T3D:matrix,eX,eY,eZ,nX,nY,nZ);
}

//Original code by Crayder
Tryg3D_Function:: ShiftLineRotationVector(Float:sX,Float:sY,Float:sZ,Float:eX,Float:eY,Float:eZ,Float:rx,Float:ry,Float:rz,&Float:nX,&Float:nY,&Float:nZ){
	//Get difference
	eX -= sX;
	eY -= sY;
	eZ -= sZ;
	
	//Normalizing, but isn`t needed for the matrix rotation
	new Float:dist = VectorSize(eX,eY,eZ);
	eX /= dist;
	eY /= dist;
	eZ /= dist;
	
	//Get rotation matrix from degrees
	new Float:T3D:matrix[3][3];
	Tryg3D_GetRotationMatrixEuler(T3D:matrix,rx,ry,rz);
	Tryg3D_MatrixRotate(T3D:matrix,eX,eY,eZ,nX,nY,nZ);
}

Tryg3D_Function:: GetPlayerRotatedVector(playerid,Float:tx,Float:ty,Float:tz,&Float:vx,&Float:vy,&Float:vz,bool:return_vector=true,Float:rx=0.0,Float:ry=0.0,Float:rz=0.0){
	new Float:px,Float:py,Float:pz;
	GetPlayerPos(playerid,px,py,pz);
	if(return_vector){
		ShiftLineRotationVector(px,py,pz,tx,ty,tz,rx,ry,rz,vx,vy,vz);
	} else {
		ShiftLineRotation(px,py,pz,tx,ty,tz,rx,ry,rz,vx,vy,vz);
	}
}

Tryg3D_Function:: GetObjectRotatedVector(objectid,Float:tx,Float:ty,Float:tz,&Float:vx,&Float:vy,&Float:vz,bool:return_vector=true,Float:rx=0.0,Float:ry=0.0,Float:rz=0.0){
	new Float:px,Float:py,Float:pz;
	GetObjectPos(objectid,px,py,pz);
	if(return_vector){
		ShiftLineRotationVector(px,py,pz,tx,ty,tz,rx,ry,rz,vx,vy,vz);
	} else {
		ShiftLineRotation(px,py,pz,tx,ty,tz,rx,ry,rz,vx,vy,vz);
	}
}

Tryg3D_Function:: GetVehicleRotatedVector(vehicleid,Float:tx,Float:ty,Float:tz,&Float:vx,&Float:vy,&Float:vz,bool:return_vector=true,Float:rx=0.0,Float:ry=0.0,Float:rz=0.0){
	new Float:px,Float:py,Float:pz;
	GetVehiclePos(vehicleid,px,py,pz);
	if(return_vector){
		ShiftLineRotationVector(px,py,pz,tx,ty,tz,rx,ry,rz,vx,vy,vz);
	} else {
		ShiftLineRotation(px,py,pz,tx,ty,tz,rx,ry,rz,vx,vy,vz);
	}
}

/************************************************************************************************************************************
 *                                                                                                                                  *
 * Universal Functions                                                                                                              *
 *                                                                                                                                  *
 ************************************************************************************************************************************/

Tryg3D_Function:: bool:GetElementPos({Text3D,_}:elementid,Item3D_Type:element_type,&Float:x,&Float:y,&Float:z){
	switch(element_type){
		case item_player, item_npc: {
			GetPlayerPos(_:elementid,x,y,z);
		}
		#if defined Tryg3D_Actor
			case item_actor: {
				GetActorPos(_:elementid,x,y,z);
			}
		#endif
		case item_object: {
			GetObjectPos(_:elementid,x,y,z);
		}
		case item_vehicle: {
			GetVehiclePos(_:elementid,x,y,z);
		}
		
		#if defined Tryg3D_Streamer
			case item_dynamic_object: {
				GetDynamicObjectPos(_:elementid,x,y,z);
			}
			case item_dynamic_pickup: {
				Streamer_GetFloatData(STREAMER_TYPE_PICKUP,_:elementid,E_STREAMER_X,x);
				Streamer_GetFloatData(STREAMER_TYPE_PICKUP,_:elementid,E_STREAMER_Y,y);
				Streamer_GetFloatData(STREAMER_TYPE_PICKUP,_:elementid,E_STREAMER_Z,z);
			}
			case item_dynamic_cp: {
				Streamer_GetFloatData(STREAMER_TYPE_CP,_:elementid,E_STREAMER_X,x);
				Streamer_GetFloatData(STREAMER_TYPE_CP,_:elementid,E_STREAMER_Y,y);
				Streamer_GetFloatData(STREAMER_TYPE_CP,_:elementid,E_STREAMER_Z,z);
			}
			case item_dynamic_racecp: {
				Streamer_GetFloatData(STREAMER_TYPE_RACE_CP,_:elementid,E_STREAMER_X,x);
				Streamer_GetFloatData(STREAMER_TYPE_RACE_CP,_:elementid,E_STREAMER_Y,y);
				Streamer_GetFloatData(STREAMER_TYPE_RACE_CP,_:elementid,E_STREAMER_Z,z);
			}
			case item_dynamic_mapicon: {
				Streamer_GetFloatData(STREAMER_TYPE_MAP_ICON,_:elementid,E_STREAMER_X,x);
				Streamer_GetFloatData(STREAMER_TYPE_MAP_ICON,_:elementid,E_STREAMER_Y,y);
				Streamer_GetFloatData(STREAMER_TYPE_MAP_ICON,_:elementid,E_STREAMER_Z,z);
			}
			case item_dynamic_3dtext: {
				Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL,elementid,E_STREAMER_X,x);
				Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL,elementid,E_STREAMER_Y,y);
				Streamer_GetFloatData(STREAMER_TYPE_3D_TEXT_LABEL,elementid,E_STREAMER_Z,z);
			}
			#if defined STREAMER_TYPE_ACTOR
				case item_dynamic_actor: {
					GetDynamicActorPos(_:elementid,x,y,z);
				}
			#endif
		#endif
		default: return false;
	}
	return true;
}

Tryg3D_Function:: bool:IsElementOnPlayerScreen(playerid,{Text3D,_}:targetid,Item3D_Type:target_type=item_player,element_orientation:orientation=o_front,Float:rx=INVALID_ROTATION,Float:rz=INVALID_ROTATION,Float:vrx=VERTICAL_CAMERA_RADIUS,Float:vrz=HORIZONTAL_CAMERA_RADIUS,bool:testLOS=true,bool:testVW=true){
	new Float:x,Float:y,Float:z,Float:tx,Float:ty,Float:tz,Float:prx,Float:prz,worldid;
	GetPlayerCameraPos(playerid,x,y,z);
	GetPlayerCameraRotation(playerid,prx,prz);
	
	switch(orientation){
		case o_left:	prx = CompRotationFloat(prx+90.0);
		case o_right:	prx = CompRotationFloat(prx-90.0);
		case o_back:	prx = CompRotationFloat(prx+180.0);
	}
	
	worldid = GetPlayerVirtualWorld(playerid);
	if(rx != INVALID_ROTATION) prx = rx;
	if(rz != INVALID_ROTATION) prz = rz;
	
	if(!GetElementPos(targetid,target_type,tx,ty,tz)) return false;
	
	switch(target_type){
		case item_player, item_npc: {
			if(testVW && worldid != GetPlayerVirtualWorld(_:targetid)) return false;
		}
		#if defined Tryg3D_Actor
			case item_actor: {
				if(testVW && worldid != GetActorVirtualWorld(_:targetid)) return false;
			}
		#endif
		case item_vehicle: {
			if(testVW && worldid != GetVehicleVirtualWorld(_:targetid)) return false;
		}
		#if defined Tryg3D_Streamer
			case item_dynamic_object: {
				if(testVW && worldid != Streamer_GetIntData(STREAMER_TYPE_OBJECT,_:targetid,E_STREAMER_WORLD_ID)) return false;
			}
			case item_dynamic_pickup: {
				if(testVW && worldid != Streamer_GetIntData(STREAMER_TYPE_PICKUP,_:targetid,E_STREAMER_WORLD_ID)) return false;
			}
			case item_dynamic_cp: {
				if(testVW && worldid != Streamer_GetIntData(STREAMER_TYPE_CP,_:targetid,E_STREAMER_WORLD_ID)) return false;
			}
			case item_dynamic_racecp: {
				if(testVW && worldid != Streamer_GetIntData(STREAMER_TYPE_RACE_CP,_:targetid,E_STREAMER_WORLD_ID)) return false;
			}
			case item_dynamic_mapicon: {
				if(testVW && worldid != Streamer_GetIntData(STREAMER_TYPE_MAP_ICON,_:targetid,E_STREAMER_WORLD_ID)) return false;
			}
			case item_dynamic_3dtext: {
				if(testVW && worldid != Streamer_GetIntData(STREAMER_TYPE_3D_TEXT_LABEL,targetid,E_STREAMER_WORLD_ID)) return false;
			}
			#if defined STREAMER_TYPE_ACTOR
				case item_dynamic_actor: {
					if(testVW && worldid != GetDynamicActorVirtualWorld(_:targetid)) return false;
				}
			#endif
		#endif
		default: return false;
	}
	return IsPointInSphericalSectorEx(tx,ty,tz,x,y,z,prx,prz,Tryg3D_StreamDistance,vrx,vrz,testLOS);
}

Tryg3D_Function:: bool:IsElementOnFakeScreen(Float:x,Float:y,Float:z,{Text3D,_}:targetid,Item3D_Type:target_type,Float:rx,Float:rz,Float:vrx=VERTICAL_CAMERA_RADIUS,Float:vrz=HORIZONTAL_CAMERA_RADIUS,bool:testLOS=true){
	new Float:tx,Float:ty,Float:tz;
	if(!GetElementPos(targetid,target_type,tx,ty,tz)) return false;
	return IsPointInSphericalSectorEx(tx,ty,tz,x,y,z,rx,rz,Tryg3D_StreamDistance,vrx,vrz,testLOS);
}

Tryg3D_Function:: Float:GetElementsDistance({Text3D,_}:elementid,Item3D_Type:element_type,{Text3D,_}:targetid,Item3D_Type:target_type){
	new Float:x,Float:y,Float:z,Float:tx,Float:ty,Float:tz;
	if(!GetElementPos(elementid,element_type,x,y,z)) return -1.0;
	if(!GetElementPos(targetid,target_type,tx,ty,tz)) return -1.0;
	return GetDistanceBetweenPoints3D(x,y,z,tx,ty,tz);
}

Tryg3D_Function:: Float:GetElementDistanceFromPoint({Text3D,_}:elementid,Item3D_Type:element_type,Float:x,Float:y,Float:z){
	new Float:tx,Float:ty,Float:tz;
	if(!GetElementPos(elementid,element_type,tx,ty,tz)) return -1.0;
	return GetDistanceBetweenPoints3D(x,y,z,tx,ty,tz);
}

Tryg3D_Function:: bool:IsElementInCircle({Text3D,_}:elementid,Item3D_Type:element_type,Float:x,Float:y,Float:radius){
	new Float:px,Float:py,Float:pz;
	GetElementPos(elementid,element_type,px,py,pz);
	return IsPointInCircle(px,py,x,y,radius);
}

Tryg3D_Function:: bool:IsElementInCylinder3D({Text3D,_}:elementid,Item3D_Type:element_type,Float:xA,Float:yA,Float:zA,Float:xB,Float:yB,Float:zB,Float:radius){
	new Float:px,Float:py,Float:pz;
	GetElementPos(elementid,element_type,px,py,pz);
	return IsPointInCylinder3D(px,py,pz,xA,yA,zA,xB,yB,zB,radius);
}

Tryg3D_Function:: bool:IsElementInCylinder2D({Text3D,_}:elementid,Item3D_Type:element_type,Float:x,Float:y,Float:minz,Float:maxz,Float:radius){
	new Float:px,Float:py,Float:pz;
	GetElementPos(elementid,element_type,px,py,pz);
	return IsPointInCylinder2D(px,py,pz,x,y,minz,maxz,radius);
}

Tryg3D_Function:: bool:IsElementInSphere({Text3D,_}:elementid,Item3D_Type:element_type,Float:x,Float:y,Float:z,Float:radius){
	new Float:px,Float:py,Float:pz;
	GetElementPos(elementid,element_type,px,py,pz);
	return IsPointInSphere(px,py,pz,x,y,z,radius);
}

Tryg3D_Function:: bool:IsElementInRectangle({Text3D,_}:elementid,Item3D_Type:element_type,Float:minx,Float:miny,Float:maxx,Float:maxy){
	new Float:px,Float:py,Float:pz;
	GetElementPos(elementid,element_type,px,py,pz);
	return IsPointInRectangle(px,py,minx,miny,maxx,maxy);
}

Tryg3D_Function:: bool:IsElementInCube({Text3D,_}:elementid,Item3D_Type:element_type,Float:minx,Float:miny,Float:minz,Float:maxx,Float:maxy,Float:maxz){
	new Float:px,Float:py,Float:pz;
	GetElementPos(elementid,element_type,px,py,pz);
	return IsPointInCube(px,py,pz,minx,miny,minz,maxx,maxy,maxz);
}

Tryg3D_Function:: bool:IsElementInPolygon({Text3D,_}:elementid,Item3D_Type:element_type,Float:points[],maxpoints = sizeof(points)){
	new Float:px,Float:py,Float:pz;
	GetElementPos(elementid,element_type,px,py,pz);
	return IsPointInPolygon(px,py,points,maxpoints);
}

Tryg3D_Function:: bool:IsElementInCircularSector({Text3D,_}:elementid,Item3D_Type:element_type,Float:x,Float:y,Float:rz,Float:radius,Float:view_angle){
	new Float:px,Float:py,Float:pz;
	GetElementPos(elementid,element_type,px,py,pz);
	return IsPointInCircularSector(px,py,x,y,rz,radius,view_angle);
}

Tryg3D_Function:: bool:IsElementInSphericalSector({Text3D,_}:elementid,Item3D_Type:element_type,Float:x,Float:y,Float:z,Float:rx,Float:rz,Float:radius,Float:vrx,Float:vrz){
	new Float:px,Float:py,Float:pz;
	GetElementPos(elementid,element_type,px,py,pz);
	return IsPointInSphericalSector(px,py,pz,x,y,z,rx,rz,radius,vrx,vrz);
}

Tryg3D_Function:: bool:IsElementInCone({Text3D,_}:elementid,Item3D_Type:element_type,Float:xA,Float:yA,Float:zA,Float:xB,Float:yB,Float:zB,Float:pointA_radius,Float:pointB_radius){
	new Float:px,Float:py,Float:pz;
	GetElementPos(elementid,element_type,px,py,pz);
	return IsPointInCone3D(px,py,pz,xA,yA,zA,xB,yB,zB,pointA_radius,pointB_radius);
}

/************************************************************************************************************************************
 *                                                                                                                                  *
 * Animation Functions                                                                                                              *
 *                                                                                                                                  *
 ************************************************************************************************************************************/
 
#if defined Tryg3D_Anims
	Tryg3D_Function:: bool:IsPlayerSkydiving(playerid){
		new T3D:index = GetPlayerAnimationIndex(playerid);
		return (T3D:index >= 958 && T3D:index <= 962);
	}

	Tryg3D_Function:: bool:IsPlayerUsingParachute(playerid){
		new T3D:index = GetPlayerAnimationIndex(playerid);
		return (T3D:index >= 963 && T3D:index <= 979);
	}

	Tryg3D_Function:: bool:IsPlayerAiming(playerid){
		switch(GetPlayerAnimationIndex(playerid)){
			case 1160..1163,1167,1365,1643,1453,220: return true;
		}
		return false;
	}

	Tryg3D_Function:: bool:IsPlayerStay(playerid){
		new T3D:index = GetPlayerAnimationIndex(playerid);
		return (T3D:index == 1189 || T3D:index == 1133);
	}

	Tryg3D_Function:: bool:IsPlayerRunning(playerid){
		new T3D:index = GetPlayerAnimationIndex(playerid);
		return (T3D:index == 1231 || T3D:index == 1266 || T3D:index == 1196);
	}

	Tryg3D_Function:: bool:IsPlayerSwim(playerid){
		new T3D:index = GetPlayerAnimationIndex(playerid);
		return (T3D:index == 1538 || T3D:index == 1539 || T3D:index == 1541 || T3D:index == 1544);
	}

	Tryg3D_Function:: bool:IsPlayerJump(playerid){
		new T3D:index = GetPlayerAnimationIndex(playerid);
		return (T3D:index == 1195 || T3D:index == 1198);
	}

	Tryg3D_Function:: bool:IsPlayerParaFall(playerid){
		new T3D:index = GetPlayerAnimationIndex(playerid);
		return (T3D:index == 958 || T3D:index == 959 || T3D:index == 961 || T3D:index == 962 || T3D:index == 1134);
	}

	Tryg3D_Function:: bool:IsPlayerParaGlide(playerid){
		new T3D:index = GetPlayerAnimationIndex(playerid);
		return (T3D:index == 963 || T3D:index == 965 || T3D:index == 971 || T3D:index == 976 || T3D:index == 978);
	}

	Tryg3D_Function:: bool:IsPlayerFall(playerid){
		return (GetPlayerAnimationIndex(playerid) == 1130);
	}
#endif

/************************************************************************************************************************************
 *                                                                                                                                  *
 * Extended Functions                                                                                                               *
 *                                                                                                                                  *
 ************************************************************************************************************************************/

 //flag_a
#define Tryg3D_GetActiveCount() 							GetSVarInt("ADM:3DTryg:ACTIVE")
#define Tryg3D_GetErrorCount() 							GetSVarInt("ADM:3DTryg:Error")
#define Tryg3D_ResetErrorCount() 						SetSVarInt("ADM:3DTryg:Error",0)
#define Update3DTrygErrorCount() 						SetSVarInt("ADM:3DTryg:Error",Tryg3D_GetErrorCount()+1)

#define Tryg3D_SetStreamDistance(%0)					Tryg3D_StreamDistance = (%0)
#define Tryg3D_GetStreamDistance()						Tryg3D_StreamDistance

Tryg3D_Function:: Tryg3D_GetModules(&modules_count=0){
	modules_count = 0;
	new T3D:string[128];
	#if (defined Tryg3D_YSF && defined ENABLE_3D_TRYG_TIMELINE_SYNC)
		format(T3D:string,sizeof(T3D:string),"4D");
	#else
		format(T3D:string,sizeof(T3D:string),"3D");
	#endif
	
	#if defined Tryg3D_MapAndreas
		format(T3D:string,sizeof(T3D:string),"%s:MapAndreas",T3D:string);
		modules_count++;
	#endif
	
	#if defined Tryg3D_ColAndreas
		format(T3D:string,sizeof(T3D:string),"%s:ColAndreas",T3D:string);
		modules_count++;
	#endif
	
	#if defined Tryg3D_YSF
		format(T3D:string,sizeof(T3D:string),"%s:YSF",T3D:string);
		modules_count++;
	#endif
	
	#if defined Tryg3D_Streamer
		format(T3D:string,sizeof(T3D:string),"%s:Streamer",T3D:string);
		modules_count++;
	#endif
	
	#if defined Tryg3D_FoxForeach
		format(T3D:string,sizeof(T3D:string),"%s:FoxForeach",T3D:string);
		modules_count++;
	#endif
	
	#if defined Tryg3D_YSIForeach
		format(T3D:string,sizeof(T3D:string),"%s:YSIForeach",T3D:string);
		modules_count++;
	#endif
	
	#if defined Tryg3D_FCNPC
		format(T3D:string,sizeof(T3D:string),"%s:FCNPC",T3D:string);
		modules_count++;
	#endif
	
	#if defined Tryg3D_Stream3D
		format(T3D:string,sizeof(T3D:string),"%s:Stream3D",T3D:string);
		modules_count++;
	#endif
	
	#if defined Tryg3D_Line3D
		format(T3D:string,sizeof(T3D:string),"%s:Line3D",T3D:string);
		modules_count++;
	#endif
	
	#if defined Tryg3D_Actor
		format(T3D:string,sizeof(T3D:string),"%s:Actor",T3D:string);
		modules_count++;
	#endif
	
	#if defined Tryg3D_ATM
		format(T3D:string,sizeof(T3D:string),"%s:ATM",T3D:string);
		modules_count++;
	#endif
	
	#if defined Tryg3D_Anims
		format(T3D:string,sizeof(T3D:string),"%s:Anims",T3D:string);
		modules_count++;
	#endif
	
	return T3D:string;
}

Tryg3D_Function:: bool:Tryg3D_IsModuleLoaded(Tryg3DModule:moduleid){
	switch(moduleid){
		case TRYG3D_MODULEID_MAPANDREAS:	return Tryg3D_Module_MapAndreas;
		case TRYG3D_MODULEID_COLANDREAS:	return Tryg3D_Module_ColAndreas;
		case TRYG3D_MODULEID_YSF:			return Tryg3D_Module_YSF;
		case TRYG3D_MODULEID_STREAMER:		return Tryg3D_Module_Streamer;
		case TRYG3D_MODULEID_FOXFOREACH:	return Tryg3D_Module_FoxForeach;
		case TRYG3D_MODULEID_YSIFOREACH:	return Tryg3D_Module_YSIForeach;
		case TRYG3D_MODULEID_FCNPC:			return Tryg3D_Module_FCNPC;
		case TRYG3D_MODULEID_STREAM3D:		return Tryg3D_Module_Stream3D;
		case TRYG3D_MODULEID_LINE3D:		return Tryg3D_Module_Line3D;
		case TRYG3D_MODULEID_ACTOR:			return Tryg3D_Module_Actor;
		case TRYG3D_MODULEID_ATM:			return Tryg3D_Module_ATM;
		case TRYG3D_MODULEID_ANIMS:			return Tryg3D_Module_Anims;
	}
	return false;
}

Tryg3D_Function:: Tryg3D_GetEfficiency(bool:use_colandreas=false){
	new test_time = GetTickCount();
	#if defined Tryg3D_ColAndreas
		if(use_colandreas){
			for(new rx = 0; rx < 360; rx++){
				for(new rz = 0; rz < 360; rz++){
					new Float:tx,Float:ty,Float:tz,Float:grx,Float:grz,Float:dist;
					GetPointInFront3DCol(0.0,0.0,0.0,float(rx),float(rz),100.0,tx,ty,tz);
					GetRotationFor2Point3D(0.0,0.0,0.0,tx,ty,tz,grx,grz);
					dist = GetDistanceBetweenPoints3D(0.0,0.0,0.0,tx,ty,tz);
					GetPointFor2Point3DEx(0.0,0.0,0.0,tx,ty,tz,(dist/2.0),tx,ty,tz);
				}
			}
		} else {
			for(new rx = 0; rx < 360; rx++){
				for(new rz = 0; rz < 360; rz++){
					new Float:tx,Float:ty,Float:tz,Float:grx,Float:grz,Float:dist;
					GetPointInFront3D(0.0,0.0,0.0,float(rx),float(rz),100.0,tx,ty,tz);
					GetRotationFor2Point3D(0.0,0.0,0.0,tx,ty,tz,grx,grz);
					dist = GetDistanceBetweenPoints3D(0.0,0.0,0.0,tx,ty,tz);
					GetPointFor2Point3DEx(0.0,0.0,0.0,tx,ty,tz,(dist/2.0),tx,ty,tz);
				}
			}
		}
	#else
		#pragma unused use_colandreas
		for(new rx = 0; rx < 360; rx++){
			for(new rz = 0; rz < 360; rz++){
				new Float:tx,Float:ty,Float:tz,Float:grx,Float:grz,Float:dist;
				GetPointInFront3D(0.0,0.0,0.0,float(rx),float(rz),100.0,tx,ty,tz);
				GetRotationFor2Point3D(0.0,0.0,0.0,tx,ty,tz,grx,grz);
				dist = GetDistanceBetweenPoints3D(0.0,0.0,0.0,tx,ty,tz);
				GetPointFor2Point3DEx(0.0,0.0,0.0,tx,ty,tz,(dist/2.0),tx,ty,tz);
			}
		}
	#endif
	return (GetTickCount()-test_time);
}

/************************************************************************************************************************************
 *                                                                                                                                  *
 * Useless Functions                                                                                                   (MarihuanKa) *
 *                                                                                                                                  *
 ************************************************************************************************************************************/
 
//These functions has been created in order to hinder thieves life.
Tryg3D_Function:: ShiftPositionToOrion(Float:x,Float:y,Float:z,&Float:orion,&Float:lon,&Float:lat){
	orion = VectorSize(x,y,z);
	if(orion == 0.0){
		lon = lat = 0.0;
	} else {
		x /= orion;
		y /= orion;
		z /= orion;
		ShiftVectorToRotation(x,y,z,lon,lat);
	}
}

Tryg3D_Function:: ShiftOrionToPosition(Float:orion,Float:lon,Float:lat,&Float:x,&Float:y,&Float:z){
	if(orion == 0.0){
		x = y = z = 0.0;
	} else {
		GetPointInFront3D(0.0,0.0,0.0,lon,lat,orion,x,y,z);
	}
}

/************************************************************************************************************************************
 *                                                                                                                                  *
 * ATM Module Functions                                                                                                             *
 *                                                                                                                                  *
 ************************************************************************************************************************************/
 
//Module: ATM.inc
//Code anti-collision: YES

#if defined Tryg3D_ATM
	#if !defined randomex
		#define randomex(%0,%1) 							(random((%1)-(%0)+1)+(%0))
	#endif

	#define Tryg3D_KeyPressed(%0) 							(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
	#define Tryg3D_KeyReleased(%0)							(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))
	#define Tryg3D_KeyHolding(%0) 							((newkeys & (%0)) == (%0))

	//%d:%02d:%02d:%02d
	#define v3DSecToTimeDay(%0)								((%0) / 86400),(((%0) % 86400) / 3600),((((%0) % 86400) % 3600) / 60),((((%0) % 86400) % 3600) % 60)
	#define v3DMSToTimeDay(%0)								v3DSecToTimeDay((%0)/1000)
	//%02d:%02d:%02d
	#define v3DSecToTime(%0)								((%0) / 3600),(((%0) % 3600) / 60),(((%0) % 3600) % 60)
	#define v3DMSToTime(%0)									v3DSecToTime((%0)/1000)
	//%02d:%02d
	#define v3DSecToTimeMini(%0)							((%0) / 60),((%0) % 60)
	#define v3DMSToTimeMini(%0)								v3DSecToTimeMini((%0)/1000)

	#define v3Dfunction%0(%1)								forward %0(%1); public %0(%1)

	Tryg3D_Function:: T3D:GetSAMIncludeVersion(value,name[],maxdest = sizeof(name)){
		format(name,maxdest,"%d.%d.%d",(value / 10000),((value % 10000) / 100),((value % 10000) % 100));
	}

	Tryg3D_Function:: T3D:DisableADMLogging(bool:disable){
		if(disable){
			SetSVarInt("ADM:Logging:Disable",1);
		} else {
			SetSVarInt("ADM:Logging:Disable",0);
		}
	}
	
#endif
//End Module: ATM.inc

/************************************************************************************************************************************
 *                                                                                                                                  *
 * Actor Functions                                                                                                                  *
 *                                                                                                                                  *
 ************************************************************************************************************************************/
 
#if defined Tryg3D_Actor

	#define GetActorDistanceFromPoint(%0,%1,%2,%3)	GetElementDistanceFromPoint((%0),item_actor,(%1),(%2),(%3))
	#define GetPlayerActorDistance(%1,%2)			GetElementsDistance((%1),item_player,(%1),item_actor)
	#define IsActorInRangeOfPoint(%0,%1,%2,%3,%4)	(GetElementDistanceFromPoint((%0),item_actor,(%2),(%3),(%4)) <= (%1))	
	
	Tryg3D_Function:: CountActors(){
		new T3D:count = 0;
		for(new i = 0, j = GetActorPoolSize(); i <= j; i++){
			if(IsValidActor(i)){
				T3D:count++;
			}
		}
		return T3D:count;
	}
#endif

/************************************************************************************************************************************
 *                                                                                                                                  *
 * Stream3D Functions                                                                                                               *
 *                                                                                                                                  *
 ************************************************************************************************************************************/

#if defined Tryg3D_Stream3D
	
	#define StreamCreate(%0)							Stream:%0[Stream3D]
	#define GetStreamType(%0) 							(%0[T3D:type])
	
	Tryg3D_Function:: bool:IsValidStream(Stream:StreamData[Stream3D]){
		return (StreamData[T3D:type] != s_invalid);
	}

	Tryg3D_Function:: Stream:StreamCircle(Float:x,Float:y,Float:radius){
		new StreamCreate(StreamData);
		StreamData[T3D:type] = s_circle;
		StreamData[T3D:X] = x;
		StreamData[T3D:Y] = y;
		StreamData[T3D:R] = radius;
		return StreamData;
	}

	Tryg3D_Function:: Stream:StreamCylinder3D(Float:xA,Float:yA,Float:zA,Float:xB,Float:yB,Float:zB,Float:radius){
		new StreamCreate(StreamData);
		StreamData[T3D:type] = s_cylinder3d;
		StreamData[T3D:minX] = xA;
		StreamData[T3D:minY] = yA;
		StreamData[T3D:minZ] = zA;
		StreamData[T3D:maxX] = xB;
		StreamData[T3D:maxY] = yB;
		StreamData[T3D:maxZ] = zB;
		StreamData[T3D:R] = radius;
		return StreamData;
	}
	
	Tryg3D_Function:: Stream:StreamCone3D(Float:xA,Float:yA,Float:zA,Float:xB,Float:yB,Float:zB,Float:pointA_radius,Float:pointB_radius){
		new StreamCreate(StreamData);
		StreamData[T3D:type] = s_cone;
		StreamData[T3D:minX] = xA;
		StreamData[T3D:minY] = yA;
		StreamData[T3D:minZ] = zA;
		StreamData[T3D:maxX] = xB;
		StreamData[T3D:maxY] = yB;
		StreamData[T3D:maxZ] = zB;
		StreamData[T3D:X] = pointA_radius;
		StreamData[T3D:Y] = pointB_radius;
		return StreamData;
	}

	Tryg3D_Function:: Stream:StreamCylinder2D(Float:x,Float:y,Float:minz,Float:maxz,Float:radius){
		new StreamCreate(StreamData);
		StreamData[T3D:type] = s_cylinder2d;
		StreamData[T3D:X] = x;
		StreamData[T3D:Y] = y;
		StreamData[T3D:minZ] = minz;
		StreamData[T3D:maxZ] = maxz;
		StreamData[T3D:R] = radius;
		return StreamData;
	}

	Tryg3D_Function:: Stream:StreamSphere(Float:x,Float:y,Float:z,Float:radius){
		new StreamCreate(StreamData);
		StreamData[T3D:type] = s_sphere;
		StreamData[T3D:X] = x;
		StreamData[T3D:Y] = y;
		StreamData[T3D:Z] = z;
		StreamData[T3D:R] = radius;
		return StreamData;
	}

	Tryg3D_Function:: Stream:StreamRectangle(Float:minx,Float:miny,Float:maxx,Float:maxy){
		new StreamCreate(StreamData);
		StreamData[T3D:type] = s_rectangle;
		StreamData[T3D:minX] = minx;
		StreamData[T3D:minY] = miny;
		StreamData[T3D:maxX] = maxx;
		StreamData[T3D:maxY] = maxy;
		return StreamData;
	}

	Tryg3D_Function:: Stream:StreamCube(Float:minx,Float:miny,Float:minz,Float:maxx,Float:maxy,Float:maxz){
		new StreamCreate(StreamData);
		StreamData[T3D:type] = s_cube;
		StreamData[T3D:minX] = minx;
		StreamData[T3D:minY] = miny;
		StreamData[T3D:minZ] = minz;
		StreamData[T3D:maxX] = maxx;
		StreamData[T3D:maxY] = maxy;
		StreamData[T3D:maxZ] = maxz;
		return StreamData;
	}

	Tryg3D_Function:: Stream:StreamCircularSector(Float:x,Float:y,Float:rz,Float:radius,Float:view_angle){
		new StreamCreate(StreamData);
		StreamData[T3D:type] = s_circularsector;
		StreamData[T3D:X] = x;
		StreamData[T3D:Y] = y;
		StreamData[T3D:minZ] = rz;
		StreamData[T3D:R] = radius;
		StreamData[T3D:maxZ] = view_angle;
		return StreamData;
	}

	Tryg3D_Function:: Stream:StreamSphericalSector(Float:x,Float:y,Float:z,Float:rx,Float:rz,Float:radius,Float:vrx,Float:vrz){
		new StreamCreate(StreamData);
		StreamData[T3D:type] = s_sphericalsector;
		StreamData[T3D:X] = x;
		StreamData[T3D:Y] = y;
		StreamData[T3D:Z] = z;
		StreamData[T3D:minX] = rx;
		StreamData[T3D:minZ] = rz;
		StreamData[T3D:R] = radius;
		StreamData[T3D:maxX] = vrx;
		StreamData[T3D:maxZ] = vrz;
		return StreamData;
	}

	Tryg3D_Function:: bool:IsPointInStream(Float:x,Float:y,Float:z,Stream:StreamData[Stream3D]){
		switch(StreamData[T3D:type]){
			case s_circle:			return IsPointInCircle(x,y,StreamData[T3D:X],StreamData[T3D:Y],StreamData[T3D:R]);
			case s_cylinder3d:		return IsPointInCylinder3D(x,y,z,StreamData[T3D:minX],StreamData[T3D:minY],StreamData[T3D:minZ],StreamData[T3D:maxX],StreamData[T3D:maxY],StreamData[T3D:maxZ],StreamData[T3D:R]);
			case s_cylinder2d:		return IsPointInCylinder2D(x,y,z,StreamData[T3D:X],StreamData[T3D:Y],StreamData[T3D:minZ],StreamData[T3D:maxZ],StreamData[T3D:R]);
			case s_sphere:			return IsPointInSphere(x,y,z,StreamData[T3D:X],StreamData[T3D:Y],StreamData[T3D:Z],StreamData[T3D:R]);
			case s_rectangle:		return IsPointInRectangle(x,y,StreamData[T3D:minX],StreamData[T3D:minY],StreamData[T3D:maxX],StreamData[T3D:maxY]);
			case s_cube:			return IsPointInCube(x,y,z,StreamData[T3D:minX],StreamData[T3D:minY],StreamData[T3D:minZ],StreamData[T3D:maxX],StreamData[T3D:maxY],StreamData[T3D:maxZ]);
			case s_circularsector:	return IsPointInCircularSector(x,y,StreamData[T3D:X],StreamData[T3D:Y],StreamData[T3D:minZ],StreamData[T3D:R],StreamData[T3D:maxZ]);
			case s_sphericalsector:	return IsPointInSphericalSector(x,y,z,StreamData[T3D:X],StreamData[T3D:Y],StreamData[T3D:Z],StreamData[T3D:minX],StreamData[T3D:minZ],StreamData[T3D:R],StreamData[T3D:maxX],StreamData[T3D:maxZ]);
			case s_cone:			return IsPointInCone3D(x,y,z,StreamData[T3D:minX],StreamData[T3D:minY],StreamData[T3D:minZ],StreamData[T3D:maxX],StreamData[T3D:maxY],StreamData[T3D:maxZ],StreamData[T3D:X],StreamData[T3D:Y]);
		}
		return false;
	}
	
	Tryg3D_Function:: bool:GetRandomPointInStream(Stream:StreamData[Stream3D],&Float:x,&Float:y,&Float:z){
		switch(StreamData[T3D:type]){
			case s_circle: {
				GetRandomPointInCircle(StreamData[T3D:X],StreamData[T3D:Y],StreamData[T3D:R],x,y);
				z = FLOAT_INFINITY;
				return true;
			}
			case s_cylinder3d: {
				x = y = z = FLOAT_INFINITY;
				return false;
			}
			case s_cylinder2d: {
				GetRandomPointInCylinder2D(StreamData[T3D:X],StreamData[T3D:Y],StreamData[T3D:minZ],StreamData[T3D:maxZ],StreamData[T3D:R],x,y,z);
				return true;
			}
			case s_sphere: {
				GetRandomPointInSphere(StreamData[T3D:X],StreamData[T3D:Y],StreamData[T3D:Z],StreamData[T3D:R],x,y,z);
				return true;
			}
			case s_rectangle: {
				GetRandomPointInRectangle(StreamData[T3D:minX],StreamData[T3D:minY],StreamData[T3D:maxX],StreamData[T3D:maxY],x,y);
				z = FLOAT_INFINITY;
				return true;
			}
			case s_cube: {
				GetRandomPointInCube(StreamData[T3D:minX],StreamData[T3D:minY],StreamData[T3D:minZ],StreamData[T3D:maxX],StreamData[T3D:maxY],StreamData[T3D:maxZ],x,y,z);
				return true;
			}
			case s_circularsector: {
				GetRandomPointInCircularSector(StreamData[T3D:X],StreamData[T3D:Y],StreamData[T3D:minZ],StreamData[T3D:R],StreamData[T3D:maxZ],x,y);
				z = FLOAT_INFINITY;
				return true;
			}
			case s_sphericalsector: {
				x = y = z = FLOAT_INFINITY;
				return false;
			}
			case s_cone: {
				x = y = z = FLOAT_INFINITY;
				return false;
			}
		}
		return false;
	}

	Tryg3D_Function:: bool:IsElementInStream({Text3D,_}:elementid,Item3D_Type:element_type,Stream:StreamData[Stream3D]){
		new Float:px,Float:py,Float:pz;
		GetElementPos(elementid,element_type,px,py,pz);
		return IsPointInStream(px,py,pz,StreamData);
	}

#endif

/************************************************************************************************************************************
 *                                                                                                                                  *
 * Line3D Functions                                                                                                                 *
 *                                                                                                                                  *
 ************************************************************************************************************************************/
 
#if defined Tryg3D_Line3D
	
	#define INVALID_LINE3D_POINT_ID						(-1)

	#define Line3DCreate(%0,%1)							Line3D:%0[(%1)][LinePoint3D]
	#define GetLine3DValue(%0,%1,%2)					%0[%1][T3D:%2]
	#define SetLine3DValue(%0,%1,%2,%3)					%0[%1][T3D:%2] = (%3)

	Tryg3D_Function:: bool:GetLine3DPointPos(Line3D:LineData[][LinePoint3D],pointid,&Float:x,&Float:y,&Float:z,max_points = sizeof(LineData)){
		if(pointid >= max_points || pointid < 0) return false;
		x = GetLine3DValue(LineData,pointid,X);
		y = GetLine3DValue(LineData,pointid,Y);
		z = GetLine3DValue(LineData,pointid,Z);
		return true;
	}

	Tryg3D_Function:: bool:SetLine3DPointPos(Line3D:LineData[][LinePoint3D],pointid,Float:x,Float:y,Float:z,max_points = sizeof(LineData)){
		if(pointid >= max_points || pointid < 0) return false;
		SetLine3DValue(LineData,pointid,X,x);
		SetLine3DValue(LineData,pointid,Y,y);
		SetLine3DValue(LineData,pointid,Z,z);
		return true;
	}

	Tryg3D_Function:: bool:GetLine3DPointRot(Line3D:LineData[][LinePoint3D],pointid,&Float:rx,&Float:ry,&Float:rz,max_points = sizeof(LineData)){
		if(pointid >= max_points || pointid < 0) return false;
		rx = GetLine3DValue(LineData,pointid,rX);
		ry = GetLine3DValue(LineData,pointid,rY);
		rz = GetLine3DValue(LineData,pointid,rZ);
		return true;
	}

	Tryg3D_Function:: bool:SetLine3DPointRot(Line3D:LineData[][LinePoint3D],pointid,Float:rx,Float:ry,Float:rz,max_points = sizeof(LineData)){
		if(pointid >= max_points || pointid < 0) return false;
		SetLine3DValue(LineData,pointid,rX,rx);
		SetLine3DValue(LineData,pointid,rY,ry);
		SetLine3DValue(LineData,pointid,rZ,rz);
		return true;
	}

	Tryg3D_Function:: CountLine3DPoints(Line3D:LineData[][LinePoint3D],max_points = sizeof(LineData)){
		new T3D:count = 0;
		for(new i = 0; i < max_points; i++){
			if(GetLine3DValue(LineData,i,PointUsed)) T3D:count++;
		}
		return T3D:count;
	}

	Tryg3D_Function:: AddPointToLine3D(Line3D:LineData[][LinePoint3D],Float:x,Float:y,Float:z,Float:rx=INVALID_ROTATION,Float:ry=INVALID_ROTATION,Float:rz=INVALID_ROTATION,max_points = sizeof(LineData)){
		new pointid = CountLine3DPoints(LineData,max_points);
		if(pointid >= max_points) return INVALID_LINE3D_POINT_ID;
		SetLine3DValue(LineData,pointid,PointUsed,true);
		SetLine3DValue(LineData,pointid,X,x);
		SetLine3DValue(LineData,pointid,Y,y);
		SetLine3DValue(LineData,pointid,Z,z);
		SetLine3DValue(LineData,pointid,rX,rx);
		SetLine3DValue(LineData,pointid,rY,ry);
		SetLine3DValue(LineData,pointid,rZ,rz);
		return pointid;
	}

	Tryg3D_Function:: bool:RemovePointFromLine3D(Line3D:LineData[][LinePoint3D],pointid,max_points = sizeof(LineData)){
		if(pointid >= max_points) return false;
		if(!GetLine3DValue(LineData,pointid,PointUsed)) return false;
		new end_pointid = CountLine3DPoints(LineData,max_points)-1;
		if(pointid == end_pointid){
			SetLine3DValue(LineData,pointid,PointUsed,false);
			SetLine3DPointPos(LineData,pointid,0.0,0.0,0.0,max_points);
			SetLine3DPointRot(LineData,pointid,0.0,0.0,0.0,max_points);
		} else {
			new Float:x,Float:y,Float:z;
			for(new i = pointid; i < end_pointid; i++){
				GetLine3DPointPos(LineData,i+1,x,y,z,max_points);
				SetLine3DPointPos(LineData,i,x,y,z,max_points);
				GetLine3DPointRot(LineData,i+1,x,y,z,max_points);
				SetLine3DPointRot(LineData,i,x,y,z,max_points);
			}
			SetLine3DValue(LineData,end_pointid,PointUsed,false);
			SetLine3DPointPos(LineData,end_pointid,0.0,0.0,0.0,max_points);
			SetLine3DPointRot(LineData,end_pointid,0.0,0.0,0.0,max_points);
		}
		return true;
	}
#endif

/************************************************************************************************************************************
 *                                                                                                                                  *
 * Streamer Functions                                                                                                               *
 *                                                                                                                                  *
 ************************************************************************************************************************************/

#if defined Tryg3D_Streamer

	new bool:T3D:Tryg3DStreamerExam = false;

	#define TRYG3D_GET_STREAMER_VERSION						(0xFFFFFFFF)
	
	#define Tryg3D_GetStreamerVersion()						(Streamer_IncludeFileVersion)
	#define Tryg3D_GetValidStreamerVersion()				(Tryg3D_StreamerVersion)
	#define IsDynamicObjectInRangeOfPoint(%0,%1,%2,%3,%4) 	(GetElementDistanceFromPoint((%0),item_dynamic_object,(%2),(%3),(%4)) <= (%1))
	
	Tryg3D_Function:: bool:Tryg3D_IsValidStreamer(value){
		return (Tryg3D_GetStreamerVersion() >= value);
	}

	Tryg3D_Function:: Tryg3D_GetStreamerVersionName(name[],value = TRYG3D_GET_STREAMER_VERSION,maxdest = sizeof(name)){
		if(value == TRYG3D_GET_STREAMER_VERSION) value = Tryg3D_GetStreamerVersion();
		new T3D:version[10];
		format(T3D:version,sizeof(T3D:version),"%06x",value);
		format(name,maxdest,"%d.%d.%dr%d",(T3D:version[0]-48),(T3D:version[1]-48),(T3D:version[2]-48),(((T3D:version[3]-48)*100) + ((T3D:version[4]-48)*10) + (T3D:version[5]-48)));
	}

	Tryg3D_Function:: Tryg3D_CheckStreamerVersion(){
		if(!Tryg3D_IsValidStreamer(Tryg3D_GetValidStreamerVersion())){
			T3D:Tryg3DStreamerExam = false;
			new T3D:str1[32], T3D:str2[32];
			Tryg3D_GetStreamerVersionName(T3D:str1,Tryg3D_GetStreamerVersion());
			Tryg3D_GetStreamerVersionName(T3D:str2,Tryg3D_GetValidStreamerVersion());
			if(GetSVarInt("ADM:Logging:Disable") == 0){
				printf("[ADM] Error: Your Streamer %s It is not compatible with this version 3DTryg, update your streamer to %s",T3D:str1,T3D:str2);
			}
			Update3DTrygErrorCount();
		} else {
			T3D:Tryg3DStreamerExam = true;
		}
	}
	
	Tryg3D_Function:: GetDynamicObjectRotationQuat(objectid,&Float:qw,&Float:qx,&Float:qy,&Float:qz){
		new Float:rx,Float:ry,Float:rz;
		GetDynamicObjectRot(objectid,rx,ry,rz);
		GetQuatFromRot(rx,ry,rz,qw,qx,qy,qz);
	}

	Tryg3D_Function:: GetDynamicObjectUpVector(objectid,&Float:vx,&Float:vy,&Float:vz){
		new Float:qw,Float:qx,Float:qy,Float:qz;
		GetDynamicObjectRotationQuat(objectid,qw,qx,qy,qz);
		GetQuatUpVector(qw,qx,qy,qz,vx,vy,vz);
	}

	Tryg3D_Function:: GetDynamicObjectUpPos(objectid,Float:radius,&Float:x,&Float:y,&Float:z){
		new Float:rx,Float:rz;
		GetDynamicObjectUpVector(objectid,x,y,z);
		ShiftVectorToRotation(x,y,z,rx,rz);
		GetDynamicObjectPos(objectid,x,y,z);
		GetPointInFront3D(x,y,z,rx,rz,radius,x,y,z);
	}

	Tryg3D_Function:: GetDynamicObjectDownPos(objectid,Float:radius,&Float:x,&Float:y,&Float:z){
		new Float:rx,Float:rz;
		GetDynamicObjectUpVector(objectid,x,y,z);
		ShiftVectorToRotation(x,y,z,rx,rz);
		GetDynamicObjectPos(objectid,x,y,z);
		GetPointInFront3D(x,y,z,CompRotationFloat(rx-180.0),rz,radius,x,y,z);
	}

	Tryg3D_Function:: GetDynamicObjectOrientationPos(objectid,element_orientation:orientation,Float:distance,&Float:tx,&Float:ty,&Float:tz){
		new Float:x, Float:y, Float:z,
			Float:rx, Float:ry, Float:rz;
		GetDynamicObjectPos(objectid,x,y,z);
		GetDynamicObjectRot(objectid,rx,ry,rz); 
		switch(orientation){
			case o_left:	GetPointInFront3D(x,y,z,ry,CompRotationFloat(rz+90.0),distance,tx,ty,tz);
			case o_right:	GetPointInFront3D(x,y,z,CompRotationFloat(ry+180.0),CompRotationFloat(rz+90.0),distance,tx,ty,tz);
			case o_up:		GetDynamicObjectUpPos(objectid,distance,tx,ty,tz);
			case o_down:	GetDynamicObjectDownPos(objectid,distance,tx,ty,tz);
			case o_front:	GetPointInFront3D(x,y,z,rx,rz,distance,tx,ty,tz);
			case o_back:	GetPointInFront3D(x,y,z,CompRotationFloat(rx+180.0),rz,distance,tx,ty,tz);
		}
	}
	
	Tryg3D_Function:: bool:GetDynamicObjectToPointVector(objectid,Float:tx,Float:ty,Float:tz,&Float:vx,&Float:vy,&Float:vz){
		new Float:px,Float:py,Float:pz,Float:rx,Float:rz;
		GetDynamicObjectPos(objectid,px,py,pz);
		if(GetRotationFor2Point3D(px,py,pz,tx,ty,tz,rx,rz)){
			ShiftRotationToVector(rx,rz,vx,vy,vz);
			return true;
		} else {
			vx = vy = vz = 0.0;
			return false;
		}
	}
	
	Tryg3D_Function:: GetDynamicObjectRotatedVector(objectid,Float:tx,Float:ty,Float:tz,&Float:vx,&Float:vy,&Float:vz,bool:return_vector=true,Float:rx=0.0,Float:ry=0.0,Float:rz=0.0){
		new Float:px,Float:py,Float:pz;
		GetDynamicObjectPos(objectid,px,py,pz);
		if(return_vector){
			ShiftLineRotationVector(px,py,pz,tx,ty,tz,rx,ry,rz,vx,vy,vz);
		} else {
			ShiftLineRotation(px,py,pz,tx,ty,tz,rx,ry,rz,vx,vy,vz);
		}
	}

	Tryg3D_Function:: SetPlayerAbsolutePosition(playerid,Float:x,Float:y,Float:z,Float:angle,worldid = -1,interiorid = -1,compensatedtime = -1){
		Streamer_UpdateEx(playerid,x,y,z,worldid,interiorid,-1,compensatedtime);
		if(worldid != -1) SetPlayerVirtualWorld(playerid,worldid);
		if(interiorid != -1) SetPlayerInterior(playerid,interiorid);
		SetPlayerPos(playerid,x,y,z);
		SetPlayerFacingAngle(playerid,angle);
		SetCameraBehindPlayer(playerid);
	}
	
	Tryg3D_Function:: SetPlayerAbsolutePositionVeh(playerid,Float:x,Float:y,Float:z,Float:angle,worldid = -1,interiorid = -1,compensatedtime = -1){
		new T3D:vehicleid = GetPlayerVehicleID(playerid), seatid;
		if(T3D:vehicleid == 0){
			SetPlayerAbsolutePosition(playerid,x,y,z,angle,worldid,interiorid,compensatedtime);
		} else {
			SetPlayerAbsolutePosition(playerid,x,y,z,angle,worldid,interiorid,compensatedtime);
			if(worldid != -1) SetVehicleVirtualWorld(T3D:vehicleid,worldid);
			if(interiorid != -1) LinkVehicleToInterior(T3D:vehicleid,interiorid);
			SetVehiclePos(T3D:vehicleid,x,y,z);
			SetVehicleZAngle(T3D:vehicleid,angle);
			PutPlayerInVehicle(playerid,T3D:vehicleid,0);
			if(worldid != -1 || interiorid != -1){
				Tryg3DForeach(i){
					if(GetPlayerVehicleID(i) == T3D:vehicleid && (seatid = GetPlayerVehicleSeat(i)) != 0){
						if(worldid != -1) SetPlayerVirtualWorld(i,worldid);
						if(interiorid != -1) SetPlayerInterior(i,interiorid);
						PutPlayerInVehicle(i,T3D:vehicleid,seatid);
					}
				}
			}
		}
	}
	
	#if defined STREAMER_TYPE_ACTOR
		
		#define IsDynamicActorInRangeOfPoint(%0,%1,%2,%3,%4)	(GetElementDistanceFromPoint((%0),item_dynamic_actor,(%2),(%3),(%4)) <= (%1))
		
		Tryg3D_Function:: GetDynamicActorOrientationPos(actorid,element_orientation:orientation,Float:distance,&Float:tx,&Float:ty,&Float:tz){
			new Float:x, Float:y, Float:z, Float:rz;
			GetDynamicActorPos(actorid,x,y,z);
			GetDynamicActorFacingAngle(actorid,rz);
			switch(orientation){
				case o_left:	GetPointInFront3D(x,y,z,0.0,CompRotationFloat(rz+90.0),distance,tx,ty,tz);
				case o_right:	GetPointInFront3D(x,y,z,0.0,CompRotationFloat(rz-90.0),distance,tx,ty,tz);
				case o_up:		tx = x, ty = y, tz = z + distance;
				case o_down:	tx = x, ty = y, tz = z - distance;
				case o_front:	GetPointInFront3D(x,y,z,0.0,rz,distance,tx,ty,tz);
				case o_back:	GetPointInFront3D(x,y,z,0.0,CompRotationFloat(rz+180.0),distance,tx,ty,tz);
			}
		}
	#endif
	
	#if defined Tryg3D_FCNPC
		Tryg3D_Function:: SetNPCAbsolutePosition(npcid,Float:x,Float:y,Float:z,Float:angle,worldid = -1,interiorid = -1,compensatedtime = -1){
			Streamer_UpdateEx(npcid,x,y,z,worldid,interiorid,-1,compensatedtime);
			if(worldid != -1) FCNPC_SetVirtualWorld(npcid,worldid);
			if(interiorid != -1) FCNPC_SetInterior(npcid,interiorid);
			FCNPC_SetPosition(npcid,x,y,z);
			FCNPC_SetAngle(npcid,angle);
		}
	#endif
	
	#if defined Tryg3D_Stream3D
		
		Tryg3D_Function:: Stream:ConvertAreaToStream(areaid){
			new StreamCreate(StreamData);
			if(!IsValidDynamicArea(areaid)) return StreamData;
			switch(Streamer_GetIntData(STREAMER_TYPE_AREA,areaid,E_STREAMER_TYPE)){
				case STREAMER_AREA_TYPE_CIRCLE: {
					StreamData[T3D:type] = s_circle;
					Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_X,StreamData[T3D:X]);
					Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_Y,StreamData[T3D:Y]);
					Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_SIZE,StreamData[T3D:R]);
				}
				case STREAMER_AREA_TYPE_CYLINDER: {
					StreamData[T3D:type] = s_cylinder2d;
					Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_X,StreamData[T3D:X]);
					Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_Y,StreamData[T3D:Y]);
					Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_MIN_Z,StreamData[T3D:minZ]);
					Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_MAX_Z,StreamData[T3D:maxZ]);
					Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_SIZE,StreamData[T3D:R]);
				}
				case STREAMER_AREA_TYPE_SPHERE: {
					StreamData[T3D:type] = s_sphere;
					Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_X,StreamData[T3D:X]);
					Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_Y,StreamData[T3D:Y]);
					Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_Z,StreamData[T3D:Z]);
					Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_SIZE,StreamData[T3D:R]);
				}
				case STREAMER_AREA_TYPE_RECTANGLE: {
					StreamData[T3D:type] = s_rectangle;
					Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_MIN_X,StreamData[T3D:minX]);
					Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_MIN_Y,StreamData[T3D:minY]);
					Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_MAX_X,StreamData[T3D:maxX]);
					Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_MAX_Y,StreamData[T3D:maxY]);
				}
				case STREAMER_AREA_TYPE_CUBOID: {
					StreamData[T3D:type] = s_cube;
					Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_MIN_X,StreamData[T3D:minX]);
					Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_MIN_Y,StreamData[T3D:minY]);
					Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_MIN_Z,StreamData[T3D:minZ]);
					Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_MAX_X,StreamData[T3D:maxX]);
					Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_MAX_Y,StreamData[T3D:maxY]);
					Streamer_GetFloatData(STREAMER_TYPE_AREA,areaid,E_STREAMER_MAX_Z,StreamData[T3D:maxZ]);
				}
			}
			return StreamData;
		}
	
	#endif
	
#endif

/************************************************************************************************************************************
 *                                                                                                                                  *
 * ColAndreas Functions                                                                                                             *
 *                                                                                                                                  *
 ************************************************************************************************************************************/

#if defined Tryg3D_ColAndreas

	#define GET_COLANDREAS_VERSION						(0xFFFFFFFF)
	
	#define GetColAndreasVersion()						(COLANDREAS_VERSION)
	#define GetValidColAndreasVersion()					(Tryg3D_ColAndreasVersion)
	#define IsCollisionFlag(%0,%1)						((%0) & (%1))
	#define IsPointInUnderwater(%1,%2,%3)				(IsPointInWater((%1),(%2),(%3)) && ((%3) < -1.0))
	
	Tryg3D_Function:: bool:IsValidColAndreas(value){
		return (GetColAndreasVersion() >= value);
	}
	
	Tryg3D_Function:: GetColAndreasVersionName(name[],value = GET_COLANDREAS_VERSION,maxdest = sizeof(name)){
		if(value == GET_COLANDREAS_VERSION) value = GetColAndreasVersion();
		format(name,maxdest,"%d.%d.%d",(value / 10000),((value % 10000) / 100),((value % 10000) % 100));
	}

	Tryg3D_Function:: CheckColAndreasVersion(){
		if(!IsValidColAndreas(GetValidColAndreasVersion())){
			new T3D:str1[32], T3D:str2[32];
			GetColAndreasVersionName(T3D:str1,GetColAndreasVersion());
			GetColAndreasVersionName(T3D:str2,GetValidColAndreasVersion());
			if(GetSVarInt("ADM:Logging:Disable") == 0){
				printf("[ADM] Error: Your ColAndreas %s It is not compatible with this version 3DTryg, update your ColAndreas to %s",T3D:str1,T3D:str2);
			}
			Update3DTrygErrorCount();
		}
	}
	
	Tryg3D_Function:: MovePointCol(Float:StartX,Float:StartY,Float:StartZ,Float:EndX,Float:EndY,Float:EndZ,&Float:x,&Float:y,&Float:z){
		CA_RayCastLine(StartX,StartY,StartZ,EndX,EndY,EndZ,x,y,z);
		if(x == 0.0) x = EndX;
		if(y == 0.0) y = EndY;
		if(z == 0.0) z = EndZ;
	}
	
	Tryg3D_Function:: bool:MovePointColCutLine(Float:sX,Float:sY,Float:sZ,Float:eX,Float:eY,Float:eZ,&Float:x,&Float:y,&Float:z,Float:cut_size=0.0){
		new Float:radius, Float:rx, Float:rz;
		CA_RayCastLine(sX,sY,sZ,eX,eY,eZ,x,y,z);
		if(x == 0.0) x = eX;
		if(y == 0.0) y = eY;
		if(z == 0.0) z = eZ;
		if((radius = GetDistanceBetweenPoints3D(sX,sY,sZ,x,y,z)) <= 0.0) return false;
		CompRotationFloat(-(acos((z-sZ)/radius)-90.0),rx);
		CompRotationFloat((atan2(y-sY,x-sX)-90.0),rz);
		if(radius-cut_size > 0.0) radius -= cut_size;
		GetPointInFront3D(sX,sY,sZ,rx,rz,radius,x,y,z);
		return true;
	}

	Tryg3D_Function:: bool:MovePointColCutLineEx(Float:sX,Float:sY,Float:sZ,Float:eX,Float:eY,Float:eZ,&Float:x,&Float:y,&Float:z,Float:cut_size=0.0){
		new Float:radius, Float:rx, Float:rz;
		CA_RayCastLine(sX,sY,sZ,eX,eY,eZ,x,y,z);
		if(x == 0.0) x = eX;
		if(y == 0.0) y = eY;
		if(z == 0.0) z = eZ;
		if((radius = GetDistanceBetweenPoints3D(sX,sY,sZ,x,y,z)) <= 0.0) return false;
		CompRotationFloat(-(acos((z-sZ)/radius)-90.0),rx);
		CompRotationFloat((atan2(y-sY,x-sX)-90.0),rz);
		if((radius-cut_size > cut_size) && (radius-cut_size > 0.0)){
			radius -= cut_size;
		} else {
			radius = FLOAT_DEFECT;
		}
		GetPointInFront3D(sX,sY,sZ,rx,rz,radius,x,y,z);
		return true;
	}
	
	//GetPointInFront3D (ColAndreas)
	Tryg3D_Function:: GetPointInFront3DCol(Float:x,Float:y,Float:z,Float:rx,Float:rz,Float:radius,&Float:tx,&Float:ty,&Float:tz){
		tx = x - (radius * floatcos(rx,degrees) * floatsin(rz,degrees));
		ty = y + (radius * floatcos(rx,degrees) * floatcos(rz,degrees));
		tz = z + (radius * floatsin(rx,degrees));
		MovePointCol(x,y,z,tx,ty,tz,tx,ty,tz);
	}
	
	//GetPointInFrontOfPlayer (ColAndreas)
	Tryg3D_Function:: Float:GetPointInFrontOfPlayerCol(playerid,&Float:tx,&Float:ty,Float:radius){
		new Float:rz,Float:z;
		GetPlayerPos(playerid,tx,ty,z);
		if(IsPlayerInAnyVehicle(playerid)){
			GetVehicleZAngle(GetPlayerVehicleID(playerid),rz);
		} else {
			GetPlayerFacingAngle(playerid,rz);
		}
		GetPointInFront3DCol(tx,ty,z,0.0,rz,radius,tx,ty,z);
		return rz;
	}

	//GetPointInFrontOfCamera2D (ColAndreas)
	Tryg3D_Function:: Float:GetPointInFrontOfCamera2DCol(playerid,&Float:tx,&Float:ty,Float:radius){
		new Float:x,Float:y,Float:z,Float:rz;
		GetPlayerCameraPos(playerid,x,y,z);
		GetPlayerCameraZAngle(playerid,rz);
		GetPointInFront3DCol(x,y,z,0.0,rz,radius,tx,ty,z);
		return rz;
	}

	//GetPointInFrontOfCamera3D (ColAndreas)
	Tryg3D_Function:: GetPointInFrontOfCamera3DCol(playerid,&Float:tx,&Float:ty,&Float:tz,Float:radius,&Float:rx=0.0,&Float:rz=0.0){
		new Float:x,Float:y,Float:z;
		GetPlayerCameraPos(playerid,x,y,z);
		GetPlayerCameraRotation(playerid,rx,rz);
		GetPointInFront3DCol(x,y,z,rx,rz,radius,tx,ty,tz);
	}
	
	//GetPointInFrontOfVehicle2D (ColAndreas)
	Tryg3D_Function:: Float:GetPointInFrontOfVehicle2DCol(vehicleid,&Float:tx,&Float:ty,Float:radius){
		new Float:rx,Float:ry,Float:rz,Float:x,Float:y,Float:z;
		GetVehiclePos(vehicleid,x,y,z);
		GetVehicleRotation(vehicleid,rx,ry,rz);
		GetPointInFront3DCol(x,y,z,0.0,rz,radius,tx,ty,z);
		return rz;
	}

	//GetPointInFrontOfVehicle3D (ColAndreas)
	Tryg3D_Function:: GetPointInFrontOfVehicle3DCol(vehicleid,&Float:tx,&Float:ty,&Float:tz,Float:radius,&Float:rx=0.0,&Float:rz=0.0){
		new Float:ry,Float:x,Float:y,Float:z;
		GetVehiclePos(vehicleid,x,y,z);
		GetVehicleRotation(vehicleid,rx,ry,rz);
		GetPointInFront3DCol(x,y,z,rx,rz,radius,tx,ty,tz);
	}

	Tryg3D_Function:: Float:UndergroundFindZ(Float:x,Float:y,&Float:z=0.0){
		z = 0.0;
		CA_RayCastLine(x,y,-0.002,x,y,-100.0,x,y,z);
		return z;
	}

	Tryg3D_Function:: Float:InteriorFindZ(Float:px,Float:py,Float:pz=1000.0,Float:size=2.0,&Float:z=0.0){
		z = 0.0;
		CA_RayCastLine(px,py,pz+size,px,py,pz-100.0,px,py,z);
		return z;
	}

	Tryg3D_Function:: bool:IsPointInWater(Float:x,Float:y,Float:z=0.0){
		if(z > 0.0) return false;
		new Float:tmpzA, Float:tmpzB;
		Tryg3D_MapAndreasFindZ(x,y,tmpzA);
		UndergroundFindZ(x,y,tmpzB);
		return ((z >= tmpzB) && (tmpzB < 0.0) && (tmpzA > -0.001 && tmpzA < 0.001));
	}

	Tryg3D_Function:: bool:IsPointInUnderground(Float:x,Float:y,Float:z){
		new Float:tmpzA;
		Tryg3D_MapAndreasFindZ(x,y,tmpzA);
		return (z < tmpzA && !IsPointInWater(x,y,z));
	}

	Tryg3D_Function:: bool:IsPointInAir(Float:x,Float:y,Float:z,bool:interior=false,Float:max_distance=2.2){
		new Float:tmpzA;
		if(interior){
			InteriorFindZ(x,y,z,2.0,tmpzA);
		} else {
			Tryg3D_MapAndreasFindZ(x,y,tmpzA);
		}
		return (z >= tmpzA+max_distance);
	}

	Tryg3D_Function:: bool:IsPointInGround(Float:x,Float:y,Float:z,bool:interior=false,Float:max_distance=2.2){
		if(z <= 0.0) return false;
		new Float:tmpzA;
		if(interior){
			InteriorFindZ(x,y,z,2.0,tmpzA);
		} else {
			Tryg3D_MapAndreasFindZ(x,y,tmpzA);
		}
		return (z <= tmpzA+max_distance);
	}
	
	Tryg3D_Function:: GetPlayerOrientationPosCol(playerid,element_orientation:orientation,Float:distance,&Float:tx,&Float:ty,&Float:tz,isactor=false){
		new Float:x, Float:y, Float:z, Float:rz;
		#if defined Tryg3D_Actor
			if(!isactor){
				GetPlayerPos(playerid,x,y,z);
				GetPlayerFacingAngle(playerid,rz);
			} else {
				GetActorPos(playerid,x,y,z);
				GetActorFacingAngle(playerid,rz);
			}
		#else
			#pragma unused isactor
			GetPlayerPos(playerid,x,y,z);
			GetPlayerFacingAngle(playerid,rz);
		#endif
		switch(orientation){
			case o_left:	GetPointInFront3DCol(x,y,z,0.0,CompRotationFloat(rz+90.0),distance,tx,ty,tz);
			case o_right:	GetPointInFront3DCol(x,y,z,0.0,CompRotationFloat(rz-90.0),distance,tx,ty,tz);
			case o_up:		GetPointInFront3DCol(x,y,z,90.0,0.0,distance,tx,ty,tz);
			case o_down:	GetPointInFront3DCol(x,y,z,270.0,0.0,distance,tx,ty,tz);
			case o_front:	GetPointInFront3DCol(x,y,z,0.0,rz,distance,tx,ty,tz);
			case o_back:	GetPointInFront3DCol(x,y,z,0.0,CompRotationFloat(rz+180.0),distance,tx,ty,tz);
		}
	}

	Tryg3D_Function:: GetVehicleOrientationPosCol(vehicleid,element_orientation:orientation,Float:distance,&Float:tx,&Float:ty,&Float:tz){
		new Float:x, Float:y, Float:z,
			Float:rx, Float:ry, Float:rz;
		GetVehiclePos(vehicleid,x,y,z);
		GetVehicleRotation(vehicleid,rx,ry,rz); 
		switch(orientation){
			case o_left:	GetPointInFront3DCol(x,y,z,ry,CompRotationFloat(rz+90.0),distance,tx,ty,tz);
			case o_right:	GetPointInFront3DCol(x,y,z,CompRotationFloat(ry+180.0),CompRotationFloat(rz+90.0),distance,tx,ty,tz);
			case o_up: {
				GetVehicleUpPos(vehicleid,distance,tx,ty,tz);
				MovePointCol(x,y,z,tx,ty,tz,tx,ty,tz);
			}
			case o_down: {
				GetVehicleDownPos(vehicleid,distance,tx,ty,tz);
				MovePointCol(x,y,z,tx,ty,tz,tx,ty,tz);
			}
			case o_front:	GetPointInFront3DCol(x,y,z,rx,rz,distance,tx,ty,tz);
			case o_back:	GetPointInFront3DCol(x,y,z,CompRotationFloat(rx+180.0),rz,distance,tx,ty,tz);
		}
	}
	
	Tryg3D_Function:: GetObjectOrientationPosCol(objectid,element_orientation:orientation,Float:distance,&Float:tx,&Float:ty,&Float:tz){
		new Float:x, Float:y, Float:z,
			Float:rx, Float:ry, Float:rz;
		GetObjectPos(objectid,x,y,z);
		GetObjectRot(objectid,rx,ry,rz); 
		switch(orientation){
			case o_left:	GetPointInFront3DCol(x,y,z,ry,CompRotationFloat(rz+90.0),distance,tx,ty,tz);
			case o_right:	GetPointInFront3DCol(x,y,z,CompRotationFloat(ry+180.0),CompRotationFloat(rz+90.0),distance,tx,ty,tz);
			case o_up: {
				GetObjectUpPos(objectid,distance,tx,ty,tz);
				MovePointCol(x,y,z,tx,ty,tz,tx,ty,tz);
			}
			case o_down: {
				GetObjectDownPos(objectid,distance,tx,ty,tz);
				MovePointCol(x,y,z,tx,ty,tz,tx,ty,tz);
			}
			case o_front:	GetPointInFront3DCol(x,y,z,rx,rz,distance,tx,ty,tz);
			case o_back:	GetPointInFront3DCol(x,y,z,CompRotationFloat(rx+180.0),rz,distance,tx,ty,tz);
		}
	}
	
	Tryg3D_Function:: GetPointCollisionFlags(Float:x,Float:y,Float:z,interiorid=0){
		new bool:isinterior = false, flag_value;
		if(interiorid != 0){
			flag_value |= POSITION_FLAG_INTERIOR;
			isinterior = true;
		} else {
			flag_value |= POSITION_FLAG_WORLD;
		}
		
		if(IsPointInUnderwater(x,y,z)){
			flag_value |= POSITION_FLAG_WATER;
			flag_value |= POSITION_FLAG_UNDERWATER;
		} else if(IsPointInWater(x,y,z)){
			flag_value |= POSITION_FLAG_WATER;
		} else if(IsPointInAir(x,y,z,isinterior,2.2)){
			flag_value |= POSITION_FLAG_AIR;
		} else if(IsPointInUnderground(x,y,z)){
			flag_value |= POSITION_FLAG_UNDERGROUND;
		} else {
			flag_value |= POSITION_FLAG_GROUND;
		}
		return flag_value;
	}
	
	Tryg3D_Function:: GetPlayerCollisionFlags(playerid){
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid,x,y,z);
		return GetPointCollisionFlags(x,y,z,GetPlayerInterior(playerid));
	}
	
	Tryg3D_Function:: GetVehicleCollisionFlags(vehicleid){
		new Float:x, Float:y, Float:z;
		GetVehiclePos(vehicleid,x,y,z);
		return GetPointCollisionFlags(x,y,z);
	}
	
	Tryg3D_Function:: GetObjectCollisionFlags(objectid){
		new Float:x, Float:y, Float:z;
		GetObjectPos(objectid,x,y,z);
		return GetPointCollisionFlags(x,y,z);
	}
	
	Tryg3D_Function:: bool:IsBetweenPlayersIsWall(playerid,targetid){
		new Float:xA,Float:yA,Float:zA,Float:xB,Float:yB,Float:zB,Float:xC,Float:yC,Float:zC;
		GetPlayerPos(playerid,xA,yA,zA);
		GetPlayerPos(targetid,xB,yB,zB);
		CA_RayCastLine(xA,yA,zA,xB,yB,zB,xC,yC,zC);
		return !(xC == 0.0 || yC == 0.0 || zC == 0.0);
	}
	
	Tryg3D_Function:: bool:IsBetweenPlayerToPointIsWall(playerid,Float:x,Float:y,Float:z){
		new Float:xA,Float:yA,Float:zA,Float:xC,Float:yC,Float:zC;
		GetPlayerPos(playerid,xA,yA,zA);
		CA_RayCastLine(xA,yA,zA,x,y,z,xC,yC,zC);
		return !(xC == 0.0 || yC == 0.0 || zC == 0.0);
	}
	
	Tryg3D_Function:: bool:GetPointInWallForPoint(Float:x,Float:y,Float:z,Float:radius,&Float:tx,&Float:ty,&Float:tz,Float:sector=90.0){
		if(sector <= 0.0 || sector > 360.0) return false;
		new Float:px,Float:py,Float:pz,Float:tmp_dist,Float:near_dist = 20000.0,sec_cnt = floatround(360.0/sector);
		if(sec_cnt > 360) sec_cnt = 360;
		
		for(new i = 0; i < sec_cnt; i++){
			GetPointInFront3DCol(x,y,z,0.0,CompRotationFloat(sector*i),radius,px,py,pz); 
			tmp_dist = GetDistanceBetweenPoints3D(x,y,z,px,py,pz);
			if(tmp_dist < near_dist){
				near_dist = tmp_dist;
				tx = px;
				ty = py;
				tz = pz;
			}
		}
		return true;
	}
	
	Tryg3D_Function:: bool:IsPlayerInRangeOfPlayer(playerid,Float:range,targetid,bool:testLOS=true){
		new Float:x,Float:y,Float:z;
		GetPlayerPos(targetid,x,y,z);
		if(testLOS){
			return (IsPlayerInRangeOfPoint(playerid,range,x,y,z) && !IsBetweenPlayerToPointIsWall(playerid,x,y,z));
		} else {
			return bool:IsPlayerInRangeOfPoint(playerid,range,x,y,z);
		}
	}

	Tryg3D_Function:: bool:IsPlayerInRangeOfVehicle(playerid,Float:range,vehicleid,bool:testLOS=true){
		new Float:x,Float:y,Float:z;
		GetVehiclePos(vehicleid,x,y,z);
		if(testLOS){
			return (IsPlayerInRangeOfPoint(playerid,range,x,y,z) && !IsBetweenPlayerToPointIsWall(playerid,x,y,z));
		} else {
			return bool:IsPlayerInRangeOfPoint(playerid,range,x,y,z);
		}
	}

	Tryg3D_Function:: bool:IsPlayerInRangeOfObject(playerid,Float:range,objectid,bool:testLOS=true){
		new Float:x,Float:y,Float:z;
		GetObjectPos(objectid,x,y,z);
		if(testLOS){
			return (IsPlayerInRangeOfPoint(playerid,range,x,y,z) && !IsBetweenPlayerToPointIsWall(playerid,x,y,z));
		} else {
			return bool:IsPlayerInRangeOfPoint(playerid,range,x,y,z);
		}
	}

	Tryg3D_Function:: bool:IsPlayerInRangeOfPointCol(playerid,Float:range,Float:x,Float:y,Float:z,bool:testLOS=true){
		if(testLOS){
			return (IsPlayerInRangeOfPoint(playerid,range,x,y,z) && !IsBetweenPlayerToPointIsWall(playerid,x,y,z));
		} else {
			return bool:IsPlayerInRangeOfPoint(playerid,range,x,y,z);
		}
	}

	#if defined Tryg3D_Actor
	
		Tryg3D_Function:: bool:IsPlayerInRangeOfActor(playerid,Float:range,actorid,bool:testLOS=true){
			new Float:x,Float:y,Float:z;
			GetActorPos(actorid,x,y,z);
			if(testLOS){
				return (IsPlayerInRangeOfPoint(playerid,range,x,y,z) && !IsBetweenPlayerToPointIsWall(playerid,x,y,z));
			} else {
				return bool:IsPlayerInRangeOfPoint(playerid,range,x,y,z);
			}
		}
		
	#endif
	
	//Streamer + Colandreas Functions
	#if defined Tryg3D_Streamer
		Tryg3D_Function:: GetDynamicObjectCollisionFlags(objectid){
			new Float:x, Float:y, Float:z;
			GetDynamicObjectPos(objectid,x,y,z);
			return GetPointCollisionFlags(x,y,z);
		}
	
		Tryg3D_Function:: GetDynamicObjectOrientPosCol(objectid,element_orientation:orientation,Float:distance,&Float:tx,&Float:ty,&Float:tz){
			new Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;
			GetDynamicObjectPos(objectid,x,y,z);
			GetDynamicObjectRot(objectid,rx,ry,rz); 
			switch(orientation){
				case o_left:	GetPointInFront3DCol(x,y,z,ry,CompRotationFloat(rz+90.0),distance,tx,ty,tz);
				case o_right:	GetPointInFront3DCol(x,y,z,CompRotationFloat(ry+180.0),CompRotationFloat(rz+90.0),distance,tx,ty,tz);
				case o_up: {
					GetDynamicObjectUpPos(objectid,distance,tx,ty,tz);
					MovePointCol(x,y,z,tx,ty,tz,tx,ty,tz);
				}
				case o_down: {
					GetDynamicObjectDownPos(objectid,distance,tx,ty,tz);
					MovePointCol(x,y,z,tx,ty,tz,tx,ty,tz);
				}
				case o_front:	GetPointInFront3DCol(x,y,z,rx,rz,distance,tx,ty,tz);
				case o_back:	GetPointInFront3DCol(x,y,z,CompRotationFloat(rx+180.0),rz,distance,tx,ty,tz);
			}
		}
		
		Tryg3D_Function:: bool:IsPlayerInRangeOfDynamicObject(playerid,Float:range,objectid,bool:testLOS=true){
			new Float:x,Float:y,Float:z;
			GetDynamicObjectPos(objectid,x,y,z);
			if(testLOS){
				return (IsPlayerInRangeOfPoint(playerid,range,x,y,z) && !IsBetweenPlayerToPointIsWall(playerid,x,y,z));
			} else {
				return bool:IsPlayerInRangeOfPoint(playerid,range,x,y,z);
			}
		}
		
		#if defined STREAMER_TYPE_ACTOR
			Tryg3D_Function:: GetDynamicActorOrientPosCol(actorid,element_orientation:orientation,Float:distance,&Float:tx,&Float:ty,&Float:tz){
				new Float:x, Float:y, Float:z, Float:rz;
				GetDynamicActorPos(actorid,x,y,z);
				GetDynamicActorFacingAngle(actorid,rz);
				switch(orientation){
					case o_left:	GetPointInFront3DCol(x,y,z,0.0,CompRotationFloat(rz+90.0),distance,tx,ty,tz);
					case o_right:	GetPointInFront3DCol(x,y,z,0.0,CompRotationFloat(rz-90.0),distance,tx,ty,tz);
					case o_up:		GetPointInFront3DCol(x,y,z,90.0,0.0,distance,tx,ty,tz);
					case o_down:	GetPointInFront3DCol(x,y,z,270.0,0.0,distance,tx,ty,tz);
					case o_front:	GetPointInFront3DCol(x,y,z,0.0,rz,distance,tx,ty,tz);
					case o_back:	GetPointInFront3DCol(x,y,z,0.0,CompRotationFloat(rz+180.0),distance,tx,ty,tz);
				}
			}
			
			Tryg3D_Function:: bool:IsPlayerInRangeOfDynamicActor(playerid,Float:range,actorid,bool:testLOS=true){
				new Float:x,Float:y,Float:z;
				GetDynamicActorPos(actorid,x,y,z);
				if(testLOS){
					return (IsPlayerInRangeOfPoint(playerid,range,x,y,z) && !IsBetweenPlayerToPointIsWall(playerid,x,y,z));
				} else {
					return bool:IsPlayerInRangeOfPoint(playerid,range,x,y,z);
				}
			}
		#endif
	#endif

	#define GetXYInFrontOfPlayerCol						GetPointInFrontOfPlayerCol
	#define GetPointInFrontCol							GetPointInFront3DCol
	#define GetPointInFrontOfCameraCol					GetPointInFrontOfCamera3DCol
	
	#define GetPointInFrontOnGround(%0,%1,%2,%3,%4,%5,%6,%7,%8) GetPointInFront3DCol((%0),(%1),(%2),(%3),(%4),(%8),(%5),(%6),(%7))

#endif

/************************************************************************************************************************************
 *                                                                                                                                  *
 * MapAndreas Functions                                                                                                             *
 *                                                                                                                                  *
 ************************************************************************************************************************************/

#if ((defined Tryg3D_MapAndreas) && (!defined Tryg3D_ColAndreas))
	Tryg3D_Function:: GetPointInFrontOnGround(Float:x,Float:y,Float:z,Float:rx,Float:rz,&Float:tx,&Float:ty,&Float:tz,Float:max_distance){
		new Float:tmpz;
		Tryg3D_MapAndreasFindZ(x,y,tmpz);
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
		if(!((dist > max_distance) || (rx >= 0.0 && rx <= 180.0))){
			Tryg3D_MapAndreasFindZ(tx,ty,tz);
		}
	}
	
	Tryg3D_Function:: bool:IsPointInWater(Float:x,Float:y,Float:z=0.0){
		if(z > 0.0) return false;
		new Float:tmpz;
		Tryg3D_MapAndreasFindZ(x,y,tmpz);
		return (tmpz == 0.0);
	}
	
#endif

/************************************************************************************************************************************
 *                                                                                                                                  *
 * MapAndreas/ColAndreas Functions                                                                                                  *
 *                                                                                                                                  *
 ************************************************************************************************************************************/
 
#if (defined Tryg3D_MapAndreas || defined Tryg3D_ColAndreas)
	Tryg3D_Function:: GetGroundRotation(Float:x,Float:y,Float:size,&Float:rx,&Float:ry){
		new Float:tpx1,Float:tpy1,Float:tpz1,
			Float:tpx2,Float:tpy2,Float:tpz2,
			Float:tmp_float;
		GetPointInFront2D(x,y,0.0,size,tpx1,tpy1);
		GetPointInFront2D(x,y,180.0,size,tpx2,tpy2);
		Tryg3D_MapAndreasFindZ(tpx1,tpy1,tpz1);
		Tryg3D_MapAndreasFindZ(tpx2,tpy2,tpz2);
		GetRotationFor2Point3D(tpx1,tpy1,tpz1,tpx2,tpy2,tpz2,rx,tmp_float);
		
		GetPointInFront2D(x,y,90.0,size,tpx1,tpy1);
		GetPointInFront2D(x,y,270.0,size,tpx2,tpy2);
		Tryg3D_MapAndreasFindZ(tpx1,tpy1,tpz1);
		Tryg3D_MapAndreasFindZ(tpx2,tpy2,tpz2);
		GetRotationFor2Point3D(tpx1,tpy1,tpz1,tpx2,tpy2,tpz2,ry,tmp_float);
	}

	Tryg3D_Function:: bool:IsPointInWaterFrontOfPlayer(playerid,Float:radius){
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid,x,y,z);
		GetPointInFrontOfPlayer(playerid,x,y,radius);
		#if defined Tryg3D_ColAndreas
			return IsPointInWater(x,y,0.0);
		#else
			new Float:tmpz;
			Tryg3D_MapAndreasFindZ(x,y,tmpz);
			return (tmpz <= 0.0);
		#endif
	}
#endif

/************************************************************************************************************************************
 *                                                                                                                                  *
 * YSF Functions                                                                                                                    *
 *                                                                                                                                  *
 ************************************************************************************************************************************/
 
#if defined Tryg3D_YSF

	#define GetPlayerHydraReactorRX(%0) 				CompRotationFloat((GetPlayerHydraReactorAngle(%0)/55.5555555))
	#define IsPlayerHydraReactorBoost(%0)				(GetPlayerHydraReactorAngle(%0) == 0)
	
	Tryg3D_Function:: CountTextDraw(){
		new T3D:count = 0;
		for(new i = 0; i < MAX_TEXT_DRAWS; i++){
			if(IsValidTextDraw(Text:i)) T3D:count++;
		}
		return T3D:count;
	}
	
	Tryg3D_Function:: CountVisibleTextDraw(playerid){
		new T3D:count = 0;
		for(new i = 0; i < MAX_TEXT_DRAWS; i++){
			if(IsValidTextDraw(Text:i) && IsTextDrawVisibleForPlayer(playerid,Text:i)) T3D:count++;
		}
		return T3D:count;
	}
	
	Tryg3D_Function:: CountPlayerTextDraw(playerid){
		new T3D:count = 0;
		for(new i = 0; i < MAX_PLAYER_TEXT_DRAWS; i++){
			if(IsValidPlayerTextDraw(playerid,PlayerText:i)) T3D:count++;
		}
		return T3D:count;
	}

	Tryg3D_Function:: CountVisiblePlayerTextDraw(playerid){
		new T3D:count = 0;
		for(new i = 0; i < MAX_PLAYER_TEXT_DRAWS; i++){
			if(IsValidPlayerTextDraw(playerid,PlayerText:i) && IsPlayerTextDrawVisible(playerid,PlayerText:i)) T3D:count++;
		}
		return T3D:count;
	}
	
	Tryg3D_Function:: bool:IsVehicleOnSpawn(vehicleid,Float:check_radius=1.0){
		new Float:x,Float:y,Float:z,Float:rz,color1,color2;
		GetVehicleSpawnInfo(vehicleid,x,y,z,rz,color1,color2);
		return IsVehicleInRangeOfPoint(vehicleid,check_radius,x,y,z);
	}

	Tryg3D_Function:: bool:IsPlayerOnSpawn(playerid,Float:check_radius=1.0){
		new teamid,modelid,Float:spawn_x,Float:spawn_y,Float:spawn_z,Float:z_angle,weapon1,weapon1_ammo,weapon2,weapon2_ammo,weapon3,weapon3_ammo;
		GetSpawnInfo(playerid,teamid,modelid,spawn_x,spawn_y,spawn_z,z_angle,weapon1,weapon1_ammo,weapon2,weapon2_ammo,weapon3,weapon3_ammo);
		return bool:IsPlayerInRangeOfPoint(playerid,check_radius,spawn_x,spawn_y,spawn_z);
	}

	Tryg3D_Function:: GetPlayerRotation(playerid,&Float:rx,&Float:ry,&Float:rz){
		new Float:qw,Float:qx,Float:qy,Float:qz;
		GetPlayerRotationQuat(playerid,qw,qx,qy,qz);
		CompRotationFloat(asin(2*qy*qz-2*qx*qw),rx);
		CompRotationFloat(-atan2(qx*qz+qy*qw,0.5-qx*qx-qy*qy),ry);
		CompRotationFloat(-atan2(qx*qy+qz*qw,0.5-qx*qx-qz*qz),rz);
	}
	
	Tryg3D_Function:: GetRandomPointInGangZone(zoneid,&Float:tx,&Float:ty){
		new Float:minx,Float:miny,Float:maxx,Float:maxy;
		GangZoneGetPos(zoneid,minx,miny,maxx,maxy);
		GetRandomPointInRectangle(minx,miny,maxx,maxy,tx,ty);
	}
	
	Tryg3D_Function:: GetRandomPointInPlayerGangZone(playerid,zoneid,&Float:tx,&Float:ty){
		new Float:minx,Float:miny,Float:maxx,Float:maxy;
		PlayerGangZoneGetPos(playerid,zoneid,minx,miny,maxx,maxy);
		GetRandomPointInRectangle(minx,miny,maxx,maxy,tx,ty);
	}
	
	//YSF Timeline Sync (Beta Version)
	#if defined ENABLE_3D_TRYG_TIMELINE_SYNC
		
		new T3D:PlayerFirstSpawn[MAX_PLAYERS];
		
		#define GetPlayerTimeline(%0)					GetPVarInt((%0),"T3D:PlayerTimeline")
		#define IsPlayerVisibleOnServer(%0)				GetPVarInt((%0),"T3D:PlayerVisible")

		Tryg3D_Function:: UpdatePlayerTimeline(playerid){
			new tline = GetPlayerTimeline(playerid), pskin = GetPlayerSkin(playerid), pcolor = GetPlayerColor(playerid),
				Float:px, Float:py, Float:pz;
			GetPlayerPos(playerid,px,py,pz);
			Tryg3DForeach(i){
				if(i != playerid){
					if(tline == GetPlayerTimeline(i)){
						if(GetPlayerDistanceFromPoint(i,px,py,pz) <= Tryg3D_StreamDistance){
							ShowPlayerForPlayer(i,playerid);
							ShowPlayerForPlayer(playerid,i);
							
							SetPlayerSkinForPlayer(i,playerid,pskin);
							SetPlayerSkinForPlayer(playerid,i,GetPlayerSkin(i));
							
							if(Tryg3D_IsPlayerSpawned(playerid)){
								SetPlayerMarkerForPlayer(i,playerid,pcolor);
							}
							SetPlayerMarkerForPlayer(playerid,i,GetPlayerColor(i));
						}
					} else if(tline == -1){
						if(GetPlayerDistanceFromPoint(i,px,py,pz) <= Tryg3D_StreamDistance){
							ShowPlayerForPlayer(playerid,i);
							
							SetPlayerSkinForPlayer(playerid,i,GetPlayerSkin(i));
							
							SetPlayerMarkerForPlayer(playerid,i,GetPlayerColor(i));
						}
					} else {
						HidePlayerForPlayer(i,playerid);
						HidePlayerForPlayer(playerid,i);
						
						SetPlayerMarkerForPlayer(i,playerid,(pcolor & 0xFFFFFF00));
						SetPlayerMarkerForPlayer(playerid,i,(GetPlayerColor(i) & 0xFFFFFF00));
					}
				}
			}
		}

		Tryg3D_Function:: SetPlayerTimeline(playerid,timeline){
			SetPVarInt(playerid,"T3D:PlayerTimeline",timeline);
			UpdatePlayerTimeline(playerid);
		}

		Tryg3D_Function:: GetPlayerPos4D(playerid,&Float:x,&Float:y,&Float:z,&timeline){
			GetPlayerPos(playerid,x,y,z);
			timeline = GetPlayerTimeline(playerid);
		}

		Tryg3D_Function:: SetPlayerPos4D(playerid,Float:x,Float:y,Float:z,timeline=0){
			SetPlayerPos(playerid,x,y,z);
			if(GetPlayerTimeline(playerid) != timeline) SetPlayerTimeline(playerid,timeline);
		}
		
		Tryg3D_Function:: CreateDynamicExplosion4D(Float:x,Float:y,Float:z,type,Float:radius,worldid = -1,interiorid = -1,timeline = -1,playerid = -1,Float:distance = 200.0){
			if(playerid == -1){
				Tryg3DForeach(i){
					new Float:px, Float:py, Float:pz;
					if(IsPlayerInAnyVehicle(i)){
						GetVehiclePos(GetPlayerVehicleID(i),px,py,pz);
					} else {
						GetPlayerPos(i,px,py,pz);
					}
					if(GetPlayerTimeline(i) == timeline || timeline == -1){
						if((GetPlayerInterior(i) == interiorid || interiorid == -1) && (GetPlayerVirtualWorld(i) == worldid || worldid == -1) && (VectorSize(px-x,py-y,pz-z) <= distance)){
							CreateExplosionForPlayer(i,x,y,z,type,radius);
						}
					}
				}
			} else {
				if(IsPlayerConnected(playerid)){
					new Float:px, Float:py, Float:pz;
					if(IsPlayerInAnyVehicle(playerid)){
						GetVehiclePos(GetPlayerVehicleID(playerid),px,py,pz);
					} else {
						GetPlayerPos(playerid,px,py,pz);
					}
					if((GetPlayerInterior(playerid) == interiorid || interiorid == -1) && (GetPlayerVirtualWorld(playerid) == worldid || worldid == -1) && (VectorSize(px-x,py-y,pz-z) <= distance)){
						CreateExplosionForPlayer(playerid,x,y,z,type,radius);
					}
				}
			}
		}
		
		Tryg3D_Function:: UpdatePlayerOnServer(playerid){
			Tryg3DForeach(i){
				if(playerid != i){
					if(IsPlayerVisibleOnServer(playerid)){
						RemovePlayerForPlayer(i,playerid);
						AddPlayerForPlayer(i,playerid,0);
					} else {
						RemovePlayerForPlayer(i,playerid);
					}
				}
			}
		}

		Tryg3D_Function:: CheckPlayersOnServer(playerid){
			Tryg3DForeach(i){
				if(playerid != i){
					if(!IsPlayerVisibleOnServer(i)){
						RemovePlayerForPlayer(playerid,i);
					}
				}
			}
		}

		Tryg3D_Function:: TogglePlayerVisibleOnServer(playerid,bool:toggle){
			TogglePlayerInServerQuery(playerid,toggle);
			SetPVarInt(playerid,"T3D:PlayerVisible",toggle?1:0);
			UpdatePlayerOnServer(playerid);
			if(toggle){
				SetPlayerTimeline(playerid,0);
			} else {
				SetPlayerTimeline(playerid,-1);
			}
		}
	
		//Hook: OnPlayerStreamIn
		public OnPlayerStreamIn(playerid,forplayerid){
			if(GetPlayerTimeline(playerid) == GetPlayerTimeline(forplayerid)){
				ShowPlayerForPlayer(forplayerid,playerid);
				ShowPlayerForPlayer(playerid,forplayerid);
				
				SetPlayerSkinForPlayer(forplayerid,playerid,GetPlayerSkin(playerid));
				SetPlayerSkinForPlayer(playerid,forplayerid,GetPlayerSkin(forplayerid));
				
				if(Tryg3D_IsPlayerSpawned(playerid)){
					SetPlayerMarkerForPlayer(forplayerid,playerid,GetPlayerColor(playerid));
				}
				SetPlayerMarkerForPlayer(playerid,forplayerid,GetPlayerColor(forplayerid));
			} else {
				HidePlayerForPlayer(forplayerid,playerid);
				HidePlayerForPlayer(playerid,forplayerid);
				
				SetPlayerMarkerForPlayer(forplayerid,playerid,(GetPlayerColor(playerid) & 0xFFFFFF00));
				SetPlayerMarkerForPlayer(playerid,forplayerid,(GetPlayerColor(forplayerid) & 0xFFFFFF00));
			}
			#if defined Tryg3D_OnPlayerStreamIn
				Tryg3D_OnPlayerStreamIn(playerid,forplayerid);
			#endif
			return 1;
		}
	
		#if defined _ALS_OnPlayerStreamIn
			#undef OnPlayerStreamIn
		#else
			#define _ALS_OnPlayerStreamIn
		#endif
		#define OnPlayerStreamIn Tryg3D_OnPlayerStreamIn
		#if defined Tryg3D_OnPlayerStreamIn
			forward Tryg3D_OnPlayerStreamIn(playerid,forplayerid);
		#endif

		//Hook: OnPlayerConnect
		public OnPlayerConnect(playerid){
			T3D:PlayerFirstSpawn[playerid] = true;
			SetPVarInt(playerid,"T3D:PlayerTimeline",0);
			SetPVarInt(playerid,"T3D:PlayerVisible",1);
			#if defined Tryg3D_OnPlayerConnect
				Tryg3D_OnPlayerConnect(playerid);
			#endif
			return 1;
		}

		#if defined _ALS_OnPlayerConnect
			#undef OnPlayerConnect
		#else
			#define _ALS_OnPlayerConnect
		#endif
		#define OnPlayerConnect Tryg3D_OnPlayerConnect
		#if defined Tryg3D_OnPlayerConnect
			forward Tryg3D_OnPlayerConnect(playerid);
		#endif

		//Hook: OnPlayerSpawn
		public OnPlayerSpawn(playerid){
			if(T3D:PlayerFirstSpawn[playerid]){
				T3D:PlayerFirstSpawn[playerid] = false;
				CheckPlayersOnServer(playerid);
			}
			UpdatePlayerTimeline(playerid);
			#if defined Tryg3D_OnPlayerSpawn
				Tryg3D_OnPlayerSpawn(playerid);
			#endif
			return 1;
		}

		#if defined _ALS_OnPlayerSpawn
			#undef OnPlayerSpawn
		#else
			#define _ALS_OnPlayerSpawn
		#endif
		#define OnPlayerSpawn Tryg3D_OnPlayerSpawn
		#if defined Tryg3D_OnPlayerSpawn
			forward Tryg3D_OnPlayerSpawn(playerid);
		#endif

	#endif
#endif

/************************************************************************************************************************************
 *                                                                                                                                  *
 * FCNPC Functions                                                                                                                  *
 *                                                                                                                                  *
 ************************************************************************************************************************************/
 
#if defined Tryg3D_FCNPC
	
	#define IsNPCInRangeOfPoint(%0,%1,%2,%3,%4)		(GetElementDistanceFromPoint((%0),item_npc,(%2),(%3),(%4)) <= (%1))
	
	Tryg3D_Function:: Float:GetNPCSpeed(npcid){
		new Float:x,Float:y,Float:z;
		FCNPC_GetVelocity(npcid,x,y,z);
		return VectorSize(x,y,z);
	}

	Tryg3D_Function:: Float:GetPointInFrontOfNPC(npcid,&Float:tx,&Float:ty,Float:radius){
		new Float:rz;
		FCNPC_GetPosition(npcid,tx,ty,rz);
		if(IsPlayerInAnyVehicle(npcid)){
			GetVehicleZAngle(FCNPC_GetVehicleID(npcid),rz);
		} else {
			rz = FCNPC_GetAngle(npcid);
		}
		GetPointInFront2D(tx,ty,rz,radius,tx,ty);
		return rz;
	}
	
	Tryg3D_Function:: GetNPCOrientationPos(npcid,element_orientation:orientation,Float:distance,&Float:tx,&Float:ty,&Float:tz){
		new Float:x,Float:y,Float:z,Float:rz;

		FCNPC_GetPosition(npcid,x,y,z);
		rz = FCNPC_GetAngle(npcid);
		
		switch(orientation){
			case o_left:	GetPointInFront3D(x,y,z,0.0,CompRotationFloat(rz+90.0),distance,tx,ty,tz);
			case o_right:	GetPointInFront3D(x,y,z,0.0,CompRotationFloat(rz-90.0),distance,tx,ty,tz);
			case o_up:		tx = x, ty = y, tz = z + distance;
			case o_down:	tx = x, ty = y, tz = z - distance;
			case o_front:	GetPointInFront3D(x,y,z,0.0,rz,distance,tx,ty,tz);
			case o_back:	GetPointInFront3D(x,y,z,0.0,CompRotationFloat(rz+180.0),distance,tx,ty,tz);
		}
	}
	
	Tryg3D_Function:: Float:GetNPCTargetAngle(npcid,Float:x,Float:y,&Float:rz=0.0){
		new Float:mx,Float:my;
		FCNPC_GetPosition(npcid,mx,my,rz);
		GetRotationFor2Point2D(mx,my,x,y,rz);
		return rz;
	}

	Tryg3D_Function:: Float:SetNPCTargetAngle(npcid,Float:x,Float:y,&Float:rz=0.0){
		new Float:mx,Float:my;
		FCNPC_GetPosition(npcid,mx,my,rz);
		GetRotationFor2Point2D(mx,my,x,y,rz);
		FCNPC_SetAngle(npcid,rz);
		return rz;
	}

	Tryg3D_Function:: Float:GetNPCTargetNPCAngle(npcid,targetid,&Float:rz=0.0){
		new Float:mx,Float:my,Float:x,Float:y;
		FCNPC_GetPosition(npcid,mx,my,rz);
		FCNPC_GetPosition(targetid,x,y,rz);
		GetRotationFor2Point2D(mx,my,x,y,rz);
		return rz;
	}

	Tryg3D_Function:: Float:SetNPCTargetNPCAngle(npcid,targetid,&Float:rz=0.0){
		new Float:mx,Float:my,Float:x,Float:y;
		FCNPC_GetPosition(npcid,mx,my,rz);
		FCNPC_GetPosition(targetid,x,y,rz);
		GetRotationFor2Point2D(mx,my,x,y,rz);
		FCNPC_SetAngle(npcid,rz);
		return rz;
	}
	
	Tryg3D_Function:: bool:GetNPCToPointVector(npcid,Float:tx,Float:ty,Float:tz,&Float:vx,&Float:vy,&Float:vz){
		new Float:px,Float:py,Float:pz,Float:rx,Float:rz;
		FCNPC_GetPosition(npcid,px,py,pz);
		if(GetRotationFor2Point3D(px,py,pz,tx,ty,tz,rx,rz)){
			ShiftRotationToVector(rx,rz,vx,vy,vz);
			return true;
		} else {
			vx = vy = vz = 0.0;
			return false;
		}
	}

	Tryg3D_Function:: GetNPCRotatedVector(npcid,Float:tx,Float:ty,Float:tz,&Float:vx,&Float:vy,&Float:vz,bool:return_vector=true,Float:rx=0.0,Float:ry=0.0,Float:rz=0.0){
		new Float:px,Float:py,Float:pz;
		FCNPC_GetPosition(npcid,px,py,pz);
		if(return_vector){
			ShiftLineRotationVector(px,py,pz,tx,ty,tz,rx,ry,rz,vx,vy,vz);
		} else {
			ShiftLineRotation(px,py,pz,tx,ty,tz,rx,ry,rz,vx,vy,vz);
		}
	}
	
	Tryg3D_Function:: FCNPC_SetVehicleRotation(npcid,Float:rx,Float:ry,Float:rz){
		new Float:qw,Float:qx,Float:qy,Float:qz;
		GetQuatFromRot(rx,ry,rz,qw,qx,qy,qz);
		FCNPC_SetQuaternion(npcid,-qw,qx,qy,qz);
	}
	
	Tryg3D_Function:: bool:FCNPC_SetVehicleTargetRotation(npcid,Float:tx,Float:ty,Float:tz,Float:ry=0.0){
		new Float:x,Float:y,Float:z,Float:rx,Float:rz;
		GetVehiclePos(FCNPC_GetVehicleID(npcid),x,y,z);
		if(GetRotationFor2Point3D(x,y,z,tx,ty,tz,rx,rz)){
			new Float:qw,Float:qx,Float:qy,Float:qz;
			GetQuatFromRot(rx,ry,rz,qw,qx,qy,qz);
			FCNPC_SetQuaternion(npcid,-qw,qx,qy,qz);
			return true;
		}
		return false;
	}
	
	Tryg3D_Function:: FCNPC_GoToAir(npcid,Float:x,Float:y,Float:z,type = MOVE_TYPE_AUTO,Float:speed = MOVE_SPEED_AUTO){
		FCNPC_SetVehicleTargetRotation(npcid,x,y,z);
		FCNPC_GoTo(npcid,x,y,z,type,speed,false,0.0,false);
	}
	
	#if (defined Tryg3D_MapAndreas || defined Tryg3D_ColAndreas)
		Tryg3D_Function:: bool:IsPointInWaterFrontOfNPC(npcid,Float:radius){
			new Float:x, Float:y, Float:z;
			FCNPC_GetPosition(npcid,x,y,z);
			GetPointInFrontOfNPC(npcid,x,y,radius);
			#if defined Tryg3D_ColAndreas
				return IsPointInWater(x,y,0.0);
			#else
				new Float:tmpz;
				Tryg3D_MapAndreasFindZ(x,y,tmpz);
				return (tmpz <= 0.0);
			#endif
		}
	#endif
	
	#if defined Tryg3D_ColAndreas
		Tryg3D_Function:: Float:GetPointInFrontOfNPCCol(npcid,&Float:tx,&Float:ty,Float:radius){
			new Float:rz,Float:z;
			FCNPC_GetPosition(npcid,tx,ty,z);
			if(IsPlayerInAnyVehicle(npcid)){
				GetVehicleZAngle(FCNPC_GetVehicleID(npcid),rz);
			} else {
				rz = FCNPC_GetAngle(npcid);
			}
			GetPointInFront3DCol(tx,ty,z,0.0,rz,radius,tx,ty,z);
			return rz;
		}

		Tryg3D_Function:: GetNPCCollisionFlags(npcid){
			new Float:x, Float:y, Float:z;
			FCNPC_GetPosition(npcid,x,y,z);
			return GetPointCollisionFlags(x,y,z,FCNPC_GetInterior(npcid));
		}

		Tryg3D_Function:: bool:IsBetweenNPCsIsWall(npcid,targetid){
			new Float:xA,Float:yA,Float:zA,Float:xB,Float:yB,Float:zB,Float:xC,Float:yC,Float:zC;
			FCNPC_GetPosition(npcid,xA,yA,zA);
			FCNPC_GetPosition(targetid,xB,yB,zB);
			CA_RayCastLine(xA,yA,zA,xB,yB,zB,xC,yC,zC);
			return !(xC == 0.0 || yC == 0.0 || zC == 0.0);
		}

		Tryg3D_Function:: bool:IsBetweenNPCToPointIsWall(npcid,Float:x,Float:y,Float:z){
			new Float:xA,Float:yA,Float:zA,Float:xC,Float:yC,Float:zC;
			FCNPC_GetPosition(npcid,xA,yA,zA);
			CA_RayCastLine(xA,yA,zA,x,y,z,xC,yC,zC);
			return !(xC == 0.0 || yC == 0.0 || zC == 0.0);
		}
		
		Tryg3D_Function:: GetNPCOrientationPosCol(npcid,element_orientation:orientation,Float:distance,&Float:tx,&Float:ty,&Float:tz){
			new Float:x,Float:y,Float:z,Float:rz;

			FCNPC_GetPosition(npcid,x,y,z);
			rz = FCNPC_GetAngle(npcid);

			switch(orientation){
				case o_left:	GetPointInFront3DCol(x,y,z,0.0,CompRotationFloat(rz+90.0),distance,tx,ty,tz);
				case o_right:	GetPointInFront3DCol(x,y,z,0.0,CompRotationFloat(rz-90.0),distance,tx,ty,tz);
				case o_up:		GetPointInFront3DCol(x,y,z,90.0,0.0,distance,tx,ty,tz);
				case o_down:	GetPointInFront3DCol(x,y,z,270.0,0.0,distance,tx,ty,tz);
				case o_front:	GetPointInFront3DCol(x,y,z,0.0,rz,distance,tx,ty,tz);
				case o_back:	GetPointInFront3DCol(x,y,z,0.0,CompRotationFloat(rz+180.0),distance,tx,ty,tz);
			}
		}
		
		Tryg3D_Function:: FCNPC_GoToCol(npcid,Float:x,Float:y,Float:z,type = MOVE_TYPE_AUTO,Float:speed = MOVE_SPEED_AUTO,bool:UseMapAndreas = false,Float:cut_size = 0.0,bool:setangle = true){
			new Float:px,Float:py,Float:pz,Float:tx,Float:ty,Float:tz;
			FCNPC_GetPosition(npcid,px,py,pz);
			if(MovePointColCutLineEx(px,py,pz,x,y,z,tx,ty,tz,cut_size)){
				FCNPC_GoTo(npcid,tx,ty,tz,type,speed,UseMapAndreas,0.0,setangle);
			}
		}

		Tryg3D_Function:: FCNPC_GoToPlayerCol(npcid,playerid,type = MOVE_TYPE_AUTO,Float:speed = MOVE_SPEED_AUTO,bool:UseMapAndreas = false,Float:cut_size = 0.0,bool:setangle = true){
			new Float:px,Float:py,Float:pz,Float:x,Float:y,Float:z,Float:tx,Float:ty,Float:tz;
			GetPlayerPos(playerid,x,y,z);
			FCNPC_GetPosition(npcid,px,py,pz);
			if(MovePointColCutLineEx(px,py,pz,x,y,z,tx,ty,tz,cut_size)){
				FCNPC_GoTo(npcid,tx,ty,tz,type,speed,UseMapAndreas,0.0,setangle);
			}
		}
		
		Tryg3D_Function:: FCNPC_GoToPlayerOnGroundCol(npcid,playerid,type = MOVE_TYPE_AUTO,Float:speed = MOVE_SPEED_AUTO,bool:UseMapAndreas = false,Float:cut_size = 1.0,Float:climbing = 2.0,bool:setangle = true){
			new Float:px,Float:py,Float:pz,Float:x,Float:y,Float:z,Float:tx,Float:ty,Float:tz;
			GetPlayerPos(playerid,x,y,z);
			FCNPC_GetPosition(npcid,px,py,pz);
			if(GetDistanceBetweenPoints1D(pz,z) > climbing) z = pz;
			if(MovePointColCutLineEx(px,py,pz,x,y,z,tx,ty,tz,cut_size)){
				FCNPC_GoTo(npcid,tx,ty,tz,type,speed,UseMapAndreas,0.0,setangle);
			}
		}

		Tryg3D_Function:: FCNPC_GoToAirCol(npcid,Float:x,Float:y,Float:z,type = MOVE_TYPE_AUTO,Float:speed = MOVE_SPEED_AUTO,Float:cut_size = 0.0){
			new Float:px,Float:py,Float:pz,Float:tx,Float:ty,Float:tz;
			GetVehiclePos(FCNPC_GetVehicleID(npcid),px,py,pz);
			if(MovePointColCutLineEx(px,py,pz,x,y,z,tx,ty,tz,cut_size)){
				FCNPC_SetVehicleTargetRotation(npcid,tx,ty,tz);
				FCNPC_GoTo(npcid,tx,ty,tz,type,speed,false,0.0,false);
			}
		}
		
		Tryg3D_Function:: bool:IsPlayerInRangeOfNPC(playerid,Float:range,npcid,bool:testLOS=true){
			new Float:x,Float:y,Float:z;
			FCNPC_GetPosition(npcid,x,y,z);
			if(testLOS){
				return (IsPlayerInRangeOfPoint(playerid,range,x,y,z) && !IsBetweenPlayerToPointIsWall(playerid,x,y,z));
			} else {
				return bool:IsPlayerInRangeOfPoint(playerid,range,x,y,z);
			}
		}


		#define GetXYInFrontOfNPCCol					GetPointInFrontOfNPCCol
		
	#endif
	
	#define GetXYInFrontOfNPC 							GetPointInFrontOfNPC
	
#endif

/************************************************************************************************************************************
 *                                                                                                                                  *
 * Functions extra names                                                                                                            *
 *                                                                                                                                  *
 ************************************************************************************************************************************/
 
#define GetXYInFrontOfPlayer							GetPointInFrontOfPlayer
#define GetPointInFront									GetPointInFront3D
#define GetPointInFrontOfCamera							GetPointInFrontOfCamera3D
#define GetDistanceBetweenPoints						GetDistanceBetweenPoints3D
#define GetXYZInFrontOfVehicle(%0,%1,%2,%3,%4) 			GetPointInFrontOfVehicle3D((%0),(%2),(%3),(%4),(%1))
#define GetVehicleAngle									GetVehicleRotation
#define GetPlayersDistance								GetDistanceBetweenPlayers
#define GetVehiclesDistance								GetDistanceBetweenVehicles
#define GetObjectsDistance								GetDistanceBetweenObjects
#define IsPointInCylinder								IsPointInCylinder3D
#define IsPlayerInCylinder								IsPlayerInCylinder3D

#if defined USE_DEPRECATED_SCREEN_FUNCTION

	Tryg3D_Deprecated:: bool:IsPlayerOnPlayerScreen(playerid,targetid,Float:rx=INVALID_ROTATION,Float:rz=INVALID_ROTATION,Float:vrx=VERTICAL_CAMERA_RADIUS,Float:vrz=HORIZONTAL_CAMERA_RADIUS,bool:testLOS=true,bool:testVW=true){
		return IsElementOnPlayerScreen(playerid,targetid,item_player,o_front,rx,rz,vrx,vrz,testLOS,testVW);
	}

	Tryg3D_Deprecated:: bool:IsVehicleOnPlayerScreen(playerid,vehicleid,Float:rx=INVALID_ROTATION,Float:rz=INVALID_ROTATION,Float:vrx=VERTICAL_CAMERA_RADIUS,Float:vrz=HORIZONTAL_CAMERA_RADIUS,bool:testLOS=true,bool:testVW=true){
		return IsElementOnPlayerScreen(playerid,vehicleid,item_vehicle,o_front,rx,rz,vrx,vrz,testLOS,testVW);
	}

	Tryg3D_Deprecated:: bool:IsObjectOnPlayerScreen(playerid,objectid,Float:rx=INVALID_ROTATION,Float:rz=INVALID_ROTATION,Float:vrx=VERTICAL_CAMERA_RADIUS,Float:vrz=HORIZONTAL_CAMERA_RADIUS,bool:testLOS=true){
		return IsElementOnPlayerScreen(playerid,objectid,item_object,o_front,rx,rz,vrx,vrz,testLOS,false);
	}

	Tryg3D_Deprecated:: bool:IsPlayerOnFakeScreen(Float:x,Float:y,Float:z,targetid,Float:rx,Float:rz,Float:vrx=VERTICAL_CAMERA_RADIUS,Float:vrz=HORIZONTAL_CAMERA_RADIUS,bool:testLOS=true){
		return IsElementOnFakeScreen(x,y,z,targetid,item_player,rx,rz,vrx,vrz,bool:testLOS);
	}

	Tryg3D_Deprecated:: bool:IsVehicleOnFakeScreen(Float:x,Float:y,Float:z,vehicleid,Float:rx,Float:rz,Float:vrx=VERTICAL_CAMERA_RADIUS,Float:vrz=HORIZONTAL_CAMERA_RADIUS,bool:testLOS=true){
		return IsElementOnFakeScreen(x,y,z,vehicleid,item_vehicle,rx,rz,vrx,vrz,bool:testLOS);
	}

	Tryg3D_Deprecated:: bool:IsObjectOnFakeScreen(Float:x,Float:y,Float:z,objectid,Float:rx,Float:rz,Float:vrx=VERTICAL_CAMERA_RADIUS,Float:vrz=HORIZONTAL_CAMERA_RADIUS,bool:testLOS=true){
		return IsElementOnFakeScreen(x,y,z,objectid,item_object,rx,rz,vrx,vrz,bool:testLOS);
	}

	#if defined Tryg3D_Actor
		Tryg3D_Deprecated:: bool:IsActorOnPlayerScreen(playerid,actorid,Float:rx=INVALID_ROTATION,Float:rz=INVALID_ROTATION,Float:vrx=VERTICAL_CAMERA_RADIUS,Float:vrz=HORIZONTAL_CAMERA_RADIUS,bool:testLOS=true,bool:testVW=true){
			return IsElementOnPlayerScreen(playerid,targetid,,o_front,rx,rz,vrx,vrz,testLOS,testVW);
		}

		Tryg3D_Deprecated:: bool:IsActorOnFakeScreen(Float:x,Float:y,Float:z,actorid,Float:rx,Float:rz,Float:vrx=VERTICAL_CAMERA_RADIUS,Float:vrz=HORIZONTAL_CAMERA_RADIUS,bool:testLOS=true){
			return IsElementOnFakeScreen(x,y,z,actorid,item_actor,rx,rz,vrx,vrz,testLOS);
		}
	#endif

	#if defined Tryg3D_Streamer
		Tryg3D_Deprecated:: bool:IsDynamicObjectOnPlayerScreen(playerid,objectid,Float:rx=INVALID_ROTATION,Float:rz=INVALID_ROTATION,Float:vrx=VERTICAL_CAMERA_RADIUS,Float:vrz=HORIZONTAL_CAMERA_RADIUS,bool:testLOS=true,bool:testVW=true){
			return IsElementOnPlayerScreen(playerid,targetid,item_dynamic_object,o_front,rx,rz,vrx,vrz,testLOS,testVW);
		}

		Tryg3D_Deprecated:: bool:IsDynamicObjectOnFakeScreen(Float:x,Float:y,Float:z,objectid,Float:rx,Float:rz,Float:vrx=VERTICAL_CAMERA_RADIUS,Float:vrz=HORIZONTAL_CAMERA_RADIUS,bool:testLOS=true){
			return IsElementOnFakeScreen(x,y,z,objectid,item_dynamic_object,rx,rz,vrx,vrz,testLOS);
		}
		
		#if defined STREAMER_TYPE_ACTOR
			Tryg3D_Deprecated:: bool:IsDynamicActorOnPlayerScreen(playerid,actorid,Float:rx=INVALID_ROTATION,Float:rz=INVALID_ROTATION,Float:vrx=VERTICAL_CAMERA_RADIUS,Float:vrz=HORIZONTAL_CAMERA_RADIUS,bool:testLOS=true,bool:testVW=true){
				return IsElementOnPlayerScreen(playerid,targetid,item_dynamic_actor,o_front,rx,rz,vrx,vrz,testLOS,testVW);
			}

			Tryg3D_Deprecated:: bool:IsDynamicActorOnFakeScreen(Float:x,Float:y,Float:z,actorid,Float:rx,Float:rz,Float:vrx=VERTICAL_CAMERA_RADIUS,Float:vrz=HORIZONTAL_CAMERA_RADIUS,bool:testLOS=true){
				return IsElementOnFakeScreen(x,y,z,actorid,item_dynamic_actor,rx,rz,vrx,vrz,testLOS);
			}
		#endif
	#endif

#endif

/************************************************************************************************************************************
 *                                                                                                                                  *
 * FilterScript/GameMode Init Hook                                                                                                  *
 *                                                                                                                                  *
 ************************************************************************************************************************************/

new bool:CRC_Tryg3DInit = true,
	bool:CRC_Tryg3DExit = true;

#if defined Tryg3D_ColAndreas

	forward OnColAndreasRemoveBuilding();

	Tryg3D_Function:: bool:Tryg3D_IsColAndreasInit(){
		new Float:mapunit;
		CA_FindZ_For2DCoord(0.0,0.0,mapunit);
		return !(mapunit <= 0.0);
	}

	Tryg3D_Function:: Tryg3D_SafeColAndreasInit(){
		//check ColAndreas Init
		new bool:ColAndreasLastStat = false;
		if(!Tryg3D_IsColAndreasInit()){
			CallLocalFunction("OnColAndreasRemoveBuilding","");
			CA_Init();
			ColAndreasLastStat = true;
		}
		if(!Tryg3D_IsColAndreasInit()){
			if(GetSVarInt("ADM:Logging:Disable") == 0){
				print("[ADM] Error: ColAndreas failed to initiated.");
				print("[ADM] Error: Cannot load /scriptfiles/colandreas/ColAndreas.cadb");
				Update3DTrygErrorCount();
			}
		} else {
			if(ColAndreasLastStat){
				if(GetSVarInt("ADM:Logging:Disable") == 0){
					print("[ADM] Info: ColAndreas successfully init.");
				}
			}
		}
	}
	
	#define IsColAndreasInit							Tryg3D_IsColAndreasInit
	#define SafeColAndreasInit 							Tryg3D_SafeColAndreasInit
	
#endif

#if defined Tryg3D_MapAndreas

	Tryg3D_Function:: bool:Tryg3D_IsMapAndreasInit(){
		new Float:mapunit;
		MapAndreas_FindZ_For2DCoord(0.0,0.0,mapunit);
		return !(mapunit <= 0.0);
	}

	//Switch MapAndreas Version
	#if defined MAP_ANDREAS_ERROR_SUCCESS
		//MapAndreas 1.2.1
		Tryg3D_Function:: Tryg3D_SafeMapAndreasInit(mode = MAP_ANDREAS_MODE_FULL, name[]="", len=sizeof(name)){
			//check MapAndreas Init
			new bool:MapAndreasLastStat = false;
			if(!Tryg3D_IsMapAndreasInit()){
				MapAndreas_Init(mode,name,len);
				MapAndreasLastStat = true;
			}
			if(!Tryg3D_IsMapAndreasInit()){
				if(GetSVarInt("ADM:Logging:Disable") == 0){
					print("[ADM] Error: MapAndreas failed to initiated.");
					print("[ADM] Error: Cannot load /scriptfiles/SAfull.hmap");
					Update3DTrygErrorCount();
				}
			} else {
				if(MapAndreasLastStat){
					if(GetSVarInt("ADM:Logging:Disable") == 0){
						print("[ADM] Info: MapAndreas successfully init.");
					}
				}
			}
		}
	#else
		//MapAndreas 1.1.0
		Tryg3D_Function:: Tryg3D_SafeMapAndreasInit(mode){
			//check MapAndreas Init
			new bool:MapAndreasLastStat = false;
			if(!Tryg3D_IsMapAndreasInit()){
				MapAndreas_Init(mode);
				MapAndreasLastStat = true;
			}
			if(!Tryg3D_IsMapAndreasInit()){
				if(GetSVarInt("ADM:Logging:Disable") == 0){
					print("[ADM] Error: MapAndreas failed to initiated.");
					print("[ADM] Error: Cannot load /scriptfiles/SAfull.hmap");
					Update3DTrygErrorCount();
				}
			} else {
				if(MapAndreasLastStat){
					if(GetSVarInt("ADM:Logging:Disable") == 0){
						print("[ADM] Info: MapAndreas successfully init.");
					}
				}
			}
		}
	#endif
	
#endif

Tryg3D_Function:: Tryg3DInit_MapPrecision(){
	#if defined Tryg3D_ColAndreas
		Tryg3D_SafeColAndreasInit();
	#elseif defined Tryg3D_MapAndreas
		Tryg3D_SafeMapAndreasInit(MAP_ANDREAS_MODE_FULL);
	#else
		
	#endif
}

forward Tryg3D_OnRequestResponse(index, response_code, data[]);
public Tryg3D_OnRequestResponse(index, response_code, data[]){
	if(index == 0 && response_code == 200){
		if(isnull(data)) return 0;
		new T3D:version[16], T3D:ver, T3D:file_ver = Tryg3D_Version;
		strmid(T3D:version,data,0,strlen(data));
		T3D:ver = strval(T3D:version);
		if(T3D:ver != T3D:file_ver){
			print(" ");
			printf("[ADM] Info: Please update your 3DTryg include to v%d.%d.%d from here:",(T3D:ver / 10000),((T3D:ver % 10000) / 100),((T3D:ver % 10000) % 100));
			print("https://github.com/AbyssMorgan/SA-MP/blob/master/include/SAM/3DTryg.inc");
			print(" ");
		}
	}
	return 1;
}

Tryg3D_Function:: Tryg3DInit(){
	
	SetSVarInt("ADM:3DTryg:ACTIVE",Tryg3D_GetActiveCount()+1);
	
	//Welcome to 3DTryg
	new T3D:ver_name[16];
	format(T3D:ver_name,sizeof(T3D:ver_name),"%d.%d.%d",(Tryg3D_Version / 10000),((Tryg3D_Version % 10000) / 100),((Tryg3D_Version % 10000) % 100));
	if(GetSVarInt("ADM:3DTryg:INIT") == 0){
		SetSVarInt("ADM:3DTryg:INIT",1);
		if(GetSVarInt("ADM:Logging:Disable") == 0){
			printf("[ADM] Info: Load 3DTryg v%s for SA:MP %s by Abyss Morgan",T3D:ver_name,Tryg3D_SAMP_Version);
		}
	}
	
	if(GetSVarInt("ADM:3DTryg:ANNOUNCE") == 0){
		SetSVarInt("ADM:3DTryg:ANNOUNCE",1);
		//IP and PORT get
		new T3D:ServerIP[32];
		GetServerVarAsString("bind",T3D:ServerIP,sizeof(T3D:ServerIP));
		
		//Announce IP + PORT + Version + Modules (ignore localhost)
		if(!(!strcmp(T3D:ServerIP,"127.0.0.1",true) || !strcmp(T3D:ServerIP,"localhost",true) || isnull(T3D:ServerIP))){
			new T3D:port = GetServerVarAsInt("port"), T3D:send_data[512], T3D:modules_count;
			format(T3D:send_data,sizeof(T3D:send_data),"8.ct8.pl/tryg3d/announce.php?ip=%s&port=%d&version=%d&modules=%s&mcnt=%d",T3D:ServerIP,T3D:port,Tryg3D_Version,Tryg3D_GetModules(T3D:modules_count),T3D:modules_count);
			HTTP(0,HTTP_GET,T3D:send_data,"","Tryg3D_OnRequestResponse");
		}
	}
	
	//Init ColAndreas
	#if ((!defined DISABLE_3D_TRYG_CHECK) && (defined Tryg3D_ColAndreas) && (COLANDREAS_VERSION != 0))
		CheckColAndreasVersion();
	#endif
	
	//Init Map Precision
	#if !defined DISABLE_3D_TRYG_INIT
		Tryg3DInit_MapPrecision();
	#endif
	
	//Init YSF Timeline Sync
	#if ((defined Tryg3D_YSF) && (defined ENABLE_3D_TRYG_TIMELINE_SYNC))
		if(GetSVarInt("ADM:3DTryg:YSF:TIMELINE") == 0){
			SetSVarInt("ADM:3DTryg:YSF:TIMELINE",1);
			if(GetSVarInt("ADM:Logging:Disable") == 0){
				print("[ADM] Info: YSF Timeline Sync successfully init.");
			}
		}
	#endif
	
	//Init Streamer
	#if (!defined DISABLE_3D_TRYG_CHECK && defined Tryg3D_Streamer)
		Tryg3D_CheckStreamerVersion();
		if(GetSVarInt("ADM:3DTryg:Streamer") == 0){
			SetSVarInt("ADM:3DTryg:Streamer",1);
			if(GetSVarInt("ADM:Logging:Disable") == 0){
				if(T3D:Tryg3DStreamerExam){
					print("[ADM] Info: Streamer successfully init.");
				} else {
					print("[ADM] Error: Streamer failed to initiated.");
					Update3DTrygErrorCount();
				}
			}
		}
	#endif
	
	#if defined Tryg3D_Streamer
		#pragma unused v3DTryg3DStreamerExam
	#endif
	
	//Init FCNPC
	#if (!defined DISABLE_3D_TRYG_CHECK && defined Tryg3D_FCNPC)
		#if	(FCNPC_INCLUDE_VERSION < Tryg3D_FCNPCVersion)
			if(GetSVarInt("ADM:Logging:Disable") == 0){
				new T3D:str1[16],T3D:str2[16];
				format(T3D:str1,sizeof(T3D:str1),"%d",FCNPC_INCLUDE_VERSION);
				format(T3D:str2,sizeof(T3D:str2),"%d",Tryg3D_FCNPCVersion);
				printf("[ADM] Error: Your FCNPC %c.%c.%c It is not compatible with this version 3DTryg, update your FCNPC to %c.%c.%c",T3D:str1[0],T3D:str1[1],T3D:str1[2],T3D:str2[0],T3D:str2[1],T3D:str2[2]);
				Update3DTrygErrorCount();
			}
		#else
			if(GetSVarInt("ADM:3DTryg:FCNPC") == 0){
				SetSVarInt("ADM:3DTryg:FCNPC",1);
				print("[ADM] Info: FCNPC successfully init.");
			}
		#endif
	#endif
	
	#if ((defined Tryg3D_MapAndreas) && (defined Tryg3D_FCNPC))
		new T3D:MapAddress = MapAndreas_GetAddress();
		if(T3D:MapAddress != 0){
			FCNPC_InitMapAndreas(T3D:MapAddress);
			if(GetSVarInt("ADM:Logging:Disable") == 0){
				print("[ADM] Info: MapAndreas successfully attached to FCNPC.");
			}
		}
	#endif
}

Tryg3D_Function:: Tryg3DExit(){
	SetSVarInt("ADM:3DTryg:ACTIVE",Tryg3D_GetActiveCount()-1);
	
	//Goodbye 3DTryg
	new T3D:ver_name[16];
	format(T3D:ver_name,sizeof(T3D:ver_name),"%d.%d.%d",(Tryg3D_Version / 10000),((Tryg3D_Version % 10000) / 100),((Tryg3D_Version % 10000) % 100));
	if(Tryg3D_GetActiveCount() == 0){
		SetSVarInt("ADM:3DTryg:INIT",0);
		if(GetSVarInt("ADM:Logging:Disable") == 0){
			printf("[ADM] Info: Unload 3DTryg v%s for SA:MP %s by Abyss Morgan",T3D:ver_name,Tryg3D_SAMP_Version);
		}
	}
}

//Hook: OnFilterScriptInit
public OnFilterScriptInit(){
	if(CRC_Tryg3DInit){
		CRC_Tryg3DInit = false;
		Tryg3DInit();
	}
	#if defined Tryg3D_OnFilterScriptInit
		Tryg3D_OnFilterScriptInit();
	#endif
	return 1;
}

#if defined _ALS_OnFilterScriptInit
	#undef OnFilterScriptInit
#else
	#define _ALS_OnFilterScriptInit
#endif
#define OnFilterScriptInit Tryg3D_OnFilterScriptInit
#if defined Tryg3D_OnFilterScriptInit
	forward Tryg3D_OnFilterScriptInit();
#endif

//Hook: OnGameModeInit
public OnGameModeInit(){
	if(CRC_Tryg3DInit){
		CRC_Tryg3DInit = false;
		Tryg3DInit();
	}
	#if defined Tryg3D_OnGameModeInit
		Tryg3D_OnGameModeInit();
	#endif
	return 1;
}

#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit Tryg3D_OnGameModeInit
#if defined Tryg3D_OnGameModeInit
	forward Tryg3D_OnGameModeInit();
#endif

//Hook: OnFilterScriptExit
public OnFilterScriptExit(){
	if(CRC_Tryg3DExit){
		CRC_Tryg3DExit = false;
		Tryg3DExit();
	}
	#if defined Tryg3D_OnFilterScriptExit
		Tryg3D_OnFilterScriptExit();
	#endif
	return 1;
}

#if defined _ALS_OnFilterScriptExit
	#undef OnFilterScriptExit
#else
	#define _ALS_OnFilterScriptExit
#endif
#define OnFilterScriptExit Tryg3D_OnFilterScriptExit
#if defined Tryg3D_OnFilterScriptExit
	forward Tryg3D_OnFilterScriptExit();
#endif

//Hook: OnGameModeExit
public OnGameModeExit(){
	if(CRC_Tryg3DExit){
		CRC_Tryg3DExit = false;
		Tryg3DExit();
	}
	#if defined Tryg3D_OnGameModeExit
		Tryg3D_OnGameModeExit();
	#endif
	return 1;
}

#if defined _ALS_OnGameModeExit
	#undef OnGameModeExit
#else
	#define _ALS_OnGameModeExit
#endif
#define OnGameModeExit Tryg3D_OnGameModeExit
#if defined Tryg3D_OnGameModeExit
	forward Tryg3D_OnGameModeExit();
#endif

/************************************************************************************************************************************
 *                                                                                                                                  *
 * Additional operations                                                                                                            *
 *                                                                                                                                  *
 ************************************************************************************************************************************/

#pragma unused Tryg3D_WeaponDamage
#pragma unused Tryg3D_StreamDistance

#undef Update3DTrygErrorCount

//EOF