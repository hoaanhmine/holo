function onCreate()
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'DoogHurtNote' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', "hurt notes")
            setPropertyFromGroup('unspawnNotes', i, 'noMissAnimation', true)
            setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true)
            setPropertyFromGroup('unspawnNotes', i, 'mustPress', true)
            setPropertyFromGroup('unspawnNotes', i, 'noteSplashDisabled', true)
			setPropertyFromGroup('unspawnNotes', i, 'missHealth', 0.5)
			precacheSound('koroneswing2')
			--Fixes animations not animating
			runHaxeCode([[
				var Note:Note=game.unspawnNotes[]]..i..[[];
				Note.animation.addByPrefix('redScroll', 'red0', 24, true);
				Note.animation.addByPrefix('blueScroll', 'blue0', 24, true);
				Note.animation.addByPrefix('purpleScroll', 'purple0', 24, true);
				Note.animation.addByPrefix('greenScroll', 'green0', 24, true);
			]])
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
			else
				setPropertyFromGroup('unspawnNotes', i, 'offsetX', -70)
				setPropertyFromGroup('unspawnNotes', i, 'offsetY', -70)
			end
		end
	end
end

function goodNoteHit(membersIndex, noteData, noteType, isSustainNote)
	if noteType == 'DoogHurtNote' then
		characterPlayAnim('boyfriend','dodge',true)
		setProperty('boyfriend.specialAnim', true)
		
		playSound('koroneswing2', 0.5)
		characterPlayAnim('dad','attack',true)
		setProperty('dad.specialAnim', true)
		disableCharaAnims(true)
	end
end

function noteMiss(membersIndex, noteData, noteType, isSustainNote)
	--play hurt sound
	if noteType == 'DoogHurtNote' then
		playAnim('boyfriend','hurt',true)
		setProperty('boyfriend.specialAnim', true)
		
		playSound('koroneswing2', 0.5)
		characterPlayAnim('dad','attack',true)
		setProperty('dad.specialAnim', true)
		disableCharaAnims(true)
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
