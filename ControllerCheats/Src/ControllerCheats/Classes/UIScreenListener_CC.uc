class UIScreenListener_CC extends UIScreenListener config(ControllerCheats);

struct CheatCode{
	var string Command;
	var string Cheat;
};

var config array<CheatCode> CheatCodes;
var array<int> CheatSequence;
var PlayerController PC;
var bool L2Held;
var bool R2Held;

var bool CheatMode;

event OnInit(UIScreen Screen){
	CheatSequence.Length = default.CheatCodes.Length;
	Clear();
	PC = Screen.PC;
	CheatMode = false;
	L2Held = false;
	R2Held = false;
	`SCREENSTACK.SubscribeToOnInput(OnUnrealCommand);
}

event OnRemoved(UIScreen screen)
{
	`SCREENSTACK.UnsubscribeFromOnInput(OnUnrealCommand);
	CheatMode = false;
	L2Held = false;
	R2Held = false;
}

event OnReceiveFocus(UIScreen screen)
{
	`SCREENSTACK.SubscribeToOnInput(OnUnrealCommand);
}

event OnLoseFocus(UIScreen screen)
{
	`SCREENSTACK.UnsubscribeFromOnInput(OnUnrealCommand);
	CheatMode = false;
	L2Held = false;
	R2Held = false;
}

function Clear(){
	local int i;
	for(i=0;i< CheatSequence.Length;i++){
		CheatSequence[i] = 0;
	}
}


function bool OnUnrealCommand(int cmd, int arg)
{
	local string in;
	local int i;
	local string s;
	
	
	if(!CheatMode){
		if(arg == class'UIUtilities_Input'.const.FXS_ACTION_Release){
			if(cmd == class'UIUtilities_Input'.const.FXS_BUTTON_RTRIGGER){
				R2Held=false;
			}
			else if(cmd == class'UIUtilities_Input'.const.FXS_BUTTON_LTRIGGER){
				L2Held=false;
			}

		}
		else if(arg == class'UIUtilities_Input'.const.FXS_ACTION_HOLD){
			if(cmd == class'UIUtilities_Input'.const.FXS_BUTTON_RTRIGGER){
				R2Held=true;
			}
			else if(cmd == class'UIUtilities_Input'.const.FXS_BUTTON_LTRIGGER){
				L2Held=true;
			}

			if(L2Held && R2Held){
				CheatMode=true;
				L2Held=false;
				R2Held=false;
			}
		}

		return false;
	}

	if(arg != class'UIUtilities_Input'.const.FXS_ACTION_PRESS){
		return true;
	}

	switch(cmd){
		case class'UIUtilities_Input'.const.FXS_BUTTON_R3:
			CheatMode = false;
			return true;	
		case class'UIUtilities_Input'.const.FXS_BUTTON_A:
			in = "A";
			break;
		case class'UIUtilities_Input'.const.FXS_BUTTON_B:
			in = "B";
			break;
		case class'UIUtilities_Input'.const.FXS_BUTTON_X:
			in = "X";
			break;
		case class'UIUtilities_Input'.const.FXS_BUTTON_Y:
			in = "Y";
			break;
		case class'UIUtilities_Input'.const.FXS_BUTTON_START:
			in = "S";
			break;
		case class'UIUtilities_Input'.const.FXS_DPAD_UP:
			in = "U";
			break;
		case class'UIUtilities_Input'.const.FXS_DPAD_DOWN:
			in = "D";
			break;
		case class'UIUtilities_Input'.const.FXS_DPAD_LEFT:
			in = "L";
			break;
		case class'UIUtilities_Input'.const.FXS_DPAD_RIGHT:
			in = "R";
			break;
		default:
			break;
	}

	for(i = 0; i < CheatSequence.Length; i++){
		s = Mid(default.CheatCodes[i].Command, CheatSequence[i], 1);
		`Log(s);
		if(s == in){
			CheatSequence[i]++;
			if(len(default.CheatCodes[i].Command) == CheatSequence[i]){
				`LOG("Executing:" @default.CheatCodes[i].Cheat);
				PC.ConsoleCommand(default.CheatCodes[i].Cheat);
				CheatMode = false;
				Clear();
			}
		} else {
			CheatSequence[i] = 0;
		}
	}

	return true;
}

defaultproperties
{
	ScreenClass = none;
}