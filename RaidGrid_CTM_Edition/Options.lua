RaidGrid_CTM_Edition = RaidGrid_CTM_Edition or {}
RaidGrid_CTM_Edition.tOptions = {}

RaidGrid_CTM_Edition.bAltNeededForDrag = true;						RegisterCustomData("RaidGrid_CTM_Edition.bAltNeededForDrag")
RaidGrid_CTM_Edition.bRaidEnable = true;							RegisterCustomData("RaidGrid_CTM_Edition.bRaidEnable")
RaidGrid_CTM_Edition.bShowRaid = true;								RegisterCustomData("RaidGrid_CTM_Edition.bShowRaid")
RaidGrid_CTM_Edition.bShowInRaid = false;							RegisterCustomData("RaidGrid_CTM_Edition.bShowInRaid")
RaidGrid_CTM_Edition.bAutoHideCTM = true;							--RegisterCustomData("RaidGrid_CTM_Edition.bAutoHideCTM")
RaidGrid_CTM_Edition.bShowSystemRaidPanel = false;					RegisterCustomData("RaidGrid_CTM_Edition.bShowSystemRaidPanel")
RaidGrid_CTM_Edition.bShowSystemTeamPanel = false;					RegisterCustomData("RaidGrid_CTM_Edition.bShowSystemTeamPanel")
RaidGrid_CTM_Edition.bAutoLinkAllPanel = true;						--RegisterCustomData("RaidGrid_CTM_Edition.bAutoLinkAllPanel")
RaidGrid_CTM_Edition.nAutoLinkMode = 5;								RegisterCustomData("RaidGrid_CTM_Edition.nAutoLinkMode")
RaidGrid_CTM_Edition.bShowAllPanel = false;							RegisterCustomData("RaidGrid_CTM_Edition.bShowAllPanel")
RaidGrid_CTM_Edition.bShowAllMemberGrid = false;					RegisterCustomData("RaidGrid_CTM_Edition.bShowAllMemberGrid")
RaidGrid_CTM_Edition.nHPShownMode2 = 2;								RegisterCustomData("RaidGrid_CTM_Edition.nHPShownMode2")
RaidGrid_CTM_Edition.nHPShownNumMode = 1;							RegisterCustomData("RaidGrid_CTM_Edition.nHPShownNumMode")
RaidGrid_CTM_Edition.nShowMP = false;								RegisterCustomData("RaidGrid_CTM_Edition.nShowMP")
RaidGrid_CTM_Edition.bLowMPBar = true;								RegisterCustomData("RaidGrid_CTM_Edition.bLowMPBar")
RaidGrid_CTM_Edition.bHPHitAlert = true;							RegisterCustomData("RaidGrid_CTM_Edition.bHPHitAlert")
RaidGrid_CTM_Edition.bColoredName = true;							RegisterCustomData("RaidGrid_CTM_Edition.bColoredName")
RaidGrid_CTM_Edition.bColoredGrid = false;							RegisterCustomData("RaidGrid_CTM_Edition.bColoredGrid")
RaidGrid_CTM_Edition.bShowIcon = 2;									RegisterCustomData("RaidGrid_CTM_Edition.bShowIcon")
RaidGrid_CTM_Edition.bShowDistance = false;							RegisterCustomData("RaidGrid_CTM_Edition.bShowDistance")
RaidGrid_CTM_Edition.bColorHPBarWithDistance = true;				RegisterCustomData("RaidGrid_CTM_Edition.bColorHPBarWithDistance")

RaidGrid_CTM_Edition.bShowTargetTargetAni = true;					RegisterCustomData("RaidGrid_CTM_Edition.bShowTargetTargetAni")

local function IsLeader()
	local hTeam = GetClientTeam()
	local hPlayer = GetClientPlayer()
	return hTeam.GetAuthorityInfo(TEAM_AUTHORITY_TYPE.LEADER) == hPlayer.dwID
end

function RaidGrid_CTM_Edition.RaidPanel_Switch(bOpen)
	local frame = Station.Lookup("Normal/RaidPanel_Main")
	if frame then
		if bOpen then
			frame:Show()
		else
			frame:Hide()
		end
	end
end

function RaidGrid_CTM_Edition.TeammatePanel_Switch(bOpen)
	local hFrame = Station.Lookup("Normal/Teammate")
	if hFrame then
		if bOpen then
			hFrame:Show()
		else
			hFrame:Hide()
		end
	end	
end

function RaidGrid_CTM_Edition.PopOptions()
	local me = GetClientPlayer()
	local team = GetClientTeam()
	local dwDistribute = team.GetAuthorityInfo(TEAM_AUTHORITY_TYPE.DISTRIBUTE)
	local menu = {}
	-- 团队就位
	table.insert(menu, { szOption = g_tStrings.STR_RAID_MENU_READY_CONFIRM, 
		{ szOption = g_tStrings.STR_RAID_READY_CONFIRM_START, bDisable = not IsLeader(), fnAction = RaidGrid_Party.InitReadyCheckCover },
		{ szOption = g_tStrings.STR_RAID_READY_CONFIRM_RESET, bDisable = not IsLeader(), fnAction = RaidGrid_Party.ClearReadyCheckCover }
	})
	table.insert(menu, { bDevide = true })
	-- 分配
	InsertDistributeMenu(menu, me.dwID ~= dwDistribute)
	table.insert(menu, { bDevide = true })
	-- 编辑模式
	table.insert(menu, { szOption = string.gsub(g_tStrings.STR_RAID_MENU_RAID_EDIT, "Ctrl", "Alt"), bDisable = not IsLeader(), bCheck = true, bChecked = not RaidGrid_CTM_Edition.bAltNeededForDrag, fnAction = function() 
		RaidGrid_CTM_Edition.bAltNeededForDrag = not RaidGrid_CTM_Edition.bAltNeededForDrag
		GetPopupMenu():Hide()
	end })
	-- 治疗模式
	table.insert(menu, { szOption = g_tStrings.STR_RAID_TARGET_ASSIST, bCheck = true, bChecked = RaidGrid_Party.bTempTargetEnable, fnAction = function() RaidGrid_Party.bTempTargetEnable = not RaidGrid_Party.bTempTargetEnable end,
		{ szOption = "战斗中不显示TIP信息", bCheck = true, bChecked = RaidGrid_Party.bTempTargetFightTip, fnDisable = function() return not RaidGrid_Party.bTempTargetEnable end, fnAction = function()
			RaidGrid_Party.bTempTargetFightTip = not RaidGrid_Party.bTempTargetFightTip
		end	}
	})
	table.insert(menu, { bDevide = true })
	-- 提醒窗体
	table.insert(menu, { szOption = g_tStrings.STR_RAID_TIP_IMAGE,
		{ szOption = g_tStrings.STR_RAID_TIP_TARGET, bCheck = true, bChecked = RaidGrid_CTM_Edition.bShowTargetTargetAni, fnAction = function()
			RaidGrid_CTM_Edition.bShowTargetTargetAni = not RaidGrid_CTM_Edition.bShowTargetTargetAn
			RaidGrid_Party.RedrawTargetSelectImage(true)
		end },
		{ szOption = "显示距离", bCheck = true, bChecked = RaidGrid_CTM_Edition.bShowDistance, fnAction = function()
			RaidGrid_CTM_Edition.bShowDistance = not RaidGrid_CTM_Edition.bShowDistance
			RaidGrid_Party.ReloadRaidPanel()
		end },
		{ szOption = "被攻击队友提示（治疗神器）", bCheck = true, bChecked = RaidGrid_CTM_Edition.bHPHitAlert, fnAction = function()
			RaidGrid_CTM_Edition.bHPHitAlert = not RaidGrid_CTM_Edition.bHPHitAlert
			RaidGrid_Party.RedrawAllFadeHP(true)
		end }
	})
	
	table.insert(menu, { bDevide = true })
	table.insert(menu, { szOption = "血条设置",
		{ szOption = "血条渐变色", bCheck = true, bChecked = not RaidGrid_Party.Shadow.bLife, fnAction = function()
			RaidGrid_Party.Shadow.bLife = not RaidGrid_Party.Shadow.bLife
		end	},
		{ szOption = "蓝条渐变色", bCheck = true, bChecked = not RaidGrid_Party.Shadow.bMana, fnAction = function()
			RaidGrid_Party.Shadow.bMana = not RaidGrid_Party.Shadow.bMana
		end	},
		{ szOption = "更细的蓝条", bCheck = true, bChecked = RaidGrid_CTM_Edition.bLowMPBar, fnAction = function()
			RaidGrid_CTM_Edition.bLowMPBar = not RaidGrid_CTM_Edition.bLowMPBar
		end	},
		{ szOption = "透明度设置", fnAction = function()
			local x, y = Cursor.GetPos()
			GetUserPercentage(function(val)
				RaidGrid_Party.Shadow.a = tonumber(val) * 255
				Station.Lookup("Normal/GetPercentagePanel"):BringToTop()
			end, nil, RaidGrid_Party.Shadow.a / 255, g_tStrings.STR_ALPHA .. g_tStrings.STR_COLON, { x, y, x + 1, y + 1 })
		end	},
		{ bDevide = true },
		{ szOption = "显示内力", bCheck = true, bChecked = RaidGrid_CTM_Edition.nShowMP, fnAction = function()
			RaidGrid_CTM_Edition.nShowMP = not RaidGrid_CTM_Edition.nShowMP
			RaidGrid_Party.ReloadRaidPanel()
		end	},
		{ bDevide = true },
		{ szOption = g_tStrings.STR_RAID_LIFE_LEFT, bMCheck = true, bChecked = RaidGrid_CTM_Edition.nHPShownMode2 == 2, fnAction = function()
			RaidGrid_CTM_Edition.nHPShownMode2 = 2
			RaidGrid_Party.ReloadRaidPanel()
		end	},
		{ szOption = g_tStrings.STR_RAID_LIFE_LOSE, bMCheck = true, bChecked = RaidGrid_CTM_Edition.nHPShownMode2 == 1, fnAction = function()
			RaidGrid_CTM_Edition.nHPShownMode2 = 1
			RaidGrid_Party.ReloadRaidPanel()
		end	},
		{ bDevide = true },
		{ szOption = "显示精简血量", bMCheck = true, bChecked = RaidGrid_CTM_Edition.nHPShownNumMode == 1, fnAction = function()
			RaidGrid_CTM_Edition.nHPShownNumMode = 1
			RaidGrid_Party.ReloadRaidPanel()
		end	},
		{ szOption = "显示百分比血量", bMCheck = true, bChecked = RaidGrid_CTM_Edition.nHPShownNumMode == 2, fnAction = function()
			RaidGrid_CTM_Edition.nHPShownNumMode = 2
			RaidGrid_Party.ReloadRaidPanel()
		end	},
		{ szOption = "显示具体数值", bMCheck = true, bChecked = RaidGrid_CTM_Edition.nHPShownNumMode == 3, fnAction = function()
			RaidGrid_CTM_Edition.nHPShownNumMode = 3
			RaidGrid_Party.ReloadRaidPanel()
		end	},
		{ bDevide = true },
		{ szOption = g_tStrings.STR_RAID_LIFE_HIDE, bMCheck = true, bChecked = RaidGrid_CTM_Edition.nHPShownMode2 == 0, fnAction = function()
			RaidGrid_CTM_Edition.nHPShownMode2 = 0
			RaidGrid_Party.ReloadRaidPanel()
		end	},
	})
	table.insert(menu, { szOption = "图标与颜色",
		{ szOption = g_tStrings.STR_RAID_COLOR_NAME_SCHOOL, bCheck = true, bChecked = RaidGrid_CTM_Edition.bColoredName, fnAction = function()
			RaidGrid_CTM_Edition.bColoredName = not RaidGrid_CTM_Edition.bColoredName
			RaidGrid_Party.ReloadRaidPanel()
		end	},		
		{ szOption = "边框根据门派着色（暂时无效）", bCheck = true, bChecked = RaidGrid_CTM_Edition.bColoredGrid, fnAction = function()
			RaidGrid_CTM_Edition.bColoredGrid = not RaidGrid_CTM_Edition.bColoredGrid
			RaidGrid_Party.ReloadRaidPanel()
		end	},
		{ bDevide = true },
		{ szOption = "显示门派图标", bMCheck = true, bChecked = RaidGrid_CTM_Edition.bShowIcon == 1, fnAction = function()
			RaidGrid_CTM_Edition.bShowIcon = 1
			RaidGrid_Party.ReloadRaidPanel()
		end	},
		{ szOption = g_tStrings.STR_SHOW_KUNGFU, bMCheck = true, bChecked = RaidGrid_CTM_Edition.bShowIcon == 2, fnAction = function()
			RaidGrid_CTM_Edition.bShowIcon = 2
			RaidGrid_Party.ReloadRaidPanel()
		end	},
		{ szOption = "显示阵营图标", bMCheck = true, bChecked = RaidGrid_CTM_Edition.bShowIcon == 3, fnAction = function()
			RaidGrid_CTM_Edition.bShowIcon = 3
			RaidGrid_Party.ReloadRaidPanel()
		end	},
	})
	
	local function GetDistTable(nIndex)
		local tabAllDist = {szOption = "距离：" .. RaidGrid_Party.tDistanceLevel[nIndex],}
		if nIndex == 5 then
			tabAllDist.bDisable = true
		else
			for k = 4, 32 do
				local tabDist = {
					szOption = "　距离 " .. k .. "米以内 (包括)", bMCheck = true, bChecked = RaidGrid_Party.tDistanceLevel[nIndex] == k, fnAction = function(UserData, bCheck)
						RaidGrid_Party.tDistanceLevel[nIndex] = k
					end,
				}
				table.insert(tabAllDist, tabDist)
			end
		end
		return tabAllDist, RaidGrid_Party.tDistanceLevel[nIndex]
	end
	local function GetColorTable(nIndex)
		local tColor = {
			{szName = "蓝色", nLevel = 1,		r = RaidGrid_Party.tDistanceColor[1][1], g = RaidGrid_Party.tDistanceColor[1][2], b = RaidGrid_Party.tDistanceColor[1][3]},
			{szName = "绿色", nLevel = 2,		r = RaidGrid_Party.tDistanceColor[2][1], g = RaidGrid_Party.tDistanceColor[2][2], b = RaidGrid_Party.tDistanceColor[2][3]},
			{szName = "黄色", nLevel = 3,		r = RaidGrid_Party.tDistanceColor[3][1], g = RaidGrid_Party.tDistanceColor[3][2], b = RaidGrid_Party.tDistanceColor[3][3]},
			{szName = "紫色", nLevel = 4,		r = RaidGrid_Party.tDistanceColor[4][1], g = RaidGrid_Party.tDistanceColor[4][2], b = RaidGrid_Party.tDistanceColor[4][3]},
			{szName = "红色", nLevel = 5,		r = RaidGrid_Party.tDistanceColor[5][1], g = RaidGrid_Party.tDistanceColor[5][2], b = RaidGrid_Party.tDistanceColor[5][3]},
			{szName = "灰色 (深)", nLevel = 6,	r = RaidGrid_Party.tDistanceColor[6][1], g = RaidGrid_Party.tDistanceColor[6][2], b = RaidGrid_Party.tDistanceColor[6][3]},
			{szName = "灰色 (浅)", nLevel = 7,	r = RaidGrid_Party.tDistanceColor[7][1], g = RaidGrid_Party.tDistanceColor[7][2], b = RaidGrid_Party.tDistanceColor[7][3]},
			{szName = "白色", nLevel = 8,		r = RaidGrid_Party.tDistanceColor[8][1], g = RaidGrid_Party.tDistanceColor[8][2], b = RaidGrid_Party.tDistanceColor[8][3]},
		}
		local szNameC = tColor[RaidGrid_Party.tDistanceColorLevel[nIndex]].szName
		local nR = RaidGrid_Party.tDistanceColor[RaidGrid_Party.tDistanceColorLevel[nIndex]][1]
		local nG = RaidGrid_Party.tDistanceColor[RaidGrid_Party.tDistanceColorLevel[nIndex]][2]
		local nB = RaidGrid_Party.tDistanceColor[RaidGrid_Party.tDistanceColorLevel[nIndex]][3]
		local tabAllColor = {szOption = "颜色：" .. szNameC, r = nR, g = nG, b = nB}
		for k = 1, #tColor do
			local tabColor = {
				szOption = tColor[k].szName, bMCheck = true, bChecked = RaidGrid_Party.tDistanceColorLevel[nIndex] == tColor[k].nLevel, fnAction = function(UserData, bCheck)
					RaidGrid_Party.tDistanceColorLevel[nIndex] = k
				end,
				r = tColor[k].r, g = tColor[k].g, b = tColor[k].b, 
			}
			table.insert(tabAllColor, tabColor)
		end
		return tabAllColor, szNameC, nR, nG, nB 
	end
	local tDistanceMenu = { szOption = g_tStrings.STR_RAID_DISTANCE, bCheck = true, bChecked = RaidGrid_CTM_Edition.bColorHPBarWithDistance, fnAction = function() 
		RaidGrid_CTM_Edition.bColorHPBarWithDistance = not RaidGrid_CTM_Edition.bColorHPBarWithDistance
		RaidGrid_Party.ReloadRaidPanel() 
	end	}
	for j = 1, 5 do
		local tD, nDist = GetDistTable(j)
		local tC, szNameC, nR, nG, nB = GetColorTable(j)
		local szDist = tostring(nDist)
		szDist = ("_"):rep(3 - #szDist) .. szDist
		table.insert(tDistanceMenu, { szOption = "小于 " .. szDist .. "米内为：" .. szNameC, fnDisable = function() return not RaidGrid_CTM_Edition.bColorHPBarWithDistance end,tD, tC, rgb = { nR, nG, nB }} )
	end

	
	table.insert(menu, tDistanceMenu)
	table.insert(menu, { bDevide = true })
	table.insert(menu, { szOption = "排列模式",
		{ szOption = "一行：五列/零列", bMCheck = true, bChecked = RaidGrid_CTM_Edition.nAutoLinkMode == 5, fnAction = function()
			RaidGrid_CTM_Edition.nAutoLinkMode = 5
			RaidGrid_Party.ReloadRaidPanel()
		end },
		{ szOption = "两行：一列/四列", bMCheck = true, bChecked = RaidGrid_CTM_Edition.nAutoLinkMode == 1, fnAction = function()
			RaidGrid_CTM_Edition.nAutoLinkMode = 1
			RaidGrid_Party.ReloadRaidPanel()
		end },
		{ szOption = "两行：两列/三列", bMCheck = true, bChecked = RaidGrid_CTM_Edition.nAutoLinkMode == 2, fnAction = function()
			RaidGrid_CTM_Edition.nAutoLinkMode = 2
			RaidGrid_Party.ReloadRaidPanel()
		end },
		{ szOption = "两行：三列/两列", bMCheck = true, bChecked = RaidGrid_CTM_Edition.nAutoLinkMode == 3, fnAction = function()
			RaidGrid_CTM_Edition.nAutoLinkMode = 3
			RaidGrid_Party.ReloadRaidPanel()
		end },
		{ szOption = "两行：四列/一列", bMCheck = true, bChecked = RaidGrid_CTM_Edition.nAutoLinkMode == 4, fnAction = function()
			RaidGrid_CTM_Edition.nAutoLinkMode = 4
			RaidGrid_Party.ReloadRaidPanel()
		end },	
	})
	table.insert(menu, { szOption = g_tStrings.WINDOW_ADJUST_SCALE,
		{ szOption = "还原为默认 1:1", bCheck = false, bChecked = false, fnAction = function()
			RaidGrid_Party.fScaleX = 1
			RaidGrid_Party.fScaleY = 1
			RaidGrid_Party.fScaleFont = 1
			RaidGrid_Party.fScaleIcon = 1
			RaidGrid_Party.fScaleShadowX = 1
			RaidGrid_Party.fScaleShadowY = 1
			RaidGrid_Party.ReloadRaidPanel()
		end },
		{ bDevide = true },
		{ szOption = "团队界面【宽度】比例", fnAction = function()
			local x, y = Cursor.GetPos()
			local fScaleX = RaidGrid_Party.fScaleX
			GetUserPercentage(function(val)
				RaidGrid_Party.fScaleX = tonumber(val)
				RaidGrid_Party.ReloadRaidPanel()
				Station.Lookup("Normal/GetPercentagePanel"):BringToTop()
			end, nil, (fScaleX - 0.5) / 1.00, "宽度" .. g_tStrings.STR_COLON, { x, y, x + 1, y + 1 }, nil, { StartValue = 50, nStepCount = 100 })
		end	},
		{ szOption = "团队界面【高度】比例", fnAction = function()
			local x, y = Cursor.GetPos()
			local fScaleY = RaidGrid_Party.fScaleY
			GetUserPercentage(function(val)
				RaidGrid_Party.fScaleY = tonumber(val)
				RaidGrid_Party.ReloadRaidPanel()
				Station.Lookup("Normal/GetPercentagePanel"):BringToTop()
			end, nil, (fScaleY - 0.5) / 1.00, "高度" .. g_tStrings.STR_COLON, { x, y, x + 1, y + 1 }, nil, { StartValue = 50, nStepCount = 100 })
		end },
		{ szOption = "团队界面【文字大小】比例", fnAction = function()
			local x, y = Cursor.GetPos()
			local fScaleFont = RaidGrid_Party.fScaleFont
			GetUserPercentage(function(val)
				RaidGrid_Party.fScaleFont = tonumber(val)
				RaidGrid_Party.ReloadRaidPanel()
				Station.Lookup("Normal/GetPercentagePanel"):BringToTop()
			end, nil, (fScaleFont - 0.5) / 1.00, "文字大小" .. g_tStrings.STR_COLON, { x, y, x + 1, y + 1 }, nil, { StartValue = 50, nStepCount = 100 })
		end },
		{ szOption = "团队界面【buff图标】比例", fnAction = function()
			local x, y = Cursor.GetPos()
			local fScaleIcon = RaidGrid_Party.fScaleIcon
			GetUserPercentage(function(val)
				RaidGrid_Party.fScaleIcon = tonumber(val)
				RaidGrid_Party.ReloadRaidPanel()
				Station.Lookup("Normal/GetPercentagePanel"):BringToTop()
			end, nil, (fScaleIcon - 0.5) / 1.00, "BUFF大小" .. g_tStrings.STR_COLON, { x, y, x + 1, y + 1 }, nil, { StartValue = 50, nStepCount = 100 })
		end	},
		{ szOption = "团队界面【buff背景色】宽度比例", fnAction = function()
			local x, y = Cursor.GetPos()
			local fScaleShadowX = RaidGrid_Party.fScaleShadowX
			GetUserPercentage(function(val)
				RaidGrid_Party.fScaleShadowX = tonumber(val)
				RaidGrid_Party.ReloadRaidPanel()
				Station.Lookup("Normal/GetPercentagePanel"):BringToTop()
			end, nil, (fScaleShadowX - 0.5) / 1.00, "BUFF背景色宽度" .. g_tStrings.STR_COLON, { x, y, x + 1, y + 1 }, nil, { StartValue = 50, nStepCount = 100 })
		end },
		{ szOption = "团队界面【buff背景色】高度比例", fnAction = function()
			local x, y = Cursor.GetPos()
			local fScaleShadowY = RaidGrid_Party.fScaleShadowY
			GetUserPercentage(function(val)
				RaidGrid_Party.fScaleShadowY = tonumber(val)
				RaidGrid_Party.ReloadRaidPanel()
				Station.Lookup("Normal/GetPercentagePanel"):BringToTop()
			end, nil, (fScaleShadowY - 0.5) / 1.00, "BUFF背景色高度" .. g_tStrings.STR_COLON, { x, y, x + 1, y + 1 }, nil, { StartValue = 50, nStepCount = 100 })
		end },
	})
	table.insert(menu, { bDevide = true })
	table.insert(menu, { szOption = g_tStrings.OTHER,
		{ szOption = "启用", bCheck = true, bChecked = RaidGrid_CTM_Edition.bRaidEnable, fnAction = function(UserData, bCheck)
			RaidGrid_CTM_Edition.bRaidEnable = bCheck
			RaidGrid_CTM_Edition.bShowRaid = bCheck
			RaidGrid_Party.ReloadRaidPanel()
		end },
		{ szOption = "只在团队时才显示", bCheck = true, bChecked = RaidGrid_CTM_Edition.bShowInRaid, fnAction = function(UserData, bCheck)
			RaidGrid_CTM_Edition.bShowInRaid = bCheck
			RaidGrid_Party.ReloadRaidPanel()
		end },
		{ bDevide = true },
		{ szOption = "开启系统团队面板", bCheck = true, bChecked = RaidGrid_CTM_Edition.bShowSystemRaidPanel, fnAction = function(UserData, bCheck)
			RaidGrid_CTM_Edition.bShowSystemRaidPanel = bCheck
			RaidGrid_CTM_Edition.RaidPanel_Switch(bCheck)
		end },
		{ szOption = "开启系统小队面板", bCheck = true, bDisable = me.IsInRaid(), bChecked = RaidGrid_CTM_Edition.bShowSystemTeamPanel, fnAction = function(UserData, bCheck)
			RaidGrid_CTM_Edition.bShowSystemTeamPanel = bCheck
			RaidGrid_CTM_Edition.TeammatePanel_Switch(bCheck)
		end },		
	})
	-- 人数统计
	if me.IsInRaid() then
		table.insert(menu, { bDevide = true })
		RaidGrid_CTM_Edition.InsertForceCountMenu(menu)
	end
	local nX, nY = Cursor.GetPos(true)
	menu.x, menu.y = nX + 15, nY + 15
	PopupMenu(menu)
	
end
			-- {
				-- szOption = "　总是显示完整的小队格子", bCheck = true, bChecked = RaidGrid_CTM_Edition.bShowAllMemberGrid, fnAction = function(UserData, bCheck)
					-- RaidGrid_CTM_Edition.bShowAllMemberGrid = bCheck
					-- RaidGrid_Party.ReloadRaidPanel()
				-- end,
			-- },
			-- {
				-- szOption = "　总是显示整个团队面板", bCheck = true, bChecked = RaidGrid_CTM_Edition.bShowAllPanel, fnAction = function(UserData, bCheck)
					-- RaidGrid_CTM_Edition.bShowAllPanel = bCheck
					-- RaidGrid_Party.ReloadRaidPanel()
				-- end,
			-- },
function RaidGrid_CTM_Edition.InsertForceCountMenu(tMenu)
	local tForceList = {}
	local hTeam = GetClientTeam()
	local nCount = 0
	for nGroupID = 0, hTeam.nGroupNum - 1 do
		local tGroupInfo = hTeam.GetGroupInfo(nGroupID)
		for _, dwMemberID in ipairs(tGroupInfo.MemberList) do
			local tMemberInfo = hTeam.GetMemberInfo(dwMemberID)
			if not tForceList[tMemberInfo.dwForceID] then
				tForceList[tMemberInfo.dwForceID] = 0
			end
			tForceList[tMemberInfo.dwForceID] = tForceList[tMemberInfo.dwForceID] + 1
		end
		nCount = nCount + #tGroupInfo.MemberList
	end
	local tSubMenu = { szOption = g_tStrings.STR_RAID_MENU_FORCE_COUNT ..
		FormatString(g_tStrings.STR_ALL_PARENTHESES, nCount)
	}
	for dwForceID, nCount in pairs(tForceList) do
		local szPath, nFrame = GetForceImage(dwForceID)
		table.insert(tSubMenu, { 
			szOption = g_tStrings.tForceTitle[dwForceID] .. "   " .. nCount,
			rgb = { JH.GetForceColor(dwForceID) },
			szIcon = szPath,
			nFrame = nFrame,
			szLayer = "ICON_LEFT"
		})
	end
	table.insert(tMenu, tSubMenu)
end

function RaidGrid_CTM_Edition.InsertChangeGroupMenu(tMenu, dwMemberID)
	local hTeam = GetClientTeam()
	local tSubMenu = { szOption = g_tStrings.STR_RAID_MENU_CHANG_GROUP }
	
	local nCurGroupID = hTeam.GetMemberGroupIndex(dwMemberID)
	for i = 0, hTeam.nGroupNum - 1 do
		if i ~= nCurGroupID then
			local tGroupInfo = hTeam.GetGroupInfo(i)
			if tGroupInfo and tGroupInfo.MemberList then
				local tSubSubMenu = 
				{
					szOption = g_tStrings.STR_NUMBER[i + 1],
					bDisable = (#tGroupInfo.MemberList >= 5),
					fnAction = function() GetClientTeam().ChangeMemberGroup(dwMemberID, i, 0) end,
					fnAutoClose = function() return true end,
				}
				table.insert(tSubMenu, tSubSubMenu)
			end
		end
	end
	
	if #tSubMenu > 0 then
		table.insert(tMenu, tSubMenu)
	end
end

function RaidGrid_CTM_Edition.OutputTeamMemberTip(dwID, rc)
	if GetPlayer(dwID) then
		RaidGrid_CTM_Edition.OutputPlayerTip(dwID, rc)
		return
	end
	
	local hTeam = GetClientTeam()
	local tMemberInfo = hTeam.GetMemberInfo(dwID)
	if not tMemberInfo then
		return
	end

	local r, g, b = RaidGrid_CTM_Edition.GetPartyMemberFontColor()
    local szTip = GetFormatText(FormatString(g_tStrings.STR_NAME_PLAYER, tMemberInfo.szName), 80, r, g, b)
    if tMemberInfo.bIsOnLine then
    	szTip = szTip .. GetFormatText(FormatString(g_tStrings.STR_PLAYER_H_WHAT_LEVEL, tMemberInfo.nLevel), 82)
		local szMapName = Table_GetMapName(tMemberInfo.dwMapID)
		if szMapName then
			szTip = szTip .. GetFormatText(szMapName .. "\n", 82)
		end
        
        local nCamp = tMemberInfo.nCamp
        szTip = szTip .. GetFormatText(g_tStrings.STR_GUILD_CAMP_NAME[nCamp], 82)
    else
    	szTip = szTip .. GetFormatText(g_tStrings.STR_FRIEND_NOT_ON_LINE .. "\n", 82)
    end
    OutputTip(szTip, 345, rc)
end

function RaidGrid_CTM_Edition.OutputPlayerTip(dwPlayerID, Rect)
	--如果是自己，则不显示tip
	local player = GetPlayer(dwPlayerID)
	if not player then
		return
	end
	
	local clientPlayer = GetClientPlayer()
	
	if not IsCursorInExclusiveMode() then	
		if clientPlayer.dwID == dwPlayerID then
			return
		end
	end
	
	local r, g, b = RaidGrid_CTM_Edition.GetForceFontColor(dwPlayerID, clientPlayer.dwID)
	local szTip = ""

	--------------名字-------------------------
    szTip = szTip.."<Text>text="..EncodeComponentsString(FormatString(g_tStrings.STR_NAME_PLAYER, player.szName)).." font=80".." r="..r.." g="..g.." b="..b.." </text>"
    
    -------------称号----------------------------        
    if player.szTitle ~= "" then
    	szTip = szTip.."<Text>text="..EncodeComponentsString("<"..player.szTitle..">\n").." font=0 </text>"
    end
    
    if player.dwTongID ~= 0 then
    	local szName = GetTongClient().ApplyGetTongName(player.dwTongID)
    	if szName and szName ~= "" then
    		szTip = szTip.."<Text>text="..EncodeComponentsString("["..szName.."]\n").." font=0 </text>"
    	end
    end
    
    -------------等级----------------------------
    if player.nLevel - clientPlayer.nLevel > 10 and not clientPlayer.IsPlayerInMyParty(dwPlayerID) then 
    	szTip = szTip.."<Text>text="..EncodeComponentsString(g_tStrings.STR_PLAYER_H_UNKNOWN_LEVEL).." font=82 </text>"
    else
    	szTip = szTip.."<Text>text="..EncodeComponentsString(FormatString(g_tStrings.STR_PLAYER_H_WHAT_LEVEL, player.nLevel)).." font=82 </text>"
    end

	if RaidGrid_CTM_Edition.g_tReputation.tReputationTable[player.dwForceID] then
		szTip = szTip.."<Text>text="..EncodeComponentsString(RaidGrid_CTM_Edition.g_tReputation.tReputationTable[player.dwForceID].szName.."\n").." font=82 </text>"
	end

	if clientPlayer.IsPlayerInMyParty(dwPlayerID) then
		local hTeam = GetClientTeam()
		local tMemberInfo = hTeam.GetMemberInfo(dwPlayerID)
		if tMemberInfo then
			local szMapName = Table_GetMapName(tMemberInfo.dwMapID)
			if szMapName then
				szTip = szTip.."<Text>text="..EncodeComponentsString(szMapName.."\n").." font=82 </text>"
			end
		end
	end
    
	if player.bCampFlag then
		szTip = szTip .. GetFormatText(g_tStrings.STR_TIP_CAMP_FLAG, 163)
	end
	
    local nCamp = player.nCamp
    szTip = szTip .. GetFormatText(g_tStrings.STR_GUILD_CAMP_NAME[nCamp], 82)
    
    if IsCtrlKeyDown() then
    	szTip = szTip.."<Text>text="..EncodeComponentsString("\n" .. FormatString(g_tStrings.TIP_PLAYER_ID, player.dwID)).." font=102 </text>"
    	--szTip = szTip.."<Text>text="
		--szTip = szTip..EncodeComponentsString(FormatString(g_tStrings.TIP_REPRESENTID_ID, player.dwModelID.." "..var2str(player.GetRepresentID()))).." font=102 </text>" 
    end
    
    OutputTip(szTip, 345, Rect)
end

function RaidGrid_CTM_Edition.GetForceFontColor(dwPeerID, dwSelfID)
	local bInParty = false
	local player = GetClientPlayer()
	if player then
		if player.dwID == dwPeerID then
			bInParty = player.IsPlayerInMyParty(dwSelfID)
		elseif player.dwID == dwSelfID then
			bInParty = player.IsPlayerInMyParty(dwPeerID)
		end
	end
	
	local src = dwPeerID
	local dest = dwSelfID
	
	if IsPlayer(dwPeerID) and IsPlayer(dwSelfID) then
	    src = dwSelfID
	    dest = dwPeerID
	end
	
	local r, g, b
	if dwSelfID == dwPeerID then
		r, g, b = 255, 255, 0
	elseif bInParty then
		r, g, b = RaidGrid_CTM_Edition.GetPartyMemberFontColor()
	elseif IsEnemy(src, dest) then
		r, g, b = 255, 0, 0
	elseif IsNeutrality(src, dest) then
		r, g, b = 255, 255, 0
	elseif IsAlly(src, dest) then
		r, g, b = 0, 200, 72
	else
		r, g, b = 255, 0, 0
	end
	return r, g, b
end

function RaidGrid_CTM_Edition.GetPartyMemberFontColor()
	return 126, 126, 255
end

RaidGrid_CTM_Edition.g_tReputation =				
{				
	tReputationGroupTable =			
	{			
		{szVersionName = "风起稻香",		
            tGroup ={				
                {szName = "江湖门派", aForce = {11, 12, 13, 14, 15, 18, 19, 20}, },				
                {szName = "城市", aForce = {34, 35, 36}, },				
                {szName = "江湖势力", aForce = {38, 44, 45, 46, 47, 48, 75}, },				
                {szName = "四大商会", aForce = {43, 54, 55, 56}, },				
                {szName = "镖局联盟", aForce = {42}, },				
                {szName = "阵营", aForce = {49, 50}, },				
            }				
		},		
				
		{szVersionName = "巴蜀风云",		
            tGroup ={				
                {szName = "江湖门派", aForce = {16,17}, },				
                {szName = "江湖势力", aForce = {82, 83, 84, 85, 86, 87, 88, 89, 90, 93}, },				
                {szName = "镖局联盟", aForce = {91}, },				
            }				
		},		
        				
	},			
				
	tReputationTable =			
	{			
		--bInShow = true 当bHide = true时有效，如果为true,当玩家加入这个势力才显示的		
		--nInNoShou = 22 当bHide = false时有效，当万家加入了这个值的势力就不显示		
				
		[1] = {szName = "少林", szDesc = "<text>text=\"少林寺历史悠久，武学渊源流长，素有天下武功出少林之称。\"", bHide = true},		
		[2] = {szName = "万花", szDesc = "<text>text=\"万花自从建立以来就成为了各种奇人异士聚集之地。\"", bHide = true},		
		[3] = {szName = "天策", szDesc = "<text>text=\"“东都之狼”天策府是唐太宗李世民身为秦王时所设立的组织。随着李世民的上台逐渐成为机密机关，负责与江湖牵涉较多的事宜。\"", bHide = true},		
		[4] = {szName = "纯阳", szDesc = "<text>text=\"注重心境修炼的道门，乃是大唐向道之人心中的圣地。\"", bHide = true},		
		[5] = {szName = "七秀", szDesc = "<text>text=\"本是抚养孤女之地，因为有七位奇女子的出现，世称“七秀坊”。\"", bHide = true},		
		[6] = {szName = "五毒", szDesc = "<text>text=\"自给自足，一般很少涉足中原。武林人士最为不愿招惹的门派之一。\"", bHide = true},		
		[7] = {szName = "唐门", szDesc = "<text>text=\"江湖中最为神秘的家族，天下四大世家之首，历史最为悠久。\"", bHide = true},		
		[8] = {szName = "藏剑", szDesc = "<text>text=\"江南新近崛起的世家，以令人惊诧的速度位列四大世家，乃是江南名侠“一叶知秋”叶孟秋一手创立的剑术名门。\"", bHide = true},		
		[9] = {szName = "丐帮", szDesc = "<text>text=\"笑傲江湖的“天下第一大帮”。一股源自社会底层的中坚力量，帮中弟子多数有着令人为之侧目的激昂热血。\"", bHide = true},		
		[10] = {szName = "明教", szDesc = "<text>text=\"明教是发源自波斯琐罗亚斯德教派的教派，教中众多文化来自异域，许多行为至今仍被中原武林大力排斥。\"", bHide = true},		
				
		[11] = {szName = "少林", szDesc = "<text>text=\"少林寺历史悠久，武学渊源流长，素有天下武功出少林之称。\""},		
		[12] = {szName = "万花", szDesc = "<text>text=\"万花自从建立以来就成为了各种奇人异士聚集之地。\""},		
		[13] = {szName = "天策", szDesc = "<text>text=\"“东都之狼”天策府是唐太宗李世民身为秦王时所设立的组织。随着李世民的上台逐渐成为机密机关，负责与江湖牵涉较多的事宜。\""},		
		[14] = {szName = "纯阳", szDesc = "<text>text=\"注重心境修炼的道门，乃是大唐向道之人心中的圣地。\""},		
		[15] = {szName = "七秀", szDesc = "<text>text=\"本是抚养孤女之地，因为有七位奇女子的出现，世称“七秀坊”。\""},		
		[16] = {szName = "五毒", szDesc = "<text>text=\"自给自足，一般很少涉足中原。武林人士最为不愿招惹的门派之一。\""},		
		[17] = {szName = "唐门", szDesc = "<text>text=\"江湖中最为神秘的家族，天下四大世家之首，历史最为悠久。\""},		
		[18] = {szName = "藏剑", szDesc = "<text>text=\"江南新近崛起的世家，以令人惊诧的速度位列四大世家，乃是江南名侠“一叶知秋”叶孟秋一手创立的剑术名门。\""},		
		[19] = {szName = "丐帮", szDesc = "<text>text=\"笑傲江湖的“天下第一大帮”。一股源自社会底层的中坚力量，帮中弟子多数有着令人为之侧目的激昂热血。\"", bHide = true},		
		[20] = {szName = "明教", szDesc = "<text>text=\"明教是发源自波斯琐罗亚斯德教派的教派，教中众多文化来自异域，许多行为至今仍被中原武林大力排斥。\"", bHide = true},		
				
				
		[34] = {szName = "扬州", szDesc = "<text>text=\"大唐最重要的港口城市，农业、商业和手工业相当发达，江淮之间富甲天下的重镇，素有扬一益二之称。\""},		
		[35] = {szName = "洛阳", szDesc = "<text>text=\"洛阳城是大唐的东都，也是“东都之狼”天策府的发源地。\""},		
		[36] = {szName = "长安", szDesc = "<text>text=\"长安乃是大唐国都，盛世之繁华尽可在那里看到。\""},		
				
				
		[38] = {szName = "红衣教", szDesc = "<text>text=\"阿萨辛创立的势力，集祆教和中原教义在一起，倡导世无阴阳，俱为一体。\""},		
		[44] = {szName = "东漓寨", szDesc = "<text>text=\"十二连环坞之一，虽处恶人之势，却有向善之心。\""},		
		[45] = {szName = "长歌门", szDesc = "<text>text=\"文人雅士聚集之处，虽处江湖之远，确有庙堂之心。\""},		
		[46] = {szName = "昆仑", szDesc = "<text>text=\"建立在昆仑山上的一个隐居飘逸的门派。\""},		
		[47] = {szName = "刀宗", szDesc = "<text>text=\"一刀流灭亡之后，继承谢云流意志的组织。\""},		
		[48] = {szName = "隐元会", szDesc = "<text>text=\"隐息华盖之下，潜光空洞之中，无所不知，无所不至。\""},		
		[49] = {szName = "恶人谷", szDesc = "<text>text=\"率性而为，无拘无束人们的聚集之地。\""},		
		[50] = {szName = "浩气盟", szDesc = "<text>text=\"针对恶人谷而特意建立的江湖联盟，以惩凶除恶为己任。\""},		
				
				
		[54] = {szName = "关中商会", szDesc = "<text>text=\"活跃在大唐关内中原广大地区的商会。\""},		
		[43] = {szName = "南洋商会", szDesc = "<text>text=\"活跃在大唐江南以及岭南大部分地区的商会。\""},		
		[55] = {szName = "西域商会", szDesc = "<text>text=\"活跃在丝绸之路沿线和西域广大地区的商会。\""},		
		[56] = {szName = "剑南商会", szDesc = "<text>text=\"活跃在大唐云南以及巴蜀广大地区的商会。\""},		
				
		[42] = {szName = "镖局联盟", szDesc = "<text>text=\"为抵抗十二连环坞而成立的镖局联盟。\""},		
		[75] = {szName = "觅宝会", szDesc = "<text>text=\"游走于大唐各地，专门搜集天下各类宝物的神秘组织 \""},		
		[82] = {szName = "轩辕社", szDesc = "<text>text=\"由天策府领导的江湖组织，专门调查南诏反唐。 \""},		
		[83] = {szName = "藏经阁", szDesc = "<text>text=\"少林为了从智慧王手上追回易筋经，专门派遣的高手，不远千里来到西南。 \""},		
		[84] = {szName = "霸刀", szDesc = "<text>text=\"为了找回九天神算多多，霸刀也派遣了众多精锐进入巴蜀。 \""},		
		[85] = {szName = "大理宫", szDesc = "<text>text=\"由南诏清平官段俭魏一手创立，在西南武林赫赫有名。 \""},		
		[86] = {szName = "塔纳", szDesc = "<text>text=\"由唐门大小姐唐书雁领导的一帮惨遭天一教迫害的武林人士。 \""},		
		[87] = {szName = "祝融殿", szDesc = "<text>text=\"五毒教分部，专门负责处理本教内部事宜。 \""},		
		[88] = {szName = "天南王家", szDesc = "<text>text=\"王昭南世家，为西南一霸，富甲一方。 \""},		
		[89] = {szName = "拜火教", szDesc = "<text>text=\"来源于波斯的神秘组织…… \""},		
		[90] = {szName = "九黎族", szDesc = "<text>text=\"西南蛮族之长，所有蛮族部落的精神领袖。 \""},		
		[91] = {szName = "镇南镖局", szDesc = "<text>text=\"镖局联盟在西南的分舵。 \""},	
		[93] = {szName = "塔纳离恨冢", szDesc = "<text>text=\"塔纳一族之中的全部成员都是被尸炼之术所害之人，为此他们与至亲好友天各一方，经受有家不能回，有愿不能圆，有情不能诉的无尽苦楚，他们中的许多人都对天一教痛恨入骨，在于天一对抗的经历中，多数塔纳都在天一强劲的围剿下死去了，剩余的塔纳为他们搭建起了离恨冢，把他们的名字和曾经为人之时的生平功过记录之中，并誓言为他们复仇。\""},			
		},			
				
	tReputationLevelTable =			
	{			
		--szLevel 等级对应的显示名字， nFont字体, nFrame--进度条图片帧		
		[0] = {szLevel = "仇恨", nFont = 166, nFrame = 40},		
		[1] = {szLevel = "敌视", nFont = 166, nFrame = 40},		
		[2] = {szLevel = "疏远", nFont = 162, nFrame = 38},		
		[3] = {szLevel = "中立", nFont = 162, nFrame = 38},		
		[4] = {szLevel = "友好", nFont = 165, nFrame = 39},		
		[5] = {szLevel = "亲密", nFont = 165, nFrame = 39},		
		[6] = {szLevel = "敬重", nFont = 165, nFrame = 39},		
		[7] = {szLevel = "尊敬", nFont = 165, nFrame = 39},		
		[8] = {szLevel = "钦佩", nFont = 165, nFrame = 39},		
		[9] = {szLevel = "显赫", nFont = 165, nFrame = 39},		
		[10] = {szLevel = "崇敬", nFont = 163, nFrame = 79},		
		[11] = {szLevel = "崇拜", nFont = 163, nFrame = 79},		
		[12] = {szLevel = "传说", nFont = 163, nFrame = 79},		
	},
}

function RaidGrid_CTM_Edition.OpenRaidDragPanel(dwMemberID)
	local hTeam = GetClientTeam()
	local tMemberInfo = hTeam.GetMemberInfo(dwMemberID)
	if not tMemberInfo then
		return
	end
	
	local hFrame = Wnd.OpenWindow("RaidDragPanel")
	
	local nX, nY = Cursor.GetPos()
	hFrame:SetAbsPos(nX, nY)
	hFrame:StartMoving()
	
	hFrame.dwID = dwMemberID
	local hMember = hFrame:Lookup("", "")
	
	local szPath, nFrame = GetForceImage(tMemberInfo.dwForceID)
	hMember:Lookup("Image_Force"):FromUITex(szPath, nFrame)
	
	local hTextName = hMember:Lookup("Text_Name")
	hTextName:SetText(tMemberInfo.szName)
	
	local hImageLife = hMember:Lookup("Image_Health")
	local hImageMana = hMember:Lookup("Image_Mana")
	if tMemberInfo.bIsOnLine then
		if tMemberInfo.nMaxLife > 0 then
			hImageLife:SetPercentage(tMemberInfo.nCurrentLife / tMemberInfo.nMaxLife)
		end
		if tMemberInfo.nMaxMana > 0 and tMemberInfo.nMaxMana ~= 1 then
			hImageMana:SetPercentage(tMemberInfo.nCurrentMana / tMemberInfo.nMaxMana)
		end
	else
		hImageLife:SetPercentage(0)
		hImageMana:SetPercentage(0)
	end
	
	hMember:Show()
end

function RaidGrid_CTM_Edition.CloseRaidDragPanel()
	local hFrame = Station.Lookup("Normal/RaidDragPanel")
	if hFrame then
		hFrame:EndMoving()
		Wnd.CloseWindow(hFrame)
	end
end

function RaidGrid_CTM_Edition.EditBox_AppendLinkPlayer(szPlayerName)
	local frame = Station.Lookup("Lowest2/EditBox")
	if not frame or not frame:IsVisible() then
		return false
	end

	local edit = Station.Lookup("Lowest2/EditBox/Edit_Input")
	edit:InsertObj("["..szPlayerName.."]", {type = "name", text = "["..szPlayerName.."]", name = szPlayerName})
	
	Station.SetFocusWindow(edit)
	return true
end
