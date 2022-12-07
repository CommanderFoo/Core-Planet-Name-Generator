---@type Folder
local ROOT = script:GetCustomProperty("Root"):WaitForObject()

local PART_1 = require(script:GetCustomProperty("Part1"))
local PART_2 = require(script:GetCustomProperty("Part2"))
local PREFIX = require(script:GetCustomProperty("Prefix"))
local SUFFIX = require(script:GetCustomProperty("Suffix"))

local SEED = ROOT:GetCustomProperty("Seed")
local PREFIX_CHANCE = ROOT:GetCustomProperty("PrefixChance")
local SUFFIX_CHANCE = ROOT:GetCustomProperty("SuffixChance")
local RANDOM_SEED = ROOT:GetCustomProperty("RandomSeed")
local AUTO_GENERATE = ROOT:GetCustomProperty("AutoGenerate")

---@type UIButton
local GENERATE_BUTTON = script:GetCustomProperty("GenerateButton"):WaitForObject()

---@type UIImage
local CONTAINER = script:GetCustomProperty("Container"):WaitForObject()

local RNG = RandomStream.New(RANDOM_SEED and DateTime.CurrentTime().millisecondsSinceEpoch or SEED)

UI.SetCursorVisible(true)
UI.SetCanCursorInteractWithUI(true)

print("-----------------\nSeed: " .. RNG:GetInitialSeed() .. "\n-----------------")

local function generate()
	local prefix_chance = RNG:GetInteger(1, 100)
	local suffix_chance = RNG:GetInteger(1, 100)
	local name = PART_1[RNG:GetInteger(1, #PART_1)].Name .. PART_2[RNG:GetInteger(1, #PART_2)].Name
	
	if(prefix_chance <= PREFIX_CHANCE) then
		name = PREFIX[RNG:GetInteger(1, #PREFIX)].Name .. " " .. name
	end

	if(suffix_chance <= SUFFIX_CHANCE) then
		name = name .. " " .. SUFFIX[RNG:GetInteger(1, #SUFFIX)].Name
	end

	print(name)

	return name
end

local function do_it()
	for i = 1, #CONTAINER:GetChildren() do
		CONTAINER:GetChildren()[i].text = generate()
	end

	print("-----------------")
end

GENERATE_BUTTON.pressedEvent:Connect(do_it)

if(AUTO_GENERATE) then
	local t = Task.Spawn(do_it)

	t.repeatCount = -1
	t.repeatInterval = 5
end