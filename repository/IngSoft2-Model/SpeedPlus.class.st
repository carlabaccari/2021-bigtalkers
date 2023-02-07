Class {
	#name : #SpeedPlus,
	#superclass : #Permanent,
	#category : #'IngSoft2-Model'
}

{ #category : #'private - validations' }
SpeedPlus >> applyOn: aGame to: target [

	aGame applySpeedUpToASlotFrom: target
	
	
]

{ #category : #accessing }
SpeedPlus >> effect [

	^ 4
]

{ #category : #'private - validations' }
SpeedPlus >> playableBy: aPlayer on: aGame affecting: target [

	aGame currentTurnPlayer  ~= aPlayer ifTrue: [ Error
				signal: 'Players can only play permanent cards during their turn' ].
]
