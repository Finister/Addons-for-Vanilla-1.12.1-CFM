pfUI:RegisterModule("map", function ()

  function _G.ToggleWorldMap()
    if WorldMapFrame:IsShown() then
      WorldMapFrame:Hide()
    else
      WorldMapFrame:Show()
      table.insert(UISpecialFrames, "WorldMapFrame")
    end
  end

  if not C.position[WorldMapFrame:GetName()] then
    C.position[WorldMapFrame:GetName()] = { alpha = 1.0, scale = 0.7 }
  end
  local c_position = C.position[WorldMapFrame:GetName()]

  local pfMapLoader = CreateFrame("Frame", nil, UIParent)
  pfMapLoader:RegisterEvent("PLAYER_ENTERING_WORLD")
  pfMapLoader:SetScript("OnEvent", function()
    -- do not load if other map addon is loaded
    if Cartographer then return end
    if METAMAP_TITLE then return end

    UIPanelWindows["WorldMapFrame"] = { area = "center" }

    WorldMapFrame:SetScript('OnShow', function()
      -- default events
      UpdateMicroButtons()
      PlaySound("igQuestLogOpen")
      CloseDropDownMenus()
      SetMapToCurrentZone()
      WorldMapFrame_PingPlayerPosition()

      -- customize
      WorldMapFrame:SetMovable(true)
      WorldMapFrame:EnableMouse(true)
      WorldMapFrame:EnableKeyboard(false)
      WorldMapFrame:EnableMouseWheel(1)
      WorldMapFrame:SetScript("OnMouseWheel", function()
        if IsShiftKeyDown() then
          c_position.alpha = pfUI.api.clamp(WorldMapFrame:GetAlpha() + arg1/10, 0.1, 1.0)
          WorldMapFrame:SetAlpha(c_position.alpha)
        end

        if IsControlKeyDown() then
          c_position.scale = pfUI.api.clamp(WorldMapFrame:GetScale() + arg1/10, 0.1, 2.0)
          WorldMapFrame:SetScale(c_position.scale)
        end
      end)

      WorldMapFrame:SetScript("OnMouseDown",function()
        WorldMapFrame:StartMoving()
      end)

      WorldMapFrame:SetScript("OnMouseUp",function()
        WorldMapFrame:StopMovingOrSizing()
      end)

      WorldMapFrame:ClearAllPoints()
      WorldMapFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
      WorldMapFrame:SetWidth(WorldMapButton:GetWidth() + 15)
      WorldMapFrame:SetHeight(WorldMapButton:GetHeight() + 55)

      WorldMapFrameCloseButton:SetPoint("TOPRIGHT", WorldMapFrame, "TOPRIGHT", 0, 0)
      CreateBackdrop(WorldMapFrame)
      
      WorldMapFrame:SetAlpha(c_position.alpha)
      WorldMapFrame:SetScale(c_position.scale)
      
      BlackoutWorld:Hide()

      for i,v in ipairs({WorldMapFrame:GetRegions()}) do
         if v.SetTexture then
           v:SetTexture("")
         end

         if v.SetText then
           v:SetText("")
         end
       end
    end)
  end)
end)
