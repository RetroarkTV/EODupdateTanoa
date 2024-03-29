call TFT_fnc_prepPhaseInit; // Preparation phase init


nopop = true; // Keeps targets from poping up on their own after hit

// Destroy bushes on firing range
["bushDestroyer1",10] call TFT_fnc_mapDestroyer;
["bushDestroyer2",10] call TFT_fnc_mapDestroyer;
["bushDestroyer3",25] call TFT_fnc_mapDestroyer;

// Get rid of handrails on edge of bridge
["guardRails",10] call TFT_fnc_mapDestroyer;

// hide helipad on main base in field
["baseHelipad",5] call TFT_fnc_mapDestroyer;


// add line of sight ACE Actions
_statement = {
	[] call tft_fnc_toggleDoor
};
_action = ["ToggleDoor","Toggle Door","",_statement,{true}] call ace_interact_menu_fnc_createAction;
[["ACE_ZeusActions"], _action] call ace_interact_menu_fnc_addActionToZeus;

_statement = {
	[] call tft_fnc_toggleLight
};
_action = ["ToggleLight","Toggle Light","",_statement,{true}] call ace_interact_menu_fnc_createAction;
[["ACE_ZeusActions"], _action] call ace_interact_menu_fnc_addActionToZeus;

if isServer then {
    // Add Zeus to logged in admin
	tft_zeus addCuratorEditableObjects [allUnits + vehicles, true];
	if (!hasInterface) then {
		tft_zeus setVariable ["Owner", "#adminLogged", true];
		call compile preprocessFileLineNumbers "tft_init.sqf";
	} else {
		//Editor play in Multiplayer
		player assignCurator tft_zeus;
	};
	[tft_zeus, ["CuratorObjectPlaced", {_this call tft_fnc_zeusSpawnAir}]] remoteExec ["addEventHandler", 0, true];
    
    // Create Tempor Bridge
    private ["_bridge", "_rail"];
    private _offset = -20.1;

    for "_i" from 0 to 40 do{
        _bridge = createSimpleObject ["Land_AirstripPlatform_01_F",[0,0,0]];
        _bridge attachTo [pier1,[_offset,0,0]];
        _offset = _offset - 20.1;
        detach _bridge;
    };

    _offset = 8;
    for "_i" from 0 to 103 do{
        _rail = createSimpleObject ["Land_CrashBarrier_01_8m_F",[0,0,0]];
        _rail attachTo [crashGuardL1,[_offset,0,0]];
        detach _rail;
        _offset = _offset + 8;
    };

    _offset = -8;
    for "_i" from 0 to 103 do{
        _rail = createSimpleObject ["Land_CrashBarrier_01_8m_F",[0,0,0]];
        _rail attachTo [crashGuardR1,[_offset,0,0]];
        detach _rail;
        _offset = _offset - 8;
    };
};

// fix for units losing their loadout when switching to Headless Client
["CAManBase", "Local", {
    params ["_entity", "_isLocal"];

    if (_isLocal) then {
		{
			if ((uniform _x) isEqualTo "") then {
				_x setUnitLoadout (typeOf _x);
			};
		} forEach units group _entity;
    };
}] call CBA_fnc_addClassEventHandler;

// Hide old pier around Tempor Bridge
{_x hideObject true} forEach (nearestTerrainObjects [[4227.9,11629.5,6.24811], [], 50]);

// Hide a few rocks
{_x hideObject true} forEach (nearestTerrainObjects [[3087.11,12700.1,0], [], 50]);

iedArray = [];
