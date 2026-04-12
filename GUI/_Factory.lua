local F = {}
cfCastbars.F = F

local widgets = {}

function F.ScrollPanel(panel)
	local sf = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
	sf:SetPoint("TOPLEFT", 0, 0)
	sf:SetPoint("BOTTOMRIGHT", -26, 0)
	local sc = CreateFrame("Frame", nil, sf)
	sc:SetSize(1, 1)
	sf:SetScrollChild(sc)
	sc:SetScript("OnSizeChanged", function(self) self:SetWidth(sf:GetWidth()) end)
	panel:HookScript("OnShow", function()
		local top = sc:GetTop()
		if not top then return end
		local lowest = top
		for _, child in pairs({ sc:GetChildren() }) do
			local b = child:GetBottom()
			if b and b < lowest then lowest = b end
		end
		sc:SetHeight(top - lowest + 20)
	end)
	return sc
end

function F.HSeparator(parent)
	local sep = parent:CreateTexture(nil, "ARTWORK")
	sep:SetHeight(1)
	sep:SetColorTexture(0.4, 0.4, 0.4, 0.4)
	sep:SetPoint("LEFT", parent, "LEFT", 0, 0)
	sep:SetPoint("RIGHT", parent, "RIGHT", 0, 0)
	return sep
end

function F.VSeparator(parent)
	local sep = parent:CreateTexture(nil, "ARTWORK")
	sep:SetWidth(1)
	sep:SetColorTexture(0.4, 0.4, 0.4, 0.4)
	return sep
end

function F.Text(parent, text, font)
	local fs = parent:CreateFontString(nil, "ARTWORK", font)
	fs:SetText(text)
	return fs
end

function F.Checkbox(parent, key, label, callback)
	local cb = CreateFrame("CheckButton", nil, parent, "InterfaceOptionsCheckButtonTemplate")
	cb.Text:SetText(label)
	if key then
		cb:SetChecked(cfCastbarsDB[key])
		cb.Refresh = function() cb:SetChecked(cfCastbarsDB[key]) end
		widgets[key] = cb
	end
	cb:HookScript("OnClick", function(self)
		if key then cfCastbarsDB[key] = self:GetChecked() end
		if callback then callback(self:GetChecked()) end
	end)
	return cb
end

function F.BindChildren(checkbox, dependents)
	local function Update()
		local enabled = checkbox:GetChecked()
		for _, w in ipairs(dependents) do
			w:SetAlpha(enabled and 1 or 0.3)
			w:EnableMouse(enabled)
		end
	end
	checkbox:HookScript("OnClick", Update)
	checkbox.UpdateChildren = Update
	Update()
end

function F.CastbarDeco(parent, r, g, b)
	local bg = parent:CreateTexture(nil, "ARTWORK")
	bg:SetColorTexture(r, g, b)
	bg:SetSize(110, 13)
	local border = parent:CreateTexture(nil, "OVERLAY")
	border:SetTexture("Interface\\CastingBar\\UI-CastingBar-Border-Small")
	border:SetSize(150, 49)
	border:SetPoint("CENTER", bg, "CENTER", 0, 0)
	return bg
end

function F.Button(parent, label, onClick)
	local btn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	btn:SetSize(80, 22)
	btn:SetText(label)
	if onClick then btn:SetScript("OnClick", onClick) end
	return btn
end

function F.ResetPrefix(prefix, callback)
	for key, value in pairs(cfCastbars.DEFAULTS) do
		if key:sub(1, #prefix) == prefix then
			cfCastbarsDB[key] = value
			if widgets[key] then
				if widgets[key].Refresh then widgets[key]:Refresh() end
				if widgets[key].UpdateChildren then widgets[key]:UpdateChildren() end
			end
		end
	end
	if callback then callback() end
end

local dropdownCount = 0

function F.Dropdown(parent, key, label, items, callback)
	dropdownCount = dropdownCount + 1
	local name = "cfCastbarsDropdown" .. dropdownCount
	local frame = CreateFrame("Frame", name, parent, "UIDropDownMenuTemplate")
	UIDropDownMenu_SetWidth(frame, 110)

	local function GetLabel(value)
		for _, item in ipairs(items) do
			if item[1] == value then return item[2] end
		end
		return items[1][2]
	end

	UIDropDownMenu_SetText(frame, GetLabel(cfCastbarsDB[key]))

	UIDropDownMenu_Initialize(frame, function()
		for _, item in ipairs(items) do
			local info = UIDropDownMenu_CreateInfo()
			info.text = item[2]
			info.value = item[1]
			info.checked = (cfCastbarsDB[key] == item[1])
			info.func = function(self)
				cfCastbarsDB[key] = self.value
				UIDropDownMenu_SetText(frame, self:GetText())
				CloseDropDownMenus()
				if callback then callback(self.value) end
			end
			UIDropDownMenu_AddButton(info)
		end
	end)

	local lbl = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	lbl:SetText(label)
	lbl:SetTextColor(1, 0.82, 0)
	lbl:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 20, 0)

	frame.Refresh = function()
		UIDropDownMenu_SetText(frame, GetLabel(cfCastbarsDB[key]))
	end
	widgets[key] = frame
	return frame
end

function F.Slider(parent, key, label, min, max, step, callback)
	local slider = CreateFrame("Slider", nil, parent, "OptionsSliderTemplate")
	slider:SetWidth(140)
	slider:SetMinMaxValues(min, max)
	slider:SetValueStep(step)
	slider:SetObeyStepOnDrag(true)
	slider.Text:SetFontObject("GameFontHighlightSmall")
	slider.Text:SetTextColor(1, 0.82, 0)
	local function Fmt(v) return v % 1 == 0 and tostring(math.floor(v)) or format("%.2f", v) end
	slider.Text:SetText(label .. ": " .. Fmt(cfCastbarsDB[key]))
	slider.Low:Hide()
	slider.High:Hide()
	slider:SetValue(cfCastbarsDB[key])
	slider:EnableMouseWheel(true)
	slider:SetScript("OnMouseWheel", function(self, delta)
		if IsShiftKeyDown() then
			self:SetValue(self:GetValue() + delta * step)
		end
	end)
	slider:SetScript("OnValueChanged", function(self, value)
		cfCastbarsDB[key] = value
		self.Text:SetText(label .. ": " .. Fmt(value))
		if callback then callback(value) end
	end)
	slider.Refresh = function()
		slider:SetValue(cfCastbarsDB[key])
		slider.Text:SetText(label .. ": " .. Fmt(cfCastbarsDB[key]))
	end
	widgets[key] = slider
	return slider
end
