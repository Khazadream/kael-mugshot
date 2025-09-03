local QBCore = exports[Config.Core]:GetCoreObject()

RegisterNetEvent("kael-mugshot:client:takemugshot", function(officer, boardData, isOfficerSide)
	local InProgress = true
	local PlayerPed = PlayerPedId()
    if isOfficerSide then
        PlayerPed = GetPlayerPed(GetPlayerFromServerId(boardData.targetid))
    end
	local SuspectCoods = GetEntityCoords(PlayerPed)
	local PlayerData = QBCore.Functions.GetPlayerData()
	-- local CitizenId = PlayerData.citizenid
	-- local Name = PlayerData.charinfo.firstname.. " ".. PlayerData.charinfo.lastname
	-- local DOB = PlayerData.charinfo.birthdate    
    local CitizenId = boardData.citizenid
    local Name = boardData.fullname
    local DOB = boardData.birthdate
    local ScaleformBoard = LoadScale("mugshot_board_01")
    local RenderHandle = CreateRenderModel("ID_Text", "prop_police_id_text")
	CreateThread(function()
        while RenderHandle do
            HideHudAndRadarThisFrame()
            SetTextRenderId(RenderHandle)
            Set_2dLayer(4)
            SetScriptGfxDrawBehindPausemenu(1)
            DrawScaleformMovie(ScaleformBoard, 0.405, 0.37, 0.81, 0.74, 255, 255, 255, 255, 0)
            SetScriptGfxDrawBehindPausemenu(0)
            SetTextRenderId(GetDefaultScriptRendertargetRenderId())
            SetScriptGfxDrawBehindPausemenu(1)
            SetScriptGfxDrawBehindPausemenu(0)
            Wait(0)
        end
    end)
	Wait(250)
	BeginScaleformMovieMethod(ScaleformBoard, 'SET_BOARD')
    PushScaleformMovieMethodParameterString(Config.BoardHeader)
    PushScaleformMovieMethodParameterString(Name)
    PushScaleformMovieMethodParameterString(CitizenId)
    PushScaleformMovieMethodParameterString(DOB)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(boardData.playerLevelCircle)
    PushScaleformMovieFunctionParameterInt(116)
    EndScaleformMovieMethod()
	-- local MugCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
	-- SetCamCoord(MugCam, Config.CameraPos.pos)
    -- SetCamRot(MugCam, Config.CameraPos.rotation, 2)
    -- RenderScriptCams(1, 0, 0, 1, 1)
    Wait(250)
	CreateThread(function()
        FreezeEntityPosition(PlayerPed, true)
        SetPauseMenuActive(false)
        while InProgress do
            DisableAllControlActions(0)
            EnableControlAction(0, 249, true)
            EnableControlAction(0, 46, true)
            Wait(0)
        end
    end)
	SetEntityCoords(PlayerPed, Config.MugShotCoords)
	SetEntityHeading(PlayerPed, Config.MugShotHeading)
	LoadModel("prop_police_id_board")
	LoadModel("prop_police_id_text")
	local Board = CreateObject("prop_police_id_board", SuspectCoods, true, true, false)
	local BoardOverlay = CreateObject("prop_police_id_text", SuspectCoods, true, true, false)
	AttachEntityToEntity(BoardOverlay, Board, -1, 4103, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
	SetModelAsNoLongerNeeded("prop_police_id_board")
	SetModelAsNoLongerNeeded("prop_police_id_text")
    SetCurrentPedWeapon(PlayerPed, "weapon_unarmed", 1)
	ClearPedWetness(PlayerPed)
	ClearPedBloodDamage(PlayerPed)
	AttachEntityToEntity(Board, PlayerPed, GetPedBoneIndex(PlayerPed, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 2, 1)	
    if not isOfficerSide then
        LoadAnimDict("mp_character_creation@lineup@male_a")
        TaskPlayAnim(PlayerPed, "mp_character_creation@lineup@male_a", "loop_raised", 8.0, 8.0, -1, 49, 0, false, false, false)
    end
    Wait(1000)
	-- QBCore.Functions.TriggerCallback('kael-mugshot:server:GetWebhook', function(Hook)
    --     if Hook then
    --         exports['screenshot-basic']:requestScreenshotUpload(tostring(Hook), 'files[]', {encoding = 'jpg'}, function(data)
    --             local Response = json.decode(data)
    --             local imageURL = Response.attachments[1].url
	-- 			TriggerServerEvent('kael-mugshot:server:MugLog', officer, imageURL)
    --         end)
    --     end
    -- end)
    Wait(8000)
    --Wait(5000)
	-- DestroyCam(MugCam, 0)
    -- RenderScriptCams(0, 0, 1, 1, 1)
    if not isOfficerSide then
        SetFocusEntity(PlayerPed)
        ClearPedTasksImmediately(PlayerPed)
        FreezeEntityPosition(PlayerPed, false)
    end
    DeleteObject(Board)
    DeleteObject(BoardOverlay)
    RenderHandle = nil
	InProgress = false
end)

function LoadModel(model)
    RequestModel(GetHashKey(model))
    while not HasModelLoaded(GetHashKey(model)) do
        Wait(0)
    end
end

function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(0)
    end
end

function LoadScale(scalef)
	local handle = RequestScaleformMovie(scalef)
    while not HasScaleformMovieLoaded(handle) do
        Wait(0)
    end
	return handle
end

function CreateRenderModel(name, model)
	local handle = 0
	if not IsNamedRendertargetRegistered(name) then
		RegisterNamedRendertarget(name, 0)
	end
	if not IsNamedRendertargetLinked(model) then
		LinkNamedRendertarget(model)
	end
	if IsNamedRendertargetRegistered(name) then
		handle = GetNamedRendertargetRenderId(name)
	end
	return handle
end
