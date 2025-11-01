-- Hammerspoon 한영 전환 (F18) - Input Source Manager 방식
local inputEnglish = "com.apple.keylayout.ABC"
local inputKorean = "com.apple.inputmethod.Korean.2SetKorean"

hs.hotkey.bind({}, 'F18', function()
    local current = hs.keycodes.currentSourceID()

    -- 사용 가능한 모든 입력기 목록 확인 (첫 실행 시)
    if not inputsChecked then
        local sources = hs.keycodes.layouts()
        for i, source in ipairs(sources) do
            print(i .. ": " .. source)
            if source:find("Korean") or source:find("2SetKorean") then
                inputKorean = source
            end
        end
        inputsChecked = true
    end

    -- 토글 로직
    if current == inputEnglish then
        hs.keycodes.setLayout(inputKorean)
        hs.alert.show("→ 한글")
    else
        hs.keycodes.setLayout(inputEnglish)
        hs.alert.show("→ ABC")
    end
end)

hs.alert.show("Hammerspoon loaded! ✅")
