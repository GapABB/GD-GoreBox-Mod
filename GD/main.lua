Maxwell = nil
ASmusic = nil
ASvfx = nil
DS = nil
RB = nil
ModelPath = "models/cude.fbx"
TextureBodyPath = "images/h.png"
TextureYsiPath = "images/h.png"
ClipMeow1Path = "audio/1.mp3"
ClipMeow2Path = "audio/2.mp3"
ClipMusicPath = "audio/music.mp3"
ClipAngryPath = "audio/3.mp3"
CurrentScene = EnvironmentMaster.GetCurrentScene() 
Icon = nil

function OnSceneLoaded(scene)
    CurrentScene = scene
    if CurrentScene ~= "sys_Menu" then
        Initialize()
    end
end

function Start()
    Icon = Importer.ImportTexture("icon.jpg")
    Importer.ImportModel(ModelPath, "fbx", true)
    if CurrentScene ~= "sys_Menu" then
        Initialize()
    end
end

function Initialize()
    Player.GetLocal().ShowSubtitles("Присоединяйся ;)  @EasyMods1gorebox", Vector3:New(0,1,0), 5)
    local GM = GameObject.FindAllByComponent("GameMaster")[1]
    local ToolGunModesTab = GM.Transform.Find("GameCanvas-3/PanelManager/MenuPanel/PanelHolder/NPC/Fun/Scroll View/Viewport/Content")
    Debug.Log(ToolGunModesTab == nil)
    local M = GameObject.Copy(ToolGunModesTab.GetChild(0).GameObject)
    M.Transform.LocalScale = Vector3.One
    local buttonM = M.GetComponent("UnityEngine.UI.Button")
    local event = buttonM.GetField("onClick")
    event.AddListener(Spawn)
    local IconM = M.Transform.Find("icon").GameObject
    local icoComp = IconM.GetComponent("UnityEngine.UI.Image")
    icoComp.SetField("sprite", Icon.ToSprite())
    local textM = M.Transform.Find("text").GameObject
    local txtCompM = textM.GetComponent("TMPro.TMP_Text")
    txtCompM.SetField("text", "Maxwell")
end

Spawn = function()
    if CurrentScene ~= "sys_Menu" then
        Importer.ImportModel(ModelPath, "fbx", true)
        local tex = Importer.ImportTexture(TextureBodyPath)
        Maxwell = GameObject.FindByName("MaxModel")
        Maxwell.Name = "Cat"
        Cats = Maxwell
        local con = Maxwell.Transform.GetChild(0).GameObject
        local player = GameObject.FindAllByTag("Player")[1]
        con.Transform.Position = Vector3.New(player.Transform.Position.x, player.Transform.Position.y, player.Transform.Position.z)
        con.Transform.LocalScale = Vector3.New(180, 180, 180)
        con.Material = Material.Create()
        con.Material.mainTexture = tex
        con.Material.metallic = 0
        con.Material.smoothness = 0
        RB = con.AddComponent("Rigidbody")
        RB.SetField("mass", 5)
        -- DS = con.AddComponent("DamageSystem")
        -- DS.SetField("connectedRB", RB)
        -- DS.SetField("BoneObjects", con)
        -- DS.SetField("Bone", con)
        -- DS.SetField("BodyPart", con)
        -- DS.GetField("Health")
        -- DS.SetField("DestroyAble", true)
        local music1 = Importer.ImportAudioClip(ClipMusicPath)
        ASmusic = con.AddComponent("AudioSource")
        ASmusic.SetField("clip", music1)
        ASmusic.SetField("loop", true)
        ASmusic.SetField("volume", 1)
        ASmusic.SetField("volume", 1)
        ASmusic.SetField("maxDistance", 50)
        ASmusic.SetField("spatialBlend", 1)
        ASmusic.CallMethod("Play")
        ASvfx = Maxwell.AddComponent("AudioSource")
        ASvfx.SetField("clip", nil)
        ASvfx.SetField("loop", false)
        ASvfx.SetField("volume", 1)
        ASvfx.CallMethod("Play")
        local IO = con.AddComponent("InteractiveObject")
        IO.Active = true
        IO.SetField("InteractText", "*GD VS GB*")
        local Event = IO.GetField("OnInteract")
        Event.AddListener(OnIO)
    end
end


OnIO = function()
    local variables = {ClipMeow1Path, ClipMeow2Path}
    local r = variables[math.random(#variables)]
    local meow = Importer.ImportAudioClip(r)
    ASvfx.SetField("clip", meow)
    ASvfx.CallMethod("Play")
end
