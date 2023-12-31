local Combo = 0;
local Judgement = "OOF"

local sickTrack = 0;
local goodTrack = 0;
local badTrack = 0;
local shitTrack = 0;

local Chaos = 0;

local X = 544;
local Y = 46;

function onCreate()
	precacheImage('comboGlows/comboGlow')
	precacheImage('comboGlows/comboGlowFail')
	precacheImage('comboGlows/comboGlowEvil')
	precacheImage('comboGlows/comboGlowFailEvil')
	
	if middlescroll and not downscroll then
		Y = Y + 155;
	elseif middlescroll and downscroll then
		Y = Y + 355;
	elseif downscroll then
		Y = Y + 520;
	end
	
	makeLuaSprite('Glow', 'comboGlows/comboGlow', X, Y)
	setObjectCamera('Glow', 'hud')
	setProperty('Glow.alpha', 0)
	addLuaSprite('Glow')

	makeLuaText('Judgement', Judgement, 200, X+1, Y+25)
	setTextAlignment('Judgement', 'center')
	setTextSize('Judgement', 46)
	setTextFont('Judgement', 'TRIGLE.TTF')
	setProperty('Judgement.alpha', 0)
	setObjectCamera('Judgement', 'hud')
	addLuaText('Judgement')

	makeLuaText('Combo', Combo, 200, X-4, Y+70)
	setTextAlignment('Combo', 'center')
	setTextSize('Combo', 46)
	setTextFont('Combo', 'TRIGLE.TTF')
	setProperty('Combo.alpha', 0)
	setObjectCamera('Combo', 'hud')
	addLuaText('Combo')
end

function onCreatePost()
	setBlendMode('Glow', 'ADD')
	setObjectOrder('Glow', getObjectOrder('Judgement')-1)
end

local Fail = 0;

local FakeCombo = 0;

local GetFakeCombo = 1;

function noteMiss(id, direction, noteType, isSustainNote)
	GetFakeCombo = 0;
	Chaos = 0;
	cancelTimer('JudgementFadeAway')
	cancelTimer('ChaosStop')
	cancelTween('ComboAlpha')
	cancelTween('JudgementAlpha')
	cancelTween('GlowAlpha')
	cancelTimer('FallApart')
	setTextString('Combo', getProperty('combo'))
	setTextString('Judgement', Judgement)
	setProperty('Combo.alpha', 1)
	setProperty('Judgement.alpha', 1)
	setProperty('Glow.alpha', 0.3)
	runTimer('FallApart', 0.3)
end

function goodNoteHit(note, direction, type, sus)
	if not sus then
		Chaos = 0;
		cancelTimer('JudgementFadeAway')
		cancelTimer('ChaosStop')
		cancelTween('ComboAlpha')
		cancelTween('JudgementAlpha')
		cancelTween('GlowAlpha')
	
		if GetFakeCombo == 1 then
			FakeCombo = getProperty('combo');
		end
		setProperty('Combo.alpha', 1)
		setProperty('Judgement.alpha', 1)
		setProperty('Glow.alpha', 0.3)
		runTimer('JudgementFadeAway', 0.5)
	end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
	if sickTrack < getProperty('sicks') then
		sickTrack = sickTrack + 1;
		Judgement = "SICK!"
	end
	
	if goodTrack < getProperty('goods') then
		goodTrack = goodTrack + 1;
		Judgement = "GOOD"
	end
	if badTrack < getProperty('bads') then
		badTrack = badTrack + 1;
		Judgement = "BAD"
	end
	if shitTrack < getProperty('shits') then
		shitTrack = shitTrack + 1;
		Judgement = "CRAP"
	end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
	if Chaos == 0 then
		setTextString('Combo', getProperty('combo'))
		setTextString('Judgement', Judgement)
	end
end

function onUpdate(elapsed)
	if Chaos == 1 then
		setTextString('Combo', getRandomInt(0, getProperty('combo')))
		ChaosString = string.char(getRandomInt(65,90))..string.char(getRandomInt(65,90))..string.char(getRandomInt(65,90))..string.char(getRandomInt(65,90))
		setTextString('Judgement', ChaosString)
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'JudgementFadeAway' then
		Chaos = 1;
		doTweenAlpha('JudgementAlpha', 'Judgement', 0, 0.8, 'linear')
		doTweenAlpha('ComboAlpha', 'Combo', 0, 0.8, 'linear')
		doTweenAlpha('GlowAlpha', 'Glow', 0, 0.8, 'linear')
		runTimer('ChaosStop', 0.81)
	end
	
	if tag == 'ChaosStop' then
		Chaos = 0;
	end
	
	if tag == 'FallApart' then
		GetFakeCombo = 1;
		setProperty('Combo.alpha', 0)
		setProperty('Judgement.alpha', 0)
		setProperty('Glow.alpha', 0)
		runTimer('JudgementFadeAway', 0.5)
		
		Fail = Fail + 1;

		makeLuaText('JudgementFail'..Fail, Judgement, 200, getProperty('Judgement.x'), getProperty('Judgement.y'))
		setTextAlignment('JudgementFail'..Fail, 'center')
		setTextSize('JudgementFail'..Fail, 46)
		setTextFont('JudgementFail'..Fail, 'TRIGLE.TTF')
		setObjectCamera('JudgementFail'..Fail, 'hud')
		addLuaText('JudgementFail'..Fail)
		
		makeLuaText('ComboFail'..Fail, FakeCombo, 200, getProperty('Combo.x'), getProperty('Combo.y'))
		setTextAlignment('ComboFail'..Fail, 'center')
		setTextSize('ComboFail'..Fail, 46)	
		setObjectCamera('ComboFail'..Fail, 'hud')
		addLuaText('ComboFail'..Fail)
		setTextFont('ComboFail'..Fail, 'TRIGLE.TTF')
		
		makeLuaSprite('GlowFail'..Fail, 'comboGlows/comboGlowFail', getProperty('Glow.x'), getProperty('Glow.y'))
		setObjectCamera('GlowFail'..Fail, 'hud')
		
		addLuaSprite('GlowFail'..Fail, true)
		doTweenY('JudgementFailY'..Fail, 'JudgementFail'..Fail, 800, 1.5, 'backIn')
		doTweenY('ComboFailY'..Fail, 'ComboFail'..Fail, 800, 1.5, 'backIn')
		doTweenX('JudgementFailX'..Fail, 'JudgementFail'..Fail, getProperty('JudgementFail'..Fail..'.x') + getRandomInt(-200, 200), 2, 'sineInOut')
		doTweenX('ComboFailX'..Fail, 'ComboFail'..Fail, getProperty('ComboFail'..Fail..'.x') + getRandomInt(-200, 200), 2, 'sineInOut')
		doTweenAngle('JudgementFailAngle'..Fail, 'JudgementFail'..Fail, getRandomInt(-700, 700)/10, 2, 'sineInOut')
		doTweenAngle('ComboFailAngle'..Fail, 'ComboFail'..Fail, getRandomInt(-700, 700)/10*-1, 2, 'sineInOut')
		doTweenAlpha('GlowFailFade'..Fail, 'GlowFail'..Fail, 0, 1, 'linear')
		
		runTimer('ClearRam', 2.05)
	end
	
	if tag == 'ClearRam' then
		removeLuaText('JudgementFail'..Fail, true)
	end
end