-- main.lua
--
-- author: 4c65736975
--
-- Copyright (c) 2025 VertexFloat. All Rights Reserved.
--
-- This source code is licensed under the GPL-3.0 license found in the
-- LICENSE file in the root directory of this source tree.

local function onLoad(self, savegame)
  local spec = self.spec_plow

  spec.bAllowPlowShare = true

  spec.texts.enablePlowShare = g_i18n:getText("action_enablePlowShare")
  spec.texts.disablePlowShare = g_i18n:getText("action_disablePlowShare")
end

Plow.onLoad = Utils.appendedFunction(Plow.onLoad, onLoad)

local function onRegisterActionEvents(self, isActiveForInput, isActiveForInputIgnoreSelection)
  local spec = self.spec_plow

  if isActiveForInputIgnoreSelection then
    local _, actionEventId = self:addActionEvent(spec.actionEvents, InputAction.IMPLEMENT_EXTRA4, self, Plow.actionTogglePlowShare, false, true, false, true, nil)
    g_inputBinding:setActionEventText(actionEventId, spec.texts.disablePlowShare)
    g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_NORMAL)
  end
end

Plow.onRegisterActionEvents = Utils.appendedFunction(Plow.onRegisterActionEvents, onRegisterActionEvents)

Plow.actionTogglePlowShare = function(self, actionName, inputValue, callbackState, isAnalog)
  local spec = self.spec_plow
  local bEnabled = not spec.bAllowPlowShare

  spec.bAllowPlowShare = bEnabled

  local actionEvent = spec.actionEvents[InputAction.IMPLEMENT_EXTRA4]

  if actionEvent ~= nil then
    local text = bEnabled and spec.texts.enablePlowShare or spec.texts.disablePlowShare

    g_inputBinding:setActionEventText(actionEvent.actionEventId, text)
  end
end

local function processPlowShareArea(self, superFunc, workArea, dt)
  if not self.spec_plow.bAllowPlowShare then
    return 0, 0
  end

  return superFunc(self, workArea, dt)
end

Plow.processPlowShareArea = Utils.overwrittenFunction(Plow.processPlowShareArea, processPlowShareArea)