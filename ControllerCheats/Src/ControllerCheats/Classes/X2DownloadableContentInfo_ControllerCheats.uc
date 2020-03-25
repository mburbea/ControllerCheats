//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_ControllerCheats.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_ControllerCheats extends X2DownloadableContentInfo;

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{
}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{
}

static event OnPostTemplatesCreated()
{
	UIScreenListener_CC(class'XComEngine'.static.GetClassDefaultObject(class'UIScreenListener_CC'))
		.ScreenClass=class<UIScreen>(GetRealizedClass(class'UITacticalHUD'));
}


static function class GetRealizedClass(Class TestClass)
{
	local class OverrideClass;

	OverrideClass = class'Engine'.static.GetEngine().GetModReplacementClass(TestClass);
	return OverrideClass != none ? OverrideClass : TestClass;
}