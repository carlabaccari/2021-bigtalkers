Class {
	#name : #BigTalkGame,
	#superclass : #Object,
	#instVars : [
		'players',
		'dice',
		'board',
		'scoreboard',
		'turn',
		'currentPlayer',
		'finishingLap',
		'activeCards',
		'lastCardUsed',
		'lastEffect',
		'deck',
		'playersInJail',
		'slotsWithTemporaryEffects'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
BigTalkGame class >> playedBy: somePlayers usingDice: someDice playedOn: aBoard finishingAtLap: aLapNumber [

	self validate: somePlayers.
	^ self new
		initializeWithPlayers: somePlayers
		withDice: someDice
		withBoard: aBoard
		finishingAtLap: aLapNumber
		withDeck: Deck default 
]

{ #category : #'instance creation' }
BigTalkGame class >> playedBy: somePlayers usingDice: someDice playedOn: aBoard finishingAtLap: aLapNumber usingDeck: aDeck [

	self validate: somePlayers.
	^ self new
		initializeWithPlayers: somePlayers
		withDice: someDice
		withBoard: aBoard
		finishingAtLap: aLapNumber
		withDeck: aDeck
]

{ #category : #validation }
BigTalkGame class >> validate: somePlayers [

	self validateNoPlayers: somePlayers.
	self validateDuplicatePlayers: somePlayers
]

{ #category : #validation }
BigTalkGame class >> validateDuplicatePlayers: somePlayers [

	| somePlayersNames |
	somePlayersNames := Set
		withAll: (somePlayers collect: [ :player | player playerName ]).
	somePlayers size ~= somePlayersNames size
		ifTrue: [ Error signal: 'There can not be two players with the same name' ]
]

{ #category : #validation }
BigTalkGame class >> validateNoPlayers: somePlayers [

	somePlayers isEmpty
		ifTrue: [ Error signal: 'You need at least one player to play' ]
]

{ #category : #'playing - card usage' }
BigTalkGame >> accelerationCardUsedBy: aPlayer [ 

self player: aPlayer usesCard: Acceleration new  on: players.
]

{ #category : #'accessing - game' }
BigTalkGame >> activeCardStack [

	^ activeCards 
]

{ #category : #private }
BigTalkGame >> addActiveCard: aCard on: target [

	target isCollection
		ifTrue: [ target do: [ :player | activeCards add: aCard to: player ] ]
		ifFalse: [ activeCards add: aCard to: target ]
]

{ #category : #'accessing - game' }
BigTalkGame >> addEffectTo: aSlot [

	
]

{ #category : #'effect-application' }
BigTalkGame >> applyAtomicBombTo: aPlayer [

	players do: [ :player | self playerMoveToStart: player ]
]

{ #category : #'effect-application' }
BigTalkGame >> applyCurrentEffect [

	^ board applyEffectTo: self toPlayer: self currentTurnPlayer
]

{ #category : #'effect-application' }
BigTalkGame >> applyGrabCardTo: aPlayer [

	self drawFromDeck: aPlayer
]

{ #category : #'effect-application' }
BigTalkGame >> applyJailTo: aPlayer [

	playersInJail add: aPlayer 
]

{ #category : #'effect-application' }
BigTalkGame >> applyLastCardTo: target [

	lastCardUsed applyOn: self to: target
]

{ #category : #'effect-application' }
BigTalkGame >> applyLastEffectTo: target [

	lastEffect applyTo: self triggeredBy: target
]

{ #category : #'effect-application' }
BigTalkGame >> applyMoonWalk: steps toPlayer: target [

	self playerMove: target slots: steps.
	players do: [ :player | self playerMove: player slots: steps * -1 ]
]

{ #category : #'effect-application' }
BigTalkGame >> applySpeedPlusToASlotFrom: aPlayer [

	| speedPlusCard currentPosition |
	speedPlusCard := SpeedPlus new.
	currentPosition := self currentSlotOf: aPlayer.
	self validateTemporaryEffectApplication: currentPosition.
	(board slotAt: currentPosition) addTemporaryEffect: speedPlusCard temporaryEffect.
	slotsWithTemporaryEffects add: currentPosition 
	

	
]

{ #category : #'effect-application' }
BigTalkGame >> applySpeedUpTo: aPlayer [

	self playerMove: aPlayer slots: 4
]

{ #category : #'effect-application' }
BigTalkGame >> applyTemporaryEffectTo: aPlayer [
	
	
	| currentPosition  |
	currentPosition := self currentSlotOf: aPlayer.
	(currentPosition  = 0) ifFalse: [self playerMove: aPlayer slots: (board slotAt: currentPosition) temporaryEffects ]
	

]

{ #category : #'effect-application' }
BigTalkGame >> applyWormHoleTo: aPlayer [

	self playerMove: aPlayer slots: -4
]

{ #category : #'private - validations' }
BigTalkGame >> assertGameIsNotFinished [

	self hasFinished ifTrue: [ Error signal: 'The game has finished' ]
]

{ #category : #'private - validations' }
BigTalkGame >> assertPlayerGotTheHighestScore: rollValue [

	| highestScore  diceCollection |
	diceCollection := dice dice.
	highestScore := diceCollection sum: [ :die | die sides ].
	(highestScore = rollValue ) ifTrue:  [ self removeFromJail: self currentTurnPlayer  ] ifFalse:  [ Error signal: 'The player is in jail']
]

{ #category : #'private - validations' }
BigTalkGame >> assertPlayerIsNotInJail: aPlayer withRollValue: aRollValue [


	( self isInJail: aPlayer )   ifTrue: [ self assertPlayerGotTheHighestScore: aRollValue  ]

	
	

]

{ #category : #'playing - card usage' }
BigTalkGame >> cancellationCardUsedBy: aPlayer targetting: target removing: aCancelledCard [ 

self player: aPlayer usesCard: Cancellation new  on: {aCancelledCard.target}.
]

{ #category : #playing }
BigTalkGame >> changeTurn [

	turn nextPut: currentPlayer.
	currentPlayer := turn next
]

{ #category : #'accesing - player' }
BigTalkGame >> currentLapOf: aPlayer [

	^ board currentLapOf: aPlayer
]

{ #category : #'accesing - player' }
BigTalkGame >> currentSlotOf: aPlayer [

	^ board currentSlotOf: aPlayer
]

{ #category : #'accesing - player' }
BigTalkGame >> currentTurnPlayer [

	^ currentPlayer
]

{ #category : #playing }
BigTalkGame >> drawFromDeck: aPlayer [

	aPlayer drawCardFrom: deck
]

{ #category : #'accessing - finishing' }
BigTalkGame >> hasFinished [

	^ self leaderLap >= finishingLap
]

{ #category : #initialization }
BigTalkGame >> initializeWithPlayers: somePlayers withDice: someDice withBoard: aBoard finishingAtLap: aLapNumber withDeck: aDeck [

	finishingLap := aLapNumber.
	players := somePlayers.
	dice := someDice.
	board := aBoard.
	board addPlayers: somePlayers.
	deck := aDeck.
	self playersDrawStartingCards.
	activeCards := ActiveCardController forPlayers: somePlayers.
	lastEffect := NoEffect new.
	scoreboard := Scoreboard competingPlayers: somePlayers.
	scoreboard update: board playerPositions.
	turn := SharedQueue new.
	turn nextPutAll: players.
	currentPlayer := turn next.
	playersInJail := OrderedCollection new.
	slotsWithTemporaryEffects := OrderedCollection new.
]

{ #category : #'accesing - player' }
BigTalkGame >> isInJail: aPlayer [

	^ (playersInJail includes: aPlayer)


 

]

{ #category : #'accessing - leader' }
BigTalkGame >> leader [

	^ scoreboard leader key
]

{ #category : #'accessing - leader' }
BigTalkGame >> leaderLap [

	^ scoreboard leaderLap
]

{ #category : #'accessing - leader' }
BigTalkGame >> leaderPosition [

	^ scoreboard leaderPosition
]

{ #category : #'playing - card usage' }
BigTalkGame >> libertyCardUsedBy: aPlayer targetting: target [

self player: aPlayer usesCard: Liberty new  on: target.
]

{ #category : #playing }
BigTalkGame >> moveCurrentPlayer [

	self assertGameIsNotFinished.
	"self assertPlayerIsNotInJail: self currentTurnPlayer. "
	self playerMoveAfterRoll: self currentTurnPlayer.
	lastEffect := self applyCurrentEffect.
	self applyTemporaryEffectTo: self currentTurnPlayer.
	self changeTurn.
	scoreboard update: board playerPositions
]

{ #category : #'playing - card usage' }
BigTalkGame >> overloadCardUsedBy: aPlayer targetting: target [

self player: aPlayer usesCard: Overload new  on: target.
]

{ #category : #private }
BigTalkGame >> player: aPlayer usesCard: aCard on: target [

	self validatePlayabilityOn: aCard by: aPlayer affecting: target.
	aPlayer useCardFromHand: aCard.
	aCard applyOn: self to: target.
	aCard = Redo new
		ifFalse: [ lastCardUsed := aCard ]
]

{ #category : #private }
BigTalkGame >> playerMove: aPlayer slots: aNumberOfSlots [

	board movePlayer: aPlayer to: aNumberOfSlots
]

{ #category : #private }
BigTalkGame >> playerMoveAfterRoll: aPlayer [

	| rollvalue modifier finalRollValue |
	modifier := activeCards playerRollModifier: aPlayer.
	rollvalue := dice roll.
	self assertPlayerIsNotInJail: self currentTurnPlayer withRollValue: rollvalue.
	finalRollValue := rollvalue + modifier.
	board movePlayer: aPlayer to: finalRollValue 
]

{ #category : #private }
BigTalkGame >> playerMoveToStart: aPlayer [

	board moveToStart: aPlayer
]

{ #category : #private }
BigTalkGame >> playersDrawStartingCards [

	players
		do: [ :player | 
			player drawCardFrom: deck.
			player drawCardFrom: deck ]
]

{ #category : #'accesing - player' }
BigTalkGame >> rankOf: aPlayer [

	^ scoreboard rankOf: aPlayer
]

{ #category : #'playing - card usage' }
BigTalkGame >> redoCardUsedBy: aPlayer [

self player: aPlayer usesCard: Redo new  on: players.
]

{ #category : #'playing - card usage' }
BigTalkGame >> redoCardUsedBy: aPlayer targetting: target [

self player: aPlayer usesCard: Redo new  on: target.
]

{ #category : #'effect-application' }
BigTalkGame >> removeActiveCard: aCard from: target [

	| slotToRemoveEffect |
	activeCards remove: aCard from: target.
	aCard = SpeedPlus new ifTrue: [ 
		slotToRemoveEffect := slotsWithTemporaryEffects at: 1.
		(board slotAt: slotToRemoveEffect) addTemporaryEffect: 0.
		slotsWithTemporaryEffects remove: slotToRemoveEffect ]
]

{ #category : #'effect-application' }
BigTalkGame >> removeFromJail: aPlayer [

	playersInJail remove: aPlayer 
]

{ #category : #'playing - card usage' }
BigTalkGame >> repeatCardUsedBy: aPlayer targetting: target [

self player: aPlayer usesCard: Repeat new  on: target.
]

{ #category : #'playing - card usage' }
BigTalkGame >> speedCardUsedBy: aPlayer targetting: target [

self player: aPlayer usesCard: Speed new  on: target.
]

{ #category : #'playing - card usage' }
BigTalkGame >> speedPlusCardUsedBy: aPlayer [ 

self player: aPlayer usesCard: SpeedPlus new on: aPlayer.
]

{ #category : #'private - validations' }
BigTalkGame >> validatePlayabilityOn: aCard by: aPlayer affecting: target [

	aCard playableBy: aPlayer on: self affecting: target 
]

{ #category : #'private - validations' }
BigTalkGame >> validateTemporaryEffectApplication: aPosition [

	 ( aPosition = 0 ) ifTrue: [ Error signal: 'Players must be in a slot to play SpeedPlus card' ]
	

	
]
