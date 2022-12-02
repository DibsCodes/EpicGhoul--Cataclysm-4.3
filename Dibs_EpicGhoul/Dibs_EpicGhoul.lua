-- frame creation and event registration
local f = CreateFrame("Frame"); --event handler frame
local f2 = CreateFrame("Frame"); --onUpdate frame
f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
f:RegisterEvent("PLAYER_LOGIN");

-- this is a list of transitions between names of pet. They will be chosen randomly. Feel free to add any you want!
local transitions = {
	" son of " ,
	" of the great ",
	" decendant of ",
	" of the fallen ",
	" trained by master ",
}

-- Phrase Generator: this edits a string called "bigstring" that contains all of your past pets
function PhraseGen()
	local newname, realm = UnitName("pet")
	if (newname == nil) then
		print("You don't have a pet, bro")
	elseif (newname == pnames[1]) then
		SendChatMessage("Rise again "..newname.." it's time for battle!")
	else
		table.insert(pnames,1,newname)

		if (#pnames == 1) then
			bigstring = pnames[1]
		else
			bigstring = pnames[1]..","..transitions[math.random(#transitions)]..bigstring
		end

		SendChatMessage("Rise, "..bigstring..", It's time for battle!")

	end
end

-- Slash Command stuff
SLASH_PHRASE1 = "/eg";
SLASH_PHRASE2 = "/epicghoul";

SlashCmdList["PHRASE"] = function(msg)
	if msg == "" then
		print("/eg reset -- will reset your list of ghouls")
			
	elseif msg.sub(msg,1,5) == "reset" then
		bigstring = "Rise, "
		pnames = {}
		print("Dibs_EpicGhoul: List of Ghouls Reset")
	else
		print("Command not recognized. Type /eg or epicghoul to see command options")
		
	end
end

-- Wait Function. This is where the Phrase Generator is called
function f:onUpdate(sinceLastUpdate)
	self.sinceLastUpdate = (self.sinceLastUpdate or 0) + sinceLastUpdate;   
	if ( self.sinceLastUpdate >= 2 ) then -- in seconds
    	PhraseGen()
    	self.sinceLastUpdate = 0
    	f2:SetScript("OnUpdate",nil)
	end
end

--event handler. This just starts the onUpdate to call the Phrase Generator
f:SetScript("OnEvent", function(self,event,...) 	
	
	if event == "PLAYER_LOGIN" then
		print("Dibs_EpicGhoul: List of Ghouls Reset")
		local bigstring = "Rise, " -- reseting the bigstring
		pnames = {}  -- reseting the past names array to be filled again
	end
	
	if event == "UNIT_SPELLCAST_SUCCEEDED" then
		local unit,spell = ...;
		if unit == "player" and spell == "Raise Dead" then
			f2:SetScript("OnUpdate",f.onUpdate)
		end
	end

end)

