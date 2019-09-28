--Made by Luckymaxer (Repurposed by Psudar)/Added some functions
--Sep 1 2019
--Stores useful functions such is IsTeammate, CreateTag, Timer, etc.

--//Services

local Debris = game:GetService("Debris")

--//Instances

local ProjectileNames = {"Water", "Arrow", "Projectile", "Effect", "Rail", "Laser", "Ray", "Bullet", "ParticlePart"}

--//Module

Functions = {
	
	CreateConfiguration = (function(Configurations, Table)
		for i, v in pairs(Configurations:GetChildren()) do
			if string.find(v.ClassName, "Value") then
				Table[v.Name] = v:Clone()
			elseif v:IsA("Folder") or v:IsA("Configuration") then
				Table[v.Name] = Functions.CreateConfiguration(v, Table)
			end
		end
		return Table
	end);
	
	FindCharacterAncestor = (function(Object)
		if Object and Object ~= game:GetService("Workspace") then
			local Humanoid = Object:FindFirstChild("Humanoid")
			if Humanoid then
				return Object, Humanoid
			else
				return Functions.FindCharacterAncestor(Object.Parent)
			end
		end
		return nil
	end);

	CheckTableForString = (function(Table, String)
		for i, v in pairs(Table) do
			if string.lower(v) == string.lower(String) then
				return true
			end
		end
		return false
	end);
	
	CheckIntangible = (function(Hit)
		if Hit and Hit.Parent then
			if Functions.CheckTableForString(ProjectileNames, Hit.Name) then
				return true
			end
			local ObjectParent = Hit.Parent
			local Character = ObjectParent.Parent
			local Humanoid = Character:FindFirstChild("Humanoid")
			if Humanoid and Humanoid.Health > 0 and ObjectParent:IsA("Hat") then
				print("Was a player")
				return true
			end
		end
		return false
	end);
	
	CastRay = (function(StartPos, Vec, Length, Ignore, DelayIfHit)
		local RayHit, RayPos, RayNormal = game:GetService("Workspace"):FindPartOnRayWithIgnoreList(Ray.new(StartPos, Vec * Length), Ignore)
		if RayHit and Functions.CheckIntangible(RayHit) then
			if DelayIfHit then
				wait()
			end
			RayHit, RayPos, RayNormal = Functions.CastRay((RayPos + (Vec * 0.01)), Vec, (Length - ((StartPos - RayPos).magnitude)), Ignore, DelayIfHit)
		end
		return RayHit, RayPos, RayNormal
	end);
	
	IsTeamMate = (function(Player1, Player2)
		return (Player1 and Player2 and not Player1.Neutral and not Player2.Neutral and Player1.TeamColor == Player2.TeamColor)
	end);
	
	TagHumanoid = (function(humanoid, player)
		local Creator_Tag = Instance.new("ObjectValue")
		Creator_Tag.Name = "creator"
		Creator_Tag.Value = player
		Debris:AddItem(Creator_Tag, 2)
		Creator_Tag.Parent = humanoid
	end);
	
	TagHumanoidForDamage = (function(humanoid, player, damage)
		local Creator_Tag = Instance.new("ObjectValue")
		Creator_Tag.Name = "dmgcreator"
		Creator_Tag.Value = player
		Debris:AddItem(Creator_Tag, 3)
		
		local Damage_Tag = Instance.new("IntValue")
		Damage_Tag.Name = "dmgtag"
		Damage_Tag.Value = damage
		Damage_Tag.Parent = Creator_Tag
		
		Creator_Tag.Parent = humanoid
	end);
	
	UntagHumanoid = (function(humanoid)
		for i, v in pairs(humanoid:GetChildren()) do
			if v:IsA("ObjectValue") and v.Name == "creator" then
				v:Destroy()
			end
		end
	end);
	
	CheckTableForString = (function(Table, String)
		for i, v in pairs(Table) do
			if string.lower(v) == string.lower(String) then
				return true
			end
		end
		return false
	end);
	
	Clamp = (function(Number, Min, Max)
		return math.max(math.min(Max, Number), Min)
	end);
	
	GetPercentage = (function(Start, End, Number)
		return (((Number - Start) / (End - Start)) * 100)
	end);
	
	Round = (function(Number, RoundDecimal)
		local WholeNumber, Decimal = math.modf(Number)
		return ((Decimal >= RoundDecimal and math.ceil(Number)) or (Decimal < RoundDecimal and math.floor(Number)))
	end);
	
	Timer = (function(duration)
		local StartTime = tick()
		repeat wait()
		until tick() - StartTime >= duration
		print("Timer finished")
	end);
	
	WeldBetween = (function(Part0, Part1)
		local Weld = Instance.new("Weld")
		Weld.Part0 = Part0
		Weld.Part1 = Part1
		Weld.Parent = Part1
	end)
	
}

return Functions
