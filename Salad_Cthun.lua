local dotPos = {
	[1] = {1, 98}, --melee        		-- 
	[2] = {-32, 131}, --healer    		-|
	[3] = {-20, 170}, --ranged    		-|Group 1 
	[4] = {22, 171}, --ranged     		-|
	[5] = {34, 132}, --healer/ranged    --
	[6] = {69, 71}, -- melee      		--
	[7] = {69, 118}, --healer     		-|
	[8] = {105, 137}, --ranged    		-|Group 2
	[9] = {134, 107}, --ranged    		-|
	[10] = {115, 70}, --healer/ranged   --
	[11] = {-66, 69}, -- melee    		--
	[12] = {-113, 69}, --healer   		-|
	[13] = {-132, 106}, --ranged  		-|Group 3
	[14] = {-66, 116}, --ranged   		-|
	[15] = {-103, 135}, --healer/ranged --
	[16] = {97, 4}, -- melee      		--
	[17] = {130, 37}, --healer    		-|
	[18] = {169, 24}, --ranged    		-|Group 4
	[19] = {170, -17}, --ranged   		-|
	[20] = {130, -30}, --healer/ranged  --
	[21] = {-93, 2}, -- melee     		--
	[22] = {-126, -31}, --healer  		-|
	[23] = {-166, -19}, --ranged  		-|Group 5
	[24] = {-166, 22}, --ranged   		-|
	[25] = {-127, 35}, --healer/ranged  --
	[26] = {70, -65}, -- melee    		--
	[27] = {117, -64}, --healer   		-|
	[28] = {135, -100}, --ranged  		-|Group 6
	[29] = {107, -129}, --ranged  		-|
	[30] = {70, -110}, --healer/ranged  --
	[31] = {-65, -65}, -- melee   		--
	[32] = {-65, -112}, --healer  		-|
	[33] = {-101, -131}, --ranged 		-|Group 7
	[34] = {-130, -102}, --ranged 		-|
	[35] = {-112, -66}, --healer/ranged --
	[36] = {3, -92}, -- melee     		--
	[37] = {36, -126}, --healer   		-|
	[38] = {23, -165}, --ranged   		-|Group 8
	[39] = {-18, -165}, --ranged  		-|
	[40] = {-30, -126} --healer/ranged  --
}

local frame = CreateFrame("Frame", "Cthun_room", UIParent)
frame:SetHeight(512)
frame:SetWidth(512)
frame:SetPoint("CENTER", 0, 0)
frame:SetAlpha(0.80)
frame:Hide()

local tex = frame:CreateTexture(nil, "BACKGROUND")
tex:SetAllPoints();
tex:SetTexture("Interface\\AddOns\\Salad_Cthun\\Images\\CThun_Positioning.tga");

local button = CreateFrame("Button", "Close_button", frame)
button:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
button:SetHeight(32)
button:SetWidth(32)
button:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
button:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
button:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
button:SetScript("OnLoad", 
	function()
		button:RegisterForClicks("AnyUp")
	end 
)
button:SetScript("OnClick", 
	function()
		frame:Hide();
	end
)

local num_dots = 0

function newDot(x, y, name, class)
	num_dots = num_dots + 1

	local dot = CreateFrame("Button", "Dot_"..num_dots, frame)

	dot:SetPoint("CENTER", frame, "CENTER", x, y)
	dot:EnableMouse(true)
	dot:SetWidth(16)
	dot:SetHeight(16)

	local texdot = dot:CreateTexture(nil, "OVERLAY")

	dot.texture = texdot
	texdot:SetAllPoints(dot)
	texdot:SetTexture("Interface\\AddOns\\Salad_Cthun\\Images\\playerdot_".. class ..".tga")

	dot:SetFrameLevel(dot:GetFrameLevel()+3)
	dot:RegisterEvent("RAID_ROSTER_UPDATE")
	dot:SetScript("OnEvent", 
		function()
			dot:Hide();
			frame:Hide();
		end
	)

	dot:SetScript("OnEnter",
		function()
			GameTooltip:SetOwner(dot, "ANCHOR_RIGHT")
			GameTooltip:SetText(name)
			GameTooltip:Show()
		end
	)
	dot:SetScript("OnLeave",
		function()
			GameTooltip:Hide()
		end
	)

	return dot
end

local dotRes = {{{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"}}, -- group 1
		  		{{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"}}, -- group 2
		  		{{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"}}, --    |
	  	  		{{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"}}, --    |
	  	  		{{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"}}, --    |
		  		{{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"}}, --    |
		  		{{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"}}, --    |
		  		{{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"},{"Empty","Empty"}}} -- group 8

function getRaidInfo()
	for i=1,40 do
		local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i);

		if (class == "Rogue" or class == "Warrior") then
			if dotRes[subgroup][1][1] == "Empty" or dotRes[subgroup][1][1] == name then
				dotRes[subgroup][1] = {name, class}
			elseif dotRes[subgroup][5][1] == "Empty" or dotRes[subgroup][5][1] == name then
				dotRes[subgroup][5] = {name, class}
			elseif dotRes[subgroup][2][1] == "Empty" or dotRes[subgroup][2][1] == name then
				dotRes[subgroup][2] = {name, class}
			elseif dotRes[subgroup][3][1] == "Empty" or dotRes[subgroup][3][1] == name then
				dotRes[subgroup][3] = {name, class}
			else
				dotRes[subgroup][4] = {name, class}
			end
		elseif (class == "Mage" or class == "Warlock" or class == "Hunter") then
			if dotRes[subgroup][3][1] == "Empty" or dotRes[subgroup][3][1] == name then
				dotRes[subgroup][3] = {name, class}
			elseif dotRes[subgroup][4][1] == "Empty" or dotRes[subgroup][4][1] == name then
				dotRes[subgroup][4] = {name, class}
			elseif dotRes[subgroup][5][1] == "Empty" or dotRes[subgroup][5][1] == name then
				dotRes[subgroup][5] = {name, class}
			elseif dotRes[subgroup][2][1] == "Empty" or dotRes[subgroup][2][1] == name then
				dotRes[subgroup][2] = {name, class}
			else 
				dotRes[subgroup][1] = {name, class}
			end
		elseif (class == "Priest" or class == "Paladin" or class == "Druid") then
			if dotRes[subgroup][2][1] == "Empty" or dotRes[subgroup][2][1] == name then
				dotRes[subgroup][2] = {name, class}
			elseif dotRes[subgroup][5][1] == "Empty" or dotRes[subgroup][5][1] == name then
				dotRes[subgroup][5] = {name, class}
			elseif dotRes[subgroup][3][1] == "Empty" or dotRes[subgroup][3][1] == name then
				dotRes[subgroup][3] = {name, class}
			elseif dotRes[subgroup][4][1] == "Empty" or dotRes[subgroup][4][1] == name then
				dotRes[subgroup][4] = {name, class}
			else
				dotRes[subgroup][1] = {name, class}
			end
		end
	end
end

function fillGrid()
	getRaidInfo()
	for i=1,8 do
		for j=1,5 do
			local x = ((i-1)*5)+j
			newDot(dotPos[x][1], dotPos[x][2], dotRes[i][j][1], dotRes[i][j][2])
		end
	end
end

SLASH_SALAD1 = "/salad";

local function HandleSlashCommands(str)
	if (str == "help" or str == "") then
		DEFAULT_CHAT_FRAME:AddMessage("Commands:", 1.0, 1.0, 0);
		DEFAULT_CHAT_FRAME:AddMessage("   salad |cff00d2d6help |r-- show this help menu", 1.0, 1.0, 0);
		DEFAULT_CHAT_FRAME:AddMessage("   salad |cff00d2d6show |r-- show c'thun positioning map", 1.0, 1.0, 0);
		DEFAULT_CHAT_FRAME:AddMessage("   salad |cff00d2d6hide |r-- hide c'thun positioning map", 1.0, 1.0, 0);
		DEFAULT_CHAT_FRAME:AddMessage("   salad |cff00d2d6fill |r-- show all players on map", 1.0, 1.0, 0);
	elseif (str == "show") then
		frame:Show();
	elseif (str == "hide") then
		frame:Hide();
	elseif (str == "fill") then
		frame:Show();
		fillGrid()
	else
		DEFAULT_CHAT_FRAME:AddMessage("Command not found", 1.0, 1.0, 0);
	end
end

SlashCmdList.SALAD = HandleSlashCommands;
