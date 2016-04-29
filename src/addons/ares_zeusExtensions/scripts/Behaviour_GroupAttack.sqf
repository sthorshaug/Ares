#define FIRST_SPECIFIC_GROUPATTACK_TARGET_INDEX 3
[
	"AI Behaviours",
	"Order attack",
	{
		private ["_groupUnderCursor", "_selectedTarget"];
		["BehaviourPatrol: Getting group under cursor"] call Ares_fnc_LogMessage;
		_groupUnderCursor = [_logic] call Ares_fnc_GetGroupUnderCursor;

		if (not isNull _groupUnderCursor) then
		{
			// Use artillery targets for now
			_allTargetsUnsorted = allMissionObjects "Ares_Module_Behaviour_Create_Artillery_Target";
			_allTargets = [_allTargetsUnsorted, [], { _x getVariable ["SortOrder", 0]; }, "ASCEND"] call BIS_fnc_sortBy;
			_targetChoices = ["Random", "Nearest", "Farthest"];
			{
				_targetChoices pushBack (name _x);
			} forEach _allTargets;

			_dialogResult = [
				"Select target",
				[
					["Choose Target", _targetChoices, 1]
				]] call Ares_fnc_ShowChooseDialog;
			if (count _dialogResult > 0) then
			{
				// Get the data that the dialog set.
				_targetChooseAlgorithm = _dialogResult select 0;
				// Choose a target to attack
				_selectedTarget = objNull;
				switch (_targetChooseAlgorithm) do
				{
					case 0: // Random
					{
						_selectedTarget = _allTargetsUnsorted call BIS_fnc_selectRandom;
					};
					case 1: // Nearest
					{
						_selectedTarget = [position _logic, _allTargetsUnsorted] call Ares_fnc_GetNearest;
					};
					case 2: // Furthest
					{
						_selectedTarget = [position _logic, _allTargetsUnsorted] call Ares_fnc_GetFarthest;
					};
					default // Specific target
					{
						_selectedTarget = _allTargets select (_targetChooseAlgorithm - FIRST_SPECIFIC_GROUPATTACK_TARGET_INDEX);
					};
				};
				if(isNil "Ares_orderGroupToAttackFunction") then {
					Ares_orderGroupToAttackFunction = {
						if(local (_this select 0)) then {
							[_this select 0, _this select 1] call BIS_fnc_taskAttack;
						};
					};
					publicVariable "Ares_orderGroupToAttackFunction";
				};
				if(local _groupUnderCursor) then {
					[_groupUnderCursor, (position _selectedTarget)] call BIS_fnc_taskAttack;
				} else {
					[[_groupUnderCursor, (position _selectedTarget)], "Ares_orderGroupToAttackFunction",false] call BIS_fnc_MP;
				};
				[objNull, format ["Group %1 will attack %2", _groupUnderCursor, name _selectedTarget]] call bis_fnc_showCuratorFeedbackMessage;
			};
		};
	}
] call Ares_fnc_RegisterCustomModule;
