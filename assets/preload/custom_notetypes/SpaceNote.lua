function onCreate()
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'SpaceNote' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', "middle")
            setPropertyFromGroup('unspawnNotes', i, 'noteData', 4)
            setPropertyFromGroup('unspawnNotes', i, 'noMissAnimation', true)
            setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true)
            setPropertyFromGroup('unspawnNotes', i, 'mustPress', true)
            setPropertyFromGroup('unspawnNotes', i, 'noteSplashDisabled', true)
			if getPropertyFromGroup('unspawnNotes', i, 'isSustainNote') then
				setPropertyFromGroup('unspawnNotes', i, 'offsetX', 50)
			else
				setPropertyFromGroup('unspawnNotes', i, 'offsetX', 20)
			end
		end
	end
end

function onCreatePost()
	makeAnimatedLuaSprite('middleSplash', 'noteSplashes middle', 830, -30);
	
	if getPropertyFromClass('ClientPrefs', 'downScroll') then
		setProperty('middleSplash.y', 470)
	end
	
	setObjectCamera('middleSplash', 'hud')
	addAnimationByPrefix('middleSplash', 'splash', 'Splash Yellow', 24, false)
	objectPlayAnimation('middleSplash', 'splash', true)
	addLuaSprite('middleSplash', true);
	setProperty('middleSplash.alpha', 0.001)
end

function goodNoteHit(membersIndex, noteData, noteType, isSustainNote)
	if noteData == 4 and noteType == 'SpaceNote' then
		if not isSustainNote then
			setProperty('middleSplash.alpha', 1)
			objectPlayAnimation('middleSplash', 'splash', true)
		end
		characterPlayAnim('boyfriend','singMID',true)
		setProperty('boyfriend.specialAnim', true)
	end
end

function noteMiss(membersIndex, noteData, noteType, isSustainNote)
    if noteData == 4 and noteType == 'SpaceNote' then
		--Run miss anim here
        characterPlayAnim('boyfriend','singMIDmiss',true)
		setProperty('boyfriend.specialAnim', true)
    end
end
