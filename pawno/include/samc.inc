/* =============================== */
/*   stuntman's Anti-Money Cheat  */
/* =============================== */

stock sGetPlayerMoney( playerid ) return GetPVarInt( playerid, "sMoney" ); //Anti-cheat - Get Player Moneys

stock sGivePlayerMoney( playerid, sMoneyV ) //Anti-cheat - Give Player Moneys
{
	SetPVarInt( playerid, "sMoney", GetPVarInt( playerid, "sMoney" ) + sMoneyV );
	return GivePlayerMoney( playerid, sMoneyV );
}

stock sResetPlayerMoney( playerid ) //Anti-cheat - Reset Player Moneys
{
	SetPVarInt( playerid, "sMoney", 0 );
	return ResetPlayerMoney( playerid );
}

//=================[ Check moneys ]===================

public OnPlayerUpdate( playerid )
{
    if( GetPlayerMoney( playerid ) != GetPVarInt( playerid, "sMoney" ) )
	{
		ResetPlayerMoney( playerid );
		GivePlayerMoney( playerid, GetPVarInt( playerid, "sMoney" ) );
	}
    return CallLocalFunction( "samc_OnPlayerUpdate", "i", playerid );
}
#if defined _ALS_OnPlayerUpdate
    #undef OnPlayerUpdate
#else
    #define _ALS_OnPlayerUpdate
#endif
#define OnPlayerUpdate samc_OnPlayerUpdate
forward samc_OnPlayerUpdate( playerid );

//====================================================

#define GetPlayerMoney sGetPlayerMoney
#define GivePlayerMoney sGivePlayerMoney
#define ResetPlayerMoney sResetPlayerMoney