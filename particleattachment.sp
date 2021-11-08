// ====[ INCLUDES | DEFINES ]============================================================

#pragma semicolon 1

#include <sourcemod>
#include <tf2_stocks>
#include <sdktools>
#include <sdkhooks>
#include <scp>
#include <morecolors>

// ====[ HANDLES | CVARS | VARIABLES ]===================================================

	// Project Particles //
	new const String:Particles[][] = {

		"tf_projectile_arrow",
		"tf_projectile_healing_bolt",
		"tf_projectile_ball_ornament",
		"tf_projectile_energy_ball",	
		"tf_projectile_energy_ring",
		"tf_projectile_flare",
		"tf_projectile_jar",
		"tf_projectile_jar_milk",
		"tf_projectile_pipe",
		"tf_projectile_rocket",
		"tf_projectile_sentryrocket",
		"tf_projectile_stun_ball"
	};
	// Project Particles //


// ====[ FOWARDS ]=====================================================================
public Plugin:myinfo =
{
	name = "Rated Awesome Donor Starter",
	author = "Unreal1",
	description = "Starter Donor Package",
	version = "3.1",
	url = ""
}

// ====[ FUNCTIONS ]=====================================================================


// Particles //
// Particles //
// Particles //
	public OnEntityCreated(entity, const String:classname[])
	{		
		for(new i = 0; i < sizeof(Particles); i++ ){

			if(StrEqual(classname, Particles[i])){ SDKHook(entity, SDKHook_Spawn, arrow); }
		}
	}
	public arrow(entity)
	{
		new client = GetEntPropEnt(entity, Prop_Data, "m_hOwnerEntity");
		
		if(client < 1){ return; }
		if(CheckCommandAccess(client, "command_immunity", ADMFLAG_CUSTOM4)){ effectarrow(entity); }

		SDKUnhook(entity, SDKHook_Spawn, arrow);
	}
	effectarrow(entity)
	{
		new Float:fOffset[3]={0.0, 0.0, -20.0};
		CreateParticle(entity, "rockettrail", true);
		CreateParticle(entity, "community_sparkle", true);
		CreateParticle(entity, "superrare_burning2", true);
		CreateParticle(entity, "unusual_storm_knives", true,"",fOffset);
		CreateParticle(entity, "teleporter_blue_charged_wisps", true,"",fOffset);
	}
// Particles //
// Particles //
// Particles //



// Colors //
// Colors //
// Colors //
	public Command_Light(client)
	{	
		new Handle:submenu = CreateMenu(MenuHandler_Light);
		SetMenuTitle(submenu, "Choose a Color \n---------------------");
		SetMenuExitBackButton(submenu, bool:true);
		
		AddMenuItem(submenu, "0", "Normal");
		AddMenuItem(submenu, "1", "Black");
		AddMenuItem(submenu, "2", "Red");
		AddMenuItem(submenu, "3", "Green");
		AddMenuItem(submenu, "4", "Blue");
		AddMenuItem(submenu, "5", "Yellow");
		AddMenuItem(submenu, "6", "Purple");
		AddMenuItem(submenu, "7", "Cyan");
		AddMenuItem(submenu, "8", "Orange");
		AddMenuItem(submenu, "9", "Olive");
		AddMenuItem(submenu, "10", "Indigo");
			
		DisplayMenu(submenu, client, 0);
	}
	public MenuHandler_Light(Handle:menu, MenuAction:action, client, param2)
	{
		if(action == MenuAction_End){ CloseHandle(menu); }
		else if (action == MenuAction_Cancel && param2 == MenuCancel_ExitBack){ FakeClientCommand(client, "sm_donor"); }
		else if(action == MenuAction_Select)
		{	
			if(param2 == 0){ SetEntityRenderColor(client, 255, 255, 255, 255); Command_Light(client); }
			else if(param2 == 1){ SetEntityRenderColor(client, 0, 0, 0, 255); Command_Light(client); }
			else if(param2 == 2){ SetEntityRenderColor(client, 255, 0, 0, 255); Command_Light(client); }
			else if(param2 == 3){ SetEntityRenderColor(client, 0, 255, 0, 255);	 Command_Light(client); }
			else if(param2 == 4){ SetEntityRenderColor(client, 0, 0, 255, 255); Command_Light(client); }
			else if(param2 == 5){ SetEntityRenderColor(client, 255, 255, 0, 255); Command_Light(client); }
			else if(param2 == 6){ SetEntityRenderColor(client, 255, 0, 255, 255); Command_Light(client); }
			else if(param2 == 7){ SetEntityRenderColor(client, 0, 255, 255, 255); Command_Light(client); }
			else if(param2 == 8){ SetEntityRenderColor(client, 255, 128, 0, 255); Command_Light(client); }
			else if(param2 == 9){ SetEntityRenderColor(client, 255, 0, 128, 255); Command_Light(client); }
			else if(param2 == 10){ SetEntityRenderColor(client, 75, 0, 130, 255); Command_Light(client); }
		}	
	}
// Colors //
// Colors //
// Colors //


// ====[ STOCKS ]=====================================================================

stock CreateParticle(iEntity, String:strParticle[], bool:bAttach = false, String:strAttachmentPoint[]="", Float:fOffset[3]={0.0, 0.0, 0.0})
	{
	    new iParticle = CreateEntityByName("info_particle_system");
	    if (IsValidEdict(iParticle))
	    {
	        decl Float:fPosition[3];
	        decl Float:fAngles[3];
	        decl Float:fForward[3];
	        decl Float:fRight[3];
	        decl Float:fUp[3];
	        
	        // Retrieve entity's position and angles
	        //GetClientAbsOrigin(iClient, fPosition);
	        //GetClientAbsAngles(iClient, fAngles);
	        GetEntPropVector(iEntity, Prop_Send, "m_vecOrigin", fPosition);
			
	        // Determine vectors and apply offset
	        GetAngleVectors(fAngles, fForward, fRight, fUp);    // I assume 'x' is Right, 'y' is Forward and 'z' is Up
	        fPosition[0] += fRight[0]*fOffset[0] + fForward[0]*fOffset[1] + fUp[0]*fOffset[2];
	        fPosition[1] += fRight[1]*fOffset[0] + fForward[1]*fOffset[1] + fUp[1]*fOffset[2];
	        fPosition[2] += fRight[2]*fOffset[0] + fForward[2]*fOffset[1] + fUp[2]*fOffset[2];
	        
	        // Teleport and attach to client
	        //TeleportEntity(iParticle, fPosition, fAngles, NULL_VECTOR);
	        TeleportEntity(iParticle, fPosition, NULL_VECTOR, NULL_VECTOR);
	        DispatchKeyValue(iParticle, "effect_name", strParticle);

	        if (bAttach == true)
	        {
	            SetVariantString("!activator");
	            AcceptEntityInput(iParticle, "SetParent", iEntity, iParticle, 0);            
	            
	            if (StrEqual(strAttachmentPoint, "") == false)
	            {
	                SetVariantString(strAttachmentPoint);
	                AcceptEntityInput(iParticle, "SetParentAttachmentMaintainOffset", iParticle, iParticle, 0);                
	            }
	        }

	        // Spawn and start
	        DispatchSpawn(iParticle);
	        ActivateEntity(iParticle);
	        AcceptEntityInput(iParticle, "Start");
	    }

	    return iParticle;
	}