local function isValidBinaryString(s)
	return s ~= "" and s:match("^[01]+$") ~= nil
end

local function isValidHexString(s)
	return s ~= "" and s:match("^[0-9a-fA-F]+$") ~= nil
end

local bin_to_hex_map = {
	["0000"] = "0",
	["0001"] = "1",
	["0010"] = "2",
	["0011"] = "3",
	["0100"] = "4",
	["0101"] = "5",
	["0110"] = "6",
	["0111"] = "7",
	["1000"] = "8",
	["1001"] = "9",
	["1010"] = "A",
	["1011"] = "B",
	["1100"] = "C",
	["1101"] = "D",
	["1110"] = "E",
	["1111"] = "F",
}

local hex_to_bin_map = {
	["0"] = "0000",
	["1"] = "0001",
	["2"] = "0010",
	["3"] = "0011",
	["4"] = "0100",
	["5"] = "0101",
	["6"] = "0110",
	["7"] = "0111",
	["8"] = "1000",
	["9"] = "1001",
	["A"] = "1010",
	["B"] = "1011",
	["C"] = "1100",
	["D"] = "1101",
	["E"] = "1110",
	["F"] = "1111",
}

local hexChars = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F" }

local function decimalToBinary(decimal_number)
	if decimal_number == 0 then
		return "0"
	end

	local binary_str = ""

	while decimal_number > 0 do
		local bit = decimal_number & 1
		binary_str = bit .. binary_str
		decimal_number = decimal_number >> 1
	end

	return binary_str
end

local function decimalToBinaryFromArgs()
	if arg[2] == nil then
		print("enter a decimal number as the second argument")
	else
		if tonumber(arg[2]) == nil then
			print("Please enter a valid decimal number using only digits 0-9")
		else
			print(decimalToBinary(tonumber(arg[2])))
		end
	end
end

local function binaryToDecimal(binary_str)
	local decimal_number = 0
	local power = 1

	for i = #binary_str, 1, -1 do
		local char = string.sub(binary_str, i, i)

		if char == "1" then
			decimal_number = decimal_number + power
		end

		power = power * 2
	end

	return decimal_number
end

local function binaryToDecimalFromArgs()
	if arg[2] == nil then
		print("Enter a binary number as the second argument")
	elseif not isValidBinaryString(arg[2]) then
		print("Please enter a valid binary number using digits only 0-1")
	else
		print(binaryToDecimal(arg[2]))
	end
end

local function decimalToHex(decimal_number)
	if decimal_number == 0 then
		return "0"
	end

	local hex_str = ""

	while decimal_number > 0 do
		local nibble = decimal_number & 0x0F
		hex_str = hexChars[nibble + 1] .. hex_str
		decimal_number = decimal_number >> 4
	end

	return hex_str
end

local function decimalToHexFromArgs()
	if arg[2] == nil then
		print("Enter a decimal number as the second argument")
	elseif tonumber(arg[2]) == nil then
		print("Please enter a valid decimal number using only digits 0-9")
	else
		local num = tonumber(arg[2])
		print(decimalToHex(num))
	end
end

local function binaryToHex(binary_str)
	local hex_str = ""

	local rem = #binary_str % 4
	if rem ~= 0 then
		binary_str = string.rep("0", 4 - rem) .. binary_str
	end

	for nibble in binary_str:gmatch("....") do
		hex_str = hex_str .. bin_to_hex_map[nibble]
	end

	return hex_str
end

local function binaryToHexFromArgs()
	if arg[2] == nil then
		print("Enter a binary string as the second argument")
	elseif not isValidBinaryString(arg[2]) then
		print("Please enter a valid binary number using digits only 0-1")
	else
		print(binaryToHex(arg[2]))
	end
end

local function hexToBinary(hex_str)
	local binary_str = ""

	for char in hex_str:gmatch(".") do
		local upper_char = char:upper()
		binary_str = binary_str .. hex_to_bin_map[upper_char]
	end

	return binary_str
end

local function hexToBinaryFromArgs()
	if arg[2] == nil then
		print("Enter a hex string as the second argument")
	elseif not isValidHexString(arg[2]) then
		print("Please enter a valid hexadecimal string using valid characters (0-9, A-F)")
	else
		print(hexToBinary(arg[2]))
	end
end

local function hexToDecimal(hex_str)
	return tonumber(hex_str, 16)
end

local function hexToDecimalFromArgs()
	if arg[2] == nil then
		print("Enter a hex string as the second argument")
	elseif not isValidHexString(arg[2]) then
		print("Please enter a valid hexadecimal string using valid characters (0-9, A-F)")
	else
		print(hexToDecimal(arg[2]))
	end
end

local function textToBinary(text)
	local binary_str = ""

	for i = 1, #text do
		local hex_byte = string.format("%02X", text:byte(i))

		for char in hex_byte:gmatch(".") do
			binary_str = binary_str .. (hex_to_bin_map[char] or "")
		end
	end

	return binary_str
end

local function textToBinaryFromArgs()
	if arg[2] == nil then
		print("Enter a text string as the second argument")
	else
		print(textToBinary(arg[2]))
	end
end

local function binaryToText(binary_str)
	local text_str = ""

	local rem = #binary_str % 8
	if rem ~= 0 then
		binary_str = string.rep("0", 8 - rem) .. binary_str
	end

	for i = 1, #binary_str, 8 do
		local byte_str = binary_str:sub(i, i + 7)
		local byte_num = tonumber(byte_str, 2)

		if byte_num then
			text_str = text_str .. string.char(byte_num)
		end
	end

	return text_str
end

local function binaryToTextFromArgs()
	if arg[2] == nil then
		print("Enter a binary string as the second argument")
	elseif not isValidBinaryString(arg[2]) then
		print("Please enter a valid binary number using digits only 0-1")
	else
		print(binaryToText(arg[2]))
	end
end

local function textToBinaryFromFile()
	local file = io.open(arg[3], "r")

	if not file then
		print("Error: Could not open file.")
		return nil
	end

	local content = file:read("*all")
	file:close()

	content = content:gsub("\n$", "")

	print(textToBinary(content))
end

local function binaryToTextFromFile()
	local file = io.open(arg[3], "r")

	if not file then
		print("Error: Could not open file.")
		return nil
	end

	local content = file:read("*all")
	file:close()

	content = content:gsub("%s+", "")

	if isValidBinaryString(content) then
		print(binaryToText(content))
	else
		print("The file must be a valid binary string only containing digits 0-1")
	end
end

if arg[1] == "fromfile" then
	if arg[2] == "t2b" then
		textToBinaryFromFile()
	elseif arg[2] == "b2t" then
		binaryToTextFromFile()
	else
		print("please enter a valid argument either b2t or t2b")
	end
elseif arg[1] == "d2b" then
	decimalToBinaryFromArgs()
elseif arg[1] == "b2d" then
	binaryToDecimalFromArgs()
elseif arg[1] == "b2h" then
	binaryToHexFromArgs()
elseif arg[1] == "d2h" then
	decimalToHexFromArgs()
elseif arg[1] == "h2b" then
	hexToBinaryFromArgs()
elseif arg[1] == "h2d" then
	hexToDecimalFromArgs()
elseif arg[1] == "t2b" then
	textToBinaryFromArgs()
elseif arg[1] == "b2t" then
	binaryToTextFromArgs()
else
	print(string.format('Error: No valid argument "%s". Try using:', tostring(arg[1])))
	print("  b2d - Binary to Decimal")
	print("  d2b - Decimal to Binary")
	print("  b2h - Binary to Hex")
	print("  h2b - Hex to Binary")
	print("  d2h - Decimal to Hex")
	print("  h2d - Hex to Decimal")
	print("  t2b - Text to Binary")
	print("  b2t - Binary to Text")
end
