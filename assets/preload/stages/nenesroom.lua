function onCreate()
	scale = 0.7;
	
	-- background shit
	makeLuaSprite('bg', 'doog/room', -1050, -350);
	setScrollFactor('bg', 1, 1);
	scaleObject('bg', scale, scale);
	addLuaSprite('bg', false);
	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end