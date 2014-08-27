["Ares_fnc_InitAresUi called..."] call Ares_fnc_DisplayMessage;

// Only worry about doing this if we're not a dedicated server. Dedicated servers don't get UI.
if(isServer && isDedicated) exitWith {};

[] spawn {
	// Wait for there to be A zeus unit.
	[] call Ares_fnc_waitForZeus;

	// Wait until THIS player is a zeus unit.
	while { !([player] call Ares_fnc_isZeus) } do
	{
		["Unit not zeus..."] call Ares_fnc_DisplayMessage;
		sleep 1;
	};
	
	["Initializing UI ..."] call Ares_fnc_DisplayMessage;
	
	["Ares"] spawn Ares_fnc_MonitorCuratorDisplay;
	//[] spawn Ares_fnc_SetupDisplayHandlers;

	["... Done initializing UI."] call Ares_fnc_DisplayMessage;
};