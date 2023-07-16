function onCreatePost()
	CreateStrum()
end

local isEnabled = false

function CreateStrum()
    addHaxeLibrary('StrumNote')
    runHaxeCode([[
       var babyArrow:StrumNote= new StrumNote(ClientPrefs.middleScroll ? 565 : 885, game.strumLine.y - 20, 4, 1);
       babyArrow.frames= Paths.getSparrowAtlas("middle");
       babyArrow.animation.addByPrefix('static', 'arrow static');
       babyArrow.animation.addByPrefix('pressed', 'space press', 24, false);
       babyArrow.animation.addByPrefix('confirm', 'space confirm', 24, false);
       babyArrow.playAnim('static', true);
       
       game.playerStrums.add(babyArrow);
	   babyArrow.downScroll = ClientPrefs.downScroll;
	   game.strumLineNotes.add(babyArrow);
       setVar("middleStrum",babyArrow);
    ]])
	setProperty('middleStrum.alpha', 0.001)
end

function onUpdate(elapsed)
	if getProperty('generatedMusic') and not getProperty('inCutscene') then
		if not getProperty('cpuControlled') then
			spaceKey()
		end
		
		if getProperty('startedCountdown') then
			for daNote=0,getProperty('notes.length')-1 do
				local mustPress=getPropertyFromGroup('notes',daNote,'mustPress')
				local isSustain=getPropertyFromGroup('notes',daNote,'isSustainNote')
				local CanHit=getPropertyFromGroup('notes',daNote,'canBeHit')
				local Notedata=getPropertyFromGroup('notes',daNote,'noteData')
				local blockHit=getPropertyFromGroup('notes',daNote,'blockHit')
				local strumTime=getPropertyFromGroup('notes',daNote,'strumTime')
				local noteType=getPropertyFromGroup('notes',daNote,'noteType')
				
				if Notedata == 4 and not blockHit and mustPress and getProperty('cpuControlled') and CanHit then
					if isSustain then
						if CanHit then
							GoodSpaceHit(daNote, noteType, isSustain)	
						end
					elseif strumTime <= getProperty('Conductor.songPosition') or isSustain then
						GoodSpaceHit(daNote, noteType, isSustain)	
					end
				end
			end
		end
	end

	if keyReleased('space') and not getProperty('cpuControlled') then
		runHaxeCode('getVar("middleStrum").playAnim("static");')
		setProperty('middleStrum.resetAnim',0)
		characterDance('boyfriend')
	end
end

function spaceKey()
	if getProperty('startedCountdown') and not getProperty('boyfriend.stunned') and getProperty('generatedMusic') then
		for daNote=0,getProperty('notes.length')-1 do
			local mustPress=getPropertyFromGroup('notes',daNote,'mustPress')
			local isSustain=getPropertyFromGroup('notes',daNote,'isSustainNote')
			local wasGood=getPropertyFromGroup('notes',daNote,'wasGoodHit')
			local Late=getPropertyFromGroup('notes',daNote,'tooLate')
			local CanHit=getPropertyFromGroup('notes',daNote,'canBeHit')
			local Notedata=getPropertyFromGroup('notes',daNote,'noteData')
			local blockHit=getPropertyFromGroup('notes',daNote,'blockHit')
			local strumTime=getPropertyFromGroup('notes',daNote,'strumTime')
			local noteType=getPropertyFromGroup('notes',daNote,'noteType')
			
			if Notedata == 4 and not blockHit and isSustain and keyPressed('space') and CanHit and mustPress and not Late and not wasGood and not blockHit then
				GoodSpaceHit(daNote, noteType, isSustain)
			end
		end
	end
	spaceKeyPressed()
end

function spaceKeyPressed()
	if not getProperty('cpuControlled') and getProperty('startedCountdown') and not getProperty('paused') and isEnabled then
		if not getProperty('boyfriend.stunned') and getProperty('generatedMusic') and not getProperty('endingSong') then
			for daNote=0,getProperty('notes.length')-1 do
				local mustPress=getPropertyFromGroup('notes',daNote,'mustPress')
				local isSustain=getPropertyFromGroup('notes',daNote,'isSustainNote')
				local wasGood=getPropertyFromGroup('notes',daNote,'wasGoodHit')
				local Late=getPropertyFromGroup('notes',daNote,'tooLate')
				local CanHit=getPropertyFromGroup('notes',daNote,'canBeHit')
				local Notedata=getPropertyFromGroup('notes',daNote,'noteData')
				local blockHit=getPropertyFromGroup('notes',daNote,'blockHit')
				local strumTime=getPropertyFromGroup('notes',daNote,'strumTime')
				local noteType=getPropertyFromGroup('notes',daNote,'noteType')
				
				if keyJustPressed('space') and Notedata == 4 and not blockHit and CanHit and mustPress and not Late and not wasGood and not isSustain then
					GoodSpaceHit(daNote, noteType, isSustain)
				elseif keyJustPressed('space') then
					runHaxeCode('getVar("middleStrum").playAnim("pressed", true);')
					setProperty('middleStrum.resetAnim',0)
					if not getProperty('ClientPrefs.ghostTapping') and not isEnabled then
						playAnim('boyfriend','singMIDmiss',true)
						setProperty('boyfriend.specialAnim', true)
						setProperty('totalPlayed',getProperty('totalPlayed')+1)
						addScore(-10)
						addMisses(1)
					end
				end
			end
		end
	end
end

function GoodSpaceHit(NoteID, noteType, isSustain)
	callOnLuas('goodNoteHit',{NoteID,4,noteType,getPropertyFromGroup('notes',NoteID,'isSustainNote')},false,false)
	
	if not isSustain then
		runHaxeCode('getVar("middleStrum").playAnim("confirm");')
		setProperty('middleStrum.resetAnim',0)
	end

    setPropertyFromGroup('notes',NoteID,'wasGoodHit',true)
    if not getPropertyFromGroup('notes',NoteID,'isSustainNote') then
        runHaxeCode([[
            var note:Note=game.notes.members[]]..NoteID..[[];
			if (note.hitCausesMiss)
			{
				noteMiss(note);
			}
			else
			{
				game.combo += 1;
				if(game.combo > 9999) game.combo = 9999;
				game.popUpScore(note);
				note.kill();
				game.notes.remove(note, true);
				note.destroy();
			}
        ]])
    end
end

function onEvent(n,i,ii)
	if n == 'Toggle Space Mechanic' then
        if i == 'true' and not isEnabled then
			isEnabled = true;
			doTweenAlpha('middleStrum', 'middleStrum', 1, 0.5, 'circInOut')
			for i = 4, 5 do
				noteTweenX('funnynote'..i..'', i, getPropertyFromGroup('strumLineNotes', i, 'x') - 56, 0.5, 'circInOut')
			end
			for i = 6, 7 do
				noteTweenX('funnynote'..i..'', i, getPropertyFromGroup('strumLineNotes', i, 'x') + 56, 0.5, 'circInOut')
			end
        elseif i == 'false' and isEnabled then
			isEnabled = false;
			doTweenAlpha('middleStrum', 'middleStrum', 0, 0.5, 'circInOut')
			for i = 4, 5 do
				noteTweenX('funnynote'..i..'', i, getPropertyFromGroup('strumLineNotes', i, 'x') + 56, 0.5, 'circInOut')
			end
			for i = 6, 7 do
				noteTweenX('funnynote'..i..'', i, getPropertyFromGroup('strumLineNotes', i, 'x') - 56 , 0.5, 'circInOut')
			end
        end
    end
end