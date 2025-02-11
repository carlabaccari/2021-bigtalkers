Class {
	#name : #Dice,
	#superclass : #Object,
	#instVars : [
		'dice'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #validation }
Dice class >> validate: someDice [

	self validateEmptyDiceCollection: someDice
]

{ #category : #validation }
Dice class >> validateEmptyDiceCollection: someDice [

	someDice isEmpty
		ifTrue: [ Error signal: 'Dice need to have at least one Die' ]
]

{ #category : #'instance creation' }
Dice class >> with: someDice [

	self validate: someDice.
	^ self new initializeWith: someDice
]

{ #category : #rolling }
Dice >> dice [

	^dice 
]

{ #category : #initialization }
Dice >> initializeWith: aDiceCollection [

	dice := aDiceCollection
]

{ #category : #rolling }
Dice >> roll [

	^ dice sum: [ :die | die roll ]
]
