function onCreate()
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'SpaceHurtNote' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', "hurt notes")
            setPropertyFromGroup('unspawnNotes', i, 'noteData', 4)
            setPropertyFromGroup('unspawnNotes', i, 'noMissAnimation', true)
            setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true)
            setPropertyFromGroup('unspawnNotes', i, 'mustPress', true)
            setPropertyFromGroup('unspawnNotes', i, 'noteSplashDisabled', true)
			setPropertyFromGroup('unspawnNotes', i, 'missHealth', 1.5)
			precacheSound('koroneswing2')
			if getPropertyFromGroup('unspawnNotes', i, 'isSustainNote') then
				runHaxeCode([[
                    var Note:Note=game.unspawnNotes[]]..i..[[];
                    Note.animation.addByPrefix('tail','red hold end');
                    Note.animation.addByPrefix('hold','red hold piece');
                    
                    if(Note.prevNote != null)
					{
                        Note.animation.play('tail',true);
                        if(Note.prevNote.isSustainNote)
                            Note.prevNote.animation.play('hold',true);
                    }
                ]])
				setPropertyFromGroup('unspawnNotes', i, 'offsetX', 60)
			else
				runHaxeCode([[
                    var Note:Note=game.unspawnNotes[]]..i..[[];
                    Note.animation.addByPrefix('middle', "middle", 24, true);
                    Note.animation.play('middle',true);
                ]])
				setPropertyFromGroup('unspawnNotes', i, 'offsetX', -50)
				setPropertyFromGroup('unspawnNotes', i, 'offsetY', -70)
			end
		end
	end
end

function goodNoteHit(membersIndex, noteData, noteType, isSustainNote)
	if noteData == 4 and noteType == 'SpaceHurtNote' and not isSustainNote then
		characterPlayAnim('boyfriend','dodge',true)
		setProperty('boyfriend.specialAnim', true)
		disableCharaAnims(true)
	end
end

function noteMiss(membersIndex, noteData, noteType, isSustainNote)
    if noteData == 4 and noteType == 'SpaceHurtNote' then
        characterPlayAnim('boyfriend','hurt',true)
		setProperty('boyfriend.specialAnim', true)
		disableCharaAnims(false)
    end
end

function disableCharaAnims(both)
	for notesLength = 0,getProperty('notes.length')-1 do
        if getPropertyFromGroup('notes', notesLength, 'noteType') == '' then
			if not both and getPropertyFromGroup('notes', notesLength, 'mustPress') == true then
				setPropertyFromGroup('notes', notesLength, 'noAnimation', true)
				setPropertyFromGroup('unspawnNotes', i, 'noMissAnimation', true)
				runTimer('reenableAnims',1)
			elseif both then
				setPropertyFromGroup('notes', notesLength, 'noAnimation', true)
				setPropertyFromGroup('unspawnNotes', i, 'noMissAnimation', true)
				runTimer('reenableAnims', 0.4)
			end
        end
    end
end

function onTimerCompleted(tag)
	if tag == 'reenableAnims' then
		for notesLength = 0,getProperty('notes.length')-1 do
			if getPropertyFromGroup('notes', notesLength, 'noteType') == '' then
				setPropertyFromGroup('notes', notesLength, 'noAnimation', false)
				setPropertyFromGroup('unspawnNotes', i, 'noMissAnimation', false)
			end
		end
	end
end