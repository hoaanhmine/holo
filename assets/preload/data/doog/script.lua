function onCreate()
	makeAnimatedLuaSprite('doogSaw', 'ChainsawDrop', -300, 400);
	addAnimationByPrefix('doogSaw', 'drop', 'ChainsawDrop', 24, false)
	addLuaSprite('doogSaw', true);
	setProperty('doogSaw.alpha', 0.001)
end

function onCreatePost()
	setProperty('isCameraOnForcedPos', true);
	setProperty('camFollow.x', 450);
	setProperty('camFollow.y', 500);
	setProperty('camera.target.x', 450);
	setProperty('camera.target.y', 500);
end

function onStepHit()
	if curStep == 1 then
		removeLuaSprite(trail)
		setProperty('isCameraOnForcedPos', false);
	end
	if curStep == 3072 then
		setProperty('camFollow.x', 250);
		setProperty('camFollow.y', 400);
		objectPlayAnimation('doogSaw', 'drop', true)
		setProperty('doogSaw.alpha', 1)
		characterPlayAnim('dad','prepunch',true)
		setProperty('dad.specialAnim', true)
		setProperty('dad.skipDance', true)
	end
	if curStep == 3078 then
		characterPlayAnim('dad','windUP',true)
		setProperty('dad.specialAnim', true)
	end
	if curStep == 3088 then
		characterPlayAnim('dad','punch',true)
		setProperty('dad.specialAnim', true)
		doTweenX('dad', 'dad', getProperty('dad.x') + 480, 0.3, 'circOut')
		setProperty('boyfriend.skipDance', true)
		setProperty('cameraSpeed', 3)
		setProperty('camFollow.x', 670);
		setProperty('camFollow.y', 500);
		setProperty('isCameraOnForcedPos', true);
		doTweenZoom('zoomcamera', 'camGame', 1.5, 0.2, 'circOut');
		setProperty('defaultCamZoom', 1.5);
	end
	if curStep == 3108 then
		--disable bop here
		characterPlayAnim('dad','punchAfter',true)
		setProperty('dad.specialAnim', true)
		characterPlayAnim('boyfriend','hey',true)
		setProperty('boyfriend.specialAnim', true)
		doTweenZoom('zoomcamera', 'camGame', 0.7, 1, 'circOut');
		setProperty('defaultCamZoom', 0.7);
	end
	
	-- Center camera stuff
	if curStep == 1564 or curStep == 2944 then
		setProperty('isCameraOnForcedPos', true);
		setProperty('camFollow.x', 450);
		setProperty('camFollow.y', 500);
	end
		
	if curStep == 1792 then 
		setProperty('isCameraOnForcedPos', false);
	end
end

function onTweenCompleted(tag, loops, loopsLeft)
	if tag == 'hueh' then
		
	end
end