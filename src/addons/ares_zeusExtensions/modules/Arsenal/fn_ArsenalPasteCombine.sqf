#include "\ares_zeusExtensions\module_header.hpp"

_ammoBox = [_logic] call Ares_fnc_GetUnitUnderCursor;
if (not isnull _ammoBox) then
{
	_parsedValue = [4] call Ares_fnc_GetArrayDataFromUser;
	if (typeName _parsedValue == typeName []) then
	{
		[_ammoBox, _parsedValue, false] call Ares_fnc_ArsenalSetup;
		[objNull, "Arsenal objects added."] call bis_fnc_showCuratorFeedbackMessage;
	}
	else
	{
		if (_parsedValue == "CANCELLED") then
		{
			// Do nothing. The paste was cancelled by the user.
		}
		else
		{
			[objNull, format ["%1. Was the data in the right format?", _parsedValue]] call bis_fnc_showCuratorFeedbackMessage;
		};
	};
};

deleteVehicle _logic;
true